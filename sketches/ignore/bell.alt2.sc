Bell {
	var <>xCoordinate, <>yCoordinate, <>xVelocity, <>yVelocity, <>fundamental, <>duration, <>amplitude, <>envelope, <>partials, <age, <bellNumber;

	*new{ 
		arg xCoord = 0, yCoord = 0, xVel = 5, yVel = 5, fund = 440, dur = 10, amp = -12, bellNum,  
		env = Env([-90, -12, -90], [0.002, 1], \exp);
		^super.new.init(xCoord, yCoord, xVel, yVel, fund, dur, amp, env, bellNum;);
		}
	
	init{ arg xCoord, yCoord, xVel, yVel, fund, dur, amp, env, bellNum;
		xCoordinate = xCoord;
		yCoordinate = yCoord;
		xVelocity = xVel;
		yVelocity = yVel;
		fundamental = fund;
		duration = dur;
		amplitude = amp; // in db
		envelope = env;
		bellNumber = bellNum;
		age = 0;
		
		partials = Array.new(11);
	// Amplitude, Duration, Frequency, Modifier
		partials.add([1,1,0.56,0]);
		partials.add([0.67,0.9,0.56,1]);
		partials.add([1,0.65,0.92,0]);
		partials.add([1.8,0.55,0.92,1.7]);
		partials.add([2.67,0.325,1.19,0]);
		partials.add([1.67,0.35,1.7,0]);
		partials.add([1.46,0.25,2,0]);
		partials.add([1.33,0.2,2.74,0]);
		partials.add([1.33,0.15,3,0]);
		partials.add([1,0.1,3.76,0]);
		partials.add([1.33,0.075,4.07,0]);
		}

	move { 
		xCoordinate = xCoordinate + xVelocity;
		yCoordinate = yCoordinate + yVelocity;
	}

	reflectX {
		xVelocity = xVelocity*(-1);	
	}	
	
	reflectY {
		yVelocity = yVelocity*(-1);	
	}	
	
	strike{
		age = age+1;
	}
	
	dump{
		"this bell".postln;
		"	xcoordinate:   ".post;		
		xCoordinate.postln;
		"	yCoordinate = ".post;
		yCoordinate.postln;
		"	xVelocity = ".post;
		xVelocity.postln;
		"	yVelocity = ".post;
		 yVelocity.postln;
		"	fundamental = ".post;
		fundamental.postln;
		"	duration = ".post; 
		duration.postln;
		"	amplitude = ".post;
		amplitude.postln;
		"	envelope = ".post;
		envelope.postln;
		"	age = ".post;
		age.postln;
		" ".postln;
	}					
}