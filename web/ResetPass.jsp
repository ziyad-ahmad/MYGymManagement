<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Reset Password</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: linear-gradient(to right, #c5cae9, #9fa8da);
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            .reset-container {
                background: #ffffff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0px 6px 12px rgba(0,0,0,0.2);
                text-align: center;
                width: 350px;
            }
            .reset-container h2 {
                margin-bottom: 20px;
                color: #283593;
            }
            .reset-container input {
                width: 90%;
                padding: 12px;
                margin: 10px 0;
                border-radius: 8px;
                border: 1px solid #ccc;
            }
            .reset-container button {
                width: 95%;
                padding: 12px;
                background-color: #283593;
                border: none;
                border-radius: 8px;
                color: #fff;
                font-size: 16px;
                cursor: pointer;
            }
            .reset-container button:hover {
                background-color: #1a237e;
            }
        </style>
    </head>
    <body>
        <div class="reset-container">
            <h2>Reset Password</h2>
            <%
                String errorMsg = (String) request.getAttribute("errorMsg");
                if (errorMsg != null) {
            %>
            <p style="color:red;"><%= errorMsg%></p>
            <%
                }
            %>
            <form action="ResetPassword" method="post">
                <input type="hidden" name="email" value="${email}">
                <input type="password" name="newPassword" placeholder="Enter New Password" required>
                <input type="password" name="confirmPassword" placeholder="Confirm New Password" required>
                <button type="submit">Reset Password</button>
            </form>
        </div>
    </body>
</html>
