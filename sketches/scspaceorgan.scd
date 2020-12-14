s.options.memSize_(65536 * 4);
s.reboot;

{
    var src = SoundIn.ar(0)!2; // stereo input
    var rev = Greyhole.ar(
        src,
        \dtime.kr(0.1),
        \damp.kr(0.1),
        \size.kr(1),
        \diff.kr(0.707),
        \fb.kr(0.1),
        \modDepth.kr(0.01),
        \modFreq.kr(2)
    );

    Mix([src, rev]) * 0.1;
}.play

(
fork {
	TempoClock.tempo = 1;
	Ndef(\ttso).play;
	loop {
		var seed = thisThread.randSeed = 100000000.rand.debug('seed');
		var wait = 20.rrand(60).debug('wait');
		Ndef(\ttso, {
			var gamma= {[rrand(30,50),rrand(50,70),rrand(50,70),rrand(70,100)].choose.midicps*LFNoise2.kr(1,0.01,1)}!24;
			Pan2.ar(
				LeakDC.ar(
					Normalizer.ar(
						BPeakEQ.ar(
							FreeVerb.ar(
								Splay.ar(RLPF.ar(LFSaw.ar(gamma)/4,gamma*LFCub.kr(rrand(0.01,0.1),0,2,3),LFNoise2.kr(1/8,0.6,0.7))),
								0.1,0.1,0.1
							),
							[100.rrand(200),1000.rrand(2000),5000.rrand(7000),10000.rrand(15000)],Array.rand(4,0,6),Array.rand(4,0,6)
						).mean,
						0.8,0.1
					)
				),
				LFNoise2.kr(0.1.exprand(10)).range(-0.1,0.1),
				SelectX.kr(
					[SinOsc,LFTri].choose.kr(2.rrand(25).reciprocal).range(0,2),
					[
						0.7.rrand(1),
						LFGauss.kr(
							Latch.kr(
								LFNoise2.kr(1).range(1/5,5.rrand(20)).reciprocal,
								Impulse.kr(LFNoise2.kr(3.rrand(10).reciprocal).range(0.5,3.rrand(6)))
							),
							SinOsc.kr(3.rrand(15).reciprocal).range(0.07.rrand(0.16),0.25.rrand(0.4))
						),
						0.1.rrand(0.5)
					]
				)
			)
		}).fadeTime_(3.rrand(6));
		wait.wait;
	}
}
)