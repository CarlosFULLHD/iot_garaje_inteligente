import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartpark/style/colors.dart';

class CustomField extends StatelessWidget {
  const CustomField({super.key, this.borderRadius = 8, this.controller, this.enabled = true, this.hintText, this.initialValue, this.inputFormatters, this.keyboardType, this.label, this.obscureText = false, this.onChanged, this.onTap, this.prefixIcon, this.validator});
  final double borderRadius;
  final TextEditingController? controller;
  final bool? enabled;
  final String? hintText;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? label;
  final bool obscureText;
  final ValueChanged? onChanged;
  final GestureTapCallback? onTap;
  final Widget? prefixIcon;
  final FormFieldValidator? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: enabled!? AppColors.primary: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))
          ),
          filled: true,
          fillColor: AppColors.ligthGrey,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle: const TextStyle(color: AppColors.primary),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))
          ),
          hintText: hintText ?? '',
          labelStyle: const TextStyle(color: AppColors.primary),
          labelText: label ?? '',
          prefixIcon: prefixIcon,
          prefixIconColor: AppColors.primary
        ),
        enabled: enabled,
        initialValue: initialValue,
        inputFormatters: inputFormatters ?? [],
        keyboardType: keyboardType,
        obscureText: obscureText,
        onTap: onTap,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}