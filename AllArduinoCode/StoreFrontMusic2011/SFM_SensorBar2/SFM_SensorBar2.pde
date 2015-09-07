/*

 
 */
//-----------------------------------CHANGE ME DEPENDING ON YOUR SET UP!
boolean cleanIt = 0; // if true will constrain to a typical Max and Min
//and then map the values back out to 0 to 1023

const int numberOfSensors = 4;

int baudRate = 9600;

const int killSwitch = 12;

int sensorPins[numberOfSensors] =  {
  0,1,2,3};

int sensorValues[numberOfSensors] =  {
  0,0,0,0};
byte sendValues[numberOfSensors] = {
  0,0,0,0};

//Min = 0.2 min / 5 V range * 1023 or 41
//Max  = (3V max / 5V range *1023) or 614

int sensorMins[numberOfSensors] = {
  0,0,0,0}; //set cleanIt to 0 and set up
//the lowest reading scenario

int sensorMaxs[numberOfSensors] = {
  614,614,614,614}; //set cleanIt to 0 and set
//a highest reading scenario
//all 4 use the same threshold one for now
//min value
//
int sensorThresholds[3] = {
  100, 200, 400};

//expected range by recieving software, used by cleanIt
int expectedMin = 0;
int expectedMax = 1023; //(3V max / 5V range *1023)

//------------------------------------------------------END OF CHANGE ME. 

//------------------------------------------------------START SETUP
void setup() {
  // configure the serial connection:
  Serial.begin(baudRate);  // is matched in processing

  pinMode(killSwitch, INPUT);
  digitalWrite(killSwitch, HIGH);  

}

//------------------------------------------------------START LOOP
void loop() {
  // read the sensor:
  //if  (digitalRead(killSwitch)) {
    for (int s = 0;  s < numberOfSensors ; s ++) {
      if (cleanIt) {
        sensorValues[s] = constrain(analogRead(sensorPins[s]), sensorMins[s], sensorMaxs[s]);
        sensorValues[s] = map(sensorValues[s], sensorMins[s], sensorMaxs[s], expectedMin, expectedMax);
      } 
      else {
        sensorValues[s] = analogRead(sensorPins[s]);
      }
      setSensorBits(s,sendValues);
    }
    //serialWriteDebugAnalog();
    //serialWriteDebugSendVals();
    //Serial.println();  
    //serialWriteValues(1);
   // Serial.write(255);
    //serialWriteValues(0);
    Serial.println();
    //Serial.println();
    
      byte sendMe;
  for (int s = 0;  s < numberOfSensors ; s ++) {
    sendMe  = sendMe | sendValues[s];
  }

  //Serial.print(sendMe);
  Serial.write(sendMe);
    
    
    
 // }
}
//------------------------------------------------------END LOOP


//------------------------------------------------------setSensorBits
void setSensorBits(int mySensorNum, byte * valueArray) {
  byte bitsValue;
  int s = mySensorNum;


  if ((sensorValues[s] < sensorThresholds[0])) {
    bitsValue = 0;
  } 
  else if ((sensorValues[s] >= sensorThresholds[0]) && (sensorValues[s] < sensorThresholds[1])) {
    bitsValue = 1;
  } 
  else if ((sensorValues[s] >= sensorThresholds[1]) && (sensorValues[s] < sensorThresholds[2])) {
    bitsValue = 2;
  } 
  else if (sensorValues[s] >= sensorThresholds[2]) {
    bitsValue = 3;
  }  

  byte shiftNum = s * 2;
  byte shiftedVal = bitsValue << shiftNum;

  valueArray[s] = shiftedVal;

}

//------------------------------------------------------serialWriteValues
void serialWriteValues(byte mode) {
  switch (mode) {
  case 0:
    sendValsAsByte();
  case 1:
    sendVals();
  }
}



void  sendVals() {
  for (int s = 0;  s < numberOfSensors ; s ++) {
    Serial.print(sendValues[s]);
  }
}

void sendValsAsByte() {
  byte sendMe;
  for (int s = 0;  s < numberOfSensors ; s ++) {
    sendMe  = sendMe | sendValues[s];
  }

  //Serial.print(sendMe);
  Serial.write(sendMe);
}


//------------------------------------------------------ debugs
void serialWriteDebugAnalog() {
  // print the results:
  char endByte = '\n'; 
  char delimByte = ',';
  for (int s = 0;  s < numberOfSensors ; s ++) {

    if (s == (numberOfSensors-1)) {
      Serial.print(sensorValues[s], DEC);
      Serial.print(endByte);
    } 
    else {
      Serial.print(sensorValues[s], DEC);
      Serial.print(delimByte); 
    }
  }

}


void serialWriteDebugSendVals(){
  char endByte = '\n'; 
  char delimByte = ',';
  for (int s = 0;  s < numberOfSensors ; s ++) {
    if (s == (numberOfSensors-1)) {
      Serial.print(sendValues[s], BIN);
      Serial.print(endByte);
    } 
    else {
      Serial.print(sendValues[s], BIN);
      Serial.print(delimByte); 
    }
  }
}


