<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,com.jobportal.DBConnection"%>
<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>JobNest - Dashboard</title>

    <link rel="stylesheet"
          href="Dashboard.css">

</head>


<body>


<%
    // ==============================
    // GET LOGGED-IN USER ID
    // ==============================

    Integer userId =
        (Integer) session.getAttribute("userId");

    // If user is not logged in
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }


    // ==============================
    // GET USER DETAILS FROM SESSION
    // ==============================

    String userName =
        (String) session.getAttribute("name");

    String userEmail =
        (String) session.getAttribute("email");

    String userPhone =
        (String) session.getAttribute("phone");

    String userRole =
        (String) session.getAttribute("role");


    // ==============================
    // DEFAULT VALUES
    // ==============================

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


    // ==============================
    // FIRST LETTER
    // ==============================

    String firstLetter =
        userName.substring(0, 1).toUpperCase();


    // ==============================
    // DASHBOARD COUNTS (DB)
    // ==============================

    int jobCount = 0;
    int internshipCount = 0;
    int applicationCount = 0;
   
    PreparedStatement recentPs = null;
    ResultSet recentRs = null;

    try {
        Connection con2 = DBConnection.getConnection();

        String recentSql =
            "SELECT a.type," +
            " CASE WHEN a.type='JOB' THEN j.job_title ELSE i.internship_title END AS title," +
            " CASE WHEN a.type='JOB' THEN j.company ELSE i.company END AS company," +
            " a.applied_at" +
            " FROM applications a" +
            " LEFT JOIN jobs j ON a.job_id=j.job_id AND a.type='JOB'" +
            " LEFT JOIN internships i ON a.job_id=i.internship_id AND a.type='INTERNSHIP'" +
            " WHERE a.user_id=?" +
            " ORDER BY a.applied_at DESC LIMIT 5";

        recentPs = con2.prepareStatement(recentSql);
        recentPs.setInt(1, userId);
        recentRs = recentPs.executeQuery();

    } catch (Exception e) {
        e.printStackTrace();
    }
    %>


<!-- ==================================================
     SIDEBAR
================================================== -->

<div class="sidebar">


    <!-- ================= LOGO ================= -->

    <div class="logo-area">

        <h2>

            <span>Job</span>Nest

        </h2>

    </div>



    <!-- ================= NAVIGATION ================= -->
<nav>

    <a href="Dashboard.jsp">🏠 Home</a>

    <a href="ProfileServlet">👤 Profile</a>

    <a href="jobs.jsp">💼 Jobs</a>

    <a href="Application.jsp">📄 Applications</a>

    <a href="internship.jsp">🎓 Internships</a>
    
    <a href="jobpost.jsp">💼 Postjob</a> 
    
    <a href="index.jsp">🚪 Logout
        </a>
    
        </nav>


</div>



<!-- ==================================================
     MAIN CONTENT
================================================== -->

