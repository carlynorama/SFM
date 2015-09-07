#include <Button.h> 
#include <FancySolenoid.h> 

bool debugFlag = 0;
unsigned long currentTime = 0;

const byte numberOfthwackers = 8;
byte thwackPinArray[numberOfthwackers] = { 
  2, 3,4 ,5 ,6, 7, 8,9 } 
;

//the pit array of the pinstates for the thwackers
unsigned char thwackMe = 0;
//Instantiate Button on digital pin 2
//pressed = ground (pulled high with _external_ resistor)
Button helloButton = Button(11, LOW);

FancySolenoid* solenoids[numberOfthwackers]; // array of pointers


  void setup()
  {
    Serial.begin(9600);


    //have to do outputs b/c using the solenoid register style
    for (byte i = 0; i < numberOfthwackers; i ++) {
      pinMode(thwackPinArray[i], OUTPUT);
      solenoids[i] = &FancySolenoid(i, HIGH, &thwackMe);
    }
    
    for (byte i = 0; i < numberOfthwackers; i ++) {
      solenoids[i]->setFullPeriod((i*120) + 100);
    }


  }

void loop()
{

  helloButton.listen();  

  currentTime = millis();

  for (byte i = 0; i < numberOfthwackers; i ++) {
    solenoids[i]->update(currentTime);
  }


  if (helloButton.onPress()) {
    
      solenoids[3]->pulse(5);
      solenoids[5]->pulse(3);
      
      solenoids[2]->pulse(4);
      solenoids[4]->pulse(2);
      
      solenoids[1]->pulse(6);
      solenoids[6]->pulse(1);
      
      solenoids[2]->pulse(7);
      solenoids[7]->pulse(2);
    
  }

  thwackOut(thwackMe);
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

