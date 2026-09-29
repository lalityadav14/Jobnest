package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/HomeServlet")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
    	response.setContentType("text/html;charset=UTF-8");
    	response.getWriter().println("<h2>HomeServlet is Working!</h2>");
    	

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");

        String userName = (String) session.getAttribute("name");
        String userEmail = (String) session.getAttribute("email");
        String userPhone = (String) session.getAttribute("phone");
        String userRole = (String) session.getAttribute("role");

        if (userName == null || userName.trim().isEmpty()) {
            userName = "User";
        }

        if (userEmail == null || userEmail.trim().isEmpty()) {
            userEmail = "-";
        }

        if (userPhone == null || userPhone.trim().isEmpty()) {
            userPhone = "-";
        }

        if (userRole == null || userRole.trim().isEmpty()) {
            userRole = "User";
        }

        request.setAttribute("userId", userId);
        request.setAttribute("userName", userName);
        request.setAttribute("userEmail", userEmail);
        request.setAttribute("userPhone", userPhone);
        request.setAttribute("userRole", userRole);

        // Applications
        int applicationCount = 0;

        String applicationSQL =
                "SELECT COUNT(*) FROM applications";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(applicationSQL);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                applicationCount = rs.getInt(1);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute(
                "applicationCount",
                applicationCount
        );

        // Jobs
        int recommendedJobs = 0;

        String jobSQL = "SELECT COUNT(*) FROM jobs";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(jobSQL);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                recommendedJobs = rs.getInt(1);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute(
                "recommendedJobs",
                recommendedJobs
        );

        // Internships
        int internshipCount = 0;

        String internshipSQL =
                "SELECT COUNT(*) FROM internships";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(internshipSQL);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                internshipCount = rs.getInt(1);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute(
                "internshipCount",
                internshipCount
        );

        // New Jobs
        request.setAttribute(
                "newJobs",
                recommendedJobs
        );

        // Interviews
        int interviewCount = 0;

        request.setAttribute(
                "interviewCount",
                interviewCount
        );

        // AI Recommendations
        int aiRecommendations = 0;

        request.setAttribute(
                "aiRecommendations",
                aiRecommendations
        );

        // Open Dashboard
        RequestDispatcher rd =
                request.getRequestDispatcher("Dashboard.jsp");

        rd.forward(request, response);
    }
}