import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:testingproject/CustomWidgets/SearchTextField.dart';
import '../Controller/UserController.dart';
import 'DistrictFirmList.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(UserController());

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Obx(
        ()=> Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Slider
            CarouselSlider(
              items: controller.carouselSliderData.map((item) {
                return Image.network(
                  "http://192.168.0.56/Varia/${item["image_url"].toString()}",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text('Failed to load image'),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 160, // Reduced height
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    controller.currentSliderIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            // Carousel indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.carouselSliderData.length, // Use the length of carouselSliderData
                    (index) => Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.currentSliderIndex == index
                        ? Colors.blue
                        : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 16),
            // // Search Bar
            // SearchTextField(
            //   controller: _searchController,
            //   onChanged: _filterDistricts,
            //   hintText: "Search Districts...",
            // ),

            const SizedBox(height: 16),
            // Grid with filtered districts
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.getListDistrictByLoginIdData.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 3 / 1.8,
              ),
              itemBuilder: (context, index) {
                final district = controller.getListDistrictByLoginIdData[index];
                return GestureDetector(
                  onTap: (){
                    Get.to(DistrictFirmList(
                      district_id: district["district_id"],
                      subscription_status: district["subscription_status"],
                      district_name: district["district_name"],
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff84C225),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        district['district_name']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 3,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}