/*

 MaxSonar EZ1 array pass through code for the VIMBY/Scion Challenge
 for use with up to 6 sensors this code sets 6 enable pins high by addressing PORTD
 Individual sensors are not addressable

 The data it spits out is
     startByte
     sensorNum
     msb of sensor raw value
     lsb of sensor raw value
     endByte

  debug flag toggles this between human readable (true) and max/MSP patch readable (false)
 
 by Carlyn Maw August 2010
 
 */

//WAIT! START HERE! Are you in debug mode?
byte debugFlag = 1;

const long baudRate = 115200;

//how many sensors do you have hooked up
const int numberOfSensors = 2;

//what pins are you hooked up to, can tweek what order things
//get read by tweaking the order here
byte sensorPinArray[numberOfSensors] = {
  0,1 } ;
 
//below not used in this version because I'm just very sloppily
//setting the whole darn lower regeister high
byte sensorEnablePinArray[numberOfSensors] = {
  2, 3};
 
//Array storting all the raw data 
int sensorRawArray[numberOfSensors];

//Array storing inch data
int inchesArray[numberOfSensors];

//Array sroting compressed data if needed
byte sensorCompressedArray[numberOfSensors];

//information used in compression and inch caluculations
const int myVCC = 5000; // mVolts
const int resolutionSensor = myVCC/512; //(mV/inch)
const int resolutionADC = myVCC/1024;
const int environmentMAX = 1024;
const int environmentMIN = 0;
const byte compressedRangeMAX = 255; //
const byte compressedRangeMIN = 10;

//values for start byte and end byte in data analysis
const byte startByte = 0;
const byte endByte = 255;


void setup() {
  //set digital pins 2-7 to outputs
  DDRD = DDRD | B11111100;
  // initialize serial communications at 9600 bps:
  Serial.begin(baudRate);
}

void loop() {

  //enable by setting entire register high for 20 us
  PORTD = PORTD | B11111100; // sets digital pins 2-7 high
  delayMicroseconds(20);
  PORTD = PORTD & B00000011; // sets digital pins 2-7 low
 
  for (byte i=0; i < numberOfSensors; i++) {
    updateSensorXData(i);    
  }

 if (debugFlag) {
     sendAllSensorDataHuman();
     // sendAllInches();
     delay(500);
 } else {
     sendAllSensorData();
 }



}

void updateSensorXData(byte myNumber) {

  int mySensorValue = analogRead(sensorPinArray[myNumber]);            
  sensorRawArray[myNumber] = mySensorValue;
 
  // map it to the range of the analog out:
  byte myRangedValue = map(mySensorValue, environmentMIN, environmentMAX, compressedRangeMIN, compressedRangeMAX);
  sensorCompressedArray[myNumber] = myRangedValue;

  //calibrate it for inches
  int myInches = mySensorValue * resolutionADC / resolutionSensor;
  inchesArray[myNumber] = myInches;

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

void sendAllInches() {
  for (byte i=0; i < numberOfSensors; i++) {
    Serial.print("sensor no. " );                      
    Serial.print(i, DEC);     
    Serial.print("\t inches = ");     
    Serial.println(inchesArray[i], DEC); 
  }
}

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

