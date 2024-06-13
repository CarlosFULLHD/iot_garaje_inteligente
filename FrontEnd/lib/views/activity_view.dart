import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:smartpark/models/user_activity_model.dart';
import 'package:smartpark/providers/activity_provider.dart';

class ActivityView extends StatelessWidget {
  static const String routerName = 'activity';
  static const String routerPath = '/activity';

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    final String userId = "1"; // Reemplaza con el ID de usuario real

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Actividad'),
      ),
      body: FutureBuilder<List<UserActivityModel>>(
        future: activityProvider.fetchUserActivity(userId),
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
            print("Activities: $activities");
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child: Text('Reservas por Día', style: Theme.of(context).textTheme.headlineSmall)),
                    Container(
                      height: 200,
                      child: BarChartSample(createBarChartData(activities)),
                    ),
                    SizedBox(height: 16),
                    Center(child: Text('Proporción de Reservas', style: Theme.of(context).textTheme.headlineSmall)),
                    buildProportionCards(context, activities),
                    SizedBox(height: 16),
                    Center(child: Text('Entradas y Salidas Programadas', style: Theme.of(context).textTheme.headlineSmall)),
                    Container(
                      height: 200,
                      child: LineChartSample(createLineChartData(activities)),
                    ),
                    SizedBox(height: 16),
                    Center(child: Text('Detalles de Reservas', style: Theme.of(context).textTheme.headlineSmall)),
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
    print("Bar Chart Data: $data");

    return [
      charts.Series<Reservation, String>(
        id: 'Reservas',
        domainFn: (Reservation reservation, _) => reservation.date,
        measureFn: (Reservation reservation, _) => reservation.count,
        data: data,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFFB8E0E3)),
      )
    ];
  }

  Widget buildProportionCards(BuildContext context, List<UserActivityModel> activities) {
    int completed = 0;
    int canceled = 0;
    int pending = 0;

    for (var activity in activities) {
      if (activity.status == 'COMPLETED') {
        completed++;
      } else if (activity.status == 'CANCELED') {
        canceled++;
      } else {
        pending++;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: buildProportionCard(context, 'Completadas', completed, Colors.green),
        ),
        Flexible(
          child: buildProportionCard(context, 'Canceladas', canceled, Colors.red),
        ),
        Flexible(
          child: buildProportionCard(context, 'Pendientes', pending, Color(0xFFFAC375)),
        ),
      ],
    );
  }

  Widget buildProportionCard(BuildContext context, String label, int count, Color color) {
    return Card(
      color: color.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white)),
            SizedBox(height: 8),
            Text(count.toString(), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
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
                Text('Reserva ID: ${activity.idReservation}', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                Text('Usuario ID: ${activity.userId}'),
                Text('Vehículo ID: ${activity.vehicleId}'),
                Text('Spot ID: ${activity.spotId}'),
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

  List<charts.Series<ReservationTime, DateTime>> createLineChartData(List<UserActivityModel> activities) {
    final List<ReservationTime> dataScheduled = [];
    final List<ReservationTime> dataActual = [];

    for (var activity in activities) {
      dataScheduled.add(ReservationTime(DateTime.parse(activity.scheduledEntry), 1));
      dataScheduled.add(ReservationTime(DateTime.parse(activity.scheduledExit), -1));

      dataActual.add(ReservationTime(DateTime.parse(activity.actualEntry), 1));
      dataActual.add(ReservationTime(DateTime.parse(activity.actualExit), -1));
    }

    print("Line Chart Data (Scheduled): $dataScheduled");
    print("Line Chart Data (Actual): $dataActual");

    return [
      charts.Series<ReservationTime, DateTime>(
        id: 'Programadas',
        domainFn: (ReservationTime time, _) => time.date,
        measureFn: (ReservationTime time, _) => time.count,
        data: dataScheduled,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFFFAC375)),
      ),
      charts.Series<ReservationTime, DateTime>(
        id: 'Reales',
        domainFn: (ReservationTime time, _) => time.date,
        measureFn: (ReservationTime time, _) => time.count,
        data: dataActual,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF97C5D8)),
      ),
    ];
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

  @override
  String toString() {
    return '{date: $date, count: $count}';
  }
}

class ReservationStatus {
  final String status;
  final int count;

  ReservationStatus(this.status, this.count);

  @override
  String toString() {
    return '{status: $status, count: $count}';
  }
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