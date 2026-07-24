<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:useBean id="workerProfile" type="lk.buildsmart.model.Worker" scope="request" />
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<div class="row g-4">
    <!-- Sidebar -->
    <div class="col-lg-3">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-body text-center p-4">
                <div class="position-relative d-inline-block mx-auto mb-3">
                    <c:choose>
                        <c:when test="${not empty workerProfile.profilePhoto}">
                            <img src="${pageContext.request.contextPath}/img?type=worker&id=${workerProfile.workerId}"
                                 class="rounded-circle object-fit-cover shadow-sm border border-3 border-white"
                                 style="width:100px; height:100px;">
                        </c:when>
                        <c:otherwise>
                            <div class="avatar-fallback rounded-circle mx-auto shadow-sm" style="width:100px; height:100px; font-size:2.5rem;">
                                <i class="fa-solid fa-user-gear"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <h5 class="fw-bold font-heading mb-1 text-navy-900">${sessionScope.loggedInUser.fullName}</h5>
                <div class="mb-3">
                    <c:choose>
                        <c:when test="${workerProfile.status == 'active'}">
                            <span class="badge badge-emerald px-3 py-1 fw-semibold"><i class="fa-solid fa-circle-check me-1"></i> Account Active</span>
                        </c:when>
                        <c:when test="${workerProfile.status == 'pending'}">
                            <span class="badge badge-amber px-3 py-1 fw-semibold"><i class="fa-solid fa-hourglass-half me-1"></i> Pending Verification</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-crimson px-3 py-1 fw-semibold"><i class="fa-solid fa-circle-xmark me-1"></i> Account Inactive</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <a href="${pageContext.request.contextPath}/worker/profile?id=${workerProfile.workerId}"
                   class="btn btn-outline-primary btn-sm w-100 rounded-pill mb-3 fw-semibold">
                    <i class="fa-solid fa-eye me-1"></i> View Public Profile
                </a>

                <!-- Photo update form -->
                <form action="${pageContext.request.contextPath}/upload-photo" method="post"
                      enctype="multipart/form-data" class="text-start bg-slate-50 p-3 rounded-3 border">
                    <label class="small fw-semibold text-slate-700 mb-1 d-block">Change Profile Image</label>
                    <div class="input-group input-group-sm">
                        <input type="file" name="profile_photo" class="form-control form-control-sm"
                               accept="image/*" required>
                        <button class="btn btn-primary btn-sm" type="submit" aria-label="Upload Photo">
                            <i class="fa-solid fa-upload"></i>
                        </button>
                    </div>
                </form>
            </div>

            <div class="list-group list-group-flush border-top p-2 gap-1">
                <a href="#" class="list-group-item list-group-item-action rounded-3 border-0 active fw-semibold">
                    <i class="fa-solid fa-calendar-check me-2 text-primary"></i> Manage Availability
                </a>
                <button type="button" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold text-start" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                    <i class="fa-solid fa-user-pen me-2 text-primary"></i> Edit Profile Details
                </button>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="col-lg-9">
        <!-- Flash messages -->
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger rounded-3 py-2.5 px-3 mb-3"><i class="fa-solid fa-circle-xmark me-2"></i> ${param.error}</div>
        </c:if>
        <c:if test="${param.msg == 'photo_updated'}">
            <div class="alert alert-success rounded-3 py-2.5 px-3 mb-3"><i class="fa-solid fa-circle-check me-2"></i> Profile photo updated successfully!</div>
        </c:if>
        <c:if test="${param.msg == 'profile_updated'}">
            <div class="alert alert-success rounded-3 py-2.5 px-3 mb-3"><i class="fa-solid fa-circle-check me-2"></i> Profile details updated successfully!</div>
        </c:if>
        <c:if test="${workerProfile.status != 'active'}">
            <div class="alert alert-warning rounded-3 py-2.5 px-3 mb-3">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                <strong>Verification Pending:</strong> Your worker profile is currently under review by platform administrators. It will be publicly visible upon approval.
            </div>
        </c:if>

        <!-- Interactive Availability Management Calendar -->
        <div class="card border-0 shadow-sm rounded-4" id="manage_cal">
            <div class="card-body p-4 p-md-5">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center border-bottom pb-3 mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold font-heading mb-1 text-navy-900">
                            <i class="fa-solid fa-calendar-days text-primary me-2"></i> Availability Schedule Manager
                        </h4>
                        <p class="text-slate-500 small mb-0">Toggle dates to notify clients when you are open for work or booked</p>
                    </div>
                    
                    <div class="cal-nav mb-0">
                        <button class="btn btn-sm btn-outline-secondary rounded-circle px-2" onclick="manage_cal_prev()" aria-label="Previous Month">
                            <i class="fa-solid fa-chevron-left"></i>
                        </button>
                        <h6 id="manage_cal-header" class="fw-bold mb-0 text-center" style="min-width:140px;">Loading…</h6>
                        <button class="btn btn-sm btn-outline-secondary rounded-circle px-2" onclick="manage_cal_next()" aria-label="Next Month">
                            <i class="fa-solid fa-chevron-right"></i>
                        </button>
                    </div>
                </div>

                <div class="alert alert-info rounded-3 py-2.5 px-3 small mb-4">
                    <i class="fa-solid fa-circle-info me-2"></i> Click any <strong>future date</strong> to switch between Available and Unavailable status. Changes are saved automatically.
                </div>

                <div id="manage_cal-grid"></div>

                <div class="cal-legend">
                    <span><span class="swatch swatch-avail"></span> Available (Click to block)</span>
                    <span><span class="swatch swatch-unavail"></span> Unavailable (Click to unblock)</span>
                    <span><span class="swatch swatch-past"></span> Past Date (Locked)</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- calendar.js + initialisation -->
