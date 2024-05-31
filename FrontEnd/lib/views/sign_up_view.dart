import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/providers/auth_provider.dart';
import 'package:smartpark/style/colors.dart';
import 'package:smartpark/widgets/custom_button.dart';
import 'package:smartpark/widgets/custom_field.dart';
import 'package:smartpark/widgets/custom_progress_indicator.dart';

class SignUpView extends StatelessWidget {
  static const String routerName = 'signUp';
  static const String routerPath = '/signUp';
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  color: AppColors.primary,
                  height: 150,
                ),
                const SizedBox(height: 20),
                CustomProgressIndicator(current: authProvider.currentStep+1),
                const SizedBox(height: 20),
                if(authProvider.currentStep == 0) Column(
                  children: [
                    CustomField(
                      controller: authProvider.nameController,
                      hintText: 'Nombre',
                      keyboardType: TextInputType.text,
                      label: 'Nombre',
                      prefixIcon: const Icon(Icons.account_circle_sharp),
                    ),
                    const SizedBox(height: 16),
                    CustomField(
                      controller: authProvider.lastNameController,
                      hintText: 'Apellido',
                      keyboardType: TextInputType.text,
                      label: 'Apellido',
                      prefixIcon: const Icon(Icons.account_circle_rounded),
                    ),
                    const SizedBox(height: 16),
                    CustomField(
                      controller: authProvider.emailController,
                      hintText: 'Correo electrónico',
                      keyboardType: TextInputType.emailAddress,
                      label: 'Correo electrónico',
                      prefixIcon: const Icon(Icons.email),
                    ),
                    const SizedBox(height: 16),
                    CustomField(
                      controller: authProvider.passwordController,
                      hintText: 'Contraseña',
                      keyboardType: TextInputType.text,
                      label: 'Contraseña',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    const SizedBox(height: 16),
                    CustomField(
                      controller: authProvider.pinController,
                      hintText: 'Código de seguridad',
                      keyboardType: TextInputType.number,
                      label: 'Código de seguridad',
                      prefixIcon: const Icon(Icons.security),
                    ),
                  ],
                ),
                if(authProvider.currentStep == 1) Column(
                  children: [
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
                  ],
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: authProvider.currentStep == 0? 'Siguiente': 'Registrarse', 
                  onPressed: () => authProvider.signup(context),
                ),
                if(authProvider.currentStep == 1)
                SizedBox(height: 16),
                if(authProvider.currentStep == 1)
                GestureDetector(
                  onTap: () => authProvider.goToStep(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Volver', style: TextStyle(color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            )
          )
        )
      ),
    );
  }
}