package hkmu.wadd.model;

import jakarta.persistence.*;

@Entity
@Table(name = "comments")
public class Comment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 1000)
    private String content;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "lecture_id", nullable = true)
    private Lecture lecture;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "poll_id", nullable = true)
    private Poll poll;

    // --- 修正點：只保留一個 user 定義，並設為 nullable = true ---
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = true)
    private User user;

    public Comment() {}

    // --- Getters and Setters ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Lecture getLecture() { return lecture; }
    public void setLecture(Lecture lecture) { this.lecture = lecture; }

    public Poll getPoll() { return poll; }
    public void setPoll(Poll poll) { this.poll = poll; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}