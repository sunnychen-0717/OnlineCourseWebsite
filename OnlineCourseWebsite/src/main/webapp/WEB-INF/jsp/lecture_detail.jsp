<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${lecture.title} - Course Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .material-item:hover { background-color: #f8f9fa; }
        .summary-text { font-size: 0.85rem; color: #6c757d; margin-top: 4px; }
        .comment-actions .btn-link { font-size: 0.85rem; padding: 0; text-decoration: none; }
        .card { border-radius: 12px; }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5 mb-5">
    <%-- Back Button --%>
    <a href="<c:url value='/'/>" class="btn btn-outline-secondary mb-4 shadow-sm">
        <i class="bi bi-arrow-left"></i> Back to Course List
    </a>

    <div class="row">
        <%-- Left Column: Course Info & Discussion --%>
        <div class="col-lg-8">
            <%-- Course Detail Card --%>
            <div class="card shadow-sm mb-4 border-0">
                <div class="card-body p-4">
                    <h1 class="display-6 fw-bold text-primary">${lecture.title}</h1>
                    <hr>
                    <h5 class="fw-bold mb-3"><i class="bi bi-info-circle"></i> Course Description</h5>
                    <p class="text-secondary" style="white-space: pre-line; line-height: 1.6;">${lecture.description}</p>

                    <c:if test="${not empty lecture.summary}">
                        <div class="mt-4 p-3 bg-light rounded">
                            <h6 class="fw-bold"><i class="bi bi-journal-text"></i> Lecture Summary</h6>
                            <p class="small mb-0">${lecture.summary}</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <%-- Discussion Area --%>
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-header bg-white py-3">
                    <h5 class="mb-0 fw-bold text-dark">Discussion (${comments.size()})</h5>
                </div>
                <div class="card-body">
                    <c:forEach var="c" items="${comments}">
                        <div class="d-flex mb-3 border-bottom pb-3">
                            <div class="flex-shrink-0">
                                <i class="bi bi-person-circle h2 text-secondary"></i>
                            </div>
                            <div class="ms-3 w-100">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="fw-bold text-dark">
                                            ${c.user.username}
                                        <small class="text-muted fw-normal ms-2">posted a comment</small>
                                    </div>

                                    <div class="comment-actions">
                                        <security:authorize access="isAuthenticated()">
                                            <c:set var="currentUsername" value="${pageContext.request.userPrincipal.name}" />

                                            <%-- Edit Button: Owner Only --%>
                                            <c:if test="${c.user.username == currentUsername}">
                                                <button class="btn btn-link text-primary me-2" onclick="showEditForm(${c.id})">
                                                    <i class="bi bi-pencil"></i> Edit
                                                </button>
                                            </c:if>

                                            <%-- Delete Button: Teacher or Owner --%>
                                            <security:authorize access="hasRole('TEACHER')">
                                                <c:set var="isTeacher" value="true" />
                                            </security:authorize>
                                            <c:if test="${c.user.username == currentUsername or isTeacher}">
                                                <form action="<c:url value='/comments/delete/${c.id}'/>" method="post" class="d-inline">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <button type="submit" class="btn btn-link text-danger" onclick="return confirm('Delete this comment?')">
                                                        <i class="bi bi-trash"></i> Delete
                                                    </button>
                                                </form>
                                            </c:if>
                                        </security:authorize>
                                    </div>
                                </div>

                                    <%-- Comment Content Display --%>
                                <div class="mt-1" id="comment-text-${c.id}">${c.content}</div>

                                    <%-- Hidden Edit Form --%>
                                <div id="edit-form-${c.id}" style="display:none;" class="mt-3">
                                        <%-- Corrected path to point to CommentController --%>
                                    <form action="<c:url value='/comments/edit/${c.id}'/>" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <%-- Required for Controller to redirect back to this lecture --%>
                                        <input type="hidden" name="lectureId" value="${lecture.id}">

                                        <textarea name="content" class="form-control mb-2" rows="2" required>${c.content}</textarea>
                                        <div class="btn-group btn-group-sm">
                                            <button type="submit" class="btn btn-success">Save</button>
                                            <button type="button" class="btn btn-secondary" onclick="hideEditForm(${c.id})">Cancel</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty comments}">
                        <div class="text-muted text-center py-4">No comments yet. Share your thoughts!</div>
                    </c:if>

                    <%-- New Comment Form --%>
                    <security:authorize access="isAuthenticated()">
                        <form action="<c:url value='/comments/add/${lecture.id}'/>" method="post" class="mt-4">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <div class="mb-3">
                                <textarea name="content" class="form-control bg-light" rows="3" placeholder="Write your thoughts..." required></textarea>
                            </div>
                            <div class="text-end">
                                <button type="submit" class="btn btn-primary px-4 shadow-sm">Post Comment</button>
                            </div>
                        </form>
                    </security:authorize>

                    <security:authorize access="!isAuthenticated()">
                        <div class="alert alert-info mt-4 text-center">
                            Please <a href="<c:url value='/login'/>">login</a> to join the discussion.
                        </div>
                    </security:authorize>
                </div>
            </div>
        </div>

        <%-- Right Column: Materials --%>
        <div class="col-lg-4">
            <div class="card shadow-sm border-0 sticky-top" style="top: 20px;">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-file-earmark-arrow-down"></i> Learning Materials</h5>
                </div>
                <div class="list-group list-group-flush">
                    <c:forEach items="${lecture.materials}" var="material">
                        <div class="list-group-item material-item py-3">
                            <div class="d-flex justify-content-between align-items-start">
                                <div class="text-truncate" style="max-width: 80%;">
                                    <i class="bi bi-file-earmark-text text-primary me-2"></i>
                                    <a href="<c:url value='/files/${material.filePath}'/>" target="_blank" class="text-decoration-none fw-bold text-dark">
                                            ${material.fileName}
                                    </a>
                                </div>
                                <a href="<c:url value='/files/${material.filePath}'/>" download class="btn btn-sm btn-outline-primary border-0">
                                    <i class="bi bi-download"></i>
                                </a>
                            </div>
                            <div class="summary-text mt-1">
                                <c:out value="${empty material.fileSummary ? 'No summary available.' : material.fileSummary}" />
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty lecture.materials}">
                        <div class="list-group-item text-muted text-center py-4">No materials uploaded.</div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function showEditForm(id) {
        document.getElementById('comment-text-' + id).style.display = 'none';
        document.getElementById('edit-form-' + id).style.display = 'block';
    }
    function hideEditForm(id) {
        document.getElementById('comment-text-' + id).style.display = 'block';
        document.getElementById('edit-form-' + id).style.display = 'none';
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>