import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:weather/weather.dart';
import 'package:webviewx/webviewx.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class LandingScreen extends StatefulWidget {
  List<CameraDescription> cameras;
  LandingScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late CameraController controller;
  String key = '856822fd8e22db5e1ba48c0e7d69844a';
  late WebViewXController webviewController;
  late WeatherFactory ws;
  late Weather data;

  int option = 0;

  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
    getData();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  bool loader = true;

  getData() async {
    setState(() {
      loader = true;
    });
    data = await ws.currentWeatherByCityName('bhubaneswar');
    setState(() {
      loader = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    webviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          const Text(
                            "Calendar",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: TableCalendar(
                              rowHeight: 32,
                              firstDay: DateTime.utc(2010, 10, 16),
                              lastDay: DateTime.utc(2030, 3, 14),
                              focusedDay: DateTime.now(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                option = 1;
                              });
                              webviewController.loadContent(
                                  "http://14.139.221.186:3000/",
                                  SourceType.url);
                            },
                            color: option == 1 ? Colors.blue : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Dress Suggestions',
                                style: TextStyle(
                                    color: option == 1
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 32,
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                option = 2;
                              });
                              webviewController.loadContent(
                                  "http://14.139.221.186:3000/hair",
                                  SourceType.url);
                            },
                            color: option == 2 ? Colors.blue : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Hair Suggestions',
                                style: TextStyle(
                                    color: option == 2
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 32,
                          ),
                          MaterialButton(
                            color: option == 3 ? Colors.blue : Colors.white,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  content: Text("Feature Comming Soon!"),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'AR Try Now!',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Weather Report",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text("City: ${data.areaName}, ${data.country}"),
                                Text("Temperature: ${data.temperature}"),
                                Text("Feels Like: ${data.tempFeelsLike}"),
                                Text("Weather: ${data.weatherDescription}"),
                                Text("Wind: ${data.windSpeed}"),
                                Text("Humidity: ${data.humidity}"),
                                Text("Pressure: ${data.pressure}"),
                                Text("Cloudiness: ${data.cloudiness}"),
                                Text("Icon: ${data.weatherIcon}"),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Essentials Suggestions",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                data.weatherDescription!
                                        .toLowerCase()
                                        .contains("rain")
                                    ? const Text("Take Umbrella/Raincoat \nRainBoots \n Quick-Dry Clothes \n Small Towels\nFace Mask")
                                    : data.weatherDescription!
                                            .toLowerCase()
                                            .contains("sun")
                                        ? const Text("Apply Sunscreen")
                                        : const Text("Nothing"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Center(
            child: option == 0
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: CameraPreview(controller),
                  )
                : option == 1
                    ? WebViewX(
                        initialContent: "Loading...",
                        onWebViewCreated: (controller) {
                          webviewController = controller;
                          webviewController.loadContent(
                              "http://14.139.221.186:3000/", SourceType.url);
                        },
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width * 0.6,
                      )
                    : option == 2
                        ? WebViewX(
                            initialContent: "Loading...",
                            onWebViewCreated: (controller) {
                              webviewController = controller;
                              webviewController.loadContent(
                                  "http://14.139.221.186:3000/hair",
                                  SourceType.url);
                            },
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: MediaQuery.of(context).size.width * 0.6,
                          )
                        : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
