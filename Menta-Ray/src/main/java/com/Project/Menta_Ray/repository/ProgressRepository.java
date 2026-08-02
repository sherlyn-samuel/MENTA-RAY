package com.Project.Menta_Ray.repository;

import com.Project.Menta_Ray.entity.ProgressEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProgressRepository extends JpaRepository<ProgressEntity, Long> {

    List<ProgressEntity> findByPlayerId(Long playerId);

    @Query("SELECT p FROM ProgressEntity p ORDER BY p.mathProgress DESC")
    List<ProgressEntity> findTop5ByOrderByMathProgressDesc(org.springframework.data.domain.Pageable pageable);
}