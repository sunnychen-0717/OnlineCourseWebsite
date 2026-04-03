<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>My Comment History - Online Course</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
  <style>
    body { padding-top: 80px; background-color: #f8f9fa; }
    .card { border-radius: 12px; }
    /* 優化留言內容的顯示樣式 */
    .comment-text { background-color: #f1f3f5; padding: 10px; border-radius: 8px; border-left: 4px solid #0d6efd; }
    .badge-source { font-size: 0.7rem; text-transform: uppercase; margin-bottom: 5px; display: inline-block; }
  </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm fixed-top">
  <div class="container">
    <a class="navbar-brand fw-bold" href="<c:url value='/'/>">
      <i class="bi bi-book"></i> Online Course
    </a>
  </div>
</nav>

<div class="container mt-4">
  <div class="row">
    <%-- 左側選單：保持一致性 --%>
    <div class="col-md-3">
      <div class="list-group shadow-sm border-0">
        <div class="list-group-item bg-dark text-white fw-bold">User Menu</div>
        <a href="<c:url value='/'/>" class="list-group-item list-group-item-action">
          <i class="bi bi-house-door me-2"></i>Home
        </a>
        <a href="<c:url value='/polls/list'/>" class="list-group-item list-group-item-action">
          <i class="bi bi-card-checklist me-2"></i>View All Polls
        </a>
        <a href="<c:url value='/polls/history'/>" class="list-group-item list-group-item-action">
          <i class="bi bi-clock-history me-2"></i>My Voting History
        </a>
        <a href="<c:url value='/polls/comments/history'/>" class="list-group-item list-group-item-action active">
          <i class="bi bi-chat-left-text me-2"></i>My Comment History
        </a>
      </div>
    </div>

    <%-- 右側內容 --%>
    <div class="col-md-9">
      <div class="card shadow-sm border-0">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
          <h5 class="mb-0 fw-bold">
            <i class="bi bi-chat-quote text-primary me-2"></i>Comments by ${username}
          </h5>
          <span class="badge bg-secondary rounded-pill">${comments.size()} comments</span>
        </div>
        <div class="card-body p-0"> <%-- 使用 p-0 讓表格貼合卡片 --%>
          <c:choose>
            <c:when test="${empty comments}">
              <div class="text-center py-5 text-muted">
                <i class="bi bi-chat-square-dots h1"></i>
                <p class="mt-3">You haven't posted any comments yet.</p>
              </div>
            </c:when>
            <c:otherwise>
              <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                  <thead class="table-light">
                  <tr>
                    <th style="width: 30%;" class="ps-4">Source & Topic</th>
                    <th style="width: 50%;">Comment Content</th>
                    <th style="width: 20%;" class="text-center">Action</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:forEach var="c" items="${comments}">
                    <tr>
                      <td class="ps-4">
                        <c:choose>
                          <%-- 判斷是否為投票留言 --%>
                          <c:when test="${not empty c.poll}">
                            <span class="badge bg-info text-dark badge-source">Poll</span>
                            <div class="fw-bold text-dark">${c.poll.question}</div>
                          </c:when>
                          <%-- 判斷是否為課程留言 --%>
                          <c:when test="${not empty c.lecture}">
                            <span class="badge bg-success badge-source">Lecture</span>
                            <div class="fw-bold text-dark">${c.lecture.title}</div>
                          </c:when>
                          <c:otherwise>
                            <span class="badge bg-light text-muted badge-source">Unknown</span>
                            <div class="text-muted italic small">Original content deleted</div>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <div class="comment-text small text-dark">
                          <c:out value="${c.content}" />
                        </div>
                      </td>
                      <td class="text-center">
                          <%-- 動態連結：根據來源跳轉到不同頁面 --%>
                        <c:choose>
                          <c:when test="${not empty c.poll}">
                            <a href="<c:url value='/polls/${c.poll.id}'/>" class="btn btn-sm btn-outline-primary">
                              <i class="bi bi-eye"></i> View Poll
                            </a>
                          </c:when>
                          <c:when test="${not empty c.lecture}">
                            <a href="<c:url value='/lectures/view/${c.lecture.id}'/>" class="btn btn-sm btn-outline-success">
                              <i class="bi bi-book"></i> View Course
                            </a>
                          </c:when>
                        </c:choose>
                      </td>
                    </tr>
                  </c:forEach>
                  </tbody>
                </table>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>