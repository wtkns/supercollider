(
var port, portName, audCtl, visCtl; // arduino stuff
var resp, midiCtl; //Midi Stuff

var blip, sineSynth, playBuffer; // CTK Synths 
var initGraphics, initBuffers, initAnimae, initAnimate; // procmods
var drone1, drone2, drone3, drone4, drone5, drone6, left, right, sub; //Buffers
var myBuffers, myBuses, myAudEnvs; // Collections
var audEnvList, changeEnvCnt;
var  animate, domain, score, changeEnv, postCtl, aud, vis; // routines
var pevents;
var midRecipr = 127.reciprocal;
var ardRecipr = 1024.reciprocal;
var ratios;


// OPEN SERIAL PORT
// double check "tty.usbserial" and baud rate
portName= SerialPort.devices.detect{|x| x.contains("tty.usbserial")}; 
if(portName.notNil, { 
	port= SerialPort(portName, 57600, crtscts: false); 
	("connected to"+portName).inform; 
}, { 
	"no port with name tty.usbserial found".inform; 
}); 

// Initialize arrays of ctk controls:
midiCtl = 26.collect({CtkControl.play(initVal: 0.5)}); // initval prevents divide by zero
audCtl = 6.collect({CtkControl.play(initVal: 0.01)}); 
visCtl = 6.collect({CtkControl.play(initVal: 0.01)}); 
ratios = 3.collect({CtkControl.play(initVal: 1)});

// MANAGE MIDI
MIDIClient.init;
MIDIIn.connectAll; 

// start the responders and feed midi data to CTK Controls on midiCtl[]
resp = Array.fill(26, {arg i; 
	CCResponder({ |src,chan,num,value|
		value.postln;
		midiCtl[i].set(value * midRecipr); // 0-1
	},
	nil, // any source
	nil, // any channel
	i+1, // cc start with #1
	nil // any value
	);
});

// Audio enevelope maps
myAudEnvs = 6.collect({Env.newClear(1)});
changeEnvCnt = 0;
audEnvList = List.with( 
	// room, mix, fundFreq, formFreq, bandwidth, damp
	[1, 1, 0.075, 20, 5, 0.5],
	[0.8, 0.5, 120, 100, 1, 0.25], 
//	[1, 0.0010023507056758, 100, 680.50018310547, 2.1820473670959, 0.0010023507056758],
//	[0.01, 0.01, 0.075, 20, 0.5, 0.01],
//	[1, 1, 800, 4000, 100, 1], 
//
////	[ 0.01, 0.025, 1.536, 45.884, 0.503, 1],
//////	[ 0.01, 0.01, 0.153, 44.423, 0.503, 0.01],
//////	[ 0.01, 0.01, 0.175, 54.423, 0.503, 0.01],//	[0.01, 0.01, 0.075, 20, 0.5, 0.01],
//	[1, 1, 10000, 5000, 100, 1]
);



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
								data[i]= ((payload[i*2]<<2)+payload[i*2+1] +1 )*ardRecipr; 
								// convert to numbers between 1/1024 and 1
							}; 

							//--move data into an ctk control array 
							//data.postln;
							6.do{|i| 
								audCtl[i].set(myAudEnvs[i].at(data[i]));
							}; 
							
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


