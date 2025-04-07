import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../Controller/UserController.dart';
import 'FirmDetailsScreen.dart';

class MyFirm extends StatefulWidget {
  const MyFirm({super.key});

  @override
  State<MyFirm> createState() => _MyFirmState();
}

class _MyFirmState extends State<MyFirm> {

  final controller = Get.put(UserController());

  @override
  void initState() {
    controller.masterFirmsByMasterLoginId();
    super.initState();
  }







  // void _deleteFirm(int index) {
  //   setState(() {
  //     firms.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Firm List', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          ()=> ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.masterFirmsByMasterLoginIdData.length,
            itemBuilder: (context, index) {
              final data = controller.masterFirmsByMasterLoginIdData[index];
              return Card(
                color: const Color(0xfff5f5f5),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image(
                      image: data["firm_image"] != null && data["firm_image"].toString().isNotEmpty
                          ?NetworkImage("http://192.168.0.56/Varia/${data["firm_image"]}") : AssetImage("assets/images/varia_logo.png"),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    data["shop_name"],
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data["address"], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                      Text("City: ${data["city"]}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                      Text("District: ${data["district_name"]}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                    ],
                  ),
                  onTap: () => Get.to(FirmDetailsScreen(
                    connectButton: false, // ✅ Check subscription_status
                    data: controller.masterFirmsByMasterLoginIdData[index], // ✅ Pass filtered data
                  )),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        editFirm(index);
                      } else if (value == 'delete') {
                        controller.deleteFirm(data["masterFirmId"]);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit, color: Colors.blue),
                          title: Text('Edit'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void editFirm(int index) {
    final data = controller.masterFirmsByMasterLoginIdData[index];
    controller.setFirmData(data);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildImagePicker("Firm Image", controller.firmImagePath),
                        const SizedBox(height: 15),
                        buildImagePicker("Owner Image", controller.ownerImagePath),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(height: 0.7, color: Colors.black,),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "Edit Firm Details",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),
                  buildTextField(controller.ownerNameController, "Owner Name", Icons.person),
                  buildTextField(controller.firmNameUpdateController, "Firm Name", Icons.business),
                  buildTextField(controller.addressUpdateController, "Address", Icons.location_on),
                  buildTextField(controller.emailController, "Email", Icons.email),
                  buildTextField(controller.gstController, "GST Number", Icons.confirmation_number),
                  buildTextField(controller.mfmsController, "MFMS ID", Icons.badge),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        ),
                        onPressed: () {
                          controller.updateFirmDetails(data["masterFirmId"]);
                          Navigator.pop(context);
                        },
                        child: const Text("Save", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildImagePicker(String title, RxString imagePath) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Obx(
              () => Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: imagePath.value.startsWith("http")
                    ? NetworkImage(imagePath.value)
                    : FileImage(File(imagePath.value)) as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: GestureDetector(
                    onTap: () async {
                      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        imagePath.value = pickedFile.path;
                      }
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

}
