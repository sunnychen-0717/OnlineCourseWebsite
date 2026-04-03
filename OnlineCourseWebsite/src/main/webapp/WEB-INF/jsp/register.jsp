<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Register - Online Course</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container mt-5 mb-5">
  <div class="row justify-content-center">
    <div class="col-md-6 col-lg-5">
      <div class="card shadow border-0">
        <div class="card-header bg-primary text-white text-center py-3">
          <h4 class="mb-0 fw-bold">Create Your Account</h4>
        </div>
        <div class="card-body p-4">

          <%-- 錯誤訊息顯示 --%>
          <c:if test="${param.error == 'exists'}">
            <div class="alert alert-danger text-center">Username already taken!</div>
          </c:if>

          <%-- 表單開始：指向 /account/register (根據你的 AccountController 路徑) --%>
          <form action="<c:url value='/account/register'/>" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="row mb-3">
              <div class="col-md-6">
                <label class="form-label fw-bold">Username</label>
                <input type="text" name="username" class="form-control" placeholder="Unique ID" required>
              </div>
              <div class="col-md-6">
                <label class="form-label fw-bold">Password</label>
                <input type="password" name="password" class="form-control" placeholder="Min 6 chars" required>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label fw-bold">Full Name</label>
              <input type="text" name="fullName" class="form-control" placeholder="Your real name" required>
            </div>

            <div class="mb-3">
              <label class="form-label fw-bold">Email Address</label>
              <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
            </div>

            <div class="mb-3">
              <label class="form-label fw-bold">Phone Number</label>
              <input type="text" name="phoneNumber" class="form-control" placeholder="e.g. 1234-5678">
            </div>

            <div class="mb-4">
              <label class="form-label fw-bold">I am a:</label>
              <select name="role" class="form-select" required>
                <option value="STUDENT">Student (View & Comment)</option>
                <option value="TEACHER">Teacher (Manage Lectures)</option>
              </select>
              <div class="form-text mt-2 text-primary small">
                <i class="bi bi-info-circle"></i> Teachers can upload and edit course materials.
              </div>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow-sm">
              Register Now
            </button>

            <hr class="my-4">

            <div class="text-center">
              <span class="text-muted">Already have an account?</span>
              <a href="<c:url value='/login'/>" class="text-decoration-none fw-bold ms-1">Login</a>
            </div>
          </form>
          <%-- 表單結束 --%>

        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>