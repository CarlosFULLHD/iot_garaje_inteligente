package bo.edu.ucb.smartpark.Smart.Park.UCB.Repository;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Integer> {
    // Puedes agregar métodos de consulta personalizados aquí si es necesario.

    UserEntity findByEmail(String email);
}