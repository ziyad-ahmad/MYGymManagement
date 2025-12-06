<%-- 
    Document   : SendMessage
    Created on : 16 Sept 2025, 12:37:32 pm
    Author     : ziyad
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("Login.jsp"); // redirect if not admin
        return;
    }

    String memberId = request.getParameter("memberId");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Send Message to Member</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f4f4;
                padding: 20px;
            }
            .form-container {
                background: white;
                padding: 20px;
                border-radius: 8px;
                max-width: 600px;
                margin: auto;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }
            textarea {
                width: 100%;
                height: 120px;
                padding: 10px;
                font-size: 14px;
                border-radius: 6px;
                border: 1px solid #ccc;
                margin-bottom: 15px;
            }
            .buttons {
                display: flex;
                justify-content: space-between;
            }
            button {
                background: #00796b;
                color: white;
                border: none;
                padding: 10px 16px;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
            }
            button:hover {
                background: #005a4d;
            }
            .back-btn {
                background: #888;
            }
            .back-btn:hover {
                background: #555;
            }
            .history {
                margin-top: 25px;
                padding: 15px;
                background: #fafafa;
                border-radius: 6px;
                border: 1px solid #ddd;
                max-height: 250px;
                overflow-y: auto;
            }
            .message {
                padding: 8px 10px;
                margin-bottom: 10px;
                border-bottom: 1px solid #eee;
            }
            .message strong {
                color: #00796b;
            }
        </style>
    </head>
    <body>
        <div class="form-container">
            <h2>Send Message</h2>
            <form action="sendmessage" method="post">
                <!-- hidden field to know which member -->
                <input type="hidden" name="memberId" value="<%= memberId%>">
                <textarea name="messageText" placeholder="Write your message..." required></textarea>

                <div class="buttons">
                    <button type="submit">Send</button>
                    <!-- Back button -->
                    <button type="button" class="back-btn" onclick="window.location.href = 'viewmembers.jsp'">Back</button>
                </div>
            </form>

            <!-- Message History Section -->
            <div class="history">
                <h3>Message History</h3>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/gym_management?useSSL=false",
                                "root",
                                "password@mysql"
                        );
                        ps = con.prepareStatement("SELECT message_text, sent_at FROM messages WHERE member_id=? ORDER BY sent_at DESC");
                        ps.setString(1, memberId);
                        rs = ps.executeQuery();

                        boolean hasMessages = false;
                        while (rs.next()) {
                            hasMessages = true;
                %>
                <%
                    java.sql.Timestamp ts = rs.getTimestamp("sent_at");
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd-MM-yyyy hh:mm a");
                    // Example: 19-09-2025 02:35 PM
                    String formattedTime = sdf.format(ts);
                %>
                <div class="message">
                    <strong><%= formattedTime%>:</strong> 
                    <%= rs.getString("message_text")%>
                </div>

                <%
                    }
                    if (!hasMessages) {
                %>
                <p>No messages sent yet.</p>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) {
                            rs.close();
                        }
                        if (ps != null) {
                            ps.close();
                        }
                        if (con != null) {
                            con.close();
                        }
                    }
                %>
            </div>
        </div>
    </body>
</html>
