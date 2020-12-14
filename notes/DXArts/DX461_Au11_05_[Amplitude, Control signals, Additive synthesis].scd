/*

Linear Amplitude, Decibels and clipping.

The maximum output value you should send to your speakers is 1.0, and the minimun value is -1.0. Internally, all of SuperCollider's UGens use this scale of linear amplitude as the range of values to output to your sound hardware. However, BEFORE you send output to your speakers, you actually have a MUCH greater range of values that you can use... and remmember that since your UGens are outputting numbers, you can use the output of a UGen as a control for other UGens. As an example:

*/

// DON'T actually run this code... it could hurt / break you / your speakers.

{a = SinOsc.ar(1) * 400};  // The output assigned to 'a' will output values between
							// 	-400.0 and 400.0 1 time per second.
							
/*

while the above signal would be well beyond what your speakers can handle, you could certainly use this kind of signal to, for instance, control the frequency of another SinOsc UGen

*/

(
var sd, note;
Server.default = s = Server.internal.boot;

s.waitForBoot({

	sd = CtkSynthDef(\test, {arg dur;
		var freq, osc, env;
		env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.6, 0.2], \sin), timeScale: dur);
		freq = SinOsc.kr(1) * 400; // .kr - runs at the slower control rate*
		osc = SinOsc.ar(freq, 0, 0.2);
		Out.ar(0, Pan2.ar(osc * env))
	});
	
	note = sd.note(0.1, 10).dur_(10).play;
})

)

/*

We have already seen the use of the 'mul' parameter in many UGens (above, we are multiplying the output of the 'osc' SinOsc by 0.2). But it is common to control the range of output for a UGen using mul and add...

*/

(
var sd, note;
Server.default = s = Server.internal.boot;

s.waitForBoot({

	sd = CtkSynthDef(\test, {arg dur;
		var freq, osc, env;
		env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.6, 0.2], \sin), timeScale: dur);
		freq = SinOsc.kr(1, 0, 400, 1000); // outputs between 600 and 1400
		osc = SinOsc.ar(freq, 0, 0.2);
		Out.ar(0, Pan2.ar(osc * env))
	});
	
	note = sd.note(0.1, 10).dur_(10).play;
})

)

/*

UGens also respond to the 'range' method that takes a low and high value. This does the mul and add calculations for you to get a signal in the desired range... 

*/

(
var sd, note;
Server.default = s = Server.internal.boot;

s.waitForBoot({

	sd = CtkSynthDef(\test, {arg dur;
		var freq, osc, env;
		env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.6, 0.2], \sin), timeScale: dur);
		freq = SinOsc.kr(1, 0).range(600, 1400); // outputs between 600 and 1400
		osc = SinOsc.ar(freq, 0, 0.2);
		Out.ar(0, Pan2.ar(osc * env))
	});
	
	note = sd.note(0.1, 10).dur_(10).play;
})
)

/*

For the actual amplitude of the sound we want to output, linear amplitude can be a bit unfriendly. Sound level is better thought of in terms of decibels (This was discussed in the Dodge on page 27). While there is great flexiblity in our signal flow by using linear amplitude, when we actually output sound we want to start thinking in terms of decibels. There are two methods that are particularily handy for this and they work for Numbers as well as UGen output.

	ampdb => convert from linear amplitude into db
	dbamp => convert from db into linear amplitude

In SC - 0 db = 1.0 - or, the maximum value of output that should be sent to hardware. -6 db is half that (0.5) and 6 db is twise that (2.0)

*/

6.dbamp;
-6.dbamp;
0.5.ampdb;

/*

From here on, when dealing with output signals that we want to hear, we will control amplitude with db (and let the language convert to linear amplitude for us) - for other signals that we will use as control signals, you should use whatever is clearer. Just make sure you convert with the methods above as needed!

*/

SinOsc.ar(440, 0, -12); // NOT -12!... this will be very loud!!!
SinOsc.ar(440, 0, -12.dbamp); // much better

/*

db levels in an Env:

*/

(
var sd, note;
Server.default = s = Server.internal.boot;

s.waitForBoot({

	sd = CtkSynthDef(\test, {arg dur;
		var freq, osc, env;
		env = EnvGen.kr(Env([-90, -18, -30, -90], [0.2, 0.6, 0.2], \sin), 
			timeScale: dur);
		freq = SinOsc.kr(1, 0, 400, 1000); 
		// apply the dbamp operator to the output of the EnvGen
		osc = SinOsc.ar(freq, 0, env.dbamp);
		Out.ar(0, Pan2.ar(osc))
	});
	
	note = sd.note(0.1, 10).dur_(10).play;
})

)

/* 

*** WARNING ***
it isn't uncommon for a amplitude envelope to cross 0... we'll see instances of this more later when we start doing more signal processing, but doing something like the below with an \exp curve will create a zero crossing, and this will create an infinity.

*/

