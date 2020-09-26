(
var animae, window,userview;

~pieceLength = 500; // * .05 seconds  (+/-3mins)
~width = 1000;
~height = 800;
~count = 200;

window = Window("window", Rect(100, 50, ~width, ~height ), false);
userview = UserView(window, Rect(0, 0, ~width, ~height));
userview.clearOnRefresh= true;
userview.background= Color.black;
window.onClose= {};
window.front;
		
userview.drawFunc= {
			for (0, ~animae.size-1,{arg i; 
				Pen.fillColor = ~animae[i].color;
				Pen.fillRect(Rect(~animae[i].position.x, ~animae[i].position.y, ~animae[i].size.x, ~animae[i].size.y));			});
};

~animae = Array.new(~count);
thisThread.randSeed_(120);
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);
s.boot;
s.waitForBoot({
	s.scope;
	
	r = Routine.new({
		var distY, xCenter;
		xCenter = ~width/2;
		distY = ~height/~count;
		for (0, ~count-1, {arg i; 
			~animae = ~animae.add(Anima.new(xPos: xCenter, yPos: i*distY,  yVel: 5, xVel: i%500, col: Color.new255(i%100*2.5, i%250, i%25*10, 50), sizX: 100, sizY: 10,  strtgy:Wave, sndParam:Drone));
		});
		
		for (0, ~pieceLength, {
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].move;
				//~animae[i].size = ~animae[i].size - 5; 
				//~animae[i].velocity.x = ~animae[i].velocity.x - 5; 
			});

			(1/30).wait;
			userview.refresh;	
		});
	}, 2048);	
	r.play(AppClock);
})
)