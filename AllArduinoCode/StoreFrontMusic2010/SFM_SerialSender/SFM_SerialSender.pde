/*
  
 This code reads two analog inputs and one digital input
 and outputs their values via serial to be read by a processing example.
 It is an examplar of using grammar as way to keep your 
 communication protocols clear.
 
 Processing Example is called
 AfP_Class2_Ex05_p_mouseLikeReciever
 
 This version was for Class 2 of the Arduino for Programmers course 
 taught at CRASH Space in October, 2010. Except for the comments,
 it is taken pretty much directly from:
 
 http://itp.nyu.edu/physcomp/Labs/SerialDuplex
 
 The Circuit:
 * Pin 2: momentary button attached, pulled high externally w/ 10k Ohm resistor
   (LOW = pressed) NOTE!! The circuit for this on the example site is the 
   opposite of this. How will it change the behavior of the two sketches when they
   are put together?
 * (Not Used) Pin 9: LED, anode to microcontroller
 * Analog Pin 0: Flex Sensor (optional, not in code as written)
 * Analog Pin 1: Potentiometer  
 
 Illustration avalaible: 
 http://23longacre.com/sharedFiles/code/arduino/201010_CS_ArduinoForProgrammers/
 
 Largely the work of Tom Igoe 2008/2009
 Updated: Carlyn Maw
 Updated On: October 23 2010
 
 Notes by Carlyn Maw for the Arduino for Programmers Class
 Highligted by 
 //----------------------------------------------------  AfP Note!
 
 */

//----------------------------------------------------  AfP Note!
// NOTE: Can just set the pins b/c this code never knows what 
// it's doing. If it wasn't so simple you might consider using 
// the Firmata Library when you just need an Arduino-As-Zombie.

int analogOne = 0;       // analog input 
int analogTwo = 1;       // analog input 
int analogThree = 2;       // analog input 
int analogFour = 3;      //  analog input 

int sensorValue4 = 0;     // reading from the sensor
int sensorValue1 = 0;     // reading from the sensor
int sensorValue2 = 0;     // reading from the sensor
int sensorValue3 = 0;     // reading from the sensor

void setup() {
  // configure the serial connection:
  Serial.begin(9600);  // is matched in processing
}

void loop() {
  // read the sensor:
  sensorValue1 = constrain(analogRead(analogOne), 0, 1023);
  // print the results:
  Serial.print(sensorValue1, DEC);
  Serial.print(","); 

  // read the sensor:
  sensorValue2 = constrain(analogRead(analogTwo), 0, 1023);
  // print the results:
  Serial.print(sensorValue2, DEC);
  Serial.print(",");
  
 sensorValue3 = analogRead(analogThree);
  // print the results:
  Serial.print(sensorValue3, DEC);
  Serial.print(",");

  // read the sensor:
  sensorValue4 = analogRead(analogFour);
  // print the last sensor value with a println() so that
  // each set of four readings prints on a line by itself:
  Serial.println(sensorValue4, DEC);
  
  //----------------------------------------------------  AfP Note!
  //NOTE: The println at the end gives us two non-numerics as
  //end of line delimeters. again, its nice for people for
  //it be someting as visual as line breaks
}

