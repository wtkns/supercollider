(
var resp, midiCtl, ardCtl; //Midi Stuff
var blip, sine, playBuffer; // CTK Synths 
var pevents, blippy, siney, sample;
var initGraphics, initBuffers, initAnimae, initAnimate; // procmods
var port, portName; // arduino stuff
var drone1, drone2, drone3, drone4, drone5, drone6; //Buffers
var myBuffers, myBuses; // Collections
var fundFreqEnv, formFreqEnv, bandWidthEnv, freqEnv; // Mapping envelopes
var graphics, animae, animate, domain; // routines
var recipr = 127.reciprocal;

// declare mapping envelopes 
// i need a better way to do this within procs rather than at the initialization of ctl
fundFreqEnv = Env.new([0.1, 20, 1000, 10000, 1],[0.5, 0.2, 0.2, 0.1], \exp);
formFreqEnv = Env.new([20, 5000],[1], \exp);
bandWidthEnv = Env.new([0.5, 100],[1], \exp);

// Initialize arrays of ctk controls:
midiCtl = 17.collect({CtkControl.play(initVal: 0.5)}); // initval prevents divide by zero
ardCtl = 6.collect({CtkControl.play(initVal: 0.01)}); 

// open serial port. double check "tty.usbserial" and baud rate
portName= SerialPort.devices.detect{|x| x.contains("tty.usbserial")}; 
if(portName.notNil, { 
	port= SerialPort(portName, 57600, crtscts: false); 
	("connected to"+portName).inform; 
}, { 
	"no port with name tty.usbserial found".inform; 
}); 

// MANAGE AND BOOT SERVER
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(32768);
s.boot;
s.waitForBoot({
	// s.scope;
	// s.freqscope;

	// MANAGE BUFFERS
	drone1 = CtkBuffer.playbuf("~/samp/drone_1.aiff".standardizePath);
	drone2 = CtkBuffer.playbuf("~/samp/drone_2.aiff".standardizePath);
	drone3 = CtkBuffer.playbuf("~/samp/drone_3.aiff".standardizePath);
	drone4 = CtkBuffer.playbuf("~/samp/drone_4.aiff".standardizePath);
	drone5 = CtkBuffer.playbuf("~/samp/drone_5.aiff".standardizePath);
	drone6 = CtkBuffer.playbuf("~/samp/drone_6.aiff".standardizePath);
	
	// INITIALIZE GRAPHICS
	graphics = Routine ({
		// VISUAL PARAMETERS AND WINDOW
		var bgColor, doClear, fullScreen, count, bounds;
		count = 100;
		bounds = Point.new(800, 800);
		bgColor = Color.black;
		doClear = true;
		fullScreen = false; // or windowed
		domain = Khora.new(count, bounds, bgColor, doClear, fullScreen);
	}, 2048);
	
	animae = Routine({
		// INITIALIZE PARTICLES		
		for (0, domain.maxCnt, {|i|
			domain.animae = domain.animae.add(
				Anima.new(
					strat: \wrap,
					par: domain,
					pos: Point.new((domain.bounds.x/(domain.maxCnt+1))*(i), 50*i),
					vel: Point.new(0.15*i, 5),
					col: Color.red,
					vis: 0.5,
					siz: Point.new(40,40),
					styl: \circle,
					lif: 6400,
					indx: i
				);
			);
		});
	}, 2048);
	
	animate = Routine({
		// PART I
		// "part I".postln;
		inf.do{ 
			//i.postln;  // to find timing
			domain.animae.do({ arg part, j;
				part.move;
				 ardCtl[0].get({arg bus, val; l = val});
				 ardCtl[1].get({arg bus, val; m = val});
				part.size.set((l*150).round(1),(m*150).round(1)); 
			});
			domain.userview.refresh;
			(1/30).wait;
		};
	}, 2048);


	// MANAGE MIDI
	MIDIClient.init;
	MIDIIn.connectAll; 
	
	// start the responders and feed midi data to CTK Controls on midiCtl[]
	resp = Array.fill(17, {arg i; 
		CCResponder({ |src,chan,num,value|
			//value.postln;
			midiCtl[i].set(value * recipr); // 0-1
		},
		nil, // any source
		nil, // any channel
		i+1, // cc start with #1
		nil // any value
		);
	});
	
	
	// MANAGE SYNTHS
	playBuffer = CtkSynthDef(\monoPlayback, {arg buffer, startPos, rate = 1, mul, pan;
		var src, env;
		env = EnvGen.kr(Env([0, 1, 1, 0], [0.1, BufDur.kr(buffer) - 0.2, 0.1], \sin));
		// PlayBuf expects the number of channels to match those in the buffer
		// this will ONLY play mono files!
		src = PlayBuf.ar(1, // mono
			buffer, // the buffer you created above
			rate * BufRateScale.kr(buffer), // the rate adjust for SR of file
			1, // a trigger... ignore for now
			startPos * BufSampleRate.kr(buffer), // adjust startPos in sec to samples
			1 // loop, 0 is no, 1 is yes
			);
		Out.ar(0, Pan2.ar((src * env)*mul, pan));
	});
	
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

	// READ FROM ARDUINO
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
								//data.postln;
								ardCtl[0].set(data[0]);   // Room   
								ardCtl[1].set(data[1]);    // damp
								ardCtl[2].set(fundFreqEnv[data[2]]);   // fundFreq mapped against envelope
								ardCtl[3].set(formFreqEnv[data[3]] );   // formFreq mapped against envelope
								ardCtl[4].set(bandWidthEnv[data[4]] );  //  bandWidth mapped against envelope
								ardCtl[5].set(data[5]);   //~mix
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
	

	
	// MANAGE PROCMODS
	sample = {arg id, amp, env, rate, pan, buffer, mul;
		var proc;
		proc = ProcModR.new(env, amp, 2, 0, id: id);
		proc.function_({arg group, routebus, server;
			Task({
				playBuffer.note(target: group)
					.buffer_(buffer)
					.startPos_(0)
					.rate_(rate)
					.pan_(pan)
					.mul_(mul)
				.play;
			});
		});
	};
	
	siney = 	{arg id, amp, env, ratio, channel;
		var proc;
		proc = ProcModR.new(env, amp, 2, 0, id: id);
		proc.function_({arg group, routebus, server;
			Task({
					sine.note(target: group)
						.freq_(ardCtl[2])
						.ratio_(ratio)
						.amp_(0.5)
						.channel_(channel)
					.play;
			});
		});
	};
	
	blippy = {arg id, amp, env, ratio, channel;
		var proc;
		proc = ProcModR.new(env, amp, 2, 0, id: id);
		proc.function_({arg group, routebus, server;
			Task({
					blip.note(target: group)
						.fundFreq_(ardCtl[2])
						.formFreq_(ardCtl[3])
						.bandWidth_(ardCtl[4])
						.room_(ardCtl[0])
						.mix_(ardCtl[1])
						.damp_(ardCtl[5])
						.ratio_(ratio)
						.amp_(0.5)
						.channel_(channel)
					.play;
			});
		});
	};

	initBuffers = {arg id;
		var proc;
		proc = ProcModR.new(Env([0, 1, 0], [0, 1], \sin, 1), 0, 2, 0, id: id);
		proc.function_({
			Routine({
				myBuffers = [drone1, drone2, drone3, drone4, drone5, drone6];
				myBuffers.do({arg thisBuffer; thisBuffer.load;});
 				"buffers added".postln;
				s.sync;		 // and pause execution until the buffer is loaded
			});
		});
	};

	initGraphics = {arg id;
		var proc;
		proc = ProcModR.new(Env([0, 1, 0], [0, 1], \sin, 1), 0, 2, 0, id: id);
		proc.function_({
			Routine({
				graphics.play(AppClock);
			});
		});
	};
	
	initAnimae = {arg id;
		var proc;
		proc = ProcModR.new(Env([0, 1, 0], [0, 1], \sin, 1), 0, 2, 0, id: id);
		proc.function_({
			Routine({
				animae.play(AppClock);
			});
		});
	};
	
	initAnimate = {arg id;
		var proc;
		proc = ProcModR.new(Env([0, 1, 0], [0, 1], \sin, 1), 0, 2, 0, id: id);
		proc.function_({
			Routine({
				animate.play(AppClock);
			});
		});
	};

	// MANAGE PROCEVENTS
	pevents = ProcEvents.new([

		[ // Start all samples, release nothing
			[	
				initBuffers.value(\evS0),
				initGraphics.value(\evGa),
				initAnimae.value(\evAa),
				initAnimate.value(\evAb)

			], nil
		], 

		/* Samples */		
		[ // Start all samples, release nothing
			[								
				sample.value(\evSa, 0.5, Env([0, 1, 0], [2, 5], \sin, 1),
					rate: 1,
					pan: 0,
					buffer: drone1,
					mul:midiCtl[0]
				),
	
				sample.value(\evSb, 0.5, Env([0, 1, 0], [2, 5], \sin, 1),
					rate: 1,
					pan: 0,
					buffer: drone2,
					mul:midiCtl[1]
				),
				
				sample.value(\evSc, 0.5, Env([0, 1, 0], [2, 5], \sin, 1),
					rate: 1,
					pan: 0,
					buffer: drone3,
					mul:midiCtl[2]
				),
				
				sample.value(\evSd, 0.5, Env([0, 1, 0], [2, 5], \sin, 1),
					rate: 1,
					pan: -0.9,
					buffer: drone4,
					mul:midiCtl[3]
				),
	
				sample.value(\evSe, 0.5, Env([0, 1, 0], [2, 5], \sin, 1),
					rate: 1,
					pan: 0.9,
					buffer: drone5,
					mul:midiCtl[4]
				)						
			], nil
		], 
				
		/* 1 */	
		/* Synths */		
		[   // Start synths, release nothing
			[				
				blippy.value(\ev0a, 0.5, Env([0, 1, 0], [2, 5], \sin, 1), 
					ratio: 2,
					channel: 0
					),
				
				blippy.value(\ev0b, 0.5, Env([0, 1, 0], [2, 5], \sin, 1), 
					ratio: 2,
					channel: 1
					),
				
				blippy.value(\ev0c, 0.5, Env([0, 1, 0], [2, 5], \sin, 1), 
					ratio: 1,
					channel: 2
					),
						
				siney.value(\ev0d, 0.5, Env([0, 1, 0], [2, 5], \sin, 1), 
					ratio: 3,
					channel: [0,1]								),
				
			], nil
		], 


		/* 3 */		
		[ // release ev1
			nil,
			[\evAa, \evAb, \evGa, \evSa, \evSb, \evSc, \evSd, \evSe, \ev0a, \ev0b, \ev0c, \ev0d]
		]
	], 0.dbamp, id: "test");
	
	pevents.showPMGUIs = true; 
	pevents.perfGUI;			

	// CLEAN UP BUFFERS AND BUSES
	CmdPeriod.doOnce({
		SerialPort.closeAll;
		CCResponder.removeAll;
		myBuffers.do({arg thisBuffer; thisBuffer.free;});
		"buffer clear".postln;
		myBuses.do({arg thisBus; thisBus.free;});		"buses clear".postln;
						//		Window.closeAll;
						//		domain.window.close;
	});
});
)