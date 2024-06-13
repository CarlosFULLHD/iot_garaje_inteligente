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
        title: const Text(
          'Mis vehículos',
          style: TextStyle(color: AppColors.dark, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => vehiclesProvider.goToAddVehicles(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<VehiclesModel>>(
          future: vehiclesProvider.getVehicles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error al cargar los datos'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay vehículos disponibles'));
            }

            final List<VehiclesModel> vehicles = snapshot.data!;
            return ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                return Card(
                  color: AppColors.white,
                  child: ListTile(
                    title: Text('${vehicles[index].carBranch} ${vehicles[index].carModel}'),
                    subtitle: Text(vehicles[index].licensePlate ?? ''),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
