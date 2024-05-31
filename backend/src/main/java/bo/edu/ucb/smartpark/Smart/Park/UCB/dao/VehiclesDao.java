package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.VehicleEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface VehiclesDao extends JpaRepository<VehicleEntity, Long> {

    Optional<VehicleEntity> findByLicensePlate(String licensePlate);

    List<VehicleEntity> findByUserEntityIdUsers(Long userId);
}
