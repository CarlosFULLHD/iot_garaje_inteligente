package bo.edu.ucb.smartpark.Smart.Park.UCB.dao;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.RolesHasUsersEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RolesHasUsersDao extends JpaRepository<RolesHasUsersEntity, Long> {
}