<div class="main-content">



    <!-- ==================================================
         TOP BAR
    ================================================== -->

    <div class="top-bar">


        <!-- PAGE TITLE -->

        <div>

            <h1>
                Welcome back to JobNest
            </h1>
        </div>



        <!-- ================= USER AREA ================= -->

        <div class="user-area">


            <!-- USER PROFILE CIRCLE -->

            <button
                class="profile-circle"
                onclick="toggleUserBox()">

                <%= firstLetter %>

            </button>



            <!-- ==================================================
                 USER DETAILS BOX
            ================================================== -->

            <div
                id="userBox"
                class="user-box">


                <!-- USER HEADER -->

                <div class="user-header">


                    <h3>
                        My Details
                    </h3>


                    <button
                        class="user-close"
                        onclick="toggleUserBox()">

                        &times;

                    </button>


                </div>



                <!-- USER DETAILS -->

                <div class="user-details">


                    <p>

                        <strong>Name:</strong>

                        <%= userName %>

                    </p>



                    <p>

                        <strong>Email:</strong>

                        <%= userEmail %>

                    </p>
                    <p>

                        <strong>Phone:</strong>

                        <%= userPhone %>

                    </p>



                    <p>

                        <strong>Role:</strong>

                        <%= userRole %>

                    </p>


                </div>



                <!-- EDIT PROFILE -->

               <a
                href="ProfileServlet" class="edit-btn">
                    ✏️ Edit Profile
                </a>
            </div>
        </div>
    </div>
    <!-- ==================================================
         WELCOME SECTION
    ================================================== -->

    <section class="welcome-section">


        <h2>

            Welcome,
            <span><%= userName %></span> 👋

        </h2>


        <p>

            Find jobs and internships according
            to your skills and qualifications.

        </p>


    </section>



    <!-- ==================================================
         SUMMARY CARDS
    ================================================== -->

    <section class="summary-section">



        <!-- ================= RECOMMENDED JOBS ================= -->

        <div class="summary-card">


            <div class="card-icon">

                💼

            </div>


            <div>

                <h3>
                    Recommended Jobs
                </h3>
                
                    <h2><%=jobCount%></h2>

                <p>
                    Matching your profile
                </p>

            </div>


        </div>



        <!-- ================= NEW INTERNSHIPS ================= -->

        <div class="summary-card">


            <div class="card-icon">

                🔔

            </div>


            <div>

                <h3>
                    Internships
                </h3>

                    <h2><%=internshipCount%></h2>
                
                <p>
                    Recently added internships
                </p>

            </div>


        </div>



        <!-- ================= APPLICATIONS ================= -->

        <div class="summary-card">


            <div class="card-icon">

                📄

            </div>


            <div>

                <h3>
                    Applications
                </h3>


               <h2><%=applicationCount%></h2>

                <p>
                    Applications submitted
                </p>

            </div>


        </div>



        <!-- ================= INTERVIEWS ================= -->

        <div class="summary-card">


            <div class="card-icon">

                📅

            </div>


            <div>

                <h3>
                    Interviews
                </h3>


                <h2>
                    0
                </h2>


                <p>
                    Upcoming interviews
                </p>

            </div>


        </div>


    </section>



    <!-- ==================================================
         AI JOB RECOMMENDATIONS
    ================================================== -->

    <section class="ai-section">


        <div class="section-heading">


            <h2>
                AI Job Recommendations
            </h2>


            <p>

                Jobs suggested according to your
                skills and qualifications.

            </p>


        </div>



        <!-- ================= JOB 1 ================= -->

        <div class="recommended-job">


            <div>


                <h3>
                    Java Developer
                </h3>


                <p>
                    Software Company • Nagpur
                </p>


                <span>
                    Skills: Java, JDBC, Servlet, SQL
                </span>


            </div>



            <a href="jobs.jsp">

                View Job

            </a>


        </div>



        <!-- ================= JOB 2 ================= -->

        <div class="recommended-job">


            <div>


                <h3>
                    Java Development Internship
                </h3>


                <p>
                    IT Company • Nagpur
                </p>


                <span>
                    Skills: Java, HTML, CSS, Database
                </span>


            </div>

            <a href="internship.jsp">

                View Internship

            </a>


        </div>



        <!-- ================= JOB 3 ================= -->

        <div class="recommended-job">


            <div>


                <h3>
                    Web Development Internship
                </h3>


                <p>
                    Technology Company • Nagpur
                </p>


                <span>
                    Skills: HTML, CSS, JavaScript, Java
                </span>


            </div>



            <a href="internship.jsp">

                View Internship

            </a>


        </div>


    </section>



    <!-- ==================================================
         RECENT ACTIVITY
    ================================================== -->


 <div class="activity-box">

<%
boolean hasActivity = false;

while (recentRs != null && recentRs.next()) {
    hasActivity = true;
%>

<div style="padding:12px;border-bottom:1px solid #eee;">
    <strong>Applied for <%= recentRs.getString("title") %></strong><br>
    <span><%= recentRs.getString("company") %></span><br>
    <small><%= recentRs.getString("type") %></small>
</div>

<%
}

if (!hasActivity) {
%>

<p>No recent activity available.</p>

<%
}

try {
    if (recentRs != null) recentRs.close();
    if (recentPs != null) recentPs.close();
} catch (Exception e) {}
%>

</div>




<!-- ==================================================
     JAVASCRIPT
================================================== -->

<script>


function toggleUserBox() {

    var box =
        document.getElementById("userBox");


    if (box.style.display === "block") {

        box.style.display = "none";

    }

    else {

        box.style.display = "block";

    }

}


/* ==========================================
   CLOSE BOX WHEN CLICKING OUTSIDE
========================================== */

document.addEventListener(
    "click",
    function(event) {


        var userArea =
            document.querySelector(".user-area");


        var box =
            document.getElementById("userBox");


        if (!userArea.contains(event.target)) {

            box.style.display = "none";

        }


    }
);


</script>


</body>

</html>
