(
var pieceLength, domain, conductor, animae, width, height, count;

pieceLength = 1400; // * .05 seconds  (+/-3mins)
width = 1000;
height = 1000;
count = 1000;
domain = Khora.new(xDom: width, yDom: height);
~animae = Array.new(count);
thisThread.randSeed_(120);
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);
s.boot;
s.waitForBoot({
	s.scope;
	
	r = Routine.new({
		var locY, distX;
		locY = width/2;
		distX = width/count;
		for (0, count, {arg i; 
			~animae = ~animae.add(Anima.new(yPos: i*distX , xPos: locY, yVel: 0.5, xVel: i%500+10, strtgy:Wave, sndParam:Drone));
		});
		
		for (0, pieceLength, {
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].move;
			});

			(1/100).wait;
			~userview.refresh;	
		});
	}, 2048);	
	r.play(AppClock);
})
)