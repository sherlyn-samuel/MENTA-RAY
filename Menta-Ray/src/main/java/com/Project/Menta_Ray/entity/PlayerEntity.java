package com.Project.Menta_Ray.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "players")
public class PlayerEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(name = "player_progress", nullable = false)
    private int progress;

    @Column(name = "leaderboard_rank", nullable = false)
    private int leaderboardRank;

    @Column(name = "pearl_count", nullable = false)
    private int pearlCount;

    @JsonIgnore
    @OneToMany(mappedBy = "player", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ProgressEntity> progressList;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public int getProgress() { return progress; }
    public void setProgress(int progress) { this.progress = progress; }
    public int getLeaderboardRank() { return leaderboardRank; }
    public void setLeaderboardRank(int leaderboardRank) { this.leaderboardRank = leaderboardRank; }
    public int getPearlCount() { return pearlCount; }
    public void setPearlCount(int pearlCount) { this.pearlCount = pearlCount; }
    public List<ProgressEntity> getProgressList() { return progressList; }
    public void setProgressList(List<ProgressEntity> progressList) { this.progressList = progressList; }
}