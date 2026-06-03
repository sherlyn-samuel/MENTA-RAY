package com.Project.Menta_Ray.repository;

import com.Project.Menta_Ray.entity.ProgressEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProgressRepository extends JpaRepository<ProgressEntity, Long> {

    // Find Progress by Player ID
    List<ProgressEntity> findByPlayerId(Long playerId);
}

