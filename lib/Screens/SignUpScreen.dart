import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testingproject/Screens/ValidateOTP.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../Controller/UserController.dart';
import '../CustomWidgets/CustomBigButton.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final controller = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    controller.getListDistrict();
  }

  final Color primaryColor = Colors.blueAccent;
  final Color backgroundColor = Colors.white;
  final Color buttonColor = Color(0xff007342);

  final TextStyle headingStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  final TextStyle labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Registration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Obx(
          ()=> Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.center,
                  child: Image.asset("assets/images/varia_logo.png", height: 100,)),
              SizedBox(height: 35),
              _buildTextField(controller.firmNameController, 'Firm Name', 'Enter your firm name', icon: Icons.business),
              SizedBox(height: 15),
              _buildTextField(controller.fullNameController, 'Full Name', 'Enter your full name', icon: Icons.person),
              SizedBox(height: 15),
              _buildTextField(controller.mobileNumberController, 'Mobile Number', 'Enter your mobile number', keyboardType: TextInputType.phone, icon: Icons.phone),
              SizedBox(height: 15),
              _buildTextField(controller.addressController, 'Your Address', 'Enter your address', icon: Icons.location_on),
              SizedBox(height: 25),
              const Text('Select Option:', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Radio<String>(
                    value: 'Firm Owner',
                    groupValue: controller.selectedOption.value.isEmpty
                        ? null
                        : controller.selectedOption.value,
                    onChanged: (value) {
                      controller.selectedOption.value = value!;
                    },
                  ),
                  const Text('Firm Owner'),
                  Radio<String>(
                    value: 'WhatsApp Service',
                    groupValue: controller.selectedOption.value.isEmpty
                        ? null
                        : controller.selectedOption.value,
                    onChanged: (value) {
                      controller.selectedOption.value = value!;
                    },
                  ),
                  const Text('WhatsApp Service'),
                ],
              ),

              // ✅ District Dropdown (Only visible when WhatsApp Service is selected)
              if (controller.selectedOption.value == 'WhatsApp Service') ...[
                const SizedBox(height: 10),
                const Text('Select District you want to connect:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                DropdownButtonFormField<Map<String, String>>(
                  hint: const Text('Select District'),
                  items: controller.dropdown.map((district) {
                    return DropdownMenuItem(
                      value: district,
                      child: Text(district['district_name']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedDistrictId.value =
                          int.parse(value['district_id']!);
                      controller.selectedDistrictName.value =
                      value['district_name']!;
                    }
                  },
                  value: controller.selectedDistrictId.value == 0
                      ? null
                      : controller.dropdown.firstWhere(
                        (item) =>
                    int.parse(item['district_id']!) ==
                        controller.selectedDistrictId.value,
                    orElse: () => {},
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              const SizedBox(height: 20),
            Text("${controller.selectedDistrictId.value}"),

            SizedBox(height: 20),
              CustomBigButton(
                text: "Register",
                onPressed: () {
                  controller.registerUser();
                },
              ),

              SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Already have an account? Login',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      )),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text('Terms & Conditions', style: linkStyle),
                    ),
                    Text(' || ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        )),
                    GestureDetector(
                      onTap: () {},
                      child: Text('Privacy Policy', style: linkStyle),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {TextInputType keyboardType = TextInputType.text, int maxLines = 1, IconData? icon}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        hintText: label,
        hintStyle: TextStyle(fontSize: 14, color: Color(0xff1E1E1E)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        prefixIcon: icon != null ? Icon(icon, color: Colors.black) : null,
      ),
    );
  }
}