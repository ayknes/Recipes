// lib/components/custom_bottom_navigation.dart

import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatefulWidget {
  final ValueChanged<int> onTap;
  CustomBottomNavigation({required this.onTap});

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentPageIndex,
      onTap: (int index) {
        setState(() {
          currentPageIndex = index;
        });
        widget.onTap(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.bookmark),
          icon: Icon(Icons.bookmark_border),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Accounts',
        ),
      ],
    );
  }
}
