<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Application Details</title>
<link rel="stylesheet" href="applications.css">
</head>
<body>

<div class="container">

<div class="card">

<div class="type"><%=request.getAttribute("type")%></div>

<h1><%=request.getAttribute("jobTitle")%></h1>

<h3><%=request.getAttribute("company")%></h3>

<p>Status: <b><%=request.getAttribute("status")%></b></p>

<p>Applied On: <%=request.getAttribute("date")%></p>

<a href="Application.jsp" class="btn">← Back</a>

</div>

</div>

</body>
</html>