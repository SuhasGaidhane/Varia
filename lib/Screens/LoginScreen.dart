import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../Controller/UserController.dart';
import '../CustomWidgets/CustomBigButton.dart';
import '../CustomWidgets/CustomSmallBlackButton.dart';
import 'SignUpScreen.dart';
import 'ValidateOTP.dart';
import '../CustomWidgets/Privacy_Terms_Condition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final controller = Get.put(UserController());

  // Define color variables
  final Color primaryColor = Colors.blueAccent;
  final Color backgroundColor = Colors.white;
  final Color buttonColor = Color(0xff007342);

  // Define text styles
  final TextStyle headingStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w400);
  final TextStyle companyTextStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff007342));

  final TextStyle labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  final TextStyle linkStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.blueAccent,
    decoration: TextDecoration.underline,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(
      //   title: Text('Login'),
      //   backgroundColor: primaryColor,
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Text('Welcome!', style: headingStyle),
              SizedBox(height: 10),
              Image.asset("assets/images/varia_logo.png", height: 90,),
              SizedBox(height: 8),
              Text('Vidharbh Agro Retailers & \nIndustrial Association', style: companyTextStyle, textAlign: TextAlign.center,),
              SizedBox(height: 4),
              Text("By"),
              SizedBox(height: 4),
              Image.asset("assets/images/SidheshLogo.jpg", height: 50,),
              SizedBox(height: 8),
              Text('Siddhesh Advertising', style: companyTextStyle),
              SizedBox(height: 50),
              TextField(
                keyboardType: TextInputType.phone,
                controller: controller.loginMobileNumber,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  hintText: "Mobile Number",
                  border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff808080))),
                  prefixIcon: Icon(Icons.phone_android_rounded, color: Color(0xff000000),),
                ),
              ),
              SizedBox(height: 40),
              CustomBigButton(text: "Login",onPressed: (){
                controller.sendLoginOTP();
                },),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to sign-up screen
                    Get.to(RegistrationScreen());
                  },
                  child: Text('Don\'t have an account? Sign Up',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      )),
                ),
              ),
              SizedBox(height: 30),
              PrivacyTermsCondition(),

            ],
          ),
        ),

    );
  }

}
