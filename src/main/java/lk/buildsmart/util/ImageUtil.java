package lk.buildsmart.util;

import jakarta.servlet.http.Part;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;

/**
 * Utility class for handling multipart image uploads directly into byte arrays.
 * Replaces the old {@code UploadHelper} which wrote files to disk.
 *
 * <p>Images are stored as {@code MEDIUMBLOB} in the database and served
 * via {@link lk.buildsmart.controller.ImageServlet}.</p>
 */
public class ImageUtil {
    private static final Logger logger = LoggerFactory.getLogger(ImageUtil.class);

    /** Maximum allowed upload size: 5 MB */
    private static final long MAX_FILE_SIZE = 5L * 1024 * 1024;

    private ImageUtil() {}  // utility class ΓÇö no instances

    /**
     * Validates and reads the uploaded file part into a {@code byte[]}.
     *
     * @param filePart the multipart part from the HTTP request
     * @return the raw image bytes, or {@code null} if no file was submitted
     * @throws IllegalArgumentException if the file exceeds 5 MB or has an invalid image format
     * @throws IOException              if an I/O error occurs while reading the stream
     */
    public static byte[] validateAndReadBytes(Part filePart) throws IOException {
        if (filePart == null
                || filePart.getSize() == 0
                || filePart.getSubmittedFileName() == null
                || filePart.getSubmittedFileName().isBlank()) {
            return null; // no file submitted
        }

        // 1. Size validation
        if (filePart.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("File size exceeds the 5 MB limit.");
        }

        // 2. MIME & Extension validation
        String mime = filePart.getContentType();
        String filename = filePart.getSubmittedFileName().toLowerCase();

        boolean validMime = mime != null && (mime.toLowerCase().startsWith("image/") || mime.equalsIgnoreCase("application/octet-stream"));
        boolean validExt = filename.endsWith(".jpg") || filename.endsWith(".jpeg") ||
                           filename.endsWith(".png") || filename.endsWith(".webp") ||
                           filename.endsWith(".gif") || filename.endsWith(".svg");

        if (!validMime && !validExt) {
            throw new IllegalArgumentException(
                "Invalid file format. Only image files (JPEG, PNG, WebP, GIF) are allowed.");
        }

        // 3. Read bytes
        try (InputStream in = filePart.getInputStream()) {
            byte[] bytes = in.readAllBytes();
            logger.debug("Read {} bytes for upload (MIME: {}, File: {})", bytes.length, mime, filename);
            return bytes;
        }
    }

    /**
     * Returns the MIME type of an uploaded part with fallbacks for browser/OS variations.
     *
     * @param filePart the multipart part
     * @return MIME type string (e.g. {@code "image/jpeg"}), or {@code null} if no file
     */
    public static String getMimeType(Part filePart) {
        if (filePart == null || filePart.getSize() == 0) return null;

        String mime = filePart.getContentType();
        if (mime != null && !mime.isBlank() && !mime.equalsIgnoreCase("application/octet-stream")) {
            return mime;
        }

        String filename = filePart.getSubmittedFileName() != null ? filePart.getSubmittedFileName().toLowerCase() : "";
        if (filename.endsWith(".png")) return "image/png";
        if (filename.endsWith(".webp")) return "image/webp";
        if (filename.endsWith(".gif")) return "image/gif";
        if (filename.endsWith(".svg")) return "image/svg+xml";
        return "image/jpeg";
    }
}
