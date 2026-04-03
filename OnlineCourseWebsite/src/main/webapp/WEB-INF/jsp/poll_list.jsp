<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Polls - Online Course System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body { padding-top: 80px; background-color: #f8f9fa; }
        .card { border-radius: 12px; }
        .list-group-item.active { background-color: #0d6efd; border-color: #0d6efd; }
    </style>
</head>
<body>

<%-- 導航欄 --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm fixed-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="<c:url value='/'/>">
            <i class="bi bi-book-half me-2"></i>Online Course
        </a>
    </div>
</nav>

<div class="container mt-4">
    <div class="row">

        <%-- 左側菜單欄 --%>
            <div class="col-md-3">
                <div class="list-group shadow-sm mb-4 border-0">
                    <div class="list-group-item bg-dark text-white fw-bold">Main Menu</div>

                    <a href="<c:url value='/'/>" class="list-group-item list-group-item-action">
                        <i class="bi bi-house-door me-2"></i>Back to Home
                    </a>

                    <a href="<c:url value='/polls/list'/>" class="list-group-item list-group-item-action active">
                        <i class="bi bi-card-checklist me-2"></i>View All Polls
                    </a>

                    <%-- 投票歷史 --%>
                    <a href="<c:url value='/polls/history'/>" class="list-group-item list-group-item-action">
                        <i class="bi bi-clock-history me-2"></i>My Voting History
                    </a>

                    <%-- 評論歷史 --%>
                    <a href="<c:url value='/polls/comments/history'/>" class="list-group-item list-group-item-action">
                        <i class="bi bi-chat-left-text me-2"></i>My Comment History
                    </a>

                    <security:authorize access="hasRole('TEACHER')">
                        <div class="list-group-item bg-light fw-bold small text-muted text-uppercase" style="font-size: 0.7rem; letter-spacing: 1px; margin-top: 5px;">Teacher Tools</div>
                        <a href="<c:url value='/polls/create'/>" class="list-group-item list-group-item-action text-primary">
                            <i class="bi bi-plus-circle-fill me-2"></i>Create New Poll
                        </a>
                    </security:authorize>
                </div>
            </div>

        <%-- 右側內容區 --%>
        <div class="col-md-9">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold text-dark">
                        <i class="bi bi-card-checklist text-primary me-2"></i>Available Polls
                    </h5>
                    <%-- 額外在右上方也放一個返回按鈕，增加便利性 --%>
                    <a href="<c:url value='/'/>" class="btn btn-sm btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Home
                    </a>
                </div>
                <div class="card-body p-0"> <%-- p-0 讓清單與邊框貼齊更美觀 --%>
                    <div class="list-group list-group-flush">
                        <c:choose>
                            <c:when test="${empty polls}">
                                <div class="p-5 text-center text-muted">
                                    <i class="bi bi-inbox h1 d-block"></i>
                                    No polls available at the moment.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="p" items="${polls}">
                                    <a href="<c:url value='/polls/${p.id}'/>"
                                       class="list-group-item list-group-item-action py-3 d-flex justify-content-between align-items-center">
                                        <div class="fw-medium">${p.question}</div>
                                        <div class="d-flex align-items-center">
                                            <span class="badge bg-light text-primary border border-primary rounded-pill me-3">
                                                ${p.options.size()} Options
                                            </span>
                                            <i class="bi bi-chevron-right text-muted"></i>
                                        </div>
                                    </a>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <%-- 底部裝飾或資訊 --%>
            <p class="text-center text-muted mt-4 small">
                &copy; 2026 Online Course System - Student Participation Portal
            </p>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>