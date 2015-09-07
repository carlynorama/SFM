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
long baudRate = 115200;

//number of thwakers
const int numberOfThwakers = 8;

//what pins the thwakers are attached to
byte thwackPinArray[numberOfThwakers] = { 
  2,3,4,5,6,7,8,9 } 
;

// when the pin that needs to be looked at to see if
// should play preprogrammed sequence or respond to sensors
const byte manualModePin = 12;
byte manualModeFlag = 1;  // 1 is off, 0 is on


//holders for infromation you're going to pass to thwaking function
const int lengthOfSequence = 10;
byte dataONE;
byte sequenceArrayONE[lengthOfSequence];

// if we need to not allow the sequence to go too fast. 
// blocking functions
int thwakTimeMin = 500;
int pulseLength = 10;

void setup() {
  //set pins to output because they are addressed in the main loop
  for (byte i = 0; i <= numberOfThwakers; i ++) {
    pinMode(thwackPinArray[i], OUTPUT);
  }

  pinMode(manualModePin, OUTPUT);
  digitalWrite(manualModePin, HIGH); // look for low


  Serial.begin(baudRate);

  sequenceArrayONE[0] = 0xFF; //11111111
  sequenceArrayONE[1] = 0xFE; //11111110
  sequenceArrayONE[2] = 0xFC; //11111100
  sequenceArrayONE[3] = 0xF8; //11111000
  sequenceArrayONE[4] = 0xF0; //11110000
  sequenceArrayONE[5] = 0xE0; //11100000
  sequenceArrayONE[6] = 0xC0; //11000000
  sequenceArrayONE[7] = 0x80; //10000000
  sequenceArrayONE[8] = 0x00; //00000000
  sequenceArrayONE[9] = 0xE0; //11100000
}

void loop() {

  manualModeFlag = digitalRead(manualModePin);  // pressed is LOW, so 0 is ON

  if (manualModeFlag == 0) {
    playSequence(sequenceArrayONE);
  } 
  else if (Serial.available() > 0) {
    // get incoming byte:
    byte inByte = Serial.read();
    thwakOut(inByte);
    delay(thwakTimeMin);
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
    delay(thwakTimeMin);
  }
}

