import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/change_lang.dart';
import '../viewmodel/home_viewmodel.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => HomeViewModel(),
        child: Consumer<HomeViewModel>(builder: (context, viewModel, child) {
          return Consumer<LocalizationProvider>(
            builder: (context, localizationProvider, child) {
              final locale = localizationProvider.locale.languageCode;
              final textDirection =
                  locale == 'ar' ? TextDirection.rtl : TextDirection.ltr;

              return Directionality(
                textDirection: textDirection,
                child: Scaffold(
                  backgroundColor: const Color(0xffFDFDFD),
                  bottomNavigationBar: BottomNavigationBar(
                    backgroundColor: const Color(0xffFDFDFD),
                    elevation: 0,
                    items: [
                      BottomNavigationBarItem(
                        icon: ImageIcon(AssetImage('assets/images/img13.png')),
                        label: Translations.getText(
                          'home',
                          context
                              .read<LocalizationProvider>()
                              .locale
                              .languageCode,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: ImageIcon(AssetImage('assets/images/img14.png')),
                        label: Translations.getText(
                          'req',
                          context
                              .read<LocalizationProvider>()
                              .locale
                              .languageCode,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: ImageIcon(AssetImage('assets/images/img15.png')),
                        label: Translations.getText(
                          'offer',
                          context
                              .read<LocalizationProvider>()
                              .locale
                              .languageCode,
                        ),
                      ),
                    ],
                    selectedItemColor: Colors.blue,
                    unselectedItemColor: Colors.grey,
                    currentIndex: viewModel.selectedIndex,
                    onTap: viewModel.changeTab,
                  ),
                  body:
                      SafeArea(child: viewModel.pages[viewModel.selectedIndex]),
                ),
              );
            },
          );
        }));
  }
}
