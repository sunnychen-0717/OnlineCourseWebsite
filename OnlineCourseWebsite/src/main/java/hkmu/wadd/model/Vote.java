package hkmu.wadd.model;

import jakarta.persistence.*;

@Entity
@Table(name = "votes")
public class Vote {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;


    @Column(name = "poll_id")
    private Long pollId;


    @ManyToOne
    @JoinColumn(name = "poll_id", insertable = false, updatable = false)
    private Poll poll;


    @ManyToOne
    @JoinColumn(name = "option_id")
    private Option option;

    // --- Getters and Setters ---

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public Long getPollId() { return pollId; }
    public void setPollId(Long pollId) { this.pollId = pollId; }

    public Option getOption() { return option; }
    public void setOption(Option option) { this.option = option; }


    public Poll getPoll() { return poll; }
    public void setPoll(Poll poll) { this.poll = poll; }
}