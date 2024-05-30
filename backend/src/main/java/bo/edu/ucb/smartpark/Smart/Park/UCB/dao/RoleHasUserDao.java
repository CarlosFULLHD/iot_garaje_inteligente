//package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;
//
//import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.RoleEntity;
//
//import org.springframework.data.domain.Page;
//import org.springframework.data.domain.Pageable;
//import org.springframework.data.jpa.repository.JpaRepository;
//import org.springframework.data.jpa.repository.Query;
//
//import java.util.List;
//import java.util.Optional;
//
//public interface RoleHasUserDao extends JpaRepository<RoleHasUserDao, Long> {
//    Optional<RoleHasUserDao> findByIdRolePerAndStatus(Long idRolePer, int status);
//
//    List<RoleHasUserDao> findByRolesIdRole_IdRoleAndStatus(Long idRole, int status);
//
//    // Este método busca RoleHasPersonEntity por el nombre del rol y el estado.
//    List<RoleHasUserDao> findByRolesIdRole_UserRoleAndStatus(String userRole, int status);
//
//    // Busca las entidades RoleHasPerson basadas en el RolesEntity asociado
//    List<RoleHasUserDao> findByRolesIdRole(RoleEntity rolesIdRole);
//
//    Page<RoleHasUserDao> findByRolesIdRoleAndStatus(String docente, int i, Pageable pageable);
//
//    Optional<RoleHasUserDao> findByUsersIdUsers_IdUsers(Long idUsers);
//
//
//}
