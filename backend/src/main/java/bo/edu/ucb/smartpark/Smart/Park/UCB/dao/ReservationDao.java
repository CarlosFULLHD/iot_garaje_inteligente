package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.ReservationEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.SpotEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface ReservationDao extends JpaRepository<ReservationEntity, Long> {
    List<ReservationEntity> findByUserEntity_IdUsers(Long userId);

    Optional<ReservationEntity> findBySpotEntityAndStatus(SpotEntity spotEntity, String confirmed);

    long countByActualEntryIsNullAndActualExitIsNull();

    @Query("SELECT COUNT(r) FROM ReservationEntity r WHERE r.actualExit > r.scheduledExit")
    long countByActualExitAfterScheduledExit();

    @Query("SELECT r.spotEntity.idSpots, COUNT(r) FROM ReservationEntity r GROUP BY r.spotEntity.idSpots ORDER BY COUNT(r) DESC")
    List<Object[]> findSpotDemand();

    @Query("SELECT r.spotEntity.parkingEntity.idPar, COUNT(r) FROM ReservationEntity r GROUP BY r.spotEntity.parkingEntity.idPar ORDER BY COUNT(r) DESC")
    List<Object[]> findParkingDemand();

    @Query("SELECT r.scheduledEntry, COUNT(r) FROM ReservationEntity r GROUP BY r.scheduledEntry ORDER BY COUNT(r) DESC")
    List<Object[]> findPeakHours();

    @Query("SELECT r.userEntity.idUsers, COUNT(r) as count FROM ReservationEntity r GROUP BY r.userEntity.idUsers ORDER BY count DESC")
    List<Object[]> findFrequentUsers();
}
