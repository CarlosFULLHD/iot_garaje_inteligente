import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/models/parking_model.dart';
import 'package:smartpark/providers/parking_provider.dart';
import 'package:smartpark/style/colors.dart';

class HomeView extends StatelessWidget {
  static const String routerName = 'home';
  static const String routerPath = '/home';
  @override
  Widget build(BuildContext context) {
    final parkingProvider = Provider.of<ParkingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parqueos inteligentes', style: TextStyle(color: AppColors.dark, fontSize: 18),),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: parkingProvider.getParkings(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            List<ParkingModel> parkings = snapshot.data as List<ParkingModel>;
            return ListView.builder(
              itemCount: parkings.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => parkingProvider.goSpaces(context, parkings[index]),
                  child: Card(
                    color: AppColors.white,
                    child: ListTile(
                      title: Text(parkings[index].name ?? ''),
                      subtitle: Text(parkings[index].location ?? ''),
                      trailing: Text(parkings[index].totalSpots.toString()),
                    ),
                  ),
                );
              },
            );	
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: 50,
                    child: Icon(Icons.person, size: 50, color: AppColors.white),
                  ),
                  // Text('User Name'),
                ],
              ),
            ),
            ListTile(
              title: Text('Mis Vehiculos'),
              onTap: () => parkingProvider.goToVehicle(context),
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}
