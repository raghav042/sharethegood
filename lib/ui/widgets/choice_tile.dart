import 'package:flutter/material.dart';
import '../screens/donation_dashboard.dart';

class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    Key? key,
    required this.icon,
    required this.label,
    this.color,
    this.width,
  }) : super(key: key);
  final IconData icon;
  final String label;
  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 5;
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: size,
      width: width ?? size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(4),
          backgroundColor: color ?? colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DonationDashboard()));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, color: Colors.black,),
            Text(label, style: const TextStyle(color: Colors.black),),
          ],
        ),
      ),
    );
  }
}
