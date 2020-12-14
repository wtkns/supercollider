(
~pieceLength = 1800; // 60 seconds  (+/-3mins)
~width = 1000;
~height = 800;
~count = 200;
~domain = Khora.new(xDom: ~width, yDom: ~height);
~animae = List.new(~count);

thisThread.randSeed_(120);
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);
s.boot;
s.waitForBoot({
	//s.scope;
	
	r = Routine.new({
		var distY, xCenter;
		xCenter = ~width/2;
		distY = ~height/~count;

		
		// BARS: GENERATE 
		// initial state
		for (0, ~count, {arg i; 
			~animae = ~animae.add(Anima.new(xPos: xCenter, yPos: i*distY,  yVel: 5, xVel: i%500, 
			col: Color.new255(i%100*2.5, i%250, i%25*10,  i%100), sizX: 10, sizY: 100,  strtgy:Wave2, sndParam:Drone));
		});
	

		// BARS:  FADE IN
		for (0, ~pieceLength/64, {arg x;
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].move;
			});

			(1/30).wait;
			~userview.refresh;	
		});
		
		// insert fade
		
		// BARS:  PLAY STATE
		for (0, ~pieceLength/8, {arg x;
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].move;
			});

			(1/30).wait;
			~userview.refresh;	
		});
			
		
		
		//SQUARES Transition
			
		for (0, ~pieceLength/64, {arg x;
			for (0, ~animae.size-1, {arg i; // size transition
				~animae[i].size.x = ~animae[i].size.x+2.5;
//				~animae[i].velocity.x = ~animae[i].velocity.x;
				~animae[i].move;
			});
			
			(1/30).wait;
			~userview.refresh;	

		});

		// SQUARES 
		for (0, ~pieceLength/64, {arg x;
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].move;
				~animae[i].velocity.x = ~animae[i].velocity.x+1;
			});

			(1/30).wait;
			~userview.refresh;	
		});
		

		 ~animae.clear;

		// WAVE 2: little squares
		for (0, ~count, {arg i; 
			~animae = ~animae.add(Anima.new(xPos: xCenter, yPos: i*distY,  yVel: 0, xVel: i%~height+20, 
			col: Color.new255(i-50%100*2.5+50, i%250, i%25*10, 50), sizX: 10, sizY: 10,  strtgy:Wave2, sndParam:Drone));
		});

		for (0, ~pieceLength/8, {arg x;   //  keep playing state
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].move;
			});

			(1/30).wait;
			~userview.refresh;	
		});

		for (0, ~pieceLength/32, {arg x;   //  keep playing state
			
			for (0, ~animae.size-1, {arg i;
				~animae[i].size = ~animae[i].size+2.5;
				~animae[i].move;
			});

			(1/30).wait;
			~userview.refresh;	
		});

		


		 ~animae.clear;

		//    PART 2					
		for (0, ~count, {arg i; 
			~animae = ~animae.add(Anima.new(xPos: xCenter, yPos: i*distY,  yVel: 0, xVel: i%~height+20, 
			col: Color.new255(i%100*2.5, i%250, i%25*10, 50), sizX: 10, sizY: 10,  strtgy:Wave, sndParam:Drone));
		});
	 
							
		///
		// CIRCLES
		
		~userview.drawFunc= { // switch to circles
			for (0, ~animae.size-1,{arg i; 
				Pen.fillColor = ~animae[i].color;
				Pen.fillOval(Rect(~animae[i].position.x, ~animae[i].position.y, ~animae[i].size.x, ~animae[i].size.y));			});
		};
		
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