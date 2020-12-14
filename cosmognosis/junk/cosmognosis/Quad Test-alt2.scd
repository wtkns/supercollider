(

var left, right, front, back;

front = 1;
back = -1;
left = -1;
right = 1;

SynthDef("help-Pan4", {Out.ar(0, Pan4.ar(PinkNoise.ar, Line.kr(left, right, 5), Line.kr(back, front, 5), 0.3))}).play;


)

Env