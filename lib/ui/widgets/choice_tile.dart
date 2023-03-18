import 'package:flutter/material.dart';
import '../screens/donate_screen.dart';

class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    Key? key,
    required this.icon,
    required this.label,
    this.color,
  }) : super(key: key);
  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 5;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.all(size / 8),
      child: SizedBox(
        height: size,
        width: size,
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
                    builder: (context) => DonateScreen(label: label)));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon, color: Colors.black,),
              Text(label, style: const TextStyle(color: Colors.black),),
            ],
          ),
        ),
      ),
    );
  }
}
