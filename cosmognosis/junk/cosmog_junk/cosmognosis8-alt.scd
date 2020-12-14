(
var func, pevents;
var port, portName; 
var blip, note, ctl;

var freqEnv;
freqEnv = Env.new([10, 800],[1], \exp);


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
	
	blip = CtkSynthDef(\singrain, {arg freq, ratio, amp, dur, outbus, channel;
		Out.ar(channel,ÊSinOsc.ar(freq*ratio, 0, amp) *ÊEnvGen.kr(Env.sine(dur, amp), doneAction: 2))
	});
	
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
								ctl[2].set(freqEnv[data[2]]);   // fundFreq mapped against envelope
								ctl[3].set(data[3]);   // formFreq mapped against envelope
								ctl[4].set(data[4]);  //  bandWidth mapped against envelope
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

	
	func = {arg id, amp, env, ratio, winsize, overlaps, channel;
		var proc;
		proc = ProcModR.new(env, amp, 2, 0, id: id);
		proc.function_({arg group, routebus, server;
			Task({
				loop({
					// start a new synth... run it inside this ProcMod's group,
					// and read control values off the envbus
					blip.note(target: group).freq_(ctl[2]).ratio_(ratio).amp_(1)
						.dur_(winsize).outbus_(routebus).channel_(channel).play;
					(winsize / overlaps).wait;
					})
				});
			});
		};
	
	pevents = ProcEvents.new([
	/* 0 */		[   // create \ev1, release nothing
					[
					func.value(\ev1a, 0.1, Env([0, 1, 0], [2, 10], \sin, 1), 
						ratio: 1,
						channel: 0,
						winsize: 0.3, 
						overlaps: 8),
					
					func.value(\ev1b, 0.1, Env([0, 1, 0], [2, 10], \sin, 1), 
						ratio: 3,
						channel: 1,
						winsize: 0.3, 
						overlaps: 8)
					],	
					nil
				], 
	/* 1 */		[
					func.value(\ev2, 0.1, Env([0, 1, 0], [1, 10], \sin, 1), 
						ratio:3,
						channel: 1,
						winsize: 0.2, 
						overlaps: 8),
					nil
				],
	/* 2 */		[   // release ev1 and ev2
					func.value(\ev3, 0.1, 
						Env([0, 1, 0.5, 2, 0], [1, 1, 1, 1], \sin, 1), 
						ratio:0.5,										channel: 2,
						winsize: 1, 
						overlaps: 4),
					[\ev1a, \ev1b, \ev2]
				],
	/* 3 */		[nil, \ev3]
				], 0.dbamp, id: "test");
				
	// record to disk
	pevents.record("~/Desktop/test".standardizePath, true, 'aiff', 'float');
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