// import 'package:flutter/material.dart';
// import 'package:smartpark/widgets/custom_field.dart';

// class StepOne extends StatelessWidget {
//   const StepOne({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CustomField(
//           hintText: 'Nombre',
//           keyboardType: TextInputType.text,
//           label: 'Nombre',
//           prefixIcon: const Icon(Icons.account_circle_sharp),
//           onChanged: (value) => registerUser.name = value,
//         ),
//         const SizedBox(height: 16),
//         CustomField(
//           hintText: 'Apellido',
//           keyboardType: TextInputType.text,
//           label: 'Apellido',
//           prefixIcon: const Icon(Icons.account_circle_rounded),
//           onChanged: (value) => registerUser.lastName = value,
//         ),
//         const SizedBox(height: 16),
//         CustomField(
//           hintText: 'Correo electrónico',
//           keyboardType: TextInputType.emailAddress,
//           label: 'Correo electrónico',
//           prefixIcon: const Icon(Icons.email),
//           onChanged: (value) => registerUser.email = value,
//         ),
//         const SizedBox(height: 16),
//         CustomField(
//           hintText: 'Contraseña',
//           keyboardType: TextInputType.text,
//           label: 'Contraseña',
//           prefixIcon: const Icon(Icons.lock),
//           onChanged: (value) => registerUser.password = value,
//         ),
//         const SizedBox(height: 16),
//         CustomField(
//           hintText: 'Código de seguridad',
//           keyboardType: TextInputType.number,
//           label: 'Código de seguridad',
//           prefixIcon: const Icon(Icons.security),
//           onChanged: (value) => registerUser.pinCode = value,
//         ),
//       ],
//     );
//   }
// }