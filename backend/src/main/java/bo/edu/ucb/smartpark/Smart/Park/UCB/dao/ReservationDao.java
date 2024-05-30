package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.ReservationEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReservationDao extends JpaRepository<ReservationEntity, Long> {
}
