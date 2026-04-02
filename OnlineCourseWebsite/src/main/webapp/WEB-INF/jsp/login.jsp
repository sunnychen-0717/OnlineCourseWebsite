<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>OnlineCourseWebsite - Login</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
  <style>
    body { background-color: #f8f9fa; }
    .card { border-radius: 15px; border: none; }
    .card-header { border-radius: 15px 15px 0 0 !important; }
    .btn-primary-custom { background-color: #0d6efd; border: none; }
  </style>
</head>
<body>

<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-md-5 col-lg-4">
      <div class="card shadow-lg">
        <div class="card-header bg-primary text-white text-center py-3">
          <h4 class="mb-0 fw-bold">OnlineCourseWebsite</h4>
        </div>

        <div class="card-body p-4">
          <%-- 訊息提示區 --%>
          <c:if test="${param.error != null}">
            <div class="alert alert-danger py-2 small">
              <i class="bi bi-exclamation-triangle"></i> Invalid username or password.
            </div>
          </c:if>
          <c:if test="${param.logout != null}">
            <div class="alert alert-info py-2 small">
              <i class="bi bi-info-circle"></i> You have been logged out.
            </div>
          </c:if>
          <c:if test="${param.success != null}">
            <div class="alert alert-success py-2 small">
              <i class="bi bi-check-circle"></i> Registration successful! Please login.
            </div>
          </c:if>

          <form action="<c:url value='/login'/>" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="mb-3">
              <label class="form-label fw-semibold">Username</label>
              <div class="input-group">
                <span class="input-group-text bg-light"><i class="bi bi-person"></i></span>
                <input type="text" name="username" class="form-control" placeholder="Enter username" required autofocus>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label fw-semibold">Password</label>
              <div class="input-group">
                <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                <input type="password" name="password" class="form-control" placeholder="Enter password" required>
              </div>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow-sm">Login</button>
          </form>

          <div class="text-center mt-4">
            <p class="text-muted small mb-1">Don't have an account?</p>
            <a href="<c:url value='/register'/>" class="text-decoration-none fw-bold">
              Create New Account
            </a>
          </div>
        </div>
      </div>

      <div class="text-center mt-3 text-muted">
        <small>&copy; 2026 OnlineCourseWebsite</small>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>