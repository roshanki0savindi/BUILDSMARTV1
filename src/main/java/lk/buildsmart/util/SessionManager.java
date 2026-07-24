package lk.buildsmart.util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.buildsmart.dao.UserDAO;
import lk.buildsmart.model.User;

import java.util.Base64;
import java.util.Optional;

/**
 * Utility class to handle session management and remember-me functionality.
 */
public class SessionManager {
    private static final String USER_SESSION_KEY = "loggedInUser";
    private static final String REMEMBER_ME_COOKIE = "buildsmart_remember";
    private static final int COOKIE_MAX_AGE = 30 * 24 * 60 * 60; // 30 days

    private final UserDAO userDAO = new UserDAO();

    /**
     * Logs the user in by establishing a session.
     */
    public static void loginUser(HttpServletRequest request, User user) {
        // Invalidate old session to prevent session fixation attacks
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute(USER_SESSION_KEY, user);
    }

    /**
     * Logs the user out by invalidating the session and clearing cookies.
     */
    public static void logoutUser(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        clearRememberMeCookie(request, response);
    }

    /**
     * Retrieves the currently logged-in user from the session.
     */
    public static User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute(USER_SESSION_KEY);
        }
        return null;
    }

    /**
     * Sets a remember-me cookie containing the user ID and a hash.
     * Note: In a production app, use a dedicated secure token table.
     * For this implementation, we use a simple Base64 encoded payload: userId:hash
     */
    public static void setRememberMeCookie(HttpServletResponse response, User user) {
        // Create a simple payload. Security note: real apps should use a cryptographically signed token (e.g. JWT)
        String payload = user.getUserId() + ":" + user.getPassword().substring(0, 10);
        String encodedPayload = Base64.getEncoder().encodeToString(payload.getBytes());
        
        Cookie cookie = new Cookie(REMEMBER_ME_COOKIE, encodedPayload);
        cookie.setMaxAge(COOKIE_MAX_AGE);
        cookie.setPath("/");
        cookie.setHttpOnly(true); // Prevent XSS access
        response.addCookie(cookie);
    }

    /**
     * Clears the remember-me cookie.
     */
    public static void clearRememberMeCookie(HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (REMEMBER_ME_COOKIE.equals(cookie.getName())) {
                    cookie.setValue("");
                    cookie.setPath("/");
                    cookie.setMaxAge(0);
                    response.addCookie(cookie);
                    break;
                }
            }
        }
    }

    /**
     * Attempts to auto-login via remember-me cookie.
     */
    public Optional<User> checkRememberMe(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) return Optional.empty();

        for (Cookie cookie : cookies) {
            if (REMEMBER_ME_COOKIE.equals(cookie.getName())) {
                try {
                    String decoded = new String(Base64.getDecoder().decode(cookie.getValue()));
                    String[] parts = decoded.split(":");
                    if (parts.length == 2) {
                        int userId = Integer.parseInt(parts[0]);
                        String hashPrefix = parts[1];
                        
                        User user = userDAO.getById(userId);
                        if (user != null && user.isActive() && user.getPassword().startsWith(hashPrefix)) {
                            return Optional.of(user);
                        }
                    }
                } catch (Exception e) {
                    // Invalid cookie format, ignore
                }
            }
        }
        return Optional.empty();
    }
}
