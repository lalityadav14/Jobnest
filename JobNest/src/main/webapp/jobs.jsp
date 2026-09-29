<%@ page import="java.sql.*" %>
<%@ page import="com.jobportal.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JobNest - Jobs</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI',Arial,sans-serif;
}
body{
    background:#F4F8FF;
}
.container{
    width:90%;
    margin:30px auto;
}
h1{
    color:#0A66C2;
    margin-bottom:25px;
}
.job-card{
    background:white;
    border-radius:16px;
    padding:22px;
    margin-bottom:20px;
    box-shadow:0 4px 12px rgba(0,0,0,.08);
}
.job-card h2{
    margin:10px 0;
    color:#222;
}
.company{
    color:#555;
    margin-bottom:10px;
}
.details{
    color:#555;
    margin:8px 0;
}
.badge{
    display:inline-block;
    padding:6px 12px;
    border-radius:20px;
    color:white;
    font-size:12px;
    font-weight:bold;
}
.job{ background:#0A66C2; }
.internship{ background:#16A34A; }

.apply-btn{
    background:#16A34A;
    color:white;
    border:none;
    padding:10px 22px;
    border-radius:8px;
    cursor:pointer;
    margin-top:15px;
    font-weight:bold;
}
.apply-btn:hover{
    background:#13833d;
}
.applied-btn{
    background:#6B7280;
    color:white;
    border:none;
    padding:10px 22px;
    border-radius:8px;
    cursor:not-allowed;
    margin-top:15px;
    font-weight:bold;
}
.empty{
    text-align:center;
    color:#777;
    margin-top:80px;
}
</style>

</head>
<body>

<div class="container">

<h1>Available Jobs & Internships</h1>

<%
Integer userId = (Integer) session.getAttribute("userId");

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

    con=DBConnection.getConnection();

    String sql =
    "SELECT job_id AS id, job_title AS title, company, location, skills, qualification, salary AS pay, description, created_at,'JOB' AS type FROM jobs " +
    "UNION ALL " +
    "SELECT internship_id AS id, internship_title AS title, company, location, skills, qualification, stipend AS pay, description, created_at,'INTERNSHIP' AS type FROM internships " +
    "ORDER BY created_at DESC";

    ps=con.prepareStatement(sql);
    rs=ps.executeQuery();

    boolean hasData=false;

    while(rs.next()){

        hasData=true;

        boolean alreadyApplied=false;

        if(userId!=null){

            PreparedStatement checkPs = con.prepareStatement(
                "SELECT COUNT(*) FROM applications WHERE user_id=? AND job_id=? AND type=?"
            );

            checkPs.setInt(1,userId);
            checkPs.setInt(2,rs.getInt("id"));
            checkPs.setString(3,rs.getString("type"));

            ResultSet checkRs = checkPs.executeQuery();

            if(checkRs.next()){
                alreadyApplied = checkRs.getInt(1)>0;
            }

            checkRs.close();
            checkPs.close();
        }
%>

<div class="job-card">

<% if("JOB".equals(rs.getString("type"))){ %>

<span class="badge job">JOB</span>

<% }else{ %>

<span class="badge internship">INTERNSHIP</span>

<% } %>

<h2><%= rs.getString("title") %></h2>

<div class="company"><%= rs.getString("company") %></div>

<div class="details">&#128205; <%= rs.getString("location") %></div>

<div class="details">&#128176; <%= rs.getString("pay") %></div>

<div class="details">&#128736; Skills: <%= rs.getString("skills") %></div>

<div class="details">&#127891; Qualification: <%= rs.getString("qualification") %></div>

<p style="margin-top:12px;"><%= rs.getString("description") %></p>

<% if("JOB".equals(rs.getString("type"))){ %>

<form action="ApplyJobServlet" method="post">

<input type="hidden" name="jobId" value="<%= rs.getInt("id") %>">

<% if(alreadyApplied){ %>

<button type="button" class="applied-btn" disabled>
✓ Applied
</button>

<% }else{ %>

<button type="submit" class="apply-btn">
Apply Job
</button>

<% } %>

</form>

<% }else{ %>

<form action="InternshipServlet" method="post">

<input type="hidden" name="internshipId" value="<%= rs.getInt("id") %>">

<% if(alreadyApplied){ %>

<button type="button" class="applied-btn" disabled>
✓ Applied
</button>

<% }else{ %>

<button type="submit" class="apply-btn">
Apply Internship
</button>

<% } %>

</form>

<% } %>

</div>

<%
    }

    if(!hasData){
%>

<div class="empty">
<h2>No jobs or internships available.</h2>
<p>User-posted jobs and internships will appear here.</p>
</div>

<%
    }

}catch(Exception e){

    out.println("<h3 style='color:red;'>Error: "+e.getMessage()+"</h3>");

}finally{

    try{ if(rs!=null) rs.close(); }catch(Exception e){}
    try{ if(ps!=null) ps.close(); }catch(Exception e){}
    try{ if(con!=null) con.close(); }catch(Exception e){}

}
%>

</div>

</body>
</html>