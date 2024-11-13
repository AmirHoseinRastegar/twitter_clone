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
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imageLinks.map((links) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Image.network(
                    links,
                    fit: BoxFit.contain,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 300,
                enableInfiniteScroll: false,
              ),
            ),
          ],
        )
      ],
    );
  }
}
