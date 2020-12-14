s.boot

(
Pbindef(\sinDef).clear;

SynthDef(\partySin, {|out = 0,
    cps = 200,
    vol = 0.25,
    pos = 0,
    vol_lag = 0.01,
    cps_lag = 0.01|
    var sig = SinOsc.ar(cps.lag(cps_lag)) * vol.lag(vol_lag);
    Out.ar(out, Pan2.ar(sig, pos));
}).add();

Pmono(\partySin).collect{|event| ~nodeID = event[\id]; event}.play;

~node = ~nodeID[0].asTarget;

)


s.queryAllNodes


~patterns = (


	pitch = Pseq([100, 200, 300, 200, 400], inf);


~noteTime = Pseq([0.5, 0.75, 0.5, 1.0, 1.25], inf);
~restTime = Pseq([0.25], inf);
~envTime = Pseq([0.1, 0.4, 0.25, 0.25], inf);
~ampLevel = Pseq([0.5, 0.5, 0.25, 0], inf);

// interlace note times an rest times
~noteRestTime = Ppatlace([~noteTime, ~restTime], inf);

)



( Pbindef(\sinEnvDef,
	\instrument, \partySin,
	\id, ~nodeID,
	\type, \set,
	\args, #[],
	\dur, ~envTime,
	\vol, ~ampLevel,
	\vol_lag, ~envTime,
).play; )


////// stop




Pchain.new(~pitch,



x = ~noteRestTime.asStream;
)

x.next;





Pbindef(\sinDef).stop

(
Pchain(
    Pbind(\detune, Pseq([-30, 0, 40], inf), \dur, Prand([0.2, 0.4], inf)),
    Pbind(\degree, Pseq([1, 2, 3], inf), \dur, 1)
).trace.play;
)
