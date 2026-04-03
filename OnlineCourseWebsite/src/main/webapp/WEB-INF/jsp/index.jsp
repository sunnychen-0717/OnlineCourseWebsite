<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Online Course System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .welcome-box { border-left: 5px solid #0d6efd; background-color: white; }
        body { padding-top: 70px; }
        .list-group-item-action:hover { background-color: #f8f9fa; }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm fixed-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="<c:url value='/'/>">
            <i class="bi bi-book"></i> Online Course
        </a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <security:authorize access="isAuthenticated()">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="<c:url value='/account/manage'/>">
                            <i class="bi bi-person-circle"></i> Manage Account
                        </a>
                    </li>
                    <li class="nav-item">
                        <form action="<c:url value='/logout'/>" method="post" class="d-inline">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button type="submit" class="btn btn-link nav-link text-white border-0" style="text-decoration:none;">
                                <i class="bi bi-box-arrow-right"></i> Logout
                            </button>
                        </form>
                    </li>
                </security:authorize>
                <security:authorize access="isAnonymous()">
                    <li class="nav-item"><a class="nav-link text-white" href="<c:url value='/login'/>">Login</a></li>
                    <li class="nav-item"><a class="btn btn-light btn-sm mt-1 ms-2" href="<c:url value='/register'/>">Register</a></li>
                </security:authorize>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="p-4 mb-4 shadow-sm rounded-3 welcome-box">
        <h1 class="h3 fw-bold text-primary mb-0">Learning Dashboard</h1>
        <security:authorize access="isAuthenticated()">
            <p class="text-muted mb-0 mt-1">
                Welcome back, <strong><security:authentication property="principal.username" /></strong>!
            </p>
        </security:authorize>
    </div>

    <div class="row">
        <div class="col-md-3">
            <div class="list-group shadow-sm mb-4 border-0">
                <div class="list-group-item bg-dark text-white fw-bold">Main Menu</div>

                <a href="<c:url value='/'/>" class="list-group-item list-group-item-action">
                    <i class="bi bi-house-door me-2"></i> View All Lectures
                </a>

                <security:authorize access="isAuthenticated()">
                    <a href="<c:url value='/polls/list'/>" class="list-group-item list-group-item-action">
                        <i class="bi bi-card-checklist me-2 text-info"></i> View All Polls
                    </a>
                    <%-- 修正這裡：改用 list-group-item-action 樣式 --%>
                    <a href="<c:url value='/polls/comments/history'/>" class="list-group-item list-group-item-action">
                        <i class="bi bi-chat-dots me-2 text-primary"></i> My Comment History
                    </a>
                </security:authorize>

                <security:authorize access="hasRole('TEACHER')">
                    <div class="list-group-item bg-light fw-bold small text-uppercase text-muted">Teacher Tools</div>

                    <a href="<c:url value='/polls/create'/>" class="list-group-item list-group-item-action">
                        <i class="bi bi-plus-circle-dotted me-2 text-primary"></i> Create New Poll
                    </a>

                    <a href="<c:url value='/lectures/add'/>" class="list-group-item list-group-item-action">
                        <i class="bi bi-plus-circle me-2 text-success"></i> Add New Lecture
                    </a>
                    <a href="<c:url value='/admin/users'/>" class="list-group-item list-group-item-action">
                        <i class="bi bi-people me-2 text-warning"></i> User Management
                    </a>
                </security:authorize>
            </div>
        </div>

        <div class="col-md-9">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-journal-text me-2"></i>Available Courses</h5>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty lectures}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-inbox h1"></i>
                                <p class="mt-2">No courses available yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                    <tr>
                                        <th class="ps-4">Course Title</th>
                                        <th>Summary</th>
                                        <security:authorize access="hasRole('TEACHER')"><th class="text-center">Actions</th></security:authorize>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${lectures}" var="lecture">
                                        <tr>
                                            <td class="ps-4">
                                                <a href="<c:url value='/lectures/view/${lecture.id}'/>" class="text-decoration-none fw-bold text-dark">
                                                        ${lecture.title}
                                                </a>
                                            </td>
                                            <td><span class="text-muted small">${lecture.summary}</span></td>
                                            <security:authorize access="hasRole('TEACHER')">
                                                <td class="text-center">
                                                    <div class="btn-group btn-group-sm">
                                                        <a href="<c:url value='/lectures/edit/${lecture.id}'/>" class="btn btn-outline-primary">Edit</a>
                                                        <a href="<c:url value='/lectures/delete/${lecture.id}'/>" class="btn btn-outline-danger" onclick="return confirm('Delete?')">Delete</a>
                                                    </div>
                                                </td>
                                            </security:authorize>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>