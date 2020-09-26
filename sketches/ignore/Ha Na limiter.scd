// Stage limiter (based on a class by Batuhan Bozkurt)

// this is for 5 channels
// args: 
//	- bus, is the first bus you want to limit, i.e. nr 2 in your case
// 	- limit, is the limit value. 1 is the standard safe one, but you may be playing louder, which would also be safe enough. Above 3 you start getting into dangerous territory. Check with your speakers though, and how your current levels sound...

~stageLimit = SynthDef(\stageLimiter, {arg bus = 2, limit = 1;
var input;
	input = In.ar(bus, 5); // change nr of channels here if you need to
	input = Select.ar(CheckBadValues.ar(input, 0, 0), [input, DC.ar(0), DC.ar(0), input]);
	ReplaceOut.ar(bus, Limiter.ar(input, limit)) ;
			});


// just a really loud signal to test with
x = { WhiteNoise.ar(2) }.play;



// If you're using groups, make sure to add this in the tail of the target Group you're using. But, you 're probably not using groups, so the below code should work fine...
// create the instance
~safeLimit = Synth.new(\stageLimiter, addAction: \addToTail);
// remove it
~safeLimit.free

x.free
