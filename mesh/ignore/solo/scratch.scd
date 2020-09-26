	sp.wait(1.0);

	drone1 = sp.seq(
		Pmono(\expHarm,
			\dur, Pexprand(10, 20),
			\cps, Pbrown(60.0, 120, 10, inf)).collect{
			|event| drone1ID = event[\id]; event});

 sp.wait(1.5);

	sp.par(
		Pbindef(\expHarm,
			\dur, Pexprand(0.125, 2),
			\instrument, \expHarm,
			\id, drone1ID,
			\type, \set,
			\args, #[],
			\cps, Pbrown(50.0, 200, Pbrown(5.0, 200, 10, inf), inf),
			\cpsLag, Pkey(\dur),
			\cpsPow, Pbrown(0.125, 1.25, 0.1, inf),
			\panVal, Pwhite(-0.75, 0.75),
			\panLag, Pkey(\dur)
		)
	);

	sp.wait(5.0);

	drone2 = sp.seq(
		Pmono(\expHarm,
			\dur, Pexprand(10, 20),
			\cps, Pbrown(60.0, 600, 10, inf)).collect{
			|event| drone2ID = event[\id]; event});

	sp.wait(1.5);

	sp.par(
		Pbindef(\expHarm2,
			\dur, Pexprand(0.125, 2),
			\instrument, \expHarm,
			\id, drone2ID,
			\type, \set,
			\args, #[],
			\cps, Pbrown(50.0, 200, Pbrown(5.0, 200, 10, inf), inf),
			\cpsLag, Pkey(\dur),
			\cpsPow, Pbrown(0.125, 1.25, 0.1, inf),
			\panVal, Pwhite(-0.75, 0.75),
			\panLag, Pkey(\dur)
		)
	);

	sp.wait(1.0.rand);

	/*sp.par(
		droneID.asTarget.free);
*/



	//
	// sp.wait(5.0);
	//
	// sp.par(
	// 	Pbindef(\swarmsaw1,
	// 		\waver, Pseq(
	// 			[[1.5, 1.5, 1.5, 1.5],
	// 			[0.5, 0.5, 0.5, 0.5]],
	// 		inf ),
	// 	)
	// );

	// Pdefn( \swarmMainVol, );


	// var dronePatterns = (
	// 	fadeIn: Pseries(0, 0.01, 50),
	// 	waver: Pbrown(0.0, 0.2, 0.05, inf)
	// );

	// Pdefn( \,
	// 	[
	// 		Pbrown(0.0, 0.2, 0.01, inf),
	// 		Pbrown(0.0, 0.2, 0.01, inf),
	// 		Pbrown(0.0, 0.2, 0.01, inf),
	// 	Pbrown(0.0, 0.2, 0.01, inf) ]
	// , inf );


	// 	[Pnsym(\waver, dronePatterns),
	// 		Pnsym(\waver, dronePatterns),
	// 		Pnsym(\waver, dronePatterns),
	// 	Pnsym(\waver, dronePatterns)]
	//
	// );

	//
	// sp.wait(1.0);
	//
	// sp.par(
	// Pmono(\expHarm, \cps, 100).collect{|event| ~expHarmID = event[\id]; event});
	//
	// sp.wait(5.0);
	//
	// sp.par(
	// Pmono(\expHarm, \cps, 200).collect{|event| ~expHarmID2 = event[\id]; event});
	//


///////



Quarks.gui

Event().trace.post

x = (Pmono(\swarmSaw ).collect{|event| ~droneID = event[\id]; event}).play;

//t.schedAbs(t.beats.ceil, { |beat| (beat % 4 + 1).postln; 1 })



20.do({ (5.0).rand.postln; });            // evenly distributed
20.do({ ((3.0).rand + 1.0).postln })

(
var start = 50;
var low = 10;
var high = 200;
var length =  50;
var brownstep = 1;
var brownlength = inf;
var stepUp = ((high - start) / length );
var stepDown = ((start - low) / length ).neg;

)



(
var a, b;
a = Pbrownseed(50, 25, 200, 1, 200);
b = a.asStream;
200.do({ b.next.postln; });
)


(
var init = 50;
var low = 20;
var high = 100;
var length = 50;

var stepDown = ((init-low)/length);
var stepUp = ((high-init)/length);


a = Pbrown(
	Pseq([init, Pseries(init, (-1 * stepDown), length), Pn(lowTarget)], inf),
	Pseq([init, Pseries(init, stepUp, length), Pn(highTarget)], inf),
	step
);


b = a.asStream;
100.do({b.next.postln});
)


