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

//// MANAGE MIDI
//MIDIClient.init;
//MIDIIn.connectAll;
//
//// start the responders and feed midi data to CTK Controls on midiCtl[]
//resp = Array.fill(26, {arg i;
//	CCResponder({ |src,chan,num,value|
//		value.postln;
//		midiCtl[i].set(value * midRecipr); // 0-1
//	},
//	nil, // any source
//	nil, // any channel
//	i+1, // cc start with #1
//	nil // any value
//	);
//});

//// READ FROM ARDUINO
//// repeating routine to read values from serial port
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

	score = CtkScore.new;

	// INITIALIZE GRAPHICS
	initGraphics = Routine ({
		// VISUAL PARAMETERS AND WINDOW
		var bgColor, doClear, fullScreen, count, bounds;
		count = 1000;
		bounds = Point.new(800, 800);
		bgColor = Color.black;
		doClear = true;
		fullScreen = false; // or windowed
		domain = Khora.new(count, bounds, bgColor, doClear, fullScreen);

		// INITIALIZE PARTICLES
		for (0, 500, {|i|
			domain.animae = domain.animae.add(
				Anima.new(
					strat: \wrap,
					par: domain,
					pos: Point.new((domain.bounds.x/(domain.maxCnt+1))*(i), 50*i),
					vel: Point.new(0.15*i, 5),
					col: Color.red,
					vis: 0.5,
					siz: Point.new(20,20),
					styl: \circle,
					lif: 6400,
					indx: i
				);
			);
		});
	}, 2048);

	postCtl = Routine({
		inf.do{
			visCtl.do({arg ctl, i;
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
			(1/60).wait;
		};
	}, 2048);

	initBuffers.();
	initGraphics.play(AppClock);
	animate.play(AppClock);



// ANIMATION ROUTINE
	vis = Routine({

		var center = Point.new(domain.bounds.x/2,domain.bounds.y/2);

		// // FADE IN
		// 4.do{
		// 	domain.animae.do({ arg part, j;
		// 		part.visible = part.visible+0.15;
		// 		0.05.wait;
		// 	});
		// };

		// STAR TUNNEL
		domain.userview.clearOnRefresh = true;

		domain.animae.do({ arg part, j;
			part.strategy = \spiral;
			part.color = Color.rand;
			part.velocity.x =  0.005;
			part.visible = 0.75;
		});

		45.wait;



	},2048);

	vis.play(AppClock);
	//aud.play();

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