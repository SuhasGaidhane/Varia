import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testingproject/CustomWidgets/SearchTextField.dart';

import '../Controller/UserController.dart';
import '../CustomWidgets/SendMessageDialog.dart';
import 'FirmDetailsScreen.dart';

class DistrictFirmList extends StatefulWidget {
  final String district_name;
  final int district_id, subscription_status;

  const DistrictFirmList({
    super.key,
    required this.district_id,
    required this.subscription_status,
    required this.district_name,
  });

  @override
  State<DistrictFirmList> createState() => _DistrictFirmListState();
}

class _DistrictFirmListState extends State<DistrictFirmList> {
  final controller = Get.put(UserController());

  @override
  void initState() {
    controller.getMasterFirm(widget.district_id);
    super.initState();
  }

  @override
  void dispose() {
    controller.masterFirms.clear();
    controller.filteredFirms.clear();
    controller.isSelecting = false.obs;
    controller.searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.district_name,
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchTextField(
              controller: controller.searchController,
              hintText: "Search Firm...",
              onChanged: (value) => controller.filterFirms(value), // ✅ Search Functionality
            ),
            SizedBox(height: 10),
            Obx(
                  () => ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  controller.isSelecting.value = !controller.isSelecting.value;
                  for (var firm in controller.filteredFirms) {
                    firm['isSelected'] = controller.isSelecting.value;
                  }
                  controller.filteredFirms.refresh();
                },
                child: Text(
                  controller.isSelecting.value ? 'Deselect All' : 'Select All',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Obx(
                    () {
                  if (controller.filteredFirms.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            "No Firms Available",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.filteredFirms.length,
                    itemBuilder: (context, index) {
                      var firm = controller.filteredFirms[index];
                      return Card(
                        color: Color(0xfff5f5f5),
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/store.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            firm['shop_name'] ?? "Unknown",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          subtitle: Text(firm['address'] ?? "Address not available"),
                          trailing: controller.isSelecting.value
                              ? Checkbox(
                            value: firm['isSelected'] ?? false,
                            onChanged: (value) => controller.toggleSelection(index),
                          )
                              : null,
                          onTap: () => controller.onTap(index, widget.subscription_status),
                          onLongPress: () => controller.onLongPress(index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
            () => controller.isSelecting.value &&
            controller.filteredFirms.any((firm) => firm['isSelected'] == true)
            ? Padding(
          padding: EdgeInsets.all(16.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.green,
            elevation: 10,
            onPressed: () {
              Get.dialog(SendMessageDialog());
            },
            label: Text(
              'Connect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            icon: Icon(Icons.send, color: Colors.white),
          ),
        )
            : SizedBox.shrink(), // ✅ Fix: Instead of returning null, return an empty widget
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.white,
    );
  }
}
