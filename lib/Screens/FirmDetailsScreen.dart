import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomWidgets/SendMessageDialog.dart';

class FirmDetailsScreen extends StatelessWidget {
  final bool connectButton;
  final dynamic data;
  const FirmDetailsScreen({super.key, required this.connectButton, this.data});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Firm Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 📌 Firm Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: data["firm_image"] != null && data["firm_image"].toString().isNotEmpty
                  ? Image.network(
                "http://192.168.0.56/Varia/${data["firm_image"]}",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/images/varia_logo.png",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
                  : Image.asset(
                "assets/images/varia_logo.png",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 12),

            /// 📌 Firm Name
            Text(
              data["shop_name"],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 8),

            /// 📌 Firm Owner Name
            ///
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(400),
                    border: Border.all(
                      width: 0.7,
                      color: Colors.grey
                    )
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:  data["firmOwnerImage"] != null && data["firmOwnerImage"].toString().isNotEmpty
                          ?Image.network("http://192.168.0.56/Varia/${data["firmOwnerImage"]}", height: 50, width: 50,fit: BoxFit.cover,) : Icon(Icons.person,size: 50))
                ),
                SizedBox(width: 10),
                Text(data["proprieter_name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)

              ],
            ),
            SizedBox(height: 10),
            _buildInfoRow(Icons.phone, "+91-${data["mobile"]}", isBold: true),
            _buildInfoRow(Icons.location_on, "Location: ${data["address"]}", isBold: true),
            _buildInfoRow(Icons.location_on, "City: ${data["city"]}", isBold: true),

            _buildInfoRow(Icons.email, data["email"], isBold: true),
            Divider(thickness: 1, height: 24),

            /// 📌 Other Details
            Text("Other Details :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            _buildInfoRow(null, "GST : ${data["gst"]}", isBold: true),
            _buildInfoRow(null, "MFMS ID : ${data["mfms"]}", isBold: true),
            SizedBox(height: 20),

            /// 📌 Connect Button
            connectButton ? SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.dialog(SendMessageDialog());
                },
                icon: Icon(Icons.send, color: Colors.white),
                label: Text("Connect", style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ) : SizedBox(),
          ],
        ),
      ),
    );
  }

  /// 🔹 Custom Row for Info
  Widget _buildInfoRow(IconData? icon, String text, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.black54, size: 20),
          if (icon != null) SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.w500 : FontWeight.normal, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
