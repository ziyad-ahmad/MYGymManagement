<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
//    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
//    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
//    response.setDateHeader("Expires", 0); // Proxies


    if (session == null || !"member".equals(session.getAttribute("role"))) {
        response.sendRedirect("Login.jsp"); // redirect if not a member
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Member Profile | Akhada Gym</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: url('https://images.pexels.com/photos/3289711/pexels-photo-3289711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1') no-repeat center center fixed;
                background-size: cover;
                min-height: 100vh;
            }
            .profile-container {
                max-width: 500px;
                margin: 80px auto;
                background: rgba(0, 0, 0, 0.75);
                padding: 35px 25px;
                border-radius: 20px;
                box-shadow: 0 8px 25px rgba(0,0,0,0.6);
                color: #fff;
            }
            h2 {
                text-align: center;
                font-weight: 700;
                color: #ff4c29;
                margin-bottom: 25px;
            }
            h3 {
                font-size: 20px;
                font-weight: 600;
                color: #ff4c29;
            }
            .detail {
                font-size: 16px;
                padding: 12px 15px;
                margin-bottom: 12px;
                background: rgba(255,255,255,0.1);
                border-left: 5px solid #ff4c29;
                border-radius: 10px;
            }
            .btn-row {
                display: flex;
                justify-content: space-between;
                margin-top: 20px;
                gap: 10px;
            }
            .btn-custom {
                flex: 1;
                padding: 12px 0;
                border-radius: 12px;
                font-weight: 600;
                color: #fff;
                text-align: center;
                text-decoration: none;
                transition: all 0.3s;
            }
            .btn-edit {
                background: #ff4c29;
            }
            .btn-edit:hover {
                background: #e63e1f;
            }
            .btn-logout {
                background: #1f1f1f;
                border: 1px solid #ff4c29;
            }
            .btn-logout:hover {
                background: #333;
            }
            .messages-box {
                max-height: 200px;
                overflow-y: auto;
                margin-top: 10px;
            }
            @media (max-width: 480px) {
                .btn-row {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <%
            String email = (String) session.getAttribute("email");
            String memberId = "", name = "", phone = "", joinDate = "";
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/gym_management?useSSL=false", "root", "password@mysql");
                PreparedStatement ps = con.prepareStatement("SELECT * FROM members WHERE email=?");
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    memberId = rs.getString("member_id");
                    name = rs.getString("name");
                    phone = rs.getString("phone");
                    joinDate = rs.getString("join_date");
                }
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>

        <div class="profile-container">
            <h2>🏋️ Member Profile</h2>

            <!-- Member Info (Safe with c:out) -->
            <div class="detail"><b>Member ID:</b> <c:out value="<%= memberId%>" /></div>
            <div class="detail"><b>Name:</b> <c:out value="<%= name%>" /></div>
            <div class="detail"><b>Email:</b> <c:out value="<%= email%>" /></div>
            <div class="detail"><b>Phone:</b> <c:out value="<%= phone%>" /></div>
            <div class="detail"><b>Join Date:</b> <c:out value="<%= joinDate%>" /></div>

            <!-- Admin Messages (Safe from XSS) -->
            <h3>📩 Messages from Admin</h3>
            <div class="messages-box">
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/gym_management?useSSL=false", "root", "password@mysql");

                        PreparedStatement psMsg = con.prepareStatement(
                                "SELECT message_text, sent_at FROM messages WHERE member_id=? ORDER BY sent_at DESC"
                        );
                        psMsg.setString(1, memberId);
                        ResultSet rsMsg = psMsg.executeQuery();

                        if (!rsMsg.isBeforeFirst()) {
                %>
                <div class="detail">No messages yet.</div>
                <%
                } else {
                    while (rsMsg.next()) {
                %>
                <div class="detail">
                    <b><c:out value="<%= rsMsg.getTimestamp("sent_at")%>" />:</b> 
                    <c:out value="<%= rsMsg.getString("message_text")%>" />
                </div>
                <%
                        }
                    }
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                %>
                <div class="detail">⚠️ Error loading messages.</div>
                <%
                    }
                %>
            </div>

            <!-- Buttons -->
            <div class="btn-row">
                <a href="editprofile.jsp" class="btn-custom btn-edit">✏️ Edit Profile</a>
                <a href="logout.jsp" class="btn-custom btn-logout">🚪 Logout</a>
            </div>
        </div>
    </body>
</html>
