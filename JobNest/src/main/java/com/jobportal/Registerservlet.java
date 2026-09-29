package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/RegisterServlet")
public class Registerservlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        String password = request.getParameter("password");
        String confirmPassword =
                request.getParameter("confirmPassword");

        // ==========================================
        // 1. PASSWORD CHECK
        // ==========================================

        if (password == null ||
            !password.equals(confirmPassword)) {

            response.setContentType(
                    "text/html;charset=UTF-8");

            response.getWriter().println(
                    "<h2>Password and Confirm Password do not match!</h2>"
            );

            return;
        }


        try {

            // ==========================================
            // 2. DATABASE CONNECTION
            // ==========================================

            Connection con =
                    DBConnection.getConnection();


            // ==========================================
            // 3. CHECK MAXIMUM 10 USERS
            // ==========================================

            String countSQL =
                    "SELECT COUNT(*) FROM users";

            PreparedStatement countPS =
                    con.prepareStatement(countSQL);

            ResultSet countRS =
                    countPS.executeQuery();


            if (countRS.next()) {

                int totalUsers =
                        countRS.getInt(1);


                // Maximum 10 users
                if (totalUsers >= 10) {

                    countRS.close();
                    countPS.close();
                    con.close();

                    response.setContentType(
                            "text/html;charset=UTF-8");

                    response.getWriter().println(
                            "<h2>Registration Limit Reached</h2>"
                    );

                    response.getWriter().println(
                            "<p>Maximum 10 users are allowed in JobNest.</p>"
                    );

                    response.getWriter().println(
                            "<a href='Register.jsp'>Go Back</a>"
                    );

                    return;
                }
            }


            countRS.close();
            countPS.close();


            // ==========================================
            // 4. INSERT NEW USER
            // ==========================================

            String sql =
                    "INSERT INTO users " +
                    "(name, email, phone, role, password) " +
                    "VALUES (?, ?, ?, ?, ?)";


            PreparedStatement ps =
                    con.prepareStatement(
                            sql,
                            PreparedStatement.RETURN_GENERATED_KEYS
                    );


            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, role);
            ps.setString(5, password);


            int result =
                    ps.executeUpdate();


            // ==========================================
            // 5. REGISTRATION SUCCESS
            // ==========================================

            if (result > 0) {

                // Get newly created User ID
                ResultSet rs =
                        ps.getGeneratedKeys();


                if (rs.next()) {

                    int userId =
                            rs.getInt(1);


                    // ==========================================
                    // 6. CREATE SESSION
                    // ==========================================

                    HttpSession session =
                            request.getSession();


                    session.setAttribute(
                            "userId",
                            userId
                    );

                    session.setAttribute(
                            "name",
                            name
                    );

                    session.setAttribute(
                            "email",
                            email
                    );

                    session.setAttribute(
                            "phone",
                            phone
                    );

                    session.setAttribute(
                            "role",
                            role
                    );


                    rs.close();
                    ps.close();
                    con.close();


                    // ==========================================
                    // 7. GO TO DASHBOARD
                    // ==========================================

                    response.sendRedirect(
                            "Dashboard.jsp"
                    );

                    return;
                }


                rs.close();
            }


            ps.close();
            con.close();


            // ==========================================
            // 8. REGISTRATION FAILED
            // ==========================================

            response.setContentType(
                    "text/html;charset=UTF-8");

            response.getWriter().println(
                    "<h2>Registration Failed!</h2>"
            );


        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType(
                    "text/html;charset=UTF-8");

            response.getWriter().println(
                    "<h2>Database Error</h2>"
            );

            response.getWriter().println(
                    "<p>" + e.getMessage() + "</p>"
            );
        }
    }
}