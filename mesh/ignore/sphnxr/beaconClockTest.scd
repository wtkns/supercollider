

("~/git/sphnxr/init.scd").loadPaths;
("~/git/sphnxr/tests.scd").loadPaths;

(
// test with a click
Pbind(\instrument, \click, \freq, Pfunc({"beats: % tempo:
%\n".postf(~clock.beats, ~clock.tempo); rrand(440, 1200)
})).play(~clock, quant: 1);
)

Pbind(\freq, Pfunc({"beats: % tempo: %\n".postf(~clock.beats, ~clock.tempo); rrand(440, 1200) })).play(~clock, quant: 1);


(
Pbind(\instrument, \sin, \freq, Pfunc({"beats: % tempo:
%\n".postf(~clock.beats, ~clock.tempo); rrand(440, 1200)
})).play(~clock, quant: 1);
)


~clock.setGlobalTempo(1,10);
~clock.setGlobalTempo(2,10);
~clock.setGlobalTempo(3,0);
~clock.setGlobalTempo(4,0 );
~clock.setGlobalTempo(6,90 );

~clock.tempo = 1
~clock.tempo = 2
~clock.tempo = 3

~clock.setGlobalTempo(3, 90)

~clock.fadeTempo(10, 3)

~clock.warpTempo(2, 30)

Pbind(\freq, rrand(440, 880)).play(~clock, quant: 1);

t = TempoClock.new(2, 5);
"current beats:" + t.beats;

