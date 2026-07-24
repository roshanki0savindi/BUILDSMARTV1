package lk.buildsmart.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.model.User;
import lk.buildsmart.util.SessionManager;

import java.io.IOException;
import java.util.Optional;

/**
 * Authentication and Role-Based Access Control (RBAC) Filter.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    private final SessionManager sessionManager = new SessionManager();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // 1. Allow public static assets, images, and fully public pages (no login needed)
        if (path.startsWith("/img") || path.startsWith("/assets/") || path.startsWith("/css/") || path.startsWith("/js/") ||
            path.startsWith("/images/") || path.isEmpty() || path.equals("/") || path.equals("/index.jsp") ||
            path.equals("/login") || path.equals("/register") || path.equals("/logout") ||
            path.equals("/workers") || path.equals("/hardware-shops") || path.equals("/packages") ||
            path.startsWith("/worker/profile") || path.startsWith("/hardware/profile") ||
            path.startsWith("/package/details") || path.startsWith("/api/availability")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Check if user is in session
        User user = SessionManager.getLoggedInUser(req);

        // 3. Check remember-me cookie if session is missing
        if (user == null) {
            Optional<User> rememberedUser = sessionManager.checkRememberMe(req);
            if (rememberedUser.isPresent()) {
                user = rememberedUser.get();
                SessionManager.loginUser(req, user);
            }
        }

        // 4. Enforce Authentication
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 5. Role-Based Access Control (RBAC)
        // Admin-only paths
        if (path.startsWith("/admin") && !"admin".equals(user.getRole())) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admins Only");
            return;
        }

        // Worker dashboard (not profile ΓÇö that's public)
        if (path.startsWith("/worker/") && !path.startsWith("/worker/profile") && !"worker".equals(user.getRole())) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Workers Only");
            return;
        }

        // Hardware dashboard (not profile ΓÇö that's public)
        if (path.startsWith("/hardware/") && !path.startsWith("/hardware/profile") && !"hardware_owner".equals(user.getRole())) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Hardware Owners Only");
            return;
        }

        // Homeowner dashboard
        if (path.startsWith("/homeowner") && !"homeowner".equals(user.getRole())) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Homeowners Only");
            return;
        }

        // User is authenticated and authorized
        chain.doFilter(request, response);
    }
}
