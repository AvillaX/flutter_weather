import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/api/models.dart';
import 'package:flutter_weather/pages/home_page.dart';
import 'next_day.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with SingleTickerProviderStateMixin {
  style(size) => TextStyle(fontSize: size);
  bold(size) => TextStyle(fontSize: size, fontWeight: FontWeight.bold);

  late AnimationController animationController;

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => repository.fetchWeather(cityId),
        child: ListView(
          children: [
            Stack(
              children: [
                AnimatedBuilder(
                    animation: animationController,
                    builder: (context, _) {
                      double slide = 255 * animationController.value;
                      double scale = 1 - (animationController.value * 0.2);
                      return Transform(
                        transform: Matrix4.identity()
                          ..translate(slide)
                          ..scale(scale),
                        alignment: Alignment.centerLeft,
                        child: FutureBuilder(
                            future: repository.fetchWeather(cityId),
                            builder: (BuildContext context,
                                AsyncSnapshot<Weather> snapshot) {
                              if (snapshot.data == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                DateTime today =
                                    DateTime.parse(snapshot.data!.date);
                                final list = snapshot.data!.alldays;
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            IconButton(
                                                onPressed: toggle,
                                                icon: const Icon(
                                                    Icons.circle_outlined)),
                                            Text(snapshot.data!.city,
                                                style: bold(35.0)),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                              DateFormat('EEEE')
                                                  .format(today)
                                                  .toString(),
                                              style: bold(25.0)),
                                          Text(snapshot.data!.weatherState,
                                              style: bold(25.0)),
                                        ],
                                      ),
                                      Center(
                                        child: SizedBox(
                                          height: 150,
                                          child: Image(
                                              image: NetworkImage(
                                                  'https://www.metaweather.com/static/img/weather/png/${snapshot.data!.weatherStateAbbr}.png')),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          '${snapshot.data!.currentTemp.toStringAsFixed(0)} C',
                                          style: style(60.0),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Text(
                                            'Humidity: ${snapshot.data!.humidity}%',
                                            style: style(12.0)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          'Pressure: ${snapshot.data!.airPressure.toStringAsFixed(0)} hPa',
                                          style: style(12.0),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          'Wind: ${snapshot.data!.windSpeed.toStringAsFixed(2)} km/h',
                                          style: style(12.0),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        height: 150,
                                        width: double.infinity,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            ...list.skip(1).map((e) {
                                              DateTime day =
                                                  DateTime.parse(e.date);
                                              return NextDay(
                                                minVal: e.minTemp
                                                    .toStringAsFixed(0),
                                                maxVal: e.maxTemp
                                                    .toStringAsFixed(0),
                                                day: DateFormat('EEEE')
                                                    .format(day)
                                                    .toString(),
                                                imPath: e.weatherState,
                                              );
                                            }),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                            }),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
