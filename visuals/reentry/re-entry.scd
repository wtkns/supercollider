(
// supercollider code for reading 6 10bit analog values via serial 
// protocol: 253 254 nn nn nn nn nn nn nn nn nn nn nn nn  255 
// nn comes in pairs. Êfirst nn are the upper 8bits and the second are the lower 2 bits. 
// values are ranged from 0 - 1023 

var pieceLength, width, height, count, domain;
var port, portName; 
var blip, note, ctl;

// declare mapping envelopes
var fundFreqEnv, formFreqEnv, bandWidthEnv;
fundFreqEnv = Env.new([0.1, 20, 1000, 10000, 1],[0.5, 0.2, 0.2, 0.1], \exp);
formFreqEnv = Env.new([20, 5000],[1], \exp);
bandWidthEnv = Env.new([0.5, 100],[1], \exp);

// set up empty array of CtkControls
ctl = 6.collect({CtkControl.play(initVal: 1)});

//set length of piece in 1/30 seconds
pieceLength = 1800; //length of piece in 1/30 seconds
width = 1000;
height = 800;
count = 200;
thisThread.randSeed_(120);

domain = Khora.new(xSize: width, ySize: height, cnt: count);

domain.animae = domain.animae.add(
	Anima.new(
		xPos: width/2, 
		yPos: height/2,  
		yVel: 5, 
		xVel: 5,
		sizX: 10, 
		sizY: 10,  
	)
);

// open serial port. double check "tty.usbserial" and baud rate
portName= SerialPort.devices.detect{|x| x.contains("tty.usbserial")}; 
if(portName.notNil, { 
	port= SerialPort(portName, 57600, crtscts: false); 
	("connected to"+portName).inform; 
}, { 
	"no port with name tty.usbserial found".inform; 
});

// boot the server
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);
s.boot;
s.waitForBoot({
	s.scope;
	s.freqscope;
	
	// CtkSynthDef with all relevant parameters
	blip = CtkSynthDef(\blipgen, {arg fundFreq, formFreq, bandWidth, room, mix, damp;
		var env, pulse, numharms, reson, rq, ampScale, reverb;
		rq = bandWidth/formFreq; 
		ampScale = 1/rq;
		numharms = (SampleRate.ir*0.4) / fundFreq;
		pulse = Blip.ar(fundFreq, numharms.floor, 1);
		reson = Resonz.ar((pulse), formFreq, rq, ampScale);
		reverb = FreeVerb.ar(reson, mix, room, damp);
		Out.ar(0, Pan2.ar(Limiter.ar(reverb, 1.0, 0.01), 0));
	}, [0.1, 0.1]);
	
	// repeating routine to read values from serial port
	Routine.run({ 
		var byte, index= 0, payload= Array.newClear(14), data= Array.newClear(6); 
		inf.do{ 
			while({byte= port.read; byte.notNil}, { 
				//byte.postln; //debug 
				if(index==0 and:{byte==253}, {  // first check bit
					index= 1; 
				}, { 
					if(index==1 and:{byte==254}, {  // second check bit
						index= 2; 
					}, { 
						if(index>=2 and:{index<14}, {  // significant bits
							payload[index-2]= byte; 
							index= index+1; 
						}, { 
							if(index==14 and:{byte==255}, {  // last bit
								//payload.postln; //debug 
								//--everything seems ok so decode payload 
								6.do{|i| 
									data[i]= ((payload[i*2]<<2)+payload[i*2+1] +1 ) /1024; // convert to numbers between 1/1024 and 1
								}; 
								//--move data into an ctk control array 
								// data.postln;  //debug
								ctl[0].set(data[0]);   // Room   
								ctl[1].set(data[1]);    // damp
								ctl[2].set(fundFreqEnv[data[2]]);   // fundFreq mapped against envelope
								ctl[3].set(formFreqEnv[data[3]] );   // formFreq mapped against envelope
								ctl[4].set(bandWidthEnv[data[4]] );  //  bandWidth mapped against envelope
								ctl[5].set(data[5]);   //~mix
								index= 0; 
							}, { 
								//--something broke or beginning - restart 
								// "restart".postln; //debug 
								index= 0; 
							}); 
						}); 
					}); 
				}); 
			}); 
		}; 
	}); 
	
	// start note to activate ctkControl
	note = blip.note().fundFreq_(ctl[2]).formFreq_(ctl[3]).bandWidth_(ctl[4]).room_(ctl[0]).damp_(ctl[1]).mix_(ctl[5]).play;
});




// close all of the serial ports with CmdPeriod
CmdPeriod.doOnce({SerialPort.closeAll}); 
) 