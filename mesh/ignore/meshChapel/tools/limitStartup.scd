s.doWhenBooted({
	~limitGroup = Group.after(1);


	SynthDef(\limiter, {|limit=0.5, time=0.1|
		ReplaceOut.ar(bus: 0, channelsArray: Sanitize.ar(
			in: Limiter.ar( in: In.ar(bus: 0, numChannels: 4),
				level: limit, dur: time), replace: 0))}).add;

	~limiter = Synth.new(\limiter, ~limitGroup, addToTail);

	"Limiter engaged".postln;

});


g=Group.after(67109867)

67109865

	SynthDef(\limiter, {|limit=0.5, time=0.1|
		ReplaceOut.ar(bus: 0, channelsArray: Sanitize.ar(
			in: Limiter.ar( in: In.ar(bus: 0, numChannels: 4),
				level: limit, dur: time), replace: 0))}).add;


Synth.new(\limiter, target: ~limitGroup);

~limitGroup = Group.after(67109865)

~limitGroup = 67109867.asTarget

67109864.asTarget.free