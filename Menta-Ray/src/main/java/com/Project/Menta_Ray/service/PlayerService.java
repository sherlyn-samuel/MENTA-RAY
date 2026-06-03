package com.Project.Menta_Ray.service;

import com.Project.Menta_Ray.entity.PlayerEntity;
import com.Project.Menta_Ray.repository.PlayerRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PlayerService {

    private final PlayerRepository playerRepository;

    public PlayerService(PlayerRepository playerRepository) {
        this.playerRepository = playerRepository;
    }

    // Get All Players
    public List<PlayerEntity> getAllPlayers() {
        return playerRepository.findAll();
    }

    // Get Player by ID
    public Optional<PlayerEntity> getPlayerById(Long id) {
        return playerRepository.findById(id);
    }

    // Add or Update a Player
    public PlayerEntity savePlayer(PlayerEntity player) {
        return playerRepository.save(player);
    }

    // Delete Player by ID
    public void deletePlayerById(Long id) {
        playerRepository.deleteById(id);
    }

    // Find a Player by Email
    public Optional<PlayerEntity> getPlayerByEmail(String email) {
        return Optional.ofNullable(playerRepository.findByEmail(email));
    }
}
