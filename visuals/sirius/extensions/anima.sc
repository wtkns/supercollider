Anima{
	var <>position, <>velocity, <age, <>soundParameters, <>strategy, <>rhythm, <>color, <>size, <>type;
	
	*new{ 
		arg xPos = (~xDomain/2), yPos = (~yDomain/2), xVel = 0, yVel = 0, sndParam = Click, strtgy = Drift, rhyth = 50.rand, col = Color.yellow.alpha_(0.5), sizX = 5, sizY = 5;
		^super.new.init(xPos, yPos, xVel, yVel, sndParam, strtgy, rhyth, col, sizX, sizY);
	}
	
	init{ arg xPos, yPos, xVel, yVel, sndParam, strtgy, rhyth, col, sizX, sizY;
		position = Point.new(xPos, yPos);
		velocity = Point.new(xVel, yVel);
		soundParameters = sndParam;
		strategy = strtgy;
		rhythm = rhyth;
		color = col;
		size = Point.new(sizX, sizY);
		age = 0;
	}
	
	dump{
		"".postln;
		"	age:   ".post;		
		age.postln;
		"	xcoordinate:   ".post;		
		position.x.postln;
		"	yCoordinate = ".post;
		position.y.postln;
		"	xVelocity = ".post;
		velocity.x.postln;
		"	yVelocity = ".post;
		 velocity.y.postln;
		"	SoundParameters:   ".post;			soundParameters.postln;
		"	Strategy:   ".post;		
		strategy.postln;
	}
	move{
		age = age + 1;
		strategy.move(this);
//		position.postln;

	}				
}	