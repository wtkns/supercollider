{\rtf1\ansi\ansicpg1252\cocoartf1138\cocoasubrtf230
{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue191;\red191\green0\blue0;
\red0\green115\blue0;\red0\green0\blue255;\red96\green96\blue96;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs24 \cf2 s = \cf3 Server\cf2 .internal.boot;\
\cf3 Server\cf2 .default = s;\
s.scope(2);\
\
\cf4 /* A delay created with a buffer of memory. \
The delay results from reading the memory after it\
has been recorded into. */\cf2 \
\
a = \cf3 CtkSynthDef\cf2 (\cf5 \\fixeddel\cf2 , \{\cf6 arg\cf2  dur, deltime, buffer, out;\
	\cf6 var\cf2  env, src, delay;\
	env = \cf3 EnvGen\cf2 .kr(\
		\cf3 Env\cf2 ([0.0, 1.0, 1.0, 0.0], [0.001, 0.998, 0.001]), timeScale: dur); \
	\cf4 // a little noise burst\cf2 \
	src = \cf3 PinkNoise\cf2 .ar(0.5) * \cf3 Decay\cf2 .ar(\cf3 Impulse\cf2 .ar(1), 0.5);\
	\cf4 // record the source into a buffer\cf2 \
	\cf3 RecordBuf\cf2 .ar(src, buffer);\
	\cf4 // tap the delay line\cf2 \
	delay = \cf3 Tap\cf2 .ar(buffer, 1, deltime);\
	\cf3 Out\cf2 .ar(0, [src, delay] * env);\
	\});\
	\
\
b = \cf3 CtkBuffer\cf2 .buffer(65536 * 2).load; \cf4 // will allow up to 1.486 of delay (65536 / 44100)\cf2 \
\
c = a.note(0.0, 5.0).dur_(5.0).deltime_(0.9).buffer_(b).play;\
b.zero;\
\
65536/44100\
b.free;\
\
\cf4 /* \
\
In this example, SC's delay is used.  This uses memory that is allocated in from SC's real-time memory pool. \
\
s.options.memSize; // this shows the amount of memory the server allocates for these kinds of delays\
\
s.options.memSize_(32768); // you can increase it, but do this BEFORE you boot the server\
\
*/\cf2 \
\
a = \cf3 CtkSynthDef\cf2 (\cf5 \\delay\cf2 , \{\cf6 arg\cf2  dur, deltime;\
	\cf6 var\cf2  env, src, delay;\
	env = \cf3 EnvGen\cf2 .kr(\
		\cf3 Env\cf2 ([0.0, 1.0, 1.0, 0.0], [0.001, 0.998, 0.001]), timeScale: dur); \
	\cf4 // a little noise burst\cf2 \
	src = \cf3 SinOsc\cf2 .ar(440, 0, 0.25) * \cf3 Decay\cf2 .ar(\cf3 Impulse\cf2 .ar(1), 0.5);\
	\cf4 // DelayC- delay with cubic interpolation\cf2 \
	\cf4 // DelayC.ar(arg in = 0.0, maxdelaytime = 0.2, delaytime = 0.2, mul = 1.0, add = 0.0);\cf2 \
	\cf4 // the max delay time tells SC how much memory to allocate\cf2 \
	delay = \cf3 DelayC\cf2 .ar(src, 1.0, deltime + \cf3 LFNoise2\cf2 .kr(1).range(0, deltime));\
	\cf3 Out\cf2 .ar(0, [src, delay] * env);\
	\});	\
	\
c = a.note(0.0, 5.0).dur_(5.0).deltime_(0.5).play;\
\
\
\cf4 // This example shows the problem of moving a tap faster than the main read/write pointer\cf2 \
\cf4 // there is a glitch in theoutput every time the tap catches up with the pointer\cf2 \
\
a = \cf3 CtkSynthDef\cf2 (\cf5 \\movingtap\cf2 , \{\cf6 arg\cf2  dur, buffer, rate=1, tapdel= -0.1;\
	\cf6 var\cf2  env, src, delay;\
	env = \cf3 EnvGen\cf2 .kr(\
		\cf3 Env\cf2 ([0.0, 1.0, 1.0, 0.0], [0.001, 0.998, 0.001]), timeScale: dur);\
	\cf4 // a sine source\cf2 \
	src = \cf3 SinOsc\cf2 .ar(440.0, 0, 0.2);\
	\cf4 // record the source into a buffer\cf2 \
	\cf3 RecordBuf\cf2 .ar(src, buffer);\
	\cf4 // tap the delay line\cf2 \
	delay = \cf3 PlayBuf\cf2 .ar(1, buffer, rate * \cf3 BufRateScale\cf2 .kr(buffer), 0, \
		tapdel * \cf3 BufSampleRate\cf2 .kr(buffer), 1);\
	\cf3 Out\cf2 .ar(0, [src, delay] * env);\
	\});\
	\
b = \cf3 CtkBuffer\cf2 .buffer(65536).load;\
b.zero;	\cf4 // make sure the buffer is cleared out\cf2 \
c = a.note(0.0, 5.0).dur_(5.0).buffer_(b).rate_(2).tapdel_(-0.1).play;\
b.free;\
\
\cf4 /* Multi-tap delays */\cf2 \
\
\cf4 // a Buffer for the UGens to use\cf2 \
b = \cf3 CtkBuffer\cf2 .buffer(s.sampleRate).load;\
\
\cf4 // write a signal into a delay, tap it at mutiple times\cf2 \
a = \cf3 CtkSynthDef\cf2 (\cf5 \\test\cf2 , \{\cf6 arg\cf2  buffer, dur;\
	\cf6 var\cf2  src, tapPhase, tap1, tap2, tap3, env;\
	env = \cf3 EnvGen\cf2 .kr(\cf3 Env\cf2 ([0, 1, 1, 0], [0.1, dur - 0.2, 0.1], \cf5 \\sin\cf2 ));\
	src = \cf3 SinOsc\cf2 .ar(0.2) * \cf3 Decay\cf2 .kr(\cf3 Dust\cf2 .kr(3), 0.2);\
	tapPhase = \cf3 DelTapWr\cf2 .ar(buffer, src);\
	#tap1, tap2, tap3 = \cf3 DelTapRd\cf2 .ar(buffer, tapPhase, \
		[0.2, 0.27, 0.303],  	\cf4 // tap times\cf2 \
		1,  					\cf4 // no interp\cf2 \
		[1.0, 0.4, 0.2] 		\cf4 // muls for each tap\cf2 \
		);\
	\cf3 Out\cf2 .ar(0, [src + tap2, tap1 + tap3] * env)\
	\});\
	\
c = a.note(0.0, 10.0).buffer_(b).dur_(10).play;\
\
b.zero;\
\
\cf4 // write a signal into a delay, tap it at mutiple times\cf2 \
a = \cf3 CtkSynthDef\cf2 (\cf5 \\test\cf2 , \{\cf6 arg\cf2  buffer, dur, interp = 1;\
	\cf6 var\cf2  src, tapPhase, tap1, tap2, tap3, env;\
	env = \cf3 EnvGen\cf2 .kr(\cf3 Env\cf2 ([0, 1, 1, 0], [0.1, dur - 0.2, 0.1], \cf5 \\sin\cf2 ));\
	src = \cf3 SinOsc\cf2 .ar(440, 0, 0.4) * \cf3 Decay\cf2 .kr(\cf3 Impulse\cf2 .kr(1), 0.8);\
	tapPhase = \cf3 DelTapWr\cf2 .ar(buffer, src);\
	#tap1, tap2, tap3 = \cf3 DelTapRd\cf2 .ar(buffer, tapPhase, \
		\cf3 LFNoise2\cf2 .kr([1, 1, 1]).range(0.1, 0.5), \cf4 // tap times\cf2 \
		interp,  					\cf4 // interp with changing times!\cf2 \
		[1.0, 0.4, 0.2] 		\cf4 // muls for each tap\cf2 \
		);\
	\cf3 Out\cf2 .ar(0, [src + tap2, tap1 + tap3] * env)\
	\});\
	\
