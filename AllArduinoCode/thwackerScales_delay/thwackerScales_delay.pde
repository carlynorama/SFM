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
byte debugFlag = 1;

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
int minThwackDelay = 750;
int pulseLength = 100;//100;

// when the pin that needs to be looked at to see if
// should play preprogrammed sequence or respond to sensors
const byte manualModePin = 12;
byte manualModeFlag = 1;  // 1 is off, 0 is on


//holders for infromation you're going to pass to thwaking function
const int lengthOfSequence = 9;
byte sequenceArrayONE[lengthOfSequence];

void setup() {
  //set pins to output because they are addressed in the main loop
  for (byte i = 0; i <= numberOfThwakers; i ++) {
    pinMode(thwackPinArray[i], OUTPUT);
  }

  pinMode(manualModePin, OUTPUT);
  digitalWrite(manualModePin, HIGH); // look for low


  Serial.begin(9600);

  sequenceArrayONE[0] = B00000001; 
  sequenceArrayONE[1] = B00000010; 
  sequenceArrayONE[2] = B00000100; 
  sequenceArrayONE[3] = B00001000;   
  sequenceArrayONE[4] = B00010000; 
  sequenceArrayONE[5] = B00100000; 
  sequenceArrayONE[6] = B01000000; 
  sequenceArrayONE[7] = B10000000; 
  sequenceArrayONE[8] = B00000000; 
}

void loop() {

  manualModeFlag = digitalRead(manualModePin);  // pressed is LOW, so 0 is ON

//  if (manualModeFlag == 0) {
    playSequence(sequenceArrayONE);
//  } 
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

