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
@Table(name = "spots")
public class SpotEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idSpots;

    @ManyToOne
    @JoinColumn(name = "parking_id", nullable = false)
    private ParkingEntity parkingEntity;

    @Column(nullable = false)
    private int spotNumber;

    @Column(nullable = false)
    private int status; // 1 for available, 0 for occupied

    @Column(nullable = false, columnDefinition = "timestamp default current_timestamp")
    private LocalDateTime createdAt;

    @Column(nullable = false, columnDefinition = "timestamp default current_timestamp")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "spotEntity", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ReservationEntity> reservations;
}
