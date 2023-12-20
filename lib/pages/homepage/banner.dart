import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<String> images = [
    "https://wallpaperaccess.com/full/2637581.jpg",
    "https://wallpaperaccess.com/full/9070071.png",
    "https://wallpaperaccess.com/full/9070079.jpg",
];

class CarouselCustom extends StatefulHookConsumerWidget {
    const CarouselCustom({super.key});

    @override
    ConsumerState<ConsumerStatefulWidget> createState() => _CarouselState();
}

class _CarouselState extends ConsumerState<CarouselCustom> {
    final Duration animationDuration = const Duration(milliseconds: 200);
    late PageController _pageController;
    int activePage = 1;

    @override
    void initState() {
        super.initState();
        _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
    }

    @override
    Widget build(BuildContext context) {
        return Column(
            children: <Widget>[
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: PageView.builder(
                        itemCount: images.length,
                        pageSnapping: true,
                        controller: _pageController,
                        onPageChanged: (page) {
                            setState(() {
                                activePage = page;
                            });
                        },
                        itemBuilder: (context, pagePosition) {
                            bool active = pagePosition == activePage;
                            return GestureDetector(
                                child: slider(images, pagePosition, active, bannerOnTap: () async{
                                    if(pagePosition != activePage) {
                                        setState(() {
                                            _pageController.animateToPage(pagePosition, duration: animationDuration, curve: Curves.easeIn);
                                        });
                                    }
                                    else {
                                        debugPrint("$pagePosition");
                                    }
                                }),
                                onTap: () async{
                                    if(pagePosition != activePage) {
                                        setState(() {
                                            _pageController.animateToPage(pagePosition, duration: animationDuration, curve: Curves.easeIn);
                                        });
                                    }
                                    else {
                                        debugPrint("$pagePosition");
                                    }
                                },
                            );
                        },
                    ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicators(images.length, activePage, slideIndicatorAction: (index) async{
                        setState(() {
                            // activePage = index;
                            _pageController.animateToPage(index, duration: animationDuration, curve: Curves.easeIn);
                        });
                    },),
                )
            ],
        );
    }
}

AnimatedContainer slider(List<String> images, int pagePosition, bool active, {VoidCallback? bannerOnTap}) {
    double margin = active ? 10 : 20;

    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        margin: EdgeInsets.all(margin),
        // decoration: BoxDecoration(
        //     image: DecorationImage(image: NetworkImage(images[pagePosition]))
        // ),
        child: GestureDetector(
            onTap: bannerOnTap,
            child: Image.network(images[pagePosition], loadingBuilder: (context, child, loadingProgress) {
                if(loadingProgress == null) {
                    return child;
                } 
                // else {
                    return const Center(child: CircularProgressIndicator(),);
                // }
            },),
        ),
    );
}

List<Widget> indicators(int imagesLength, int currentIndex, {Function(int index)? slideIndicatorAction}) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
        margin: const EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle
        ),
        child: GestureDetector(
            onTap: () async{
                slideIndicatorAction!(index);
            },
        ),
    );
  });
}