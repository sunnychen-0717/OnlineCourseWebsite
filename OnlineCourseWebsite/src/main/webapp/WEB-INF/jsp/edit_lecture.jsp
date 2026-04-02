<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Lecture - ${lecture.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .card { border: none; border-radius: 15px; }
        .file-item { transition: all 0.2s; }
        .file-item:hover { background-color: #f8f9fa; }
    </style>
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <a href="<c:url value='/'/>" class="btn btn-link text-decoration-none mb-3">
                <i class="bi bi-arrow-left"></i> Back to Course List
            </a>

            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white p-4">
                    <h2 class="h4 mb-0">Edit Course Content</h2>
                </div>

                <div class="card-body p-4">
                    <form action="<c:url value='/lectures/edit/${lecture.id}'/>" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Course Title</label>
                            <input type="text" name="title" class="form-control" value="${lecture.title}" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Brief Summary</label>
                            <input type="text" name="summary" class="form-control" value="${lecture.summary}">
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Detailed Description</label>
                            <textarea name="description" class="form-control" rows="4">${lecture.description}</textarea>
                        </div>

                        <hr class="my-4">

                        <h5 class="fw-bold mb-3 text-secondary">Existing Materials</h5>
                        <div class="list-group mb-4">
                            <c:forEach var="m" items="${lecture.materials}">
                                <div class="list-group-item d-flex justify-content-between align-items-center file-item">
                                    <div>
                                        <i class="bi bi-file-earmark-text text-primary me-2"></i>
                                        <strong>${m.fileName}</strong>
                                        <div class="small text-muted">Summary: ${m.fileSummary}</div>
                                    </div>
                                    <a href="<c:url value='/lectures/material/delete/${m.id}'/>"
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Delete this note?')">
                                        <i class="bi bi-trash"></i> Delete
                                    </a>
                                </div>
                            </c:forEach>
                        </div>

                        <hr class="my-4">

                        <h5 class="fw-bold mb-3 text-success">Upload New Notes</h5>

                        <div id="file-container">
                            <div class="card bg-light border-0 mb-3">
                                <div class="card-body p-3">
                                    <div class="row g-2">
                                        <div class="col-md-5">
                                            <input type="file" name="files" class="form-control">
                                        </div>
                                        <div class="col-md-7">
                                            <input type="text" name="fileSummaries" class="form-control" placeholder="Add a brief summary...">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <button type="button" class="btn btn-sm btn-outline-secondary mb-4" onclick="addNewFileInput()">
                            <i class="bi bi-plus-circle"></i> Add More File Field
                        </button>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">Update Course</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function addNewFileInput() {
        const container = document.getElementById('file-container');
        const newRow = document.createElement('div');
        newRow.className = 'card bg-light border-0 mb-3';
        newRow.innerHTML = `
        <div class="card-body p-3">
            <div class="row g-2">
                <div class="col-md-5">
                    <input type="file" name="files" class="form-control">
                </div>
                <div class="col-md-7">
                    <input type="text" name="fileSummaries" class="form-control" placeholder="Add a brief summary...">
                </div>
            </div>
        </div>
    `;
        container.appendChild(newRow);
    }
</script>

</body>
</html>