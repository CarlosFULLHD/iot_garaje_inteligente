package bo.edu.ucb.smartpark.Smart.Park.UCB.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsersAndVehiclesResponseDto {

    private Long idUser;
    private String name;
    private String lastName;
    private String email;
    private String licensePlate;
    private String carBranch;
    private String carModel;
    private String carColor;
    private String carManufacturingDate;
    private List<VehiclesDto> vehicles;
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
        public static class VehiclesDto {
            private Long idVehicles;
            private String licensePlate;
            private String carBranch;
            private String carModel;
            private String carColor;
            private String carManufacturingDate;
        }
        public UsersAndVehiclesResponseDto UsersAndVehiclesResponseDtoToResponse(UsersAndVehiclesResponseDto entity){
            UsersAndVehiclesResponseDto responseDto = new UsersAndVehiclesResponseDto();
            responseDto.setIdUser(entity.getIdUser());
            responseDto.setName(entity.getName());
            responseDto.setLastName(entity.getLastName());
            responseDto.setEmail(entity.getEmail());
            responseDto.setLicensePlate(entity.getLicensePlate());
            responseDto.setCarBranch(entity.getCarBranch());
            responseDto.setCarModel(entity.getCarModel());
            responseDto.setCarColor(entity.getCarColor());
            responseDto.setCarManufacturingDate(entity.getCarManufacturingDate());
            return responseDto;
        }


}
