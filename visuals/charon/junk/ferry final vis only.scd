//////////// GRAPHICS ROUTINE (plays score)

	// Set up Particle routine 
	pieceLength = 3600;
	count = 200; 
	bounds = Point.new(1000, 800);
	bgColor = Color.black;
	doClear = true;
	
	// initialize window
	domain = Khora.new(count, bounds, bgColor, doClear);
	
	// start particles
	r = Routine.new({

	score.play;
	
	// part 1:
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
					lif: (pieceLength/count)*i,
					indx: i
				)
			);
		});	

		for (0, pieceLength, {|i|

			domain.animae.do({ arg part, j;
				part.move;
				part.size.y = part.size.y-0.025; 
				
			});

			// housekeeping
			domain.animae.do({ arg part, j;
				if (part.age>part.life, {domain.animae.removeAt(j)});
			});
			
			domain.userview.refresh;
			(1/30).wait;
		});


	// part 2:
		(2).wait;

		for (0, count/2, {|i|
			domain.animae = domain.animae.add(
				Anima.new(
					strat: \rotate,
					par: domain,
					pos: Point.new(domain.bounds.x/2, i*(domain.bounds.y/count)),
					vel: Point.new(i%500,5),
					col: Color.new255(i%100*2.5, i%250, i%25*10, 255),
					vis: i/count,
					siz: Point.new(100,100),
					styl: \circle,
					lif: (pieceLength/count)*i,
					indx: i
				)
			);
		});	

		domain.userview.clearOnRefresh = false;

		for (0, pieceLength/2, {|i|

			domain.animae.do({ arg part, j;
				part.move;
				part.color = (part.color).complementary; 
				part.size = part.size+Point.new(-0.055,-0.055);
			});

			// housekeeping
			domain.animae.do({ arg part, j;
				// if (part.age>part.life, {domain.animae.removeAt(j)});
			});
			
			domain.userview.refresh;
			(1/30).wait;
		});

		
	}, 2048);	
		r.play(AppClock);