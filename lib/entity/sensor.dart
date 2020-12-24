class Sensor {
  int temperature,
      humidity,
      waterLevel,
      pirMotion,
      DHT11IsDown,
      PirIsDown,
      WaterLevelIsDown,
      WebcamIsDown;

  Sensor(Map<dynamic, dynamic> json) {
    DHT11IsDown = json['Diagnosis']['DHT11IsDown'].round();
    PirIsDown = json['Diagnosis']['PirIsDown'].round();
    WaterLevelIsDown = json['Diagnosis']['WaterLevelIsDown'].round();
    WebcamIsDown = json['Diagnosis']['WebcamIsDown'].round();
    temperature = json['DHT11']['temperature'].round();
    humidity = json['DHT11']['humidity'].round();
    waterLevel = json['WaterLevel'];
    pirMotion = json['PirMotion'];

    if (DHT11IsDown == 1) print("DHT11 is down");
    if (PirIsDown == 1) print("Pir is down");
    if (WaterLevelIsDown == 1) print("WaterLevel is down");
    if (WebcamIsDown == 1) print("Webcam is down");

    print('Temperature is: ' + temperature.toString() + ' °C');
    print('Humidity is: ' + humidity.toString() + '%');

    String risk = (waterLevel == 0) ? 'LOW' : 'HIGH';
    print('WaterLevel is: ' + risk);

    String motion = (pirMotion == 0) ? 'NOT DETECTED' : 'DETECTED';
    print('Motion: ' + motion);
  }

//  Dht.fromDht(String temperature, String humidity) {
//    this.temperature = temperature;
//    this.humidity = humidity;
//  }

  int getDHT11IsDown() {
    return DHT11IsDown;
  }

  int getWaterLevelIsDown() {
    return WaterLevelIsDown;
  }

  int getPirIsDown() {
    return PirIsDown;
  }

  int getWebcamIsDown() {
    return WebcamIsDown;
  }

  String getTemperature() {
    return (temperature.toString() + ' °C');
  }

  String getHumidity() {
    return (humidity.toString() + ' %');
  }

  String getWaterLevel() {
    return (waterLevel == 1) ? 'HIGH' : 'OK';
  }

  String getMotionSersor() {
    return (pirMotion == 1) ? 'DETECTED' : 'OK';
  }
}
