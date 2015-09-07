/*
 Store Front Music Demo
 Language: Arduino
 Name: SFM_GOOD_a_SensorSender.pde
  
 This code reads four analog inputs and outputs their values via serial 
 to be read by a processing sketch.
 
 The processing sketch is called
 SFM_GOOD_p_demo.pde
 
 This version was for demoing how SFM worked to the folks from 
 GOOD Magaizine in November, 2010. It is a modification of work by
 Tom Igoe, found here:
 
 http://itp.nyu.edu/physcomp/Labs/SerialDuplex
 
 Made more efficent & extendible by creating some Arrays.
 
 The Circuit:
 * Analog Pins 0-4: Photocells, dark = 1023 (photocell to grnd, 10k to Vcc)
 
 By Carlyn Maw
 Created On: November 07 2010
 
 */
//-----------------------------------CHANGE ME DEPENDING ON YOUR SET UP!
boolean cleanIt = 1; // if true will constrain to a typical Max and Min
                     //and then map the values back out to 0 to 1023
                     
const int numberOfSensors = 4;

int baudRate = 9600;


int sensorPins[numberOfSensors] =  {0,1,2,3};

int sensorValues[numberOfSensors] =  {0,0,0,0};

int sensorMins[numberOfSensors] = {120,160,295,250}; //set cleanIt to 0 and set up
                                                     //the lowest reading scenario

int sensorMaxs[numberOfSensors] = {850,950,960,1000}; //set cleanIt to 0 and set
                                                      //a highest reading scenario

char endByte = '\n'; 
char delimByte = ',';

int expectedMin = 0;
int expectedMax = 1023;

//------------------------------------------------------END OF CHANGE ME. 

void setup() {
  // configure the serial connection:
  Serial.begin(baudRate);  // is matched in processing
}

void loop() {
  // read the sensor:
  
  for (int s = 0;  s < numberOfSensors ; s ++) {
    if (cleanIt) {
      sensorValues[s] = constrain(analogRead(sensorPins[s]), sensorMins[s], sensorMaxs[s]);
      sensorValues[s] = map(sensorValues[s], sensorMins[s], sensorMaxs[s], expectedMin, expectedMax);
    } else {
      sensorValues[s] = analogRead(sensorPins[s]);
    }
    
    // print the results:
    if (s == (numberOfSensors-1)) {
        Serial.print(sensorValues[s], DEC);
        Serial.print(endByte);
    } else {
        Serial.print(sensorValues[s], DEC);
        Serial.print(delimByte); 
    }
  }

}