(
var a, b;


a = Pseq([1, 2, 3], 2);    // repeat twice
b = a.asStream;
7.do({ b.next.postln; });
)






a = ).asStream;
150.do({a.next.postln});

~droneID.postln;



)

s.boot

x = Synth(\expHarm, [\cps, 200]);

x.set(\cpsLag, 100);

x.set(\cps, 20);
x.set(\cpsPow, 0.6);
x.set(\cpsPow, 0.8);

x.set(\cpsPow, 1.2);
x.set(\cps, 250);
x.set(\cpsPow, 0.95);

x.set(\cps, 100);



x.set(\panVal, 0);
x.set(\panLag, 25);
x.set(\panVal, 1);


x.set(\leftAdd, 0.5);
x.set(\rightAdd, -0.0);



x.free





(

Pbindef.removeAll;
Pbindef(\swarmsaw1).clear;

s.boot;




)


(


)

(
Pbindef(\swarmsaw1,
	\dur, Pdefn(\swarmDur, Pwhite(0.25, 5.0, inf), inf),
	\instrument, \swarmSaw,
	\id, ~droneID,
	\type, \set,
	\args, #[],
	\lagArr, Ptuple({ Pwhite(Pkey(\dur)*0.25, Pkey(\dur)*0.9, inf) }.dup(~numVoices), inf).collect([_]),
	\cpsArr, Ptuple({ Pbrown(60, 600, 40, inf) }.dup(~numVoices), inf).collect([_]),
	\syncVal, Pdefn(\syncFreq, Pwhite(1, 100, inf), inf),
	\syncCpsArr, Ptuple( Pkey(\syncVal, inf).dup(~numVoices), inf).collect([_]),
	\lpfFrq, Ptuple({ Pbrown(10, 500, 10, inf) }.dup(~numVoices), inf).collect([_]),
	\lpfRq, Ptuple({ Pbrown(0.01, 0.2, 0.1, inf) }.dup(~numVoices), inf).collect([_]),
	\ampArr, Ptuple({ Pbrown(0.1, 0.75, 0.05, inf)*2 }.dup(~numVoices), inf).collect([_]),
	\panArr, Ptuple({ Pbrown(-1.0, 1.0, 0.15, inf) }.dup(~numVoices), inf).collect([_]),
	\lpfLagArr, Pkey(\lagArr)*0.25

).play;


)

Pdefn(\syncFreq, Pxrand([40, 42, 44, 46, 44, 48], inf).midicps, inf);

Pdefn(\swarmDur, Pxrand([0.25, 0.5, 0.75, 1.0], inf), inf);











(
SynthDef(\expHarm, {
	|cps = 300, cpsPower = 1.06 |
	var harmonics = 10;
	var cpsArray = Array.fill(harmonics, {|i| cps + (cps * i).pow(cpsPower)});
	var signal = SinOsc.ar(cpsArray);
	Out.ar(0, signal)
}).add;
)


(








)


Array.fill(harmonics, {|i| (cps*(i+1.pow(cpsPower)))});


(var a = 1, z;
z = if (a < 5, { 100 },{ 200 });
z.postln;
)


(
var a, b;
a = Pbrowntrend(50, 25, 100, 1, 100);
b = a.asStream.nextN(100);

w = Window.new("Pbrown", Rect(10, 10, 540, 800));
// plot the values


b.plot(bounds: Rect(10, 10, 520, 380), discrete: false, parent: w);

)



(
var start = 50;
var low = 10;
var high = 200;
var length =  50;
var brownstep = 3;
var brownlength = inf;
var stepUp = ((high - start) / length );
var stepDown = ((start - low) / length ).neg;
var a = Pseq([
	Pbrown(
		lo: Pseries (
			start: start,
			step: stepDown,
			length: length),

		hi: Pseries (
			start:start,
			step: stepUp,
			length: length),

		step: brownstep,
		length: length),

	Pn(

		Pbrownseed(
			seed: a.next,
			lo: low,
			hi: high,
			step: brownstep,
			length: brownlength))],1);

var b = a.asStream.nextN(100);


//Ptrace(a).play;


w = Window.new("Pbrown", Rect(10, 10, 540, 800));
// plot the values

b.plot(bounds: Rect(10, 10, 520, 380), discrete: true, parent: w);

// a histogram of the values
//b.histo(500).plot(bounds: Rect(10, 410, 520, 380), parent: w);


// 100.do({
// 	b.next.postln
// });

//b.next(Event.new)


)

