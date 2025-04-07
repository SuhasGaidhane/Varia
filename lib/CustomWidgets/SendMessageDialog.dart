import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class SendMessageDialog extends StatefulWidget {
  @override
  _SendMessageDialogState createState() => _SendMessageDialogState();
}

class _SendMessageDialogState extends State<SendMessageDialog> {
  final TextEditingController messageController = TextEditingController();
  File? selectedImage;

  /// 📌 Function to Pick Image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  /// 📌 Function to Remove Image
  void _removeImage() {
    setState(() {
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // Increased Size
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 📌 Title Row with WhatsApp Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Send Message",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SvgPicture.asset("assets/svg/whatsAppIcon.svg", height: 30,),
                ],
              ),
              SizedBox(height: 10),

              /// 📌 Pricing Information
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 5),
                  Text(
                    "₹0.05 per message | ₹0.05 per firm",
                    style: TextStyle(fontSize: 14, color: Colors.orange),
                  ),
                ],
              ),
              SizedBox(height: 15),

              /// 📌 New Message Input UI (Card Style)
              Text("Message", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  controller: messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type your message...",
                    prefixIcon: Icon(Icons.edit, color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 16),

              /// 📌 Image Upload Section
              Text("Photo Upload", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: DottedBorderContainer(selectedImage, _removeImage),
              ),
              SizedBox(height: 20),

              /// 📌 Send Message Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (messageController.text.isNotEmpty || selectedImage != null) {
                      Get.snackbar("Message Sent", "Your message has been successfully sent!",
                          backgroundColor: Colors.green, colorText: Colors.white);
                      Get.back(); // Close Dialog
                    } else {
                      Get.snackbar("Error", "Please enter a message or upload an image!",
                          backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: Icon(Icons.send, color: Colors.white),
                  label: Text("Send via WhatsApp", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 📌 Custom Image Upload UI with Dotted Border
class DottedBorderContainer extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onRemove;

  DottedBorderContainer(this.selectedImage, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130, // Slightly bigger for better usability
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: selectedImage == null
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload, size: 45, color: Colors.green),
          Text("Tap to Upload Image", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      )
          : Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(selectedImage!, width: double.infinity, height: 130, fit: BoxFit.cover),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Icon(Icons.close, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
