import 'package:flutter/material.dart';
import 'package:smartpark/style/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.backgroundColor, this.borderColor, this.borderRadius, this.height = 50, required this.label, this.labelColor, required this.onPressed, this.width = double.infinity});
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final double height;
  final String label;
  final Color? labelColor;
  final VoidCallback? onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          elevation: 0,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            side: BorderSide(
              color: borderColor ?? AppColors.primary,
              width: 1
            ),
          ),
          surfaceTintColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(label,
          style: TextStyle(
            color: labelColor ?? AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )
        ),
      ),
    );
  }
}