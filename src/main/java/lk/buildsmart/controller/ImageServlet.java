package lk.buildsmart.controller;

import lk.buildsmart.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Serves image binaries stored as MEDIUMBLOB directly from the database.
 *
 * <p>URL pattern: {@code /img?type=worker&id=1}
 *
 * <p>Supported {@code type} values:
 * <ul>
 *   <li>{@code worker}  ΓÇö {@code workers.profile_photo} by {@code worker_id} or {@code user_id}</li>
 *   <li>{@code shop}    ΓÇö {@code hardware_shops.logo} by {@code shop_id} or {@code user_id}</li>
 *   <li>{@code review}  ΓÇö {@code reviews.photo} by {@code review_id}</li>
 * </ul>
 */
@WebServlet("/img")
public class ImageServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(ImageServlet.class);

    /**
     * Minimal 1├ù1 transparent PNG returned when no image is stored.
     */
    private static final byte[] TRANSPARENT_PNG =
        java.util.Base64.getDecoder().decode(
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=="
        );

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String type = req.getParameter("type");
        String idParam = req.getParameter("id");

        if (type == null || idParam == null) {
            serveFallback(resp);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
            if (id <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            serveFallback(resp);
            return;
        }

        String sql;
        String blobCol;
        String mimeCol;
        boolean hasTwoParams = false;

        switch (type) {
            case "worker" -> {
                sql = "SELECT profile_photo, photo_mime FROM workers WHERE worker_id = ? OR user_id = ?";
                blobCol = "profile_photo";
                mimeCol = "photo_mime";
                hasTwoParams = true;
            }
            case "shop" -> {
                sql = "SELECT logo, logo_mime FROM hardware_shops WHERE shop_id = ? OR user_id = ?";
                blobCol = "logo";
                mimeCol = "logo_mime";
                hasTwoParams = true;
            }
            case "review" -> {
                sql = "SELECT photo, photo_mime FROM reviews WHERE review_id = ?";
                blobCol = "photo";
                mimeCol = "photo_mime";
                hasTwoParams = false;
            }
            default -> {
                serveFallback(resp);
                return;
            }
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            if (hasTwoParams) {
                stmt.setInt(2, id);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    byte[] data = rs.getBytes(blobCol);
                    String mime = rs.getString(mimeCol);

                    if (data == null || data.length == 0) {
                        serveFallback(resp);
                        return;
                    }

                    String contentType = (mime != null && !mime.isBlank()) ? mime : "image/jpeg";

                    // Prevent browser caching so updated images appear immediately
                    resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                    resp.setHeader("Pragma", "no-cache");
                    resp.setDateHeader("Expires", 0);
                    resp.setContentType(contentType);
                    resp.setContentLength(data.length);

                    try (OutputStream out = resp.getOutputStream()) {
                        out.write(data);
                    }
                    return;
                }
            }
        } catch (SQLException e) {
            logger.error("Error serving image type={} id={}", type, id, e);
        }

        serveFallback(resp);
    }

    /** Writes a transparent 1├ù1 PNG so image tags remain unbroken. */
    private void serveFallback(HttpServletResponse resp) throws IOException {
        resp.setContentType("image/png");
        resp.setContentLength(TRANSPARENT_PNG.length);
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        try (OutputStream out = resp.getOutputStream()) {
            out.write(TRANSPARENT_PNG);
        }
    }
}
