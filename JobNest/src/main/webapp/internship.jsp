<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,com.jobportal.DBConnection"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>JobNest - Internships</title>

<link rel="stylesheet" href="internship.css">

<style>
.applied-btn{
    background:#6B7280;
    color:white;
    border:none;
    padding:10px 20px;
    border-radius:8px;
    cursor:not-allowed;
}
.empty{
    text-align:center;
    color:#666;
    margin-top:60px;
}
</style>

</head>

<body>

<div class="sidebar">

    <div class="logo-area">
        <h2><span>Job</span>Nest</h2>
    </div>

    <nav class="sidebar-nav">
        <a href="Dashboard.jsp">🏠 Home</a>
        <a href="ProfileServlet">👤 Profile</a>
        <a href="jobs.jsp">💼 Jobs</a>
        <a href="Application.jsp">📄 Applications</a>
        <a href="internship.jsp" class="active">🎓 Internships</a>
        <a href="jobpost.jsp">➕ Post Job</a>
        <a href="index.jsp">🚪 Logout</a>
    </nav>

</div>

<main class="container">

<section class="welcome">
    <h1>Internship <span>Opportunities</span></h1>
    <p>Apply directly — your applications will appear on your dashboard.</p>
</section>

<section class="ai-section">

<div class="section-heading">
    <h2>Available Internships</h2>
    <h5>Internships posted by users.</h5>
</div>

<%
Integer userId = (Integer) session.getAttribute("userId");

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try{

    con = DBConnection.getConnection();

    ps = con.prepareStatement(
        "SELECT * FROM internships ORDER BY created_at DESC"
    );

    rs = ps.executeQuery();

    boolean hasInternship = false;

    while(rs.next()){

        hasInternship = true;

        boolean alreadyApplied = false;

        if(userId != null){

            PreparedStatement check = con.prepareStatement(
                "SELECT COUNT(*) FROM applications WHERE user_id=? AND job_id=? AND type='INTERNSHIP'"
            );

            check.setInt(1,userId);
            check.setInt(2,rs.getInt("internship_id"));

            ResultSet cr = check.executeQuery();

            if(cr.next()){
                alreadyApplied = cr.getInt(1)>0;
            }

            cr.close();
            check.close();
        }
%>

<div class="recommended-job">

    <div>

        <h3><%= rs.getString("internship_title") %></h3>

        <h5>
            <%= rs.getString("company") %>
            &nbsp;•&nbsp;
            <%= rs.getString("location") %>
        </h5>

        <span>
            Skills:
            <%= rs.getString("skills") %>
        </span>

        <br><br>

        <small>
            &#128176;
            <%= rs.getString("stipend") %>
        </small>

    </div>

    <form action="InternshipServlet" method="post">

        <input type="hidden"
               name="internshipId"
               value="<%= rs.getInt("internship_id") %>">

        <% if(alreadyApplied){ %>

            <button type="button"
                    class="applied-btn"
                    disabled>
                ✓ Applied
            </button>

        <% }else{ %>

            <button type="submit"
                    class="apply-btn">
                Apply
            </button>

        <% } %>

    </form>

</div>

<%
    }

    if(!hasInternship){
%>

<div class="empty">

    <h2>No internships available.</h2>

    <p>User-posted internships will appear here.</p>

</div>

<%
    }

}catch(Exception e){

    out.println("<h3 style='color:red;'>"+e.getMessage()+"</h3>");

}finally{

    try{ if(rs!=null) rs.close(); }catch(Exception e){}
    try{ if(ps!=null) ps.close(); }catch(Exception e){}
    try{ if(con!=null) con.close(); }catch(Exception e){}
}
%>

</section>

</main>

</body>
</html>