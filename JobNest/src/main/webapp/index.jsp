<!DOCTYPE html>
<html lang="en">

<head>

    <head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Login - JobNest</title>

    <link rel="stylesheet" href="login.css">

</head>

</head>


<body>

    <div class="auth-container">

        <div class="auth-box">

            <div class="auth-logo">

                <h1>Job<span>Nest</span></h1>

                <p>Login to your account</p>

            </div>


           <form action="Loginservlet" method="post">

                <div class="form-group">

                    <label>Email</label>

                    <input type="email"
                           name="email"
                           placeholder="Enter your email"
                           required>

                </div>


                <div class="form-group">

                    <label>Password</label>

                    <input type="password"
                           name="password"
                           placeholder="Enter your password"
                           required>

                </div>


                <div class="forgot-password">

                    <a href="#">Forgot Password?</a>

                </div>


                <button type="submit"
                        class="auth-btn">

                    Login

                </button>

            </form>


            <div class="auth-footer">

                Don't have an account?

                <a href="Register.jsp">
                    Create Account
                </a>

            </div>

        </div>

    </div>

</body>

</html>