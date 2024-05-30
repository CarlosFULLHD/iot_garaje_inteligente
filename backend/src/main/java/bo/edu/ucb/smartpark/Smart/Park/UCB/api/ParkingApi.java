package bo.edu.ucb.smartpark.Smart.Park.UCB.api;

import bo.edu.ucb.smartpark.Smart.Park.UCB.bl.ParkingBl;
import bo.edu.ucb.smartpark.Smart.Park.UCB.bl.ReservationBl;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.ParkingAndSpotsResponseDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.ReservationRequestDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.SpotResponseDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.ParkingResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.util.Globals;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(Globals.apiVersion + "parkings")
public class ParkingApi {
    private static final Logger LOG = LoggerFactory.getLogger(ParkingApi.class);
    private final ParkingBl parkingBl;
    private final ReservationBl reservationBl;

    public ParkingApi(ParkingBl parkingBl, ReservationBl reservationBl) {
        this.parkingBl = parkingBl;
        this.reservationBl = reservationBl;
    }

    @GetMapping
    public ResponseEntity<List<ParkingAndSpotsResponseDto>> getAllParkingsWithSpots() {
        List<ParkingAndSpotsResponseDto> parkingAndSpotsResponseDtos = parkingBl.getAllParkingsWithSpots();
        return ResponseEntity.ok(parkingAndSpotsResponseDtos);
    }

    @GetMapping("/{parkingId}/spots")
    public ResponseEntity<List<SpotResponseDto>> getSpotsByParkingId(@PathVariable Long parkingId) {
        List<SpotResponseDto> spotResponseDtos = parkingBl.getSpotsByParkingId(parkingId);
        return ResponseEntity.ok(spotResponseDtos);
    }

    @PostMapping("/reservations")
    public ResponseEntity<String> createReservation(@RequestBody ReservationRequestDto reservationRequestDto) {
        reservationBl.createReservation(reservationRequestDto);
        return ResponseEntity.ok("Reservation created successfully");
    }
}