(
var sd, note;
Server.default = s = Server.internal.boot;

s.waitForBoot({

	sd = CtkSynthDef(\test, {arg dur, ampScale;
		var freq, osc, env;
		env = EnvGen.kr(Env([-90, 18, -30, -90], [0.2, 0.6, 0.2], \exp), timeScale: dur);
		freq = SinOsc.ar(1, 0, 400, 1000); 
		osc = SinOsc.ar(freq, 0, env.dbamp * ampScale.dbamp);
		Out.ar(0, Pan2.ar(osc))
	});
	
	note = sd.note(0.1, 10).dur_(10).play;
})

)

/*

differences when dealing with linear amplitude and db scales.

amp * 2; // output is doubled
dbValue + 6; // output is doubled
amp * 4; // output is quadrupled
dbValue + 12; // output is quadrupled
amp * 0.5; // output is halved
dbValue - 6; // output is halved

*/

/*

A little more on Control signals, Envs and EnvGens

The example above uses a SinOsc running with the 'kr' method to control frequency. Notice also that EnvGen is running at 'kr'. These are efficiencies that the system has to save calculations and make the sound engine run more efficiently. All audio in SC is actually calculated in blocks of samples (by default, 64 samples per block). For 'ar' UGens, this means 64 samples of data are calculated for each block. But for 'kr' UGens, only 1 sample is calculated. This can save a LOT of computation, especially for signals that are running at slower rates (or - for signals that are providing 'control' data rather then 'audio' data).

SuperCollider actually smoothes what would be 'choppier' signals at the control rate for you still... you don't need to worry too much about this right now... the main thing to be concerned with is that the sound you want to hear MUST be run as an 'ar' UGen. 

Most UGens can also take inputs at different rates. There are three common rate... 

	'scaler' - these are values that are usually static (a number for instance)
	'control' - these update at a slower interval
	'audio' - many UGens can actually take other audio rate UGens as input. And even if a UGen 
		isn't designed to take an audio rate UGen, it will still accept it as input and 
		will sample it at the rate that the UGen wants. This is taken care of for you... you 
		just give the UGen the input you want to give it. We'll find instances later in this class
		where there are specific reasons for one or the other ... for now, don't worry about it.

*/


/*

Approaches to additive synthesis:

Additive synthesis is usually defined as the combination of multiple versions of a simpler signal to create a more complex one. There are three 'basic' ways to do this in SuperCollider, each with advantages and disadvantages. We'll talk about the two easier approaches in the next class (using a CtkBuffer to create a complex spectrum or building a single CtkSynthDef to create a single complex timbre)... the approach we will use today though will give you the most flexibility, and will also serve as a good template for your midterm assignment. In this approach, we will make a CtkSynthDef that will control a single sinusoidal partial. We will then create more complex sounds by calling multiple notes at the same time.

When you output two sounds to the same output bus, scsynth sums those outputs:

*/


(
var sd, note;
Server.default = s = Server.internal.boot;

s.waitForBoot({
	s.scope;

	sd = CtkSynthDef(\simpleSine, {arg freq, dur, ampScale;
		var osc, env;
		env = EnvGen.kr(Env([-90, 0, 0, -90], [0.2, 0.6, 0.2], \sin), timeScale: dur);
		osc = SinOsc.ar(freq, 0, env.dbamp * ampScale.dbamp);
		Out.ar(0, Pan2.ar(osc))
	});
	
	Routine.run({
		sd.note(0.1, 4).freq_(440).dur_(4).ampScale_(-18).play;
		5.wait;
		sd.note(0.1, 4).freq_(440).dur_(4).ampScale_(-18).play;
		sd.note(0.1, 4).freq_(880).dur_(4).ampScale_(-18).play;
	});
})

)

/*

If you look at the additive synthesis diagram on Dodge, page 88, this 'summing' of signals that scsynth does for you is represented in the diagram with the '+' portion of the signal flow. We can output as many notes as we want at the same time to bus 0 in the above example, and if their onset and attack envelope are similar, we will perceive then as a single complex sound rather then two different sounds.

Below, I define a Function that I can call that will produce clarinet like timbres... I can then call that Function in my Routine to make 'clarinet' notes.

*/

(
var sd, note, clar;
Server.default = s = Server.internal.boot;

s.waitForBoot({
	s.scope;

	sd = CtkSynthDef(\simpleSine, {arg freq, dur, ampScale;
		var osc, env;
		env = EnvGen.kr(Env([-90, 0, 0, -90], [0.2, 0.6, 0.2], \sin), timeScale: dur);
		osc = SinOsc.ar(freq, 0, env.dbamp * ampScale.dbamp);
		Out.ar(0, Pan2.ar(osc))
	});
	
	clar = {arg freq, amp, duration; // pass in values for freq, amp (in db) and duration:
		var partialAmps;
		// clarinet sounds have a lot of energy in the ODD partials. Create 11 partials of
		// sound, giving more energy the odd partials. We'll store 'base' amplitude values
		// (in db) inside an Array that will will iterate over to create notes
		partialAmps = [0, -30, -6, -36, -9, -44, -18, -76, -24, -66, -36];
		// create the notes using these amp values and the incrementer to calculate
		// each partials frequency
		partialAmps.do({arg thisAmp, i;
			i = i + 1; // since i starts at 0, add 1 to make it scale freq properly
			thisAmp = thisAmp + amp; // ADD the db value in our array to the 'amp' arg in our Function
									 // to scale the overall sense of amplitude
			sd.note(0.1, duration).freq_(freq * i).dur_(duration).ampScale_(thisAmp).play;
		})
	};
	  
	Routine.run({
		clar.value(220, -18, 4);
		/*
		5.0.wait;
		[PC(\c, 3), PC(\d, 3), PC(\ef, 3), PC(\f, 3), PC(\g, 3), PC(\a, 3), PC(\b, 3)].do({arg thisPC;
			clar.value(thisPC.freq, -12, 0.22);
			0.25.wait;
		});
		2.0.wait; // ... wait for it...
		clar.value(PC(\c, 2).freq, -6, 2.0);
		*/
	});
})

)

