<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("AdminLogin.jsp"); // redirect if not admin
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | AKHADA GYM</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body, html {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            height: 100%;
            background: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .dashboard {
            background: #ffffff;
            padding: 35px 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
            width: 90%;
            max-width: 400px;
        }

        .dashboard h1 {
            font-size: 28px;
            margin-bottom: 10px;
            color: #333;
        }

        .dashboard p {
            font-size: 16px;
            color: #666;
            margin-bottom: 25px;
        }

        .btn-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .btn {
            background: #00796b; /* subtle teal */
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.3s;
        }

        .btn:hover {
            background: #005a4d;
        }

        @media (max-width: 480px) {
            .dashboard h1 {
                font-size: 24px;
            }
            .dashboard p {
                font-size: 14px;
            }
            .btn {
                font-size: 15px;
                padding: 10px;
            }
        }
    </style>
</head>
<body>
<%
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("adminName") == null) {
        response.sendRedirect("AdminLogin.jsp");
        return;
    }
    String adminName = (String) session1.getAttribute("adminName");
%>

<div class="dashboard">
    <h1>Welcome, <%= adminName %> 👋</h1>
    <p>Manage your gym quickly and easily.</p>

    <div class="btn-container">
        <a href="viewmembers.jsp" class="btn">View Members</a>
        <a href="logout.jsp" class="btn">Logout</a>
    </div>
</div>
</body>
</html>
