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
        .file-item { transition: all 0.2s; border-bottom: 1px solid #eee; }
        .file-item:last-child { border-bottom: none; }
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
                    <%-- 注意：enctype="multipart/form-data" 是必須的 --%>
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

                        <%-- --- 1. 編輯現有教材區域 --- --%>
                        <h5 class="fw-bold mb-3 text-secondary">Existing Materials (Edit Summaries)</h5>
                        <div class="card border mb-4">
                            <div class="list-group list-group-flush">
                                <c:forEach var="m" items="${lecture.materials}">
                                    <div class="list-group-item p-3 file-item">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <span class="fw-bold text-dark"><i class="bi bi-file-earmark-text"></i> ${m.fileName}</span>
                                            <a href="<c:url value='/lectures/material/delete/${m.id}'/>"
                                               class="btn btn-sm btn-outline-danger border-0"
                                               onclick="return confirm('Permanently delete this file?')">
                                                <i class="bi bi-trash"></i> Remove
                                            </a>
                                        </div>

                                            <%-- 關鍵：傳送 ID 和新的摘要內容給 Controller --%>
                                        <input type="hidden" name="existingMaterialIds" value="${m.id}">
                                        <div class="input-group input-group-sm">
                                            <span class="input-group-text">Summary</span>
                                            <textarea name="existingSummaries" class="form-control" rows="1">${m.fileSummary}</textarea>
                                        </div>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty lecture.materials}">
                                    <div class="p-4 text-center text-muted italic">No materials uploaded yet.</div>
                                </c:if>
                            </div>
                        </div>

                        <hr class="my-4">

                        <%-- --- 2. 上傳新教材區域 --- --%>
                        <h5 class="fw-bold mb-3 text-success">Upload New Notes</h5>
                        <div id="file-container">
                            <div class="card bg-light border-0 mb-3">
                                <div class="card-body p-3">
                                    <div class="row g-2">
                                        <div class="col-md-5">
                                            <input type="file" name="files" class="form-control">
                                        </div>
                                        <div class="col-md-7">
                                            <input type="text" name="fileSummaries" class="form-control" placeholder="Brief summary for this new file...">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <button type="button" class="btn btn-sm btn-outline-secondary mb-4" onclick="addNewFileInput()">
                            <i class="bi bi-plus-circle"></i> Add More File Field
                        </button>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg shadow-sm">Update Course</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 動態新增檔案欄位
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
                        <input type="text" name="fileSummaries" class="form-control" placeholder="Brief summary for this new file...">
                    </div>
                </div>
            </div>
        `;
        container.appendChild(newRow);
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
