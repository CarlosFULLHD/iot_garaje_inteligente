package bo.edu.ucb.smartpark.Smart.Park.UCB.repository;

import bo.edu.ucb.smartpark.Smart.Park.UCB.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Integer> {
    // Métodos personalizados pueden ser definidos aquí
    UserEntity findByEmail(String email);
}