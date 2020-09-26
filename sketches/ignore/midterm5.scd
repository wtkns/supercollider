var boxHeight, boxWidth, sd, part, klang, evolve, checkBell, bells, pieceLength;

boxHeight = 4000;
boxWidth =  500;
pieceLength = 3600; // * .05 seconds  (+/-3mins)

evolve = {arg thisBell;
	var env;
	
//increase num strikes, split, mutate, accelerate, etc
//this is where the genetic code goes
	if ((thisBell.age % 3 == 0),
		{thisBell.xVelocity = thisBell.xVelocity+5.rand;
		thisBell.yVelocity = thisBell.yVelocity+5.rand;
		//thisBell.dump; 	
	});	

	if ((thisBell.age == 20),
		{
		 thisBell.duration = 30;	
		 thisBell.envelope = Env([-90, -12, -90], [0.2, 0.8], \exp);
		 thisBell.amplitude = -12;
	});	
	
	if ((thisBell.age>30).and(thisBell.duration>0.5),
		{
		 thisBell.duration = thisBell.duration-0.5;
	});



};

checkBell = { arg thisBell;
	x = thisBell.xCoordinate;
	y = thisBell.yCoordinate;
									
	if ((x>=boxWidth),
	{
		thisBell.xCoordinate = boxWidth-1;
		klang.(thisBell);
		thisBell.reflectX;
		thisBell.strike
	});		
	
	if ((y>=boxHeight),
	{
		thisBell.yCoordinate = boxHeight-1;
		klang.(thisBell);
		thisBell.reflectY;
		thisBell.strike
	}); 
	
	if ((x<=0),
	{
		thisBell.xCoordinate = 1;
		klang.(thisBell);
		thisBell.reflectX;
		thisBell.strike
	});		
	
	if ((y<=0),
	{
		thisBell.yCoordinate = 1;
		klang.(thisBell);
		thisBell.reflectY;
		thisBell.strike
	}); 

};				

klang = {arg thisBell; 
	var amplitude, distance;
	distance = (boxHeight - thisBell.yCoordinate)/boxHeight;
	amplitude = thisBell.amplitude.dbamp*distance;
	
	// send the partials to the synth
	thisBell.partials.do({arg thisPartial, i;
		var note, partialAmp, partialDur, partialFreq, partialOffset, partialEnv, bellPan;
		#partialAmp, partialDur, partialFreq, partialOffset = thisPartial;
		partialDur = partialDur*thisBell.duration;
		partialFreq = (thisBell.fundamental*partialFreq)+partialOffset;
		partialAmp = (amplitude * partialAmp).ampdb;
		partialEnv = thisBell.envelope;
		bellPan = thisBell.xCoordinate;
		sd.note(0.1).freq_(partialFreq).env_(partialEnv).envDurScale_(partialDur).ampScale_(partialAmp).pan_(bellPan).
		play;
		});	
		
	evolve.(thisBell);
};

Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.boot;
s.waitForBoot({
	s.scope;

	sd = CtkSynthDef(\simpleSineWEnv, {arg freq, envDurScale = 1, ampScale, pan;
		var osc, env, envGen;
		pan = LinLin.kr(pan, 0, boxWidth, -1, 1);
		env = Control.names([\env]).kr(Env.newClear(8)); 
		envGen = EnvGen.kr(env, timeScale: envDurScale, doneAction: 2);
		osc = SinOsc.ar(freq, 0, envGen.dbamp * ampScale.dbamp);
		Out.ar(0, Pan2.ar(osc, pan))
	});
	
	Routine.run({
		bells = Array.new(20);
		
		for (1, 20,
			{arg i;
				bells.add (Bell.new(xCoord: boxWidth/2, yCoord: 100, xVel: 15, yVel: 30, fund: 220+(4*i), amp: -12, dur: 20));
			}
		);
		

		for (1, pieceLength, 
			{ arg i;
				bells.do({arg thisBell, i; 
					checkBell.(thisBell);
					thisBell.move;
			});	
			
			0.05.wait
			}
		)
	}, 2048)	
})