import 'package:flutter/material.dart';
import 'package:smartpark/style/colors.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key, required this.current});
  final double current;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        return Stack(
          children: [
            Container(
              width: x,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            Positioned(
              left: 0,
              child: Container(
                width: x * .495,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),
            Positioned(
              left: x * .505,
              child: Container(
                width: x * .49,
                height: 2,
                decoration: BoxDecoration(
                  color: current == 1? AppColors.disable: AppColors.primary,
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}