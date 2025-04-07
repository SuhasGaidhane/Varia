import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:testingproject/CustomWidgets/CustomBigButton.dart';
import 'package:testingproject/Screens/Home.dart';
import 'package:testingproject/Screens/SubscriptionPlanScreen.dart';

import '../Controller/UserController.dart';
import '../CustomWidgets/Privacy_Terms_Condition.dart';


class ValidateOtpScreen extends StatefulWidget {
  final String type;
  final String otp;
  final String mobileNumber;
  const ValidateOtpScreen({super.key, required this.type, required this.otp, required this.mobileNumber});

  @override
  State<ValidateOtpScreen> createState() => _ValidateOtpScreenState();
}

class _ValidateOtpScreenState extends State<ValidateOtpScreen> {

  final controller = Get.put(UserController());

  // Define color variables
  final Color primaryColor = Colors.blueAccent;
  final Color backgroundColor = Colors.white;
  final Color buttonColor = Colors.blueAccent;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Validate'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(
        ()=> SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Varia", style: TextStyle(fontSize: 35, color: Color(0xff007342), fontWeight: FontWeight.w500),),
              SizedBox(height: 5),
              Image.asset("assets/images/varia_logo.png", height: 80,),
              SizedBox(height: 90,),

              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: "OTP successfully sent to number: ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF007342), // Green color for normal text
                    ),
                    children: [
                      TextSpan(
                        text: widget.mobileNumber, // The phone number
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Black color for number
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20,),

              Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              TextField(
                keyboardType: TextInputType.number,
                controller: controller.otpController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  hintText: "OTP",
                  border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff808080))),
                  prefixIcon: Icon(Icons.phone_android_rounded, color: Color(0xff000000),),
                ),
              ),

              // PinCodeTextField(
              //   appContext: context,
              //   length: 4,
              //   controller: controller.otpController,
              //   keyboardType: TextInputType.number,
              //   animationType: AnimationType.fade,
              //   pinTheme: PinTheme(
              //     shape: PinCodeFieldShape.box,
              //     borderRadius: BorderRadius.circular(8),
              //     fieldHeight: 60,
              //     fieldWidth: 50,
              //     activeFillColor: Colors.grey.shade200,
              //     inactiveFillColor: Color(0xffF9F9F9),
              //     selectedFillColor: Colors.white,
              //     activeColor: Color(0xFF007342),
              //     selectedColor: Color(0xFF007342),
              //     inactiveColor: Colors.grey.shade300,
              //   ),
              //   enableActiveFill: true,
              //   onChanged: (value) {
              //     setState(() {
              //       controller.errorText.value = '';
              //     });
              //   },
              // ),

              Obx(() => controller.errorText.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  controller.errorText.value,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              )
                  : SizedBox.shrink()),


              Text("otp ${controller.otp.value}"),
              Text("otp controller ${controller.otpController.text}"),
              SizedBox(height: 30),
              CustomBigButton(text: "Validate", onPressed: ()=> controller.validateOtp(widget.type),
              ),
              SizedBox(height: 90),
              PrivacyTermsCondition(),

            ],
          ),
        ),
      ),
    );
  }
}
