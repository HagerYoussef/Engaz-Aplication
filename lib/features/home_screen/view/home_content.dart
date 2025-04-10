import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../viewmodel/content_viewmodel.dart';
import '../widgets/category_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContentViewModel(),
      child: Consumer<ContentViewModel>(
        builder: (context, viewModel, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: const Color(0xffFDFDFD),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'الرئيسية',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'IBM_Plex_Sans_Arabic'),
                            ),
                            Row(
                              children: [
                                Image.asset("assets/images/img8.png"),
                                const SizedBox(width: 10),
                                Image.asset("assets/images/img9.png"),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'مرحباً محمد!',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'IBM_Plex_Sans_Arabic',
                              color: Color(0xff409EDC)),
                        ),
                        Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.maybeOf(context)?.size.height != null
                              ? MediaQuery.of(context).size.height * 0.25
                              : 200,
                                child: PageView.builder(
                                  controller: viewModel.pageController,
                                  itemCount: viewModel.images.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(horizontal: .5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(viewModel.images[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.center,
                                child: SmoothPageIndicator(
                                  controller: viewModel.pageController,
                                  count: viewModel.images.length,
                                  effect: const ExpandingDotsEffect(
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    activeDotColor: Color(0xff409EDC),
                                    dotColor: Colors.grey,
                                    expansionFactor: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'التصنيفات',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff1D1D1D),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBM_Plex_Sans_Arabic',
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...viewModel.categories.map((cat) => CategoryCard(
                          title: cat['title'],
                          description: cat['description'],
                          image: cat['image'],
                          destinationPage: cat['page'],
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
