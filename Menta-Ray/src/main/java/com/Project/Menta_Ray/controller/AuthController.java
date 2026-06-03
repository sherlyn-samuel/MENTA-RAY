package com.Project.Menta_Ray.controller;

import com.Project.Menta_Ray.dto.ApiResponse;
import com.Project.Menta_Ray.dto.LoginRequest;
import com.Project.Menta_Ray.dto.SignupRequest;
import com.Project.Menta_Ray.entity.User;
import com.Project.Menta_Ray.repository.URepository;
import com.Project.Menta_Ray.service.AuthService;
import com.Project.Menta_Ray.util.JwtUtil;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private URepository usersRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<Map<String, String>>> login(
            @Valid @RequestBody LoginRequest loginRequest) {

        // Look up user by email instead of username
        User user = usersRepository.findByEmail(loginRequest.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!passwordEncoder.matches(loginRequest.getPassword(), user.getPassword())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(
                    new ApiResponse<>(false, "Invalid credentials", null, HttpStatus.UNAUTHORIZED.value())
            );
        }

        String token = jwtUtil.generateToken(user.getUsername());
        Map<String, String> tokenData = Collections.singletonMap("token", token);

        return ResponseEntity.ok(
                new ApiResponse<>(true, "Login successful", tokenData, HttpStatus.OK.value())
        );
    }

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<Void>> register(
            @Valid @RequestBody SignupRequest signupRequest) {
        authService.registerUser(signupRequest);
        return ResponseEntity.ok(
                new ApiResponse<>(true, "User registered successfully", null, HttpStatus.OK.value())
        );
    }
}