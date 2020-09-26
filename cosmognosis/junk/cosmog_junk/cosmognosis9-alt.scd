(
var func, pevents;
var port, portName; 
var blip, sine, note, ctl;

// declare mapping envelopes
var fundFreqEnv, formFreqEnv, bandWidthEnv;
fundFreqEnv = Env.new([0.1, 20, 1000, 10000, 1],[0.5, 0.2, 0.2, 0.1], \exp);
formFreqEnv = Env.new([20, 5000],[1], \exp);
bandWidthEnv = Env.new([0.5, 100],[1], \exp);

// set up empty array of CtkControls
ctl = 6.collect({CtkControl.play(initVal: 0.01)}); // initval prevents divide by zero when everything is getting started

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
	
	sine = CtkSynthDef(\singrain, {arg freq, ratio, amp, channel;
		Out.ar(channel,ÊSinOsc.ar(freq*ratio, 0, amp))
	});
	
	blip = CtkSynthDef(\blipgen, {arg fundFreq, formFreq, bandWidth, room, mix, damp, amp, channel, ratio;
		var env, pulse, numharms, reson, rq, ampScale, reverb, out;
		rq = bandWidth/formFreq; 
		ampScale = 1/rq;
		numharms = (SampleRate.ir*0.4) / fundFreq*ratio;
		pulse = Blip.ar(fundFreq*ratio, numharms.floor, 1);
		reson = Resonz.ar((pulse), formFreq*ratio, rq, ampScale);
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

	
	func = {arg id, amp, env, ratio, channel;
		var proc;
		proc = ProcModR.new(env, amp, 2, 0, id: id);
		proc.function_({arg group, routebus, server;
			Task({
//					sine.note(target: group)
//						.freq_(ctl[2])
//						.ratio_(ratio)
//						.amp_(1)
//						.channel_(channel)
//					.play;
//					
//					
					blip.note(target: group)
						.fundFreq_(ctl[2])
						.formFreq_(ctl[3])
						.bandWidth_(ctl[4])
						.room_(ctl[0])
						.mix_(ctl[1])
						.damp_(ctl[5])
						.ratio_(ratio)
						.amp_(1)
						.channel_(channel)
					.play;
			});
		});
	};
	
	pevents = ProcEvents.new([
	/* 0 */		[   // create \ev0, release nothing
					[
					func.value(\ev0a, 0.5, Env([0, 1, 0], [2, 0.1], \sin, 1), 
						ratio: 2,
						channel: 0
						),
					
					func.value(\ev0b, 0.5, Env([0, 1, 0], [2, 0.1], \sin, 1), 
						ratio: 2,
						channel: 1
						),
					
					func.value(\ev0c, 0.5, Env([0, 1, 0], [2, 0.1], \sin, 1), 
						ratio: 1,
						channel: 2
						)	
					],	
					nil
				], 
				
		/* 1 */		[   // create \ev1, release ev0
					[
					func.value(\ev1a, 0.5, Env([0, 1, 0], [0.5, 0.1], \sin, 1), 
						ratio: 4,
						channel: 0
						),
					
					func.value(\ev1b, 0.5, Env([0, 1, 0], [0.5, 0.1], \sin, 1), 
						ratio: 2,
						channel: 1
						)
					],	
					[\ev0a, \ev0b]
				], 	
		
		/* 2 */		[   // create \ev2, release ev0
					[
					func.value(\ev2a, 0.5, Env([0, 1, 0], [0.5, 0.1], \sin, 1), 
						ratio: 3,
						channel: 0
						),
					
					func.value(\ev2b, 0.5, Env([0, 1, 0], [0.5, 0.1], \sin, 1), 
						ratio: 3,
						channel: 1
						)
					],	
					[\ev1a, \ev1b]
				], 					
		/* 3 */		[   // create \ev3, release ev0
					[
					func.value(\ev3a, 0.5, Env([0, 1, 0], [0.5, 0.1], \sin, 1), 
						ratio: 3,
						channel: 0
						),
					
					func.value(\ev3b, 0.5, Env([0, 1, 0], [0.5, 0.1], \sin, 1), 
						ratio: 3,
						channel: 1
						)
					],	
					[\ev2a, \ev2b]
				], 					
				
		/* 4 */		[   // create \ev1, release ev0
					[
					func.value(\ev4a, 0.5, Env([0, 1, 0], [0.5, 0.1], \sin, 1), 
						ratio: 4,
						channel: 0
						),
					
					func.value(\ev4b, 0.5, Env([0, 1, 0], [0.5, 0.1], \sin, 1), 
						ratio: 3,
						channel: 1
						)
					],	
					[\ev3a, \ev3b]
				], 					
		/* 5 */		[   // create \ev5, release ev0
					[
					func.value(\ev5a, 0.5, Env([0, 1, 0], [0.5, 0.1], \sin, 1), 
						ratio: 5,
						channel: 0
						),
					
					func.value(\ev5b, 0.5, Env([0, 1, 0], [0.5, 0.1], \sin, 1), 
						ratio: 5,
						channel: 1
						)
					],	
					[\ev4a, \ev4b]
				], 					

		/* 6 */		[   // create \ev6, release ev0
					[
					func.value(\ev6a, 0.5, Env([0, 1, 0], [0.5, 0.1], \sin, 1), 
						ratio: 80,
						channel: 0
						),
					
					func.value(\ev6b, 0.5, Env([0, 1, 0], [0.5, 0.1], \sin, 1), 
						ratio: 81,
						channel: 1
						)
					],	
					[\ev5a, \ev5b]
				], 

		/* 3 */		[ // release ev1
						nil,
						[\ev6a, \ev6b, \ev0c]]
					], 0.dbamp, id: "test");
				
	// record to disk
	//pevents.record("~/Desktop/test".standardizePath, true, 'aiff', 'float');
	// show the ProcModR GUIs
	pevents.showPMGUIs = true; 
	// show the performance GUI
	pevents.perfGUI;
});

// close all of the serial ports with CmdPeriod
CmdPeriod.doOnce({
	SerialPort.closeAll;
	//recBuffer.write(path: thisProcess.platform.recordingsDir +/+ "SC_" ++ Date.localtime.stamp ++ ".aiff");
	//recBuffer.free;
});
	
)