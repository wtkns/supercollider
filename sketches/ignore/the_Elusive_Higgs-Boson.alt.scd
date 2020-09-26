// the Elusive Higgs-Boson
// james watkins
// DX Arts 461 - Autumn
// midterm assignment
// requires bell.sc and the CTK quark installed 

(

var boxHeight, boxWidth, sd, part, klang, evolve, checkBell, bells, bells2, pieceLength, numberOfBells;
thisThread.randSeed_(124);
boxHeight = 4000;
boxWidth =  500;
numberOfBells = 20;
pieceLength = 2800; // * .05 seconds  (+/-3mins)

evolve = {arg thisBell;
	var env, bellSplit;
	bellSplit = (numberOfBells/2);
//increase num strikes, split, mutate, accelerate, etc
//this is where the genetic code goes
	if ((thisBell.age > 4).and(thisBell.age%4==0),
		{
		thisBell.xVelocity = thisBell.xVelocity+5.rand;
		thisBell.yVelocity = thisBell.yVelocity+5.rand; 	});	

	if ((thisBell.age == 20),
		{
		 thisBell.duration = 30;	
		 thisBell.envelope = Env([-90, -12, -90], [0.2, 0.8], \exp);
		 thisBell.amplitude = -24;
	});	
	
		if ((thisBell.age == 30),
		{
		 thisBell.duration = 3;	
		 thisBell.envelope = Env([-90, -12, -90], [0.8, 0.2], \sin);
	});	

	if ((thisBell.age == 40),
		{
		thisBell.fundamental = thisBell.fundamental+1000;	});
	
	if ((thisBell.age == 50),
		{
		thisBell.fundamental = thisBell.fundamental+1000;
		thisBell.duration = 1;	
	});
	
	if ((thisBell.age > 60).and(thisBell.bellNumber>bellSplit).and(thisBell.fundamental>120),
		{
			thisBell.duration = 20;	
			thisBell.fundamental = thisBell.fundamental-50;
	});
	
	if ((thisBell.age > 60).and(thisBell.bellNumber<bellSplit).and(thisBell.fundamental<4000),
		{
			thisBell.duration = 10;	
			thisBell.fundamental = thisBell.fundamental+50;
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
	amplitude = (thisBell.amplitude.dbamp)*distance; 
	
	// send the partials to the synth
	thisBell.partials.do({arg thisPartial, i;
		var note, partialAmp, partialDur, partialFreq, partialOffset, partialEnv, bellPan;
		#partialAmp, partialDur, partialFreq, partialOffset = thisPartial;
		partialDur = partialDur*thisBell.duration;
		partialFreq = (thisBell.fundamental*partialFreq)+partialOffset;
		partialAmp = (amplitude * partialAmp); 
		partialEnv = thisBell.envelope;
		bellPan = thisBell.xCoordinate;
		bellPan = (((bellPan / boxWidth) * 2 ) - 1);
		partialEnv = partialEnv.deepCopy;
		partialEnv.times = (partialEnv.times * partialDur); //.postln;
		sd.note(0.1).freq_(partialFreq).env_(partialEnv).envDurScale_(partialDur).ampScale_(partialAmp).pan_(bellPan).
		play;
		});	
		
	evolve.(thisBell);
};

Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);

s.boot;
s.waitForBoot({
//	s.scope;
// s.freqscope;

	sd = CtkSynthDef(\simpleSineWEnv, {arg freq, envDurScale = 1, ampScale, pan;
		var osc, env, envGen;
		env = Control.names([\env]).kr(Env.newClear(8)); 
		envGen = EnvGen.kr(env, timeScale: 1, doneAction: 2);
		osc = SinOsc.ar(freq, 0, envGen.dbamp * ampScale);
		Out.ar(0, Pan2.ar(osc, pan))
	});
	
	Routine.run({

		bells = Array.new(numberOfBells);
		for (1, numberOfBells,
			{arg i;
				bells.add (Bell.new(xCoord: boxWidth/2, yCoord: 100, xVel: 15, yVel: 30, fund: 220+(4*i), amp: -24, dur: 15, bellNum: i));
			});

		bells2 = Array.new(numberOfBells);
		for (1, numberOfBells,
			{arg i;
				bells2.add (Bell.new(xCoord: boxWidth/2, yCoord: 100, xVel: 15, yVel: 30, fund: 220+(4*i), amp: -24, dur: 15, bellNum: i));
			});
		

		for (1, pieceLength, 
			{ arg i;
				bells.do({arg thisBell, i; 
					thisBell.move;
					checkBell.(thisBell);
			});			
			0.05.wait;
		});


		for (1, 270, 
			{ arg i;
				bells2.do({arg thisBell, i; 
					thisBell.move;
					checkBell.(thisBell);
			});	
			
			0.05.wait
			}
		)		
		
		
	}, 2048)	
})

)