// MANAGE AND BOOT SERVER
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(32768);
s.boot;
s.waitForBoot({
	s.scope;
	s.freqscope;

	initBuffers = {	
		// MANAGE BUFFERS
		drone1 = CtkBuffer.playbuf("~/samp/drone_1.aiff".standardizePath);
		drone2 = CtkBuffer.playbuf("~/samp/drone_2.aiff".standardizePath);
		drone3 = CtkBuffer.playbuf("~/samp/drone_3.aiff".standardizePath);
		drone4 = CtkBuffer.playbuf("~/samp/drone_4.aiff".standardizePath);
		drone5 = CtkBuffer.playbuf("~/samp/drone_5.aiff".standardizePath);
		drone6 = CtkBuffer.playbuf("~/samp/drone_6.aiff".standardizePath);
		left = CtkBuffer.playbuf("~/samp/leftfinal.aiff".standardizePath);
		right = CtkBuffer.playbuf("~/samp/rightfinal.aiff".standardizePath);
		sub = CtkBuffer.playbuf("~/samp/subfinal.aiff".standardizePath);
		myBuffers = [drone1, drone2, drone3, drone4, drone5, drone6, left, right, sub];
		myBuffers.do({arg thisBuffer; thisBuffer.load;});
	 	s.sync;		 // and pause execution until the buffer is loaded
		"buffers added".postln;
	};
	
	score = CtkScore.new;

	// INITIALIZE GRAPHICS
	initGraphics = Routine ({
		// VISUAL PARAMETERS AND WINDOW
		var bgColor, doClear, fullScreen, count, bounds;
		count = 1000;
		bounds = Point.new(800, 800);
		bgColor = Color.black;
		doClear = true;
		fullScreen = true; // or windowed
		domain = Khora.new(count, bounds, bgColor, doClear, fullScreen);

		// INITIALIZE PARTICLES		
		for (0, 100, {|i|
			domain.animae = domain.animae.add(
				Anima.new(
					strat: \wrap,
					par: domain,
					pos: Point.new((domain.bounds.x/(domain.maxCnt+1))*(i), 50*i),
					vel: Point.new(0.15*i, 5),
					col: Color.red,
					vis: 0.1,
					siz: Point.new(40,40),
					styl: \circle,
					lif: 6400,
					indx: i
				);
			);
		});
	}, 2048);

	postCtl = Routine({
		inf.do{ 
			audCtl.do({arg ctl, i;
				ctl.get({arg bus, val;
					(i==0).if({"[ ".post;});
					l = val.round(0.001); 
					l.post;
					(i<5).if({", ".post;},{"]".postln;})});

			});
			"".postln;
			1.wait;
		};
	});
	
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
	
	
	// MANAGE SYNTHS
	playBuffer = CtkSynthDef(\monoPlayback, {arg buffer, chan = 0, startPos, rate = 1, mul = 1, pan, env;
		var src = PlayBuf.ar(1, buffer, rate * BufRateScale.kr(buffer),
			 1, // a trigger... ignore for now
			startPos * BufSampleRate.kr(buffer), // adjust startPos in sec to samples
			1 // loop, 0 is no, 1 is yes
			);
		Out.ar(chan, Pan2.ar((src * env)*mul, pan));
	});

	sineSynth = CtkSynthDef(\singrain, {arg freq, ratio, amp, dur, outbus, channel;
		Out.ar(channel,Ê
			SinOsc.ar((freq)*ratio, 0, amp)		)
	});
	
	blip = CtkSynthDef(\blipgen, {arg fundFreq, formFreq, bandWidth, room, mix, damp, amp, channel, ratio, env, mul = 1;
		var pulse, numharms, reson, rq, ampScale, reverb, out;
		rq = bandWidth/formFreq; 
		ampScale = 1/rq;
		numharms = (SampleRate.ir*0.4) / fundFreq*ratio;
		pulse = Blip.ar(fundFreq*ratio, numharms.floor, 1);
		reson = Resonz.ar((pulse), formFreq*ratio, rq, ampScale);
		reson = reson * mul;
		reverb = FreeVerb.ar(reson, mix, room, damp);
		out = Limiter.ar(reverb, 1.0, 0.01);
		Out.ar(channel, ((out*amp)*env));
	}, [0.1, 0.1]);
	
	
	initBuffers.();
	initGraphics.play(AppClock);
	animate.play(AppClock);
	
	score.add(playBuffer.note(0.1, drone2.duration) // Organ intro
	.buffer_(drone2).startPos_(0).rate_(1).pan_(0).mul_(midiCtl[0])
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));

	score.add(playBuffer.note(0.1, drone3.duration) // Organ Body Drone
	.buffer_(drone3).startPos_(0).rate_(1).pan_(0.2).mul_(midiCtl[1]) //.mul_(0.6)
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));
	
	score.add(playBuffer.note(0.1, drone4.duration) // Organ Solo and Wheeze
	.buffer_(drone4).startPos_(0).rate_(1).pan_(-0.9).mul_(midiCtl[2])
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));

	score.add(playBuffer.note(0.1, drone5.duration) // Bells and Horn
	.buffer_(drone5).startPos_(0).rate_(1).pan_(0.9).mul_(midiCtl[3])  //.mul_(1.5)
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));

	score.add(playBuffer.note(0.1, drone1.duration) // Organ Distorted
	.buffer_(drone1).startPos_(0).rate_(1).pan_(-0.2).mul_(midiCtl[4])
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));
	
	score.add(playBuffer.note(200, drone6.duration) // vocal Distorted
	.buffer_(drone6).startPos_(0).rate_(1).pan_(-0.2).mul_(midiCtl[5])
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));

	score.add(playBuffer.note(0.1, left.duration) // left synth
	.buffer_(left).startPos_(12).rate_(1).pan_(-1).mul_(midiCtl[6])
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));
	
	score.add(playBuffer.note(0.1, right.duration) // right synth
	.buffer_(right).startPos_(12).rate_(1).pan_(1).mul_(midiCtl[7])
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));

	score.add(playBuffer.note(0.1, sub.duration) // sub synth
	.buffer_(sub).startPos_(12).rate_(1).pan_(0).mul_(midiCtl[8]).chan_(2)
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));
	
	
	

