
import 'package:engaz_app/features/visitor/view/setting_screen_2.dart';
import 'package:flutter/material.dart';

class PleaseLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(  backgroundColor: Colors.white,
          title: const Text("عفوا",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset("assets/images/img23.png"))),
      body: Column(
        children: [
          Center(child: Image.asset("assets/images/img24.png",width:200,height:200)),

          const Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text("الرجاء تسجيل الدخول اولا للوصول الي خدمات التطبيق",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 13,color: Colors.grey)),
                ),
              )),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xff409EDC), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  minimumSize: const Size(164, 5),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'تراجع',
                  style: TextStyle(
                    color: Color(0xff409EDC),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>SettingsScreen2()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff409EDC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  minimumSize: const Size(164, 5),
                ),
                child: const Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
