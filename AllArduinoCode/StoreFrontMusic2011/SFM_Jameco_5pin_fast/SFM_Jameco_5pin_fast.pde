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
int minThwackDelay = 750;
int pulseLength = 100;//100;

// when the pin that needs to be looked at to see if
// should play preprogrammed sequence or respond to sensors
const byte manualModePin = 12;
byte manualModeFlag = 1;  // 1 is off, 0 is on


//holders for infromation you're going to pass to thwaking function
const int lengthOfSequence = 12;
byte scaleArray[lengthOfSequence];

void setup() {
  //set pins to output because they are addressed in the main loop
  for (byte i = 0; i <= numberOfThwakers; i ++) {
    pinMode(thwackPinArray[i], OUTPUT);
  }

  pinMode(manualModePin, OUTPUT);
  digitalWrite(manualModePin, HIGH); // look for low


  //Serial.begin(9600);

 scaleArray[0] = B00000001; 
 scaleArray[1] = B00000010; 
 scaleArray[2] = B00000100; 
 scaleArray[3] = B00001000;   
 scaleArray[4] = B00010000; 
 scaleArray[5] = B00000000; 
 scaleArray[6] = B00010000; 
 scaleArray[7] = B00001000; 
 scaleArray[8] = B00000100; 
 scaleArray[9] = B00000010;
 scaleArray[10] = B00000001;
 scaleArray[11] = B00000000;  
 
 tuneArray[0] = B00010101; 
 tuneArray[1] = B00001010; 
 tuneArray[2] = B00000100; 
 tuneArray[3] = B00001000;   
 tuneArray[4] = B00010000; 
 tuneArray[5] = B00000101; 
 tuneArray[6] = B00010000; 
 tuneArray[7] = B00001010; 
 tuneArray[8] = B00000100; 
 tuneArray[9] = B00000010;
 tuneArray[10] = B00000101;
 tuneArray[11] = B00000000;  
}




void loop() {

  manualModeFlag = digitalRead(manualModePin);  // pressed is LOW, so 0 is ON

  if (manualModeFlag == 0) {
    playSequence(scaleArray);
  } 
  else {
    playSequence(tuneArray)
  } 
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

