import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/models/vehicles_model.dart';
import 'package:smartpark/providers/vehicles_provider.dart';
import 'package:smartpark/style/colors.dart';

class VehiclesView extends StatelessWidget {
  static const String routerName = 'vehicles';
  static const String routerPath = '/vehicles';
  const VehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    final vehiclesProvider = Provider.of<VehiclesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis vehiculos', style: TextStyle(color: AppColors.dark, fontSize: 18),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: vehiclesProvider.getVehicles(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<VehiclesModel> vehicles = snapshot.data as List<VehiclesModel>;
            return ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                return Card(
                  color: AppColors.white,
                  child: ListTile(
                    title: Text('${vehicles[index].carBranch} ${vehicles[index].carModel}' ?? ''),
                    subtitle: Text(vehicles[index].licensePlate ?? ''),
                  ),
                );
              },
            );
          },
        ),
      )
    );
  }
}