package bo.edu.ucb.smartpark.Smart.Park.UCB.Entity;

import jakarta.persistence.*;
import lombok.*;

import java.sql.Timestamp;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString

@Entity
@Table(name = "user", uniqueConstraints = {@UniqueConstraint(columnNames = "email")})
public class UserEntity {

    @Id
    @Column(name = "user_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "last_name", nullable = false, length = 255)
    private String lastName;

    @Column(name = "email", nullable = false, length = 255, unique = true)
    private String email;

    @Column(name = "password", nullable = false, length = 255)
    private String password;

    @Column(name = "created_at", nullable = true, columnDefinition = "timestamp default current_timestamp")
    private Timestamp createdAt;

    @Column(name = "updated_at", nullable = true, columnDefinition = "timestamp default current_timestamp")
    private Timestamp updatedAt;

    @Column(name = "rol_id", nullable = false)
    private int rolId;


}