(
Pspawner({ |sp|


	sp.par(
		Pmono(\limiter,
			\dur, 0.2,
			\limit, 0.5
		).collect{|event| ~limitID = event[\id]; event};
	);


	sp.par( Pchain(
		Pmono(\swarmSaw,
			\dur, Pdefn(\d_dur, Pwhite(0.08, 0.12), inf)
		).collect{|event| ~droneID = event[\id]; event},
		Pbindef(\swarmFade,
			\amp1, Pdefn(\d_vol1, 0, inf),
			\amp2, Pdefn(\d_vol2, 0, inf),
			\amp3, Pdefn(\d_vol3, 0, inf),
			\amp4, Pdefn(\d_vol4, 0, inf),
			\amplag1, Pdefn(\d_volLag1, 0, inf),
			\amplag2, Pdefn(\d_volLag2, 0, inf),
			\amplag3, Pdefn(\d_volLag3, 0, inf),
			\amplag4, Pdefn(\d_volLag4, 0, inf))
	));


	sp.par(
		Pbindef(\swarmPan,
			\instrument, \swarmSaw,
			\id, ~droneID,
			\type, \set,
			\args, #[],
			\dur, Pdefn(\swarmPanDur, Pwhite(0.1, 0.25)),
			\pos1, Pdefn(\d_pan1, Pbrown(-1, 1, 0.125, inf)),
			\pos2, Pdefn(\d_pan2, Pbrown(-1, 1, 0.125, inf)),
			\pos3, Pdefn(\d_pan3, Pbrown(-1, 1, 0.125, inf)),
			\pos4, Pdefn(\d_pan4, Pbrown(-1, 1, 0.125, inf))
	));

	sp.wait(1.0);

	sp.par(
		Pdefn(\d_vol1, Pseq([
			Pseries(0, 0.005, 100),
			Pn(Pbrown(0.25, 0.55, 0.0125))
		], 1));
	);

	//	sp.wait((1.0).rand + 2.0);

	sp.par(
	Pdefn(\d_vol2, Pseq([
		Pseries(0, 0.005, 100),
		Pn(Pbrown(0.25, 0.55, 0.0125))
	], 1));
	);

	//	sp.wait((1.0).rand + 2.0);

	sp.par(
	Pdefn(\d_vol3, Pseq([
		Pseries(0, 0.005, 100),
		Pn(Pbrown(0.25, 0.55, 0.0125))
	], 1));
	);

	//	sp.wait((1.0).rand + 2.0);
	sp.par(
	Pdefn(\d_vol4, Pseq([
		Pseries(0, 0.005, 100),
		Pn(Pbrown(0.25, 0.55, 0.0125))
	], 1));
	);


	sp.wait(1.0);
	sp.par(
		Pbindef(\swarmFade).stop
	);


}))

))



