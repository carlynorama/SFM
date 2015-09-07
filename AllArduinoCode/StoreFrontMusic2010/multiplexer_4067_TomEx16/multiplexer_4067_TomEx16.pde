/// the address pins will go in order from the first one:
const int firstAddressPin = 8;

void setup() {
  Serial.begin(9600);
  // set the output pins, from the first to the fourth:
  for (int pinNumber = firstAddressPin; pinNumber < firstAddressPin + 4; pinNumber++) {
    pinMode(pinNumber, OUTPUT);
    // set all the address pins low 
    //to connect input 0 to the output:
    digitalWrite(pinNumber, LOW);
  }
}

void loop() {
  // loop over all the input channels
  for (int thisChannel = 0; thisChannel < 16; thisChannel++) {
    setChannel(thisChannel);
    // read the analog input and store it in the value array: 
    int analogReading = analogRead(0);  
    // print the result:
    Serial.print(thisChannel, DEC);
    Serial.print(" = ");
    Serial.print(analogReading, DEC);
    Serial.print("\t");
  }
  // print a linefeed and carriage return
  // after all the channels are printed
  Serial.println();
}

// this method sets the address pins to pick which input channel
// is connected to the multiplexer's output:

void setChannel(int whichChannel) {
  // loop over all four bits in the channel number:
  for (int bitPosition = 0; bitPosition < 4; bitPosition++) {
    // read a bit in the channel number:
    int bitValue = bitRead(whichChannel, bitPosition);  
    // pick the appropriate address pin:
    int pinNumber = bitPosition + firstAddressPin;
    // set the address pin
    // with the bit value you read:
    digitalWrite(pinNumber, bitValue);
  }
}
