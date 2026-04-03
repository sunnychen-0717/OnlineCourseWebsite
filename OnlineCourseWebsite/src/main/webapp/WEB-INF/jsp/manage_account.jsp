<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow border-0">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Account Settings</h4>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty message}">
                        <div class="alert alert-success">${message}</div>
                    </c:if>

                    <form action="<c:url value='/account/update'/>" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Username</label>
                            <input type="text" class="form-control bg-secondary-subtle" value="${user.username}" readonly>
                            <div class="form-text">Username cannot be changed.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Full Name</label>
                            <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Email Address</label>
                            <input type="email" name="email" class="form-control" value="${user.email}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Phone Number</label>
                            <input type="text" name="phoneNumber" class="form-control" value="${user.phoneNumber}">
                        </div>

                        <hr>

                        <div class="mb-4">
                            <label class="form-label fw-bold">New Password</label>
                            <input type="password" name="newPassword" class="form-control" placeholder="Leave blank to keep current password">
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                            <a href="<c:url value='/'/>" class="btn btn-outline-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
