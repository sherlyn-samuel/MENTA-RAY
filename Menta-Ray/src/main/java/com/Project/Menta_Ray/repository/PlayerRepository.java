package com.Project.Menta_Ray.repository;

import com.Project.Menta_Ray.entity.PlayerEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PlayerRepository extends JpaRepository<PlayerEntity, Long> {

    // Find Player by Email (Optional Method for Custom Queries)
    PlayerEntity findByEmail(String email);
}

