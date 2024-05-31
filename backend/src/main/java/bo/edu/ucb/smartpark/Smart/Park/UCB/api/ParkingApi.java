package bo.edu.ucb.smartpark.Smart.Park.UCB.api;

import bo.edu.ucb.smartpark.Smart.Park.UCB.bl.ParkingBl;
import bo.edu.ucb.smartpark.Smart.Park.UCB.bl.ReservationBl;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.*;
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

    //Listar todos los parqueo con informacion de sus spots
    @GetMapping
    public ResponseEntity<List<ParkingAndSpotsResponseDto>> getAllParkingsWithSpots() {
        List<ParkingAndSpotsResponseDto> parkingAndSpotsResponseDtos = parkingBl.getAllParkingsWithSpots();
        return ResponseEntity.ok(parkingAndSpotsResponseDtos);
    }

    //Obtener la info de un parqueo al igual que sus spots por ParkingId
    @GetMapping("/{parkingId}/spots")
    public ResponseEntity<List<SpotResponseDto>> getSpotsByParkingId(@PathVariable Long parkingId) {
        List<SpotResponseDto> spotResponseDtos = parkingBl.getSpotsByParkingId(parkingId);
        return ResponseEntity.ok(spotResponseDtos);
    }

    //Endpoint para crear una reserva en el sistema para parqueo
    @PostMapping("/reservations")
    public ResponseEntity<String> createReservation(@RequestBody ReservationRequestDto reservationRequestDto) {
        reservationBl.createReservation(reservationRequestDto);
        return ResponseEntity.ok("Reservation created successfully");
    }

    @PostMapping("/spots/update")
    public ResponseEntity<String> updateSpaceStatus(@RequestBody SpaceStatusUpdateDto spaceStatusUpdateDto) {
        parkingBl.updateSpaceStatus(spaceStatusUpdateDto);
        return ResponseEntity.ok("Space status updated successfully");
    }
    // Obtener detalles de una reserva específica
    @GetMapping("/reservations/{reservationId}")
    public ResponseEntity<ReservationDetailsDto> getReservationDetails(@PathVariable Long reservationId) {
        ReservationDetailsDto reservationDetails = reservationBl.getReservationDetails(reservationId);
        return ResponseEntity.ok(reservationDetails);
    }

    // Cancelar una reserva
    @DeleteMapping("/reservations/{reservationId}")
    public ResponseEntity<String> cancelReservation(@PathVariable Long reservationId) {
        reservationBl.cancelReservation(reservationId);
        return ResponseEntity.ok("Reservation cancelled successfully");
    }

    // Obtener todas las reservas de un usuario
    @GetMapping("/users/{userId}/reservations")
    public ResponseEntity<List<ReservationDetailsDto>> getUserReservations(@PathVariable Long userId) {
        List<ReservationDetailsDto> reservations = reservationBl.getUserReservations(userId);
        return ResponseEntity.ok(reservations);
    }

}
