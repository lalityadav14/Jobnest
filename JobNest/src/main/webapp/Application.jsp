<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*,com.jobportal.DBConnection"%>

<%
Integer userId = (Integer) session.getAttribute("userId");

if (userId == null) {
    response.sendRedirect("index.jsp");
    return;
}

Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM applications WHERE user_id=? ORDER BY applied_date DESC");

ps.setInt(1, userId);

ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Applications</title>
<link rel="stylesheet" href="Application.css">
</head>

<body>

<div class="container">

    <h1>My Applications</h1>

    <div class="cards">

    <%
    boolean found = false;

    while (rs.next()) {
        found = true;
    %>

        <div class="card">

            <div class="type">
                <%= rs.getString("application_type") %>
            </div>

            <h2><%= rs.getString("job_title") %></h2>

            <h3><%= rs.getString("company") %></h3>

            <p>Status: <b><%= rs.getString("status") %></b></p>

            <p>Applied: <%= rs.getString("applied_date") %></p>

            <a href="ApplicationServlet?application_id=<%= rs.getInt("application_id") %>"
               class="btn">
                View Details
            </a>

        </div>

    <%
    }

    if (!found) {
    %>

        <div class="empty">

            <h2>No Applications Yet</h2>

            <p>Apply for a Job or Internship.</p>

            <a href="jobs.jsp">Browse Jobs</a>

        </div>

    <%
    }
    %>

    </div>

</div>

</body>
</html>