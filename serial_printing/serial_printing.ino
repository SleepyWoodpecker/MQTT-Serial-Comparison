#include <Arduino.h>

#ifndef DELAY_TIME_MS
#define DELAY_TIME_MS 50
#endif

long curr;

void setup() {
    Serial.begin(115200);
    delay(1000);
    curr = millis();

    Serial.print("Configured delay is ");
    Serial.println(DELAY_TIME_MS);
}

void loop() {
    long now = millis();
    if (now - curr > DELAY_TIME_MS) {
        String to_print = "Asensorvals pt0=482.60169,pt1=586.3529,pt2=-4.77855,pt3=-61.87105,pt4=1.03304,pt5=339.3728,pt6=34.07698,pt7=98.41807,pt8=3557.51375,pt9=13.36228,lc1=165.83Z";

        Serial.println(to_print);
        curr = now;
    }
}