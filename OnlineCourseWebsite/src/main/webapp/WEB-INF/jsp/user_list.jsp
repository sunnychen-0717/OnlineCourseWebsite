<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Account Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">

    <%-- 顯示刪除成功的提示 (配合 Controller 的 redirect) --%>
    <c:if test="${param.deleted != null}">
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            User account has been successfully deleted.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="card shadow">
        <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
            <h4 class="mb-0">All Registered Accounts</h4>
            <a href="<c:url value='/'/>" class="btn btn-sm btn-outline-light">Back to Home</a>
        </div>
        <div class="card-body p-0"> <%-- p-0 讓表格貼齊邊框更專業 --%>
            <table class="table table-striped table-hover mb-0">
                <thead class="table-secondary">
                <tr>
                    <th class="ps-3">ID</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Role</th>
                    <th class="text-center">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${users}" var="user">
                    <tr>
                        <td class="ps-3">${user.id}</td>
                        <td><strong>${user.username}</strong></td>
                        <td>${user.fullName}</td>
                        <td>
                                <%-- 根據角色顯示不同顏色 --%>
                            <c:choose>
                                <c:when test="${user.role == 'ROLE_TEACHER'}">
                                    <span class="badge bg-danger">Teacher</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-info text-dark">Student</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                                <%-- 刪除按鈕，包含防誤點確認 --%>
                            <a href="<c:url value='/admin/users/delete/${user.id}'/>"
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('Are you sure you want to delete user: ${user.username}?');">
                                Delete
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- 引入 Bootstrap JS (為了讓 alert 的關閉按鈕有用) --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>