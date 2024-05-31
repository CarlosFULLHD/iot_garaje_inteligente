import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/providers/auth_provider.dart';
import 'package:smartpark/providers/vehicles_provider.dart';
import 'package:smartpark/style/colors.dart';
import 'package:smartpark/widgets/custom_button.dart';
import 'package:smartpark/widgets/custom_field.dart';

class AddVehiclesView extends StatelessWidget {
  static const String routerName = 'addVehicles';
  static const String routerPath = '/addVehicles';
  const AddVehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final vehiclesProvider = Provider.of<VehiclesProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agregar vehiculo', style: TextStyle(color: AppColors.dark, fontSize: 18),),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                CustomField(
                  controller: authProvider.licensePlateController,
                  hintText: 'Matricula',
                  keyboardType: TextInputType.text,
                  label: 'Matricula',
                  prefixIcon: const Icon(Icons.car_repair),
                ),
                const SizedBox(height: 16),
                CustomField(
                  controller: authProvider.carBranchController,
                  hintText: 'Marca',
                  keyboardType: TextInputType.text,
                  label: 'Marca',
                  prefixIcon: const Icon(Icons.assignment),
                ),
                const SizedBox(height: 16),
                CustomField(
                  controller: authProvider.carModelController,
                  hintText: 'Modelo',
                  keyboardType: TextInputType.text,
                  label: 'Modelo',
                  prefixIcon: const Icon(Icons.assignment),
                ),
                const SizedBox(height: 16),
                CustomField(
                  controller: authProvider.carColorController,
                  hintText: 'Color',
                  keyboardType: TextInputType.text,
                  label: 'Color',
                  prefixIcon: const Icon(Icons.palette),
                ),
                const SizedBox(height: 16),
                CustomField(
                  controller: authProvider.carManufacturingDateController,
                  hintText: 'Año de fabricación',
                  keyboardType: TextInputType.number,
                  label: 'Año de fabricación',
                  prefixIcon: const Icon(Icons.assignment),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: 'Registrar vehiculo', 
                  onPressed: () => vehiclesProvider.add(context, authProvider),
                ),
              ],
            ),
          )
        )
      ),
    );
  }
}