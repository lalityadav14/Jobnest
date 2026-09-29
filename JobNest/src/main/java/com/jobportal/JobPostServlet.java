package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/JobPostServlet")
public class JobPostServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String jobTitle = request.getParameter("jobTitle");
        String company = request.getParameter("company");
        String location = request.getParameter("location");
        String jobType = request.getParameter("jobType");   // JOB / INTERNSHIP
        String experience = request.getParameter("experience");
        String salary = request.getParameter("salary");
        String vacancies = request.getParameter("vacancies");
        String skills = request.getParameter("skills");
        String qualification = request.getParameter("requirements");
        String description = request.getParameter("description");
        String deadline = request.getParameter("deadline");

        Connection con = null;
        PreparedStatement ps = null;

        try {

            con = DBConnection.getConnection();

            if ("INTERNSHIP".equalsIgnoreCase(jobType)) {

                String sql = "INSERT INTO internships "
                        + "(internship_title, job_title, company, location, skills, qualification, stipend, description) "
                        + "VALUES (?,?,?,?,?,?,?,?)";

                ps = con.prepareStatement(sql);

                ps.setString(1, jobTitle);
                ps.setString(2, jobTitle);
                ps.setString(3, company);
                ps.setString(4, location);
                ps.setString(5, skills);
                ps.setString(6, qualification);
                ps.setString(7, salary);      // stipend
                ps.setString(8, description);

            } else {

                String sql = "INSERT INTO jobs "
                        + "(job_title, company, location, skills, qualification, salary, description) "
                        + "VALUES (?,?,?,?,?,?,?)";

                ps = con.prepareStatement(sql);

                ps.setString(1, jobTitle);
                ps.setString(2, company);
                ps.setString(3, location);
                ps.setString(4, skills);
                ps.setString(5, qualification);
                ps.setString(6, salary);
                ps.setString(7, description);
            }

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("Dashboard.jsp");
            } else {
                response.getWriter().println("Post failed.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());

        } finally {

            try {
                if (ps != null)
                    ps.close();
            } catch (Exception e) {}

            try {
                if (con != null)
                    con.close();
            } catch (Exception e) {}
        }
    }
}