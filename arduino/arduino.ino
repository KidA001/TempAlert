#include "config.h"
#include <SPI.h>
#include <WiFi101.h>
#include <string.h>
#include <stdlib.h>
#include <OneWire.h>
#include <DallasTemperature.h>

//WiFi Client Setup
int status = WL_IDLE_STATUS;
WiFiClient client;

// Setup for temperature sensor
#define ONE_WIRE_BUS A5
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);
DeviceAddress insideThermometer;


void setup() {
  Serial.begin(9600);
  WiFi.setPins(8,2,A3,-1);
  connectWifiShield();
  wifiConnect();
  sensors.begin();
}

void loop() {
  sensors.requestTemperatures();
  int temperature = (((sensors.getTempCByIndex(0) * 9.)/5.)+32.);
  Serial.println(temperature);
  char temp[5];
  dtostrf(temperature,5,2,temp);
  
  httpRequest(temp);
  delay(60000); //1min
}

void connectWifiShield() {
  if (WiFi.status() == WL_NO_SHIELD) {
    while (true);
  }
}

void httpRequest(String temp) {
  while (client.available()) {
    char c = client.read();
    Serial.write(c);
  }
  String request = "POST /api/webhooks/temp?temperature=" + temp + " HTTP/1.1\r\n"
                   "Authorization: Token " + authToken + "\r\n"
                   "Host: hottub.somahouse.family\r\n"
                   "Connection: close\r\n";

  if (client.connect(server, 80)) {
    client.println(request);
    client.println();
  }
  else {
    Serial.println(F("Connection failed"));
  }
  client.stop();
  WiFi.end();
  delay(10);
  WiFi.begin(ssid, pass);
}

void wifiConnect() {
  while ( status != WL_CONNECTED) {
    status = WiFi.begin(ssid, pass);
    delay(1000);
  }
  Serial.println("Connected to WiFi");
}

