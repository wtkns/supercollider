Drone{
	*playSound{arg this_anima;
		
		var noteObject, note;
		
		noteObject = CtkSynthDef(				\simplefm3, {arg dur = 0.125, amp = -32, carfreq = this_anima.position.y, 
			cmratio = 0.25, index = 1;
		
			var env, mod, car, modfreq, deviation, pan;
			env = EnvGen.kr(
				Env([0.01, 1, 1, 0.01], [0.1, dur-0.2, 0.1], \exp));
			pan = 	this_anima.position.x;
			pan = (((pan / ~xDomain) * 2 ) - 1);
			modfreq = carfreq * cmratio;
			deviation = index * modfreq;
			mod = SinOsc.ar(modfreq, 0, deviation);
			car = SinOsc.ar(carfreq + mod, 0, amp.dbamp);
			Out.ar(0, Pan2.ar(car * env, pan));
		});
	
		note = noteObject.note(0.1, 0.25).dur_(0.25).carfreq_(( (~yDomain - this_anima.position.y)+100))
			.cmratio_(0.25).index_(4).play; 
	}
}