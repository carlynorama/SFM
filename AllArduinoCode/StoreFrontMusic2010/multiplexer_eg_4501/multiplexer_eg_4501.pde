/*
 * codeexample for useing a 4051 * analog multiplexer / demultiplexer
 * by david c. and tomek n.* for k3 / malmö högskola
 *
 */  

int led = 13;    //just a led
int r0 = 0;      //value select pin at the 4051 (s0)
int r1 = 0;      //value select pin at the 4051 (s1)
int r2 = 0;      //value select pin at the 4051 (s2)
int row = 0;     // storeing the bin code
int count = 0;    // just a count
int  bin [] = {000, 1, 10, 11, 100, 101, 110, 111};//bin = binär, some times it is so easy

void setup(){

  pinMode(2, OUTPUT);    // s0
  pinMode(3, OUTPUT);    // s1
  pinMode(4, OUTPUT);    // s2
 digitalWrite(led, HIGH); 
  beginSerial(9600);
}

void loop () {

  for (count=0; count<=7; count++) {
    row = bin[count];      
    r0 = row & 0x01;
    r1 = (row>>1) & 0x01;
    r2 = (row>>2) & 0x01;
    digitalWrite(2, r0);
    digitalWrite(3, r1);
    digitalWrite(4, r2);
    //Serial.println(bin[count]);
    delay (1000);
  }  
}
