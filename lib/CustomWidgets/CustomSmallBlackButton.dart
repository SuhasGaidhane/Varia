import 'package:flutter/material.dart';

class CustomSmallBlackButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomSmallBlackButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30), // Bigger padding
        decoration: BoxDecoration(
          color: Color(0xFF000000), // Background color
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        // alignment: Alignment.center, // Center the text
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text color
          ),
        ),
      ),
    );
  }
}
