(
var pevents; // CTK Synths 
var initGraphics,  initAnimae, initAnimate; // procmods
var graphics, animae, animate, domain; // routines

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
	});
	
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
	});
	
	// MANAGE PROCMODS
	
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


		/* 3 */		
		[ // release ev0b
			nil,
			[\evGa, \evGb, \evGc]
		]
	], 0.dbamp, id: "test");
	
	pevents.showPMGUIs = true; 
	pevents.perfGUI;			

	// CLEAN UP BUFFERS AND BUSES
	CmdPeriod.doOnce({
		domain.window.close;
		"Killed".postln;
	});
});
)