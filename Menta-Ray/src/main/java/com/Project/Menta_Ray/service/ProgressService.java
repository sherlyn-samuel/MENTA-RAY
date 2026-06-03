package com.Project.Menta_Ray.service;

import com.Project.Menta_Ray.entity.PlayerEntity;
import com.Project.Menta_Ray.entity.ProgressEntity;
import com.Project.Menta_Ray.repository.ProgressRepository;
import com.Project.Menta_Ray.repository.PlayerRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProgressService {

    private final ProgressRepository progressRepository;
    private final PlayerRepository playerRepository;

    public ProgressService(ProgressRepository progressRepository, PlayerRepository playerRepository) {
        this.progressRepository = progressRepository;
        this.playerRepository = playerRepository;
    }

    public List<ProgressEntity> getAllProgress() {
        return progressRepository.findAll();
    }

    public Optional<ProgressEntity> getProgressById(Long id) {
        return progressRepository.findById(id);
    }

    public List<ProgressEntity> getProgressByPlayerId(Long playerId) {
        return progressRepository.findByPlayerId(playerId);
    }

    public ProgressEntity saveProgress(Long playerId, ProgressEntity progress) {
        PlayerEntity player = playerRepository.findById(playerId)
                .orElseThrow(() -> new IllegalArgumentException("Player not found with ID: " + playerId));
        progress.setPlayer(player);
        return progressRepository.save(progress);
    }

    public void deleteProgress(Long id) {
        if (!progressRepository.existsById(id)) {
            throw new IllegalArgumentException("Progress not found with ID: " + id);
        }
        progressRepository.deleteById(id);
    }
}