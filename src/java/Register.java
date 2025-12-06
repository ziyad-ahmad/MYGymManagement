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

@WebServlet(urlPatterns = {"/Register"})
public class Register extends HttpServlet {

    private boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        return email != null && email.matches(emailRegex);
    }

    private boolean sendConfirmationEmail(String toEmail, String memberId) {
        final String fromEmail = "personal.one0371@gmail.com"; // your Gmail
        final String password = "gormsmcozvmizfwu";           // app password

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
            msg.setSubject("Welcome to AKHADA GYM!");
            msg.setText("Hello,\n\nYour registration was successful.\nYour Member ID is: "
                    + memberId + "\n\nLogin to your account to get started.\n\n- AKHADA.GYM Team");
            Transport.send(msg);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            request.setAttribute("errorMsg", "❌ All fields are required.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        try {
            if (!isValidEmail(email)) {
                request.setAttribute("errorMsg", "❌ Enter a valid email address.");
                request.getRequestDispatcher("Register.jsp").forward(request, response);
                return;
            }

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/gym_management?useSSL=false",
                    "root", "password@mysql");
            // Check if email already exists
            PreparedStatement checkEmail = con.prepareStatement("SELECT * FROM members WHERE email=?");
            checkEmail.setString(1, email);
            ResultSet rsEmail = checkEmail.executeQuery();
            if (rsEmail.next()) {
                request.setAttribute("errorMsg", "❌ Email already registered. Try logging in.");
                request.getRequestDispatcher("Register.jsp").forward(request, response);
                return;
            }

            // Generate Member ID
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT MAX(member_id) AS maxId FROM members");
            String memberId = "GYM001";
            if (rs.next() && rs.getString("maxId") != null) {
                String lastId = rs.getString("maxId");
                int num = Integer.parseInt(lastId.substring(3));
                num++;
                memberId = "GYM" + String.format("%03d", num);
            }

            // Send confirmation email
            boolean emailSent = sendConfirmationEmail(email, memberId);
            if (!emailSent) {
                request.setAttribute("errorMsg", "❌ Could not send confirmation email.");
                request.getRequestDispatcher("Register.jsp").forward(request, response);
                return;
            }

            // Hash password with BCrypt
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // Insert into DB
            PreparedStatement psmt = con.prepareStatement(
                "INSERT INTO members(member_id,name,email,phone,password) VALUES (?,?,?,?,?)");
            psmt.setString(1, memberId);
            psmt.setString(2, name);
            psmt.setString(3, email);
            psmt.setString(4, phone);
            psmt.setString(5, hashedPassword);

            int i = psmt.executeUpdate();
            if (i > 0) {
                request.setAttribute("successMsg", "✅ Registration successful! Confirmation email sent to " + email);
                request.getRequestDispatcher("Register.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMsg", "❌ Registration failed. Try again.");
                request.getRequestDispatcher("Register.jsp").forward(request, response);
            }

            psmt.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        }
    }
}
