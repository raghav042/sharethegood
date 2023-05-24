import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/color_constant.dart';

class DashboardTile extends StatelessWidget {
  const DashboardTile({
    Key? key,
    this.gradient = ColorConstants.blueGradient,
    required this.label,
    required this.quantity,
    required this.progress,
    required this.available,
    required this.width,
    this.height,
  }) : super(key: key);
  final Gradient? gradient;
  final String label;
  final String quantity;
  final double progress;
  final bool available;
  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isBig = width > MediaQuery.of(context).size.width/2;
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height ?? 180,
      width: width,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:isDarkMode ? colorScheme.surfaceVariant : Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                quantity,
                style: TextStyle(
                  fontSize: 60,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                isBig ? label.toUpperCase() : "",
                style: const TextStyle(
                  fontSize: 20,
                  //color: Colors.white,
                ),
              ),
              const Expanded(child: SizedBox()),
              SizedBox(
                height: isBig ? 100 : 50,
                width: isBig ? 100 : 50,
                child: Stack(
                  children: [
                    SizedBox(
                      height: isBig ? 100 : 50,
                      width: isBig ? 100 : 50,
                      child: CircularProgressIndicator(
                        value: progress,
                       // color: Colors.white,
                      ),
                    ),
                    Center(
                      child: Text(
                        "${(progress * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          //color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            (available
                    ? "people donate "
                    : "people want ") +
                (isBig ? "" : label),
            style: const TextStyle(
              fontSize: 16,
              //color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
