#include <Button.h> 
#include <FancySolenoid.h> 

bool debugFlag = 0;
unsigned long currentTime = 0;
bool serialListenerFlag = 1;

const byte numberOfthwackers = 8;
byte thwackPinArray[numberOfthwackers] = { 
  2, 3,4 ,5 ,6, 7, 8,9 } 
;

const int LEDPin = 14;

//the pit array of the pinstates for the thwackers
unsigned char thwackMe = 0;
unsigned char readMe = 0;
//Instantiate Button on digital pin 2
//pressed = ground (pulled high with _external_ resistor)
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


  void setup()
  {
    Serial.begin(9600);

    //have to do outputs b/c using the solenoid register style
    for (byte i = 0; i < numberOfthwackers; i ++) {
      pinMode(thwackPinArray[i], OUTPUT);
    }

  }

void loop()
{

  if (serialListenerFlag && Serial.available() > 0) {
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


