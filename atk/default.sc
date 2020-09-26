UGen.browse

~initGroups = Routine{
	~src_grp = Group.new;
	~filter_grp = Group.after(~src_grp);
	~output_grp = Group.after(~filter_grp);
	~stereomix_grp = Group.after(~output_grp);
	~initGroups.yieldAndReset;
};

~bootServer.play;
~setupEnv.play;
~initGroups.play;

~decoder = FoaDecoderKernel.newUHJ; // default (set in startup) super stereo
~decoder = FoaDecoderKernel.newCIPIC // KEMAR binaural (kernel)




// left f,b
{PinkNoise.ar([0.5,0,0.5,0])}.play;

// right f,b
{PinkNoise.ar([0.5,0,0.5,0].reverse)}.play;

// front l,r
{PinkNoise.ar([0.5,0.5,0,0])}.play;

// back l,r
{PinkNoise.ar([0.5,0.5,0,0].reverse)}.play;


// some quad droney drones

({
	var src = Pulse.ar(freq: [
		SinOsc.kr(1/10, 0).curverange(10, 60, 3),
		SinOsc.kr(1/66, (pi*(-1))).curverange(60, 120, 2),
		SinOsc.kr(1/123, 2pi).curverange(120, 460, 1),
		SinOsc.kr(1/257, pi).curverange(460, 1200, 0.5),
	], mul: 1.0, add: 0.0);


	var distAmt = SinOsc.kr(SinOsc.kr(1/300).range(1.0,10.0)).range(0.1, 0.5);
	var k = 2 * distAmt / (1 - distAmt);
	var sig = (1 + k) * src / (1 + (k * src.abs));

	var rqFreq = SinOsc.kr(freq: 0.1, phase: 0).curverange(100, Saw.kr(freq: 0.01).range(2000,5000), 3.0);
	var rqAmt = SinOsc.ar(0.1).range(0.1, 0.9);
	var filt = RLPF.ar(in: sig, freq: rqFreq, rq: rqAmt, mul: 0.25);

	Pan4.ar(filt, SinOsc.kr(20.0, 0, 0.75, 0.0 ), SinOsc.kr(100.0, 2pi, 0.75, 0.0 ), 0.25);
}.play;
)


// atk stuff starts here

~serverBoot.play;

(
~models = [0003, 0008, 0009, 0010, 0011, 0012, 0015, 0017, 0018, 0019, 0020, 0021, 0027, 0028, 0033, 0040, 0044, 0048, 0050, 0051, 0058, 0059, 0060, 0061, 0065, 0119, 0124, 0126, 0127, 0131, 0133, 0134, 0135, 0137, 0147, 0148, 0152, 0153, 0154, 0155, 0156, 0158, 0162, 0163, 0165];

// choose Foa Decoder
// ~decoder = FoaDecoderKernel.newCIPIC(~models[0]); //FoaDecoderKernel.newUHJ;
// ~decoder = FoaDecoderKernel.newListen(1002);
~decoder = FoaDecoderKernel.newUHJ(kernelSize: 8192);
//reserve 4 channel bus for bformat audio stream
~rtBus = Bus.audio(s,4);
)

(
// synth to encode to b-format
SynthDef(\bell, {
	arg outBus, freq = 200, decay = 0.2, theta = 0, phi = 0, amp = 0.2, prox = 0.5, out = 0;
	var sig, foa;
	var rqAmt = SinOsc.ar(0.1).range(0.5, 0.9);

	// start the source signal synth
	sig = Decay2.ar(Impulse.ar(0), 0.01, decay, SinOsc.ar(freq, 0, amp));
	// sig = BPF.ar(sig, freq, rqAmt, mul: 0.25);
	// sig = CombL.ar(sig, freq.reciprocal, freq.reciprocal, mul: 9.neg.dbamp);

	// encode x/y
	foa = FoaPanB.ar(sig, theta, phi);

	// apply "proximity"
	// foa = FoaTransform.ar(foa, \proximity, prox);

	// free synth when it's finished
	DetectSilence.ar(sig, time:0.1, doneAction:2);

	//output 4 channels for ambisonic B format
	Out.ar(outBus, foa);
}).add;

// Decoding Synth
SynthDef(\foaDecode, {arg inBus;
	var foa, out;
	var angle = MouseX.kr(-pi, pi);
	var prox = MouseY.kr(0.05, 0.1);

	// read in 4 channels (B-format) from inBus
	foa = In.ar(inBus, 4);

	// foa = FoaTransform.ar(foa, \proximity, prox);

	foa = FoaTransform.ar(foa, \rotate, angle);

	// decode to stereo
	out = FoaDecode.ar(foa, ~decoder);
	Out.ar(0, out);
}).add;
)

~decoderSink = Synth(\foaDecode, [\inBus, ~rtBus], s, \addToTail);

(
// play the synth
Pbind(
	\instrument, \bell,
	\outBus, ~rtBus,
	\dur, Prand([0.05, 0.1, 0.25, 0.5, 1.0], inf),
	\freq, Prand([500, 600, 200, 100, 60, 1000], inf),
	\amp, Prand([0.1, 0.2, 0.5], inf),
	\theta, Prand([0, pi/2, pi, -pi, -pi/2], inf),
	\decay, Prand([0.1, 0.2, 0.5, 1.5], inf),
	\prox, Prand([0.05, 0.1, 1.0, 5.0, 25.0], inf),
).play;

// press command period when done
CmdPeriod.doOnce({
	~decoderSink.free;
	~rtBus.free;
	~decoder.free;
});
)