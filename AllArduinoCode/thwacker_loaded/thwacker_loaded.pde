//the libraries live at github.com/carlynorama
#include <Button.h> 
#include <FancySolenoid.h> 

bool debugFlag = 0;
unsigned long currentTime = 0;
bool serialListenerFlag = 1;

const byte numberOfthwackers = 8;
byte thwackPinArray[numberOfthwackers] = { 
  2,3 ,5 ,6, 4 , 7, 8,9 };

const byte gndPin = 15;
const byte manualModePin = 14;
//const byte offModePin = 17;
//Instantiate Button on digital pins
//pressed = 5V

int dutyCycle = 7;
long fullPeriod = 1300;

//------------------------------------------------------END OF CHANGE ME.  

byte manualModeFlag = 0;  // 1 is off, 0 is on
//byte offModeFlag = 0;  // 1 is off, 0 is on
//the pit array of the pinstates for the thwackers
unsigned char thwackMe = 0;
unsigned char readMe = 0;

Button buttons[numberOfthwackers] = {
  Button(0, HIGH, &readMe),
  Button(1, HIGH, &readMe),
  Button(2, HIGH, &readMe),
  Button(3, HIGH, &readMe),
  Button(4, HIGH, &readMe),
  Button(5, HIGH, &readMe),
  Button(6, HIGH, &readMe),
  Button(7, HIGH, &readMe)
  };

FancySolenoid solenoids[numberOfthwackers] = { 
  FancySolenoid(0, HIGH, &thwackMe), 
  FancySolenoid(1, HIGH, &thwackMe), 
  FancySolenoid(2, HIGH, &thwackMe),
  FancySolenoid(3, HIGH, &thwackMe), 
  FancySolenoid(4, HIGH, &thwackMe), 
  FancySolenoid(5, HIGH, &thwackMe),
  FancySolenoid(6, HIGH, &thwackMe), 
  FancySolenoid(7, HIGH, &thwackMe)
  };

  const int lengthOfSequence = 9;
byte scalesArray[lengthOfSequence];

void setup()
{
  Serial.begin(9600);

  //have to do outputs b/c using the solenoid register style
  for (byte i = 0; i < numberOfthwackers; i ++) {
    pinMode(thwackPinArray[i], OUTPUT);
  }
  
  for (byte i = 0; i < numberOfthwackers; i ++) {
    solenoids[i].setDutyCycle(dutyCycle);
    solenoids[i].setFullPeriod(fullPeriod);
  }
  
  pinMode(gndPin, OUTPUT);
  digitalWrite(gndPin, LOW);
  pinMode(manualModePin, INPUT);
  digitalWrite(manualModePin, HIGH); // look for low
  //pinMode(offModePin, INPUT);
  //digitalWrite(offModePin, HIGH); 

  scalesArray[0] = B00000001; 
  scalesArray[1] = B00000010; 
  scalesArray[2] = B00000100; 
  scalesArray[3] = B00001000;   
  scalesArray[4] = B00010000; 
  scalesArray[5] = B00100000; 
  scalesArray[6] = B01000000; 
  scalesArray[7] = B10000000; 
  scalesArray[8] = B00000000; 

}

void loop()
{
  
  manualModeFlag = digitalRead(manualModePin);
 //offModeFlag = digitalRead(offModePin);
  
  //if (offModeFlag == 0) {
  //      readMe = 0;
  //}else if (manualModeFlag == 0) {
    
  if (manualModeFlag == 0) {
    readMe = 0;
    playSequence(scalesArray);
  } 
  else if (serialListenerFlag && Serial.available() > 0) {
    respondToSerial(); 
  } 


  for (byte i = 0; i < numberOfthwackers; i ++) {
    buttons[i].listen();
  }  

  currentTime = millis();
  for (byte i = 0; i < numberOfthwackers; i ++) {
    solenoids[i].update(currentTime);
  }

  for (byte i = 0; i < numberOfthwackers; i ++) {
    if (buttons[i].isPressed()) {
      solenoids[i].pulse(1);
    }
  }  

  thwackOut(thwackMe);
  //readMe=0;
}


void thwackOut(byte myDataOut) {
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
  if (debugFlag) {
    Serial.println(myDataOut, BIN);
  }
}


void respondToSerial()
{
  //get the first byte in the serial buffer
  unsigned char incomingByte = Serial.read();

  //do different things based on it's value..
  readMe = incomingByte;

  //clear out the serial buffer, keep it up to date
  Serial.flush();

}

void playSequence(byte * mySequenceArray) {
  for (int j = 0; j < lengthOfSequence; j++) {
    byte currentByte = mySequenceArray[j];
    thwackOut(currentByte);   
    delay(750);
  }
    delay(2000);  
}


