import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/models/user_activity_model.dart';
import 'package:smartpark/providers/activity_provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class VehicleActivityView extends StatelessWidget {
  static const String routerName = 'vehicle-activity';
  static const String routerPath = '/vehicle-activity';

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Actividad de Vehículos'),
      ),
      body: FutureBuilder<List<UserActivityModel>>(
        future: activityProvider.fetchUserActivity("5"), // Cambia "userId" por el ID real del usuario
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error en FutureBuilder: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos disponibles'));
          } else {
            List<UserActivityModel> activities = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child: Text('Actividad por Vehículo', style: Theme.of(context).textTheme.headlineSmall)),
                    Container(
                      height: 200,
                      child: BarChartSample(createBarChartData(activities)),
                    ),
                    SizedBox(height: 16),
                    Center(child: Text('Tendencia de Uso', style: Theme.of(context).textTheme.headlineSmall)),
                    Container(
                      height: 200,
                      child: LineChartSample(createLineChartData(activities)),
                    ),
                    SizedBox(height: 16),
                    Center(child: Text('Detalles de Actividad', style: Theme.of(context).textTheme.headlineSmall)),
                    buildDetailCards(context, activities),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  List<charts.Series<Reservation, String>> createBarChartData(List<UserActivityModel> activities) {
    final Map<String, int> dataMap = {};
    for (var activity in activities) {
      final date = activity.scheduledEntry.split('T')[0];
      if (dataMap.containsKey(date)) {
        dataMap[date] = dataMap[date]! + 1;
      } else {
        dataMap[date] = 1;
      }
    }

    final data = dataMap.entries.map((entry) => Reservation(entry.key, entry.value)).toList();

    return [
      charts.Series<Reservation, String>(
        id: 'Actividad',
        domainFn: (Reservation reservation, _) => reservation.date,
        measureFn: (Reservation reservation, _) => reservation.count,
        data: data,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFFB8E0E3)),
      )
    ];
  }

  List<charts.Series<ReservationTime, DateTime>> createLineChartData(List<UserActivityModel> activities) {
    final List<ReservationTime> data = [];

    for (var activity in activities) {
      final date = DateTime.parse(activity.scheduledEntry);
      data.add(ReservationTime(date, 1));
    }

    return [
      charts.Series<ReservationTime, DateTime>(
        id: 'Tendencia',
        domainFn: (ReservationTime time, _) => time.date,
        measureFn: (ReservationTime time, _) => time.count,
        data: data,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF97C5D8)),
      ),
    ];
  }

  Widget buildDetailCards(BuildContext context, List<UserActivityModel> activities) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        UserActivityModel activity = activities[index];
        return Card(
          color: index % 2 == 0 ? Color(0xFFB8E0E3) : Color(0xFFFAE39C),
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vehículo ID: ${activity.vehicleId}', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                Text('Usuario ID: ${activity.userId}'),
                Text('Reserva ID: ${activity.idReservation}'),
                Text('Entrada Programada: ${activity.scheduledEntry}'),
                Text('Salida Programada: ${activity.scheduledExit}'),
                Text('Entrada Real: ${activity.actualEntry}'),
                Text('Salida Real: ${activity.actualExit}'),
                Text('Estado: ${activity.status}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BarChartSample extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  BarChartSample(this.seriesList, {this.animate = false});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
    );
  }
}

class LineChartSample extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;

  LineChartSample(this.seriesList, {this.animate = false});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
    );
  }
}

class Reservation {
  final String date;
  final int count;

  Reservation(this.date, this.count);
}

class ReservationTime {
  final DateTime date;
  final int count;

  ReservationTime(this.date, this.count);

  @override
  String toString() {
    return '{date: $date, count: $count}';
  }
}