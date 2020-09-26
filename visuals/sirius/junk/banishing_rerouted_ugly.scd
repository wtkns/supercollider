(
var score, blipgen, blipOut, moogy, moogOut, globalReverb, globalEffects, myBuses;

~pieceLength = 1800; // *(1/30) = 60 seconds
~width = 1000;
~height = 800;
~count = 200;
~domain = Khora.new(xDom: ~width, yDom: ~height);
~animae = List.new(~count);
~ctl = 2.collect({CtkControl.play});

thisThread.randSeed_(120);
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);
s.boot;
s.waitForBoot({
//	s.scope;
//	f = FreqScope.new; 


	// Buses
	blipOut = CtkAudio.new(server: s);
	moogOut = CtkAudio.new(server: s);
	globalEffects = CtkAudio.new(server: s);
	blipOut.bus.postln;
	myBuses = [blipOut, moogOut, globalEffects];
	
	globalReverb = CtkSynthDef(\reverb,{arg pan = 0;
		var src, filter;
		src = In.ar(globalEffects);
		filter = FreeVerb.ar(src,0.5,0.25,0.5);
		Out.ar(0, Pan2.ar(filter, 0, 0.8));
	});	

	// Blip Generator		
	blipgen = CtkSynthDef(\blipgen, {arg env, freq, numharms, dur, outbus;
		Out.ar(outbus, Blip.ar(freq, numharms, env))
	});
	
	// Moog filter
	moogy = CtkSynthDef(\moogy, {arg pan, env, amp = 1, dur, outbus, inbus;
		var src, filter;
		src = In.ar(inbus);
		filter = MoogFF.ar(src,SinOsc.kr(LFNoise0.kr(0.42).range(0.001,2.2)).range(30,4200), 0.83 * 4);
	 	Out.ar(outbus, Pan2.ar(filter, pan, env));
	 });

	score = CtkScore.new;

		score.add(blipgen.note
			(0.1, 66.0, addAction: \head,  target: 1)
			.freq_(~ctl[0])
			.numharms_(~ctl[1])
			// .freq_(CtkControl.env(Env([1, 100 ], [1.0], \exp), timeScale: 66)) 
			//.numharms_(CtkControl.env(Env([30, 100], [1.0], \exp), timeScale: 66))
			.env_(CtkControl.env(Env([0.01, 1, 1, 0.01], [0.05, 0.95, 0.05], \lin), timeScale: 66))
			.dur_(66)
			.outbus_(blipOut)
		); 

	10.do({arg i;		
		score.add(moogy.note
			(0.1, 66, addAction: \tail, target: 1) 
			.inbus_(blipOut)
			.pan_(CtkControl.env(Env([-0.8, 0.8, 0], [0.2, 0.8], \lin), timeScale: 22))
			.env_(CtkControl.env(Env([0.01, 1, 1, 0.01], [0.05, 0.9, 0.05], \lin), timeScale: 22))
			.dur_(22)
			.amp_(0.8)
			.outbus_(globalEffects)
		);
	});
	

		score.add(globalReverb.note
			(0.1, 66.0, addAction: \tail,  target: 1)
		); 



	});


