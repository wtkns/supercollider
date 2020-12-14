(
// supercollider code for reading 6 10bit analog values via serial 
// protocol: 253 254 nn nn nn nn nn nn nn nn nn nn nn nn  255 
// nn comes in pairs. Êfirst nn are the upper 8bits and the second are the lower 2 bits.  thanks to fredrik olofsson
// values are ranged from 0 - 1023 

var port, portName; 
var blip, note1, note2, note3, ctl, recBuffer;

// declare mapping envelopes
var fundFreqEnv, formFreqEnv, bandWidthEnv;
fundFreqEnv = Env.new([0.1, 20, 1000, 10000, 1],[0.5, 0.2, 0.2, 0.1], \exp);
formFreqEnv = Env.new([20, 5000],[1], \exp);
bandWidthEnv = Env.new([0.5, 100],[1], \exp);


// set up empty array of CtkControls
ctl = 6.collect({CtkControl.play(initVal: 1)}); // initval prevents divide by zero when everything is getting started

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
s.options.memSize_(32768);
s.boot;
s.waitForBoot({
	s.scope;
	s.freqscope;

	//recBuffer = CtkBuffer.buffer(18522000).load;
	thisProcess.platform.recordingsDir=standardizePath("~/samp/");

	// CtkSynthDef with all relevant parameters
	blip = CtkSynthDef(\blipgen, {arg fundFreq, formFreq, bandWidth, room, mix, damp, out, buffer, channel;
		var env, pulse, numharms, reson, rq, ampScale, reverb;
		rq = bandWidth/formFreq; 
		ampScale = 1/rq;
		numharms = (SampleRate.ir*0.4) / fundFreq;
		pulse = Blip.ar(fundFreq*(3-channel), numharms.floor, 1);
		reson = Resonz.ar((pulse), formFreq*(3-channel), rq, ampScale);
		reverb = FreeVerb.ar(reson, mix, room, damp);
		out = Limiter.ar(reverb, 1.0, 0.01);
		//RecordBuf.ar(out, buffer);
		Out.ar(channel, out );
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
								data.postln;
								ctl[0].set(data[0]);   // Room   
								ctl[1].set(data[1]);    // damp
								ctl[2].set(fundFreqEnv[data[2]]);   // fundFreq mapped against envelope
								ctl[3].set(formFreqEnv[data[3]] );   // formFreq mapped against envelope
								ctl[4].set(bandWidthEnv[data[4]] );  //  bandWidth mapped against envelope
								ctl[5].set(data[5]);   //~mix
								index= 0; 
							}, { 
								//--something broke or beginning - restart 
								"restart".postln; //debug 
								index= 0; 
							}); 
						}); 
					}); 
				}); 
			}); 
		}; 
	}); 

	// start note to activate ctkControl
	note1 = blip.note().fundFreq_(ctl[2]).formFreq_(ctl[3]).bandWidth_(ctl[4]).room_(ctl[0]).damp_(ctl[1]).mix_(ctl[5]).channel_(0).play;
	note2 = blip.note().fundFreq_(ctl[2]).formFreq_(ctl[3]).bandWidth_(ctl[4]).room_(ctl[0]).damp_(ctl[1]).mix_(ctl[5]).channel_(1).play;
	note3 = blip.note().fundFreq_(ctl[2]).formFreq_(ctl[3]).bandWidth_(ctl[4]).room_(ctl[0]).damp_(ctl[1]).mix_(ctl[5]).channel_(2).play;
	// ctl[\grainRate].get({arg bus, val; ctl[\grainRate].set(val * 0.9998)});
	//.buffer_(recBuffer)
	// {ctl[2].get({arg bus, val; val})
});

// close all of the serial ports with CmdPeriod
CmdPeriod.doOnce({
	SerialPort.closeAll;
	//recBuffer.write(path: thisProcess.platform.recordingsDir +/+ "SC_" ++ Date.localtime.stamp ++ ".aiff");
	//recBuffer.free;
	});

) 
