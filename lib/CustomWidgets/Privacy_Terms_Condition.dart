import 'package:flutter/material.dart';

class PrivacyTermsCondition extends StatelessWidget {
  const PrivacyTermsCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // Open terms and conditions
            },
            child: Text('Terms & Conditions', style: linkStyle),
          ),
          Text(' || ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
          GestureDetector(
            onTap: () {
              // Open privacy policy
            },
            child: Text('Privacy Policy', style: linkStyle),
          ),
        ],
      ),
    );
  }
}

final TextStyle linkStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: Colors.blueAccent,
  decoration: TextDecoration.underline,
);
