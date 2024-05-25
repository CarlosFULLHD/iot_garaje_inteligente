package ucb.edu.bo.garajeiot.persistence.entity;

import jakarta.persistence.*;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Component
@Entity(name = "users")
@Table(name = "users")
public class UsersEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_users", nullable = false)
    private Long idUsers;
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "person_id_person", referencedColumnName = "id_person")
    private PersonEntity personIdPerson;
    @Column(name = "username", nullable = false, length = 4000)
    private String username;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;


    @PrePersist
    protected void onCreate() {
        //status = 1;
        createdAt = LocalDateTime.now();
    }



}
