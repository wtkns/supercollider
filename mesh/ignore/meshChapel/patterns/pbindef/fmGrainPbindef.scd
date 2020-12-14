
 201327593 group
         201327596 fmGrain
         201327595 fmGrain
         201327594 fmGrain
~groupNode = 201327593.asTarget;
~synth1Node = 201327596.asTarget;
~synth2Node = 201327595.asTarget;
~synth3Node = 201327594.asTarget;

~fmGrainGroupBindef1.stop

~fmGrainGroupBindef1 = Pbindef(\fmGrainGroupBindef1,
	\instrument, \fmGrain,
	\id, ~groupNode,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\fmGrainDurBindef1, Pexprand(0.1, 0.25))
).play;

Pdefn(\fmGrainDurBindef1, Pexprand(0.01, 0.125));
Pdefn(\fmGrainDurBindef1, Pexprand(0.1, 0.25));

~fmGrainSynth1Bindef = Pbindef(\fmGrainSynth1Bindef,
	\instrument, \fmGrain,
	\id, ~synth1Node,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\fmGrainSynth1Dur, Pexprand(0.001, 0.5))
).play;

Pdefn(\fmGrainSynth1Dur, Pexprand(0.001, 0.5));

~fmGrainSynth2Bindef = Pbindef(\fmGrainSynth2Bindef,
	\instrument, \fmGrain,
	\id, ~synth2Node,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\fmGrainSynth2Dur, Pexprand(0.001, 0.5))
).play;

Pdefn(\fmGrainSynth2Dur, Pexprand(0.001, 0.5))

~fmGrainSynth3Bindef = Pbindef(\fmGrainSynth3Bindef,
	\instrument, \fmGrain,
	\id, ~synth3Node,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\fmGrainSynth3Dur, Pexprand(0.001, 0.5))
).play;






Pbindef(\fmGrainGroupBindef1, \amp, Pdefn(\fmGrainGroupAmp, Pexprand(0.01, 0.15)));
Pbindef(\fmGrainSynth1Bindef, \amp, Pdefn(\fmGrainSynth1Amp, Pexprand(0.001, 0.5)));
Pbindef(\fmGrainSynth2Bindef, \amp, Pdefn(\fmGrainSynth2Amp, Pexprand(0.001, 0.5)));
Pbindef(\fmGrainSynth3Bindef, \amp, Pdefn(\fmGrainSynth3Amp, Pexprand(0.001, 0.5)));


Pbindef(\fmGrainGroupBindef1, \dur, Pdefn(\fmGrainGroupDur, Pwhite(1, 5)));
Pbindef(\fmGrainSynth1Bindef, \dur, Pdefn(\fmGrainSynth1Dur, Pwhite(1, 5)));
Pbindef(\fmGrainSynth2Bindef, \dur, Pdefn(\fmGrainSynth2Dur, Pexprand(1, 5)));
Pbindef(\fmGrainSynth3Bindef, \dur, Pdefn(\fmGrainSynth3Dur, Pexprand(1, 5)));

Pbindef(\fmGrainGroupBindef1, \freq, Pdefn(\fmGrainGroupFreq,Pshuf([200, 240, 440, 600], inf)));
Pbindef(\fmGrainSynth1Bindef, \freq, Pdefn(\fmGrainSynthFreq,Pshuf([200, 240, 440, 600], inf)));
Pbindef(\fmGrainSynth2Bindef, \freq, Pdefn(\fmGrainSynth2Freq,Pshuf([200, 240, 440, 600], inf)));
Pbindef(\fmGrainSynth3Bindef, \freq, Pdefn(\fmGrainSynth3Freq,Pshuf([200, 240, 440, 600], inf)));

Pbindef(\fmGrainGroupBindef1, \carfreq, Pdefn(\fmGrainGroupCarFreq,Pshuf([200, 240, 440, 600], inf)));
Pbindef(\fmGrainSynth1Bindef, \carfreq, Pdefn(\fmGrainSynthCarFreq,Pshuf([200, 240, 440, 600], inf)));
Pbindef(\fmGrainSynth2Bindef, \carfreq, Pdefn(\fmGrainSynth2CarFreq,Pshuf([200, 240, 440, 600], inf)));
Pbindef(\fmGrainSynth3Bindef, \carfreq, Pdefn(\fmGrainSynth3CarFreq,Pshuf([200, 240, 440, 600], inf)));

Pbindef(\fmGrainGroupBindef1, \modfreq, Pdefn(\fmGrainGroupModFreq,Pshuf([200, 240, 440, 600], inf)));
Pbindef(\fmGrainSynth1Bindef, \modfreq, Pdefn(\fmGrainSynthModFreq,Pshuf([200, 240, 440, 600], inf)));
Pbindef(\fmGrainSynth2Bindef, \modfreq, Pdefn(\fmGrainSynth2ModFreq,Pshuf([200, 240, 440, 600], inf)));
Pbindef(\fmGrainSynth3Bindef, \modfreq, Pdefn(\fmGrainSynth3ModFreq,Pshuf([200, 240, 440, 600], inf)));

Pbindef(\fmGrainGroupBindef1, \modfreq, Pdefn(\fmGrainGroupModFreq,Pshuf([200, 240, 440, 600], inf)));
Pbindef(\fmGrainSynth1Bindef, \modfreq, Pdefn(\fmGrainSynthModFreq,Pshuf([200, 240, 440, 600], inf)));
Pbindef(\fmGrainSynth2Bindef, \modfreq, Pdefn(\fmGrainSynth2ModFreq,Pshuf([200, 240, 440, 600], inf)));
Pbindef(\fmGrainSynth3Bindef, \modfreq, Pdefn(\fmGrainSynth3ModFreq,Pshuf([200, 240, 440, 600], inf)));

Pbindef(\fmGrainGroupBindef1, \panX, Pdefn(\fmGrainGroupPanX,Pmeanrand(-1.0, 1.0, inf)));
Pbindef(\fmGrainSynth1Bindef, \panX, Pdefn(\fmGrainSynthPanX,Pmeanrand(-1.0, 1.0, inf)));
Pbindef(\fmGrainSynth2Bindef, \panX, Pdefn(\fmGrainSynth2PanX,Pmeanrand(-1.0, 1.0, inf)));
Pbindef(\fmGrainSynth3Bindef, \panX, Pdefn(\fmGrainSynth3PanX,Pmeanrand(-1.0, 1.0, inf)));

Pbindef(\fmGrainGroupBindef1, \panY, Pdefn(\fmGrainGroupPanY, Pmeanrand(-1.0, 1.0, inf)));
Pbindef(\fmGrainSynth1Bindef, \panY, Pdefn(\fmGrainSynthPanY, Pmeanrand(-1.0, 1.0, inf)));
Pbindef(\fmGrainSynth2Bindef, \panY, Pdefn(\fmGrainSynth2PanY, Pmeanrand(-1.0, 1.0, inf)));
Pbindef(\fmGrainSynth3Bindef, \panY, Pdefn(\fmGrainSynth3PanY, Pmeanrand(-1.0, 1.0, inf)));


Pdefn(\fmGrainDurBindef1, Pexprand(0.01, 0.25));
Pdefn(\fmGrainSynth1Dur, Pexprand(0.01, 0.25));
Pdefn(\fmGrainSynth2Dur, Pexprand(0.01, 0.25));
Pdefn(\fmGrainSynth3Dur, Pexprand(0.01, 0.25));


~fmGrainSynth1Bindef.stop;
~fmGrainGroupBindef1.stop;
~fmGrainSynth2Bindef.stop;
~fmGrainSynth2Bindef.stop;