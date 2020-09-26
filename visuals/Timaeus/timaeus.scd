(
var pieceLength, domain, conductor, animae;

pieceLength = 1400; // * .05 seconds  (+/-3mins)
domain = Khora.new(xDom: 500, yDom: 1000);
~animae = Array.new(50);

thisThread.randSeed_(120);
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);

s.boot;
s.waitForBoot({
	//s.scope;
	r = Routine.new({
		for (0, 50, {arg i; 
			~animae = ~animae.add(Anima.new(xVel: 15.rand2, yVel: 15.rand2, strtgy:Drift, sndParam:Click));
		});
		
		for (0, pieceLength, {
			
			for (0, ~animae.size-1, {arg i;
				
				if ( (~animae[i].age == (150)),
					{~animae[i].strategy = Bounce;
				});

				if ( (~animae[i].age == (300)),
					{~animae[i].strategy = Drift;
					~animae[i].soundParameters = Drone; 				});

				if ( (~animae[i].age == (450)),
					{~animae[i].strategy = Center;
					~animae[i].soundParameters = Click; 				});

				if ( (~animae[i].age == (500)),
					{~animae[i].strategy = Fall;
					~animae[i].soundParameters = Drone; 				});				

				if ( (~animae[i].age == (600)),
					{~animae[i].strategy = Rise;
					~animae[i].soundParameters = Drone; 				});	
					
				if ( (~animae[i].age == (700)),
					{~animae[i].strategy = Bounce;
					~animae[i].soundParameters = [Drone, Click].choose; 				});

				if ( (~animae[i].age == (850)),
					{~animae[i].strategy = Center; 				});				

				if ( (~animae[i].age == (900)),
					{~animae[i].strategy = Bounce;				});

				if ( (~animae[i].age == (1000)),
					{~animae[i].strategy = Swirl;
					~animae[i].soundParameters = [Drone, Click].choose; 				});

				if ( (~animae[i].age == 1100),
					{~animae[i].strategy = Rise; 				});
					
				if ( (~animae[i].age == (1250)),
					{~animae[i].strategy = Center; 				});	
				~animae[i].move;
			});

			(1/20).wait;
			~userview.refresh;	
		});
	}, 2048);	
	r.play(AppClock);
})
)