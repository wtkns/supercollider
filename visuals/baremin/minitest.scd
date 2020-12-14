(
var count, domain, bounds, bgColor, doClear;
count = 1500; 
bounds = Point.new(1000,1000);
bgColor = Color.blue;
doClear = true;

// initialize window
domain = Khora.new(count, bounds, bgColor, doClear);

// initialize particles
for (0, count, {|i|
	domain.animae = domain.animae.add(
		Anima.new(
			strat: \bounce,
			par: domain,
			pos: Point.new(bounds.x.rand,bounds.y.rand),
			vel: Point.new(15.rand2,15.rand2),
			col: Color.rand,
			siz: Point.new(20,20)
		)
	);
});	

// start particles
r = Routine.new({

// part 1:
	for (0, 200, {|i|
		for (0, domain.animae.size-1, {|j|
			domain.animae[j].move;
		});
		(1/30).wait;
		domain.userview.refresh;
	});

// set mode 2:

	for (0, domain.animae.size-1, {|i|
		domain.animae[i].strategy = \wrap;
	});

// part 2:
	for (0, 200, {|i|
		for (0, domain.animae.size-1, {|j|
			domain.animae[j].move;
		});
		(1/30).wait;
		domain.userview.refresh;
	});

}, 2048);	
	r.play(AppClock);
)