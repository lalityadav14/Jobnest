package com.jobportal;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ApplyJobServlet")
public class ApplyJobServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String email = (String) session.getAttribute("email");
        int jobId = Integer.parseInt(request.getParameter("jobId"));

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            // Job details fetch
            ps = con.prepareStatement(
                "SELECT job_title, company FROM jobs WHERE job_id=?"
            );
            ps.setInt(1, jobId);
            rs = ps.executeQuery();

            if (!rs.next()) {
                response.getWriter().println("Job not found.");
                return;
            }

            String jobTitle = rs.getString("job_title");
            String company = rs.getString("company");

            rs.close();
            ps.close();

            // Duplicate apply check
            ps = con.prepareStatement(
                "SELECT COUNT(*) FROM applications WHERE user_id=? AND job_id=? AND type='JOB'"
            );
            ps.setInt(1, userId);
            ps.setInt(2, jobId);

            rs = ps.executeQuery();
            rs.next();

            if (rs.getInt(1) > 0) {
                response.sendRedirect("jobs.jsp");
                return;
            }

            rs.close();
            ps.close();

            // Save application
            ps = con.prepareStatement(
                "INSERT INTO applications " +
                "(user_id, student_email, job_title, company, application_type, job_id, type) " +
                "VALUES (?,?,?,?,?,?,?)"
            );

            ps.setInt(1, userId);
            ps.setString(2, email);
            ps.setString(3, jobTitle);
            ps.setString(4, company);
            ps.setString(5, "Job");
            ps.setInt(6, jobId);
            ps.setString(7, "JOB");

            ps.executeUpdate();

            response.sendRedirect("jobs.jsp");

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());

        } finally {

            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}

        }
    }
}