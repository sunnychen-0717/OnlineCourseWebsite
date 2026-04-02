<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Create New Poll - Online Course</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card shadow border-0">
        <div class="card-header bg-primary text-white py-3">
          <h4 class="mb-0"><i class="bi bi-plus-circle me-2"></i>Create a New Poll</h4>
        </div>
        <div class="card-body p-4">
          <form action="<c:url value='/polls/save'/>" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="mb-4">
              <label for="question" class="form-label fw-bold">Poll Question</label>
              <input type="text" class="form-control form-control-lg" id="question" name="question"
                     placeholder="e.g., Which topic should be introduced next?" required>
              <div class="form-text">Enter the main question for your students.</div>
            </div>

            <hr>

            <div class="mb-3">
              <label class="form-label fw-bold text-secondary">Multiple Choice Options (Exactly 5)</label>

              <div class="input-group mb-2">
                <span class="input-group-text">1</span>
                <input type="text" name="optionTexts" class="form-control" placeholder="Option 1" required>
              </div>

              <div class="input-group mb-2">
                <span class="input-group-text">2</span>
                <input type="text" name="optionTexts" class="form-control" placeholder="Option 2" required>
              </div>

              <div class="input-group mb-2">
                <span class="input-group-text">3</span>
                <input type="text" name="optionTexts" class="form-control" placeholder="Option 3" required>
              </div>

              <div class="input-group mb-2">
                <span class="input-group-text">4</span>
                <input type="text" name="optionTexts" class="form-control" placeholder="Option 4" required>
              </div>

              <div class="input-group mb-2">
                <span class="input-group-text">5</span>
                <input type="text" name="optionTexts" class="form-control" placeholder="Option 5" required>
              </div>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
              <a href="<c:url value='/'/>" class="btn btn-outline-secondary">Cancel</a>
              <button type="submit" class="btn btn-primary px-5">Publish Poll</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

</body>
</html>