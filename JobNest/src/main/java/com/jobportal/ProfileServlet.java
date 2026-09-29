package com.jobportal;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/ProfileServlet")
@MultipartConfig(
    maxFileSize = 10 * 1024 * 1024,
    maxRequestSize = 12 * 1024 * 1024
)
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    // ==========================================
    // GET PROFILE DATA
    // ==========================================

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("index.jsp");
            return;
        }

        int userId =
                (Integer) session.getAttribute("userId");

        try {

            Connection con =
                    DBConnection.getConnection();

            String sql =
                    "SELECT full_name, phone, work_experience, " +
                    "skills, qualification, resume, email, " +
                    "linkedin, github " +
                    "FROM profile WHERE user_id = ?";

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, userId);

            ResultSet rs =
                    ps.executeQuery();

            if (rs.next()) {

                request.setAttribute(
                    "fullName",
                    rs.getString("full_name")
                );

                request.setAttribute(
                    "phone",
                    rs.getString("phone")
                );

                request.setAttribute(
                    "workExperience",
                    rs.getString("work_experience")
                );

                request.setAttribute(
                    "skills",
                    rs.getString("skills")
                );

                request.setAttribute(
                    "qualification",
                    rs.getString("qualification")
                );

                request.setAttribute(
                    "resume",
                    rs.getString("resume")
                );

                request.setAttribute(
                    "profileEmail",
                    rs.getString("email")
                );

                request.setAttribute(
                    "linkedin",
                    rs.getString("linkedin")
                );

                request.setAttribute(
                    "github",
                    rs.getString("github")
                );
            }

            rs.close();
            ps.close();
            con.close();

            request.getRequestDispatcher(
                "Profile.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html;charset=UTF-8");

            response.getWriter().println(
                "<h2>Profile Load Error</h2>"
            );

            response.getWriter().println(
                "<p>" + e.getMessage() + "</p>"
            );
        }
    }


    // ==========================================
    // SAVE / UPDATE PROFILE
    // ==========================================

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("index.jsp");
            return;
        }

        int userId =
                (Integer) session.getAttribute("userId");

        try {

            String fullName =
                    request.getParameter("full_name");

            String phone =
                    request.getParameter("phone");

            String workExperience =
                    request.getParameter("work_experience");

            String skills =
                    request.getParameter("skills");

            String qualification =
                    request.getParameter("qualification");

            String email =
                    request.getParameter("email");

            String linkedin =
                    request.getParameter("linkedin");

            String github =
                    request.getParameter("github");


            // ==========================================
            // RESUME
            // ==========================================

            Part resumePart =
                    request.getPart("resume");

            String resumeFileName = null;

            if (resumePart != null &&
                resumePart.getSize() > 0) {

                String originalFileName =
                        Paths.get(
                            resumePart.getSubmittedFileName()
                        )
                        .getFileName()
                        .toString();

                resumeFileName =
                        userId + "_" +
                        System.currentTimeMillis() +
                        "_" +
                        originalFileName;

                String uploadPath =
                        getServletContext()
                        .getRealPath("/uploads");

                File uploadFolder =
                        new File(uploadPath);

                if (!uploadFolder.exists()) {
                    uploadFolder.mkdirs();
                }

                File saveFile =
                        new File(
                            uploadFolder,
                            resumeFileName
                        );

                resumePart.write(
                    saveFile.getAbsolutePath()
                );
            }


            // ==========================================
            // DATABASE
            // ==========================================

            Connection con =
                    DBConnection.getConnection();


            // Check existing profile
            String checkSQL =
                    "SELECT profile_id, resume " +
                    "FROM profile WHERE user_id = ?";

            PreparedStatement checkPS =
                    con.prepareStatement(checkSQL);

            checkPS.setInt(1, userId);

            ResultSet rs =
                    checkPS.executeQuery();


            // ==========================================
            // UPDATE
            // ==========================================

            if (rs.next()) {

                String oldResume =
                        rs.getString("resume");

                if (resumeFileName == null) {
                    resumeFileName = oldResume;
                }

                String updateSQL =
                        "UPDATE profile SET " +
                        "full_name=?, " +
                        "phone=?, " +
                        "work_experience=?, " +
                        "skills=?, " +
                        "qualification=?, " +
                        "resume=?, " +
                        "email=?, " +
                        "linkedin=?, " +
                        "github=? " +
                        "WHERE user_id=?";

                PreparedStatement ps =
                        con.prepareStatement(updateSQL);

                ps.setString(1, fullName);
                ps.setString(2, phone);
                ps.setString(3, workExperience);
                ps.setString(4, skills);
                ps.setString(5, qualification);
                ps.setString(6, resumeFileName);
                ps.setString(7, email);
                ps.setString(8, linkedin);
                ps.setString(9, github);
                ps.setInt(10, userId);

                ps.executeUpdate();

                ps.close();
            }


            // ==========================================
            // INSERT
            // ==========================================

            else {

                String insertSQL =
                        "INSERT INTO profile " +
                        "(user_id, full_name, phone, " +
                        "work_experience, skills, qualification, " +
                        "resume, email, linkedin, github) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                PreparedStatement ps =
                        con.prepareStatement(insertSQL);

                ps.setInt(1, userId);
                ps.setString(2, fullName);
                ps.setString(3, phone);
                ps.setString(4, workExperience);
                ps.setString(5, skills);
                ps.setString(6, qualification);
                ps.setString(7, resumeFileName);
                ps.setString(8, email);
                ps.setString(9, linkedin);
                ps.setString(10, github);

                ps.executeUpdate();

                ps.close();
            }


            rs.close();
            checkPS.close();
            con.close();


            // Update session details too
            session.setAttribute("name", fullName);
            session.setAttribute("phone", phone);
            session.setAttribute("email", email);


            response.sendRedirect(
                "ProfileServlet"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType(
                "text/html;charset=UTF-8"
            );

            response.getWriter().println(
                "<h2>Profile Save Error</h2>"
            );

            response.getWriter().println(
                "<p>" + e.getMessage() + "</p>"
            );
        }
    }
}