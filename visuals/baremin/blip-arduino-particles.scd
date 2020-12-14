(
var count, domain, bounds, bgColor, doClear, pieceLength;
var port, portName; 
var blip, note, ctl;

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


thisThread.randSeed_(120);
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);
s.boot;
s.waitForBoot({
	
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
									 // convert to numbers between 1/1024 and 1
									data[i]= ((payload[i*2]<<2)+payload[i*2+1] +1 ) /1024;
								}; 

								//--move data into an ctk control array 
								// data.postln;
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

	pieceLength = 1800;
	count = 200; 
	bounds = Point.new(1000, 800);
	bgColor = Color.black;
	doClear = true;
	
	// initialize window
	domain = Khora.new(count, bounds, bgColor, doClear);
	
	// start particles
	r = Routine.new({

		// start note to activate ctkControl
	note = blip.note().fundFreq_(ctl[2]).formFreq_(ctl[3]).bandWidth_(ctl[4]).room_(ctl[0]).damp_(ctl[1]).mix_(ctl[5]).play;
	
	// initialize particles
		for (0, count, {|i|
			domain.animae = domain.animae.add(
				Anima.new(
					strat: \wrap,
					par: domain,
					pos: Point.new(domain.bounds.x/2, i*(domain.bounds.y/count)),
					vel: Point.new(i%500,5),
					col: Color.new255(i%100*2.5, i%250, i%25*10,  100),
					siz: Point.new(10,100),
					styl: \circle
				)
			);
		});	
	
	// part 1:
		for (0, pieceLength, {|i|
			for (0, domain.animae.size-1, {|j|
				domain.animae[j].move;
			});
			(1/30).wait;
			domain.userview.refresh;
		});
			
	}, 2048);	
		r.play(AppClock);
});		

// close all of the serial ports with CmdPeriod
CmdPeriod.doOnce({SerialPort.closeAll});

)