package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;


import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.RolesHasUsersEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface UserDao extends JpaRepository<UserEntity, Long> {

    Optional<UserEntity> findUsersEntityByEmail(String email);


    Optional<Object> findByEmail(String email);

    boolean existsByPinCode(String pin);
}

