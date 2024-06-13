import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:smartpark/models/auth_model.dart';
import 'package:smartpark/models/register_user_model.dart';
import 'package:smartpark/services/auth_services.dart';
import 'package:smartpark/services/services.dart';
import 'package:smartpark/style/colors.dart';
import 'package:smartpark/utils/constants.dart';
import 'package:smartpark/views/home_view.dart';
import 'package:smartpark/views/login_view.dart';
import 'package:smartpark/views/sign_up_view.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController carBranchController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController carColorController = TextEditingController();
  TextEditingController carManufacturingDateController = TextEditingController();

  int _currentStep = 0;
  RegisterUserModel _registerUser = RegisterUserModel();

  int get currentStep => _currentStep;
  RegisterUserModel get registerUser => _registerUser;

  void goToStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void goHome(BuildContext context) async {
    AuthModel authModel = await login(emailController.text, passwordController.text);
    if (authModel.jwt != null) {
      final dataName = await Services().parseJwtPayLoad(authModel.jwt.toString());
      await _storage.write(key: Constants.ssName, value: dataName['name']);
      await _storage.write(key: Constants.ssUserId, value: dataName['userId'].toString());
      await _storage.write(key: Constants.ssToken, value: authModel.jwt.toString());
      await _storage.write(key: Constants.ssUsername, value: authModel.username.toString());

      // Almacenar el rol del usuario
      await _storage.write(key: Constants.ssRole, value: dataName['role'].toString());

      // Decodificar el token JWT
      Map<String, dynamic> decodedToken = JwtDecoder.decode(authModel.jwt.toString());
      String userId = decodedToken['userId'].toString();

      await _storage.write(key: Constants.ssUserId, value: userId);
      print('User ID saved: $userId');
      print('User Role saved: ${dataName['role']}');
      context.goNamed(HomeView.routerName);
    }
  }

  Future<String?> getUserRole() async {
    String? userRole = await _storage.read(key: Constants.ssRole);
    print('User Role retrieved: $userRole');
    return userRole;
  }


  Future<void> verifyAuth(BuildContext context) async {
    String? token = await _storage.read(key: Constants.ssToken);
    if (token != null) {
      context.goNamed(HomeView.routerName);
    }
  }

  void goToSignUp(BuildContext context) {
    context.pushNamed(SignUpView.routerName);
  }

  Future<AuthModel> login(String email, String password) async {
    return AuthService().login(email, password);
  }

  void signup(BuildContext context) async {
    if (_currentStep == 0) {
      goToStep(1);
    } else {
      RegisterUserModel registerUser = RegisterUserModel(
        name: nameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        password: passwordController.text,
        pinCode: pinController.text,
        licensePlate: licensePlateController.text,
        carBranch: carBranchController.text,
        carModel: carModelController.text,
        carColor: carColorController.text,
        carManufacturingDate: carManufacturingDateController.text,
      );
      bool isRegistered = await AuthService().registerUser(registerUser);
      if (isRegistered) {
        final snackBar = SnackBar(
          backgroundColor: AppColors.green,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Usuario registrado correctamente',
            style: const TextStyle(color: Colors.white),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        context.goNamed(LoginView.routerName);
      } else {
        final snackBar = SnackBar(
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Error al registrar usuario',
            style: const TextStyle(color: Colors.white),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<String?> getUserId() async {
    String? userId = await _storage.read(key: Constants.ssUserId);
    print('User ID retrieved: $userId');
    return userId;
  }
}
