/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt 
 * to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java 
 * to edit this template
 */

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.servlet.http.HttpSession;

/**
 * @author ziyad
 */
@WebServlet(urlPatterns = {"/sendmessage"})
public class sendmessage extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String memberId = request.getParameter("memberId");
        String messageText = request.getParameter("messageText");

        try {
            // 1. DB connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/gym_management?useSSL=false",
                "root", "password@mysql"
            );

            // 2. Insert message
            String sql = "INSERT INTO messages(member_id, message_text) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, memberId);
            ps.setString(2, messageText);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                // Get member email
                String emailSql = "SELECT email FROM members WHERE member_id = ?";
                PreparedStatement ps2 = con.prepareStatement(emailSql);
                ps2.setString(1, memberId);
                ResultSet rs = ps2.executeQuery();

                if (rs.next()) {
                    String toEmail = rs.getString("email");

                    // 4. Send email
                    String subject = "New Message from AKHADA GYM";
                    String body = "Hello " + memberId + ",\n\nYou have a new message:\n\n"
                                + messageText + "\n\nRegards,\nAkhada Gym";

                    sendEmail(toEmail, subject, body);
                }

                request.setAttribute("successMsg", "✅ Message saved & email sent to " + memberId);
            } else {
                request.setAttribute("errorMsg", "❌ Failed to send message. Try again.");
            }

            ps.close();
            con.close();

            // Redirect back to members page
            request.getRequestDispatcher("SendMessage.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    private void sendEmail(String toEmail, String subject, String body) {
        final String fromEmail = "personal.one0371@gmail.com";  // 🔹 Replace with your Gmail
        final String password = "gormsmcozvmizfwu";              // 🔹 Replace with your App Password

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail, "Akhada Gym"));
            msg.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            msg.setSubject(subject);
            msg.setText(body);

            Transport.send(msg);
            System.out.println("📧 Email sent successfully to: " + toEmail);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Returns a short description of the servlet.
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
