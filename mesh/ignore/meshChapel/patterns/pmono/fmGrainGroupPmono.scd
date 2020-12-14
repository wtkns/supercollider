~fmGroup = Group.new;
~fmGroup.post

(
~fmGrain1_mono=Pmono(
    \fmGrain,
    \group, ~fmGroup,
    \gate, Pdefn(\fmGrain1t_gate_mono, 1, inf),
    \dur, Pdefn(\fmGrain1dur_mono, Pexprand(0.01, 0.1)),
    \len, Pdefn(\fmGrain1len_mono, 0.2, inf),
    \indexRangeHi, Pdefn(\fmGrain1indexRangeHi_mono, Pexprand(10, 100)),
    \amp, Pdefn(\fmGrain1amp_mono, 0.1, inf),
    \carfreq, Pdefn(\fmGrain1carfreq_mono, 440, inf),
    \panY, Pdefn(\fmGrain1panY_mono, Pbrown(-1, 1)),
    \modfreq, Pdefn(\fmGrain1modfreq_mono, 2200-Pexprand(100, 1600)),
    \indexRate, Pdefn(\fmGrain1indexRate_mono, 10, inf),
    \panX, Pdefn(\fmGrain1panX_mono, Pbrown(-1, 1)),
    \indexRangeLow, Pdefn(\fmGrain1indexRangeLow_mono, 1, inf),
    \freq, Pdefn(\fmGrain1freq_mono, 20, inf)
).play;


~fmGrain2_mono=Pmono(
    \fmGrain,
    \group, ~fmGroup,
    \gate, Pdefn(\fmGrain2t_gate_mono, 1, inf),
    \dur, Pdefn(\fmGrain2dur_mono, Pexprand(0.01, 0.1)),
    \len, Pdefn(\fmGrain2len_mono, 0.2, inf),
    \indexRangeHi, Pdefn(\fmGrain2indexRangeHi_mono, Pexprand(10, 100)),
    \amp, Pdefn(\fmGrain2amp_mono, 0.1, inf),
    \carfreq, Pdefn(\fmGrain2carfreq_mono, 440, inf),
    \panY, Pdefn(\fmGrain2panY_mono, Pbrown(-1, 1)),
    \modfreq, Pdefn(\fmGrain2modfreq_mono, 2200-Pexprand(100, 1600)),
    \indexRate, Pdefn(\fmGrain2indexRate_mono, 10, inf),
    \panX, Pdefn(\fmGrain2panX_mono, Pbrown(-1, 1)),
    \indexRangeLow, Pdefn(\fmGrain2indexRangeLow_mono, 1, inf),
    \freq, Pdefn(\fmGrain2freq_mono, 20, inf)
).play;


~fmGrain3_mono=Pmono(
    \fmGrain,
    \group, ~fmGroup,
    \gate, Pdefn(\fmGrain3t_gate_mono, 1, inf),
    \dur, Pdefn(\fmGrain3dur_mono, Pexprand(0.01, 0.1)),
    \len, Pdefn(\fmGrain3len_mono, 0.2, inf),
    \indexRangeHi, Pdefn(\fmGrain3indexRangeHi_mono, Pexprand(10, 100)),
    \amp, Pdefn(\fmGrain3amp_mono, 0.1, inf),
    \carfreq, Pdefn(\fmGrain3carfreq_mono, 440, inf),
    \panY, Pdefn(\fmGrain3panY_mono, Pbrown(-1, 1)),
    \modfreq, Pdefn(\fmGrain3modfreq_mono, 2200-Pexprand(100, 1600)),
    \indexRate, Pdefn(\fmGrain3indexRate_mono, 10, inf),
    \panX, Pdefn(\fmGrain3panX_mono, Pbrown(-1, 1)),
    \indexRangeLow, Pdefn(\fmGrain3indexRangeLow_mono, 1, inf),
    \freq, Pdefn(\fmGrain3freq_mono, 20, inf)
).play;

)

~fmGrain1_mono.stop
~fmGrain2_mono.stop
~fmGrain3_mono.stop


Pdefn(\fmGrain1dur_mono, Pexprand(15, 45))
Pdefn(\fmGrain2dur_mono, Pexprand(15, 45))
Pdefn(\fmGrain3dur_mono, Pexprand(15, 45))


201327592.asTarget.free

