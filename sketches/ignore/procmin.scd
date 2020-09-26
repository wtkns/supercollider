(
var pevents, sineProc, sineSynth; // CTK Synths 
var initGraphics,  initAnimae, initAnimate; // procmods
var ardCtl, port, portName; // arduino stuff
var graphics, animae, animate, domain; // routines
var fundFreqEnv;
var ardRecipr = 1024.reciprocal;

fundFreqEnv = Env.new([20, 5000],[1], \exp);

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
			domain.animae.do({ arg part, j;
				part.move;
			});
			domain.userview.refresh;
			(1/30).wait;
		};
	}, 2048);


	
	sineSynth = CtkSynthDef(\singrain, {arg freq, ratio, amp, channel;
		Out.ar(channel,ÊSinOsc.ar(freq*ratio, 0, amp))
	});
	

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
									data[i]= ((payload[i*2]<<2)+payload[i*2+1] +1 )*ardRecipr; // convert to numbers between 1/1024 and 1
								}; 

								//--move data into an ctk control array 
								// data.postln;
								ardCtl[0].set(data[0]);   // Room   
								ardCtl[1].set(data[1]);    // damp
								ardCtl[2].set(fundFreqEnv[data[2]]);   // fundFreq mapped against envelope
								ardCtl[3].set(fundFreqEnv[data[3]]);   // formFreq mapped against envelope
								ardCtl[4].set(data[4]);  //  bandWidth mapped against envelope
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
	
	sineProc = 	{arg id, amp, env, ratio, channel, freq, freqMap;
		var proc, curFreq;
		
		// freq = freqMap[curFreq]
		// part.size.set((l*150).round(1),(m*150).round(1)); 

		proc = ProcModR.new(env, amp, 2, 0, id: id);
		proc.function_({arg group, routebus, server;
			Task({

					curFreq = freq.get({arg bus, val; m = val});
					m.postln;

					sineSynth.note(target: group)
						.freq_(freq)
						.ratio_(ratio)
						.amp_(0.5)
						.channel_(channel)
					.play;
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
				initGraphics.value(\evGa),
				initAnimae.value(\evGb),
				initAnimate.value(\evGc)

			], nil
		], 

	
		/* 1 */	
		/* Synths */		
		[   // Start synths, release nothing
			[				
				sineProc.value(\ev0a, 0.5, Env([0, 1, 0], [2, 5], \sin, 1), 
					freq: ardCtl[2],
					ratio: 1,
					channel: [0,1],
					freqMap: Env.new([20, 500],[1], \exp)					),
				
			], nil
		], 
		
		/* 2 */	
		[   // Start synths, release nothing
			[				
				sineProc.value(\ev1a, 0.5, Env([0, 1, 0], [2, 5], \sin, 1), 
					freq: ardCtl[3],
					ratio: 2,
					channel: [0,1],
					freqMap: Env.new([1000, 500],[1], \exp)					),
				
			], nil
		], 


		/* 3 */		
		[ // release ev0b
			nil,
			[\evGa, \evGb, \evGc, \ev0a, \ev1a]
		]
	], 0.dbamp, id: "test");
	
	pevents.showPMGUIs = true; 
	pevents.perfGUI;			

	// CLEAN UP BUFFERS AND BUSES
	CmdPeriod.doOnce({
		SerialPort.closeAll;
		domain.window.close;
		"Killed".postln;
	});
});
)