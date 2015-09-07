/*

 MaxSonar EZ1 array pass through code for the VIMBY/Scion Challenge
 Multiplexer is the TI "CD74HC4067SM96G4". Base code for Multiplexer taken from 
 2008 Tom Igoe example on the ITP physcomp site. 
 
 In our case we also started at digial pin 8. 
 
   VCC  (pin 24) -> 5V
   GND  (pin 12) -> GND
   S0   (pin 10) -> Arduino D8
   S1   (pin 11) -> Arduino D9
   S2   (pin 14) -> Arduino D8
   S3   (pin 13) -> Arduino D9
   E    (pin 15) -> GND
   OUT  (pin 1)  -> Arduino A0
 
 
 by Carlyn Maw August 2010
 
 */

//WAIT! START HERE! Are you in debug mode?
byte debugFlag = 0;

long baudRate = 9600;

//how many sensors do you have hooked up? In this case 16 OR LESS (1 multiplexer in use)
const int numberOfSensors = 16;

int sensorValue[numberOfSensors];  // an array to store the sensor values

// the address pins will go in order from the first one:
#define firstAddressPin 8

int analogInput = 0;

void setup() {
  Serial.begin(9600);
  // set the output pins: (the start pin as determined up top plus 3 more)
  for (int pinNumber = firstAddressPin; pinNumber < firstAddressPin + 4; pinNumber++) {
    pinMode(pinNumber, OUTPUT);
  }
}

void loop() {
  // iterate once for every multiplexer (called muxes for short):
  //for (int mux = 0; mux < 3; mux++) {
    for (int channelNum = 0; channelNum < numberOfSensors; channelNum ++) {
      // determine the four address pin values from the channelNum:
      setChannel(channelNum);

      // read the analog input and store it in the value array: 
      //sensorValue[channelNum] = analogRead(analogInput+mux);
      sensorValue[channelNum] = analogRead(analogInput);
      delay(10);
      // print the values as a single tab-separated line:
      Serial.print(sensorValue[channelNum], DEC);
      Serial.print(",");
    }
 // }
  // print a carriage return at the end of each read of the mux:
  Serial.println();   
}

void setChannel(int whichChannel) {
  //yes, this is slower than setting the port values, but it is reproducable
  //across multiple chip sets. 
  for (int bitPosition = 0; bitPosition < 4; bitPosition++) {
    // shift value x bits to the right, and mask all but bit 0:
    int bitValue = (whichChannel >> bitPosition) & 1;
    // set the address pins:
    int pinNumber = firstAddressPin + bitPosition;
    digitalWrite(pinNumber, bitValue);
  }
}
