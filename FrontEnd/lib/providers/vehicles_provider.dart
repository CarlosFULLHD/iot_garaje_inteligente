import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartpark/models/register_user_model.dart';
import 'package:smartpark/models/vehicles_model.dart';
import 'package:smartpark/providers/auth_provider.dart';
import 'package:smartpark/services/vehicles_services.dart';
import 'package:smartpark/style/colors.dart';
import 'package:smartpark/views/add_vehicles_view.dart';

class VehiclesProvider extends ChangeNotifier {
  void add(BuildContext context, AuthProvider authProvider) async {
    RegisterUserModel registerUser = RegisterUserModel(
      licensePlate: authProvider.licensePlateController.text,
      carBranch: authProvider.carBranchController.text,
      carModel: authProvider.carModelController.text,
      carColor: authProvider.carColorController.text,
      carManufacturingDate: authProvider.carManufacturingDateController.text,
    );
    final register = await addVehicles(registerUser);
    if(register) {
      context.pop();
      notifyListeners();
      final snackBar = SnackBar(
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating, 
        content: Text('Vehiculo agregado con exito', 
          style: const TextStyle(color: Colors.white)
        )
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      final snackBar = SnackBar(
        backgroundColor: AppColors.red,
        behavior: SnackBarBehavior.floating, 
        content: Text('No se pudo agregar el cliente, intente nuevamente', 
          style: const TextStyle(color: Colors.white)
        )
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void goToAddVehicles(BuildContext context) {
    context.pushNamed(AddVehiclesView.routerName);
  }

  Future<bool> addVehicles(registerUserModel) async {
    return VehiclesServices().addVehicles(registerUserModel);
  }

  Future<List<VehiclesModel>> getVehicles() async {
    return VehiclesServices().getVehicles();
  }
}