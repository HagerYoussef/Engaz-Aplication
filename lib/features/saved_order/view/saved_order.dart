// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:provider/provider.dart';
//
// import '../../address/view/address.dart';
// import '../../address/view/edit_address.dart';
// import '../../address/view_model/add_address_view_model.dart';
//
// class SavedAddress extends StatefulWidget {
//   const SavedAddress({Key? key}) : super(key: key);
//
//   @override
//   _SavedAddressState createState() => _SavedAddressState();
// }
//
// class _SavedAddressState extends State<SavedAddress> {
//   String? currentLocation = 'جاري تحديد الموقع...';
//   String? selectedAddress;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() {
//         currentLocation = 'خدمة الموقع غير مفعلة';
//       });
//       return;
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() {
//           currentLocation = 'تم رفض صلاحية الوصول للموقع';
//         });
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       setState(() {
//         currentLocation = 'تم رفض صلاحية الوصول نهائياً';
//       });
//       return;
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//
//     getAddressFromLatLng(position.latitude, position.longitude);
//   }
//
//   Future<void> getAddressFromLatLng(double lat, double lng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//
//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;
//         setState(() {
//           currentLocation =
//           "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
//         });
//       }
//     } catch (e) {
//       print("Error getting location: $e");
//       setState(() {
//         currentLocation = "تعذر تحديد الموقع";
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: const Color(0xffF8F8F8),
//         appBar: AppBar(
//           leading: const Icon(Icons.arrow_back_ios),
//           title: const Text('العناوين المحفوظه',
//               style: TextStyle(color: Colors.black)),
//           backgroundColor: const Color(0xffF8F8F8),
//           elevation: 0,
//           iconTheme: const IconThemeData(color: Colors.black),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                         child: Image.asset('assets/images/img52.png',
//                             height: 100)),
//                     const SizedBox(height: 20),
//                     const Center(
//                       child: Text(
//                         "اختر احد العناوين المحفوظه الخاصه بك",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     _buildAddressCard("المنزل"),
//                     _buildAddressCard("العمل"),
//                     const SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   if (selectedAddress != null) _buildDeliveryButton(),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: _buildAddAddressButton(),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAddressCard(String title) {
//     bool isSelected = selectedAddress == title;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedAddress = title;
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(
//             color: isSelected ? const Color(0xff409EDC) : Colors.transparent,
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(title,
//                     style: const TextStyle(
//                         color: Color(0xff409EDC),
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold)),
//                 Row(
//                   children: [
//                     InkWell(
//
//                         onTap: (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context)=>EditAddressScreen()));
//                         },
//                         child: Image.asset("assets/images/img54.png")),
//                     const SizedBox(width: 10),
//                     InkWell(
//                       onTap: () {
//                         Provider.of<AddAddressViewModel>(context, listen: false).deleteAddress(context);
//                       },
//                       child: Image.asset("assets/images/img53.png"),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 4),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "الموقع :",
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   Expanded(
//                     child: Text(
//                       currentLocation ?? '',
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDeliveryButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.white,
//           foregroundColor: const Color(0xff409EDC),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//             side: const BorderSide(color: Color(0xff409EDC), width: 1),
//           ),
//         ),
//         onPressed: () {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('تم اختيار التوصيل إلى $selectedAddress')),
//           );
//         },
//         child: const Text(
//           'التوصيل إلى هذا العنوان',
//           style: TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAddAddressButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xff409EDC),
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>  AddAddressScreen()));
//         },
//         child: const Text('اضافه عنوان جديد',
//             style: TextStyle(color: Colors.white, fontSize: 16)),
//       ),
//     );
//   }
// }
//



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../address/view/address.dart';
import '../../address/view/edit_address.dart';
import '../../address/view_model/add_address_view_model.dart';

class SavedAddress extends StatefulWidget {
  const SavedAddress({Key? key}) : super(key: key);

  @override
  _SavedAddressState createState() => _SavedAddressState();
}

class _SavedAddressState extends State<SavedAddress> {
  String? selectedAddress;
  List<dynamic> addresses = [];

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId == null) {
      print('User ID not found');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/address/$userId'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          addresses = data['addresses'];
        });
      } else {
        print('Failed to load addresses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching addresses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        appBar: AppBar(
          leading: const Icon(Icons.arrow_back_ios),
          title: const Text('العناوين المحفوظه',
              style: TextStyle(color: Colors.black)),
          backgroundColor: const Color(0xffF8F8F8),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Image.asset('assets/images/img52.png',
                            height: 100)),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "اختر احد العناوين المحفوظه الخاصه بك",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...addresses.map((address) => _buildAddressCard(
                      address['name'],
                      address['address'],
                    )).toList(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (selectedAddress != null) _buildDeliveryButton(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: _buildAddAddressButton(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(String title, String address) {
    bool isSelected = selectedAddress == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddress = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xff409EDC) : Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Color(0xff409EDC),
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    InkWell(

                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditAddressScreen()));
                        },
                        child: Image.asset("assets/images/img54.png")),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Provider.of<AddAddressViewModel>(context, listen: false).deleteAddress(context);
                      },
                      child: Image.asset("assets/images/img53.png"),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "الموقع :", // Changed from "الموقع" to "العنوان"
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      address,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xff409EDC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xff409EDC), width: 1),
          ),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم اختيار التوصيل إلى $selectedAddress')),
          );
        },
        child: const Text(
          'التوصيل إلى هذا العنوان',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildAddAddressButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff409EDC),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  AddAddressScreen()));
        },
        child: const Text('اضافه عنوان جديد',
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

}