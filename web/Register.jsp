<%-- 
    Document   : Register
    Updated    : 19 Sept 2025
    Author     : Ziyad
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #83a4d4, #b6fbff);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background: #fff;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            width: 350px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        input {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            margin-top: 5px;
            font-size: 14px;
        }
        .btn {
            width: 100%;
            background: #4CAF50;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
        }
        .btn:hover {
            background: #45a049;
        }
        .message {
            text-align: center;
            margin-bottom: 15px;
            padding: 10px;
            border-radius: 8px;
        }
        .error {
            background: #ffcccc;
            color: #cc0000;
        }
        .success {
            background: #d4edda;
            color: #155724;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Register</h2>

        <!-- Show messages from servlet -->
        <%
            String errorMsg = (String) request.getAttribute("errorMsg");
            String successMsg = (String) request.getAttribute("successMsg");
            if (errorMsg != null) {
        %>
            <div class="message error"><%= errorMsg %></div>
        <% } else if (successMsg != null) { %>
            <div class="message success"><%= successMsg %></div>
        <% } %>

        <form action="Register" method="post">
            <div class="form-group">
                <label>Name:</label>
                <input type="text" name="name">
            </div>

            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email">
            </div>

            <div class="form-group">
                <label>Phone:</label>
                <input type="text" name="phone">
            </div>

            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password">
            </div>

            <button type="submit" class="btn">Register</button>
        </form>

        <p style="text-align:center; margin-top:10px;">
            Already have an account? <a href="Login.jsp">Login</a>
        </p>
    </div>
</body>
</html>
