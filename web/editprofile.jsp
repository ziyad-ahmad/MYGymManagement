<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("member_id") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String memberId = (String) session1.getAttribute("member_id");

    // Initialize variables
    String name = "", phone = "", password = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/gym_management?useSSL=false",
                "root",
                "password@mysql"
        );

        PreparedStatement ps = con.prepareStatement(
                "SELECT name, phone, password FROM members WHERE member_id=?"
        );
        ps.setString(1, memberId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            phone = rs.getString("phone");
            password = rs.getString("password");
        }
        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("Database error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #eef2f3, #ffffff);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .edit-container {
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 6px 12px rgba(0,0,0,0.2);
            width: 400px;
        }
        h2 { text-align: center; color: #00796b; }
        input {
            width: 95%;
            padding: 10px;
            margin: 8px 0;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        .btn {
            width: 100%;
            padding: 12px;
            background-color: #00796b;
            border: none;
            border-radius: 6px;
            color: #fff;
            font-size: 16px;
            cursor: pointer;
        }
        .btn:hover { background-color: #004d40; }
        .back-btn {
            width: 100%;
            padding: 12px;
            background-color: #9e9e9e;
            border: none;
            border-radius: 6px;
            color: #fff;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }
        .back-btn:hover { background-color: #616161; }
    </style>
</head>
<body>
<div class="edit-container">
    <h2>Edit Profile</h2>
    <p>You can only edit your Name, Phone, and Password.</p>
    
    <form action="EditServ" method="post">
        <input type="hidden" name="member_id" value="<%= memberId %>">

        <label>Name</label>
        <input type="text" name="name" value="<%= name %>" placeholder="Enter your Name">

        <label>Phone</label>
        <input type="text" name="phone" value="<%= phone %>" placeholder="Enter your Phone">

        <label>Password</label>
        <input type="password" name="password" value="" placeholder="Enter new Password (leave blank to keep old)">

        <button type="submit" class="btn">Update Profile</button>
    </form>

    <form action="Profile.jsp" method="get">
        <button type="submit" class="back-btn">Back</button>
    </form>
</div>
</body>
</html>
