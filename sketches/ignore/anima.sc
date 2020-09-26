Anima{
	var <>xCoordinate, <>yCoordinate, <>xVelocity, <>yVelocity, <age, <>soundParameters, <>strategy;
	
	*new{ 
		arg xCoord = 0, yCoord = 0, xVel = 0, yVel = 0, sndParam = Click, strtgy = Drift;
		^super.new.init(xCoord, yCoord, xVel, yVel, sndParam, strtgy;);
	}
	
	init{ arg xCoord, yCoord, xVel, yVel, sndParam, strtgy;
		xCoordinate = xCoord;
		yCoordinate = yCoord;
		xVelocity = xVel;
		yVelocity = yVel;
		soundParameters = sndParam;
		strategy = strtgy;
		age = 0;
	}
	
	dump{
		"this anima".postln;
		"	age:   ".post;		
		age.postln;
		"	xcoordinate:   ".post;		
		xCoordinate.postln;
		"	yCoordinate = ".post;
		yCoordinate.postln;
		"	xVelocity = ".post;
		xVelocity.postln;
		"	yVelocity = ".post;
		 yVelocity.postln;
		"	fundamental = ".post;
		"	SoundParameters:   ".post;			soundParameters.postln;
		"	Strategy:   ".post;		
		strategy.postln;
	}					
}	