c = a.note(0.0, 10.0).buffer_(b).dur_(10).interp_(4).play;\
\
\cf4 /* \
EZFlange\
*/\cf2 \
\
a = \cf3 CtkSynthDef\cf2 (\cf5 \\flange\cf2 , \{\cf6 arg\cf2  dur, freq = 110, psamount, psfreq;\
	\cf6 var\cf2  env, src, delay, deltime;\
	env = \cf3 EnvGen\cf2 .kr(\
		\cf3 Env\cf2 ([0.0, 1.0, 1.0, 0.0], [0.001, 0.998, 0.001]), timeScale: dur); \
	\cf4 // a sound to flange\cf2 \
	src = \cf3 Pluck\cf2 .ar(\cf3 PinkNoise\cf2 .ar(0.5), \cf3 Impulse\cf2 .ar(dur.reciprocal), \
		freq.reciprocal, freq.reciprocal, dur, 0.1);\
	\cf4 // here, the delay is controlled by a SinOsc.  Remap the output\cf2 \
	\cf4 // to 0 and psamount (avoiding negative delay times)\cf2 \
	deltime = \cf3 SinOsc\cf2 .ar(psfreq, 0).range(0, psamount);\
	delay = \cf3 DelayC\cf2 .ar(src, psamount, deltime);\
	\cf3 Out\cf2 .ar(0, [src, delay] * env);\
	\});	\
	\
