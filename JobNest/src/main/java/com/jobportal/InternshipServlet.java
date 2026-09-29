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

@WebServlet("/InternshipServlet")
public class InternshipServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String studentEmail = (String) session.getAttribute("email");

        int internshipId = Integer.parseInt(request.getParameter("internshipId"));

        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            // Internship details fetch
            ps1 = con.prepareStatement(
                "SELECT internship_title, company FROM internships WHERE internship_id=?"
            );

            ps1.setInt(1, internshipId);
            rs = ps1.executeQuery();

            if (!rs.next()) {
                response.getWriter().println("Internship not found.");
                return;
            }

            String internshipTitle = rs.getString("internship_title");
            String company = rs.getString("company");

            // Duplicate apply check
            ps2 = con.prepareStatement(
                "SELECT COUNT(*) FROM applications WHERE user_id=? AND job_title=? AND company=?"
            );

            ps2.setInt(1, userId);
            ps2.setString(2, internshipTitle);
            ps2.setString(3, company);

            ResultSet check = ps2.executeQuery();
            check.next();

            if (check.getInt(1) > 0) {
                response.sendRedirect("Dashboard.jsp");
                return;
            }

            check.close();
            ps2.close();

            // Save application
            ps2 = con.prepareStatement(
            	    "INSERT INTO applications " +
            	    "(user_id, student_email, job_title, company, application_type, job_id, type) " +
            	    "VALUES (?,?,?,?,?,?,?)"
            	);

            	ps2.setInt(1, userId);
            	ps2.setString(2, studentEmail);
            	ps2.setString(3, internshipTitle);
            	ps2.setString(4, company);
            	ps2.setString(5, "Internship");
            	ps2.setInt(6, internshipId);
            	ps2.setString(7, "INTERNSHIP");

            	ps2.executeUpdate();

            response.sendRedirect("Dashboard.jsp");

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());

        } finally {

            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps1 != null) ps1.close(); } catch (Exception e) {}
            try { if (ps2 != null) ps2.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}

        }
    }
}