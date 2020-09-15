import 'package:flutter/material.dart';

class RusherTile extends StatelessWidget {
  final void Function() onTap;
  final Icon icon;
  final String text;
  RusherTile({this.onTap, this.icon, this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xFFFFFEFF),
          child: IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            icon: icon,
            iconSize: 140,
            onPressed: onTap,
            //iconSize: 150,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}
