import 'package:flutter/material.dart';

class NextDay extends StatelessWidget {
  const NextDay(
      {Key? key,
      required this.minVal,
      required this.maxVal,
      required this.day,
      required this.imPath})
      : super(key: key);
  final String minVal, maxVal;
  final String day;
  final String imPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(left: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(day),
          Image(
              image: NetworkImage(
                  'https://www.metaweather.com/static/img/weather/png/$imPath.png')),
          //Image(image: AssetImage('assets/$imPath.png')),
          Text('$minVal / $maxVal'),
        ],
      ),
    );
  }
}
