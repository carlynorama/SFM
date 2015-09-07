/*
  Analog input, analog output, serial output
 
 scaled for the MaxSonar EZ1 as testing protocol for the VIMBY/Scion Challenge
 
 by Carlyn Maw August 2010
 based on code 2009 code by Tom Igoe
 
 */

// These constants won't change.  They're used to give names
// to the pins used:
const int analogInPin = 0;  // Analog input pin that the potentiometer is attached to
const int analogOutPin = 9; // Analog output pin that the LED is attached to

const int VCC = 5000; // mVolts
const int resolutionSensor = VCC/512; //(mV/inch)
const int resolutionADC = VCC/1024;

int myInches = 0;
const int environmentMAX = 550;

int sensorValue = 0;        // value read from the pot
int outputValue = 0;        // value output to the PWM (analog out)

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600); 
}

void loop() {
  // read the analog in value:
  sensorValue = analogRead(analogInPin);            
  // map it to the range of the analog out:  
  outputValue = map(sensorValue, 0, environmentMAX, 255, 0); 
  //calibrate it for inches
  myInches = sensorValue * resolutionADC / resolutionSensor;
  // change the analog out value:
  analogWrite(analogOutPin, outputValue);           


  // print the results to the serial monitor:
  Serial.print("sensor = " );                       
  Serial.print(sensorValue);      
  Serial.print("\t inches = ");      
  Serial.println(myInches);   

  // wait 10 milliseconds before the next loop
  // for the analog-to-digital converter to settle
  // after the last reading:
  delay(10);                     
}
