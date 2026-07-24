<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<div class="row justify-content-center my-4 my-md-5">
    <div class="col-md-8 col-lg-5">
        <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="card-header bg-navy text-white text-center p-4 border-0" style="background: var(--navy-900);">
                <div class="brand-icon-wrapper bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-2" style="width:50px; height:50px; font-size:1.25rem;">
                    <i class="fa-solid fa-helmet-safety"></i>
                </div>
                <h3 class="fw-bold text-white mb-1 font-heading">Welcome Back</h3>
                <p class="text-slate-300 small mb-0">Sign in to manage your BuildSmart account</p>
            </div>
            
            <div class="card-body p-4 p-md-5">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger rounded-3 d-flex align-items-center gap-2 py-2 px-3 mb-4">
                        <i class="fa-solid fa-circle-exclamation"></i> <span>${error}</span>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'registered'}">
                    <div class="alert alert-success rounded-3 d-flex align-items-center gap-2 py-2 px-3 mb-4">
                        <i class="fa-solid fa-circle-check"></i> <span>Registration successful! Please log in with your credentials.</span>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'logged_out'}">
                    <div class="alert alert-info rounded-3 d-flex align-items-center gap-2 py-2 px-3 mb-4">
                        <i class="fa-solid fa-circle-info"></i> <span>You have been safely logged out.</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-slate-700">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-slate-500"><i class="fa-solid fa-envelope"></i></span>
                            <input type="email" name="email" class="form-control border-start-0 ps-0" placeholder="you@example.com" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-slate-700">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-slate-500"><i class="fa-solid fa-lock"></i></span>
                            <input type="password" name="password" id="loginPassword" class="form-control border-start-0 border-end-0 ps-0" placeholder="••••••••" required>
                            <button class="btn btn-outline-secondary border-start-0 toggle-password-btn" type="button" data-target="loginPassword" aria-label="Toggle password visibility">
                                <i class="fa-solid fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="form-check">
                            <input type="checkbox" name="remember" id="remember" class="form-check-input">
                            <label class="form-check-label small text-slate-700" for="remember">Remember Me</label>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary w-100 py-2.5 rounded-pill fw-semibold shadow-sm">
                        <i class="fa-solid fa-right-to-bracket me-2"></i> Sign In
                    </button>
                </form>
            
                <div class="text-center mt-4 pt-3 border-top">
                    <span class="text-muted small">Don't have an account yet?</span> 
                    <a href="${pageContext.request.contextPath}/register" class="fw-semibold text-primary ms-1">Create an Account</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
