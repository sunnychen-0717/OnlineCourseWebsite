package hkmu.wadd.model;

import jakarta.persistence.*;

@Entity
public class Material {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String fileName;
    private String filePath;

    @Column(columnDefinition = "TEXT")
    private String fileSummary; // 每個檔案獨立的摘要

    @ManyToOne
    @JoinColumn(name = "lecture_id")
    private Lecture lecture;

    // --- Getters and Setters ---

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }


    public String getFileSummary() { return fileSummary; }
    public void setFileSummary(String fileSummary) { this.fileSummary = fileSummary; }

    public Lecture getLecture() { return lecture; }
    public void setLecture(Lecture lecture) { this.lecture = lecture; }
}