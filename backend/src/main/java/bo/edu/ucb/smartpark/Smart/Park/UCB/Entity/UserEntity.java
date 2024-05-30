package bo.edu.ucb.smartpark.Smart.Park.UCB.Entity;

import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.UserDTO;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Getter
@Setter
@Table(name = "users", uniqueConstraints = {@UniqueConstraint(columnNames = "email")})
public class UserEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idUsers;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String lastName;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false, unique = true)
    private String pinCode;

    @Column(nullable = false, columnDefinition = "timestamp default current_timestamp")
    private LocalDateTime createdAt;

    @Column(nullable = false, columnDefinition = "timestamp default current_timestamp")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "userEntity")
    private List<VehicleEntity> vehicles;

    @OneToMany(mappedBy = "userEntity")
    private List<ReservationEntity> reservations;

    @OneToMany(mappedBy = "userEntity")
    private List<RolesHasUsersEntity> rolesHasUsers;


}