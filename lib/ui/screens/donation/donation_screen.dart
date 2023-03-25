import 'package:flutter/material.dart';
import 'package:sharethegood/ui/screens/donation/donation_form.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({Key? key, required this.donate}) : super(key: key);
  final bool donate;

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  static const List<String> labels = [
    "books",
    "clothes",
    "food",
    "volunteer",
    "utilities",
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tileWidth = MediaQuery.of(context).size.width / 3 - 15;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.donate ? "Donate" : "I want"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  labels.length,
                  (index) => SizedBox(
                    height: tileWidth,
                    width: tileWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DonationForm(
                                      donate: widget.donate,
                                      product: labels[index],
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primaryContainer,
                        foregroundColor: colorScheme.onPrimaryContainer,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        labels[index].toUpperCase(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // SizedBox(
              //   height: tileWidth,
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: colorScheme.tertiaryContainer,
              //       foregroundColor: colorScheme.onTertiaryContainer,
              //       padding: const EdgeInsets.all(8),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12.0),
              //       ),
              //     ),
              //     child: Text(
              //       "Other",
              //       style: const TextStyle(fontSize: 18),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
