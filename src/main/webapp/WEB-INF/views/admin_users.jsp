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
                <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action rounded-3 border-0 active fw-semibold">
                    <i class="fa-solid fa-users-gear me-2 text-primary"></i> User Management
                </a>
                <a href="${pageContext.request.contextPath}/admin/materials" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-boxes-packing me-2 text-primary"></i> Master Materials
                </a>
                <a href="${pageContext.request.contextPath}/admin/packages" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-cubes me-2 text-primary"></i> Package Bundles
                </a>
                <a href="${pageContext.request.contextPath}/admin/reviews" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-comment-slash me-2 text-primary"></i> Moderation Queue
                </a>
            </div>
        </div>
    </div>

    <!-- Admin Main Content -->
    <div class="col-lg-9">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-white p-4 border-bottom">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-3">
                    <div>
                        <h4 class="fw-bold font-heading mb-0 text-navy-900"><i class="fa-solid fa-users-gear text-primary me-2"></i> User Directory & Approvals</h4>
                        <p class="text-slate-500 small mb-0">Approve worker/shop applications, manage roles, and enforce platform governance</p>
                    </div>
                </div>
                
                <!-- Role Tabs -->
                <ul class="nav nav-pills gap-2" id="userRoleTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active rounded-pill fw-semibold py-2 px-3 small" data-bs-toggle="tab" data-bs-target="#tab-all" type="button">All Accounts</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link rounded-pill fw-semibold py-2 px-3 small" data-bs-toggle="tab" data-bs-target="#tab-workers" type="button"><i class="fa-solid fa-hard-hat me-1"></i> Workers</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link rounded-pill fw-semibold py-2 px-3 small" data-bs-toggle="tab" data-bs-target="#tab-shops" type="button"><i class="fa-solid fa-store me-1"></i> Hardware Stores</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link rounded-pill fw-semibold py-2 px-3 small" data-bs-toggle="tab" data-bs-target="#tab-homeowners" type="button"><i class="fa-solid fa-house-user me-1"></i> Homeowners</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link rounded-pill fw-semibold py-2 px-3 small" data-bs-toggle="tab" data-bs-target="#tab-admins" type="button"><i class="fa-solid fa-user-shield me-1"></i> Admins</button>
                    </li>
                </ul>
            </div>

            <div class="card-body p-0">
                <div class="tab-content" id="userRoleTabsContent">
                    
                    <c:forEach var="tabId" items="${['tab-all','tab-workers','tab-shops','tab-homeowners','tab-admins']}">
                        <c:set var="targetRole" value="${tabId == 'tab-workers' ? 'worker' : (tabId == 'tab-shops' ? 'hardware_owner' : (tabId == 'tab-homeowners' ? 'homeowner' : (tabId == 'tab-admins' ? 'admin' : 'all')))}"/>
                        
                        <div class="tab-pane fade ${tabId == 'tab-all' ? 'show active' : ''}" id="${tabId}" role="tabpanel">
                            <div class="table-custom-wrapper border-0 rounded-0">
                                <table class="table table-custom align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Account Holder</th>
                                            <th>Contact Phone</th>
                                            <th>Role</th>
                                            <th>Status</th>
                                            <th class="text-end">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="u" items="${allUsers}">
                                            <c:if test="${targetRole == 'all' || u.role == targetRole}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-3">
                                                            <div class="avatar-fallback rounded-circle" style="width:38px; height:38px; font-size:0.9rem;">
                                                                ${u.fullName.substring(0,1)}
                                                            </div>
                                                            <div>
                                                                <div class="fw-bold text-navy-900">${u.fullName}</div>
                                                                <div class="text-slate-500 small">${u.email}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="text-slate-700 small">${u.phone}</span></td>
                                                    <td>
                                                        <span class="badge badge-pill ${u.role == 'admin' ? 'badge-crimson' : (u.role == 'worker' ? 'badge-amber' : (u.role == 'hardware_owner' ? 'badge-emerald' : 'badge-slate'))} text-capitalize">
                                                            ${u.role == 'hardware_owner' ? 'Hardware Store' : (u.role == 'homeowner' ? 'Homeowner' : u.role)}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${u.status == 'active'}">
                                                                <span class="badge badge-emerald"><i class="fa-solid fa-circle-check me-1"></i> Active</span>
                                                            </c:when>
                                                            <c:when test="${u.status == 'pending'}">
                                                                <span class="badge badge-amber"><i class="fa-solid fa-hourglass-half me-1"></i> Pending Approval</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-crimson"><i class="fa-solid fa-circle-xmark me-1"></i> Rejected</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-end action-cell">
                                                        <div class="d-inline-flex gap-1">
                                                            <c:if test="${u.status != 'active' && u.role != 'admin' && u.role != 'homeowner'}">
                                                                <form action="${pageContext.request.contextPath}/admin/users" method="post" class="d-inline">
                                                                    <input type="hidden" name="action" value="updateStatus">
                                                                    <input type="hidden" name="userId" value="${u.userId}">
                                                                    <input type="hidden" name="status" value="active">
                                                                    <button type="submit" class="btn btn-sm btn-success rounded-3 py-1 px-2.5 fw-semibold" title="Approve & Activate">
                                                                        <i class="fa-solid fa-check me-1"></i> Approve
                                                                    </button>
                                                                </form>
                                                            </c:if>

                                                            <c:if test="${u.status == 'pending' && u.role != 'admin'}">
                                                                <form action="${pageContext.request.contextPath}/admin/users" method="post" class="d-inline">
                                                                    <input type="hidden" name="action" value="updateStatus">
                                                                    <input type="hidden" name="userId" value="${u.userId}">
                                                                    <input type="hidden" name="status" value="rejected">
                                                                    <button type="submit" class="btn btn-sm btn-outline-warning rounded-3 py-1 px-2.5 fw-semibold" title="Reject Application">
                                                                        <i class="fa-solid fa-ban me-1"></i> Reject
                                                                    </button>
                                                                </form>
                                                            </c:if>

                                                            <c:if test="${u.role != 'admin'}">
                                                                <form action="${pageContext.request.contextPath}/admin/users" method="post" class="d-inline"
                                                                      onsubmit="return confirm('Are you sure you want to permanently delete this user account and associated profile data?');">
                                                                    <input type="hidden" name="action" value="deleteUser">
                                                                    <input type="hidden" name="userId" value="${u.userId}">
                                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-3 py-1 px-2" title="Delete User">
                                                                        <i class="fa-solid fa-trash"></i> Delete
                                                                    </button>
                                                                </form>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:forEach>

                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
