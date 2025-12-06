<%-- 
    Document   : Login
    Created on : 6 Sept 2025, 11:27:52 am
    Author     : Ziyad
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gym Member Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #e0f7fa, #b2ebf2);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-container {
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 6px 12px rgba(0,0,0,0.2);
            text-align: center;
            width: 350px;
        }
        .login-container h2 {
            margin-bottom: 20px;
            color: #00796b;
        }
        .login-container input {
            width: 90%;
            padding: 12px;
            margin: 10px 0;
            border-radius: 8px;
            border: 1px solid #ccc;
        }
        .login-container button {
            width: 95%;
            padding: 12px;
            background-color: #00796b;
            border: none;
            border-radius: 8px;
            color: #fff;
            font-size: 16px;
            cursor: pointer;
        }
        .login-container button:hover {
            background-color: #004d40;
        }
        .login-container a {
            display: block;
            margin-top: 15px;
            text-decoration: none;
            color: #00796b;
        }
        .login-container a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h2>Member Login</h2>
    <form action="Login" method="post">
        <% 
           String errorMsg = (String) request.getAttribute("errorMsg");
           if (errorMsg != null) {
        %>
           <p style="color:red;"><%= errorMsg %></p>
        <% 
           } 
        %>

        <input type="email" name="email" placeholder="Enter Email" >
        <input type="password" name="password" placeholder="Enter Password" >
        <button type="submit">Login</button>
    </form>

    <a href="Register.jsp">Don't have an account? Register</a>
    <a href="ForegtPass.jsp">Forgot Password?</a>
</div>
</body>
</html>
