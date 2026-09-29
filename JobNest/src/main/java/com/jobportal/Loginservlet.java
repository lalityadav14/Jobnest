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

@WebServlet("/Loginservlet")
public class Loginservlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null ||
            email.trim().isEmpty() ||
            password.trim().isEmpty()) {

            response.sendRedirect("index.jsp?error=empty");
            return;
        }

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "SELECT id, name, email, phone, role " +
                    "FROM users " +
                    "WHERE email = ? AND password = ?";

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                int userId = rs.getInt("id");
                String name = rs.getString("name");
                String userEmail = rs.getString("email");
                String phone = rs.getString("phone");
                String role = rs.getString("role");

                // New session
                HttpSession session = request.getSession();

                // Logged-in user information
                session.setAttribute("userId", userId);
                session.setAttribute("name", name);
                session.setAttribute("email", userEmail);
                session.setAttribute("phone", phone);
                session.setAttribute("role", role);

                rs.close();
                ps.close();
                con.close();

                response.sendRedirect("Dashboard.jsp");

            } else {

                rs.close();
                ps.close();
                con.close();

                response.sendRedirect("index.jsp?error=invalid");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html;charset=UTF-8");

            response.getWriter().println(
                    "<h2>Database Error</h2>"
            );

            response.getWriter().println(
                    "<p>" + e.getMessage() + "</p>"
            );
        }
    }
}