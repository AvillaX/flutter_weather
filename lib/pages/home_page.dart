import 'package:flutter/material.dart';
import 'package:flutter_weather/api/api_service.dart';
import 'package:flutter_weather/pages/weather_page.dart';

int cityId = 0;
final repository = WeatherApiClient();

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.submitted}) : super(key: key);
  final VoidCallback? submitted;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();
  String city = '';
  Future<void> submitted() async {
    setState(() {
      city = textEditingController.text;
    });
    final _city = await repository.getLocationId(city);
    cityId = _city;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const WeatherPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 150),
            child: Text(
              'Weather App',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onSubmitted: ((val) async {
                await submitted();
                textEditingController.clear();
              }),
              controller: textEditingController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Enter City'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await submitted();
              textEditingController.clear();
            },
            child: const Text('Submit'),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
