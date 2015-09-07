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
int const humanDebugDelay = 1000;

long baudRate = 115200;

//how many sensors do you have hooked up? In this case 16 OR LESS (1 multiplexer in use)
const int numberOfSensors = 8;
  
//Array storting all the raw sensor data  
int sensorRawArray[numberOfSensors];

//---- NOT doing Compression or Inch Calculations in this code.
//Array storing inch data 
//int inchesArray[numberOfSensors];

//Array sroting compressed data if needed
//byte sensorCompressedArray[numberOfSensors];

//information used in compression and inch caluculations
//const int myVCC = 5000; // mVolts
//const int resolutionSensor = myVCC/512; //(mV/inch)
//const int resolutionADC = myVCC/1024;
//const int environmentMAX = 1024;
//const int environmentMIN = 0;
//const byte sendRangeMAX = 255;
//const byte sendRangeMIN = 10;

//values for start byte and end byte in data analysis
const byte startByte = 0;
const byte endByte = 255;

// the address pins will go in order from the first one:
#define firstAddressPin 8

int muxPin = 0;

void setup() {

  Serial.begin(baudRate);
  
  //set digital pins 2-7 to outputs for the rail
  DDRD = DDRD | B11111100;
  // set the output pins: (the start pin as determined up top plus 3 more)
  for (int pinNumber = firstAddressPin; pinNumber < firstAddressPin + 4; pinNumber++) {
    pinMode(pinNumber, OUTPUT);
  }
}

void loop() {
 
    pulseSensorEnable();  
    for (byte i = 0; i < numberOfSensors; i ++) {
          updateSensorXData(i);
    }
    
     if (debugFlag) {
     sendAllSensorDataHuman();
     // sendAllInches();
     delay(humanDebugDelay);
 } else {
     sendAllSensorData();
 }
    
 // }
  // print a carriage return at the end of each read of the mux:
  Serial.println();   
}

void setMuxChannel(int whichChannel) {
  //yes, this is slower than setting the port values, but it is reproducable
  //across multiple chip sets. 
  for (int bitPosition = 0; bitPosition < 4; bitPosition++) {
    // shift value x bits to the right, and mask all but bit 0:
    int bitValue = (whichChannel >> bitPosition) & 1;
    // set the address pins
    int pinNumber = firstAddressPin + bitPosition;
    digitalWrite(pinNumber, bitValue);
  }
}

void updateSensorXData(byte myNumber) {
  
   setMuxChannel(myNumber);

   // read the analog input and store it in the value array: 
  int mySensorValue = analogRead(muxPin);             
  sensorRawArray[myNumber] = mySensorValue;
  
  
  //---- NOT doing Compression. NOT doing send as you go. 
  // map it to the range of the analog out: 
  //byte myRangedValue = map(mySensorValue, environmentMIN, environmentMAX, sendRangeMIN, sendRangeMAX);
  //sensorCompressedArray[myNumber] = myRangedValue;

  //calibrate it for inches
  //int myInches = mySensorValue * resolutionADC / resolutionSensor;
  //inchesArray[myNumber] = myInches;

  //for when send as you go is appropriate
  //sendSensorValueHuman(myNumber, mySensorValue);
  //sendSensorValue(myNumber);

}


void sendAllSensorData() {
  for (byte i=0; i < numberOfSensors; i++) {
    sendSensorValue(i);
  }
}

void sendAllSensorDataHuman() {
  for (byte i=0; i < numberOfSensors; i++) {
    sendSensorValueHuman(i);
  }
}

//No compression in this code.
//void sendAllInches() {
//  for (byte i=0; i < numberOfSensors; i++) {
//    Serial.print("sensor no. " );                       
//    Serial.print(i, DEC);      
//    Serial.print("\t inches = ");      
//    Serial.println(inchesArray[i], DEC);  
//  }
//}

void sendSensorValueHuman(byte myNumber) {
  int myValue = sensorRawArray[myNumber];
  // print the results to the serial monitor:
  sendSensorValueHuman(myNumber, myValue);
}  


void sendSensorValueHuman(byte myNumber, int myValue) {
  // print the results to the serial monitor:
  Serial.print("Start Byte " ); 
  Serial.print("\t Sensor Number = ");     
  Serial.print(myNumber, DEC);      
  Serial.print("\t Sensor Value = ");  
  Serial.print("highByte: 0x");
  Serial.print(highByte(myValue), HEX);
  Serial.print(", lowByte: 0x");
  Serial.print(lowByte(myValue), HEX);  
  Serial.print(", Decimal: ");
  Serial.print(myValue, DEC);    
  Serial.println("\t End Byte " );   
}  


void sendSensorValue(byte myNumber, int myValue) {
  // print the results to the serial monitor:
  Serial.print(startByte);     
  Serial.print(myNumber);      
  Serial.print(highByte(myValue));
  Serial.print(lowByte(myValue));    
  Serial.print(endByte);   
}  


void sendSensorValue(byte myNumber) {
  int myValue = sensorRawArray[myNumber];
  // print the results to the serial monitor:
  sendSensorValue(myNumber, myValue);
}  

void pulseSensorEnable() {
  //enable by setting entire register high for 20 us
  PORTD = PORTD | B11111100; // sets digital pins 2-7 high
  delayMicroseconds(20);
  PORTD = PORTD & B00000011; // sets digital pins 2-7 low
}
