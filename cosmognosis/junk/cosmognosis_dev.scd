(
var port, portName, audCtl, visCtl; // arduino stuff
var resp, midiCtl; //Midi Stuff

var blip, sineSynth, playBuffer; // CTK Synths 
var initGraphics, initBuffers, initAnimae, initAnimate; // procmods
var drone1, drone2, drone3, drone4, drone5, drone6; //Buffers
var myBuffers, myBuses, myAudEnvs; // Collections
var audEnvList, changeEnvCnt;

// Mapping envelopes
var fundFreqEnv, formFreqEnv, bandWidthEnv, freqEnv, roomEnv, dampEnv, mixEnv; 
var xSizeEnv, ySizeEnv, xVelocityEnv, yVelocityEnv, colorEnv, visibilityEnv;

var  animate, domain, score, changeEnv; // routines
var sineProc, pevents;
var midRecipr = 127.reciprocal;
var ardRecipr = 1024.reciprocal;

// OPEN SERIAL PORT
// double check "tty.usbserial" and baud rate
portName= SerialPort.devices.detect{|x| x.contains("tty.usbserial")}; 
if(portName.notNil, { 
	port= SerialPort(portName, 57600, crtscts: false); 
	("connected to"+portName).inform; 
}, { 
	"no port with name tty.usbserial found".inform; 
}); 


// DECLARE MAPPING ENVELOPES 
// Audio
roomEnv = Env.new([0.001, 1],[1], \sin);
dampEnv = Env.new([0.001, 1],[1], \sin);
fundFreqEnv = Env.new([0.1, 1000],[1], \sin);
formFreqEnv = Env.new([20, 5000],[1], \sin);
bandWidthEnv = Env.new([0.5, 100],[1], \sin);
mixEnv = Env.new([0.001, 1],[1], \sin);

// Graphics
xSizeEnv = Env.new([1, 1],[1], \sin);
ySizeEnv = Env.new([1, 1],[1], \sin);
xVelocityEnv = Env.new([1, 1],[1], \sin);
yVelocityEnv = Env.new([1, 1],[1], \sin);
colorEnv = Env.new([1, 1],[1], \sin);
visibilityEnv = Env.new([1, 1],[1], \sin);

myAudEnvs = [roomEnv, dampEnv, fundFreqEnv, formFreqEnv, bandWidthEnv, mixEnv];
changeEnvCnt = 0;
audEnvList = List.with( 
	[0.1, 1, 0.1, 300, 10, 0.5],
	[1, 0.1, 100, 30, 20, 0.1],
	[0.9, 0.2, 1000, 100, 100, 0.2],
	[0.5, 0.3, 750, 200, 100, 0.3],
	[0.25, 0.4, 400, 800, 40, 0.4],
	[0.1, 0.5, 250, 14000, 5, 0.5]
);

// Initialize arrays of ctk controls:
midiCtl = 17.collect({CtkControl.play(initVal: 0.5)}); // initval prevents divide by zero
audCtl = 6.collect({CtkControl.play(initVal: 0.01)}); 
visCtl = 6.collect({CtkControl.play(initVal: 0.01)}); 

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
							audCtl[0].set(roomEnv[data[0]]);   // Room 
							visCtl[0].set(colorEnv[data[0]]);   // Room
							
							audCtl[1].set(dampEnv[data[1]]);    // damp
							visCtl[1].set(visibilityEnv[data[1]]);   // Room
							
							audCtl[2].set(fundFreqEnv[data[2]]);   // fundFreq 
							visCtl[2].set(xSizeEnv[data[2]]);   // Room
							
							audCtl[3].set(formFreqEnv[data[3]] );   // formFreq
							visCtl[3].set(ySizeEnv[data[3]]);   // Room
							
							audCtl[4].set(bandWidthEnv[data[4]] );  // bandWidth envelope
							visCtl[4].set(xVelocityEnv[data[4]]);   // Room
							
							audCtl[5].set(mixEnv[data[5]]);   //~mix
							visCtl[5].set(yVelocityEnv[data[5]]);   // Room
							
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
	// s.scope;
	// s.freqscope;

	initBuffers = {	
		// MANAGE BUFFERS
		drone1 = CtkBuffer.playbuf("~/samp/drone_1.aiff".standardizePath);
		drone2 = CtkBuffer.playbuf("~/samp/drone_2.aiff".standardizePath);
		drone3 = CtkBuffer.playbuf("~/samp/drone_3.aiff".standardizePath);
		drone4 = CtkBuffer.playbuf("~/samp/drone_4.aiff".standardizePath);
		drone5 = CtkBuffer.playbuf("~/samp/drone_5.aiff".standardizePath);
		drone6 = CtkBuffer.playbuf("~/samp/drone_6.aiff".standardizePath);
		myBuffers = [drone1, drone2, drone3, drone4, drone5, drone6];
		myBuffers.do({arg thisBuffer; thisBuffer.load;});
	 	s.sync;		 // and pause execution until the buffer is loaded
		"buffers added".postln;
	};
	
	score = CtkScore.new;

	// INITIALIZE GRAPHICS
	initGraphics = Routine ({
		// VISUAL PARAMETERS AND WINDOW
		var bgColor, doClear, fullScreen, count, bounds;
		count = 100;
		bounds = Point.new(800, 800);
		bgColor = Color.black;
		doClear = true;
		fullScreen = false; // or windowed
		domain = Khora.new(count, bounds, bgColor, doClear, fullScreen);

		// INITIALIZE PARTICLES		
		for (0, domain.maxCnt, {|i|
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
	
	animate = Routine({
		// PART I
		// "part I".postln;
		inf.do{ 
			//i.postln;  // to find timing
			domain.animae.do({ arg part, j;
				part.move;
			});
			domain.userview.refresh;
			(1/30).wait;
			
//			audCtl.do({arg ctl, i;
//				// "[".postln; // weird, out of sync
//   				ctl.get({arg bus, val; l = val.round(0.001); l.post; (i<5).if({", ".post;},{"]".postln;})});
//			});
//			"".postln;

			formFreqEnv.levels.postln;

		};
	}, 2048);	
	
	// MANAGE SYNTHS
	playBuffer = CtkSynthDef(\monoPlayback, {arg buffer, startPos, rate = 1, mul = 1, pan, env;
		var src = PlayBuf.ar(1, buffer, rate * BufRateScale.kr(buffer),
			 1, // a trigger... ignore for now
			startPos * BufSampleRate.kr(buffer), // adjust startPos in sec to samples
			1 // loop, 0 is no, 1 is yes
			);
		Out.ar(0, Pan2.ar((src * env)*mul, pan));
	});

	sineSynth = CtkSynthDef(\singrain, {arg freq, ratio, amp, dur, outbus, channel;
		Out.ar(channel,Ê
			SinOsc.ar((freq)*ratio, 0, amp)		)
	});
	
	blip = CtkSynthDef(\blipgen, {arg fundFreq, formFreq, bandWidth, room, mix, damp, amp, channel, ratio, env;
		var pulse, numharms, reson, rq, ampScale, reverb, out;
		rq = bandWidth/formFreq; 
		ampScale = 1/rq;
		numharms = (SampleRate.ir*0.4) / fundFreq*ratio;
		pulse = Blip.ar(fundFreq*ratio, numharms.floor, 1);
		reson = Resonz.ar((pulse), formFreq*ratio, rq, ampScale);
		reverb = FreeVerb.ar(reson, mix, room, damp);
		out = Limiter.ar(reverb, 1.0, 0.01);
		//RecordBuf.ar(out, buffer);
		Out.ar(channel, (out*amp)*env );
	}, [0.1, 0.1]);
	
	
	initBuffers.();
	initGraphics.play(AppClock);
	animate.play(AppClock);
	
	score.add(playBuffer.note(0.1, drone1.duration)
	.buffer_(drone1).startPos_(0).rate_(1).pan_(-0.2)
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));
	
	score.add(playBuffer.note(0.1, drone2.duration)
	.buffer_(drone2).startPos_(0).rate_(1).pan_(0)
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));
	
	score.add(playBuffer.note(0.1, drone3.duration)
	.buffer_(drone3).startPos_(0).rate_(1).pan_(0.2).mul_(0.6)
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));
	
	score.add(playBuffer.note(0.1, drone4.duration)
	.buffer_(drone4).startPos_(0).rate_(1).pan_(-0.9)
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));
	
	score.add(playBuffer.note(0.1, drone5.duration)
	.buffer_(drone5).startPos_(0).rate_(1).pan_(0.9).mul_(1.5)
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.1, 0.98, 0.1], \sin), timeScale: 390)));

	score.add(blip.note(1, 300)
	.fundFreq_(audCtl[2]).formFreq_(audCtl[3]).bandWidth_(audCtl[4])
	.room_(audCtl[0]).mix_(audCtl[1]).damp_(audCtl[5])
	.amp_(1).channel_(0).ratio_(3)
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.25, 0.5, 0.25], \sin), timeScale: 300)));

	score.add(blip.note(1, 300)
	.fundFreq_(audCtl[2]).formFreq_(audCtl[3]).bandWidth_(audCtl[4])
	.room_(audCtl[0]).mix_(audCtl[1]).damp_(audCtl[5])
	.amp_(1).channel_(1).ratio_(4)
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.25, 0.5, 0.25], \sin), timeScale: 300)));

	score.add(blip.note(1, 300)
	.fundFreq_(audCtl[2]).formFreq_(audCtl[3]).bandWidth_(audCtl[4])
	.room_(audCtl[0]).mix_(audCtl[1]).damp_(audCtl[5])
	.amp_(1).channel_(2).ratio_(1)
	.env_(CtkControl.env(Env([0.1, 1, 1, 0.1], [0.25, 0.5, 0.25], \sin), timeScale: 300)));


	changeEnv = {
		var last, next;
		"changing envelopes".postln;
		
		changeEnvCnt = changeEnvCnt+1;
		last = audEnvList.removeAt(0);
		next = audEnvList.at(0);

		myAudEnvs.do({arg env, i;
			myAudEnvs[i] = if (changeEnvCnt%2==1, 
				{Env.new([last[i], next[i]],[1], \sin)},
				{Env.new([next[i], last[i]],[1], \sin)}
			);
		});
	};	
		
	score.play;


	r = Routine({

		changeEnv.();
		3.wait; 

		changeEnv.();
		3.wait; 

		changeEnv.();
		3.wait; 

		changeEnv.();
		3.wait; 
//
//		changeEnv.();
//		myAudEnvs.do({arg env, i;
//			myAudEnvs[i].levels.postln;
//		});
//
//		changeEnv.();
//		myAudEnvs.do({arg env, i;
//			myAudEnvs[i].levels.postln;
//		});
//
//		changeEnv.();
//		myAudEnvs.do({arg env, i;
//			myAudEnvs[i].levels.postln;
//		});

//
//		9.do{
//			domain.animae.do({ arg part, j;
//				part.visible = part.visible+0.05;
//				0.05.wait;
//			});
//		};
//
//		changeEnv.value();
//		
//		20.do{
//			domain.animae.do({ arg part, j;
//				part.size = part.size+2;
//				0.05.coin.if({part.color = Color.rand;});
//				part.velocity = part.velocity + 2; 
//			});
//		0.5.wait;
//		};
//
//		changeEnv.value();
//
//		domain.animae.do({ arg part, j;
//				part.strategy = \spiral; 
//			});
//
//		changeEnv.value();
//
//		domain.animae.do({ arg part, j;
//			part.visible = 1;
//			part.position = Point.new(domain.bounds.x/2, j*(domain.bounds.y/100));
//			part.velocity = Point.new(j%100,1);
//			part.strategy = \spiral;
//			part.size = Point.new(10,10);
//
//		});
//
//		fundFreqEnv = Env.new([10, 100],[1], \exp);
		
	},2048);
	
	r.play(AppClock);
			

	

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