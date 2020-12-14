(
var score, blipgen, blip, moogy;
score = CtkScore.new;
blip = CtkAudio.new(2, server: s);
blip.bus.postln;

// source 
blipgen = CtkSynthDef(\blip, {
	Out.ar(blip, Blip.ar(Line.kr(1,100,20), Line.kr(1,100,20), 0.8))
});

moogy = CtkSynthDef(\moogy, {
	var src, filter;
	src = In.ar(blip);
	filter = MoogFF.ar(src,SinOsc.kr(LFNoise0.kr(0.42).range(0.001,2.2)).range(30,4200), 0.83 * 4);
 	
 	Out.ar(0, Pan2.ar(filter, 0))
 });

score.add(blipgen.note(0.0, 20.0));
score.add(moogy.note(0.1, 20.0));

score.play;
)
