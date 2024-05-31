import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/providers/auth_provider.dart';
import 'package:smartpark/style/colors.dart';
import 'package:smartpark/widgets/RotatingLoginCircle.dart';
import 'package:smartpark/widgets/custom_button.dart';
import 'package:smartpark/widgets/custom_field.dart';

class LoginView extends StatelessWidget {
  static const String routerName = 'login';
  static const String routerPath = '/';
  const LoginView({super.key});

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
                CustomField(
                  controller: authProvider.passwordController,
                  hintText: 'Contraseña',
                  keyboardType: TextInputType.text,
                  label: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
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
                      text: '¿No tienes cuenta? ',
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
