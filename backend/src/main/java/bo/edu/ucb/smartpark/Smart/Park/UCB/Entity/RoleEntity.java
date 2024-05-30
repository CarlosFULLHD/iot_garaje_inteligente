package bo.edu.ucb.smartpark.Smart.Park.UCB.Entity;

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
@Table(name = "roles")
public class RoleEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idRole;

    @Column(nullable = false)
    private String userRole;

    @Column(nullable = false)
    private String description;

    @Column(nullable = false)
    private short status;

    @Column(nullable = false, columnDefinition = "timestamp default current_timestamp")
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "roleEntity")
    private List<RolesHasUsersEntity> rolesHasUsers;
}
