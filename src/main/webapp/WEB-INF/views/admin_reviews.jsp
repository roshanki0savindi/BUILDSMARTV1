<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<div class="row g-4">
    <!-- Admin Sidebar -->
    <div class="col-lg-3">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-navy text-white p-3 border-0" style="background: var(--navy-900);">
                <h6 class="fw-bold font-heading text-white mb-0 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-shield-halved text-primary"></i> Admin Control Panel
                </h6>
            </div>
            <div class="list-group list-group-flush p-2 gap-1">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-chart-pie me-2 text-primary"></i> Platform Analytics
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-users-gear me-2 text-primary"></i> User Management
                </a>
                <a href="${pageContext.request.contextPath}/admin/materials" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-boxes-packing me-2 text-primary"></i> Master Materials
                </a>
                <a href="${pageContext.request.contextPath}/admin/packages" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-cubes me-2 text-primary"></i> Package Bundles
                </a>
                <a href="${pageContext.request.contextPath}/admin/reviews" class="list-group-item list-group-item-action rounded-3 border-0 active fw-semibold">
                    <i class="fa-solid fa-comment-slash me-2 text-primary"></i> Moderation Queue
                </a>
            </div>
        </div>
    </div>

    <!-- Admin Main Content -->
    <div class="col-lg-9">
        <c:if test="${param.msg == 'moderated'}">
            <div class="alert alert-success rounded-3 py-2.5 px-3 mb-3"><i class="fa-solid fa-circle-check me-2"></i> Review moderation status updated successfully.</div>
        </c:if>

        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-white p-4 border-bottom">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-3">
                    <div>
                        <h4 class="fw-bold font-heading mb-0 text-navy-900"><i class="fa-solid fa-comments text-primary me-2"></i> Review Moderation Queue</h4>
                        <p class="text-slate-500 small mb-0">Approve, reject, or purge client reviews before public publication</p>
                    </div>
                </div>
                
                <!-- Review Status Tabs -->
                <ul class="nav nav-pills gap-2" id="reviewTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active rounded-pill fw-semibold py-2 px-3 small" data-bs-toggle="tab" data-bs-target="#tab-pending" type="button">
                            <i class="fa-solid fa-clock me-1 text-warning"></i> Pending Queue 
                            <span class="badge bg-warning text-dark rounded-pill ms-1">${pendingReviews.size()}</span>
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link rounded-pill fw-semibold py-2 px-3 small" data-bs-toggle="tab" data-bs-target="#tab-approved" type="button">
                            <i class="fa-solid fa-circle-check me-1 text-success"></i> Approved
                            <span class="badge bg-success rounded-pill ms-1">${approvedReviews.size()}</span>
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link rounded-pill fw-semibold py-2 px-3 small" data-bs-toggle="tab" data-bs-target="#tab-rejected" type="button">
                            <i class="fa-solid fa-circle-xmark me-1 text-danger"></i> Rejected
                            <span class="badge bg-danger rounded-pill ms-1">${rejectedReviews.size()}</span>
                        </button>
                    </li>
                </ul>
            </div>

            <div class="card-body p-0">
                <div class="tab-content" id="reviewTabsContent">
                    
                    <!-- TAB 1: PENDING REVIEWS -->
                    <div class="tab-pane fade show active" id="tab-pending" role="tabpanel">
                        <c:choose>
                            <c:when test="${not empty pendingReviews}">
                                <div class="table-custom-wrapper border-0 rounded-0">
                                    <table class="table table-custom align-middle mb-0">
                                        <thead>
                                            <tr>
                                                <th>Reviewer</th>
                                                <th>Target Entity</th>
                                                <th>Rating & Feedback</th>
                                                <th>Submitted</th>
                                                <th class="text-end">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="r" items="${pendingReviews}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar-fallback rounded-circle" style="width:34px; height:34px; font-size:0.85rem;">
                                                                ${not empty r.reviewerName ? r.reviewerName.substring(0,1) : 'A'}
                                                            </div>
                                                            <strong class="text-navy-900">${not empty r.reviewerName ? r.reviewerName : 'Anonymous'}</strong>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge badge-pill ${r.targetType == 'worker' ? 'badge-amber' : 'badge-emerald'} text-capitalize mb-1">
                                                            ${r.targetType == 'hardware_shop' ? 'Hardware Store' : 'Worker'}
                                                        </span>
                                                        <div class="fw-semibold text-slate-700 small">${r.targetName}</div>
                                                    </td>
                                                    <td>
                                                        <div class="mb-1">
                                                            <c:forEach begin="1" end="${r.rating}"><i class="fa-solid fa-star text-warning" style="font-size:0.8rem;"></i></c:forEach>
                                                            <c:forEach begin="${r.rating + 1}" end="5"><i class="fa-regular fa-star text-slate-300" style="font-size:0.8rem;"></i></c:forEach>
                                                        </div>
                                                        <div class="text-slate-700 small">${r.comment}</div>
                                                        <c:if test="${not empty r.photo}">
                                                            <img src="${pageContext.request.contextPath}/img?type=review&id=${r.reviewId}" alt="Review photo" class="img-thumbnail rounded-3 mt-1" style="max-height:60px;">
                                                        </c:if>
                                                    </td>
                                                    <td class="small text-slate-500">${r.reviewDate}</td>
                                                    <td class="text-end action-cell">
                                                        <div class="d-inline-flex gap-1">
                                                            <form action="${pageContext.request.contextPath}/admin/reviews" method="post" class="d-inline">
                                                                <input type="hidden" name="action" value="approve">
                                                                <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                                <button type="submit" class="btn btn-sm btn-success rounded-3 py-1 px-2.5 fw-semibold" title="Approve Review">
                                                                    <i class="fa-solid fa-check me-1"></i> Approve
                                                                </button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/admin/reviews" method="post" class="d-inline">
                                                                <input type="hidden" name="action" value="reject">
                                                                <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                                <button type="submit" class="btn btn-sm btn-outline-warning rounded-3 py-1 px-2.5 fw-semibold" title="Reject Review">
                                                                    <i class="fa-solid fa-ban me-1"></i> Reject
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="p-5 text-center bg-slate-50">
                                    <i class="fa-solid fa-circle-check fa-3x text-success mb-3"></i>
                                    <h5 class="fw-bold text-navy-900">Moderation queue is clean</h5>
                                    <p class="text-muted small mb-0">No pending reviews waiting for administrative review.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- TAB 2: APPROVED REVIEWS -->
                    <div class="tab-pane fade" id="tab-approved" role="tabpanel">
                        <c:choose>
                            <c:when test="${not empty approvedReviews}">
                                <div class="table-custom-wrapper border-0 rounded-0">
                                    <table class="table table-custom align-middle mb-0">
                                        <thead>
                                            <tr>
                                                <th>Reviewer</th>
                                                <th>Target Entity</th>
                                                <th>Rating & Feedback</th>
                                                <th>Submitted</th>
                                                <th class="text-end">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="r" items="${approvedReviews}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar-fallback rounded-circle" style="width:34px; height:34px; font-size:0.85rem;">
                                                                ${not empty r.reviewerName ? r.reviewerName.substring(0,1) : 'A'}
                                                            </div>
                                                            <strong class="text-navy-900">${not empty r.reviewerName ? r.reviewerName : 'Anonymous'}</strong>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge badge-pill ${r.targetType == 'worker' ? 'badge-amber' : 'badge-emerald'} text-capitalize mb-1">
                                                            ${r.targetType == 'hardware_shop' ? 'Hardware Store' : 'Worker'}
                                                        </span>
                                                        <div class="fw-semibold text-slate-700 small">${r.targetName}</div>
                                                    </td>
                                                    <td>
                                                        <div class="mb-1">
                                                            <c:forEach begin="1" end="${r.rating}"><i class="fa-solid fa-star text-warning" style="font-size:0.8rem;"></i></c:forEach>
                                                            <c:forEach begin="${r.rating + 1}" end="5"><i class="fa-regular fa-star text-slate-300" style="font-size:0.8rem;"></i></c:forEach>
                                                        </div>
                                                        <div class="text-slate-700 small">${r.comment}</div>
                                                    </td>
                                                    <td class="small text-slate-500">${r.reviewDate}</td>
                                                    <td class="text-end action-cell">
                                                        <div class="d-inline-flex gap-1">
                                                            <form action="${pageContext.request.contextPath}/admin/reviews" method="post" class="d-inline">
                                                                <input type="hidden" name="action" value="reject">
                                                                <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                                <button type="submit" class="btn btn-sm btn-outline-warning rounded-3 py-1 px-2.5 fw-semibold" title="Move to Rejected">
                                                                    <i class="fa-solid fa-ban me-1"></i> Reject
                                                                </button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/admin/reviews" method="post" class="d-inline"
                                                                  onsubmit="return confirm('Permanently delete this review from system database?');">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-3 py-1 px-2" title="Delete Review">
                                                                    <i class="fa-solid fa-trash"></i>
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="p-5 text-center bg-slate-50">
                                    <i class="fa-regular fa-star fa-3x text-slate-300 mb-3"></i>
                                    <h5 class="fw-bold text-navy-900">No approved reviews found</h5>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- TAB 3: REJECTED REVIEWS -->
                    <div class="tab-pane fade" id="tab-rejected" role="tabpanel">
                        <c:choose>
                            <c:when test="${not empty rejectedReviews}">
                                <div class="table-custom-wrapper border-0 rounded-0">
                                    <table class="table table-custom align-middle mb-0">
                                        <thead>
                                            <tr>
                                                <th>Reviewer</th>
                                                <th>Target Entity</th>
                                                <th>Rating & Feedback</th>
                                                <th>Submitted</th>
                                                <th class="text-end">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="r" items="${rejectedReviews}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar-fallback rounded-circle" style="width:34px; height:34px; font-size:0.85rem;">
                                                                ${not empty r.reviewerName ? r.reviewerName.substring(0,1) : 'A'}
                                                            </div>
                                                            <strong class="text-navy-900">${not empty r.reviewerName ? r.reviewerName : 'Anonymous'}</strong>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge badge-pill ${r.targetType == 'worker' ? 'badge-amber' : 'badge-emerald'} text-capitalize mb-1">
                                                            ${r.targetType == 'hardware_shop' ? 'Hardware Store' : 'Worker'}
                                                        </span>
                                                        <div class="fw-semibold text-slate-700 small">${r.targetName}</div>
                                                    </td>
                                                    <td>
                                                        <div class="mb-1">
                                                            <c:forEach begin="1" end="${r.rating}"><i class="fa-solid fa-star text-warning" style="font-size:0.8rem;"></i></c:forEach>
                                                            <c:forEach begin="${r.rating + 1}" end="5"><i class="fa-regular fa-star text-slate-300" style="font-size:0.8rem;"></i></c:forEach>
                                                        </div>
                                                        <div class="text-slate-700 small">${r.comment}</div>
                                                    </td>
                                                    <td class="small text-slate-500">${r.reviewDate}</td>
                                                    <td class="text-end action-cell">
                                                        <div class="d-inline-flex gap-1">
                                                            <form action="${pageContext.request.contextPath}/admin/reviews" method="post" class="d-inline">
                                                                <input type="hidden" name="action" value="approve">
                                                                <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                                <button type="submit" class="btn btn-sm btn-success rounded-3 py-1 px-2.5 fw-semibold" title="Approve Review">
                                                                    <i class="fa-solid fa-check me-1"></i> Approve
                                                                </button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/admin/reviews" method="post" class="d-inline"
                                                                  onsubmit="return confirm('Permanently delete this review?');">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-3 py-1 px-2" title="Delete Review">
                                                                    <i class="fa-solid fa-trash"></i>
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="p-5 text-center bg-slate-50">
                                    <i class="fa-solid fa-circle-xmark fa-3x text-slate-300 mb-3"></i>
                                    <h5 class="fw-bold text-navy-900">No rejected reviews in archive</h5>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
