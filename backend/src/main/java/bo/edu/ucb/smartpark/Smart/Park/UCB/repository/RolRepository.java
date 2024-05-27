package bo.edu.ucb.smartpark.Smart.Park.UCB.repository;


import bo.edu.ucb.smartpark.Smart.Park.UCB.entity.RolEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RolRepository extends JpaRepository<RolEntity, Integer> {
    // Métodos personalizados pueden ser definidos aquí
    RolEntity findByName(String name);
}