// This #include statement was automatically added by the Particle IDE.
#include <simple-OSC.h>

const int SOFT_POT_PIN = A0; // Pin connected to softpot wiper
String softPotMessage = "0";

// OSC set up
UDP udp;
IPAddress outIp(10,196,21,64);
unsigned int outPort = 1234; //computer incoming port
unsigned int inPort = 8001;

void setup() 
{
    udp.begin(inPort);//necessary even for sending only.
    Serial.println("");
    Serial.println("WiFi connected");
    IPAddress ip = WiFi.localIP();
    pinMode(SOFT_POT_PIN, INPUT);
}

void loop() 
{
    // Read in the soft pot's ADC value
    int softPotADC = analogRead(SOFT_POT_PIN);
    // Put the soft pot's ADC value into the message string
    softPotMessage = softPotADC;
    // create the OSC message
    OSCMessage outMessage("/photon");
    // add the OSC message
    outMessage.addString(softPotMessage);
    // finish the OSC message
    outMessage.send(udp,outIp,outPort);

}