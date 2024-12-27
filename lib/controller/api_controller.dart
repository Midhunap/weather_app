import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/w_model.dart';



class ApiController extends GetxController{





  var weather = <WeatherResponse>[].obs;
  var loader = false.obs;
  Future<void> getWeather(String city)async{
    print('api fetching');
    loader.value =true;
    weather.value.clear();
    var serurl = 'https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=86666cddd625e7cdd81533161bba41e2&units=metric';

    final response = await http.get(Uri.parse(serurl),
    );
    if(response.statusCode == 200){
      print('api success $city');
      loader.value = false;
      var jsonData = json.decode(response.body);
      WeatherResponse weatherResponse = WeatherResponse.fromJson(jsonData);
      weather.value.add(weatherResponse);
    }else{
      print(response.statusCode);
      loader.value = false;
    }

  }





}