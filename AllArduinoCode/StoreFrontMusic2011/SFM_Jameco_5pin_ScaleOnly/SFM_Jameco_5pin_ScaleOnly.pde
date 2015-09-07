//**************************************************************//
//  Name    : 5 Tone Scales for Clay Pots                       //
//  Author  : Carlyn Maw                                        //
//  Date    : 26 JUN, 2011                                      //
//  Version : 1.0                                               //
//  Notes   : Code for thwaking objects via solenoid            //
//          : This is very simple code for running one of 3     //
//          : patterns of thwacks. It requires the user to      //
//          : remember not to thwack too many solenoids at once //
//          : to not thwack the same one too many times, etc... //
//****************************************************************


//number of thwakers
const int numberOfThwakers = 8;

//what pins the thwakers are attached to?
//keeping those pins in an array at the top
//allows for easy updating later.
byte thwackPinArray[numberOfThwakers] = { 
  2,3,4,5,6,7,8,9 } 
;

// This is the brute force way to ensure the duty cycle is enforced
// pulseLength is the length of time the solenoid is pulsed.
// minThwack delay gets called at the end of the pulseing to ensure that the 
// for these solenoids the duty cycle is 10%
int pulseLength = 100;
int minThwackDelay = 700;


// when the pin that needs to be looked at to see if
// should play preprogrammed sequence or respond to sensors
const byte manualModePin = 12;
byte manualModeFlag = 1;  // 1 is off, 0 is on


//holders for infromation you're going to pass to thwaking function
const int lengthOfSequence = 12;
byte scaleArray[lengthOfSequence];
byte tuneArray[lengthOfSequence];
byte tune2Array[lengthOfSequence];

void setup() {
  //set pins to output because they are addressed in the main loop
  for (byte i = 0; i <= numberOfThwakers; i ++) {
    pinMode(thwackPinArray[i], OUTPUT);
  }

  pinMode(manualModePin, INPUT);
  digitalWrite(manualModePin, HIGH); // look for low
  
  pinMode(11, INPUT);
  digitalWrite(11, HIGH); // look for low


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
 
 tuneArray[0] = B00000001; 
 tuneArray[1] = B00010000; 
 tuneArray[2] = B00000100; 
 tuneArray[3] = B00001000;   
 tuneArray[4] = B00000100; 
 tuneArray[5] = B00001001; 
 tuneArray[6] = B00010000; 
 tuneArray[7] = B00001010; 
 tuneArray[8] = B00010000; 
 tuneArray[9] = B00000010;
 tuneArray[10] = B00001000;
 tuneArray[11] = B00000010;  


 tune2Array[0] = B00000100; 
 tune2Array[1] = B00000010; 
 tune2Array[2] = B00000001; 
 tune2Array[3] = B00000100;   
 tune2Array[4] = B00000010; 
 tune2Array[5] = B00000001; 
 tune2Array[6] = B00010000; 
 tune2Array[7] = B00001000; 
 tune2Array[8] = B00000100; 
 tune2Array[9] = B00001000;
 tune2Array[10] = B00010001;
 tune2Array[11] = B00000010;  
}




void loop() {

  manualModeFlag = digitalRead(manualModePin);  // pressed is LOW, so 0 is ON

  
      delay(2000);       
     playSequence(scaleArray);
     delay(2000);
   playSequence(tune2Array);
   playSequence(tune2Array);
   delay(2000);
    playSequence(tuneArray);
    playSequence(tuneArray);
    delay(2000);
     playSequence(scaleArray);
     playSequence(scaleArray);
           delay(2000); 

//  if (manualModeFlag == 0) {
//    playSequence(tune2Array);
//  } else if (digitalRead(11) == 0) {
//    playSequence(tuneArray);
//  } else {
//     playSequence(scaleArray);
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
}



void playSequence(byte * mySequenceArray) {
  for (int j = 0; j < lengthOfSequence; j++) {
    byte currentByte = mySequenceArray[j];
    thwakOut(currentByte);   
    delay(minThwackDelay);
  }
}