//	~droneID[0].asTarget.set( \amp1, 0, \amp2, 0, \amp3, 0, \amp4, 0);

	// .asTarget.free;

	//	sp.wait((1.0).rand + 4.0);

	// Pdefn(\d_volLag1, Pseq([
	// 	Pseries(1, -0.05, 100),
	// 	Pn(0.5)
	// 	], 1), inf);

	// sp.wait((1.0).rand);

	// Pdefn(\d_volLag2, Pseq([
	// 	Pseries(1, -0.05, 100),
	// 	Pn(0.5)
	// 	], 1), inf);

	// 	sp.wait((1.0).rand);

	// Pdefn(\d_volLag3, Pseq([
	// 	Pseries(1, -0.05, 100),
	// 	Pn(0.5)
	// 	], 1), inf);

	// 	sp.wait((1.0).rand);

	// Pdefn(\d_volLag4, Pseq([
	// 	Pseries(1, -0.05, 100),
	// 	Pn(0.5)
	// 	], 1), inf);

	// 	sp.wait((4.0));


	// sp.par(
	// 	Pbindef(\swarmPitch1,
	// 		\instrument, \swarmSaw,
	// 		\id, ~droneID,
	// 		\type, \set,
	// 		\args, #[],
	// 		\dur, Pdefn(\swarmPitchDur1, Pwhite(0.1, 0.25)),
	// 		\freq1, Pdefn(\d_frq1, Pbrown(40, 80, 0.25, inf))
	// 	));

	// sp.wait((1.0).rand + 2.0);

	// sp.par(
	// 	Pbindef(\swarmPitch2,
	// 		\instrument, \swarmSaw,
	// 		\id, ~droneID,
	// 		\type, \set,
	// 		\args, #[],
	// 		\dur, Pdefn(\swarmPitchDur2, Pwhite(0.1, 0.25)),
	// 		\freq2, Pdefn(\d_frq2, Pbrown(80, 120, 0.5, inf))
	// 	));

	// sp.wait((1.0).rand + 2.0);

	// sp.par(
	// 	Pbindef(\swarmPitch3,
	// 		\instrument, \swarmSaw,
	// 		\id, ~droneID,
	// 		\type, \set,
	// 		\args, #[],
	// 		\dur, Pdefn(\swarmPitchDur3, Pwhite(0.1, 0.25)),
	// 		\freq3, Pdefn(\d_frq3, Pbrown(160, 240, 1, inf))
	// 	));

	// 	sp.wait((10.0).rand + 2.0);

	// sp.par(
	// 	Pbindef(\swarmPitch4,
	// 		\instrument, \swarmSaw,
	// 		\id, ~droneID,
	// 		\type, \set,
	// 		\args, #[],
	// 		\dur, Pdefn(\swarmPitchDur4, Pwhite(0.1, 0.25)),
	// 		\freq4, Pdefn(\d_frq4, Pbrown(240, 1400, 5, inf))
	// 	));


	// sp.par(
	// 	Pbindef(\swarmPitch,
	// 		\instrument, \swarmSaw,
	// 		\id, ~droneID,
	// 		\type, \set,
	// 		\args, #[],
	// 		\dur, Pdefn(\swarmPitchDur, Pwhite(0.1, 0.25)),
	// 		\frqOffset, Pdefn(\d_frq1, Pbrown(40, 60, 0.125, inf))
	// 	));





	// faded in
	//
	// sp.wait(5.0);
	//
	//
	//
	// sp.wait(10.0);

	// sp.par(
	// 	Pbindef(\swarmBeat,
	// 		\instrument, \swarmSaw,
	// 		\id, ~droneID,
	// 		\type, \set,
	// 		\args, #[],
	// 		\amplag1, 0.05,
	// 		\amplag2, 0.05,
	// 		\amplag3, 0.05,
	// 		\amplag4, 0.05,
	// 		\dur, Pdefn(\swarmBeatDur, Pwhite(0.1, 0.25)),

	// 		\amp1, Pdefn(\d_BeatVol1, 0.5, inf),
	// 		\amp2, Pdefn(\d_BeatVol2, 0.5, inf),
	// 		\amp3, Pdefn(\d_BeatVol3, 0.5, inf),
	// 		\amp4, Pdefn(\d_BeatVol4, 0.5, inf)
	// ));


	// Pdefn(\d_BeatVol1, Prand([
	// 	Pseries(0.5, -0.01, 50),
	// 	0.5], inf));
	// Pdefn(\d_BeatVol2, Prand([
	// 	Pseries(0.5, -0.01, 50),
	// 	0.5], inf));
	// Pdefn(\d_BeatVol3, Prand([
	// 	Pseries(0.5, -0.01, 50),
	// 	0.5], inf));
	// Pdefn(\d_BeatVol4, Prand([
	// 	Pseries(0.5, -0.01, 50),
	// 	0.5], inf));


	// sp.wait(5.0);

	// Pbindef(\swarmBeat).stop;

	// Pdefn(\d_vol1, Pseq([Pseries(0.5, -0.005, 100), Pn(0)], 1));

	// sp.wait(2.0);
	// Pdefn(\d_vol2, Pseq([Pseries(0.5, -0.005, 100), Pn(0)], 1));

	// sp.wait(2.0);
	// Pdefn(\d_vol3, Pseq([Pseries(0.5, -0.005, 100), Pn(0)], 1));

	// sp.wait(2.0);
	// Pdefn(\d_vol4, Pseq([Pseries(0.5, -0.005, 100), Pn(0)], 1));

	// sp.wait(1.0);

	// sp.par( Pbindef(\swarmBeat).stop );


	//	~droneID.postln;
	//  ~limitID.postln;


});


