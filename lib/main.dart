import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  String? location = 'Nairobi';
  String? apiKey = 'b34fddd3dae4a2eb0ad363b62f98ba1e';
  Map weatherData = {};
  bool loading = false;
  final TextEditingController _textFieldController = TextEditingController();

  Future<void> _fetchWeatherData() async {
    setState(() {
      loading = true;
    });

    var response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
        loading = false;
        print(weatherData);
      });

      _textFieldController.clear();
    } else {
      throw 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: TextFormField(
                                onChanged: (value) {
                                  location = value;
                                  // placeAutocomplete(value);
                                },
                                controller: _textFieldController,
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  hintText: 'Enter Location',
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: SvgPicture.asset(
                                      'assets/icons/location.svg',
                                      // color: secondaryColor40LightTheme,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: _fetchWeatherData,
                            icon: const Icon(Icons.search)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.amberAccent,
                      margin: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text('${weatherData['name']}'),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Image.network(
                                      'https://openweathermap.org/img/w/${weatherData['weather'][0]['icon']}.png'),
                                  Text(
                                    '${weatherData['main']['temp']}°',
                                    style: const TextStyle(
                                      fontSize: 40.0,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      '${weatherData['weather'][0]['description']}'),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('${weatherData['wind']['speed']} kph'),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('${weatherData["main"]["humidity"]} %'),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
