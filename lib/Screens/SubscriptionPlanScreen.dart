import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testingproject/Screens/Home.dart';
import 'package:testingproject/Screens/LoginScreen.dart';
import '../Controller/UserController.dart';
import '../CustomWidgets/Privacy_Terms_Condition.dart';
import '../CustomWidgets/showSuccessDialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';



class SubscriptionPlanScreen extends StatefulWidget {
  final String type;
  const SubscriptionPlanScreen({super.key, required this.type});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {

  final controller = Get.put(UserController());

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    controller.fetchSubscriptionPlans();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
    // Dispose Rx variables

  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showStatusDialog(message :"Payment Successful! Order ID: ${response.orderId}", isSuccess:  true);

    if(widget.type == "SignUp"){
      controller.registrationUser();
      // Get.off(Home());
      Get.to(LoginScreen());
      showStatusDialog(message :"Congratulations, your account has been successfully created.", isSuccess:  true);
      // showSuccessDialog("Your request has been successfully submitted!");
    } else{
      controller.addUserSubscription();
      Get.off(Home(isLogin: true,));
      showStatusDialog(message: "Your request has been successfully active!", isSuccess: true);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showStatusDialog(message: "Payment Failed: ${response.message}", isSuccess: false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showStatusDialog(message: "External Wallet Selected: ${response.walletName}", isSuccess: false);
  }




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Subscription Plan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Your Plan for Selected District - Bhandara',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Note: This subscription is valid for only one district within Bhandara. Please choose your plan accordingly',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.black54),
                ),
                Text("${controller.selectedIndex.value}"),
                SizedBox(height: 16.0),
                ...controller.subscriptionPlans.asMap().entries.map((entry) {
                  int index = entry.key;
                  var plan = entry.value;

                  String formattedPrice = controller.formatPrice(plan['BasePrice']);
                  bool isBestValue = controller.highestPrice.value != null &&
                      double.tryParse(plan['BasePrice']) == controller.highestPrice.value;

                  return Column(
                    children: [
                      SubscriptionCard(
                        title: plan['PlanName'],
                        subtitle: plan['Description'],
                        price: formattedPrice,
                        month: "${plan['Month']}",
                        tag: isBestValue ? "Best Value" : null,
                        isSelected: controller.selectedIndex.value == index,  // ✅ Compare by index
                        onTap: () => controller.selectPlan(plan['PlanName'], index),  // ✅ Pass index
                      ),
                      SizedBox(height: 16.0),
                    ],
                  );
                }).toList(),
                SizedBox(height: 32.0),
                Center(
                  child: ElevatedButton(
                    onPressed: controller.selectedPlan.value == null
                        ? null
                        : () {
                      var index = controller.selectedIndex.value;
                      var selectedPlanData = controller.subscriptionPlans[index!];

                      int amount = int.parse(controller.formatPrice(selectedPlanData['BasePrice'])) * 100;
                      var options = {
                        'key': 'rzp_test_CCByBKdahOExhW',
                        'amount': amount,
                        'name': 'Varia',
                        'description': 'Subscription Payment - ${selectedPlanData['title']} Plan',
                        'prefill': {'contact': '9876543210', 'email': 'user@example.com'},
                        'external': {
                          'wallets': ['paytm']
                        }
                      };

                      try {
                        _razorpay.open(options);
                      } catch (e) {
                        showStatusDialog(message: "Error: ${e.toString()}", isSuccess: false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
                    ),
                    child: Text(
                      'Continue to Purchase',
                      style: TextStyle(
                        color: controller.selectedPlan.value == null ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                PrivacyTermsCondition(),
              ],
            ),
          );
        }),
      ),
    );
  }
}


class SubscriptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String month;
  final String? tag;
  final bool isSelected;
  final VoidCallback onTap;

  const SubscriptionCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.month,
    this.tag,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: isSelected ? 7.0 : 1, // More shadow when selected
              spreadRadius: isSelected ? 3.0 : 0,
              offset: const Offset(0, 0),
            ),
          ],
          gradient: isSelected
              ? const LinearGradient(
            colors: [Color(0xFF45A476), Color(0xFF036A3F)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
              : const LinearGradient(
            colors: [Colors.white, Colors.white], // Default white background
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black, // Text color changes
                      ),
                    ),
                    SizedBox(width: 8),

                    if (tag != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [Color(0xFFE5BE89), Color(0xFFF99593)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        ),
                        padding: EdgeInsets.only(top: 2, bottom: 2, left: 15, right: 15),
                        child: Text(
                          tag!,
                          style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),

                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "$month Month Subscription Plan",
                  style: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                ),
                const SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black, // Price text color change
                  ),
                ),
                // Text(
                //   priceLabel,
                //   style: TextStyle(color: isSelected ? Colors.white70 : Colors.black87),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
