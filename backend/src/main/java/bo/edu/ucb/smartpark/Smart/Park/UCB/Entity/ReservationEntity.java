package bo.edu.ucb.smartpark.Smart.Park.UCB.Entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "reservations")
public class ReservationEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idRes;

    @ManyToOne
    @JoinColumn(name = "users_id", nullable = false)
    private UserEntity userEntity;

    @ManyToOne
    @JoinColumn(name = "vehicles_id", nullable = false)
    private VehicleEntity vehicleEntity;

    @ManyToOne
    @JoinColumn(name = "spots_id", nullable = false)
    private SpotEntity spotEntity;

    @Column(nullable = false)
    private LocalDateTime scheduledEntry;

    @Column(nullable = false)
    private LocalDateTime scheduledExit;

    private LocalDateTime actualEntry;
    private LocalDateTime actualExit;

    @Column(nullable = false)
    private String status;

    @Column(nullable = false, columnDefinition = "timestamp default current_timestamp")
    private LocalDateTime createdAt;

    @Column(nullable = false, columnDefinition = "timestamp default current_timestamp")
    private LocalDateTime updatedAt;


}
