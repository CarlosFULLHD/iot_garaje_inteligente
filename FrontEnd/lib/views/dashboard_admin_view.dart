import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:smartpark/providers/admin_dashboard_provider.dart';
import 'package:smartpark/models/spot_stats_model.dart';
import 'package:smartpark/models/parking_model.dart';

class DashboardAdminView extends StatefulWidget {
  static const String routerName = 'dashboard_admin';
  static const String routerPath = '/dashboard_admin';

  @override
  _DashboardAdminViewState createState() => _DashboardAdminViewState();
}

class _DashboardAdminViewState extends State<DashboardAdminView> {
  late Future<List<ParkingStatsModel>> _futureParkingStats;
  late AdminDashboardProvider _adminDashboardProvider;

  @override
  void initState() {
    super.initState();
    _adminDashboardProvider = Provider.of<AdminDashboardProvider>(context, listen: false);
    _futureParkingStats = _adminDashboardProvider.fetchAllSpotsStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin'),
      ),
      body: FutureBuilder<List<ParkingStatsModel>>(
        future: _futureParkingStats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error en FutureBuilder: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos disponibles'));
          } else {
            List<ParkingStatsModel> parkingStats = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child: Text('Estadísticas de Uso por Spot', style: Theme.of(context).textTheme.headlineSmall)),
                    buildExpansionPanels(parkingStats),
                    SizedBox(height: 16),
                    Center(child: Text('Gráfica General de Reservas por Parqueo', style: Theme.of(context).textTheme.headlineSmall)),
                    buildGeneralReservationsChart(parkingStats),
                    SizedBox(height: 16),
                    Center(child: Text('Gráfica General de Horas Ocupadas por Parqueo', style: Theme.of(context).textTheme.headlineSmall)),
                    buildGeneralHoursOccupiedChart(parkingStats),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildExpansionPanels(List<ParkingStatsModel> parkingStats) {
    return Column(
      children: parkingStats.map((ParkingStatsModel parking) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ExpansionTile(
            title: Text(parking.parkingName),
            children: parking.spotUsageStats.map((SpotStatsModel spotStats) {
              return ListTile(
                title: Text('Spot: ${parking.spotUsageStats.indexOf(spotStats) + 1}'),
                subtitle: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: [
                    buildInfoCard(
                      context,
                      'Spot: ${parking.spotUsageStats.indexOf(spotStats) + 1}',
                      spotStats.totalReservations.toString(),
                      'Reservas',
                      formatHours(spotStats.totalHoursOccupied),
                      'Total Horas Ocupadas',
                      Colors.blue,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget buildInfoCard(BuildContext context, String spotLabel, String reservations, String reservationsLabel, String totalHours, String hoursLabel, Color color) {
    return Card(
      color: color.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text(spotLabel, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white))),
            SizedBox(height: 8),
            Center(child: Text(reservations, style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white))),
            Center(child: Text(reservationsLabel, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white))),
            SizedBox(height: 8),
            Center(child: Text(totalHours, style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white))),
            Center(child: Text(hoursLabel, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white))),
          ],
        ),
      ),
    );
  }

  String formatHours(double hours) {
    // Omitir la parte desde que tiene -e para adelante
    final String hoursString = hours.toString().split('e')[0];
    final double parsedHours = double.parse(hoursString);
    print('Total hours: $parsedHours'); // Línea añadida para imprimir el valor de horas sin formatear
    final int totalSeconds = (parsedHours * 3600).round();
    final int h = totalSeconds ~/ 3600;
    final int m = (totalSeconds % 3600) ~/ 60;
    final int s = totalSeconds % 60;
    return '${h}h ${m}m ${s}s';
  }

  Widget buildGeneralReservationsChart(List<ParkingStatsModel> parkingStats) {
    final groupedData = _groupReservationsDataByParkingName(parkingStats);
    final colors = charts.MaterialPalette.getOrderedPalettes(groupedData.length);

    List<charts.Series<SpotReservationsData, String>> series = groupedData.entries.map((entry) {
      final color = colors[groupedData.keys.toList().indexOf(entry.key)].shadeDefault;
      return charts.Series<SpotReservationsData, String>(
        id: entry.key,
        domainFn: (SpotReservationsData data, _) => data.spot,
        measureFn: (SpotReservationsData data, _) => data.totalReservations,
        data: entry.value,
        colorFn: (_, __) => color,
      );
    }).toList();

    return Container(
      height: 300,
      child: charts.BarChart(
        series,
        animate: true,
        behaviors: [charts.SeriesLegend(), charts.PanAndZoomBehavior()],
      ),
    );
  }

  Widget buildGeneralHoursOccupiedChart(List<ParkingStatsModel> parkingStats) {
    final groupedData = _groupHoursDataByParkingName(parkingStats);
    final colors = charts.MaterialPalette.getOrderedPalettes(groupedData.length);

    List<charts.Series<SpotHoursOccupiedData, String>> series = groupedData.entries.map((entry) {
      final color = colors[groupedData.keys.toList().indexOf(entry.key)].shadeDefault;
      return charts.Series<SpotHoursOccupiedData, String>(
        id: entry.key,
        domainFn: (SpotHoursOccupiedData data, _) => data.spot,
        measureFn: (SpotHoursOccupiedData data, _) => data.totalHoursOccupied,
        data: entry.value,
        colorFn: (_, __) => color,
      );
    }).toList();

    return Container(
      height: 300,
      child: charts.BarChart(
        series,
        animate: true,
        behaviors: [charts.SeriesLegend(), charts.PanAndZoomBehavior()],
      ),
    );
  }

  Map<String, List<SpotReservationsData>> _groupReservationsDataByParkingName(List<ParkingStatsModel> parkingStats) {
    final Map<String, List<SpotReservationsData>> groupedData = {};

    for (var parking in parkingStats) {
      if (!groupedData.containsKey(parking.parkingName)) {
        groupedData[parking.parkingName] = [];
      }
      groupedData[parking.parkingName]!.addAll(parking.spotUsageStats.map((spotStats) {
        return SpotReservationsData(
          'Spot ${parking.spotUsageStats.indexOf(spotStats) + 1}',
          spotStats.totalReservations,
        );
      }).toList());
    }

    return groupedData;
  }

  Map<String, List<SpotHoursOccupiedData>> _groupHoursDataByParkingName(List<ParkingStatsModel> parkingStats) {
    final Map<String, List<SpotHoursOccupiedData>> groupedData = {};

    for (var parking in parkingStats) {
      if (!groupedData.containsKey(parking.parkingName)) {
        groupedData[parking.parkingName] = [];
      }
      groupedData[parking.parkingName]!.addAll(parking.spotUsageStats.map((spotStats) {
        return SpotHoursOccupiedData(
          'Spot ${parking.spotUsageStats.indexOf(spotStats) + 1}',
          _convertToHours(spotStats.totalHoursOccupied),
        );
      }).toList());
    }

    return groupedData;
  }

  double _convertToHours(double hours) {
    return double.parse(hours.toString().split('e')[0]);
  }
}

class SpotReservationsData {
  final String spot;
  final int totalReservations;

  SpotReservationsData(this.spot, this.totalReservations);
}

class SpotHoursOccupiedData {
  final String spot;
  final double totalHoursOccupied;

  SpotHoursOccupiedData(this.spot, this.totalHoursOccupied);
}
