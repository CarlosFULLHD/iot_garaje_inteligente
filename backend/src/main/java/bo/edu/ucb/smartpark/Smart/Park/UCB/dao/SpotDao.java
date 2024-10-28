package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.SpotEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface SpotDao extends JpaRepository<SpotEntity, Long> {

    // Agregar ordenación por número de espacio en orden ascendente
    List<SpotEntity> findByParkingEntity_IdParOrderBySpotNumberAsc(Long parkingId);

    @Query("SELECT s FROM SpotEntity s WHERE s.parkingEntity.idPar = :parkingId ORDER BY s.spotNumber ASC")
    List<SpotEntity> findFirst10ByParkingId(@Param("parkingId") Long parkingId);

    // Obtener los siguientes 6 spots para un parqueo específico (offset de 10)
    @Query("SELECT s FROM SpotEntity s WHERE s.parkingEntity.idPar = :parkingId ORDER BY s.spotNumber ASC")
    List<SpotEntity> findNext6ByParkingId(@Param("parkingId") Long parkingId);

}