// VISUALS
	
	r = Routine.new({
		var distY, distX, xCenter, yCenter;
		xCenter = ~width/2;
		yCenter = ~height/2;
		distX = ~width/~count;
		distY = ~height/~count;
		
		// BARS: GENERATE 
		// populate animae with ~count objects of initial state
		for (0, ~count, {arg i; 
			~animae = ~animae.add(
				Anima.new(
					xPos: xCenter, 
					yPos: i*distY,  
					yVel: 5, 
					xVel: i%500, 
					col: Color.new255(i%100*2.5, i%250, i%25*10,  0), 
					sizX: 10, 
					sizY: 100,  
					strtgy:Wave2, 
					sndParam:Drone));
		});
	

		// BARS:  FADE IN

		score.play;
		~ctl[0].set(0);
		~ctl[1].set(0);

		for (0, ~pieceLength/32, {arg x;          // length of fade
			for (0, ~animae.size-1, {arg i; 
				~animae[i].color = Color.new255(i%100*2.5, i%250, i%25*10, x/(~pieceLength/32)*i%100);
				~animae[i].move;
			});

			~ctl[0].set(x);
			~ctl[1].set(x);
			
			(1/30).wait;
			~userview.refresh;
		
		});
		
		// insert fade
		
		// BARS:  PLAY STATE
		for (0, ~pieceLength/8, {arg x;
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].move;
			});

			~ctl[0].set(x);
			~ctl[1].set(x);

			(1/30).wait;
			~userview.refresh;	
		});
			
		
		
		//SQUARES Transition
			
		for (0, ~pieceLength/32, {arg x;
			for (0, ~animae.size-1, {arg i; // size transition
				~animae[i].size.x = ~animae[i].size.x+2.5;
//				~animae[i].velocity.x = ~animae[i].velocity.x;
				~animae[i].move;
			});

			~ctl[0].set(~animae[0].size.x);
			~ctl[1].set(x);

			(1/30).wait;
			~userview.refresh;	

		});

		// SQUARES:  PLAY STATE 
		for (0, ~pieceLength/8, {arg x;
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].move;
				~animae[i].velocity.y = ~animae[i].velocity.y+1; 
				~animae[i].velocity.x = ~animae[i].velocity.x - (~animae[i].velocity.x*(x/~pieceLength/8)) ; // slow X
				~animae[i].color = Color.new255(i%100*2.5, i%250, i%25*10, (1-(x/(~pieceLength/8)))*(i%100)); // fade out

			});

			(1/30).wait;

			~ctl[0].set(~animae[1].velocity.y+1;);
			~ctl[1].set(~animae[1].velocity.x+1;);

			~userview.refresh;	
		});
		

		 ~animae.clear;

		// WAVE 2: little squares
		for (0, ~count, {arg i; 
			~animae = ~animae.add(
				Anima.new(
					xPos: xCenter,
					yPos: i*distY, 
					yVel: 0, 
					xVel: i%~height+20, 
					col: Color.new255(i-50%100*2.5+50, i%250, i%25*10, 50), 
					sizX: 10, 
					sizY: 10, 
					strtgy:Wave2, 
					sndParam:Drone));
		});

		for (0, ~pieceLength/8, {arg x;   //  keep playing state
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].move;
			});

			~ctl[0].set(~animae[0].position.y);
			~ctl[1].set(x);

			(1/30).wait;
			~userview.refresh;	
		});

		for (0, ~pieceLength/32, {arg x;   //  resize
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].size = ~animae[i].size+0.5;
				~animae[i].move;
			});

			(1/30).wait;
			~userview.refresh;	
		});

		for (0, ~pieceLength/8, {arg x;   // play state
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].color = Color.new255(i%100*2.5, i%250, i%25*10, (1-(x/(~pieceLength/8)))*(i%100)); // fade out
				~animae[i].move;
			});

			(1/30).wait;
			~userview.refresh;	
		});
		


		 ~animae.clear;

		//    PART 2					
		for (0, ~count, {arg i; 
			~animae = ~animae.add(
				Anima.new(
					xPos: xCenter, 
					yPos: i*distY, 
					yVel: 0, 
					xVel: i%~height+20, 
					col: Color.new255(i%100*2.5, i%250, i%25*10, 50), 
					sizX: 10, 
					sizY: 10,  
					strtgy:Wave, 
					sndParam:Drone));
		});
	 
							
		///
		// CIRCLES
		
		~userview.drawFunc= { // switch to circles
			for (0, ~animae.size-1,{arg i; 
				Pen.fillColor = ~animae[i].color;
				Pen.fillOval(Rect(~animae[i].position.x, ~animae[i].position.y,
										 ~animae[i].size.x, ~animae[i].size.y));			
				});
		};
		
		for (0, ~pieceLength/32, {arg x;
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].size.x = (x/(~pieceLength/32)*50);
				~animae[i].size.y = (x/(~pieceLength/32)*50);
				~animae[i].velocity.x = ~animae[i].velocity.x - 2.5;
				~animae[i].move;
			});

			(1/30).wait;
			~userview.refresh;	
		});

		for (0, ~pieceLength/8, {
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].move;
			});

			(1/30).wait;
			~userview.refresh;	
		});


		for (0, ~pieceLength/32, {
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].size.x = ~animae[i].size.x+1;
				~animae[i].size.y = ~animae[i].size.y+1;
				~animae[i].velocity.x = ~animae[i].velocity.x - 2.5;
				~animae[i].move;
			});

			(1/30).wait;
			~userview.refresh;	
		});
		
		for (0, ~animae.size-1, {arg i;
				~animae[i].strategy = Wave2;

			});

		for (0, ~pieceLength/4, {
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].velocity.x = ~animae[i].velocity.x-5;
				~animae[i].velocity.y = ~animae[i].velocity.y/2;

				~animae[i].move;
			});

			(1/30).wait;
			~userview.refresh;	
		});
	
	}, 2048);	
	r.play(AppClock);
})
)