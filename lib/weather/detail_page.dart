import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/constants.dart';
import 'package:weather_app/weather/flutter_map.dart';
import 'package:weather_app/weather/weather_item.dart';

class DetailPage extends StatefulWidget {
  final List consolidatedWeatherList;
  final int selectedId;
  final String location;
  const DetailPage(
      {super.key,
      required this.consolidatedWeatherList,
      required this.selectedId,
      required this.location});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();
    //Tạo linear grandient
    final Shader linearGradient = const LinearGradient(
            colors: <Color>[Color(0x0ffabcff), Color(0xff9AC6F3)])
        .createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    int selectedIndex = widget.selectedId;
    var weatherStateName = widget.consolidatedWeatherList[selectedIndex]
            ["weather"][int.parse("0")]["main"] ??
        0;
    imageUrl = weatherStateName.replaceAll(' ', '').toLowerCase();

    return Scaffold(
      backgroundColor: myConstants.secondaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: myConstants.secondaryColor,
        elevation: 0.0,
        title: Text(widget.location),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const flutter_map()));
                },
                icon: const Icon(Icons.settings),
              )),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              height: 150,
              width: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.consolidatedWeatherList.length,
                itemBuilder: (BuildContext context, int index) {
                  var futureWeatherName = widget.consolidatedWeatherList[index]
                      ["weather"][int.parse("0")]["main"];
                  var weatherUrl =
                      futureWeatherName.replaceAll('', '').toLowerCase();
                  var parseDate = DateTime.parse(
                      widget.consolidatedWeatherList[index]["dt_txt"]);
                  var newDate =
                      DateFormat('EEEE').format(parseDate).substring(0, 3);
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    margin: const EdgeInsets.only(right: 20),
                    width: 80,
                    decoration: BoxDecoration(
                        color: index == selectedIndex
                            ? Colors.white
                            : const Color(0xff9ebcf9),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                              color: Colors.blue.withOpacity(.3))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.consolidatedWeatherList[index]["main"]["temp"].round() - 273}C",
                          style: TextStyle(
                            fontSize: 17,
                            color: index == selectedIndex
                                ? Colors.blue
                                : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // ignore: prefer_interpolation_to_compose_strings
                        Image.asset(
                          "${'assets/' + weatherUrl}.png",
                          width: 40,
                        ),
                        Text(
                          newDate,
                          style: TextStyle(
                            fontSize: 17,
                            color: index == selectedIndex
                                ? Colors.blue
                                : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: size.height * .55,
              width: size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  )),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -40,
                    right: 20,
                    left: 20,
                    child: Container(
                      width: size.width * .7,
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.center,
                              colors: [
                                Color(0xffa9c1f5),
                                Color(0xff6696f5),
                              ]),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(.3),
                              offset: const Offset(0, 25),
                              blurRadius: 3,
                              spreadRadius: -10,
                            )
                          ]),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -40,
                            left: 20,
                            child: Image.asset(
                              'assets/$imageUrl.png',
                              width: 150,
                            ),
                          ),
                          Positioned(
                              top: 120,
                              left: 30,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  weatherStateName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              )),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              width: size.width * .8,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  weatheritem(
                                    text: 'Wind Speed',
                                    value: widget
                                        .consolidatedWeatherList[selectedIndex]
                                            ["wind"]["speed"]
                                        .round(),
                                    unit: 'km/h',
                                    imageUrl: 'assets/windspeed.png',
                                  ),
                                  weatheritem(
                                    text: 'Humidity',
                                    value: widget
                                        .consolidatedWeatherList[selectedIndex]
                                            ["main"]["humidity"]
                                        .round(),
                                    unit: '',
                                    imageUrl: 'assets/humidity.png',
                                  ),
                                  weatheritem(
                                    text: 'Temp Max',
                                    value: widget.consolidatedWeatherList[
                                                selectedIndex]["main"]
                                                ['temp_max']
                                            .round() -
                                        273,
                                    unit: 'C',
                                    imageUrl: 'assets/max-temp.png',
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    (widget.consolidatedWeatherList[
                                                    selectedIndex]["main"]
                                                    ["temp"]
                                                .round() -
                                            273)
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = linearGradient,
                                    )),
                                Text(
                                  'o',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = linearGradient,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 300,
                    left: 20,
                    child: SizedBox(
                      height: 200,
                      width: size.width * .9,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.consolidatedWeatherList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var futureWeatherName =
                              widget.consolidatedWeatherList[index]["weather"]
                                      [int.parse("0")]["main"] ??
                                  0;
                          var futureImageURL = futureWeatherName
                              .replaceAll('', '')
                              .toLowerCase();
                          var mydate = DateTime.parse(
                              widget.consolidatedWeatherList[index]["dt_txt"]);
                          var currentDate =
                              DateFormat('d MMMM,EEEE').format(mydate);
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 10, top: 13, right: 10, bottom: 5),
                            height: 80,
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: myConstants.secondaryColor
                                        .withOpacity(.1),
                                    spreadRadius: 5,
                                    blurRadius: 20,
                                    offset: const Offset(0, 3),
                                  )
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    currentDate,
                                    style: const TextStyle(
                                      color: Color(0xff6696f5),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        (widget.consolidatedWeatherList[index]
                                                        ["main"]["temp_max"]
                                                    .round() -
                                                273)
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Text(
                                        '/',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 30,
                                        ),
                                      ),
                                      Text(
                                        (widget.consolidatedWeatherList[index]
                                                        ["main"]["temp_min"]
                                                    .round() -
                                                273)
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // ignore: duplicate_ignore
                                    children: [
                                      // ignore: prefer_interpolation_to_compose_strings
                                      Image.asset(
                                        '${'assets/' + futureImageURL}.png',
                                        width: 30,
                                      ),
                                      Text(widget.consolidatedWeatherList[index]
                                          ["weather"][int.parse("0")]["main"]),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
