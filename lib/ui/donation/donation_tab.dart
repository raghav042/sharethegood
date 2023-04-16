import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/donation/donation_list.dart';

class DonationTab extends StatelessWidget {
  const DonationTab({Key? key, required this.userSnapshot}) : super(key: key);
  final DocumentSnapshot userSnapshot;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: userSnapshot['type'] == "Individual" ? 2 : 1,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: false,
                expandedHeight: 320,
                forceElevated: innerBoxIsScrolled,
                title: const Text("Donation"),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  stretchModes: const [StretchMode.zoomBackground],
                  background: Image.asset(
                    "assets/donate.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: Scaffold(
          appBar: AppBar(
            toolbarHeight: 45,
            automaticallyImplyLeading: false,
            flexibleSpace: userSnapshot['type'] == "Individual"
                ? TabBar(
                    labelPadding: const EdgeInsets.fromLTRB(12, 25, 12, 12),
                    tabs: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.volunteer_activism),
                          SizedBox(width: 8),
                          Text("Available"),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.my_library_books),
                          SizedBox(width: 8),
                          Text("Required"),
                        ],
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          body: userSnapshot['type'] == "Individual"
              ? TabBarView(
                  children: [
                    DonationList(
                      userType: userSnapshot['type'],
                      available: true,
                    ),
                    DonationList(
                      userType: userSnapshot['type'],
                      available: false,
                    ),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                      child: SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DonationList(
                                  userType: userSnapshot['type'],
                                  available: true,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primaryContainer,
                            foregroundColor: colorScheme.onPrimaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            "Available ${userSnapshot['type']}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 20.0,
                    //     vertical: 12.0,
                    //   ),
                    //   child: SizedBox(
                    //     height: 80,
                    //     width: double.infinity,
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (_) => DonationList(
                    //                 userType: userSnapshot['type'],
                    //                 available: false,
                    //               ),
                    //             ));
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //           backgroundColor: colorScheme.tertiaryContainer,
                    //           foregroundColor: colorScheme.onTertiaryContainer,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(8.0),
                    //           )),
                    //       child: const Text(
                    //         "Required",
                    //         style: TextStyle(fontSize: 20),
                    //       ),
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
