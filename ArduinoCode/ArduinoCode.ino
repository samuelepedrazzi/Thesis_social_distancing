#include "arduino_secrets.h"
#include <string>
#include <vector>
#include <SR04.h>
#include <Wire.h>
#include <time.h>
#include <EdgeEngine_library.h>
#include <SPI.h>
#include <WiFiNINA.h>
#include <Adafruit_MLX90614.h>


using std::vector;
using std::string;

/********Define features********/
sample* distanceSample = NULL;
sample* temperatureSample = NULL;
sample* alertSample = NULL;

/********Define ssid and password for WiFi connection********/
const char* ssidWifi = SECRET_SSID;
const char* passWifi = SECRET_PASS;

/********Define pin name for sensors and actuators********/
#define triggerPin 7
#define echoPin 6
#define buttonPin 5
#define ledPin 4
#define vibrationPin 3
#define redLedPin 2
#define greenLedPin 1
#define blueLedPin 0

/********Define variables for distance sensor********/
long duration;
int distance;
int delayCounter = 0;

/********Define variables for temperature sensor********/
Adafruit_MLX90614 mlx = Adafruit_MLX90614();
float temperature;


/********Define variables for Edge Engine********/
edgine* Edge;
connection* Connection; //Wrapper for the wifi connection
vector<sample*> samples;
int connection_state;


void setup() {

  /********Set sensors and actuators pins********/
  pinMode(triggerPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(redLedPin, OUTPUT);
  pinMode(greenLedPin, OUTPUT);
  pinMode(blueLedPin, OUTPUT);
  pinMode(vibrationPin, OUTPUT);

  pinMode(buttonPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(buttonPin), getTemperature, RISING);

  /********Initialize serial connection********/
  Serial.begin(115200);
  /********Setup I2C for temperature sensor********/
  Wire.begin();


  /********Connect WIFi module and connect to WiFi********/

  Connection = connection::getInstance();
  Connection->setupConnection(ssidWifi, passWifi);

  /********Initialize Edge Engine connection********/
  options opts;
  //login
  opts.username = "distancing-user-username";
  opts.password =  "distancing-user-password";
  opts.tenant =    "social-distancing-reminder";
  //route
  opts.url = "https://students.atmosphere.tools";
  opts.ver = "v1";
  opts.login = "login";
  opts.devs = "devices";
  opts.scps = "scripts";
  opts.measurements = "measurements";
  opts.info = "info";
  opts.issues = "issues";
  //Edge Engine identifiers
  opts.thing = "User B";
  opts.device = "distance-monitor-1";
  opts.id = "distance-monitor-1";

  //start Edge engine
  Edge = edgine::getInstance();
  Edge->init(opts);

  /********Check sensors ********/
  Serial.println("\n\n");
  if ( getDistance() != 0) Serial.print("Sensore di distanza correttamente funzionante\n");
  else  Serial.print("Errore nel sensore di distanza!!\n");

  Serial.println("\n\n");
  if (mlx.readObjectTempC() < 45) Serial.print("Sensore di temperatura correttamente funzionante\n\n\n");
  else  Serial.print("Errore nel sensore di temperatura!!\n");
}

void loop() {
  delay(10000);
  distanceSample = new sample("distance");
  distanceSample->startDate = Edge->Api->getActualDate();
  distanceSample->endDate = distanceSample->startDate;
  distanceSample->value = (getDistance());
  samples.push_back(distanceSample);

  alertSample = new sample("alert");
  alertSample->startDate = Edge->Api->getActualDate();
  alertSample->endDate = alertSample->startDate;
  alertSample->value = distanceSample->value;
  samples.push_back(alertSample);


  distance = distanceSample->value;
  if (distance < 100) {
    setLed(255, 0, 0);
    vibrate(1000, 1000, 2);
  }
  else setLed(0, 0, 255);


  Edge->evaluate(samples);

  samples.clear(); // after evaluated all samples delete them

  delete distanceSample;
  delete temperatureSample;
  delete alertSample;
  distanceSample = NULL;
  temperatureSample = NULL;
  alertSample = NULL;
}

int getDistance() {
  digitalWrite(triggerPin, LOW);
  delayMicroseconds(2);
  // Sets the triggerPin on HIGH state for 10 micro seconds
  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(500000);
  digitalWrite(triggerPin, LOW);
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);
  // Calculating the distance
  distance = duration * 0.034 / 2;
  // Prints the distance on the Serial Monitor
  Serial.print("Distance: ");
  Serial.println(distance);
  return distance;

}

void getTemperature() {

  Serial.println("***premuto pulsante***");

  Serial.println("Measuring temperature...");
  temperature = 0;
  for (int i = 0; i < 10; i++) {
    temperature += mlx.readObjectTempC();
    delayMicroseconds(100000);
  }
  temperature /= 10;
  Serial.print("Object temperature = ");
  Serial.print(temperature);
  Serial.println("*C");
  Serial.println();

  temperatureSample = new sample("temperature");
  temperatureSample->startDate = Edge->Api->getActualDate();
  temperatureSample->endDate = temperatureSample->startDate;
  temperatureSample->value = (temperature);
  samples.push_back(temperatureSample);
  if (temperature >= 37) {
    setLed(255, 0, 0);
    vibrate(500, 500, 2);
    delayMicroseconds(1500000);
  }
  else setLed(0, 255, 0);

}

void vibrate(int duration, int interval, int times) {
  for (int i = 0; i < times; i++) {
    digitalWrite(vibrationPin, HIGH);
    delayMicroseconds(duration*1000);
    digitalWrite(vibrationPin, LOW);
    delayMicroseconds(interval*1000);
  }
}

void setLed(int red, int green, int blue)
{
  analogWrite(redLedPin, red);
  analogWrite(greenLedPin, green);
  analogWrite(blueLedPin, blue);
  delayMicroseconds(1000000);
  analogWrite(redLedPin, 0);
  analogWrite(greenLedPin, 0);
  analogWrite(blueLedPin, 0);
}
