#include <DHT.h>
#include <DHT_U.h>

#include <Preferences.h>

#include "WiFi.h"
#include "ESPAsyncWebServer.h"
#include <SPI.h>,
AsyncWebServer server(80);

Preferences preferences;

#define DHTPIN 15
#define DHTTYPE DHT11

const char* PARAM_INPUT_1 = "cmd";
const char* PARAM_INPUT_2 = "rtmp";
int relais1 = 27;
String inputMessage = "null";
float h = 0.00;
float t = 0.00;
float hic = 0.00;
// definitions of your desired intranet created by the ESP32
IPAddress PageIP(192, 168, 20, 124);
IPAddress gateway(192, 168, 20, 198);
IPAddress subnet(255, 255, 255, 0);
IPAddress ip;
int Y1 = 0;
int Y2 = 0;
int C1 = 20;
int C2 = 50;

DHT dht(DHTPIN, DHTTYPE);

void setup() {
dht.begin();
Serial.begin(115200);
preferences.begin("variable", false);
Y1 = preferences.getInt("Y1",25);
Y2 = preferences.getInt("Y2",30);
Serial.println("ESP serial initialize");
delay(1000);
pinMode(relais1,OUTPUT);

WiFi.softAP("esp32wifi","11111111"); delay(100); 
WiFi.softAPConfig(PageIP, gateway, subnet); delay(100); 
IPAddress apip = WiFi.softAPIP(); Serial.println(apip);
/*
WiFi.begin("FideleS","@shley3107");
delay(100);
WiFi.config(PageIP, gateway, subnet); 
delay(100);

while(WiFi.status() != WL_CONNECTED){
  delay(1000);
  Serial.println("Connexion en cours...");
}
Serial.println(WiFi.localIP());
*/
server.on("/", HTTP_GET, [] (AsyncWebServerRequest *request) {

if (request->hasParam(PARAM_INPUT_1)) {
inputMessage = request->getParam(PARAM_INPUT_1)->value();}
Serial.println( inputMessage );
if(inputMessage == "a"){
  request->send(200,"text/plain","OK");
}else if(inputMessage == "get"){
  // Reading temperature or humidity takes about 250 milliseconds!
  // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
   h = dht.readHumidity();
  // Read temperature as Celsius (the default)
   t = dht.readTemperature();

  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t)) {
    request->send(200,"text/plain","err");
    return;
  }

  if ((t >= Y2+5) || (Y1-2 >= t)) {
    request->send(200,"text/plain","error");
    return;
  }

  // Compute heat index in Celsius (isFahreheit = false)
   hic = dht.computeHeatIndex(t, h, false);
  delay(3000);
  String jul = String(t)+":"+String(h)+"!"+String(hic);
  request->send(200,"text/plain",jul);
}else{
  
}
}); 



server.on("/d", HTTP_GET, [] (AsyncWebServerRequest *request) {
  String msg;
if (request->hasParam(PARAM_INPUT_2)) {msg = request->getParam(PARAM_INPUT_2)->value();}
Serial.println( inputMessage );
if(inputMessage.length() != 0){
  request->send(200,"text/plain","OK");

  int a = msg.indexOf(":");
  String T1 = msg.substring(0,a);
  Y1 = T1.toInt();
  String T2 = msg.substring(a+1);
  Y2 = T2.toInt();
  preferences.putInt("Y1", Y1);
  preferences.putInt("Y2", Y2);
  Serial.println(Y1);
  Serial.println(Y2);
}
}); 
server.begin();
}

void loop() {
   h = dht.readHumidity();
   t = dht.readTemperature();
  if (isnan(h) || isnan(t)) {
    return;
  }
   hic = dht.computeHeatIndex(t, h, false);
  delay(3000);
  if (t > Y2){
    digitalWrite(relais1, LOW);
  }else if (Y1 > t){
    digitalWrite(relais1, HIGH);
  }
}
