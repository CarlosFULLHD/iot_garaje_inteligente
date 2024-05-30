package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;


import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.RolesHasUsersEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface UserDao extends JpaRepository<UserEntity, Long> {

    Optional<UserEntity> findUsersEntityByUsername(String username);

    Optional<UserEntity> findByIdUsersAndStatus(Long idUsers, int status);

    Optional<UserEntity> findById(Long idUsers);


    // Ajuste para filtrar por RoleHasPersonEntity y estado
    // Asegúrate de que el método corresponda con la lógica y estructura de tu base de datos
    List<UserEntity> findByRoleHasPersonEntityAndStatus(RolesHasUsersEntity roleHasPerson, int status);


    Optional<Object> findByEmail(String email);
}

