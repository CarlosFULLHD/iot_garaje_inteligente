package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.ReservationEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.SpotEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ReservationDao extends JpaRepository<ReservationEntity, Long> {
    List<ReservationEntity> findByUserEntity_IdUsers(Long userId);

    Optional<ReservationEntity> findBySpotEntityAndStatus(SpotEntity spotEntity, String confirmed);
}
