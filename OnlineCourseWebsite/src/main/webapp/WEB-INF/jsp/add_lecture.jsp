<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Add New Lecture</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container mt-5 mb-5">
  <div class="row justify-content-center">
    <div class="col-md-9">
      <div class="card shadow border-0">
        <div class="card-header bg-success text-white py-3">
          <h4 class="mb-0 text-center">Create New Lecture</h4>
        </div>
        <div class="card-body p-4">
          <form action="<c:url value='/lectures/add'/>" method="post" enctype="multipart/form-data">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <%-- 課程基本資訊 --%>
            <div class="mb-3">
              <label class="form-label fw-bold">Lecture Title</label>
              <input type="text" name="title" class="form-control" placeholder="e.g. Java Programming" required>
            </div>

            <div class="mb-3">
              <label class="form-label fw-bold">Course Overview (Home Page Summary)</label>
              <input type="text" name="summary" class="form-control" placeholder="A brief one-line introduction..." required>
            </div>

            <div class="mb-3">
              <label class="form-label fw-bold">Full Description</label>
              <textarea name="description" class="form-control" rows="4"></textarea>
            </div>

            <hr>

            <%-- 重點：動態教材區 --%>
            <h5 class="fw-bold mb-3"><i class="bi bi-paperclip"></i> Learning Materials</h5>
            <div id="fileContainer">
              <div class="card bg-white border mb-3 file-group p-3">
                <div class="row g-3">
                  <div class="col-md-5">
                    <label class="form-label small fw-bold">Select File</label>
                    <input type="file" name="files" class="form-control" required>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label small fw-bold">Brief Summary for this note</label>
                    <input type="text" name="fileSummaries" class="form-control" placeholder="What's in this note?">
                  </div>
                  <div class="col-md-1 d-flex align-items-end">
                    <button type="button" class="btn btn-outline-danger border-0" onclick="removeFile(this)">
                      <i class="bi bi-trash"></i>
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <button type="button" class="btn btn-outline-primary btn-sm mb-4" onclick="addFileField()">
              <i class="bi bi-plus-circle"></i> Add Another Note
            </button>

            <div class="d-flex justify-content-end gap-2 mt-4">
              <a href="<c:url value='/'/>" class="btn btn-light border px-4">Cancel</a>
              <button type="submit" class="btn btn-success px-5 fw-bold">Publish Lecture</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<%-- JavaScript 處理動態新增 --%>
<script>
  function addFileField() {
    const container = document.getElementById('fileContainer');
    const newField = document.createElement('div');
    newField.className = 'card bg-white border mb-3 file-group p-3';
    newField.innerHTML = `
      <div class="row g-3">
        <div class="col-md-5">
          <label class="form-label small fw-bold">Select File</label>
          <input type="file" name="files" class="form-control" required>
        </div>
        <div class="col-md-6">
          <label class="form-label small fw-bold">Brief Summary for this note</label>
          <input type="text" name="fileSummaries" class="form-control" placeholder="What's in this note?">
        </div>
        <div class="col-md-1 d-flex align-items-end">
          <button type="button" class="btn btn-outline-danger border-0" onclick="removeFile(this)">
            <i class="bi bi-trash"></i>
          </button>
        </div>
      </div>
    `;
    container.appendChild(newField);
  }

  function removeFile(btn) {
    const groups = document.querySelectorAll('.file-group');
    if (groups.length > 1) {
      btn.closest('.file-group').remove();
    } else {
      alert("At least one file is required!");
    }
  }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>