

/*
	Week 11 - Sensor Technology task for Arduino - SuperCollider - Processing

	With the Arduino example you send 4 analog signals + 1 digital (button).
	You only send characters between 0 - 200, therefor for more accurate mapping
	this parsing is not the best solution.

	You can find the Arduino and the Processing code below or attached.
	For the Processing part you will have to use the oscP5.* and netP5.* libraries by A. Schlegel:
	oscP5 website at http://www.sojamo.de/oscP5

	Code based on code on the SC forum posts.
	K.Hofstader - http://tedor.info 11/2011

	1) Upload the Arduino code (use for analog sensors or pots and a digital button in pin 13)
	2) Run the SC part (make sure you change the serial port to yours)
	3) Run the Processing Part (make sure you've got the libraries)
	4) Alter, add...
*/

(
var port= SerialPort("/dev/tty.usbserial-A6006hym", 38400); // edit port here, this is used with Arduino


var net = NetAddr.new("127.0.0.1", 12000); // create the NetAddr for OSC that is used by Processing as well


~payloadData = [0,0,0,0,0]; // this is the array where the arduino signals are going to be stored



~message = "Hello Stech Student "; // you can send text to Processing






Routine.run({
	var byte;
	inf.do{
                while({(byte= port.read).isNil}, {
                        0.1.wait; // update rate 10hz
		// " major problem".postln;
                });
                //--the function:
              if (port.read == 13, // look for carriage, that represents an endline on the Serial Port
			{ if ( port.read == 10, // look for new line, this should always follow 13
				// we look for 255 twice to make sure that
				// the signal we want to use comes in the right order
				// have a look at the Arduino code for more detail
				{ if ( port.read == 255, { if ( port.read == 255 ,
				{
				5.do{ |i| // loop reading for 5 times to fill the array
				~payloadData[i] = port.read.asInteger;}; // you need to change the incoming char  to int
				~payloadData.postln;
				},

				{"2nd guard not synced".postln;};);
				}, {"1st guard not synced".postln}; ); // end of 1st guard;

				}, {"newline".postln;}); // end of if newline (10);
			};); //end of carrige (13);

			}; // end of do;
});

// with the task below send integers and a string
// in Processing you will have to have the relevant libaries installed
~sendOsc = Task({
	inf.do({
		net.sendMsg("/test", ~payloadData[0], ~payloadData[0], ~payloadData[0], ~payloadData[0], ~payloadData[0], 0, ~message);
		0.02.wait;
	});


}).play;



CmdPeriod.doOnce({port.close;~sendOsc.stop;}); // you can close the port and stop the task with this
)
