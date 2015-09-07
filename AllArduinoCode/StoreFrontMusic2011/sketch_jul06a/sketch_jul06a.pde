
#include <Button.h> 
#include <FancySolenoid.h> 

  //Instantiate Button on digital pin 2
  //pressed = ground (i.e. pulled high with external resistor)
  Button helloButton = Button(11, LOW);
  
  
  FancySolenoid potSolenoid = FancySolenoid(5, HIGH);

void setup()
{
//Serial.begin(9600);

}

void loop()
{

   helloButton.listen();  
 

  if (helloButton.isPressed()) {
    //Serial.println("On!");
    potSolenoid.turnOn();
     
  } else {
    //Serial.println("Off!");
    potSolenoid.turnOff();
  }

}

