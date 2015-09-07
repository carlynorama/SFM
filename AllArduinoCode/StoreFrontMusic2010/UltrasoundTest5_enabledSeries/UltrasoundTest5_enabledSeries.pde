/*
  Analog input, analog output, serial output
 
 scaled for the MaxSonar EZ1 as testing protocol for the VIMBY/Scion Challenge
 
 by Carlyn Maw August 2010
 based on code 2009 code by Tom Igoe
 
 */

// These constants won't change.  They're used to give names
// to the pins used:

const int numberOfSensors = 2;

byte sensorPinArray[numberOfSensors] = { 0,1 } ;
byte sensorEnablePinArray[numberOfSensors] = {2, 3};
int sensorRawArray[numberOfSensors];
byte sensorSendArray[numberOfSensors];

const int analogInPin = 0;
const int analogOutPin = 9; // Analog output pin that the LED is attached to

const int VCC = 5000; // mVolts
const int resolutionSensor = VCC/512; //(mV/inch)
const int resolutionADC = VCC/1024;

int myInches = 0;
const int environmentMAX = 550;
const int environmentMIN = 0;
const byte sendRangeMAX = 255;
const byte sendRangeMIN = 10;

int sensorValue = 0;        // value read from the pot
int outputValue = 0;        // value output to the PWM (analog out)

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600); 
}

void loop() {

for (byte i=0; i < numberOfSensors; i++) {
  digitalWrite(sensorEnablePinArray[i], HIGH);
  delayMicroseconds(20);
  digitalWrite(sensorEnablePinArray[i], LOW);
  updateSensorXData(i);    
  sendSensorValue(i); 
  delayMicroseconds(20);  
}

}

void updateSensorXData(byte myNumber) {

  int mySensorValue = analogRead(sensorPinArray[myNumber]);             
  sensorRawArray[myNumber] = mySensorValue;
  // map it to the range of the analog out: 
  byte myRangedValue = map(mySensorValue, environmentMIN, environmentMAX, sendRangeMIN, sendRangeMAX);
  sensorSendArray[myNumber] = myRangedValue;
  
  //sendSensorValue(myNumber, myRangedValue);
  
  //calibrate it for inches
  //myInches = sensorValue * resolutionADC / resolutionSensor;
 
}

void sendSensorValue(byte myNumber, byte myValue) {
  // print the results to the serial monitor:
  Serial.print("sensor no. " );                       
  Serial.print(myNumber, DEC);      
  Serial.print("\t sensorvalue = ");      
  Serial.println(myValue, DEC);    
}  

void sendSensorValue(byte myNumber) {
  
  byte myValue = sensorSendArray[myNumber];
  // print the results to the serial monitor:
  Serial.print("sensor no. " );                       
  Serial.print(myNumber, DEC);      
  Serial.print("\t sensorvalue = ");      
  Serial.println(myValue, DEC);   
}  


