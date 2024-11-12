// scroll.dart
import 'package:flutter/material.dart';
import 'welcome.dart'; // Import the WelcomePage widget

class ScrollPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.white, // Set app bar background color to white
        iconTheme: IconThemeData(
            color: Colors.black), // Set back button color to black
        elevation: 0, // Remove app bar shadow
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Small logo image
                Image.asset(
                  'assets/logo.webp',
                  height: 50.0, // Set height for the logo image
                ),
                SizedBox(height: 10.0), // Add space below the logo image

                // "Select Your Store" text
                Text(
                  'Select Your Store',
                  style: TextStyle(
                    fontSize: 24.0, // Set font size for the text
                    fontWeight: FontWeight.w200, // Set text to bold
                  ),
                ),
                SizedBox(height: 20.0), // Add space below the text

                // Column of images with tap functionality
                _buildImage(context, 'assets/myntra.jpg', WelcomePage()),
                SizedBox(height: 20.0), // Space between images
                _buildImage(context, 'assets/fwd.jpg'),
                SizedBox(height: 20.0), // Space between images
                _buildImage(context, 'assets/luxe.jpg'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, String imagePath,
      [Widget? targetPage]) {
    return GestureDetector(
      onTap: targetPage != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => targetPage),
              );
            }
          : null,
      child: Container(
        width: MediaQuery.of(context).size.width *
            0.8, // Set width to 80% of screen width
        height: 150.0, // Set height for the image container
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover, // Set the image to cover the container
          ),
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
      ),
    );
  }
}
