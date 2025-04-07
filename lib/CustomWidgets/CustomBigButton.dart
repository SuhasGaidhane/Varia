import 'package:flutter/material.dart';

class CustomBigButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomBigButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20 ),
        width: double.infinity, // Full width button
        padding: EdgeInsets.symmetric(vertical: 12), // Bigger padding
        decoration: BoxDecoration(
          color: Color(0xFF007342), // Background color
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        alignment: Alignment.center, // Center the text
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
