package com.Project.MentaRay.dto;

class AuthResponseDto {
    private String token;
    private String username;
    private String email;
    private String fullName;
    private String message;

    public AuthResponseDto(String token, String username, String email, String fullName, String message) {
        this.token = token;
        this.username = username;
        this.email = email;
        this.fullName = fullName;
        this.message = message;
    }

    // Getters and Setters
    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

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

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