<script src="${pageContext.request.contextPath}/js/calendar.js"></script>
<script>
    CalendarWidget.initManage(
        'manage_cal',
        '${workerProfile.workerId}',
        '${pageContext.request.contextPath}'
    );
</script>

<!-- Edit Profile Modal -->
<div class="modal fade" id="editProfileModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="modal-header bg-navy text-white p-4 border-0" style="background: var(--navy-900);">
                <h5 class="modal-title fw-bold font-heading text-white"><i class="fa-solid fa-user-pen text-primary me-2"></i> Update Worker Profile</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/worker/dashboard" method="post">
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-slate-700">Full Name</label>
                            <input type="text" name="full_name" class="form-control" value="${sessionScope.loggedInUser.fullName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-slate-700">Phone Number</label>
                            <input type="text" name="phone" class="form-control" value="${sessionScope.loggedInUser.phone}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-slate-700">Profession</label>
                            <select name="profession" class="form-select" required>
                                <c:forEach var="p" items="${['Mason','Carpenter','Electrician','Plumber','Painter','Tiler','Architect','Welder','Laborer']}">
                                    <option value="${p}" ${workerProfile.profession == p ? 'selected' : ''}>${p}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-slate-700">Years of Experience</label>
                            <input type="number" name="experience" class="form-control" min="0" value="${workerProfile.experience}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-slate-700">Daily Rate (LKR)</label>
                            <input type="number" step="0.01" name="daily_rate" class="form-control" value="${workerProfile.dailyRate}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-slate-700">District</label>
                            <input type="text" name="district" class="form-control" value="${workerProfile.district}" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold small text-slate-700">Skills (Comma separated)</label>
                            <input type="text" name="skills" class="form-control" value="${workerProfile.skills}">
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold small text-slate-700">About Me</label>
                            <textarea name="about" class="form-control" rows="3">${workerProfile.about}</textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light p-3">
                    <button type="button" class="btn btn-slate btn-sm rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4 fw-semibold shadow-sm">
                        <i class="fa-solid fa-floppy-disk me-1"></i> Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
