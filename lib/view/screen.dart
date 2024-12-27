import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/api_controller.dart';


class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  var cont = Get.put(ApiController());

  var cityName = TextEditingController();
  var unit = TextEditingController();

  Future<void> saveLastSearchedCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastCity', city);
  }

  Future<void> loadLastSearchedCity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCity = prefs.getString('lastCity');
    if (lastCity != null && lastCity.isNotEmpty) {
      cityName.text = lastCity;
      await cont.getWeather(lastCity);
    }
  }

  @override
  void initState() {
    loadLastSearchedCity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Weather Now",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cityName,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Enter city name...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: ()async {
                      print('data');
                      if(cityName.text.isNotEmpty){
                        await saveLastSearchedCity(cityName.text);
                        await cont.getWeather(cityName.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Get Weather",
                      style: TextStyle(fontSize: 16,color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Obx(() {
                if (cont.loader.value) {
                  return Center(child: CircularProgressIndicator(color: Colors.blue));
                } else if (cont.weather.isNotEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cont.weather[0].name,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              cont.weather[0].main.temp.toString(),
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'feels like : ${cont.weather[0].main.feelsLike.toString()}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                              ),
                            ),

                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cont.weather[0].weather[0].main,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              cont.weather[0].weather[0].description,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(width: 1,color: Colors.grey)),
                              child: Column(

                                children: [
                                  Text(
                                    'Temparature',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${cont.weather[0].main.tempMin} - ${cont.weather[0].main.tempMax} ',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(width: 1,color: Colors.grey)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'pressure : ${cont.weather[0].main.pressure}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  Text(
                                    'humidity : ${cont.weather[0].main.humidity}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  Text(
                                    'sea level : ${cont.weather[0].main.seaLevel}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  Text(
                                    'ground level : ${cont.weather[0].main.grndLevel}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),

                            )
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('No weather data available.'));
                }
              })





            ],
          ),
        ),
      ),
    );
  }
}
