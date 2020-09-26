s = Server.internal.boot;
// look at the waveform
s.scope;
// look at the spectral results
FreqScope.new(600, 300, 0);

// frequency to play
~freq = 220;

// Sine wave
{SinOsc.ar(~freq)}.play;

// Square wave (non-band-limited)
{LFPulse.ar(~freq, mul:2, add:-1)}.play;

// Triangle wave (non-band-limited)
{LFTri.ar(~freq)}.play;

// Sawtooth wave (non-band-limited)
{LFSaw.ar(~freq)}.play;

