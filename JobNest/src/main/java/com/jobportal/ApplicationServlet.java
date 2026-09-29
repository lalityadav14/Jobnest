package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ApplicationServlet")
public class ApplicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // User login check
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String jobIdStr = request.getParameter("jobId");
        String type = request.getParameter("type"); // JOB or INTERNSHIP

        try {
            int jobId = Integer.parseInt(jobIdStr);

            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO applications(user_id, job_id, type) VALUES (?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, jobId);
            ps.setString(3, type);

            int result = ps.executeUpdate();

            ps.close();
            con.close();

            if (result > 0) {
                response.sendRedirect("Dashboard.jsp");
            } else {
                response.getWriter().println("Application failed.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}