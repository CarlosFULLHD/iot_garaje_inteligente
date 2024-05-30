package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.RoleEntity;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RolesDao extends JpaRepository<RoleEntity, Long> {

    Optional<RoleEntity> findByUserRole(String user);
}
