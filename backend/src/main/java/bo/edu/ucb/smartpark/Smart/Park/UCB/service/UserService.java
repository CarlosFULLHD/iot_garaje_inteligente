package bo.edu.ucb.smartpark.Smart.Park.UCB.service;

import bo.edu.ucb.smartpark.Smart.Park.UCB.entity.RolEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.entity.UserEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.repository.RolRepository;
import bo.edu.ucb.smartpark.Smart.Park.UCB.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RolRepository rolRepository;

    public List<UserEntity> getAllUsers() {
        return userRepository.findAll();
    }

    public UserEntity getUserById(int id) {
        return userRepository.findById(id).orElse(null);
    }

    public UserEntity getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public RolEntity getRolById(int id) {
        return rolRepository.findById(id).orElse(null);
    }

    public RolEntity getRolByName(String name) {
        return rolRepository.findByName(name);
    }

    public UserEntity saveUser(UserEntity user) {
        return userRepository.save(user);
    }

    public void deleteUserById(int id) {
        userRepository.deleteById(id);
    }
}
