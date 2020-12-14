//
//
// setting up arduino duemilanove in osx 10.7
//
// install arduino.app
// install "http://www.ftdichip.com/Drivers/VCP/MacOSX/FTDIUSBSerialDriver_v2_2_14.dmg"http://www.ftdichip.com/Drivers/VCP/MacOSX/FTDIUSBSerialDriver_v2_2_14.dmg
//
// connect board
// test blink example
// upload it
// change values
// upload it again
//
// connect pot 5v, end, analog 0, middle wire to analog input
// open serial example
// upload it
// open serial monitor
// diddle knob
//
// open SC
//
// update quarks (accept svn certificate)
// install arduino Quarks.install("arduino");
// recompile SC
//

void setup() {
  Serial.begin(57600);
}
void loop() {
  Serial.write(253);
  Serial.write(254);
  serialPrint(analogRead(A0));
  serialPrint(analogRead(A1));
  serialPrint(analogRead(A2));
  serialPrint(analogRead(A3));
  serialPrint(analogRead(A4));
  serialPrint(analogRead(A5));
  serialPrint(analogRead(A6));
  serialPrint(analogRead(A7));
  Serial.write(255);
  //delay(1);
}
void serialPrint(int val) {
  Serial.write(val>>2);  //bits 2-9
  Serial.write(val&3);   //bits 0-1
}





(
var ardSms;
var portName= SerialPort.devices.detect{|x| x.contains("tty.usbserial")};
if(portName.notNil, {
        ardSms= ArduinoSMS(portName, 115200);
        ("connected to"+portName).inform;
}, {
        "no port with name tty.usbmodem found".inform;
});
)





//
// or:
//
// install "http://arduino.cc/playground/Code/CmdMessenger"http://arduino.cc/playground/Code/CmdMessenger
// "https://github.com/dreamcat4/CmdMessenger"https://github.com/dreamcat4/CmdMessenger (clone github repository)
//
// place 3 folders into sketchbook/libraries folder:
//
// CmdMessenger library available from https://github.com/dreamcat4/cmdmessenger
// #include <CmdMessenger.h>
//
// Base64 library available from https://github.com/adamvr/arduino-base64
// #include <Base64.h>
//
// // note, folder name can't contain a -
//
// Streaming4 library available from http://arduiniana.org/libraries/	streaming/
// #include <Streaming.h>
//
// restart arduino ide
//
// open ~/Documents/Arduino/Sketches/libraries/CmdMessenger/CmdMessengerExample
//
// check baud rate
//
// compile and load onto arduino
//
// open serial window and set correct baud rate
//
//
