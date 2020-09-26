/*
 * cylon
 */ 
 
int pins[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }; // an array of pin numbers
int num_pins = 10;                  // the number of pins (i.e. the length of the array)
int sensorPin = A0;    // select the input pin for the potentiometer
int sensor2Pin = A1;    // select the input pin for the potentiometer

int sensorValue = 0;  // variable to store the value coming from the sensor
int sensor2Value = 0;  // variable to store the value coming from the sensor

void setup()
{
  int i;

  for (i = 0; i < num_pins; i++)   // the array elements are numbered from 0 to num_pins - 1
    pinMode(pins[i], OUTPUT);      // set each pin as an output
}

void loop()
{
  int i;
  sensorValue = analogRead(sensorPin); 
  sensor2Value = analogRead(sensor2Pin); 
  for (i = 0; i < num_pins; i++) { // loop through each pin...
    digitalWrite(pins[i], HIGH);   // turning it on,
    delay(sensorValue);                  // pausing,
    digitalWrite(pins[i], LOW);    // and turning it off.
  }
  sensorValue = analogRead(sensorPin); 
  sensor2Value = analogRead(sensor2Pin); 
  for (i = num_pins - 1; i >= 0; i--) { 
    digitalWrite(pins[i], HIGH);   // turning it on,
    delay(sensor2Value);                  // pausing,
    digitalWrite(pins[i], LOW);    // and turning it off.
  }
}
