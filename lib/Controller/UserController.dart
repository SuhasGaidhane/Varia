import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CustomWidgets/showSuccessDialog.dart';
import '../Screens/FirmDetailsScreen.dart';
import '../Screens/Home.dart';
import '../Screens/LoginScreen.dart';
import '../Screens/SubscriptionPlanScreen.dart';
import '../Screens/ValidateOTP.dart';

class UserController extends GetxController {
  // var userName = 'Suhas Gaidhane'.obs;
  // var userMobile = '7972726558'.obs;
  // var userLocation = 'Manish Nagar, Nagpur'.obs;
  //
  // void updateUserDetails(String name,mobile, location) {
  //   userName.value = name;
  //   userMobile.value = mobile;
  //   userLocation.value = location;
  // }


  TextEditingController firmNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  var dropdown = <Map<String, String>>[].obs;
  var selectedDistrictName = RxnString();
  RxInt selectedDistrictId = RxInt(0);
  Future<void> getListDistrict() async {
    String apiUrl = 'http://192.168.0.56/Varia/getListDistrict.php';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    final data = json.decode(response.body);
    if (data["code"] == 200) {
      // Convert the list properly
      List<Map<String, String>> formattedData = (data['data'] as List)
          .map((item) => {
        "district_id": item["district_id"].toString(),
        "district_name": item["district_name"].toString(),
      }).toList();
      dropdown.assignAll(formattedData);
    } else {
      throw Exception('Failed to load masterNames');
    }
  }

  var selectedOption = RxString('');

  bool validateFields() {
    if (firmNameController.text.isEmpty) {
      showWarning("Firm Name is required");
      return false;
    }
    if (fullNameController.text.isEmpty) {
      showWarning("Full Name is required");
      return false;
    }
    if (mobileNumberController.text.isEmpty) {
      showWarning("Mobile Number is required");
      return false;
    }
    if (addressController.text.isEmpty) {
      showWarning("Address is required");
      return false;
    }

    // ✅ Validate that an option is selected
    if (selectedOption.value.isEmpty) {
      showWarning("Please select an option");
      return false;
    }

    // ✅ Validate district ONLY when WhatsApp Service is selected
    if (selectedOption.value == 'WhatsApp Service' &&
        selectedDistrictId.value == 0) {
      showWarning("Please select a District");
      return false;
    }

    return true;
  }


  bool validateLoginFields() {
    if (loginMobileNumber.text.isEmpty) {
      showWarning("Firm Name is required");
      return false;
    }
    return true;
  }

