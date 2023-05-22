// componnent near to the search bar for filtering the list of products with the help of categories

import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  final ValueChanged<String> onFilter;
  Filter({required this.onFilter});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  String filter = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          suffixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
        onChanged: (value) {
          setState(() {
            filter = value;
          });
          widget.onFilter(value);
        },
      ),
    );
  }
}