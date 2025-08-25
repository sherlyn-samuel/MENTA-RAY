package com.Project.MentaRay.dto;

class UserProfileDto {
    private String username;
    private String email;
    private String fullName;
    private LocalDateTime joinedDate;

    public UserProfileDto(String username, String email, String fullName, LocalDateTime joinedDate) {
        this.username = username;
        this.email = email;
        this.fullName = fullName;
        this.joinedDate = joinedDate;
    }

    // Getters and Setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public LocalDateTime getJoinedDate() {
        return joinedDate;
    }

    public void setJoinedDate(LocalDateTime joinedDate) {
        this.joinedDate = joinedDate;
    }
}
