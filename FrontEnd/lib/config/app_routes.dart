import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:smartpark/providers/activity_provider.dart';
import 'package:smartpark/providers/auth_provider.dart';
import 'package:smartpark/providers/parking_provider.dart';
import 'package:smartpark/providers/vehicles_provider.dart';
import 'package:smartpark/views/add_vehicles_view.dart';
import 'package:smartpark/views/activity_view.dart';
import 'package:smartpark/views/home_view.dart';
import 'package:smartpark/views/login_view.dart';
import 'package:smartpark/views/sign_up_view.dart';
import 'package:smartpark/views/space_view.dart';
import 'package:smartpark/views/vehicles_view.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRoutes {
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        name: AddVehiclesView.routerName,
        path: AddVehiclesView.routerPath,
        builder: (context, state) => const AddVehiclesView(),
      ),
      GoRoute(
        name: HomeView.routerName,
        path: HomeView.routerPath,
        builder: (context, state) => HomeView(),
      ),
      GoRoute(
        name: LoginView.routerName,
        path: LoginView.routerPath,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        name: SignUpView.routerName,
        path: SignUpView.routerPath,
        builder: (context, state) => SignUpView(),
      ),
      GoRoute(
        name: SpaceView.routerName,
        path: SpaceView.routerPath,
        builder: (context, state) {
          Map arguments = state.extra as Map; 
          return SpaceView(argument: arguments);
        }
      ),
      GoRoute(
        name: VehiclesView.routerName,
        path: VehiclesView.routerPath,
        builder: (context, state) => VehiclesView(),
      ),
      GoRoute(
        name: ActivityView.routerName,
        path: ActivityView.routerPath,
        builder: (context, state) => ActivityView(),
      ),
    ]
  );

  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ParkingProvider()),
    ChangeNotifierProvider(create: (_) => VehiclesProvider()),
    ChangeNotifierProvider(create: (_) => ActivityProvider()),
  ];
}
