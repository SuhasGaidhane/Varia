import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testingproject/Screens/AddWhatsAppRequest.dart';
import 'package:testingproject/Screens/ContactUsScreen.dart';
import 'package:testingproject/Screens/Home.dart';
import '../Controller/UserController.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';
import 'MyFirm.dart';
import 'SubscriptionPlanScreen.dart';
import 'YourWallet.dart';

// Home Screen (Main Screen)
class Home extends StatefulWidget {
  final bool isLogin;
  const Home({super.key, required this.isLogin});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = Get.put(UserController());

  @override
  void initState() {
    controller.getUserData();
    controller.carouselSlider();
    controller.getListDistrictByLoginId();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset("assets/images/varia_logo.png", height: 40,),
        actions: [
          if (!widget.isLogin)
            GestureDetector(
            onTap: (){
              Get.to(LoginScreen());
            },
            child: Row(
              children: [
                SvgPicture.asset("assets/svg/whatsAppIcon.svg", height: 25,),
                SizedBox(width: 10),
                Text("Login    ", style: TextStyle(fontSize: 12),)
              ],
            ),
          )

          // IconButton(
          //   icon: const Icon(Icons.local_airport),
          //   onPressed: () {
          //     // Implement WhatsApp login functionality
          //     print('WhatsApp Login');
          //   },
          // ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff127e00),
              ),
              child: widget.isLogin
                  ? UserProfile()
                  : GestureDetector(
                onTap: () {
                  Get.to(LoginScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/svg/whatsAppIcon.svg", height: 35),
                    SizedBox(width: 10),
                    Text("Login", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            if (widget.isLogin)
            ListTile(
              title: const Text('My Firm'),
              onTap: () {
                Get.to(MyFirm());
              },
            ),
            ListTile(
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Contact Us Screen (using GetX for navigation)
                Get.to( ContactUsScreen());
              },
            ),
            if (widget.isLogin)
            ListTile(
              title: const Text('Add WhatsApp Account'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Add WhatsApp Account Screen
                Get.to(WhatsAppAccountScreen());
              },
            ),
            if (widget.isLogin)
            ListTile(
              title: const Text('Your Wallet'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Add WhatsApp Account Screen
                Get.to(YourWallet());
              },
            ),
            if (widget.isLogin)
            ListTile(
              title: const Text('Sign Out'),
              onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear(); // Clear all stored preferences
                  // Navigate to LoginScreen and remove all previous screens
                  Get.offAll(() => LoginScreen());
              },
            ),
          ],
        ),
      ),
      body: const HomeScreen(),
    );
  }
}

// Custom Slider Widget
class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: 0.5,
      onChanged: (value) {
        // Handle slider value change
      },
      min: 0.0,
      max: 1.0,
    );
  }
}





class UserProfile extends StatelessWidget {
  const UserProfile({super.key});
  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      init: UserController(),
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Text("${controller.userImage.value}"),
            SizedBox(
              height: 55,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: controller.userImage.value!.isNotEmpty
                        ? NetworkImage("${controller.userImage.value}")
                        : null,
                    child: controller.userImage.value!.isEmpty
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),

                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => _showImagePickerDialog(context, controller),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.edit, color: Colors.green, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${controller.fullName.value}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 2),
            Text(
              "${controller.mobileNumber.value}",
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 2),
            Text(
              "${controller.yourAddress.value}",
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        );
      },
    );
  }

  void _showImagePickerDialog(BuildContext context, UserController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Profile Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a Photo'),
                onTap: () async {
                  _pickImage(ImageSource.camera, controller);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  _pickImage(ImageSource.gallery, controller);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source, UserController controller) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      print("Selected image path: ${pickedFile.path}");
      // controller.updateProfileImage(pickedFile.path);
      await controller.uploadProfileImage(pickedFile.path); // Upload image after selection
    } else {
      Get.snackbar('Error', 'No image selected.');
    }
  }


}



