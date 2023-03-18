import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({Key? key, required this.label}) : super(key: key);
  final String label;

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: false,
                expandedHeight: 320,
                forceElevated: innerBoxIsScrolled,
                title: Text(widget.label),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  stretchModes: const [StretchMode.zoomBackground],
                  background: Image.asset(
                    "assets/${widget.label}.jpg",
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
            flexibleSpace: TabBar(
              labelPadding: const EdgeInsets.fromLTRB(12, 25, 12, 12),
              tabs: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.volunteer_activism),
                    SizedBox(width: 8),
                    Text("Donors"),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.family_restroom),
                    SizedBox(width: 8),
                    Text("Taker"),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              //donors(),
              myForm(),
              takers(),
            ],
          ),
        ),
      ),
    );
  }

  Widget myForm() {
    return Form(
      child: Column(
        children: [
          Text("name"),
          TextFormField(),
          Text("Quantity"),
          TextFormField()
        ],
      ),
    );
  }

  // Widget donors() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text("Name of book"),
  //       TextFormField(),
  //
  //       Text("writer name"),
  //       TextFormField(),
  //
  //
  //       ElevatedButton(onPressed: (){senddata();}, child: Text("send data"))
  //
  //
  //
  //
  //
  //
  //     ],
  //   );
  // }

  Widget takers() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 30),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "some text for donation to feel user proud not fill dummy text try to motivate user to donate ssomething and feel them happy because sharing is caring",
            style: TextStyle(fontSize: 16),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Again some reference and text text try to motivate user to donate ssomething and feel them happy because sharing is caring",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  /// create
  /// read
  /// update
  /// delete
  //create
  Future<void> senddata() async {
    await FirebaseFirestore.instance.collection("donation").doc("id3").set({
      "author name": "my name",
      "title": "title is hc verma",
      "quantity": 12,
    });
  }
}

/// you have to pick an image/video
/// upload it on direbase storage database
/// get the download url of that file
/// save this downloadUrl in firestore
///
///
/// update ui according to response
