<%-- 
    Document   : viewmembers
    Created on : 13 Sept 2025, 1:40:48 pm
    Author     : ziyad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("Login.jsp"); // redirect if not admin
        return;
    }
%>
<%
    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/gym_management?useSSL=false", 
            "root", 
            "password@mysql"
        );
        stmt = con.createStatement();
        rs = stmt.executeQuery("SELECT * FROM members");
%>

<html>
<head>
    <title>Admin Dashboard - Members</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        h1 {
            text-align: center;
            color: #333;
            margin: 20px 0;
        }
        table {
            width: 95%;
            margin: 20px auto;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
            font-size: 14px;
        }
        th {
            background: #555;
            color: white;
        }
        tr:hover {
            background-color: #f0f0f0;
        }
        button {
            padding: 10px 14px;
            margin: 3px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
        }
        .delete-btn {
            background: #e53935;
            color: white;
        }
        .message-btn {
            background: #43a047;
            color: white;
        }
        .back-btn {
            background: #555;
            color: white;
            display: block;
            margin: 20px auto;
            padding: 12px 18px;
            border-radius: 6px;
            font-size: 14px;
        }
        .back-btn:hover {
            background: #333;
        }
        /* Responsive for small screens */
        @media (max-width: 600px) {
            th, td {
                font-size: 12px;
                padding: 8px;
            }
            button {
                padding: 8px 10px;
                font-size: 12px;
            }
            table {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <h1>Manage Members</h1>
    <table>
        <tr>
            <th>Member ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Password</th>
            <th>Join Date</th>
            <th>Action</th>
        </tr>
        <%
            while(rs.next()){
        %>
        <tr>
            <td><%= rs.getString("member_id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("phone") %></td>
            <td><%= rs.getString("password") %></td>
            <td><%= rs.getString("join_date") %></td>
            <td>
                <form action="DeleteMember" method="post" style="display:inline;">
                    <input type="hidden" name="member_id" value="<%= rs.getString("member_id") %>">
                    <button type="submit" class="delete-btn">Delete</button>
                </form>
                <form action="SendMessage.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="memberId" value="<%= rs.getString("member_id") %>">
                    <button type="submit" class="message-btn">Send Message</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>

    <!-- Back button -->
    <button class="back-btn" onclick="window.location.href='AdminDashboard.jsp'">Back to Dashboard</button>

</body>
</html>

<%
    } catch(Exception e){
        out.println("Error: " + e.getMessage());
    } finally {
        if(rs!=null) rs.close();
        if(stmt!=null) stmt.close();
        if(con!=null) con.close();
    }
%>
