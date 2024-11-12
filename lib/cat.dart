// ignore_for_file: prefer_const_constructors, unused_label

import 'package:flutter/material.dart';
import 'package:myntra/main.dart';

void main() {
  runApp(MyApp());
}

class CatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removed the debug banner
      home: Scaffold(
        backgroundColor: Colors.white, // Set the background color to white
        appBar: AppBar(
          backgroundColor:
              Colors.transparent, // Set to transparent to remove color
          elevation: 0, // Remove shadow and elevation of the AppBar
        ),
        body: Center(
          child: _buildButtonRow(), // Call your button row widget here
        ),
      ),
    );
  }
}

// Define the function to create the button row
Widget _buildButtonRow() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _buildSquareButton('Men', 'assets/men.webp'),
        SizedBox(width: 10.0),
        _buildSquareButton('Women', 'assets/women.jpg'),
        SizedBox(width: 10.0),
        _buildSquareButton('Kids', 'assets/both.webp'),
        SizedBox(width: 10.0),
        _buildSquareButton('Footwear', 'assets/heels.jpg'),
        SizedBox(width: 10.0),
        _buildSquareButton('Accessories', 'assets/purse.webp'),
        SizedBox(width: 10.0),
        _buildSquareButton('Watches', 'assets/watch.jpg'),
        SizedBox(width: 10.0),
        _buildSquareButton('Luggage', 'assets/trolly.jpg'),
        SizedBox(width: 10.0),
        _buildSquareButton('Gadgets', 'assets/headphone.webp'),
        SizedBox(width: 10.0),
        _buildSquareButton('Jewellery', 'assets/jewel.webp'),
      ],
    ),
  );
}

// Define the _buildSquareButton function
Widget _buildSquareButton(String label, String imagePath) {
  return Column(
    children: [
      // Button with image
      Container(
        width: 80, // Adjust the size of the button
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: Colors.black, width: 2.0), // Add border styling
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(height: 5),
      // Text label under the button
      Text(
        label,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
