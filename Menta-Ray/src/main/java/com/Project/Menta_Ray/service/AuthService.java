package com.Project.Menta_Ray.service;

import com.Project.Menta_Ray.dto.SignupRequest;
import com.Project.Menta_Ray.entity.PlayerEntity;
import com.Project.Menta_Ray.entity.ProgressEntity;
import com.Project.Menta_Ray.entity.Role;
import com.Project.Menta_Ray.entity.User;
import com.Project.Menta_Ray.repository.PlayerRepository;
import com.Project.Menta_Ray.repository.ProgressRepository;
import com.Project.Menta_Ray.repository.RoleRepository;
import com.Project.Menta_Ray.repository.URepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
public class AuthService {

    @Autowired
    private URepository usersRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private PlayerRepository playerRepository;

    @Autowired
    private ProgressRepository progressRepository;

    public void registerUser(SignupRequest signupRequest) {
        if (usersRepository.existsByUsername(signupRequest.getUsername())) {
            throw new RuntimeException("Username already exists");
        }

        // Create user
        User user = new User();
        user.setUsername(signupRequest.getUsername());
        user.setEmail(signupRequest.getEmail());
        user.setPassword(passwordEncoder.encode(signupRequest.getPassword()));

        Role role = roleRepository.findByName(signupRequest.getRole())
                .orElseThrow(() -> new RuntimeException("Role not found"));
        user.setRoles(Collections.singleton(role));
        usersRepository.save(user);

        // Auto-create player
        PlayerEntity player = new PlayerEntity();
        player.setEmail(signupRequest.getEmail());
        player.setProgress(0);
        player.setLeaderboardRank(0);

        playerRepository.save(player);

        // Auto-create progress
        ProgressEntity progress = new ProgressEntity();
        progress.setPlayer(player);
        progress.setLives(3);
        progress.setMathProgress(0);
        progress.setMathDifficulty(ProgressEntity.Difficulty.EASY);
        progress.setCoins(0);
        progressRepository.save(progress);
    }
}