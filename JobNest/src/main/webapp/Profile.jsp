<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>JobNest - Profile</title>

    <link rel="stylesheet" href="Profile.css">

</head>

<body>

    <div class="logo">
        JobNest
    </div>


    <%
        // Get profile data from ProfileServlet

        String fullName =
            (String) request.getAttribute("fullName");

        String phone =
            (String) request.getAttribute("phone");

        String workExperience =
            (String) request.getAttribute("workExperience");

        String skills =
            (String) request.getAttribute("skills");

        String qualification =
            (String) request.getAttribute("qualification");

        String profileEmail =
            (String) request.getAttribute("profileEmail");

        String linkedin =
            (String) request.getAttribute("linkedin");

        String github =
            (String) request.getAttribute("github");


        // Default values

        if (fullName == null)
            fullName = "";

        if (phone == null)
            phone = "";

        if (workExperience == null)
            workExperience = "";

        if (skills == null)
            skills = "";

        if (qualification == null)
            qualification = "";

        if (profileEmail == null)
            profileEmail = "";

        if (linkedin == null)
            linkedin = "";

        if (github == null)
            github = "";
    %>


    <form action="ProfileServlet"
          method="post"
          enctype="multipart/form-data">


        <label>Full Name</label>

        <input type="text"
               name="full_name"
               value="<%= fullName %>"
               placeholder="Enter your name"
               required>


        <label>Tel</label>

        <input type="tel"
               name="phone"
               value="<%= phone %>"
               placeholder="Enter your number"
               pattern="[0-9]{10}"
               required>


        <label>Work Experience</label>

        <input type="text"
               name="work_experience"
               value="<%= workExperience %>"
               placeholder="Enter work experience">


        <label>Skill</label>

        <input type="text"
               name="skills"
               value="<%= skills %>"
               placeholder="Java, HTML, CSS, SQL">


        <label>Qualification</label>

        <input type="text"
               name="qualification"
               value="<%= qualification %>"
               placeholder="BCA, MCA, B.Tech etc.">


        <label>Resume</label>

        <input type="file"
               name="resume"
               accept=".pdf">


        <label>Email</label>

        <input type="email"
               name="email"
               value="<%= profileEmail %>"
               placeholder="Enter your email"
               required>


        <label>LinkedIn</label>

        <input type="url"
               name="linkedin"
               value="<%= linkedin %>"
               placeholder="https://linkedin.com/in/username">


        <label>GitHub</label>

        <input type="url"
               name="github"
               value="<%= github %>"
               placeholder="https://github.com/username">


        <input type="submit"
               value="Save">

    </form>

</body>

</html>