package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.ParkingEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ParkingDao extends JpaRepository<ParkingEntity, Long> {
    // Additional custom queries if needed
}