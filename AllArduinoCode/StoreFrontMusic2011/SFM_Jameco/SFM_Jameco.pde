//**************************************************************//
//  Name    : thwaktCode                                        //
//  Author  : Carlyn Maw                                        //
//  Date    : 26 AUG, 2010                                      //
//  Version : 1.0                                               //
//  Notes   : Code for thwaking objects via solenoid            //
//          : based on serial in data or via a manual mode      //
//          : which loops a single array over and over again    //
//****************************************************************


//WAIT! START HERE! Are you in debug mode?
byte debugFlag = 0;

// best rate for the max patch
//long baudRate = 115200;

//number of thwakers
const int numberOfThwakers = 8;

//what pins the thwakers are attached to
byte thwackPinArray[numberOfThwakers] = { 
  2,3,4,5,6, 7, 8,9 } 
;

byte thwakStateArray[numberOfThwakers] = {
    0,0,0,0,0, 0,0,0}
;

// if we need to not allow the sequence to go too fast. 
// for these solenoids the duty cycle is 10%
int minThwackDelay = 1000;
int pulseLength = 600;//100;

// when the pin that needs to be looked at to see if
// should play preprogrammed sequence or respond to sensors
const byte manualModePin = 12;
byte manualModeFlag = 1;  // 1 is off, 0 is on


//holders for infromation you're going to pass to thwaking function
const int lengthOfSequence = 10;
byte sequenceArrayONE[lengthOfSequence];

void setup() {
  //set pins to output because they are addressed in the main loop
  for (byte i = 0; i <= numberOfThwakers; i ++) {
    pinMode(thwackPinArray[i], OUTPUT);
  }

  pinMode(manualModePin, OUTPUT);
  digitalWrite(manualModePin, HIGH); // look for low


 // Serial.begin(baudRate);

  sequenceArrayONE[0] = B10000001; 
  sequenceArrayONE[1] = B01000010; 
  sequenceArrayONE[2] = B00100100; 
  sequenceArrayONE[3] = B00011000; 
  sequenceArrayONE[4] = B00011000; 
  sequenceArrayONE[5] = B00000000; 
  sequenceArrayONE[6] = B00011000; 
  sequenceArrayONE[7] = B00011000; 
  sequenceArrayONE[8] = B00100100; 
  sequenceArrayONE[9] = B01000010; 
  sequenceArrayONE[10] = B10000001; 
}

void loop() {

  manualModeFlag = digitalRead(manualModePin);  // pressed is LOW, so 0 is ON

  if (manualModeFlag == 0) {
    playSequence(sequenceArrayONE);
  } 
//  else if (Serial.available() > 0) {
//    // get incoming byte:
//    byte inByte = Serial.read();
//    thwakOut(inByte);
//    delay(minThwackDelay);
//  } 
}




void thwakOut(byte myDataOut) {

  int pinState;

  for (int t=7; t>=0; t--)  {

    if ( myDataOut & (1<<t) ) {
      pinState= 1;
    }
    else {	
      pinState= 0;
    }
    digitalWrite(thwackPinArray[t], pinState);
  }

  delay(pulseLength);

  for (int t=7; t>=0; t--)  {
    digitalWrite(thwackPinArray[t], 0);

  }
  if (debugFlag) {
    Serial.println(myDataOut, DEC);
  }
}



void playSequence(byte * mySequenceArray) {
  for (int j = 0; j < lengthOfSequence; j++) {
    byte currentByte = mySequenceArray[j];
    thwakOut(currentByte);   
    delay(minThwackDelay);
  }
}

