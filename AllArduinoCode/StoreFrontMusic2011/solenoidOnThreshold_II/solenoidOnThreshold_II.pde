/*
  Conditionals - If statement
 
 This example demonstrates the use of if() statements.
 It reads the state of a potentiometer (an analog input) and turns on an LED
 only if the LED goes above a certain threshold level. It prints the analog value
 regardless of the level.
 
 The circuit:
 * potentiometer connected to analog pin 0.
 Center pin of the potentiometer goes to the analog pin.
 side pins of the potentiometer go to +5V and ground
 * LED connected from digital pin 13 to ground
 
 * Note: On most Arduino boards, there is already an LED on the board
 connected to pin 13, so you don't need any extra components for this example.
 
 created 17 Jan 2009
 modified 4 Sep 2010
 by Tom Igoe
 
 This example code is in the public domain.
 
 http://arduino.cc/en/Tutorial/IfStatement
 
 */

// These constants won't change:
const int analogPin = A0;    // pin that the sensor is attached to
const int motorPin = 9;       // pin that the LED is attached to
const int threshold = 400;   // an arbitrary threshold level that's in the range of the analog input

void setup() {
  // initialize the LED pin as an output:
  pinMode(motorPin, OUTPUT);
  // initialize serial communications:
  Serial.begin(9600);

  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);

  digitalWrite(10, HIGH);
  digitalWrite(11, LOW);
}

void loop() {
  // read the value of the potentiometer:
  int analogValue = analogRead(analogPin);



  // if the analog value is high enough, turn on the LED:
  if (analogValue > threshold) {
    thwack(solenoidPin);
  } 
  else {
    digitalWrite(motorPin,LOW); 
  }

  // print the analog value:
  Serial.println(analogValue, DEC);

}


///----------------------------------------------  BLINK IT.-- I'M CHANGED!!

/*
void twack(int mySolenoid, int myBlinkPeriod) {
 if ((myBlinkPeriod) < (currentMillis- blinkFlipTime)) {
 blinkState ? blinkState=false : blinkState=true;
 blinkFlipTime = currentMillis;       
 }
 //(moving this line outside the if is what makes it update every time)
 digitalWrite(mySolenoid,blinkState); 
 }*/

void twack(int mySolenoid, int myPeriod, myDutyCycle) {
  int myOnPeriod = (myPeriod * myDutyCycle) / 100;
  if (twackState) {
    if ((myOnPeriod) < (currentMillis- solenoidFlipTime)) {
      blinkFlipTime = currentMillis;       
    }

  } 
  else {
  }
  //check state
  //if I'm on, check if I should be on
  //if I should be, leave me on
  //else, turn me off
  //if I'm off, see if I'm ready        


  if ((myBlinkPeriod) < (currentMillis- blinkFlipTime)) {
    blinkFlipTime = currentMillis;       
  }
  //(moving this line outside the if is what makes it update every time)
  digitalWrite(mySolenoid,blinkState); 
}

