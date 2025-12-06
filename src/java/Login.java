import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(urlPatterns = {"/Login"})
public class Login extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // ✅ Basic validation
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMsg", "❌ Please enter your Email.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }
        

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMsg", "❌ Please enter your Password.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        try {
            // ✅ Connect to DB
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/gym_management?useSSL=false",
                    "root",
                    "password@mysql"
            );

            // ✅ Fetch user by email
            PreparedStatement ps = con.prepareStatement(
                    "SELECT member_id, password FROM members WHERE email=?"
            );
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // ✅ Email found
                String hashedPassword = rs.getString("password"); // password hash from DB

                if (hashedPassword != null && BCrypt.checkpw(password, hashedPassword)) {
                    // ✅ Correct password
                        HttpSession session = request.getSession();
                        session.setAttribute("email", email);
                        session.setAttribute("role", "member");
                        session.setAttribute("member_id", rs.getString("member_id"));
                        response.sendRedirect("Profile.jsp");
                } else {
                    // ❌ Wrong password
                    request.setAttribute("errorMsg", "❌ Incorrect Password!");
                    request.getRequestDispatcher("Login.jsp").forward(request, response);
                }
            } else {
                // ❌ Email not found
                request.setAttribute("errorMsg", "❌ Email does not exist!");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            }

            // ✅ Cleanup
            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "❌ Something went wrong. Try again OR Incorrect Password!.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Login.jsp"); // redirect GET requests
    }
}
