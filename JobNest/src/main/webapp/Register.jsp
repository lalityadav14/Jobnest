<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>JobNest - Register</title>
    <link rel="stylesheet" href="Register.css">
</head>

<body>

    <div class="logo">
        Job<strong>Nest</strong>
    </div>

    <div class="box">

        <h2>Register</h2>

        <form action="RegisterServlet" method="post">

            <label>Full Name</label>
            <input type="text"
                   name="name"
                   placeholder="Enter your name"
                   required>

            <label>Email</label>
            <input type="email"
                   name="email"
                   placeholder="Enter your email"
                   required>

            <label>Phone Number</label>
            <input type="tel"
                   name="phone"
                   placeholder="Enter 10 digit number"
                   pattern="[0-9]{10}"
                   required>

            <label>Account Type</label>
            <select name="role" required>
                <option value="">Select</option>
                <option value="jobseeker">Job Seeker</option>
                <option value="employer">Employer</option>
            </select>

            <label>Password</label>
            <input type="password"
                   name="password"
                   placeholder="Create password"
                   required>

            <label>Confirm Password</label>
            <input type="password"
                   name="confirmPassword"
                   placeholder="Confirm password"
                   required>

            <button type="submit" class="btn">
                Register
            </button>

        </form>

        <div class="login">
            Already have an account?
            <a href="index.jsp">Login</a>
        </div>

    </div>

</body>
</html>