var boxHeight, boxWidth, sd, part, klang, bells, pieceLength;

boxHeight = 4000;
boxWidth =  500;
pieceLength = 3600; // * .05 seconds  (+/-3mins)

klang = {arg thisBell; 
	var amplitude, distance;
	
	distance = (boxHeight - thisBell.getY)/boxHeight;	amplitude = thisBell.getAmplitude*distance;
	thisBell.getPartials.do({arg thisPartial, i;
		var amp, dur, freq, offset, note, env, pan;
		#amp, dur, freq, offset = thisPartial;
		dur = dur*thisBell.getDuration;
		freq = (thisBell.getFundamental*freq)+offset;
		amp = (amplitude * amp);
		env = thisBell.getEnvelope;
		pan = thisBell.getX;
		sd.note(0.1, dur).freq_(freq).env_(env).envDurScale_(dur).ampScale_(amp).pan_(pan).
		play;
		});	
};

Server.default = s = Server.internal.boot;

s.waitForBoot({
	s.scope;

	sd = CtkSynthDef(\simpleSineWEnv, {arg freq, envDurScale = 1, ampScale, pan;
		var osc, env, envGen;
		env = Control.names([\env]).kr(Env.newClear(8)); 
		envGen = EnvGen.kr(env, timeScale: envDurScale);
		osc = SinOsc.ar(freq, 0, envGen.dbamp * ampScale.dbamp);
		Out.ar(0, Pan2.ar(osc, LinLin.kr(pan, 0, boxWidth, -1, 1)))
	});
	
	Routine.run({
		
		bells = [	Bell.new(1,100,15,30, 220, 20), 
					Bell.new(1,100,3,3),
					Bell.new(1,100,5,5, 620),
					Bell.new(1,100,5,10, 320),
					Bell.new(1,100,1,1, 820),
					Bell.new(1,100,0.5,0.5, 1020),
					];
		
		for (1, pieceLength, 
			{ arg i;
				bells.do({arg thisBell, i; 
					x = thisBell.getX;
					y = thisBell.getY;
					
					if ((x>=boxWidth).or(x<=0),
					{
						klang.value(thisBell);
						thisBell.reflectX;
						thisBell.strike.postln
					});		
					
					if ((y>=boxHeight).or(y<=0),
					{
						klang.value(thisBell);
						thisBell.reflectY;
						thisBell.strike.postln
					}); 
					
					thisBell.move
				});	
					
			   0.05.wait
			}
		)
	})	
})