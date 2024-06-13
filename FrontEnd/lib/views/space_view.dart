// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/models/parking_model.dart';
import 'package:smartpark/models/reservation_model.dart';
import 'package:smartpark/models/spots_model.dart';
import 'package:smartpark/models/vehicles_model.dart';
import 'package:smartpark/providers/parking_provider.dart';
import 'package:smartpark/providers/reservation_provider.dart';
import 'package:smartpark/providers/vehicles_provider.dart';
import 'package:smartpark/style/colors.dart';

class SpaceView extends StatefulWidget {
  static const String routerName = 'space';
  static const String routerPath = '/space';
  const SpaceView({super.key, required this.argument});
  final Map argument;

  @override
  _SpaceViewState createState() => _SpaceViewState();
}

class _SpaceViewState extends State<SpaceView> {
  TimeOfDay selectedEntryTime = TimeOfDay.now();
  TimeOfDay selectedExitTime = TimeOfDay.now().replacing(minute: TimeOfDay.now().minute + 1);
  VehiclesModel? selectedVehicle;

  Future<void> _selectTime(BuildContext context, StateSetter setState, bool isEntryTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isEntryTime ? selectedEntryTime : selectedExitTime,
    );
    if (picked != null) {
      setState(() {
        if (isEntryTime) {
          selectedEntryTime = picked;
        } else {
          selectedExitTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final parkingProvider = Provider.of<ParkingProvider>(context);
    final reservationProvider = Provider.of<ReservationProvider>(context);
    
    final vehiclesProvider = Provider.of<VehiclesProvider>(context);
    final ParkingModel parking = widget.argument['parking'] as ParkingModel;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(parking.name ?? '', style: const TextStyle(color: AppColors.dark, fontSize: 18)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: Future.wait([
              parkingProvider.getParkingsById(parking.idPar),
              vehiclesProvider.getVehicles(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final List<dynamic> data = snapshot.data as List<dynamic>;
              final List<SpotsModel> spotsModel = data[0] as List<SpotsModel>;
              final List<VehiclesModel> vehicles = data[1] as List<VehiclesModel>;

              // ordenar sports por id
              spotsModel.sort((a, b) => a.idSpots!.compareTo(b.idSpots!));


              

              return GridView.builder(
                shrinkWrap: true,
                primary: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 120,
                  mainAxisSpacing: 4,
                  mainAxisExtent: 110,
                ),
                itemCount: spotsModel.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: spotsModel[index].status == 1
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text('¿Desea reservar este espacio?'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset('assets/images/car.svg', color: AppColors.green, width: 50),
                                          Text('Espacio ${spotsModel[index].spotNumber}', style: const TextStyle(color: AppColors.dark, fontSize: 18)),
                                          Text('Disponible', style: const TextStyle(color: AppColors.dark, fontSize: 18)),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Hora de entrada: ${selectedEntryTime.format(context)}',
                                                style: const TextStyle(color: AppColors.dark, fontSize: 18),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.access_time, color: AppColors.dark),
                                                onPressed: () {
                                                  _selectTime(context, setState, true);
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Hora de salida: ${selectedExitTime.format(context)}',
                                                style: const TextStyle(color: AppColors.dark, fontSize: 18),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.access_time, color: AppColors.dark),
                                                onPressed: () {
                                                  _selectTime(context, setState, false);
                                                },
                                              ),
                                            ],
                                          ),
                                          DropdownButton<VehiclesModel>(
                                            value: selectedVehicle,
                                            hint: const Text('Seleccione un vehículo'),
                                            items: vehicles.map((VehiclesModel vehicle) {
                                              return DropdownMenuItem<VehiclesModel>(
                                                value: vehicle,
                                                child: Text('${vehicle.carBranch} ${vehicle.carModel} - ${vehicle.licensePlate}'),
                                              );
                                            }).toList(),
                                            onChanged: (VehiclesModel? newValue) {
                                              setState(() {
                                                selectedVehicle = newValue;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancelar', style: TextStyle(color: AppColors.dark, fontSize: 18)),
                                        ),
                                        TextButton(
                                          onPressed:  () async {  
                                            // llamar al servicio de reservar espacio con los datos seleccionados
                                              final _storage = const FlutterSecureStorage();
                                            ReservationModel reservation = ReservationModel(
                                              
                                              userId: int.parse ( await _storage.read(key: 'userId') ?? '0'),
                                              
                                              vehicleId: selectedVehicle!.idVehicles,
                                              spotId: spotsModel[index].idSpots,
                                              scheduledEntry: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day,
                                                selectedEntryTime.hour,
                                                selectedEntryTime.minute,
                                              ),
                                              scheduledExit: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day,
                                                selectedExitTime.hour,
                                                selectedExitTime.minute,
                                              ),
                                            );
                                            bool isReserved = await reservationProvider.addReservation(reservation);
                                            if (isReserved) {
                                              Navigator.pop(context);
                                              final snackBar = SnackBar(
                                                backgroundColor: AppColors.green,
                                                behavior: SnackBarBehavior.floating,
                                                content: const Text(
                                                  'Espacio reservado correctamente',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            } else {
                                              final snackBar = SnackBar(
                                                backgroundColor: AppColors.red,
                                                behavior: SnackBarBehavior.floating,
                                                content: const Text(
                                                  'Error al reservar espacio',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                          
                                          },
                                          child: const Text('Reservar', style: TextStyle(color: AppColors.dark, fontSize: 18)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Transform(
                              alignment: FractionalOffset.center,
                              transform: Matrix4.identity()..rotateZ(90 * 3.1415927 / 180),
                              child: SvgPicture.asset('assets/images/car.svg', color: spotsModel[index].status == 1 ? AppColors.green : spotsModel[index].status == 2 ? Colors.yellow.withOpacity(0.8) : AppColors.red, width: 50),
                            ),
                            Text(parking.spots![index].spotNumber.toString(), style: const TextStyle(color: AppColors.dark, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
