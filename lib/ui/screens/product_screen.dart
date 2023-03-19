import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../forms/books_form.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.label}) : super(key: key);
  final String label;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
            children: [],
          ),
        ),
      ),
    );
  }
}
