
#include <SPI.h>
#include <WiFi101.h>
#include <string.h>
#include <stdlib.h>

char ssid[] = "spruce-home";    //  your network SSID (name)
char pass[] = "homehome";       // your network password
int status = WL_IDLE_STATUS;    // the WiFi radio's status


// Initialize the WiFi client library
WiFiClient client;

// server address:
char server[] = "http://a7905c9d.ngrok.io";

void setup() {
  //Initialize serial and wait for port to open:
  Serial.begin(9600);
  WiFi.setPins(8,2,A3,-1);
  while (!Serial) {
    Serial.println("Waiting for serial");
  }

  //Connect to wifi shield
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("WiFi shield not present");
    // don't continue:
    while (true);
  }

  //Attempt to connect to WiFi network:
  while ( status != WL_CONNECTED) {
    Serial.print("Attempting to connect to WPA SSID: ");
    Serial.println(ssid);
    status = WiFi.begin(ssid, pass);

    delay(10000);
  }

  Serial.print("You're connected to the network");
  printCurrentNet();
  printWiFiData();
}

void loop() {
  // Measure the temperature
  int sensorValue = analogRead(A4);
  float milliVoltsValue = sensorValue * 5000. / 1024.;
  float temperature = (milliVoltsValue - 500.)/10.;

  // Print the temperature
 Serial.println(temperature);
  
  // Transform to string
  char temp[5];
  dtostrf(temperature,5,2,temp);

  //Print out last response from server
  while (client.available()) {
    char c = client.read();
    Serial.write(c);
  }

  httpRequest(temp);
  delay(300000); // 5min
}

void httpRequest(String temp) {
  // close any connection before send a new request to free up socket
  client.stop();
  String request = "POST /api/webhooks/temp?temperature=" + temp + " HTTP/1.1";

  // if there's a successful connection:
  if (client.connect(server, 80)) {
    Serial.println("connecting...");
    client.println(request);
    client.println("Authorization: Token FyyAwAjTDoK6WXRDYFBUcJEG");
    client.println("Host: a7905c9d.ngrok.io");
    client.println("User-Agent: ArduinoWiFi/1.1");
    client.println("Connection: close");
    client.println();
  }
  else {
    Serial.println("Connection failed");
  }
}

void printWiFiData() {
  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);
  Serial.println(ip);

  // print your MAC address:
  byte mac[6];
  WiFi.macAddress(mac);
  Serial.print("MAC address: ");
  Serial.print(mac[5], HEX);
  Serial.print(":");
  Serial.print(mac[4], HEX);
  Serial.print(":");
  Serial.print(mac[3], HEX);
  Serial.print(":");
  Serial.print(mac[2], HEX);
  Serial.print(":");
  Serial.print(mac[1], HEX);
  Serial.print(":");
  Serial.println(mac[0], HEX);

}

void printCurrentNet() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print the MAC address of the router you're attached to:
  byte bssid[6];
  WiFi.BSSID(bssid);
  Serial.print("BSSID: ");
  Serial.print(bssid[5], HEX);
  Serial.print(":");
  Serial.print(bssid[4], HEX);
  Serial.print(":");
  Serial.print(bssid[3], HEX);
  Serial.print(":");
  Serial.print(bssid[2], HEX);
  Serial.print(":");
  Serial.print(bssid[1], HEX);
  Serial.print(":");
  Serial.println(bssid[0], HEX);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.println(rssi);

  // print the encryption type:
  byte encryption = WiFi.encryptionType();
  Serial.print("Encryption Type:");
  Serial.println(encryption, HEX);
  Serial.println();
}

