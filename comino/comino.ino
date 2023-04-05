#include <Preferences.h>

#include "WiFi.h"
#include "ESPAsyncWebServer.h"
#include <SPI.h>,
AsyncWebServer server(80);

Preferences preferences;

const char* PARAM_INPUT_1 = "cmd";
const char* PARAM_INPUT_2 = "rtmp";
int relais1 = 27;
int relais2 = 14;
String inputMessage = "null";
// definitions of your desired intranet created by the ESP32
IPAddress PageIP(192, 168, 20, 124);
IPAddress gateway(192, 168, 20, 198);
IPAddress subnet(255, 255, 255, 0);
IPAddress ip;
int Y1 = 0;
int Y2 = 0;

void setup() {
Serial.begin(115200);
preferences.begin("variable", false);
Y1 = preferences.getInt("Y1",25);
Y2 = preferences.getInt("Y2",30);
Serial.println("ESP serial initialize");
delay(1000);
pinMode(relais1,OUTPUT); pinMode(relais2,OUTPUT);

WiFi.begin("FideleS","@shley3107");
delay(100);
WiFi.config(PageIP, gateway, subnet); 
delay(100);

while(WiFi.status() != WL_CONNECTED){
  delay(1000);
  Serial.println("Connexion en cours...");
}
Serial.println(WiFi.localIP());

server.on("/", HTTP_GET, [] (AsyncWebServerRequest *request) {

if (request->hasParam(PARAM_INPUT_1)) {
inputMessage = request->getParam(PARAM_INPUT_1)->value();}
Serial.println( inputMessage );
if(inputMessage == "a"){
  request->send(200,"text/plain","OK");
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
}