[
	\pattern1 -> Pbind(\instrument, \test,
		\nharms, Pshuf([4, 10, 40], inf),
		\dur, Pseq([1, 1, 2, 1]/10, inf),
		#[freq, sustain], Ptuple([ // assignment to multiple keys
			Pseq( (1..16) * 20, 4),
			Pseq([1/10, 0.5, 1, 2], inf)
		])),

	\pattern2 -> Pbind(\instrument, \test,
		\nharms, Pshuf([4, 6, 8], inf),
		\dur, Pseq([1, 1, 2, 1]/20, inf),
		#[freq, sustain], Ptuple([ // assignment to multiple keys
			Pseq( (1..16) * 50, 4),
			Pseq([1/10, 0.5, 1, 2], inf)
		])),

	\swarmSawMono -> Pmono(\swarmSaw,
		\dur, Pdefn(\swarmSawDur, Pmeanrand(1, 5)),
		\out, Pdefn(\swarmSawOut, 0, inf),
		\frqOffset, Pdefn(\swarmSawFrqOffset, Pmeanrand(10, 50)),
		\frqSpread, Pdefn(\swarmSawFrqSpread, Pmeanrand(5, 25)),
		\freq1, Pdefn(\swarmSawFreq1, Pmeanrand(50, 70)),
		\freq2, Pdefn(\swarmSawFreq2, Pmeanrand(50, 70)),
		\freq3, Pdefn(\swarmSawFreq3, Pmeanrand(50, 70)),
		\freq4, Pdefn(\swarmSawFreq4, Pmeanrand(50, 70)),
		\amp1, Pdefn(\swarmSawAmp1, Pmeanrand(0.1, 0.25)),
		\amp2, Pdefn(\swarmSawAmp2, Pmeanrand(0.1, 0.25)),
		\amp3, Pdefn(\swarmSawAmp3, Pmeanrand(0.1, 0.25)),
		\amp4, Pdefn(\swarmSawAmp4, Pmeanrand(0.1, 0.25)),
		\rlpfrq1, Pdefn(\swarmSawRlpfrq, Pmeanrand(100, 500)),
		\rlpfrq2, Pdefn(\swarmSawRlpfrq2, Pmeanrand(100, 500)),
		\rlpfrq3, Pdefn(\swarmSawRlpfrq3, Pmeanrand(100, 500)),
		\rlpfrq4, Pdefn(\swarmSawJamesRlpfrq4, Pmeanrand(100, 500)),
		\rlpfrqlag1, Pdefn(\swarmSawRlpfrqlag1, Pmeanrand(1, 5)),
		\rlpfrqlag2, Pdefn(\swarmSawRlpfrqlag2, Pmeanrand(1, 5)),
		\rlpfrqlag3, Pdefn(\swarmSawRlpfrqlag3, Pmeanrand(1, 5)),
		\rlpfrqlag4, Pdefn(\swarmSawRlpfrqlag4, Pmeanrand(1, 5)),
		\rlprq1, Pdefn(\swarmSawRlprq1, Pmeanrand(0.5, 1.5)),
		\rlprq2, Pdefn(\swarmSawRlprq2, Pmeanrand(0.5, 1.5)),
		\rlprq3, Pdefn(\swarmSawRlprq3, Pmeanrand(0.5, 1.5)),
		\rlprq4, Pdefn(\swarmSawRlprq4, Pmeanrand(0.5, 1.5)),
		\panx1, Pdefn(\swarmSawPanx1, Pmeanrand(-1.0)),
		\panx2, Pdefn(\swarmSawPanx2, Pmeanrand(-1.0)),
		\panx3, Pdefn(\swarmSawPanx3, Pmeanrand(-1.0)),
		\panx4, Pdefn(\swarmSawPanx4, Pmeanrand(-1.0)),
		\pany1, Pdefn(\swarmSawPany1, Pmeanrand(-1.0)),
		\pany2, Pdefn(\swarmSawPany2, Pmeanrand(-1.0)),
		\pany3, Pdefn(\swarmSawPany3, Pmeanrand(-1.0)),
		\pany4, Pdefn(\swarmSawPany4, Pmeanrand(-1.0)),
		\panxlag1, Pdefn(\swarmSawPanxlag1, Pmeanrand(1, 5)),
		\panxlag2, Pdefn(\swarmSawPanxlag2, Pmeanrand(1, 5)),
		\panxlag3, Pdefn(\swarmSawPanxlag3, Pmeanrand(1, 5)),
		\panxlag4, Pdefn(\swarmSawPanxlag4, Pmeanrand(1, 5)),
		\panylag1, Pdefn(\swarmSawPanylag1, Pmeanrand(1, 5)),
		\panylag2, Pdefn(\swarmSawPanylag2, Pmeanrand(1, 5)),
		\panylag3, Pdefn(\swarmSawPanylag3, Pmeanrand(1, 5)),
		\panylag4, Pdefn(\swarmSawPanylag4, Pmeanrand(1, 5)),
		\frqlag1, Pdefn(\swarmSawFrqlag1, Pmeanrand(1, 5)),
		\frqlag2, Pdefn(\swarmSawFrqlag2, Pmeanrand(1, 5)),
		\frqlag3, Pdefn(\swarmSawFrqlag3, Pmeanrand(1, 5)),
		\frqlag4, Pdefn(\swarmSawFrqlag4, Pmeanrand(1, 5)),
		\amplag1, Pdefn(\swarmSawAmplag1, Pmeanrand(1, 5)),
		\amplag2, Pdefn(\swarmSawAmplag2, Pmeanrand(1, 5)),
		\amplag3, Pdefn(\swarmSawAmplag3, Pmeanrand(1, 5)),
		\amplag4, Pdefn(\swarmSawAmplag4, Pmeanrand(1, 5))
	),

	\fadeOut -> Pseries(0.2, -0.05, 40)
]


	sp.wait(1.0);

	sp.par(
		Pbindef(\swarmFade,
			\dur, Pdefn(\d_ampDur, 1, inf),
			\instrument, \swarmSaw,
			\id, ~droneID,
			\type, \set,
			\args, #[],
			\amp1, Pdefn(\d_amp1, 0.5, inf),
			\amp2, Pdefn(\d_amp2, 0.5, inf),
			\amp3, Pdefn(\d_amp3, 0.5, inf),
			\amp4, Pdefn(\d_amp4, 0.5, inf),
			\amplag1, Pdefn(\d_ampLag1, 1, inf),
			\amplag2, Pdefn(\d_ampLag2, 1, inf),
			\amplag3, Pdefn(\d_ampLag3, 1, inf),
			\amplag4, Pdefn(\d_ampLag4, 1, inf)));


	sp.par(
		Pbindef(\swarmPan,
			\instrument, \swarmSaw,
			\id, ~droneID,
			\type, \set,
			\args, #[],
			\dur, Pdefn(\d_panDur, 0.5),
			\pos1, Pdefn(\d_pan1, Pbrown(-1, 1, 0.125, inf)),
			\pos2, Pdefn(\d_pan2, Pbrown(-1, 1, 0.125, inf)),
			\pos3, Pdefn(\d_pan3, Pbrown(-1, 1, 0.125, inf)),
			\pos4, Pdefn(\d_pan4, Pbrown(-1, 1, 0.125, inf))));



	sp.par(

		Pdefn(\d_amp1, Pseq([
			Pseries(0, 0.005, 100),
			Pn(Pbrown(0.25, 0.55, 0.0125))
		], 1));

		Pdefn(\d_amp2, Pseq([
			Pseries(0, 0.005, 100),
			Pn(Pbrown(0.25, 0.55, 0.0125))
		], 1));

		Pdefn(\d_amp3, Pseq([
			Pseries(0, 0.005, 100),
			Pn(Pbrown(0.25, 0.55, 0.0125))
		], 1));


		Pdefn(\d_amp4, Pseq([
			Pseries(0, 0.005, 100),
			Pn(Pbrown(0.25, 0.55, 0.0125))
		], 1));

	);


	sp.wait((2.0).rand + 15.0);

	Pbindef(\swarmFade).stop;















	// sp.par(
	//  Pdefn(\d_ampLag1, 0.01, inf);
	//  Pdefn(\d_ampLag2, 0.01, inf);
	//  Pdefn(\d_ampLag3, 0.01, inf);
	//  Pdefn(\d_ampLag4, 0.01, inf);
	// );

	// sp.wait(1.0);


	//	~droneID[0].asTarget.set( \amp1, 0, \amp2, 0, \amp3, 0, \amp4, 0);

	// .asTarget.free;

	//	sp.wait((1.0).rand + 4.0);

	// Pdefn(\d_volLag1, Pseq([
	// 	Pseries(1, -0.05, 100),
	// 	Pn(0.5)
	// 	], 1), inf);

	// sp.wait((1.0).rand);

	// Pdefn(\d_volLag2, Pseq([
	// 	Pseries(1, -0.05, 100),
	// 	Pn(0.5)
	// 	], 1), inf);

	// 	sp.wait((1.0).rand);

	// Pdefn(\d_volLag3, Pseq([
	// 	Pseries(1, -0.05, 100),
	// 	Pn(0.5)
	// 	], 1), inf);

	// 	sp.wait((1.0).rand);

	// Pdefn(\d_volLag4, Pseq([
	// 	Pseries(1, -0.05, 100),
	// 	Pn(0.5)
	// 	], 1), inf);

	// 	sp.wait((4.0));


	// sp.par(
	// 	Pbindef(\swarmPitch1,
	// 		\instrument, \swarmSaw,
	// 		\id, ~droneID,
	// 		\type, \set,
	// 		\args, #[],
	// 		\dur, Pdefn(\swarmPitchDur1, Pwhite(0.1, 0.25)),
	// 		\freq1, Pdefn(\d_frq1, Pbrown(40, 80, 0.25, inf))
	// 	));

	// sp.wait((1.0).rand + 2.0);

	// sp.par(
	// 	Pbindef(\swarmPitch2,
	// 		\instrument, \swarmSaw,
	// 		\id, ~droneID,
	// 		\type, \set,
	// 		\args, #[],
	// 		\dur, Pdefn(\swarmPitchDur2, Pwhite(0.1, 0.25)),
	// 		\freq2, Pdefn(\d_frq2, Pbrown(80, 120, 0.5, inf))
	// 	));

	// sp.wait((1.0).rand + 2.0);

	// sp.par(
	// 	Pbindef(\swarmPitch3,
	// 		\instrument, \swarmSaw,
	// 		\id, ~droneID,
	// 		\type, \set,
	// 		\args, #[],
	// 		\dur, Pdefn(\swarmPitchDur3, Pwhite(0.1, 0.25)),
	// 		\freq3, Pdefn(\d_frq3, Pbrown(160, 240, 1, inf))
	// 	));

	// 	sp.wait((10.0).rand + 2.0);

	// sp.par(
	// 	Pbindef(\swarmPitch4,
	// 		\instrument, \swarmSaw,
	// 		\id, ~droneID,
	// 		\type, \set,
	// 		\args, #[],
	// 		\dur, Pdefn(\swarmPitchDur4, Pwhite(0.1, 0.25)),
	// 		\freq4, Pdefn(\d_frq4, Pbrown(240, 1400, 5, inf))
	// 	));


	// sp.par(
	// 	Pbindef(\swarmPitch,
	// 		\instrument, \swarmSaw,
	// 		\id, ~droneID,
	// 		\type, \set,
	// 		\args, #[],
	// 		\dur, Pdefn(\swarmPitchDur, Pwhite(0.1, 0.25)),
	// 		\frqOffset, Pdefn(\d_frq1, Pbrown(40, 60, 0.125, inf))
	// 	));





	// faded in
	//
	// sp.wait(5.0);
	//
	//
	//
	// sp.wait(10.0);

	// sp.par(
	// 	Pbindef(\swarmBeat,
	// 		\instrument, \swarmSaw,
	// 		\id, ~droneID,
	// 		\type, \set,
	// 		\args, #[],
	// 		\amplag1, 0.05,
	// 		\amplag2, 0.05,
	// 		\amplag3, 0.05,
	// 		\amplag4, 0.05,
	// 		\dur, Pdefn(\swarmBeatDur, Pwhite(0.1, 0.25)),

	// 		\amp1, Pdefn(\d_BeatVol1, 0.5, inf),
	// 		\amp2, Pdefn(\d_BeatVol2, 0.5, inf),
	// 		\amp3, Pdefn(\d_BeatVol3, 0.5, inf),
	// 		\amp4, Pdefn(\d_BeatVol4, 0.5, inf)
	// ));


	// Pdefn(\d_BeatVol1, Prand([
	// 	Pseries(0.5, -0.01, 50),
	// 	0.5], inf));
	// Pdefn(\d_BeatVol2, Prand([
	// 	Pseries(0.5, -0.01, 50),
	// 	0.5], inf));
	// Pdefn(\d_BeatVol3, Prand([
	// 	Pseries(0.5, -0.01, 50),
	// 	0.5], inf));
	// Pdefn(\d_BeatVol4, Prand([
	// 	Pseries(0.5, -0.01, 50),
	// 	0.5], inf));


	// sp.wait(5.0);

	// Pbindef(\swarmBeat).stop;

	// Pdefn(\d_vol1, Pseq([Pseries(0.5, -0.005, 100), Pn(0)], 1));

	// sp.wait(2.0);
	// Pdefn(\d_vol2, Pseq([Pseries(0.5, -0.005, 100), Pn(0)], 1));

	// sp.wait(2.0);
	// Pdefn(\d_vol3, Pseq([Pseries(0.5, -0.005, 100), Pn(0)], 1));

	// sp.wait(2.0);
	// Pdefn(\d_vol4, Pseq([Pseries(0.5, -0.005, 100), Pn(0)], 1));

	// sp.wait(1.0);

	// sp.par( Pbindef(\swarmBeat).stop );


	//	~droneID.postln;
	//  ~limitID.postln;

	/*


	sp.wait((2.0).rand + 3.0);


	sp.par(
	Pbindef(\swarmAmp,
	\dur, Pdefn(\d_ampDur, Pwhite(0.8, 1.2), inf),
	\instrument, \swarmSaw,
	\id, ~droneID,
	\type, \set,
	\args, #[],
	\amp1, Pdefn(\d_amp1, Pbrown(0.25, 0.55, 0.0125), inf),
	\amp2, Pdefn(\d_amp2, Pbrown(0.25, 0.55, 0.0125), inf),
	\amp3, Pdefn(\d_amp3, Pbrown(0.25, 0.55, 0.0125), inf),
	\amp4, Pdefn(\d_amp4, Pbrown(0.25, 0.55, 0.0125), inf),
	\amplag1, Pdefn(\d_ampLag1, Pbrown(0.1, 0.5, 0.0125), inf),
	\amplag2, Pdefn(\d_ampLag2, Pbrown(0.1, 0.5, 0.0125), inf),
	\amplag3, Pdefn(\d_ampLag3, Pbrown(0.1, 0.5, 0.0125), inf),
	\amplag4, Pdefn(\d_ampLag4, Pbrown(0.1, 0.5, 0.0125), inf)));



	sp.par(
	Pbindef(\swarmFreq1,
	\dur, Pdefn(\d_freq1Dur,
	Pseq([
	Pseries(1, -0.1, 10),
	Pn(Pbrown(0.08, 0.12, 0.01))
	], 1)),
	\instrument, \swarmSaw,
	\id, ~droneID,
	\type, \set,
	\args, #[],

	\freq1, Pdefn(\d_freq1,
	Pbrown(50, 30, 100, 0.1, 200)),

	\freqlag1, Pdefn(\d_freqLag1,
	Pseq([
	Pseries(10, -0.1, 100),
	Pn(Pbrown(0.08, 0.12, 0.01))], 1)));

	Pbindef(\swarmFreq2,
	\dur, Pdefn(\d_freq2Dur,
	Pseq([
	Pseries(1, -0.1, 10),
	Pn(Pbrown(0.08, 0.12, 0.01))
	], 1)),
	\instrument, \swarmSaw,
	\id, ~droneID,
	\type, \set,
	\args, #[],

	\freq2, Pdefn(\d_freq2, Pbrown(
	Pseries(100, -5, 20),
	100, 0.25)),

	\freqlag2, Pdefn(\d_freqLag2,
	Pseq([
	Pseries(1, -0.1, 10),
	Pn(Pbrown(0.08, 0.12, 0.01))], 1)));

	Pbindef(\swarmFreq3,
	\dur, Pdefn(\d_freq3Dur,
	Pseq([
	Pseries(1, -0.1, 10),
	Pn(Pbrown(0.08, 0.12, 0.01))
	], 1)),
	\instrument, \swarmSaw,
	\id, ~droneID,
	\type, \set,
	\args, #[],

	\freq3, Pdefn(\d_freq3, Pbrown(
	Pseries(100, -1, 20),
	100, 0.25)),

	\freqlag3, Pdefn(\d_freqLag3,
	Pseq([
	Pseries(1, -0.1, 10),
	Pn(Pbrown(0.08, 0.12, 0.01))], 1)));

	Pbindef(\swarmFreq4,
	\dur, Pdefn(\d_freq4Dur,
	Pseq([
	Pseries(1, -0.1, 10),
	Pn(Pbrown(0.08, 0.12, 0.01))
	], 1)),
	\instrument, \swarmSaw,
	\id, ~droneID,
	\type, \set,
	\args, #[],

	\freq4, Pdefn(\d_freq4, Pbrown(
	Pseries(200, -4, 20),
	200,
	0.25)),

	\freqlag4, Pdefn(\d_freqLag4,
	Pseq([
	Pseries(1, -0.1, 10),
	Pn(Pbrown(0.08, 0.12, 0.01))], 1))));

	*/
