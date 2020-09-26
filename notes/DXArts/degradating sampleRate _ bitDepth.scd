(
Server.default = s = Server.internal.boot;
s.waitForBoot({
	s.scope; // look at the waveform (time-domain)
	f = FreqScope.new(600, 300, 0);  // look at the spectrum (frequency-domain)
	})
)


////////////////// –ÊSample-rate degradation (an approximate emulation)

// original white noise
{WhiteNoise.ar.dup}.play
// original complex signal (has randomness)
{{SinOsc.ar(exprand(100, 22050))}.dup(30).sum * 0.08}.play;

(
a = CtkSynthDef(\fft1, {arg fftbuf, wipe = 0.0, sampleRate, sinFreq = 220;
	var sig, sah, chain, out, env;
	// using white noise
	sig = WhiteNoise.ar;
	// using a complex signal
//	sig = {SinOsc.ar(exprand(100, 22050))}.dup(30).sum * 0.08;
	sah = Latch.ar(sig, Impulse.ar(sampleRate));
	chain = FFT(fftbuf, sah);
	chain = PV_BrickWall(chain, wipe);
	out = IFFT(chain);
	Out.ar(0, out.dup); // send out stereo
	});
)

b = CtkBuffer.buffer(4096).load; // will have 1024 bins
f =  { arg freq; 2 * freq/s.sampleRate };



// our starting point is not quite like the original, but close enough for demonstration purposes
z = a.note.fftbuf_(b).wipe_(f.value(22050)-1).sampleRate_(22050).play; 

// SampleRate: 22050 
z.wipe_(f.value(11025)-1).sampleRate_(22050); 
// SampleRate: 11025 
z.wipe_(f.value(11025/2)-1).sampleRate_(22050/2); 
// SampleRate: 5512 
z.wipe_(f.value(11025/4)-1).sampleRate_(22050/4); 


////////////////// –ÊBit depth degradation
// move the mouse to degrade the signal
(
x = {
	// using white noise
	//var sig = WhiteNoise.ar;
	// using a sine tone
	var sig = SinOsc.ar(220); 
	// using a complex signal
	//var sig = {SinOsc.ar(exprand(100, 22050))}.dup(30).sum * 0.08;
	var crunch = MouseX.kr(0.000000001, 1);
	sig.round(crunch).dup;
}.play(s);
)