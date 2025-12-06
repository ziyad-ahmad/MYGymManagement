import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(urlPatterns = {"/ResetPassword"})
public class ResetPassword extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        if(newPassword == null || newPassword.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty())
        {
             request.setAttribute("errorMsg", "❌ fill the all password.");
        }

        try {
            if (!newPassword.equals(confirmPassword)) {
                out.println("<h3 style='color:red;'>Passwords do not match!</h3>");
                request.getRequestDispatcher("ResetPassword.jsp").include(request, response);
                return;
            }

            // ✅ Hash password
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/gym_management?useSSL=false",
                "root", "password@mysql");

            String sql = "UPDATE members SET password=? WHERE email=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, hashedPassword);
            ps.setString(2, email);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                boolean sent = sendPasswordResetEmail(email);
                out.println("<h3 style='color:green;'>Password updated successfully!</h3>");
                if (sent) {
                    out.println("<p style='color:blue;'>A confirmation email has been sent to " + email + ".</p>");
                } else {
                    out.println("<p style='color:red;'>Password updated, but email could not be sent.</p>");
                }
                out.println("<a href='Login.jsp'>Click here to Login</a>");
            } else {
                out.println("<h3 style='color:red;'>Email not found. Try again.</h3>");
                request.getRequestDispatcher("ForegtPass.jsp").include(request, response);
                
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
        }
    }

    // ✅ Send confirmation email
    private boolean sendPasswordResetEmail(String toEmail) {
        final String fromEmail = "personal.one0371@gmail.com"; 
        final String password = "gormsmcozvmizfwu"; // App password

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail, "AKHADA GYM"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("Password Reset Confirmation - AKHADA GYM");
            msg.setText("Hello,\n\nYour password has been successfully reset.\n\n"
                    + "If you did not request this change, please contact support immediately.\n\n"
                    + "- AKHADA GYM Team");

            Transport.send(msg);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
