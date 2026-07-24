import org.mindrot.jbcrypt.BCrypt;
public class TestBcrypt {
    public static void main(String[] args) {
        // Generate a new known hash for admin123
        String newHash = BCrypt.hashpw("admin123", BCrypt.gensalt(10));
        System.out.println("admin123 hash: " + newHash);
        System.out.println("Verify: " + BCrypt.checkpw("admin123", newHash));
        
        // Also generate hash for password123 (seed user password)
        String userHash = BCrypt.hashpw("password123", BCrypt.gensalt(10));
        System.out.println("password123 hash: " + userHash);
    }
}
