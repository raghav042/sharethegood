import 'package:flutter/material.dart';

class DonationTile extends StatelessWidget {
  const DonationTile({
    Key? key,
    required this.label,
    required this.imagePath,
    this.onTap,
  }) : super(key: key);

  final String label;
  final String imagePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25.0),
          child: Stack(
            children: [
              SizedBox.expand(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.none,
                  ),
                ),
              ),
              SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
