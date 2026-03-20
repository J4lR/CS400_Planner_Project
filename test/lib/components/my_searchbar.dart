import 'package:flutter/material.dart';

Widget searchbox() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
    child: TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(Icons.search, color: Colors.black, size: 20),
        prefixIconConstraints: BoxConstraints(maxHeight: 20, maxWidth: 25),
        border: InputBorder.none,
        hintText: 'Search',
        hintStyle: TextStyle(color: Colors.grey),
      ),
    ),
  );
}
