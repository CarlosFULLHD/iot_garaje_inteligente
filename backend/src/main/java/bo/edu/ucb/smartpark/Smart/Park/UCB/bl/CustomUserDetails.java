package bo.edu.ucb.smartpark.Smart.Park.UCB.bl;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.RolesHasUsersEntity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.stream.Collectors;

public class CustomUserDetails implements UserDetails {
    private static final Logger LOG = LoggerFactory.getLogger(CustomUserDetails.class);

    private final UserEntity userEntity;
    private final Collection<? extends GrantedAuthority> authorities;

    public CustomUserDetails(UserEntity userEntity, Collection<? extends GrantedAuthority> authorities) {
        this.userEntity = userEntity;
        this.authorities = authorities;
    }

    // Retorna el nombre completo (nombre + apellido)
    public String getFullName() {
        return String.format("%s %s", userEntity.getName(), userEntity.getLastName());
    }

    public Long getIdUsers() {
        return userEntity.getIdUsers();
    }

    public String getPersonName() {
        return userEntity.getName();
    }

    // Obtener el rol relacionado al usuario
    public String getUserRole() {
        for (RolesHasUsersEntity roleUser : userEntity.getRolesHasUsers()) {
            if (roleUser.getStatus() == 1) {  // Estado activo
                LOG.info("Rol encontrado para el usuario {}: {}", userEntity.getEmail(), roleUser.getRoleEntity().getUserRole());
                return roleUser.getRoleEntity().getUserRole();
            }
        }
        LOG.warn("No se encontró un rol activo para el usuario: {}", userEntity.getEmail());
        return null; // O lanzar una excepción si no se encuentra un rol activo
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return userEntity.getPassword();
    }

    @Override
    public String getUsername() {
        return userEntity.getEmail();
    }

    // Métodos de UserDetails
    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true; // Considerar como habilitado
    }
}
