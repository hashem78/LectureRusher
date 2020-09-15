import 'package:flutter/material.dart';

class RusherTile extends StatelessWidget {
  final void Function() onTap;
  final void Function() onDobuleTap;
  final void Function() onLongPress;
  final Icon icon;
  final String text;
  RusherTile(
      {this.onTap, this.icon, this.text, this.onDobuleTap, this.onLongPress});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xFFFFFEFF),
          child: InkWell(
            onTap: onTap,
            onDoubleTap: onDobuleTap,
            onLongPress: onLongPress,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Icon(
                icon.icon,
                color: icon.color,
                size: 100,
              ),
              width: 150,
              height: 150,

              //iconSize: 150,
            ),
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
