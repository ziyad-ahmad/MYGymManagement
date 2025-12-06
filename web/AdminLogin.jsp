<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f4f8;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-container {
            background: #ffffff;
            border-radius: 15px;
            padding: 35px 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 380px;
            text-align: center;
        }

        .login-container h2 {
            margin-bottom: 25px;
            color: #1e3a8a;
            font-size: 24px;
        }

        input {
            width: 100%;
            padding: 14px;
            margin: 12px 0;
            border-radius: 10px;
            border: 1px solid #ccc;
            font-size: 16px;
            box-sizing: border-box;
        }

        button {
            width: 100%;
            padding: 14px;
            margin-top: 15px;
            border: none;
            border-radius: 10px;
            background-color: #1e3a8a;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }

        button:hover {
            background-color: #16276b;
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 25px 20px;
            }
            input, button {
                padding: 12px;
                font-size: 15px;
            }
            .login-container h2 {
                font-size: 22px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Admin Login</h2>
        <form action="AdminLogin" method="post">
             <% 
   String errorMsg = (String) request.getAttribute("errorMsg");
   if (errorMsg != null) {
%>
   <p style="color:red;"><%= errorMsg %></p>
<% 
   } 
%>
            <input type="text" name="username" placeholder="Username" >
            <input type="password" name="password" placeholder="Password" >
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>
