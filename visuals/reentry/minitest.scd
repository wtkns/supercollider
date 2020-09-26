(
var pieceLength, width, height, count, domain;
pieceLength = 1800; //length of piece in 1/30 seconds
width = 400;
height = 400;
count = 5;

domain = Khora.new(xSize: width, ySize: height, cnt: count);

for (0, count, {arg i;
	domain.animae = domain.animae.add(
		Anima.new(
			xPos: width/2+(15*i), 
			yPos: height/2,  
			yVel: 5, 
			xVel: 5,
			sizX: 10, 
			sizY: 10*i,
			col: Color.new255(i*15, i*20, i*20,  255),
			strat: Strategy.wave
		)
	);
});	

for (0, domain.animae.size-1, {arg i;
	domain.animae[i].position.post;
	domain.animae[i].move;
	domain.animae[i].position.postln;
});

for (0, domain.animae.size-1, {arg i;
	domain.animae[i].strategy = Strategy.fall;
});

for (0, domain.animae.size-1, {arg i;
	domain.animae[i].position.post;
	domain.animae[i].move;
	domain.animae[i].position.postln;
});

)