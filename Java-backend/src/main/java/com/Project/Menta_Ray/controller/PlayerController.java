package com.Project.Menta_Ray.controller;

import com.Project.Menta_Ray.dto.ApiResponse;
import com.Project.Menta_Ray.entity.PlayerEntity;
import com.Project.Menta_Ray.service.PlayerService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/players")
public class PlayerController {

    private final PlayerService playerService;

    public PlayerController(PlayerService playerService) {
        this.playerService = playerService;
    }

    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    @GetMapping
    public ResponseEntity<ApiResponse<List<PlayerEntity>>> getAllPlayers() {
        List<PlayerEntity> players = playerService.getAllPlayers();
        return ResponseEntity.ok(
                new ApiResponse<>(true, "Success", players, HttpStatus.OK.value())
        );
    }

    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<PlayerEntity>> getPlayerById(@PathVariable Long id) {
        Optional<PlayerEntity> player = playerService.getPlayerById(id);
        return player.map(p -> ResponseEntity.ok(
                new ApiResponse<>(true, "Success", p, HttpStatus.OK.value())
        )).orElse(ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                new ApiResponse<>(false, "Player not found", null, HttpStatus.NOT_FOUND.value())
        ));
    }

    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    @GetMapping("/email/{email}")
    public ResponseEntity<ApiResponse<PlayerEntity>> getPlayerByEmail(@PathVariable String email) {
        Optional<PlayerEntity> player = playerService.getPlayerByEmail(email);
        return player.map(p -> ResponseEntity.ok(
                new ApiResponse<>(true, "Success", p, HttpStatus.OK.value())
        )).orElse(ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                new ApiResponse<>(false, "Player not found", null, HttpStatus.NOT_FOUND.value())
        ));
    }

    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    @PostMapping
    public ResponseEntity<ApiResponse<PlayerEntity>> createOrUpdatePlayer(@RequestBody PlayerEntity player) {
        PlayerEntity saved = playerService.savePlayer(player);
        return ResponseEntity.status(HttpStatus.CREATED).body(
                new ApiResponse<>(true, "Player saved successfully", saved, HttpStatus.CREATED.value())
        );
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deletePlayer(@PathVariable Long id) {
        Optional<PlayerEntity> player = playerService.getPlayerById(id);
        if (player.isPresent()) {
            playerService.deletePlayerById(id);
            return ResponseEntity.ok(
                    new ApiResponse<>(true, "Player deleted successfully", null, HttpStatus.OK.value())
            );
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                new ApiResponse<>(false, "Player not found", null, HttpStatus.NOT_FOUND.value())
        );
    }
}