  void showWarning(String message) {
    Get.snackbar(
      "Warning",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  var otp = "".obs; // Store OTP

  String formatMobileNumber(String number) {
    // Remove +91 if present
    if (number.startsWith("+91")) {
      return number.substring(3); // Remove first 3 characters
    }
    return number;
  }

  Future<void> registerUser() async {
    if (!validateFields()) return; // Validate before making API call
    String formattedNumber = formatMobileNumber(mobileNumberController.text); // Format the number
    String apiUrl = "http://192.168.0.56/Varia/validateUserNumberOnRegistration.php";
    var body = jsonEncode({"mobile_number": formattedNumber});
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      var data = jsonDecode(response.body);
      if (data["status"] == "error") {
        showWarning(data["message"]);
      } else if (data["status"] == "success") {
        otp.value = data["otp"].toString(); // Store OTP
        Get.to(ValidateOtpScreen(type: "SignUp", otp: otp.value, mobileNumber: mobileNumberController.text,)); // Navigate to OTP screen
      } else {
        showWarning("Unexpected error occurred!");
      }
    } catch (e) {
      showWarning("Failed to connect to the server!");
    }
  }



  TextEditingController otpController = TextEditingController();
  var errorText = ''.obs;

  void validateOtp(String type) async {
    if (otpController.text.isEmpty) {
      errorText.value = "Please enter OTP";
      return;
    }

    if (otpController.text == otp.value) {
      if (type == "SignUp") {
        if (selectedOption.value == 'WhatsApp Service') {
          // ✅ If WhatsApp Service is selected → Navigate to Subscription Plan
          Get.to(() => SubscriptionPlanScreen(type: "SignUp"));
        } else if (selectedOption.value == 'Firm Owner') {
          // ✅ If Firm Owner is selected → Print in console
          print("Firm Owner");
          registerFirmOwner();
        }
      } else {
        // ✅ If login, call API
        await loginUser();
      }
    } else {
      errorText.value = "Invalid OTP. Please try again.";
    }
  }

  Future<void> registerFirmOwner() async {
    String apiUrl = "http://192.168.0.56/Varia/registerFirmOwner.php";
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    var body = jsonEncode({
      "MasterProfileId": 1,
      "MobileNumber": mobileNumberController.text,
      "FullName": fullNameController.text,
      "FirmName": firmNameController.text,
      "YourAddress": addressController.text,
      "MasterDistrictId": 1,
      "MasterCityId": 1,
      "IsVerified": 1,
      "ModifiedDate": todayDate,
      "AvailableCredit": 0,
      "LastUsedDate": todayDate
    });

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        Get.to(LoginScreen());
        showStatusDialog(
            message: "Congratulations, your account has been successfully created.",
            isSuccess: true
        );
        // ✅ Clear fields after success
        mobileNumberController.clear();
        fullNameController.clear();
        firmNameController.clear();
        addressController.clear();
        selectedIndex.value = null;
        otpController.clear();
        otp = "".obs;
      } else {
        showWarning(data["message"]);
      }
    } catch (e) {
      showWarning("Failed to connect to server");
    }
  }




  /// ✅ **Function to Call API & Store User Data**
  Future<void> loginUser() async {
    const String apiUrl = "http://192.168.0.56/Varia/LoginValidate.php";
    final Map<String, dynamic> requestBody = {
      "mobile_number": loginMobileNumber.text
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          final userData = responseData['data'];

          // ✅ Store User Data in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool("isLogin", true);
          prefs.setInt("MasterLoginId", userData["MasterLoginId"]);
          prefs.setInt("MasterProfileId", userData["MasterProfileId"]);
          prefs.setString("MobileNumber", userData["MobileNumber"]);
          prefs.setString("FullName", userData["FullName"]);
          prefs.setInt("IsVerified", userData["IsVerified"]);
          prefs.setString("FirmName", userData["FirmName"]);
          prefs.setString("UserImage", "http://192.168.0.56/Varia/${userData["UserImage"]}" ?? "");
          prefs.setString("YourAddress", userData["YourAddress"]);
          // ✅ Navigate to Home Screen
          Get.offAll(() => Home(isLogin: true));
        } else {
          errorText.value = "Login failed. Please try again.";
        }
      } else {
        errorText.value = "Server error. Please try again later.";
      }
    } catch (e) {
      errorText.value = "Network error. Check your connection.";
    }
  }


  var isLoading = false.obs;
  var subscriptionPlans = <Map<String, dynamic>>[].obs;
  var selectedPlan = RxnString();
  var selectedIndex = RxnInt();
  var highestPrice  = RxnDouble();
  Future<void> fetchSubscriptionPlans() async {
    try {
      isLoading(true);
      var url = Uri.parse('http://192.168.0.56/Varia/getAllSubscriptionPlan.php');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          subscriptionPlans.value = List<Map<String, dynamic>>.from(jsonData['data']).reversed.toList();
          highestPrice.value = getHighestPrice(subscriptionPlans);
          if (subscriptionPlans.isNotEmpty) {
            highestPrice.value = getHighestPrice(subscriptionPlans);
          }
        } else {
          Get.snackbar("Error", "Failed to load subscription plans");
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  void selectPlan(String plan, int index) {
    selectedPlan.value = plan;
    selectedIndex.value = index;  // ✅ Store index
    update();
  }

  double getHighestPrice(List<dynamic> plans) {
    return plans.map<double>((plan) => double.tryParse(plan['BasePrice']) ?? 0.0).reduce((a, b) => a > b ? a : b);
  }


  String formatPrice(String price) {
    double priceValue = double.parse(price);
    return priceValue == priceValue.toInt() ? priceValue.toInt().toString() : priceValue.toString();
  }


  Future<void> registrationUser() async {
    try {
      isLoading(true);
      var url = Uri.parse('http://192.168.0.56/Varia/register.php');


      // Get today's date
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      var selectedPlanData = subscriptionPlans[selectedIndex.value!];
      int subscriptionMonths = int.tryParse(selectedPlanData['Month'].toString()) ?? 0;

      // Calculate Subscription End Date (today + selected months)
      DateTime subscriptionEndDate = DateTime.now().add(Duration(days: subscriptionMonths * 30));
      String subscriptionEnd = DateFormat('yyyy-MM-dd').format(subscriptionEndDate);

      var body = jsonEncode({
        "MasterProfileId": 1,
        "MobileNumber": mobileNumberController.text,
        "FullName": fullNameController.text,
        "FirmName": firmNameController.text,
        "YourAddress": addressController.text,
        "MasterDistrictId": 1,
        "MasterCityId": 1,
        "AvailableCredit": int.parse(formatPrice(subscriptionPlans[selectedIndex.value!]['Credit'])),
        "LastUsedDate": todayDate, //Today date
        "Subscription": {
          "MasterSubscriptionId": selectedPlanData['MasterSubscriptionId'],
          "district_id": selectedDistrictId.value,
          "IsActive": true,
          "SubscriptionStart": todayDate, // Today's date
          "SubscriptionEnd": subscriptionEnd, // Calculated based on months
          "RenewalDate": subscriptionEnd, // Same as Subscription End
        }
      });

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          Get.snackbar("Success", "Registration successful!");

          // Clear all text fields
          mobileNumberController.clear();
          fullNameController.clear();
          firmNameController.clear();
          addressController.clear();
          selectedIndex.value = null;
          otpController.clear();
          otp="".obs;

        } else {
          Get.snackbar("Error", jsonData['message'] ?? "Registration failed");
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  TextEditingController loginMobileNumber = TextEditingController();
  Future<void> sendLoginOTP() async {
    if (!validateLoginFields()) return; // Validate before making API call
    String formattedNumber = formatMobileNumber(loginMobileNumber.text);
    String apiUrl = "http://192.168.0.56/Varia/LoginSendOTP.php";
    var body = jsonEncode({"mobile_number": formattedNumber});
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      var data = jsonDecode(response.body);
      if (data["status"] == "error") {
        showWarning(data["message"]);
      } else if (data["status"] == "success") {
        otp.value = data["otp"].toString();
        Get.to(ValidateOtpScreen(type: "Login", otp: otp.value, mobileNumber: loginMobileNumber.text,));
        otpController.clear();
        errorText.value = '';
      } else {
        showWarning("Unexpected error occurred!");
      }
    } catch (e) {
      showWarning("Failed to connect to the server!");
    }
  }


  // void updateProfileImage(String path) {
  //   userImage.value = path;
  // }

  Future<void> uploadProfileImage(String path) async {
    // if (userImage.value.isEmpty) {
    //   Get.snackbar('Error', 'Please select an image first.');
    //   return;
    // }

    var uri = Uri.parse('http://192.168.0.56/Varia/uploadUserImage.php');
    var request = http.MultipartRequest('POST', uri);
    request.fields['MasterLoginId'] = masterLoginId.value.toString();

    try {
      request.files.add(await http.MultipartFile.fromPath('user_image', path));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        if (jsonResponse['status'] == 'success') {
          String newImagePath = jsonResponse['image_path']; // This should be the **relative path**

          // Construct the full URL
          String imageUrl = "http://192.168.0.56/Varia/$newImagePath";

          // Update UI with the correct URL
          // userImage.value = imageUrl;
          // userImage.refresh();

          // Save to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("UserImage", imageUrl);
          await getUserData();

          Get.snackbar('Success', jsonResponse['message']);
        } else {
          Get.snackbar('Error', jsonResponse['message']);
        }
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e');
    }
  }




  var masterLoginId = RxnInt();  // Nullable integer
  var masterProfileId = RxnInt();
  var mobileNumber = RxnString();  // Nullable string
  var fullName = RxnString();
  var isVerified = RxnInt();
  var firmName = RxnString();
  var userImage = RxnString();
  var yourAddress = RxnString();

  // Function to get stored user data
  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    masterLoginId.value = prefs.getInt("MasterLoginId");
    masterProfileId.value = prefs.getInt("MasterProfileId");
    mobileNumber.value = prefs.getString("MobileNumber") ;
    fullName.value = prefs.getString("FullName") ;
    isVerified.value = prefs.getInt("IsVerified") ;
    firmName.value = prefs.getString("FirmName");
    userImage.value = prefs.getString("UserImage");
    yourAddress.value = prefs.getString("YourAddress");
  }



  var carouselSliderData = <Map<String, dynamic>>[].obs;
  int currentSliderIndex = 0;

  Future<void> carouselSlider() async {
    String apiUrl = 'http://192.168.0.56/Varia/Offers/get-offers.php';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        // Cast the List<dynamic> to List<Map<String, String>>
        carouselSliderData.assignAll(List<Map<String, dynamic>>.from(data["data"]));
      } else {
        throw Exception('Failed to load carousel data: ${data["message"]}');
      }
    } else {
      throw Exception('Failed to load carousel data: ${response.statusCode}');
    }
  }

  var getSubscriptionPlanData = <Map<String, dynamic>>[].obs;
  var availableCredit =  ''.obs;

  Future<void> getSubscriptionPlan() async {
    String apiUrl = 'http://192.168.0.56/Varia/getSubscriptionPlan.php?MasterLoginId=${masterLoginId.value}';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        getSubscriptionPlanData.assignAll(List<Map<String, dynamic>>.from(data["data"]));
        availableCredit.value = data["AvailableCredit"];
      } else {
        throw Exception('Failed to load carousel data: ${data["message"]}');
      }
    } else {
      throw Exception('Failed to load carousel data: ${response.statusCode}');
    }
  }


  String formatDate(String dateString) {
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat("dd-MMM-yyyy").format(parsedDate);
    } catch (e) {
      print("Error parsing date: $e");
      return dateString; // Return original string if parsing fails
    }
  }



  var getListDistrictByLoginIdData = <Map<String, dynamic>>[].obs; //HomeScreen

  var getListDistrictByLoginIdWhatsAppDropdown = <Map<String, dynamic>>[].obs; //Add Whats App Request Dropdown
  var selectedDistrict = RxnString(); // Nullable string for district name
  var selectedDistrictIdWhatsApp = RxnString(); // Nullable string for district_id


  Future<void> getListDistrictByLoginId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? masterLogin = prefs.getInt("MasterLoginId");
    print("here is the master login id : ${masterLogin}");

    // Construct the API URL accordingly
    String apiUrl = masterLogin != null
        ? 'http://192.168.0.56/Varia/getListDistrict.php?MasterLoginId=$masterLogin'
        : 'http://192.168.0.56/Varia/getListDistrict.php';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        // Cast the List<dynamic> to List<Map<String, String>>
        getListDistrictByLoginIdData.assignAll(List<Map<String, dynamic>>.from(data["data"]));
        getListDistrictByLoginIdWhatsAppDropdown.assignAll(List<Map<String, dynamic>>.from(data["data"]).where((item) => item["subscription_status"] == 0).toList(),);
      } else {
        throw Exception('Failed to load carousel data: ${data["message"]}');
      }
    } else {
      throw Exception('Failed to load carousel data: ${response.statusCode}');
    }
  }

  // var getMasterFirmData = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> masterFirms = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredFirms = <Map<String, dynamic>>[].obs; // ✅ Filtered list for search
  RxBool isSelecting = false.obs;
  TextEditingController searchController = TextEditingController();

  Future<void> getMasterFirm(int district_id) async {
    String apiUrl = 'http://192.168.0.56/Varia/get_masterfirm.php?district_id=$district_id';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        masterFirms.assignAll(List<Map<String, dynamic>>.from(data["data"]));
        filteredFirms.assignAll(masterFirms); // ✅ Assign to filtered list
      } else {
        throw Exception('Failed to load firms: ${data["message"]}');
      }
    } else {
      throw Exception('Failed to load firms: ${response.statusCode}');
    }
  }


  RxList<Map<String, dynamic>> masterFirmsByMasterLoginIdData = <Map<String, dynamic>>[].obs;
  Future<void> masterFirmsByMasterLoginId() async {
    String apiUrl = 'http://192.168.0.56/Varia/get_firm_list_master_login_id.php?masterLoginId=${masterLoginId.value}';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        masterFirmsByMasterLoginIdData.assignAll(List<Map<String, dynamic>>.from(data["data"]));
      } else {
        masterFirmsByMasterLoginIdData.clear();
        throw Exception('Failed to load firms: ${data["message"]}');
      }
    } else {
      masterFirmsByMasterLoginIdData.clear();
      throw Exception('Failed to load firms: ${response.statusCode}');
    }
  }

  Future<String?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }

  final firmNameUpdateController = TextEditingController();
  final ownerNameController = TextEditingController();
  final addressUpdateController = TextEditingController();
  final emailController = TextEditingController();
  final gstController = TextEditingController();
  final mfmsController = TextEditingController();

  RxString firmImagePath = "".obs;
  RxString ownerImagePath = "".obs;

  void setFirmData(Map<String, dynamic> data) {
    firmNameUpdateController.text = data["shop_name"];
    ownerNameController.text = data["proprieter_name"];
    addressUpdateController.text = data["address"];
    emailController.text = data["email"];
    gstController.text = data["gst"];
    mfmsController.text = data["mfms"];

    firmImagePath.value = "http://192.168.0.56/Varia/${data["firm_image"]}";
    ownerImagePath.value = "http://192.168.0.56/Varia/${data["firmOwnerImage"]}";
  }

  Future<void> deleteFirm(int firmId) async {
    var uri = Uri.parse('http://192.168.0.56/Varia/delete_firm.php');
    var response = await http.post(uri, body: {
      'masterFirmId': firmId.toString(),
    });

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status'] == 'success') {
      Get.snackbar('Success', jsonResponse['message']);
      masterFirmsByMasterLoginId();
    } else {
      Get.snackbar('Error', jsonResponse['message']);
    }
  }



  Future<void> updateFirmDetails(int firmId) async {
    var uri = Uri.parse('http://192.168.0.56/Varia/update_firm.php');
    var request = http.MultipartRequest('POST', uri);

    request.fields['masterFirmId'] = firmId.toString();

    // Only send fields that have been modified
    if (firmNameUpdateController.text.isNotEmpty) {
      request.fields['shop_name'] = firmNameUpdateController.text;
    }
    if (ownerNameController.text.isNotEmpty) {
      request.fields['proprieter_name'] = ownerNameController.text;
    }
    if (addressUpdateController.text.isNotEmpty) {
      request.fields['address'] = addressUpdateController.text;
    }
    if (emailController.text.isNotEmpty) {
      request.fields['email'] = emailController.text;
    }
    if (gstController.text.isNotEmpty) {
      request.fields['gst'] = gstController.text;
    }
    if (mfmsController.text.isNotEmpty) {
      request.fields['mfms'] = mfmsController.text;
    }

    // Attach images only if selected
    if (firmImagePath.value.isNotEmpty && !firmImagePath.value.startsWith('http')) {
      request.files.add(await http.MultipartFile.fromPath('firm_image', firmImagePath.value));
    }
    if (ownerImagePath.value.isNotEmpty && !ownerImagePath.value.startsWith('http')) {
      request.files.add(await http.MultipartFile.fromPath('firm_owner_image', ownerImagePath.value));
    }


    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    var jsonResponse = jsonDecode(responseBody);
    if (jsonResponse['status'] == 'success') {
      Get.snackbar('Success', jsonResponse['message']);
      masterFirmsByMasterLoginId();
    } else {
      Get.snackbar('Error', jsonResponse['message']);
    }
  }




  void filterFirms(String query) {
    if (query.isEmpty) {
      filteredFirms.assignAll(masterFirms); // ✅ Reset if query is empty
    } else {
      filteredFirms.assignAll(
        masterFirms.where((firm) =>
        (firm['shop_name'] ?? "").toLowerCase().contains(query.toLowerCase()) ||
            (firm['address'] ?? "").toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  void toggleSelection(int index) {
    filteredFirms[index]['isSelected'] = !(filteredFirms[index]['isSelected'] ?? false);
    isSelecting.value = filteredFirms.any((firm) => firm['isSelected'] == true);
    filteredFirms.refresh(); // Notify UI to update
  }

  void onLongPress(int index) {
    if (!isSelecting.value) {
      filteredFirms[index]['isSelected'] = true;
      isSelecting.value = true;
    } else {
      toggleSelection(index);
    }
    filteredFirms.refresh(); // Notify UI to update
  }

  void onTap(int index, int subscription_status) {
    if (isSelecting.value) {
      toggleSelection(index);
    } else {
      Get.to(FirmDetailsScreen(
        connectButton: subscription_status == 1, // ✅ Check subscription_status
        data: filteredFirms[index], // ✅ Pass filtered data
      ));
    }
  }


  Future<void> uploadUserImage(int masterLoginId, String imagePath) async {
    var uri = Uri.parse('http://192.168.0.56/Varia/uploadUserImage.php');
    var request = http.MultipartRequest('POST', uri);

    request.fields['MasterLoginId'] = masterLoginId.toString();

    if (imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('user_image', imagePath));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    var jsonResponse = jsonDecode(responseBody);
    if (jsonResponse['status'] == 'success') {
      print("Image uploaded: ${jsonResponse['image_path']}");
      Get.snackbar('Success', jsonResponse['message']);
    } else {
      Get.snackbar('Error', jsonResponse['message']);
    }
  }



  var getPreviousDistrictRequestData = <Map<String, dynamic>>[].obs;

  Future<void> getPreviousDistrictRequest() async {
    String apiUrl = 'http://192.168.0.56/Varia/getPreviousDistrictRequest.php?MasterLoginId=${masterLoginId.value}';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        getPreviousDistrictRequestData.assignAll(List<Map<String, dynamic>>.from(data["data"]));
      } else {
        throw Exception('Failed to load carousel data: ${data["message"]}');
      }
    } else {
      throw Exception('Failed to load carousel data: ${response.statusCode}');
    }
  }


  Future<void> addUserSubscription() async {
    try {
      var url = Uri.parse('http://192.168.0.56/Varia/AddUserSubscription.php');

      // Get today's date
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      var selectedPlanData = subscriptionPlans[selectedIndex.value!];
      int subscriptionMonths = int.tryParse(selectedPlanData['Month'].toString()) ?? 0;

      // Calculate Subscription End Date (today + selected months)
      DateTime subscriptionEndDate = DateTime.now().add(Duration(days: subscriptionMonths * 30));
      String subscriptionEnd = DateFormat('yyyy-MM-dd').format(subscriptionEndDate);

      var body = jsonEncode({

        "MasterLoginId": 27,
        // "AvailableCredit": 500,
        // "Subscription": {
        //   "MasterSubscriptionId": 3,
        //   "district_id": 8,
        //   "IsActive": true,
        //   "SubscriptionStart": "05-03-2025",
        //   "SubscriptionEnd": "05-03-2026",
        //   "RenewalDate": "05-03-2026"
        // }
        //
        "AvailableCredit": int.parse(formatPrice(subscriptionPlans[selectedIndex.value!]['Credit'])),
        "Subscription": {
          "MasterSubscriptionId": selectedPlanData['MasterSubscriptionId'],
          "district_id": selectedDistrictIdWhatsApp.value,
          "IsActive": true,
          "SubscriptionStart": todayDate, // Today's date
          "SubscriptionEnd": subscriptionEnd, // Calculated based on months
          "RenewalDate": subscriptionEnd, // Same as Subscription End
        }
      });

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          Get.snackbar("Success", "Subscription added and credit updated!");
          // Clear the variables after successful subscription
          getListDistrictByLoginIdWhatsAppDropdown.clear();
          selectedDistrict.value = null;
          selectedDistrictIdWhatsApp.value = null;
        } else {
          Get.snackbar("Error", jsonData['message']);
          // Clear the variables after successful subscription
          getListDistrictByLoginIdWhatsAppDropdown.clear();
          selectedDistrict.value = null;
          selectedDistrictIdWhatsApp.value = null;
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }




  var fullNameContactUsController = TextEditingController();
  var mobileNumberContactUsController = TextEditingController();
  var emailAddressController = TextEditingController();
  var messageController = TextEditingController();

  var isLoadingContactUs = false.obs;

  Future<void> submitContactForm() async {
    try {
      if (fullNameContactUsController.text.isEmpty ||
          mobileNumberContactUsController.text.isEmpty ||
          emailAddressController.text.isEmpty ||
          messageController.text.isEmpty) {
        Get.snackbar("Error", "All fields are required");
        return;
      }

      isLoadingContactUs(true);

      var url = Uri.parse('http://192.168.0.56/Varia/contact_us.php');

      var body = jsonEncode({
        "full_name": fullNameContactUsController.text.trim(),
        "mobile_number": mobileNumberContactUsController.text.trim(),
        "email_address": emailAddressController.text.trim(),
        "message": messageController.text.trim()
      });

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success') {
        Get.snackbar("Success", "Your message has been sent!");
        clearForm();
      } else {
        Get.snackbar("Error", jsonData['message']);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoadingContactUs(false);
    }
  }

  void clearForm() {
    fullNameContactUsController.clear();
    mobileNumberContactUsController.clear();
    emailAddressController.clear();
    messageController.clear();
  }




}

class Firm {
  String name;
  bool isSelected;
  Firm({required this.name, this.isSelected = false});
}

