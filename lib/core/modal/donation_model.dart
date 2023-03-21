import 'package:flutter/material.dart';

class DonationModel {
  const DonationModel({
    required this.label,
    required this.imagePath,
    this.form,
  });

  final String label;
  final String imagePath;
  final Widget? form;
}
