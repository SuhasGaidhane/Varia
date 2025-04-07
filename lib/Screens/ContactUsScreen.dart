import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/UserController.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  final controller = Get.put(UserController());

  final Color primaryColor = Color(0xff007342);
  final Color backgroundColor = Colors.white;
  final Color buttonColor = Color(0xff007342);

  final TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  final TextStyle labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  final TextStyle linkStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.green,
    decoration: TextDecoration.underline,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Contact Us',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Get in Touch', style: headingStyle),
            SizedBox(height: 20),
            _buildTextField(
                'Your Name', 'Enter your full name', controller.fullNameContactUsController),
            SizedBox(height: 15),
            _buildTextField('Mobile Number', 'Enter your mobile number',
                controller.mobileNumberContactUsController,
                keyboardType: TextInputType.phone),
            SizedBox(height: 15),
            _buildTextField('Email Address', 'Enter your email',
                controller.emailAddressController,
                keyboardType: TextInputType.emailAddress),
            SizedBox(height: 15),
            _buildMessageField(
                'Your Message', 'Enter your message', controller.messageController),
            SizedBox(height: 20),
            Obx(
                  () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoadingContactUs.value
                      ? null
                      : () {
                    controller.submitContactForm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isLoadingContactUs.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
            SizedBox(height: 20),
            Text('Contact Information', style: headingStyle),
            SizedBox(height: 10),
            _buildInfoRow(Icons.phone, '+91 12345 67890'),
            SizedBox(height: 10),
            _buildInfoRow(Icons.email, 'support@varia.com'),
            SizedBox(height: 10),
            _buildInfoRow(
                Icons.location_on, '123 Agriculture Lane, Pune, Maharashtra, India'),
            SizedBox(height: 20),
            Center(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            hintText: hint,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            hintText: hint,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: primaryColor),
        SizedBox(width: 10),
        Expanded(child: Text(text, style: labelStyle)),
      ],
    );
  }
}
