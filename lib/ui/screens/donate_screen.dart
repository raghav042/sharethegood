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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TabBarView(
              children: [
                donors(),
                takers(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget donors() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputTile("dummy text"),
        inputTile("author name"),
        SizedBox(height: 20),
        Center(
          child: SizedBox(
            height: 55,
            width: 300,
            child: ElevatedButton(onPressed: () {}, child: Text("send data")),
          ),
        )
      ],
    );
  }

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

  Widget inputTile(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }
}
