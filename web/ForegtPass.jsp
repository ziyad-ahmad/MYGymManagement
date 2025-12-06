<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Forgot Password</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: linear-gradient(to right, #f8bbd0, #f48fb1);
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            .forgot-container {
                background: #ffffff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0px 6px 12px rgba(0,0,0,0.2);
                text-align: center;
                width: 350px;
            }
            .forgot-container h2 {
                margin-bottom: 20px;
                color: #ad1457;
            }
            .forgot-container input {
                width: 90%;
                padding: 12px;
                margin: 10px 0;
                border-radius: 8px;
                border: 1px solid #ccc;
            }
            .forgot-container button {
                width: 95%;
                padding: 12px;
                background-color: #ad1457;
                border: none;
                border-radius: 8px;
                color: #fff;
                font-size: 16px;
                cursor: pointer;
            }
            .forgot-container button:hover {
                background-color: #6a1b9a;
            }
            .forgot-container a {
                display: block;
                margin-top: 15px;
                text-decoration: none;
                color: #ad1457;
            }
        </style>
    </head>
    <body>
        <div class="forgot-container">
            <h2>Forgot Password</h2>
            <%
                String errorMsg = (String) request.getAttribute("errorMsg");
                if (errorMsg != null) {
            %>
            <p style="color:red;"><%= errorMsg%></p>
            <%
                }
            %>
            <form action="ForgetPassword" method="post">
                <input type="email" name="email" placeholder="Enter Registered Email">
                <button type="submit">Submit</button>
            </form>
            <a href="Login.jsp">Back to Login</a>
        </div>
    </body>
</html>
