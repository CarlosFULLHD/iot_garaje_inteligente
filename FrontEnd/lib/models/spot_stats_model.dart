class SpotStatsModel {
  final int totalReservations;
  final double totalHoursOccupied;

  SpotStatsModel({required this.totalReservations, required this.totalHoursOccupied});

  factory SpotStatsModel.fromJson(Map<String, dynamic> json) {
    return SpotStatsModel(
      totalReservations: json['totalReservations'],
      totalHoursOccupied: (json['totalHoursOccupied'] as num).toDouble(), // Convertir a double
    );
  }
}


class ParkingStatsModel {
  final int parkingId;
  final String parkingName;
  final List<SpotStatsModel> spotUsageStats;
  bool isExpanded; // Añadimos la propiedad isExpanded

  ParkingStatsModel({required this.parkingId, required this.parkingName, required this.spotUsageStats, this.isExpanded = false});

  factory ParkingStatsModel.fromJson(Map<String, dynamic> json) {
    var list = json['spotUsageStats'] as List;
    List<SpotStatsModel> spotList = list.map((i) => SpotStatsModel.fromJson(i)).toList();

    return ParkingStatsModel(
      parkingId: json['parkingId'],
      parkingName: json['parkingName'],
      spotUsageStats: spotList,
    );
  }
}
