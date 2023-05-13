import 'package:flutter/material.dart';
import 'package:sharethegood/core/color_constant.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'package:sharethegood/ui/dashboard/donation_dashboard.dart';
import 'package:sharethegood/ui/donation/donation_form.dart';

class DonationButton extends StatelessWidget {
  const DonationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FirebaseHelper.userData!['type'] == "Individual"
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                width: double.infinity,
                height: 155,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: ColorConstants.pinkGradient,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const DonationForm(donate: true)));
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.volunteer_activism,
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Add donation",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                height: 126,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const DonationForm(donate: false)));
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    backgroundColor: isDarkMode
                        ? colorScheme.primaryContainer
                        : Colors.pink.shade50,
                    foregroundColor: colorScheme.onPrimaryContainer,
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 40,
                      ),
                      Text(
                        "Add Requirement",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                height: 125,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DonationDashboard()));
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    backgroundColor: isDarkMode
                        ? colorScheme.primaryContainer
                        : Colors.pink.shade50,
                    foregroundColor: colorScheme.onPrimaryContainer,
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.dashboard_outlined,
                        size: 40,
                      ),
                      Text(
                        "Dashboard",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
