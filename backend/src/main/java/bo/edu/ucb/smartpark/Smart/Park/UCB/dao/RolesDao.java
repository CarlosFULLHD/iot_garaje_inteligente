package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.RoleEntity;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RolesDao extends JpaRepository<RoleEntity, Long> {

    Optional<RoleEntity> findByIdRoleAndUserRole(Long idRole, String userRole);
    Optional<RoleEntity> findById(Long idRole);
    Optional<RoleEntity> findByUserRole(String userRole);

    Optional<RoleEntity> findByUserRoleAndStatus(String userRole, int status);
    Optional<RoleEntity> findByIdRoleAndStatusAndUserRole(Long idRole, int status, String userRole);

}