b = a.note(0.0, 5).dur_(5).psamount_(0.01).psfreq_(10.reciprocal).play;\
\
b = a.note(0.0, 5).dur_(5).psamount_(0.01).psfreq_(2.reciprocal).play;\
\
b = a.note(0.0, 5).dur_(5).psamount_(0.1).psfreq_(100.reciprocal).play;\
\
b = a.note(0.0, 5).dur_(5).psamount_(0.1).psfreq_(0.01.reciprocal).play;\
	\
\cf4 /* PitchShifting / harmonizing */\cf2 \
\
a = \cf3 CtkSynthDef\cf2 (\cf5 \\harmonizer\cf2 , \{\cf6 arg\cf2  dur = 1, semis = 4, windowsize = 0.1, buffer, clean = 1;\
	\cf6 var\cf2  buf, rate, ratio, phases, envs, envsarray, phasesarray, in, env, out;\
	env = \cf3 EnvGen\cf2 .kr(\
		\cf3 Env\cf2 ([0.0001, 1, 1, 0.0001], [0.1, dur - 0.02, 0.1], \cf5 \\sin\cf2 ));\
	\cf4 // this takes the semitone number, and coverts it to a ratio of pitch change\cf2 \
	\cf4 // an octave up (12 semitones) = 2, an octave down (-12 semitones) = 0.5\cf2 \
	ratio = semis.midiratio;\
	\cf4 // calculate the rate the saw needs to run at to control the delays\cf2 \
	rate = ((ratio-1)/windowsize);\
	\cf4 // we will use 2 windows, 180 degrees out of phase with each other.  This array\cf2 \
	\cf4 // helps with that in the UGens later\cf2 \
	phasesarray = [0, 0.5]; \
	\cf4 // each windows envelope, with some tricky math on the phase arg to make it line up \cf2 \
	\cf4 // with the delays\cf2 \
	envs = \cf3 LFTri\cf2 .ar(rate.abs, ((phasesarray * 4) + 1), 0.5, 0.5);\
	\cf4 // phases controls the delay times, which are changing to effect the change in pitch\cf2 \
	phases = \cf3 LFSaw\cf2 .ar(rate.neg, phasesarray * 2, windowsize*0.5, windowsize*0.5);\
	\cf4 // our input\cf2 \
	in = \cf3 PlayBuf\cf2 .ar(1, buffer, \cf3 BufRateScale\cf2 .kr(buffer)) * env;\
	\cf4 // the two delays, using phases for their delaytimes, and envs for their mul to create\cf2 \
	\cf4 // the overlapping windows.\cf2 \
	out = \cf3 DelayC\cf2 .ar(in, windowsize, phases, envs * 2.reciprocal).sum;\
	\cf3 Out\cf2 .ar(0, (out + (in* clean)) * env);\
	\});\
	\
b = \cf3 CtkBuffer\cf2 .playbuf(\cf7 "sounds/vln-g4.aiff"\cf2 ).load;\
\
c = a.note(0.0, b.duration).dur_(b.duration).buffer_(b).semis_(-5).clean_(1).play;\
\
\cf4 // In SC - this is all done for you with the PitchShift UGen. The main difference is, there are\cf2 \
\cf4 // four overlaps, and the approach is actually a little more like granular synthesis. This lets\cf2 \
\cf4 // you play a little with how the grains are created (and lets you avoid certain 'combing' effects\cf2 \
\
a = \cf3 CtkSynthDef\cf2 (\cf5 \\pshift\cf2 , \{\cf6 arg\cf2  dur, semis, windowsize = 0.1, buffer, clean = 1;\
	\cf6 var\cf2  in, env, out;\
	env = \cf3 EnvGen\cf2 .kr(\
		\cf3 Env\cf2 ([0.0001, 1, 1, 0.0001], [0.1, dur - 0.02, 0.1], \cf5 \\sin\cf2 ), doneAction: 2);\
	in = \cf3 PlayBuf\cf2 .ar(1, buffer, \cf3 BufRateScale\cf2 .kr(buffer));\
	\cf4 // add in a little timeDispersion to avoid "combing" effect\cf2 \
	out = (in * clean) + \cf3 PitchShift\cf2 .ar(in, windowsize, semis.midiratio, 0, windowsize * 0.1);\
	\cf3 Out\cf2 .ar(0, out * env * 0.5);\
	\});\
	\
