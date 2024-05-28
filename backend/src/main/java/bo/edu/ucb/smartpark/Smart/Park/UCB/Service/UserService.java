package bo.edu.ucb.smartpark.Smart.Park.UCB.Service;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }


}
