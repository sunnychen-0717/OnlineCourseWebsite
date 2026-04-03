package hkmu.wadd.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, updatable = false)
    private String username;

    @Column(nullable = false)
    private String password;

    private String fullName;
    private String email;
    private String phoneNumber;

    private String role; // 例如 "ROLE_STUDENT" 或 "ROLE_TEACHER"

    // 修正 1：合併重複的 comments，並確保初始化
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Comment> comments = new ArrayList<>();

    // 修正 2：確保初始化，防止 NullPointer
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Lecture> lectures = new ArrayList<>();
    // 在 User.java 類別中補上這段
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Poll> polls = new ArrayList<>();


    // 記得補上 Getter 和 Setter
    public List<Poll> getPolls() { return polls; }
    public void setPolls(List<Poll> polls) { this.polls = polls; }
    public User() {}

    public User(String username, String password, String fullName, String email, String phoneNumber, String role) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.role = role;
    }

    // --- Getters and Setters ---

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    // 修正 3：補上關聯欄位的 Getter/Setter
    public List<Comment> getComments() { return comments; }
    public void setComments(List<Comment> comments) { this.comments = comments; }

    public List<Lecture> getLectures() { return lectures; }
    public void setLectures(List<Lecture> lectures) { this.lectures = lectures; }
}