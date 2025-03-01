#include <WiFi.h>
#include <Arduino.h>
#include <PubSubClient.h>

#ifndef DELAY_TIME_MS
#define DELAY_TIME_MS 50
#endif

// WiFi settings
const char* ssid = "GreenGuppy";
const char* password = "lebron123";

// MQTT Broker
const int mqtt_port = 1883;
const char* computer_ip = "172.20.10.10";

WiFiClient espClient;
PubSubClient mqtt_client(espClient);

long now;

void setup() {
    Serial.begin(115200);

    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(2000);
        Serial.println("Retyring connection to WiFi");
    }

    Serial.println("connected");

    mqtt_client.setServer(computer_ip, 1883);
    
    while (!mqtt_client.connected()) {
        mqtt_client.connect("esp32");

        delay(1000);
        Serial.println("Cannot connect to client");
    }

    delay(1000);

    Serial.println("connected!");

    const char* topic = "hello";

    mqtt_client.publish(topic, "HELLO FROM ESP32");

    Serial.println("Sent message");

    now = millis();
}

void loop() {
    long curr = millis();

    if (curr - now > DELAY_TIME_MS) {
        String to_print = "Asensorvals pt0=482.60169,pt1=586.3529,pt2=-4.77855,pt3=-61.87105,pt4=1.03304,pt5=339.3728,pt6=34.07698,pt7=98.41807,pt8=3557.51375,pt9=13.36228,lc1=165.83Z";

        mqtt_client.publish("hello", to_print.c_str());
        now = curr;
    }
}