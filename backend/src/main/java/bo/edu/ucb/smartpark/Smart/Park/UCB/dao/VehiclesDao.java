package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.VehicleEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VehiclesDao extends JpaRepository<VehicleEntity, Long> {

}
