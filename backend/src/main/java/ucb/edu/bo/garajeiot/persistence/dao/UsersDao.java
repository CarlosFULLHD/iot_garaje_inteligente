package ucb.edu.bo.garajeiot.persistence.dao;



import org.springframework.data.jpa.repository.JpaRepository;
import ucb.edu.bo.garajeiot.persistence.entity.UsersEntity;

import java.util.List;
import java.util.Optional;

public interface UsersDao extends JpaRepository<UsersEntity, Long> {


}

