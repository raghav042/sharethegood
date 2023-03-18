import 'package:flutter/material.dart';

class SideBarTile extends StatelessWidget {
  const SideBarTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.screen,
  }) : super(key: key);
  final IconData icon;
  final String text;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
      },
      title: Text(text),
      leading: Icon(icon),
    );
  }
}
