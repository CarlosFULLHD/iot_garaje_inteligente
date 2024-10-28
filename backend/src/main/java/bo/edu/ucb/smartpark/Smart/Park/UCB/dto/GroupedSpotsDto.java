package bo.edu.ucb.smartpark.Smart.Park.UCB.dto;

import java.util.List;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.SpotResponseDto;
public class GroupedSpotsDto {
    private List<SpotResponseDto> leftSpots;
    private List<SpotResponseDto> rightSpots;

    public GroupedSpotsDto(List<SpotResponseDto> leftSpots, List<SpotResponseDto> rightSpots) {
        this.leftSpots = leftSpots;
        this.rightSpots = rightSpots;
    }

    public List<SpotResponseDto> getLeftSpots() {
        return leftSpots;
    }

    public List<SpotResponseDto> getRightSpots() {
        return rightSpots;
    }
}
