(
var count, domain, bounds, bgColor, doClear, pieceLength;
var port, portName, data; 
var ferryGrain, note, ctl, sndBuffer;

// declare mapping envelopes
var grainFreqEnv, grainPeriodEnv;
grainFreqEnv = Env.new([1, 20, 100],[0.5, 0.5], \exp);
grainPeriodEnv = Env.new([0.01, 10],[1], \exp);
data= Array.with(0.001,0.001,0.001,0.001,0.001,0.001);

// set up empty array of CtkControls
ctl = 6.collect({CtkControl.play(initVal: 0.001)}); // initval prevents divide by zero when everything is getting started

// open serial port. double check "tty.usbserial" and baud rate
portName= SerialPort.devices.detect{|x| x.contains("tty.usbserial")}; 
if(portName.notNil, { 
	port= SerialPort(portName, 57600, crtscts: false); 
	("connected to"+portName).inform; 
}, { 
	"no port with name tty.usbserial found".inform; 
}); 


thisThread.randSeed_(120);
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);
s.boot;
s.waitForBoot({
		sndBuffer = CtkBuffer.playbuf("/Users/jameswatkins/dx461-au11-james/FerryStudy/ferry.aiff");
		sndBuffer.load;
		s.sync;

	
	// CtkSynthDef with all relevant parameters
	ferryGrain = CtkSynthDef(\periodic, {arg duration, grainFreq, grainPeriod, grainAmp, sndBuffer;
			var grains, env, freq, trigger, pan, rate, pos, out, ctrl;
			env = EnvGen.kr(Env([0, 1, 1, 0], [0.3, 0.4, 0.3], \sin), timeScale: duration);
			// create overlaps
			trigger = Impulse.ar(grainFreq);
			rate = LFNoise2.kr(0.1).range(0.707, 1.3);
			pos = LFNoise1.kr(2).range(0, 1);
			pan = WhiteNoise.ar * EnvGen.kr(Env([0, 1, 0], [0.5, 0.5], [5, -5]), timeScale: duration);
			grains = GrainBuf.ar(2, trigger, grainPeriod, sndBuffer, rate, pos, 4, pan);
			out = grains;
	Out.ar(0, out);
			} , [0.1, 0.1]);
	
	// repeating routine to read values from serial port
	Routine.run({ 
		var byte, index= 0, payload= Array.newClear(14); 
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
									 // convert to numbers between 1/1024 and 1
									data[i]= (((payload[i*2]<<2)+payload[i*2+1] +1 ) /1024).round(0.01);
								}; 

								//--move data into an ctk control array 
								data.postln;
								ctl[0].set(data[0]);   // Room   
								ctl[1].set(data[1]);    // damp
								ctl[2].set(grainFreqEnv[data[2]]);   // fundFreq mapped against envelope
								ctl[3].set(grainPeriodEnv[data[3]] );   // formFreq mapped against envelope
								ctl[4].set(data[4] );  //  bandWidth mapped against envelope
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

	pieceLength = 1800;
	count = 50; 
	bounds = Point.new(1000, 800);
	bgColor = Color.black;
	doClear = true;
	
	// initialize window
	domain = Khora.new(count, bounds, bgColor, doClear);
	
	// start particles
	r = Routine.new({

		// start note to activate ctkControl
	note = ferryGrain.note().duration_(200).grainFreq_(ctl[2]).grainPeriod_(ctl[3]).grainAmp_(-12.dbamp).sndBuffer_(sndBuffer).play;
	
	1.wait;
	
	// initialize particles
		for (0, count, {|i|
			domain.animae = domain.animae.add(
				Anima.new(
					strat: \rotate,
					par: domain,
					pos: Point.new(domain.bounds.x/2, i*(domain.bounds.y/count)),
					vel: Point.new(i%500,5),
					col: Color.new255(i%100*2.5, i%250, i%25*10, 255),
					vis: i/count,
					siz: Point.new(10,100),
					styl: \rectangle,
					lif: i*10,
					indx: i
				)
			);
		});	
	
	// part 1:
		for (0, pieceLength, {|i|
			
			domain.animae.do({ arg part, j;
				part.move;
				part.size = Point.new(5+(data[2]*100), 5+(data[3]*100));
				part.velocity = Point.new(j%500,5) + Point.new(1+(data[2]*100), 1+(data[3]*100));
				part.visible = data[1];
			});

			// housekeeping
			domain.animae.do({ arg part, j;
//				if (part.age>part.life, {domain.animae.removeAt(j)});
			});
			
			domain.userview.refresh;
			(1/30).wait;
		});
			
	}, 2048);	
		r.play(AppClock);
});		

// close all of the serial ports with CmdPeriod
CmdPeriod.doOnce({SerialPort.closeAll});

)