/*

More complex control - 

*/

(
var sd, note, clar;
Server.default = s = Server.internal.boot;

s.waitForBoot({
	s.scope;

	sd = CtkSynthDef(\simpleSine, {arg freq, dur, ampScale;
		var osc, env;
		env = EnvGen.kr(Env([-90, 0, 0, -90], [0.2, 0.6, 0.2], \sin), timeScale: dur);
		osc = SinOsc.ar(freq, 0, env.dbamp * ampScale.dbamp);
		Out.ar(0, Pan2.ar(osc))
	});
	
	// pass in values for freq, amp (in db) and duration:
	clar = {arg freq, amp, duration; 
		var partialAmps, freqScale, durScale;
		partialAmps = [0, -30, -6, -36, -9, -44, -18, -76, -24, -66, -36];
		freqScale = [1, 2.1, 3.001, 3.9, 5.0, 5.85, 7.01, 8.1, 8.99, 9.9, 11.02];
		durScale = [1, 1, 1, 0.9, 1, 0.8, 0.9, 0.5, 0.7, 0.3, 0.1];
		partialAmps.size.do({arg i; // simply a counter passed in
			var thisAmp, thisFreq, thisDur;
			thisAmp = partialAmps[i] + amp; 
			thisFreq = freqScale[i] * freq;
			thisDur = durScale[i] * duration;
			sd.note(0.1, thisDur).freq_(thisFreq).dur_(thisDur)
				.ampScale_(thisAmp).play;
		})
	};
	  
	Routine.run({
		clar.value(220, -18, 4);
		/*
		5.0.wait;
		[PC(\c, 3), PC(\d, 3), PC(\ef, 3), PC(\f, 3), PC(\g, 3), PC(\a, 3), 			PC(\b, 3)].do({arg thisPC;
				clar.value(thisPC.freq, -12, 0.22);
				0.25.wait;
		});
		2.0.wait; // ... wait for it...
		clar.value(PC(\c, 2).freq, -6, 2.0);
		*/
	});
})
)

/*

One final thing to notice in the above example - especially in longer notes, you can really hear the envelopes cut off. It ruins the 'additive' synthesis effect in some ways (makes it feel unnatural), but it also highlights another place in our code where we may want to have more control.

We can actually pass in Envs into notes as we do other arguments - but Envs are not just single values. They are actually (underneath) an Array of data:

*/

a = Env([0, 1, 0], [0.2, 0.6], [\sin]);
b = a.asArray;

/*

A CtkSynthDef needs some extra code in it to make it work so that you can give an array of data... We use the Control class for this:

*/


(
var sd, note, clar;
Server.default = s = Server.internal.boot;

s.waitForBoot({
	s.scope;

	sd = CtkSynthDef(\simpleSineWEnv, {arg freq, envDurScale = 1, ampScale;
		var osc, env, envGen;
		// Control.names([\argName]).kr( ... a default ... )
		// space for an 8 breakpoint Env
		env = Control.names([\env]).kr(Env.newClear(8)); 
		envGen = EnvGen.kr(env, timeScale: envDurScale);
		osc = SinOsc.ar(freq, 0, envGen.dbamp * ampScale.dbamp);
		Out.ar(0, Pan2.ar(osc))
	});
	
	Routine.run({
		// now - we can pass in an Env with times scaled to 1 so envDurScale 
		// will scale the times appropriately - and pass our Env in with the 
		// env_ setter method
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		5.0.wait;
		// or - by setting envDurScale to 1, we can give the Env specific times
		// just make sure they add up to the note's duration (here, 4)
		sd.note(0.1, 4.0).freq_(440).envDurScale_(1.0).ampScale_(-12)
			.env_(Env([-90, -12, -24, -36, -90], [0.1, 0.2, 3.4, 0.3], \exp)).play;		
	})
})
	
)

/*

some handy Array methods:

*/

// you can do math to an Array:

a = [0.1, 0.2, 0.3, 0.8, 1.4];
b = a + 3;
c = a * 0.2;

// normalizeSum will take all your Array values, and make the sum of them equal 1

b = a.normalizeSum;
b.sum;


