package lk.buildsmart.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * DBConnection ΓÇö Singleton database connection helper.
 *
 * <p>Loads connection parameters from {@code db.properties} on the classpath
 * (src/main/resources/db.properties), so no credentials are hard-coded.</p>
 *
 * <p>Usage:
 * <pre>
 *   try (Connection conn = DBConnection.getConnection()) {
 *       // use connection
 *   }
 * </pre>
 * </p>
 *
 * <p>OOP Concept ΓÇö Encapsulation: all internal state is private;
 * the only public surface is {@link #getConnection()}.</p>
 */
public class DBConnection {

    private static final Logger logger = LoggerFactory.getLogger(DBConnection.class);

    /** Properties file that must exist on the runtime classpath. */
    private static final String PROPERTIES_FILE = "db.properties";

    // Loaded once when the class is first used
    private static final String DB_URL;
    private static final String DB_USERNAME;
    private static final String DB_PASSWORD;
    private static final String DB_DRIVER;

    /*
     * Static initializer ΓÇö runs exactly once when the JVM loads this class.
     * Loads db.properties from the classpath and registers the JDBC driver.
     */
    static {
        Properties props = new Properties();

        // Load the file from the classpath (works in both WAR and unit tests)
        try (InputStream is = Thread.currentThread()
                .getContextClassLoader()
                .getResourceAsStream(PROPERTIES_FILE)) {

            if (is == null) {
                throw new RuntimeException(
                        "Cannot find '" + PROPERTIES_FILE + "' on the classpath. "
                        + "Make sure src/main/resources/db.properties exists.");
            }
            props.load(is);
            logger.info("Loaded database properties from classpath:{}", PROPERTIES_FILE);

        } catch (IOException e) {
            throw new RuntimeException("Failed to load " + PROPERTIES_FILE, e);
        }

        DB_URL      = props.getProperty("db.url");
        DB_USERNAME = props.getProperty("db.username");
        DB_PASSWORD = props.getProperty("db.password", "");
        DB_DRIVER   = props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");

        // Validate required properties
        if (DB_URL == null || DB_URL.isBlank()) {
            throw new RuntimeException(
                    "Property 'db.url' is missing or empty in " + PROPERTIES_FILE);
        }
        if (DB_USERNAME == null || DB_USERNAME.isBlank()) {
            throw new RuntimeException(
                    "Property 'db.username' is missing or empty in " + PROPERTIES_FILE);
        }

        // In web applications, we must explicitly load the driver class so Tomcat's classloader finds it
        try {
            Class.forName(DB_DRIVER);
            logger.info("JDBC driver registered: {}", DB_DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Failed to load JDBC driver: " + DB_DRIVER, e);
        }
    }

    /** Private constructor prevents instantiation ΓÇö use {@link #getConnection()} instead. */
    private DBConnection() {}

    /**
     * Opens and returns a new JDBC {@link Connection}.
     *
     * <p>The caller is responsible for closing the connection (try-with-resources
     * is strongly recommended).</p>
     *
     * @return an open {@link Connection} to the BuildSmart database
     * @throws SQLException if the connection cannot be established
     */
    public static Connection getConnection() throws SQLException {
        logger.debug("Opening database connection to {}", DB_URL);
        return DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
    }

    /**
     * Convenience method ΓÇö safely closes a connection without throwing.
     * Useful in finally blocks or legacy code that does not use try-with-resources.
     *
     * @param conn the {@link Connection} to close (may be {@code null})
     */
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                logger.debug("Database connection closed.");
            } catch (SQLException e) {
                logger.warn("Failed to close database connection", e);
            }
        }
    }
}
