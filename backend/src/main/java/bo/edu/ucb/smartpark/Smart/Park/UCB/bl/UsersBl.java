package bo.edu.ucb.smartpark.Smart.Park.UCB.bl;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.VehicleEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.UserDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.VehiclesDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.SuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.UnsuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request.RegisterUserRequest;

import bo.edu.ucb.smartpark.Smart.Park.UCB.util.Globals;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class UsersBl {

    private final UserDao userDao;
    private final VehiclesDao vehiclesDao;
    private final PasswordEncoder passwordEncoder;
    private static final Logger LOG = LoggerFactory.getLogger(UsersBl.class);

    public UsersBl(UserDao userDao, VehiclesDao vehiclesDao, PasswordEncoder passwordEncoder) {
        this.userDao = userDao;
        this.vehiclesDao = vehiclesDao;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public Object registerUser(RegisterUserRequest request) {
        try {
            // Check if email is already used
            if (userDao.findByEmail(request.getEmail()).isPresent()) {
                return new UnsuccessfulResponse(Globals.httpBadRequest[0], Globals.httpBadRequest[1], "Email is already in use");
            }

            // Create new UsersEntity
            UserEntity userEntity = new UserEntity();
            userEntity.setName(request.getName());
            userEntity.setLastName(request.getLastName());
            userEntity.setEmail(request.getEmail());
            userEntity.setPassword(passwordEncoder.encode(request.getPassword()));
            userEntity.setPinCode(request.getPinCode());
            userEntity.setCreatedAt(LocalDateTime.now());
            userDao.save(userEntity);

            // Create new VehiclesEntity
            VehicleEntity vehicleEntity = new VehicleEntity();
            vehicleEntity.setLicensePlate(request.getLicensePlate());
            vehicleEntity.setUserEntity(userEntity);
            vehiclesDao.save(vehicleEntity);

            return new SuccessfulResponse(Globals.httpOkStatus[0], Globals.httpOkStatus[1], "User registered successfully");
        } catch (Exception e) {
            LOG.error("Error registering user", e);
            return new UnsuccessfulResponse(Globals.httpInternalServerErrorStatus[0], Globals.httpInternalServerErrorStatus[1], "Error registering user");
        }
    }
}
