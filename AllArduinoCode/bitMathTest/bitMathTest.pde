bool pinValue = 0;
byte _myBit = 4;
byte _registerValue = 255;
byte _bitmask;

int buttonPin = 11;

void setup()
{
  Serial.begin(9600);
  pinMode(buttonPin, INPUT);   

  _bitmask = 0xFF ^ (1 << _myBit);
  Serial.println(_bitmask, BIN);
}

void loop()
{
  pinValue = !digitalRead(buttonPin);

  if (pinValue) {
    _registerValue = 255;
  } else {
    _bitmask =  0xFF ^ (1 << _myBit);
    _registerValue = _registerValue & _bitmask;
  }
  
  Serial.print("Register Value: ");
  Serial.println(_registerValue, BIN);
}


/*
  pinValue = digitalRead(buttonPin);
  if (pinValue) {
    _registerValue = _registerValue | (1 << _myBit);
  } 
  else {
    _bitmask = 255 | (1 << _myBit);
    _registerValue = _registerValue ^ _bitmask;
  }
  */
  
  /*
  //bit to high
  //_registerValues is set to zero at first
    pinValue = !digitalRead(buttonPin);
  if (pinValue) {
    _registerValue = _registerValue | (1 << _myBit);
  } else {
    _registerValue = 0;
  }
  */
  
/*
  //bit to low
  //_registerValues is set to 255 at first
    if (pinValue) {
    _registerValue = 255;
  } else {
    _bitmask =  0xFF ^ (1 << _myBit);
    _registerValue = _registerValue & _bitmask;
  }
  */