c = a.note(0.0, b.duration).dur_(b.duration).buffer_(b).semis_(12).clean_(1).play;\
\
\cf4 // you can also create deviations in pitch randomly\cf2 \
a = \cf3 CtkSynthDef\cf2 (\cf5 \\pshiftpdev\cf2 , \{\cf6 arg\cf2  dur, semis, windowsize = 0.1, buffer, clean = 1, \
		pitchdev = 0;\
	\cf6 var\cf2  in, env, out;\
	env = \cf3 EnvGen\cf2 .kr(\
		\cf3 Env\cf2 ([0.0001, 1, 1, 0.0001], [0.1, dur - 0.02, 0.1], \cf5 \\sin\cf2 ));\
	in = \cf3 PlayBuf\cf2 .ar(1, buffer, \cf3 BufRateScale\cf2 .kr(buffer));\
	\cf4 // add in a little timeDispersion to avoid "combing" effect\cf2 \
	out = (in * clean) + \cf3 PitchShift\cf2 .ar(in, windowsize, semis.midiratio, pitchdev, \
		windowsize * 0.1);\
	\cf3 Out\cf2 .ar(0, out * env);\
	\});\
	\
c = a.note(0.0, b.duration).dur_(b.duration).buffer_(b).semis_(5).clean_(0)\
	.pitchdev_(0.01).play;\
c = a.note(0.0, b.duration).dur_(b.duration).buffer_(b).semis_(-12).clean_(0)\
	.pitchdev_(0.1).play;\
c = a.note(0.0, b.duration).dur_(b.duration).buffer_(b).windowsize_(0.1).semis_(7)\
	.clean_(0.707).pitchdev_(0).play;\
\
b.free;\
\
\cf4 // a similar approach can be used for time stretching, however in this case the sound is created\cf2 \
\cf4 // directly from buffer. This is also a granular technique.\cf2 \
\
a = \cf3 CtkSynthDef\cf2 (\cf5 \\warp\cf2 , \{\cf6 arg\cf2  buffer, start, end, dur, curve;\
	\cf6 var\cf2  out, pointer, pan, env;\
	env = \cf3 EnvGen\cf2 .kr(\cf3 Env\cf2 ([0, 1, 1, 0], [0.1, 0.8, 0.1], \cf5 \\sin\cf2 ), timeScale: dur);\
	pointer = \cf3 EnvGen\cf2 .kr(\cf3 Env\cf2 ([start, end], [dur], curve));\
	out = \cf3 Warp1\cf2 .ar(1, buffer, pointer, 1, 0.1, -1, 8, 0.2);\
	\cf4 // use a noise UGen to control the panning\cf2 \
	pan = \cf3 Pan2\cf2 .ar(out, \cf3 LFNoise2\cf2 .kr((dur * 0.2).reciprocal));\
	\cf3 Out\cf2 .ar(0, pan * env * 0.2);\
	\});\
\
b = \cf3 CtkBuffer\cf2 .playbuf(\cf7 "sounds/mozart.aiff"\cf2 ).load;\
c = a.note(0.0, 10.0).buffer_(b).start_(0.1).end_(0.8).dur_(10).curve_(0).play;\
c = a.note(0.0, 10.0).buffer_(b).start_(0.21).end_(0.22).dur_(10).curve_(0).play;\
c = a.note(0.0, 10.0).buffer_(b).start_(0.8).end_(0.1).dur_(10).curve_(5).play;\
\cf3 Env\cf2 ([1, 0], [1], -10).plot\
b.free;\
\
z = \cf3 CtkScore\cf2 .new;\
\
z.add(\
	b = \cf3 CtkBuffer\cf2 .playbuf(\cf7 "sounds/mozart.aiff"\cf2 ),\
	a.note(1.0, 20).dur_(20).buffer_(b).start_(0).end_(1).curve_(0),\
	a.note(2.0, 24).dur_(24).buffer_(b).start_(0.4).end_(0.2).curve_(3),\
	a.note(2.5, 15).dur_(15).buffer_(b).start_(0.3).end_(0.31).curve_(-4),\
	a.note(3.3, 26).dur_(26).buffer_(b).start_(0.2).end_(0.9).curve_(2),\
	a.note(6.0, 15).dur_(15).buffer_(b).start_(0.7).end_(0.01).curve_(-10)\
	);\
	\
z.play;\
\
\cf4 // you can be pretty precise with your time pointer\cf2 \
a = \cf3 CtkSynthDef\cf2 (\cf5 \\warplw\cf2 , \{\cf6 arg\cf2  buffer;\
	\cf6 var\cf2  out, pointer;\
	pointer = \cf3 EnvGen\cf2 .kr(\cf3 Env\cf2 ([0, 0.3, 0.55, 1], [0.3 * \cf3 BufDur\cf2 .kr(buffer), 14, \
		0.45 * \cf3 BufDur\cf2 .kr(buffer)]));\
	out = \cf3 Warp1\cf2 .ar(1, buffer, pointer, 1, 0.1, -1, 8, 0.2);\
	\cf3 Out\cf2 .ar(0, out * 0.5);\
	\});\
\
b = \cf3 CtkBuffer\cf2 .playbuf(\cf7 "sounds/lw.aiff"\cf2 ).load;\
\
c = a.note(0.0, 14 + (b.duration * 0.75)).buffer_(b).play;\
\
\
}