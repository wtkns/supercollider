Quarks.gui

(
{SinOsc.ar(440, 0, 0.2)}.play
)

"hello world".postln;

s.boots.quit

s.quit

s.boot


(
{
var ampOsc;
ampOsc=SinOsc.kr(0.5, 1.5pi, 0.5, 0.5);
SinOsc.ar(440,0, ampOsc);
}.play
)

(
{[SinOsc.ar([80,120,440], 0, 0.2), SinOsc.ar(442, 0, 0.2)]}.play;
)