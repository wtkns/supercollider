// Robert vosim
SynthDef(\vosim, {|
   amp=0.45,
    att = 0.15,
    t_gate=1,
    len = 1,
    harms = 6,
    out = 0,
    impfreq = 1,
    impdepth = 9,
    freq = 400,
    freqspread = 1.06,
    endfreq = 1,
    ncycles = 4,
    decay = 0.9|


    var env = Env([0.001, amp, 0.001], [att, len- att], [\lin, \sin]);
    var envGen = EnvGen.kr(env, t_gate, timeScale: len, doneAction: 0);
    harms.do({|i|
        Out.ar(out, Pan2.ar(VOSIM.ar(Impulse.ar(
            SinOsc.kr(impfreq, 1/(i+1), i+1*impdepth, i+1*impdepth+1)),
            EnvGen.kr(Env([freq*i*freqspread, freq*i*freqspread,
            freq*i*freqspread*endfreq], [0, len]), t_gate, timeScale: len, doneAction: 0),
            ncycles,
            decay),
           SinOsc.kr(SinOsc.kr(i+1*0.47, 4, 1)), 1/harms)
                  )*envGen});
}, metadata:(
	\dur: Pwrand([2, 0.4, 1], [0.5, 0.3, 0.2], inf),
	\amp: Pseq([0.01], inf),
	\att: Pwhite(0.001, 1, inf),
	\t_gate: Pseq([1], inf),
	\len: Pseq([1], inf),
	\harms: Pbrown(1, 12, 1),
	\out: Pseq([0], inf),
	\impfreq: Pn(Pgeom(10, 1.06, 30)),
	\impdepth: Pwhite(1, 9),
	\freq: Pseq([400], inf),
	\freqspread: Pn(Pgeom(1.06, 1.06, 40), inf),
	\endfreq: Prand([40, 60, 10, 80, 5], inf),
    \ncycles: Pshuf([8, 12, 16, 20, 7], inf),
    \decay: Pn(Pseries(1, -0.1, 8), inf)

)).add;







