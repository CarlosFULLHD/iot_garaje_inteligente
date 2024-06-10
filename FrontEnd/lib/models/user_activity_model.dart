class UserActivityModel {
  final int idReservation;
  final int userId;
  final int vehicleId;
  final int spotId;
  final String scheduledEntry;
  final String scheduledExit;
  final String actualEntry;
  final String actualExit;
  final String status;

  UserActivityModel({
    required this.idReservation,
    required this.userId,
    required this.vehicleId,
    required this.spotId,
    required this.scheduledEntry,
    required this.scheduledExit,
    required this.actualEntry,
    required this.actualExit,
    required this.status,
  });

  factory UserActivityModel.fromJson(Map<String, dynamic> json) {
    return UserActivityModel(
      idReservation: json['idReservation'],
      userId: json['userId'],
      vehicleId: json['vehicleId'],
      spotId: json['spotId'],
      scheduledEntry: json['scheduledEntry'],
      scheduledExit: json['scheduledExit'],
      actualEntry: json['actualEntry'],
      actualExit: json['actualExit'],
      status: json['status'],
    );
  }
}
