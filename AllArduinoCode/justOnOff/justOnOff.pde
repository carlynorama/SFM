int myRead = 0;

void setup()
{
//Serial.begin(9600);
pinMode(13, OUTPUT);
pinMode(11, INPUT);
  
}

void loop()
{

  myRead = digitalRead(11);
  digitalWrite(13, myRead);

/*
  if (myRead) {
    digitalWrite(5, HIGH);
  } else {
    digitalWrite(5, LOW);
  }
  */

}

