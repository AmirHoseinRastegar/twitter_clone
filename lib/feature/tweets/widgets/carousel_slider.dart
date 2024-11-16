import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class CrouselTweetImages extends StatefulWidget {
  final List<String> imageLinks;

  const CrouselTweetImages({super.key, required this.imageLinks});

  @override
  State<CrouselTweetImages> createState() => _CrouselTweetImagesState();
}

class _CrouselTweetImagesState extends State<CrouselTweetImages> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CarouselSlider(

              items: widget.imageLinks.map((links) {
                return Container(
                  padding:  const EdgeInsets.symmetric(horizontal: 25),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Image.network(
                    links,
                    fit: BoxFit.contain,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex= index;
                  });
                },
viewportFraction: 1,
                enableInfiniteScroll: false,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              ///this entries.map that comes after asMap will create a list
              /// of widgets based on the number of entries and uses indexes of the list as
              /// key we can use key to access the lists items position
              children: widget.imageLinks.asMap().entries.map((entry) {
                return Container(
                  height: 5,
                  width: 15,
                  margin: const EdgeInsets.symmetric( vertical: 8,horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius:  BorderRadius.circular(15),
                    color: _currentIndex == entry.key
                        ? Colors.white.withOpacity(0.9)
                        : Colors.white.withOpacity(0.3),
                  ),
                );

              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
