import 'package:flutter/material.dart';

class MyBottomNavigationBar extends BottomNavigationBar {
  MyBottomNavigationBar(
      {Key? key, required int currentIndex, required Function(int) onTap})
      : super(
          key: key,
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
            BottomNavigationBarItem(label: 'Contact', icon: Icon(Icons.comment))
          ],
          onTap: onTap,
        );
}
