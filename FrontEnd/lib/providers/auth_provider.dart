import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:smartpark/models/auth_model.dart';
import 'package:smartpark/models/register_user_model.dart';
import 'package:smartpark/services/auth_services.dart';
import 'package:smartpark/style/colors.dart';
import 'package:smartpark/utils/constants.dart';
import 'package:smartpark/views/home_view.dart';
import 'package:smartpark/views/login_view.dart';
import 'package:smartpark/views/sign_up_view.dart';

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

  void goHome(BuildContext context) async{
    AuthModel authModel = await login(emailController.text, passwordController.text);
    if(authModel.jwt != null){
      await _storage.write(key: Constants.ssToken, value: authModel.jwt.toString());
      await _storage.write(key: Constants.ssUsername, value: authModel.username.toString());
      context.goNamed(HomeView.routerName);
    }
  }

  void goToSignUp(BuildContext context) {
    context.pushNamed(SignUpView.routerName);
  }

  Future<AuthModel> login(String email, String password) async{
    return AuthService().login(email, password);
  }

  void signup(BuildContext context) async {
    if(_currentStep == 0) {
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
      if(isRegistered) {
        print('Usuario registrado');
        final snackBar = SnackBar(
          backgroundColor: AppColors.green,
          behavior: SnackBarBehavior.floating, 
          content: Text('Usuario registrado correctamente', 
            style: const TextStyle(color: Colors.white)
          )
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        context.goNamed(LoginView.routerName);
      } else {
        final snackBar = SnackBar(
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating, 
          content: Text('Error al registrar usuario', 
            style: const TextStyle(color: Colors.white)
          )
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
