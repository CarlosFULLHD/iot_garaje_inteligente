import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/models/parking_model.dart';
import 'package:smartpark/providers/parking_provider.dart';
import 'package:smartpark/style/colors.dart';
import 'package:smartpark/utils/constants.dart';
import 'package:smartpark/views/dashboard_admin_view.dart';
import 'package:smartpark/views/login_view.dart';
import 'package:smartpark/views/activity_view.dart';
import 'package:smartpark/views/vehicle_activity_view.dart';

class HomeView extends StatelessWidget {
  static const String routerName = 'home';
  static const String routerPath = '/home';

  @override
  Widget build(BuildContext context) {
    final parkingProvider = Provider.of<ParkingProvider>(context);
    final _storage = const FlutterSecureStorage();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parqueos inteligentes',
          style: TextStyle(color: AppColors.dark, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Ejecutar animación de logout
              await _showLogoutAnimation(context);
              // Redireccionar al login
              await _storage.deleteAll();
              context.goNamed(LoginView.routerName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: parkingProvider.getParkings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
        child: FutureBuilder<Map<String, String?>>(
          future: _getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: Text('Error al cargar la información del usuario'));
            } else {
              String userName = snapshot.data?['name'] ?? 'Usuario';
              String userRole = snapshot.data?['role'] ?? 'Rol desconocido';
              return ListView(
                children: [
                  DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: 40,
                          child: Icon(Icons.person, size: 40, color: AppColors.white),
                        ),
                        SizedBox(height: 9),
                        Flexible(
                          child: Text(
                            userName,
                            style: TextStyle(
                              color: Color.fromARGB(255, 31, 42, 197),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black45,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 1),
                        Flexible(
                          child: Text(
                            userRole,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Mis Vehiculos'),
                    onTap: () => parkingProvider.goToVehicle(context),
                  ),
                  ListTile(
                    title: Text('Mi Actividad'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ActivityView()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Actividad de Vehículos'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VehicleActivityView()),
                      );
                    },
                  ),
                  if (userRole == 'ADMIN') // Mostrar solo si el usuario es ADMIN
                    ListTile(
                      title: Text('Actividad Administrador'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DashboardAdminView()),
                        );
                      },
                    ),
                  ListTile(
                    title: Text('Settings'),
                    onTap: () {},
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _showLogoutAnimation(BuildContext context) async {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return Center(
          child: RotatingCircle(),
        );
      },
    );

    // Insertar el overlay entry
    Overlay.of(context)!.insert(overlayEntry);

    // Esperar un poco para mostrar la animación
    await Future.delayed(Duration(seconds: 2));

    // Eliminar el overlay entry
    overlayEntry.remove();
  }

  Future<Map<String, String?>> _getUserInfo() async {
    final _storage = const FlutterSecureStorage();
    String? name = await _storage.read(key: Constants.ssName);
    String? role = await _storage.read(key: Constants.ssRole);
    return {'name': name, 'role': role};
  }
}

class RotatingCircle extends StatefulWidget {
  @override
  _RotatingCircleState createState() => _RotatingCircleState();
}

class _RotatingCircleState extends State<RotatingCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 6.3,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.logout, color: AppColors.white, size: 50),
          ),
        );
      },
    );
  }
}
