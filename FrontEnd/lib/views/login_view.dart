import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/providers/auth_provider.dart';
import 'package:smartpark/style/colors.dart';
import 'package:smartpark/widgets/RotatingLoginCircle.dart';
import 'package:smartpark/widgets/custom_button.dart';
import 'package:smartpark/style/custom_field.dart';

class LoginView extends StatefulWidget {
  static const String routerName = 'login';
  static const String routerPath = '/';
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
    // verfivar  que exista la autenticaciopn en el securioty storage;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.verifyAuth(context);
  
  
  }
  Future<void> _showLoginAnimation(BuildContext context) async {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return Center(
          child: RotatingLoginCircle(),
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

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
                const SizedBox(height: 120),
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  color: AppColors.primary,
                  height: 150,
                ),
                const SizedBox(height: 70),
                CustomField(
                  controller: authProvider.emailController,
                  hintText: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  label: 'Correo electrónico',
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: _obscurePassword,
                  builder: (context, value, child) {
                    return CustomField(
                      controller: authProvider.passwordController,
                      hintText: 'Contraseña',
                      keyboardType: TextInputType.text,
                      label: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      obscureText: value,
                      suffixIcon: IconButton(
                        icon: Icon(value ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          _obscurePassword.value = !_obscurePassword.value;
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                CustomButton(
                  label: 'Iniciar sesión', 
                  onPressed: () async {
                    // Mostrar animación de login
                    await _showLoginAnimation(context);
                    // Redirigir a la pantalla de inicio
                    authProvider.goHome(context);
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => authProvider.goToSignUp(context),
                  child: RichText(
                    text: TextSpan(
                      text: '¿Aun no tienes cuenta? ',
                      style: const TextStyle(color: AppColors.primary),
                      children: [
                        TextSpan(
                          text: 'Regístrate',
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)
                        )
                      ]
                    )
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
