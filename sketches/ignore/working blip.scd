(
var score, blipgen, blip;
score = CtkScore.new;
blip = CtkAudio.new(2, server: s);
blip.bus.postln;
blipgen = CtkSynthDef(\blip, {
Out.ar(0, Blip.ar(Line.kr(1,100,20), Line.kr(1,100,20), 0.8))
});

score.add(blipgen.note(0.0, 20.0));
score.play;
)

