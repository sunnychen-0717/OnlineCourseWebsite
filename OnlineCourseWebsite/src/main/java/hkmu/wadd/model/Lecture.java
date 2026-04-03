package hkmu.wadd.model;

import jakarta.persistence.*;
import java.util.List;
import java.util.ArrayList;

@Entity
@Table(name = "lectures")
public class Lecture {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    @Column(length = 2000)
    private String description;

    @Column(length = 500)
    private String summary;

    // ⭐ 關鍵修正：補上這個關聯欄位，名稱必須是 "user"
    @ManyToOne
    @JoinColumn(name = "user_id") // 資料庫外鍵名稱
    private User user;

    @OneToMany(mappedBy = "lecture", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Material> materials = new ArrayList<>();

    @OneToMany(mappedBy = "lecture", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    private List<Comment> comments = new ArrayList<>();

    public Lecture() {}

    // --- Getters and Setters ---

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }

    // ⭐ 補上 user 的 Getter 和 Setter
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public List<Material> getMaterials() { return materials; }
    public void setMaterials(List<Material> materials) { this.materials = materials; }

    public List<Comment> getComments() { return comments; }
    public void setComments(List<Comment> comments) { this.comments = comments; }
}