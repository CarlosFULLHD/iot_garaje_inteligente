package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.VehicleEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface VehiclesDao extends JpaRepository<VehicleEntity, Long> {

    Optional<VehicleEntity> findByLicensePlate(String licensePlate);

    Optional<Object> findByLicensePlateAndUserEntity(String licensePlate, UserEntity userEntity);

}
