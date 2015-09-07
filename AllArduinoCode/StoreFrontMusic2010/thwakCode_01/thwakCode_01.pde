//**************************************************************//
//  Name    : thwaktCode,   two meoldies                        //
//  Author  : Carlyn Maw                                        //
//  Date    : 25 Oct, 2006                                      //
//  Version : 1.0                                               //
//  Notes   : Code for using a 74HC595 Shift Register           //
//          : to count from 0 to 255                            //
//****************************************************************


//WAIT! START HERE! Are you in debug mode?
byte debugFlag = 0;

long baudRate = 115200;

const int numberOfThwakers = 8;

byte thwackPinArray[numberOfThwakers] = { 
  2,3,4,5,6,7,8,9 } 
;

const int lengthOfSequence = 10;

//holders for infromation you're going to pass to shifting function
byte dataONE;
byte dataTWO;
byte sequenceArrayONE[lengthOfSequence];
byte sequenceArrayTWO[lengthOfSequence];

int thwakTimeMin = 1000;
int pulseLength = 100;

void setup() {
  //set pins to output because they are addressed in the main loop
  for (byte i = 0; i <= numberOfThwakers; i ++) {
    pinMode(thwackPinArray[i], OUTPUT);
  }
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


  for (int j = 0; j < lengthOfSequence; j++) {
    dataONE = sequenceArrayONE[j];
    thwakOut(dataONE);   
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
}




