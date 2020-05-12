

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeCarousel extends StatelessWidget {

  static const startPage = 1;

  final List<String> _imgList = [
    'images/banner1.jpg',
    'images/banner2.jpg',
    'images/banner3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          enableInfiniteScroll: false,
          height: 140,
          initialPage: startPage,
        ),
        items: _imgList.map((item) => Container(
          margin: EdgeInsets.symmetric(
            horizontal: 10.0, vertical: 0.0
          ),
          child: Center(
            child: GestureDetector(
              onTap: () { showModal(context); },
              child: Image.asset(item, fit: BoxFit.cover, width: 280)
            )
          ),
        )).toList(),
      )
    );
  }

  void showModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.keyboard_arrow_down), onPressed: () { Navigator.pop(context); })
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}