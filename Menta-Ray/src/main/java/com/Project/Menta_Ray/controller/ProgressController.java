package com.Project.Menta_Ray.controller;

import com.Project.Menta_Ray.dto.ApiResponse;
import com.Project.Menta_Ray.entity.ProgressEntity;
import com.Project.Menta_Ray.service.ProgressService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/progress")
public class ProgressController {

    private final ProgressService progressService;

    public ProgressController(ProgressService progressService) {
        this.progressService = progressService;
    }

    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    @GetMapping
    public ResponseEntity<ApiResponse<List<ProgressEntity>>> getAllProgress() {
        List<ProgressEntity> progress = progressService.getAllProgress();
        return ResponseEntity.ok(
                new ApiResponse<>(true, "Success", progress, HttpStatus.OK.value())
        );
    }

    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ProgressEntity>> getProgressById(@PathVariable Long id) {
        Optional<ProgressEntity> progress = progressService.getProgressById(id);
        return progress.map(p -> ResponseEntity.ok(
                new ApiResponse<>(true, "Success", p, HttpStatus.OK.value())
        )).orElse(ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                new ApiResponse<>(false, "Progress not found", null, HttpStatus.NOT_FOUND.value())
        ));
    }

    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    @GetMapping("/player/{playerId}")
    public ResponseEntity<ApiResponse<List<ProgressEntity>>> getProgressByPlayerId(@PathVariable Long playerId) {
        List<ProgressEntity> progress = progressService.getProgressByPlayerId(playerId);
        return ResponseEntity.ok(
                new ApiResponse<>(true, "Success", progress, HttpStatus.OK.value())
        );
    }

    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    @PostMapping("/player/{playerId}")
    public ResponseEntity<ApiResponse<ProgressEntity>> createOrUpdateProgress(
            @PathVariable Long playerId,
            @RequestBody ProgressEntity progress) {
        ProgressEntity saved = progressService.saveProgress(playerId, progress);
        return ResponseEntity.status(HttpStatus.CREATED).body(
                new ApiResponse<>(true, "Progress saved successfully", saved, HttpStatus.CREATED.value())
        );
    }

    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteProgress(@PathVariable Long id) {
        progressService.deleteProgress(id);
        return ResponseEntity.ok(
                new ApiResponse<>(true, "Progress deleted successfully", null, HttpStatus.OK.value())
        );
    }
}