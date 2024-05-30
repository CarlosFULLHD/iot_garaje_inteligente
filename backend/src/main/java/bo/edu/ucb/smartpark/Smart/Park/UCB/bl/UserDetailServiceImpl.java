package bo.edu.ucb.smartpark.Smart.Park.UCB.bl;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Configuration.security.Jwt.JwtUtils;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.RolesHasUsersEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.RolesDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.UserDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request.AuthLoginrequest;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.AuthResponse;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class UserDetailServiceImpl implements UserDetailsService {

    private static final Logger LOG = LoggerFactory.getLogger(UserDetailServiceImpl.class);

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UserDao userDao;

    @Autowired
    private RolesDao rolesDao;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        LOG.info("Cargando el usuario por el nombre de usuario: {}", username);
        UserEntity userEntity = userDao.findUsersEntityByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("El usuario " + username + " no existe."));

        List<SimpleGrantedAuthority> authorityList = new ArrayList<>();

        // Asumiendo que un usuario tiene un solo rol activo
        for (RolesHasUsersEntity roleUser : userEntity.getRolesHasUsers()) {
            if (roleUser.getStatus() == 1) {  // O el valor que represente el estado activo
                String userRole = roleUser.getRoleEntity().getUserRole();
                authorityList.add(new SimpleGrantedAuthority("ROLE_" + userRole));
                break;
            }
        }

        CustomUserDetails customUserDetails = new CustomUserDetails(userEntity, authorityList);
        LOG.info("Usuario cargado: {}", customUserDetails.getUsername());
        return customUserDetails;
    }

    public AuthResponse loginUser(AuthLoginrequest authLoginRequest, HttpServletResponse response) {
        String username = authLoginRequest.getUsername();
        Optional<UserEntity> userEntity = userDao.findUsersEntityByUsername(username);
        if (userEntity.isEmpty()) {
            throw new UsernameNotFoundException("El usuario " + username + " no existe.");
        }
        String password = authLoginRequest.getPassword();

        Authentication authentication = this.authenticate(username, password);
        SecurityContextHolder.getContext().setAuthentication(authentication);

        String accessToken = jwtUtils.createToken(authentication);
        return new AuthResponse(username, "Usuario autenticado exitosamente", accessToken, true);
    }

    public Authentication authenticate(String username, String password) {
        UserDetails userDetails = this.loadUserByUsername(username);

        if (userDetails == null) {
            throw new BadCredentialsException(String.format("Invalid username or password"));
        }

        if (!passwordEncoder.matches(password, userDetails.getPassword())) {
            throw new BadCredentialsException("Incorrect Password");
        }
        Authentication authentication = new UsernamePasswordAuthenticationToken(userDetails, password, userDetails.getAuthorities());
        LOG.info("Authentication principal type: {}", authentication.getPrincipal().getClass());
        return authentication;
    }
}
