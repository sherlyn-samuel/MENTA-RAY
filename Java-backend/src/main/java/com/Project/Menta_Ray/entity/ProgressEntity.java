package com.Project.Menta_Ray.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

@Entity
@Table(name = "progress")
public class ProgressEntity {

    public enum Difficulty {
        EASY, MEDIUM, HARD
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "player_id", nullable = false)
    @JsonIgnoreProperties("progressList")
    private PlayerEntity player;

    @Column(name = "lives", nullable = false)
    private int lives;

    @Column(name = "math_progress", nullable = false)
    private int mathProgress;

    @Enumerated(EnumType.STRING)
    @Column(name = "math_difficulty", nullable = false)
    private Difficulty mathDifficulty;

    @Column(name = "coins", nullable = false)
    private int coins;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public PlayerEntity getPlayer() { return player; }
    public void setPlayer(PlayerEntity player) { this.player = player; }
    public int getLives() { return lives; }
    public void setLives(int lives) { this.lives = lives; }
    public int getMathProgress() { return mathProgress; }
    public void setMathProgress(int mathProgress) { this.mathProgress = mathProgress; }
    public Difficulty getMathDifficulty() { return mathDifficulty; }
    public void setMathDifficulty(Difficulty mathDifficulty) { this.mathDifficulty = mathDifficulty; }
    public int getCoins() { return coins; }
    public void setCoins(int coins) { this.coins = coins; }
}