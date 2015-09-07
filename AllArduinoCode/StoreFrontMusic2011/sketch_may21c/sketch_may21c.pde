/*
 Store Front Music Demo
 Language: Arduino
 Name: SFM_GOOD_a_twacker.pde
 
 This code recieves a string of information from a processing sketch
 and does or does not "thwak" different items accordingly. 
 
 The processing sketch is called
 SFM_GOOD_p_demo.pde
 
 This version was for demoing how SFM worked to the folks from 
 GOOD Magaizine in November, 2010. It used LEDs instead of actual
 solenoids. 
 
 http://itp.nyu.edu/physcomp/Labs/SerialDuplex
 
 Made more efficent & extendible by creating some Arrays.
 
 The Circuit:
 * 4 Red LEDs w/ 330 Ohm resistors, pins 2, 3, 4, 5
 * 4 Yellow LEDs w/ 330 Ohm resistors, pins 6, 7, 8, 9
 * Toggle swtich (by which I mean a wire as necessary) pulled 
 up by internal resistor on pin 12
 
 By Carlyn Maw
 Created On: August 26 2010
 Updated On: November 07 2010
 */

//-----------------------------------CHANGE ME DEPENDING ON YOUR SET UP!  

//WAIT! START HERE! Are you in debug mode?
byte debugFlag = 0;

//current communication rate. 
long baudRate = 9600;

const char startByte = 'S';   //83
const char endByte = '\n';    //10
const char trueByte = '1';    //49
const char falseByte = '0';   //48

//number of thwakers
const int numberOfThwakers = 8;

//what pins the thwakers are attached to
byte thwackPinArray[numberOfThwakers] = { 
  2,3,4,5,6,7,8,9 } 
;

// when the pin that needs to be looked at to see if
// should play preprogrammed sequence or respond to sensors
const byte manualModePin = 12;

// if we need to not allow the sequence to go too fast. 
// blocking functions
int thwakTimeMin = 1000;
int pulseLength = 120;

//------------------------------------------------------END OF CHANGE ME.  

byte manualModeFlag = 1;  // 1 is off, 0 is on

int counter = 0; //how many 1 or 0 have I gotten since the last 'S'?

//holders for infromation you're going to pass to thwaking function
//in this case for manual mode only. 
const int lengthOfSequence = 10;
byte dataONE;
byte sequenceArrayONE[lengthOfSequence];


void setup() {
  //set pins to output because they are addressed in the main loop
  for (byte i = 0; i <= numberOfThwakers; i ++) {
    pinMode(thwackPinArray[i], OUTPUT);
  }

  pinMode(manualModePin, INPUT);
  digitalWrite(manualModePin, HIGH); // look for low


  Serial.begin(baudRate);

  sequenceArrayONE[0] = B11100000;
  sequenceArrayONE[1] = B00011000;
  sequenceArrayONE[2] = B00000100;
  sequenceArrayONE[3] = B00000001;
  sequenceArrayONE[4] = B10000010;
  sequenceArrayONE[5] = B01000000;
  sequenceArrayONE[6] = B00100000;
  sequenceArrayONE[7] = B00010000;
  sequenceArrayONE[8] = B00001000;
  sequenceArrayONE[9] = B00000100;
}

void loop() {

  manualModeFlag = digitalRead(manualModePin);  // pressed is LOW, so 0 is ON

  
   // playSequence();
  //  thwack(3);
   // thwack(4);
    thwack(7);
//        thwack(6);
    thwack(5);
    thwack(7);
    thwack(7);    
    thwack(9);
    thwack(4);
  
    delay(3000);

}



void plainSequence() {
  thwack(2);
  thwack(3);
  thwack(4);
  thwack(5);
  thwack(6);
  thwack(7);
  thwack(8);
  thwack(9);
}


void thwack(int myPin) {
  digitalWrite(myPin, HIGH);
  delay(pulseLength);
  digitalWrite(myPin, LOW);
  delay(1000);
}





