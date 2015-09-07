/*
  Analog input, analog output, serial output
 
 scaled for the MaxSonar EZ1 as testing protocol for the VIMBY/Scion Challenge
 
 by Carlyn Maw August 2010
 based on code 2009 code by Tom Igoe
 
 */

// These constants won't change.  They're used to give names
// to the pins used:

const int numberOfSensors = 2;

byte sensorPinArray[numberOfSensors] = { 
  0,1 } 
;
byte sensorEnablePinArray[numberOfSensors] = {
  2, 3};
int sensorRawArray[numberOfSensors];
int inchesArray[numberOfSensors];
byte sensorSendArray[numberOfSensors];

const int analogInPin = 0;
const int analogOutPin = 9; // Analog output pin that the LED is attached to

const int VCC = 5000; // mVolts
const int resolutionSensor = VCC/512; //(mV/inch)
const int resolutionADC = VCC/1024;

int myInches = 0;
const int environmentMAX = 1024;
const int environmentMIN = 0;
const byte sendRangeMAX = 255;
const byte sendRangeMIN = 10;


void setup() {
  DDRD = DDRD | B11111100;
  // initialize serial communications at 9600 bps:
  Serial.begin(9600); 
}

void loop() {

  //enable
  PORTD = PORTD | B11111100; // sets digital pins 2-7 high
  delayMicroseconds(20);
  PORTD = PORTD & B00000011; // sets digital pins 2-7 high
  //delayMicroseconds(500);
  for (byte i=0; i < numberOfSensors; i++) {
    updateSensorXData(i);     
  }

  // sendAllSensorData();
 // sendAllInches();

  delay(500);
}

void updateSensorXData(byte myNumber) {

  int mySensorValue = analogRead(sensorPinArray[myNumber]);             
  sensorRawArray[myNumber] = mySensorValue;
  // map it to the range of the analog out: 
  byte myRangedValue = map(mySensorValue, environmentMIN, environmentMAX, sendRangeMIN, sendRangeMAX);
  sensorSendArray[myNumber] = myRangedValue;

  sendSensorValue(myNumber, myRangedValue);

  //calibrate it for inches
  myInches = mySensorValue * resolutionADC / resolutionSensor;
  inchesArray[myNumber] = myInches;


}

void sendSensorValueHuman(byte myNumber, byte myValue) {
  // print the results to the serial monitor:
  Serial.print("sensor no. " );                       
  Serial.print(myNumber, DEC);      
  Serial.print("\t sensorvalue = ");      
  Serial.println(myValue, DEC);    
}  

void sendSensorValueHuman(byte myNumber) {

  byte myValue = sensorSendArray[myNumber];
  // print the results to the serial monitor:
  Serial.print("sensor no. " );                       
  Serial.print(myNumber, DEC);      
  Serial.print("\t sensorvalue = ");      
  Serial.println(myValue, DEC);   
}  

void sendAllSensorData() {
  for (byte i=0; i < numberOfSensors; i++) {
    Serial.print("sensor no. " );                       
    Serial.print(i, DEC);      
    Serial.print("\t sensorvalue = ");      
    Serial.println(sensorSendArray[i], DEC);  

  }
}

void sendAllInches() {
  for (byte i=0; i < numberOfSensors; i++) {
    Serial.print("sensor no. " );                       
    Serial.print(i, DEC);      
    Serial.print("\t inches = ");      
    Serial.println(inchesArray[i], DEC);  

  }

  void sendSensorValue(byte myNumber, int myValue) {
    // print the results to the serial monitor:
    Serial.print("Start Byte " ); 
    Serial.print("\t Sensor Number = ");     
    Serial.print(myNumber, DEC);      
    Serial.print("\t sensorvalue = ");  
    Serial.print(". HighByte: 0x");
    Serial.print(highByte(myValue), HEX);
    Serial.print(", lowByte: 0x");
    Serial.print(lowByte(myValue), HEX);  
    Serial.println(myValue, DEC);    
    Serial.print("End Byte " );   
  }  
}

void sendSensorValue(byte myNumber) {

  byte myValue = sensorSendArray[myNumber];
  // print the results to the serial monitor:
  Serial.print("sensor no. " );                       
  Serial.print(myNumber, DEC);      
  Serial.print("\t sensorvalue = ");      
  Serial.println(myValue, DEC);   
}  




