package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import lk.buildsmart.dao.HardwareShopDAO;
import lk.buildsmart.dao.UserDAO;
import lk.buildsmart.dao.WorkerDAO;
import lk.buildsmart.model.HardwareShop;
import lk.buildsmart.model.User;
import lk.buildsmart.model.UserFactory;
import lk.buildsmart.model.Worker;
import lk.buildsmart.util.ImageUtil;
import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@WebServlet("/register")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 5,       // 5MB per file
    maxRequestSize = 1024 * 1024 * 10    // 10MB total
)
public class RegisterServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(RegisterServlet.class);
    private final UserDAO userDAO = new UserDAO();
    private final WorkerDAO workerDAO = new WorkerDAO();
    private final HardwareShopDAO shopDAO = new HardwareShopDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String role = req.getParameter("role");
        String fullName = req.getParameter("full_name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");

        // Basic validation
        if (role == null || fullName == null || email == null || password == null ||
            role.isBlank() || fullName.isBlank() || email.isBlank() || password.isBlank()) {
            req.setAttribute("error", "Please fill in all required fields.");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        // Check if email already exists
        if (userDAO.getByEmail(email) != null) {
            req.setAttribute("error", "Email is already registered.");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        String status = "homeowner".equalsIgnoreCase(role) ? "active" : "pending";
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

        try {
            User user = UserFactory.create(0, fullName, email, hashedPassword, phone, role, status, LocalDateTime.now());

            boolean userInserted = userDAO.insert(user);
            if (!userInserted) {
                throw new RuntimeException("Failed to insert base user record.");
            }

            if ("worker".equalsIgnoreCase(role)) {
                handleWorkerRegistration(req, (Worker) user);
            } else if ("hardware_owner".equalsIgnoreCase(role)) {
                handleShopRegistration(req, user.getUserId());
            }

            logger.info("New user registered successfully: {}", email);
            resp.sendRedirect(req.getContextPath() + "/login?msg=registered");

        } catch (IllegalArgumentException e) {
            // Caught MIME/Size validation exceptions from ImageUtil
            logger.warn("Registration upload validation failed: {}", e.getMessage());
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        } catch (Exception e) {
            logger.error("Registration error for email: {}", email, e);
            req.setAttribute("error", "Registration failed: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        }
    }

    private void handleWorkerRegistration(HttpServletRequest req, Worker worker) throws IOException, ServletException {
        worker.setNic(req.getParameter("nic"));
        worker.setProfession(req.getParameter("profession"));
        worker.setExperience(Integer.parseInt(req.getParameter("experience")));
        worker.setSkills(req.getParameter("skills"));
        worker.setDailyRate(new BigDecimal(req.getParameter("daily_rate")));
        worker.setDistrict(req.getParameter("district"));
        worker.setAbout(req.getParameter("about"));

        // Read image directly into byte[] for BLOB storage
        Part filePart = req.getPart("profile_photo");
        byte[] imageBytes = ImageUtil.validateAndReadBytes(filePart);
        String mimeType  = ImageUtil.getMimeType(filePart);

        if (imageBytes != null) {
            worker.setProfilePhoto(imageBytes);
            worker.setProfilePhotoType(mimeType);
        }

        if (!workerDAO.insert(worker)) {
            throw new RuntimeException("Failed to insert worker profile.");
        }
    }

    private void handleShopRegistration(HttpServletRequest req, int userId) throws IOException, ServletException {
        HardwareShop shop = new HardwareShop();
        shop.setUserId(userId);
        shop.setShopName(req.getParameter("shop_name"));
        shop.setOwnerName(req.getParameter("owner_name"));
        shop.setBusinessRegistrationNumber(req.getParameter("business_registration_number"));
        shop.setAddress(req.getParameter("address"));
        shop.setDistrict(req.getParameter("district"));
        shop.setPhone(req.getParameter("shop_phone"));
        shop.setOpeningHours(req.getParameter("opening_hours"));
        shop.setDeliveryAvailable("on".equals(req.getParameter("delivery_available")));
        shop.setDescription(req.getParameter("description"));

        // Read logo directly into byte[] for BLOB storage
        Part filePart = req.getPart("logo");
        byte[] imageBytes = ImageUtil.validateAndReadBytes(filePart);
        String mimeType  = ImageUtil.getMimeType(filePart);

        if (imageBytes != null) {
            shop.setLogo(imageBytes);
            shop.setLogoType(mimeType);
        }

        if (!shopDAO.insert(shop)) {
            throw new RuntimeException("Failed to insert hardware shop profile.");
        }
    }
}
