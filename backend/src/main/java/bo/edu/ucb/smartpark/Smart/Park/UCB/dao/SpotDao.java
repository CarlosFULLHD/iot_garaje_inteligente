package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.SpotEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface SpotDao extends JpaRepository<SpotEntity, Long> {

    // Agregar ordenación por número de espacio en orden ascendente
    List<SpotEntity> findByParkingEntity_IdParOrderBySpotNumberAsc(Long parkingId);


}
