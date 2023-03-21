import 'package:flutter/material.dart';
import 'package:sharethegood/core/data/donation_list.dart';
import 'package:sharethegood/ui/widgets/donation_tile.dart';
import '../../core/data/app_constants.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({Key? key, required this.donate}) : super(key: key);
  final bool donate;

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.donate ? "Donate" : "I want"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            donationList.length,
            (index) {
              return DonationTile(
                label: donationList[index].label,
                imagePath: donationList[index].imagePath,
                onTap: () {
                  donate = widget.donate;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => donationList[index].form!));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
