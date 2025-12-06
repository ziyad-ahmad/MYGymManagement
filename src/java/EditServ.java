import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(urlPatterns = {"/EditServ"})
public class EditServ extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("member_id") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String memberId = (String) session.getAttribute("member_id");
        String newName = request.getParameter("name");
        String newPhone = request.getParameter("phone");
        String newPassword = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/gym_management?useSSL=false",
                    "root",
                    "password@mysql"
            );

            // Fetch current values
            PreparedStatement psSelect = con.prepareStatement(
                    "SELECT name, phone, password FROM members WHERE member_id=?"
            );
            psSelect.setString(1, memberId);
            ResultSet rs = psSelect.executeQuery();

            String finalName = "";
            String finalPhone = "";
            String finalPassword = "";

            if (rs.next()) {
                finalName = rs.getString("name");
                finalPhone = rs.getString("phone");
                finalPassword = rs.getString("password");
            }
            rs.close();
            psSelect.close();

            // Only update if user typed something
            if (newName != null && !newName.trim().isEmpty()) {
                finalName = newName.trim();
            }
            if (newPhone != null && !newPhone.trim().isEmpty()) {
                finalPhone = newPhone.trim();
            }
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                finalPassword = BCrypt.hashpw(newPassword.trim(), BCrypt.gensalt());
            }

            // Update DB
            PreparedStatement psUpdate = con.prepareStatement(
                    "UPDATE members SET name=?, phone=?, password=? WHERE member_id=?"
            );
            psUpdate.setString(1, finalName);
            psUpdate.setString(2, finalPhone);
            psUpdate.setString(3, finalPassword);
            psUpdate.setString(4, memberId);

            int updated = psUpdate.executeUpdate();
            psUpdate.close();
            con.close();

            if (updated > 0) {
                // Update session values
                session.setAttribute("name", finalName);
                session.setAttribute("phone", finalPhone);
                // Do NOT store password in session for security

                response.sendRedirect("Profile.jsp");
            } else {
                out.println("<script>alert('Update failed! Try again'); window.location='edit.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        }
    }
}
