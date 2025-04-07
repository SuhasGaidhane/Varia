import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../Controller/UserController.dart';

class YourWallet extends StatefulWidget {
  const YourWallet({super.key});

  @override
  State<YourWallet> createState() => _YourWalletState();
}

class _YourWalletState extends State<YourWallet> {

  final controller = Get.put(UserController());

  @override
  void initState() {
    controller.getSubscriptionPlan();
    super.initState();
  }

  final List<Map<String, dynamic>> subscriptions = [
    {
      "name": "Bhandara",
      "type": "Yearly",
      "startDate": "01-Jan-2025",
      "expiryDate": "01-Jan-2026",
      "isActive": true,
    },
    {
      "name": "Nagpur",
      "type": "Monthly",
      "startDate": "01-Dec-2024",
      "expiryDate": "01-Jan-2025",
      "isActive": false,
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Your Wallet", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          ()=> Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: const Text("Available Credit", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black))),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/svg/whatsAppIcon.svg", height: 25,),
                  Text("  ${controller.availableCredit.value}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
              SizedBox(height: 20),
              // Subscription Card
              SizedBox(
                height: 150, // Adjusted height to accommodate the status label
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.getSubscriptionPlanData.length,
                  itemBuilder: (context, index) {
                    final subscription = controller.getSubscriptionPlanData[index];
                    final isActive = subscription["IsActive"] == 1;
                    return Container(
                      width: 250,
                      margin: const EdgeInsets.only(right: 16.0, bottom: 10),
                      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 5, top: 5),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green.shade500 : Colors.blueGrey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${subscription["district_name"]}   --- ${subscription["PlanName"]}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text("Start From : ${controller.formatDate(subscription["SubscriptionStart"])}",
                              style: const TextStyle(color: Colors.white)),
                          Text("Expire on : ${controller.formatDate(subscription["SubscriptionEnd"])}",
                              style: const TextStyle(color: Colors.white)),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.green.shade700 : Colors.grey.shade600,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isActive ? "Active" : "Inactive",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const Text(
                "\ud83d\udca1  0.05 change is for per Farm Message\n\ud83d\udca1  0.05 is for one Credit",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // Add Credit Section
              const Text("Add Credit", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _creditOption(100, 50),
                  _creditOption(210, 100),
                  _creditOption(320, 300),
                  _creditOption(1000, 800),
                  _creditOption(2000, 1300),
                ],
              ),
              const SizedBox(height: 16),

              // Credit Usage History
              const Text("Credit Usage History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: [
                    _usageHistoryItem("Bhandara","25-Jan-2025", 100, 2000),
                    _usageHistoryItem("Nagpur","24-Jan-2025", 100, 2000),
                    _usageHistoryItem("Bhandara","23-Jan-2025", 100, 2000),
                  ],
                ),
              ),

              // Notation

            ],
          ),
        ),
      ),
    );
  }

  Widget _creditOption(int credit, int price) {
    return Container(
      width: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text("$credit", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text("$price₹", style: const TextStyle(fontSize: 14, color: Colors.green)),
        ],
      ),
    );
  }

  Widget _usageHistoryItem(String district, date, int creditUsed, int messagesSent) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(district, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text("Date: $date", style: const TextStyle(fontSize: 14)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Rupies: $creditUsed₹", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text("Messages: $messagesSent", style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}