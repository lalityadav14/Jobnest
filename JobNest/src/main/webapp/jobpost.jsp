<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Post a Job - JobNest</title>

<link rel="stylesheet" href="jobpost.css">

</head>
<body>

<div class="navbar">

    <div class="logo">
        Job<span>Nest</span>
    </div>

    <a href="Dashboard.jsp" class="back-btn">
        ← Back to Dashboard
    </a>

</div>

<div class="container">

    <div class="heading">

        <h1>Post a Job</h1>

        <p>Create a new job or internship opportunity.</p>

    </div>

    <div class="job-card">

        <form action="JobPostServlet" method="post">

            <!-- Job Title -->

            <div class="form-group">

                <label>Job Title</label>

                <input type="text" name="jobTitle" required>

            </div>

            <!-- Company & Location -->

            <div class="form-row">

                <div class="form-group">

                    <label>Company</label>

                    <input type="text" name="company" required>

                </div>

                <div class="form-group">

                    <label>Location</label>

                    <input type="text" name="location" required>

                </div>

            </div>

            <!-- Job Type & Experience -->

            <div class="form-row">

                <div class="form-group">

                    <label>Job Type</label>

                    <select name="jobType" required>

                        <option value="">Select</option>

                        <option value="JOB">Job</option>

                        <option value="INTERNSHIP">Internship</option>

                    </select>

                </div>

                <div class="form-group">

                    <label>Experience</label>

                    <select name="experience" required>

                        <option value="">Select</option>

                        <option value="Fresher">Fresher</option>

                        <option value="0-1 Years">0-1 Years</option>

                        <option value="1-3 Years">1-3 Years</option>

                        <option value="3-5 Years">3-5 Years</option>

                        <option value="5+ Years">5+ Years</option>

                    </select>

                </div>

            </div>

            <!-- Salary & Vacancy -->

            <div class="form-row">

                <div class="form-group">

                    <label>Salary / Stipend</label>

                    <input type="text" name="salary" required>

                </div>

                <div class="form-group">

                    <label>Vacancies</label>

                    <input type="number" name="vacancies" min="1" required>

                </div>

            </div>

            <!-- Skills -->

            <div class="form-group">

                <label>Required Skills</label>

                <input type="text" name="skills" required>

            </div>

            <!-- Description -->

            <div class="form-group">

                <label>Description</label>

                <textarea name="description" rows="4" required></textarea>

            </div>

            <!-- Qualification -->

            <div class="form-group">

                <label>Qualification / Requirements</label>

                <textarea name="requirements" rows="3" required></textarea>

            </div>

            <!-- Deadline -->

            <div class="form-group">

                <label>Application Deadline</label>

                <input type="date" name="deadline" required>

            </div>

            <button type="submit" class="post-btn">

                Post Now

            </button>

        </form>

    </div>

</div>

</body>
</html>