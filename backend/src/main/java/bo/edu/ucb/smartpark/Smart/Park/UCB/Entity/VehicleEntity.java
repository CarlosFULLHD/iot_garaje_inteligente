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
@Table(name = "vehicles")
public class VehicleEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idVehicles;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity userEntity;

    @Column(nullable = false, unique = true)
    private String licensePlate;

    @Column(nullable = false, columnDefinition = "timestamp default current_timestamp")
    private LocalDateTime createdAt;

    @Column(nullable = false, columnDefinition = "timestamp default current_timestamp")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "vehicleEntity")
    private List<ReservationEntity> reservationsReservationEntityList;
}
