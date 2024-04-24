import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100.0, // Set the width of the container
        height: 100.0, // Set the height of the container
        decoration: BoxDecoration(
          color: Colors.white, // Set the color of the container
          borderRadius: BorderRadius.circular(
              10), // Optional: if you want rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: CircularProgressIndicator(
              // Your custom color
              ),
        ),
      ),
    );
  }
}
