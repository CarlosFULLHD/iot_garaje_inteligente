package bo.edu.ucb.smartpark.Smart.Park.UCB.Entity;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Getter
@Table(name = "roles_has_users")
public class RolesHasUsersEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idRoleUs;

    @ManyToOne
    @JoinColumn(name = "roles_id_role", nullable = false)
    private RoleEntity roleEntity;

    @ManyToOne
    @JoinColumn(name = "users_id_users", nullable = false)
    private UserEntity userEntity;

    @Column(nullable = false)
    private short status;

    @Column(nullable = false, columnDefinition = "timestamp default current_timestamp")
    private LocalDateTime createdAt;
}
