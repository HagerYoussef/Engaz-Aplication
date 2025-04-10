import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/home_viewmodel.dart';
import 'home_content.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: const Color(0xffFDFDFD),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: const Color(0xffFDFDFD),
                elevation: 0,
                items: const [
                  BottomNavigationBarItem(
                      icon: ImageIcon(AssetImage('assets/images/img13.png')),
                      label: 'الرئيسية'),
                  BottomNavigationBarItem(
                      icon: ImageIcon(AssetImage('assets/images/img14.png')),
                      label: 'طلباتي'),
                  BottomNavigationBarItem(
                      icon: ImageIcon(AssetImage('assets/images/img15.png')),
                      label: 'المزيد'),
                ],
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
                currentIndex: viewModel.selectedIndex,
                onTap: viewModel.changeTab,
              ),
              body: SafeArea(child: viewModel.pages[viewModel.selectedIndex]),
            ),
          );
        },
      ),
    );
  }
}
