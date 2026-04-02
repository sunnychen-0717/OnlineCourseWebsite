<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>My Voting History - Online Course</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
  <style>
    body { padding-top: 80px; background-color: #f8f9fa; }
    .card { border-radius: 12px; }
    .table thead { background-color: #f1f3f5; }
    .badge-vote { font-size: 0.9rem; padding: 0.5em 0.8em; }
  </style>
</head>
<body>

<%-- 1. 頂部導航欄 --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm fixed-top">
  <div class="container">
    <a class="navbar-brand fw-bold" href="<c:url value='/'/>">
      <i class="bi bi-book-half me-2"></i>Online Course
    </a>
  </div>
</nav>

<div class="container mt-4">
  <div class="row">

    <%-- 2. 左側選單欄 --%>
    <div class="col-md-3">
      <div class="list-group shadow-sm mb-4 border-0">
        <div class="list-group-item bg-dark text-white fw-bold">User Menu</div>

        <%-- 修正點 1：將 Home 連結獨立出來，不要包住其他連結 --%>
        <a href="<c:url value='/'/>" class="list-group-item list-group-item-action">
          <i class="bi bi-house-door me-2"></i>Home
        </a>

        <a href="<c:url value='/polls/list'/>" class="list-group-item list-group-item-action">
          <i class="bi bi-card-checklist me-2"></i>View All Polls
        </a>

        <%-- 修正點 2：My Voting History 是當前頁面，保持 active --%>
        <a href="<c:url value='/polls/history'/>" class="list-group-item list-group-item-action active">
          <i class="bi bi-clock-history me-2"></i>My Voting History
        </a>

        <%-- 修正點 3：My Comment History 獨立一行 --%>
        <a href="<c:url value='/polls/comments/history'/>" class="list-group-item list-group-item-action">
          <i class="bi bi-chat-left-text me-2"></i>My Comment History
        </a>

        <security:authorize access="hasRole('TEACHER')">
          <div class="list-group-item bg-light fw-bold small text-muted text-uppercase" style="font-size: 0.7rem;">Teacher Tools</div>
          <a href="<c:url value='/polls/create'/>" class="list-group-item list-group-item-action text-primary">
            <i class="bi bi-plus-circle-fill me-2"></i>Create New Poll
          </a>
        </security:authorize>
      </div>
    </div>

    <%-- 3. 右側內容區：投票歷史表格 --%>
    <div class="col-md-9">
      <div class="card shadow-sm border-0">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
          <h5 class="mb-0 fw-bold">
            <i class="bi bi-person-check text-primary me-2"></i>Voting History for ${username}
          </h5>
          <span class="badge bg-secondary rounded-pill">${votes.size()} records</span>
        </div>
        <div class="card-body">
          <c:choose>
            <c:when test="${empty votes}">
              <div class="text-center py-5">
                <i class="bi bi-clipboard-x h1 text-muted"></i>
                <p class="mt-3 text-muted">You haven't participated in any polls yet.</p>
                <a href="<c:url value='/polls/list'/>" class="btn btn-primary">
                  Browse Available Polls
                </a>
              </div>
            </c:when>
            <c:otherwise>
              <div class="table-responsive">
                <table class="table table-hover align-middle">
                  <thead>
                  <tr>
                    <th style="width: 50%;">Poll Topic</th>
                    <th style="width: 30%;">Your Selection</th>
                    <th style="width: 20%;" class="text-center">Action</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:forEach var="v" items="${votes}">
                    <tr>
                        <%-- 欄位 1: 投票題目 (處理 Poll 可能被刪除的情況) --%>
                      <td class="fw-bold">
                        <i class="bi bi-question-circle text-primary me-2"></i>
                        <c:choose>
                          <c:when test="${not empty v.poll}">
                            <c:out value="${v.poll.question}" />
                          </c:when>
                          <c:otherwise>
                                                            <span class="text-muted fst-italic">
                                                                (Deleted Poll #${v.pollId})
                                                            </span>
                          </c:otherwise>
                        </c:choose>
                      </td>

                        <%-- 欄位 2: 選擇的選項 --%>
                      <td>
                                                    <span class="badge bg-info text-dark badge-vote">
                                                        <i class="bi bi-check2-circle me-1"></i>
                                                        <c:out value="${v.option.text}" />
                                                    </span>
                      </td>

                        <%-- 欄位 3: 操作按鈕 --%>
                      <td class="text-center">
                        <c:if test="${not empty v.poll}">
                          <a href="<c:url value='/polls/${v.pollId}'/>"
                             class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-eye"></i> View
                          </a>
                        </c:if>
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

      <p class="text-center text-muted mt-4 small">
        Records are sorted by date (newest first).
      </p>
    </div>

  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>