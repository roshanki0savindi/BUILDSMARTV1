<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<div class="row justify-content-center my-4">
    <div class="col-lg-9 col-xl-8">
        <div class="text-center mb-4">
            <h2 class="fw-bold font-heading text-navy-900 mb-2">Create Your BuildSmart Account</h2>
            <p class="text-slate-500">Join Sri Lanka's leading platform for construction professionals, stores, and homeowners</p>
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger rounded-3 d-flex align-items-center gap-2 mb-4">
                <i class="fa-solid fa-circle-exclamation"></i> <span>${error}</span>
            </div>
        </c:if>

        <div class="card border-0 shadow-lg rounded-4 overflow-hidden mb-5">
            <div class="card-header bg-light p-3 border-bottom">
                <ul class="nav nav-pills nav-fill gap-2" id="registerTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active rounded-pill fw-semibold py-2.5" data-bs-toggle="tab" data-bs-target="#homeowner-tab" type="button" role="tab">
                            <i class="fa-solid fa-house-user me-2"></i> Homeowner
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link rounded-pill fw-semibold py-2.5" data-bs-toggle="tab" data-bs-target="#worker-tab" type="button" role="tab">
                            <i class="fa-solid fa-hard-hat me-2"></i> Skilled Worker
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link rounded-pill fw-semibold py-2.5" data-bs-toggle="tab" data-bs-target="#shop-tab" type="button" role="tab">
                            <i class="fa-solid fa-store me-2"></i> Hardware Shop
                        </button>
                    </li>
                </ul>
            </div>
            
            <div class="card-body p-4 p-md-5">
                <div class="tab-content" id="registerTabsContent">
                    
                    <!-- Homeowner Tab -->
                    <div class="tab-pane fade show active" id="homeowner-tab" role="tabpanel">
                        <form action="${pageContext.request.contextPath}/register" method="post">
                            <input type="hidden" name="role" value="homeowner">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-slate-700">Full Name</label>
                                    <input type="text" name="full_name" class="form-control" placeholder="e.g. Nimal Perera" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-slate-700">Email Address</label>
                                    <input type="email" name="email" class="form-control" placeholder="nimal@example.com" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-slate-700">Password</label>
                                    <div class="input-group">
                                        <input type="password" name="password" id="regHomeownerPwd" class="form-control" placeholder="••••••••" required>
                                        <button class="btn btn-outline-secondary toggle-password-btn" type="button" data-target="regHomeownerPwd" aria-label="Toggle password visibility">
                                            <i class="fa-solid fa-eye"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-slate-700">Phone Number</label>
                                    <input type="text" name="phone" class="form-control" placeholder="0771234567" required>
                                </div>
                                <div class="col-12 mt-4">
                                    <button type="submit" class="btn btn-primary w-100 py-2.5 rounded-pill fw-semibold shadow-sm">
                                        <i class="fa-solid fa-user-plus me-2"></i> Register as Homeowner
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Worker Tab -->
                    <div class="tab-pane fade" id="worker-tab" role="tabpanel">
                        <form action="${pageContext.request.contextPath}/register" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="role" value="worker">
                            <div class="row g-3">
                                <div class="col-12 border-bottom pb-2">
                                    <h6 class="fw-bold text-primary mb-0"><i class="fa-solid fa-user-gear me-2"></i> Basic Credentials</h6>
                                </div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">Full Name</label><input type="text" name="full_name" class="form-control" required></div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">Email Address</label><input type="email" name="email" class="form-control" required></div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-slate-700">Password</label>
                                    <div class="input-group">
                                        <input type="password" name="password" id="regWorkerPwd" class="form-control" required>
                                        <button class="btn btn-outline-secondary toggle-password-btn" type="button" data-target="regWorkerPwd" aria-label="Toggle password visibility">
                                            <i class="fa-solid fa-eye"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">Phone Number</label><input type="text" name="phone" class="form-control" required></div>
                                
                                <div class="col-12 border-bottom pb-2 pt-3">
                                    <h6 class="fw-bold text-primary mb-0"><i class="fa-solid fa-briefcase me-2"></i> Professional Experience</h6>
                                </div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">National ID (NIC)</label><input type="text" name="nic" class="form-control" required></div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-slate-700">Trade Profession</label>
                                    <select name="profession" class="form-select" required>
                                        <option value="Mason">Mason</option>
                                        <option value="Carpenter">Carpenter</option>
                                        <option value="Electrician">Electrician</option>
                                        <option value="Plumber">Plumber</option>
                                        <option value="Painter">Painter</option>
                                        <option value="Architect">Architect</option>
                                    </select>
                                </div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">Years of Experience</label><input type="number" name="experience" class="form-control" min="0" required></div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">Daily Rate (LKR)</label><input type="number" step="0.01" name="daily_rate" class="form-control" required></div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">District</label><input type="text" name="district" class="form-control" required></div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">Skills (Comma separated)</label><input type="text" name="skills" class="form-control" placeholder="e.g., Tile laying, Brickwork"></div>
                                <div class="col-12"><label class="form-label fw-semibold small text-slate-700">About You</label><textarea name="about" class="form-control" rows="3" placeholder="Brief summary of your expertise and past work..."></textarea></div>
                                <div class="col-12"><label class="form-label fw-semibold small text-slate-700">Profile Photo</label><input type="file" name="profile_photo" class="form-control" accept="image/*"></div>
                                
                                <div class="col-12 mt-4">
                                    <div class="alert alert-warning rounded-3 d-flex align-items-center gap-2 py-2 px-3 mb-3">
                                        <i class="fa-solid fa-circle-info"></i> <span class="small">Worker accounts require administrative verification before appearing in public listings.</span>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100 py-2.5 rounded-pill fw-semibold shadow-sm">
                                        <i class="fa-solid fa-hard-hat me-2"></i> Submit Worker Application
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Hardware Shop Tab -->
                    <div class="tab-pane fade" id="shop-tab" role="tabpanel">
                        <form action="${pageContext.request.contextPath}/register" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="role" value="hardware_owner">
                            <div class="row g-3">
                                <div class="col-12 border-bottom pb-2">
                                    <h6 class="fw-bold text-primary mb-0"><i class="fa-solid fa-user-shield me-2"></i> Owner Credentials</h6>
                                </div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">Owner Name</label><input type="text" name="full_name" class="form-control" required></div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">Login Email</label><input type="email" name="email" class="form-control" required></div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-slate-700">Password</label>
                                    <div class="input-group">
                                        <input type="password" name="password" id="regShopPwd" class="form-control" required>
                                        <button class="btn btn-outline-secondary toggle-password-btn" type="button" data-target="regShopPwd" aria-label="Toggle password visibility">
                                            <i class="fa-solid fa-eye"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">Owner Phone</label><input type="text" name="phone" class="form-control" required></div>
                                
                                <div class="col-12 border-bottom pb-2 pt-3">
                                    <h6 class="fw-bold text-primary mb-0"><i class="fa-solid fa-store me-2"></i> Store Information</h6>
                                </div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">Shop Name</label><input type="text" name="shop_name" class="form-control" required></div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">Business Reg. No.</label><input type="text" name="business_registration_number" class="form-control" required></div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">Shop Contact Phone</label><input type="text" name="shop_phone" class="form-control" required></div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">District</label><input type="text" name="district" class="form-control" required></div>
                                <div class="col-12"><label class="form-label fw-semibold small text-slate-700">Street Address</label><textarea name="address" class="form-control" rows="2" required></textarea></div>
                                <div class="col-md-6"><label class="form-label fw-semibold small text-slate-700">Opening Hours</label><input type="text" name="opening_hours" class="form-control" placeholder="e.g. Mon-Sat: 8 AM - 6 PM"></div>
                                <div class="col-md-6 d-flex align-items-center pt-md-4">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="delivery_available" id="deliveryCheck">
                                        <label class="form-check-label fw-semibold text-slate-700" for="deliveryCheck">Offers Delivery Service</label>
                                    </div>
                                </div>
                                <div class="col-12"><label class="form-label fw-semibold small text-slate-700">Shop Description</label><textarea name="description" class="form-control" rows="3"></textarea></div>
                                <div class="col-12"><label class="form-label fw-semibold small text-slate-700">Shop Logo</label><input type="file" name="logo" class="form-control" accept="image/*"></div>
                                
                                <div class="col-12 mt-4">
                                    <div class="alert alert-warning rounded-3 d-flex align-items-center gap-2 py-2 px-3 mb-3">
                                        <i class="fa-solid fa-circle-info"></i> <span class="small">Hardware shop accounts require administrative approval before becoming visible.</span>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100 py-2.5 rounded-pill fw-semibold shadow-sm">
                                        <i class="fa-solid fa-store me-2"></i> Register Hardware Shop
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
