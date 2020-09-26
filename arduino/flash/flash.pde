/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */
int sensorPin = A0;    // select the input pin for the potentiometer
int sensorValue = 0;  // variable to store the value coming from the sensor
int num_pins = 10;    // number of pins to use
int pins[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }; // an array of pin numbers

void setup() {                
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
  int i;
  for (i = 0; i < num_pins; i++)   // the array elements are numbered from 0 to num_pins - 1
  pinMode(pins[i], OUTPUT);      // set each pin as an output
}

void loop() {
   // read the value from the sensor:
  sensorValue = analogRead(sensorPin);    
  digitalWrite(1, HIGH);   // set the LED on
  digitalWrite(2, LOW);   // set the LED off
  digitalWrite(3, LOW);   // set the LED off
  digitalWrite(4, LOW);   // set the LED off
  digitalWrite(5, LOW);   // set the LED off
  digitalWrite(6, LOW);   // set the LED off
  digitalWrite(7, LOW);   // set the LED off
  digitalWrite(8, LOW);   // set the LED off
  digitalWrite(9, LOW);   // set the LED off
  digitalWrite(10, LOW);   // set the LED off
  delay(sensorValue);              // wait for a second

  digitalWrite(1, LOW);   // set the LED on
  digitalWrite(2, HIGH);   // set the LED off
  digitalWrite(3, LOW);   // set the LED off
  digitalWrite(4, LOW);   // set the LED off
  digitalWrite(5, LOW);   // set the LED off
  digitalWrite(6, LOW);   // set the LED off
  digitalWrite(7, LOW);   // set the LED off
  digitalWrite(8, LOW);   // set the LED off
  digitalWrite(9, LOW);   // set the LED off
  digitalWrite(10, LOW);   // set the LED off
  delay(sensorValue);              // wait for a second

  digitalWrite(1, LOW);   // set the LED on
  digitalWrite(2, LOW);   // set the LED off
  digitalWrite(3, HIGH);   // set the LED off
  digitalWrite(4, LOW);   // set the LED off
  digitalWrite(5, LOW);   // set the LED off
  digitalWrite(6, LOW);   // set the LED off
  digitalWrite(7, LOW);   // set the LED off
  digitalWrite(8, LOW);   // set the LED off
  digitalWrite(9, LOW);   // set the LED off
  digitalWrite(10, LOW);   // set the LED off
  delay(sensorValue);              // wait for a second

  digitalWrite(1, LOW);   // set the LED on
  digitalWrite(2, LOW);   // set the LED off
  digitalWrite(3, LOW);   // set the LED off
  digitalWrite(4, HIGH);   // set the LED off
  digitalWrite(5, LOW);   // set the LED off
  digitalWrite(6, LOW);   // set the LED off
  digitalWrite(7, LOW);   // set the LED off
  digitalWrite(8, LOW);   // set the LED off
  digitalWrite(9, LOW);   // set the LED off
  digitalWrite(10, LOW);   // set the LED off
  delay(sensorValue);              // wait for a second

  digitalWrite(1, LOW);   // set the LED on
  digitalWrite(2, LOW);   // set the LED off
  digitalWrite(3, LOW);   // set the LED off
  digitalWrite(4, LOW);   // set the LED off
  digitalWrite(5, HIGH);   // set the LED off
  digitalWrite(6, LOW);   // set the LED off
  digitalWrite(7, LOW);   // set the LED off
  digitalWrite(8, LOW);   // set the LED off
  digitalWrite(9, LOW);   // set the LED off
  digitalWrite(10, LOW);   // set the LED off
  delay(sensorValue);              // wait for a second

  digitalWrite(1, LOW);   // set the LED on
  digitalWrite(2, LOW);   // set the LED off
  digitalWrite(3, LOW);   // set the LED off
  digitalWrite(4, LOW);   // set the LED off
  digitalWrite(5, LOW);   // set the LED off
  digitalWrite(6, HIGH);   // set the LED off
  digitalWrite(7, LOW);   // set the LED off
  digitalWrite(8, LOW);   // set the LED off
  digitalWrite(9, LOW);   // set the LED off
  digitalWrite(10, LOW);   // set the LED off
  delay(sensorValue);              // wait for a second

  digitalWrite(1, LOW);   // set the LED on
  digitalWrite(2, LOW);   // set the LED off
  digitalWrite(3, LOW);   // set the LED off
  digitalWrite(4, LOW);   // set the LED off
  digitalWrite(5, LOW);   // set the LED off
  digitalWrite(6, LOW);   // set the LED off
  digitalWrite(7, HIGH);   // set the LED off
  digitalWrite(8, LOW);   // set the LED off
  digitalWrite(9, LOW);   // set the LED off
  digitalWrite(10, LOW);   // set the LED off
  delay(sensorValue);              // wait for a second
 
 
  digitalWrite(1, LOW);   // set the LED on
  digitalWrite(2, LOW);   // set the LED off
  digitalWrite(3, LOW);   // set the LED off
  digitalWrite(4, LOW);   // set the LED off
  digitalWrite(5, LOW);   // set the LED off
  digitalWrite(6, LOW);   // set the LED off
  digitalWrite(7, LOW);   // set the LED off
  digitalWrite(8, HIGH);   // set the LED off
  digitalWrite(9, LOW);   // set the LED off
  digitalWrite(10, LOW);   // set the LED off
  delay(sensorValue);              // wait for a second
  
  digitalWrite(1, LOW);   // set the LED on
  digitalWrite(2, LOW);   // set the LED off
  digitalWrite(3, LOW);   // set the LED off
  digitalWrite(4, LOW);   // set the LED off
  digitalWrite(5, LOW);   // set the LED off
  digitalWrite(6, LOW);   // set the LED off
  digitalWrite(7, LOW);   // set the LED off
  digitalWrite(8, LOW);   // set the LED off
  digitalWrite(9, HIGH);   // set the LED off
  digitalWrite(10, LOW);   // set the LED off
  delay(sensorValue);              // wait for a second
  
  digitalWrite(1, LOW);   // set the LED on
  digitalWrite(2, LOW);   // set the LED off
  digitalWrite(3, LOW);   // set the LED off
  digitalWrite(4, LOW);   // set the LED off
  digitalWrite(5, LOW);   // set the LED off
  digitalWrite(6, LOW);   // set the LED off
  digitalWrite(7, LOW);   // set the LED off
  digitalWrite(8, LOW);   // set the LED off
  digitalWrite(9, LOW);   // set the LED off
  digitalWrite(10, HIGH);   // set the LED off
  delay(sensorValue);              // wait for a second
}
