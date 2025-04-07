import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Controller/UserController.dart';
import '../CustomWidgets/CustomBigButton.dart';
import '../CustomWidgets/showSuccessDialog.dart';
import 'Home.dart';
import 'SubscriptionPlanScreen.dart';

class WhatsAppAccountScreen extends StatefulWidget {
  const WhatsAppAccountScreen({super.key});

  @override
  State<WhatsAppAccountScreen> createState() => _WhatsAppAccountScreenState();
}

class _WhatsAppAccountScreenState extends State<WhatsAppAccountScreen> {

  final controller = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    controller.getPreviousDistrictRequest();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add What's App Account",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16, top: 10),
        child: SingleChildScrollView(
          child: Obx(
            ()=> Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Request Form", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),

                SizedBox(height: 10),
                CustomTextField(label: "Firm Name", hint: "${controller.firmName.value}", icon: Icons.business),
                CustomTextField(label: "User Name", hint: "${controller.fullName.value}", icon: Icons.person),
                CustomTextField(label: "Address", hint: "${controller.yourAddress.value}", icon: Icons.location_on),
                SizedBox(height: 10),
               // Text("${controller.selectedDistrict.value}"),
               // Text("${controller.selectedDistrictIdWhatsApp.value}"),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select District do you want to add",
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                  SizedBox(height: 4),
                  Obx(
                        () => DropdownButtonFormField2<String>(
                      value: controller.selectedDistrict.value,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_city, color: Colors.green),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Color(0xffffffff),
                      ),
                      items: controller.getListDistrictByLoginIdWhatsAppDropdown
                          .map((district) => DropdownMenuItem<String>(
                        value: district["district_name"] as String, // Explicitly cast
                        child: Text(district["district_name"] as String),
                      ))
                          .toList(),
                      onChanged: (value) {
                        controller.selectedDistrict.value = value;

                        // Find and update selected district_id
                        final selectedDistrict = controller.getListDistrictByLoginIdWhatsAppDropdown.firstWhere(
                              (district) => district["district_name"] == value,
                          orElse: () => {},
                        );

                        controller.selectedDistrictIdWhatsApp.value = selectedDistrict["district_id"]?.toString() ?? "";
                      },
                      hint: Text("Select a district"), // Placeholder when no selection
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),



              SizedBox(height: 10),
                CustomTextField(label: "Mobile Number", hint: "+91 ${"${controller.mobileNumber.value}"}", icon: Icons.phone, keyboardType: TextInputType.phone),

                SizedBox(height: 20),
                CustomBigButton(
                  text: "Submit",
                  onPressed: () {
                    if (controller.selectedDistrict.value == null || controller.selectedDistrict.value!.isEmpty) {
                      // Show Snackbar if no district is selected
                      Get.snackbar(
                        "Selection Required",
                        "Please select a district before proceeding",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );

                    } else {
                      // Navigate to the SubscriptionPlanScreen if a district is selected
                      Get.to(SubscriptionPlanScreen(type: "request"));
                    }
                  },
                ),


                SizedBox(height: 20),
                Text("Previous Request", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),

                SizedBox(height: 10),
                Column(
                  children: controller.getPreviousDistrictRequestData.map((request) {
                    return PreviousRequestCard(
                      district: request["district_name"]!,
                      status: "Approved",
                      applyDate: request["SubscriptionStart"]!,
                      endDate: request["SubscriptionEnd"],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// **Custom Text Field Widget**
class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  const CustomTextField({
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
        SizedBox(height: 4),

        Container(
          padding: EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.7, color: Color(0xff808080)
            ),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.green),
              SizedBox(width: 10),
              Text(hint, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

/// **Custom Dropdown Widget**
// class CustomDropdown extends StatelessWidget {
//   final String label;
//   final String selectedValue;
//   final IconData icon;
//
//   const CustomDropdown({
//     required this.label,
//     required this.selectedValue,
//     required this.icon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
//         SizedBox(height: 4),
//         DropdownButtonFormField2<String>(
//           value: selectedValue,
//           decoration: InputDecoration(
//             prefixIcon: Icon(icon, color: Colors.green),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//             filled: true,
//             fillColor: Color(0xffffffff),
//           ),
//           items: ["Pune", "Nagpur", "Mumbai", "Nashik", "Aurangabad", "Bhandara"]
//               .map((district) => DropdownMenuItem(
//             value: district,
//             child: Text(district),
//           ))
//               .toList(),
//           onChanged: (value) {},
//         ),
//         SizedBox(height: 10),
//       ],
//     );
//   }
// }

/// **Previous Request Card**
class PreviousRequestCard extends StatelessWidget {
  final String district;
  final String status;
  final String applyDate;
  final String? endDate;

  const PreviousRequestCard({
    required this.district,
    required this.status,
    required this.applyDate,
    this.endDate,
  });

  Color _getStatusColor() {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Approved":
        return Colors.green;
      case "Reject":
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "District: ",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                      children: [
                        TextSpan(text: district, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "Status: ",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                      children: [
                        TextSpan(text: status, style: TextStyle(color: _getStatusColor(), fontWeight: FontWeight.w500, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(

              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "Apply Date: ",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
                      children: [
                        TextSpan(text: formatDate(applyDate), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                if (endDate != null)
                  Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "End Date: ",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
                      children: [
                        TextSpan(text: formatDate(endDate!), style: TextStyle(color: _getStatusColor(), fontWeight: FontWeight.w500, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  String formatDate(String date) {
    if (date.isEmpty) return "";
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat("dd-MM-yyyy").format(parsedDate);
    } catch (e) {
      return date; // Return original if parsing fails
    }
  }


}
