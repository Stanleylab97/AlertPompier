import 'package:alert/config/palette.dart';
import 'package:alert/screens/BottomNavScreen.dart';
import 'package:alert/screens/Start.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.primaryColor,
      elevation: 0.0,
      leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BottomNavScreen()));
          }),
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => Start()));
            }),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
