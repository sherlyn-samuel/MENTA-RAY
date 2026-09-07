package com.Project.Menta_Ray.controller;

import com.Project.Menta_Ray.dto.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/dashboard")
    public ResponseEntity<ApiResponse<String>> getAdminDashboard() {
        return ResponseEntity.ok(
                new ApiResponse<>(true, "Success", "Admin dashboard data", HttpStatus.OK.value())
        );
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/manage-users")
    public ResponseEntity<ApiResponse<String>> manageUsers() {
        return ResponseEntity.ok(
                new ApiResponse<>(true, "Success", "Manage users data", HttpStatus.OK.value())
        );
    }
}