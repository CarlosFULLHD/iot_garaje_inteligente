package bo.edu.ucb.smartpark.Smart.Park.UCB.Controller;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("api/v1/user")
public class UserController {

    private final UserService userService;

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public ResponseEntity<List<UserEntity>> getAll(){
        return ResponseEntity.ok(userService.getAll());
    }
}
