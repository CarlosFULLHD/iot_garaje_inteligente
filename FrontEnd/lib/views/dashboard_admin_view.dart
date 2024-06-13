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
                    Center(child: Text('Gráfica General de Reservas por Spot', style: Theme.of(context).textTheme.headlineSmall)),
                    Container(
                      height: 300,
                      child: GeneralSpotUsageBarChart(createGeneralSpotUsageBarData(parkingStats)),
                    ),
                    SizedBox(height: 16),
                    Center(child: Text('Horas Ocupadas por Spot', style: Theme.of(context).textTheme.headlineSmall)),
                    Container(
                      height: 300,
                      child: GeneralSpotHoursOccupiedChart(createGeneralSpotHoursOccupiedBarData(parkingStats)),
                    ),
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Reservas: ${spotStats.totalReservations}'),
                    Text('Total Horas Ocupadas: ${spotStats.totalHoursOccupied}'),
                    SizedBox(
                      height: 200,
                      child: SpotUsageBarChart(createSpotUsageBarData([spotStats])),
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

  List<charts.Series<SpotUsage, String>> createSpotUsageBarData(List<SpotStatsModel> spotStats) {
    final data = spotStats.map((stats) {
      return SpotUsage(
        'Spot ${spotStats.indexOf(stats) + 1}',
        stats.totalReservations,
        stats.totalHoursOccupied,
      );
    }).toList();

    return [
      charts.Series<SpotUsage, String>(
        id: 'Total Reservas',
        domainFn: (SpotUsage usage, _) => usage.spot,
        measureFn: (SpotUsage usage, _) => usage.totalReservations,
        data: data,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
      charts.Series<SpotUsage, String>(
        id: 'Total Horas Ocupadas',
        domainFn: (SpotUsage usage, _) => usage.spot,
        measureFn: (SpotUsage usage, _) => usage.totalHoursOccupied,
        data: data,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      )..setAttribute(charts.rendererIdKey, 'customBar'),
    ];
  }

  List<charts.Series<GeneralSpotUsage, String>> createGeneralSpotUsageBarData(List<ParkingStatsModel> parkingStats) {
    final data = parkingStats.expand((parking) {
      return parking.spotUsageStats.map((stats) {
        return GeneralSpotUsage(
          'Spot ${parking.spotUsageStats.indexOf(stats) + 1}',
          stats.totalReservations,
        );
      }).toList();
    }).toList();

    return [
      charts.Series<GeneralSpotUsage, String>(
        id: 'Total Reservas',
        domainFn: (GeneralSpotUsage usage, _) => usage.spot,
        measureFn: (GeneralSpotUsage usage, _) => usage.totalReservations,
        data: data,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
    ];
  }

  List<charts.Series<GeneralSpotHoursOccupied, String>> createGeneralSpotHoursOccupiedBarData(List<ParkingStatsModel> parkingStats) {
    final data = parkingStats.expand((parking) {
      return parking.spotUsageStats.map((stats) {
        return GeneralSpotHoursOccupied(
          'Spot ${parking.spotUsageStats.indexOf(stats) + 1}',
          stats.totalHoursOccupied,
        );
      }).toList();
    }).toList();

    return [
      charts.Series<GeneralSpotHoursOccupied, String>(
        id: 'Total Horas Ocupadas',
        domainFn: (GeneralSpotHoursOccupied usage, _) => usage.spot,
        measureFn: (GeneralSpotHoursOccupied usage, _) => usage.totalHoursOccupied,
        data: data,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      ),
    ];
  }
}

class SpotUsageBarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  SpotUsageBarChart(this.seriesList, {this.animate = false});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
      customSeriesRenderers: [
        charts.BarTargetLineRendererConfig<String>(
          customRendererId: 'customBar',
        ),
      ],
    );
  }
}

class GeneralSpotUsageBarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  GeneralSpotUsageBarChart(this.seriesList, {this.animate = false});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }
}

class GeneralSpotHoursOccupiedChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  GeneralSpotHoursOccupiedChart(this.seriesList, {this.animate = false});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }
}

class SpotUsage {
  final String spot;
  final int totalReservations;
  final double totalHoursOccupied;

  SpotUsage(this.spot, this.totalReservations, this.totalHoursOccupied);
}

class GeneralSpotUsage {
  final String spot;
  final int totalReservations;

  GeneralSpotUsage(this.spot, this.totalReservations);
}

class GeneralSpotHoursOccupied {
  final String spot;
  final double totalHoursOccupied;

  GeneralSpotHoursOccupied(this.spot, this.totalHoursOccupied);
}
