Anima{
	var <>position, <>velocity, <age, <>soundParameters, <>strategy, <>rhythm;
	
	*new{ 
		arg xPos = (~xDomain/2), yPos = (~yDomain/2), xVel = 0, yVel = 0, sndParam = Click, strtgy = Drift, rhyth = 50.rand;
		^super.new.init(xPos, yPos, xVel, yVel, sndParam, strtgy, rhyth);
	}
	
	init{ arg xPos, yPos, xVel, yVel, sndParam, strtgy, rhyth;
		position = Point.new(xPos, yPos);
		velocity = Point.new(xVel, yVel);
		soundParameters = sndParam;
		strategy = strtgy;
		rhythm = rhyth;
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