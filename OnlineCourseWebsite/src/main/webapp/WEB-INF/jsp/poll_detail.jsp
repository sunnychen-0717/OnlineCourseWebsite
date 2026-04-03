<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Poll Detail - Online Course</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
  <style>
    body { background-color: #f8f9fa; }
    .poll-card { border-radius: 15px; }
    .vote-badge { font-size: 0.8rem; }
    .edit-section { background-color: #fff3cd; border: 1px solid #ffeeba; padding: 15px; border-radius: 10px; }
  </style>
</head>
<body>

<div class="container mt-5 mb-5">
  <a href="<c:url value='/polls/list'/>" class="btn btn-link text-decoration-none mb-3">
    <i class="bi bi-arrow-left"></i> Back to Polls
  </a>

  <div class="row">
    <div class="col-md-8 mx-auto">

      <%-- 1. 投票與編輯區塊 --%>
      <div class="card shadow-sm poll-card mb-4">
        <div class="card-body p-4">

          <%-- 標題展示模式 --%>
          <div id="poll-view-container">
            <div class="d-flex justify-content-between align-items-start mb-4">
              <h2 class="h4 fw-bold mb-0">${poll.question}</h2>
              <sec:authorize access="hasRole('TEACHER')">
                <div class="btn-group">
                  <button class="btn btn-sm btn-outline-primary" onclick="togglePollEdit(true)">
                    <i class="bi bi-pencil"></i> Edit Poll
                  </button>
                  <form action="<c:url value='/polls/${poll.id}/delete'/>" method="post"
                        onsubmit="return confirm('Delete this poll and all associated data?')">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-sm btn-outline-danger ms-1">
                      <i class="bi bi-trash"></i> Delete
                    </button>
                  </form>
                </div>
              </sec:authorize>
            </div>

            <%-- 投票表單 --%>
            <form action="<c:url value='/polls/${poll.id}/vote'/>" method="post">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              <c:forEach var="opt" items="${poll.options}">
                <div class="form-check p-3 border rounded mb-2 bg-white shadow-sm">
                  <input class="form-check-input ms-0 me-3" type="radio" name="optionId"
                         id="opt${opt.id}" value="${opt.id}"
                    ${existingVote.option.id == opt.id ? 'checked' : ''} required>
                  <label class="form-check-label d-flex justify-content-between align-items-center w-100" for="opt${opt.id}">
                    <span class="fw-medium">${opt.text}</span>
                    <span class="badge bg-primary rounded-pill vote-badge">${opt.voteCount} votes</span>
                  </label>
                </div>
              </c:forEach>
              <div class="d-grid mt-4">
                <button type="submit" class="btn btn-success btn-lg">
                  <i class="bi bi-check-lg"></i>
                  ${existingVote != null ? 'Update My Vote' : 'Submit My Vote'}
                </button>
              </div>
            </form>
          </div>

          <%-- 整個投票的編輯模式 (整合題目與選項) --%>
          <sec:authorize access="hasRole('TEACHER')">
            <div id="poll-edit-container" style="display:none;" class="edit-section mb-4">
              <h5 class="fw-bold text-warning-emphasis mb-3">Edit Mode</h5>
              <form action="<c:url value='/polls/${poll.id}/edit'/>" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="mb-3">
                  <label class="form-label fw-bold">Poll Question:</label>
                  <input type="text" name="question" class="form-control" value="${poll.question}" required>
                </div>

                <div class="mb-3">
                  <label class="form-label fw-bold small">Edit Options:</label>
                  <c:forEach var="opt" items="${poll.options}" varStatus="status">
                    <div class="input-group mb-2">
                      <span class="input-group-text">#${status.count}</span>
                      <input type="hidden" name="optionIds" value="${opt.id}">
                      <input type="text" name="optionTexts" class="form-control" value="${opt.text}" required>
                    </div>
                  </c:forEach>
                </div>

                <div class="pt-2 border-top">
                  <button type="submit" class="btn btn-primary">Save All Changes</button>
                  <button type="button" class="btn btn-secondary" onclick="togglePollEdit(false)">Cancel</button>
                </div>
              </form>
            </div>
          </sec:authorize>

        </div>
      </div>

      <%-- 2. 評論區塊 (保持不變) --%>
      <div class="card shadow-sm poll-card">
        <div class="card-body p-4">
          <h5 class="fw-bold mb-4"><i class="bi bi-chat-left-text me-2"></i>Comments</h5>

          <c:choose>
            <c:when test="${empty comments}">
              <p class="text-muted italic">No comments yet. Be the first to share your thoughts!</p>
            </c:when>
            <c:otherwise>
              <c:forEach var="c" items="${comments}">
                <div class="d-flex mb-3">
                  <div class="flex-shrink-0">
                    <i class="bi bi-person-circle h3 text-secondary"></i>
                  </div>
                  <div class="ms-3 bg-light p-3 rounded-3 w-100">
                    <div id="view-container-${c.id}">
                      <div class="d-flex justify-content-between align-items-start">
                        <span class="fw-bold text-primary">${c.user.username}</span>
                        <sec:authorize access="isAuthenticated()">
                          <div class="btn-group">
                            <c:if test="${pageContext.request.userPrincipal.name == c.user.username}">
                              <button class="btn btn-sm text-primary p-0 me-2" onclick="toggleEdit(${c.id}, true)">
                                <i class="bi bi-pencil-square"></i> Edit
                              </button>
                            </c:if>
                            <sec:authorize access="hasRole('TEACHER') or principal.username == '${c.user.username}'">
                              <form action="<c:url value='/polls/comment/${c.id}/delete'/>" method="post" style="display:inline;">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="pollId" value="${poll.id}">
                                <button type="submit" class="btn btn-sm text-danger p-0" onclick="return confirm('Delete comment?')">
                                  <i class="bi bi-trash"></i> Delete
                                </button>
                              </form>
                            </sec:authorize>
                          </div>
                        </sec:authorize>
                      </div>
                      <div class="text-dark mt-1">${c.content}</div>
                    </div>

                    <div id="edit-container-${c.id}" style="display: none;">
                      <form action="<c:url value='/polls/comment/${c.id}/edit'/>" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="pollId" value="${poll.id}">
                        <textarea name="content" class="form-control mb-2" required>${c.content}</textarea>
                        <button type="submit" class="btn btn-sm btn-success">Save</button>
                        <button type="button" class="btn btn-sm btn-secondary" onclick="toggleEdit(${c.id}, false)">Cancel</button>
                      </form>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </c:otherwise>
          </c:choose>

          <hr class="my-4">
          <form action="<c:url value='/polls/${poll.id}/comment'/>" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="mb-3">
              <label class="form-label fw-bold small">Leave a comment</label>
              <textarea name="content" class="form-control" rows="3" required></textarea>
            </div>
            <div class="text-end">
              <button type="submit" class="btn btn-primary px-4">Post Comment</button>
            </div>
          </form>
        </div>
      </div>

    </div>
  </div>
</div>

<script>
  function toggleEdit(id, isEditing) {
    document.getElementById('view-container-' + id).style.display = isEditing ? 'none' : 'block';
    document.getElementById('edit-container-' + id).style.display = isEditing ? 'block' : 'none';
  }

  function togglePollEdit(isEditing) {
    document.getElementById('poll-view-container').style.display = isEditing ? 'none' : 'block';
    document.getElementById('poll-edit-container').style.display = isEditing ? 'block' : 'none';
  }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>