//	score.add(blip.note(1, 400)
//	.fundFreq_(audCtl[2]).formFreq_(audCtl[3]).bandWidth_(audCtl[4])
//	.room_(audCtl[0]).mix_(audCtl[1]).damp_(audCtl[5])
//	.amp_(1).channel_(3).ratio_(ratios[2]).mul_(midiCtl[6])
//	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.01, 0.98, 0.01], \sin), timeScale: 400)));
//
//	score.add(blip.note(1, 400)
//	.fundFreq_(audCtl[2]).formFreq_(audCtl[3]).bandWidth_(audCtl[4])
//	.room_(audCtl[0]).mix_(audCtl[1]).damp_(audCtl[5])
//	.amp_(1).channel_(4).ratio_(ratios[1]).mul_(midiCtl[7])
//	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.01, 0.98, 0.01], \sin), timeScale: 400)));
//
//	score.add(blip.note(1, 400)
//	.fundFreq_(audCtl[2]).formFreq_(audCtl[3]).bandWidth_(audCtl[4])
//	.room_(audCtl[0]).mix_(audCtl[1]).damp_(audCtl[5])
//	.amp_(1).channel_(2).ratio_(ratios[0]).mul_(midiCtl[8])
//	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.01, 0.98, 0.01], \sin), timeScale: 400)));
//

	changeEnv = {
		var last, next;
		"changing envelopes".postln;
		
		changeEnvCnt = changeEnvCnt+1;
		last = audEnvList.removeAt(0);
		next = audEnvList.at(0);

		myAudEnvs.do({arg env, i;
			myAudEnvs[i] = if (changeEnvCnt%2==1, 
				{Env.new([last[i], next[i]],[1], \exp)},
				{Env.new([next[i], last[i]],[1], \exp)}
			);
			myAudEnvs[i].levels;
		});
	};	
	
	
	

// AUDIO ROUTINE	(Will convert to procmod)	
	aud = Routine ({
		changeEnv.();
		ratios[1].set(3);
		ratios[2].set(4);
		postCtl.play; // logging

		score.play;
		60.wait;

//		changeEnv.();
//		changeEnv.();
		ratios[1].set(1);
		ratios[2].set(1);
		30.wait;

		ratios[1].set(2);
		ratios[2].set(2);
		60.wait;

		ratios[1].set(3);
		90.wait;

		ratios[2].set(4);
		60.wait;

		ratios[1].set(5);
		ratios[2].set(5);
		40.wait;

		ratios[1].set(80);
		ratios[2].set(81);

		40.wait;
		ratios[1].set(3);
		ratios[2].set(4);



	}, 2048);



// ANIMATION ROUTINE
	vis = Routine({
		


	
		// FADE IN
		9.do{
			domain.animae.do({ arg part, j;
				part.visible = part.visible+0.05;
				0.05.wait;
			});
		};

		// CHANGE COLORS, ACCELERATE
		20.do{
			domain.animae.do({ arg part, j;
				0.05.coin.if({part.color = Color.rand(0.3, 0.9)});
				//part.size = part.size+2;
				//part.velocity = part.velocity + 2; 
			});
		0.5.wait;
		};

		10.do{
			domain.animae.do({ arg part, j;
				(part.position.y>200).and(part.position.y<600).if({part.strategy = \wave});
			});
			0.5.wait;
		};

		30.do{
			domain.animae.do({ arg part, j;
				part.size = part.size-1;
			});
			0.125.wait;
		};	
		
		for (0, 800, {|i|
			domain.animae = domain.animae.add(
				Anima.new(
					strat: \wave,
					par: domain,
					pos: Point.new(i*(domain.bounds.x/10), ((domain.bounds.y/2)+2*i )),
					vel: Point.new(0.15*i, 5),
					col: Color.rand(0.3,0.6),
					vis: 1/(i%4), // (i%16)/16,
					siz: Point.new(10,10),
					styl: \circle,
					lif: 6400,
					indx: i+100
				);
			);
		});
		
		20.wait;
				
		domain.userview.clearOnRefresh = false;
		
		
		domain.animae.do({ arg part, j;
			part.position = Point.new(j*(domain.bounds.x/10), ((domain.bounds.y/2)+2*j ));
			part.color = Color.rand;
			part.visible = 1/(j%4); // (j%16)/16
			part.strategy = \wave;
			part.size = Point.new(10,10);
			part.velocity =  Point.new(10,60);

		});
	
		60.wait;

		domain.animae.do({ arg part, j;
			part.position = Point.new(domain.bounds.x/2, j*(domain.bounds.y/100));
			part.velocity = Point.new(j%100,1);
			part.strategy = \spiral;
			part.size = Point.new(30,30);
		});


		domain.userview.clearOnRefresh = false;

		domain.animae.do({ arg part, j;
			var  topBound, botBound;
			part.color = Color.rand;
			topBound = domain.bounds.y/4;
			botBound = domain.bounds.y-topBound;
			part.position = Point.new(j*(domain.bounds.x/10), (topBound+ j*(botBound-topBound/100)));
			//part.color = Color.rand;
			part.visible = (j%15)/16;
			part.strategy = \wave;
			part.size = Point.new(5,5);
			(j%2==0).if({part.velocity =  Point.new(5,30)}, {part.velocity =  Point.new(-5,-30)});

		});


		
	},2048);
	
	vis.play(AppClock);
	aud.play();
	
	// CLEAN UP BUFFERS AND BUSES
	CmdPeriod.doOnce({
		domain.window.close;
		SerialPort.closeAll;
		myBuffers.do({arg thisBuffer; thisBuffer.free;});
		"buffer clear".postln;
		myBuses.do({arg thisBus; thisBus.free;});		"buses clear".postln;
		"Killed".postln;
	});
});
)   