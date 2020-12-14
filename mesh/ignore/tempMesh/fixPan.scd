// look at the outputs of Pan2:
Pan2.ar(PinkNoise.ar(0.1), FSinOsc.kr(3)).dump;



{ Pan2.ar(SawDPW.ar([100,200,300,400], 0.025),[MouseX.kr(-1,1),MouseX.kr(1,-1)]).sum }.asSynthDef.dumpUGens

{ Pan2.ar(SinOsc.ar([500,600]),[-0.5,0.5]).sum }.asSynthDef.dumpUGens



{ Pan2.ar(SinOsc.ar([500,600]),[-0.5,0.5]) }.asSynthDef.dumpUGens;

{ Pan2.ar(SinOsc.ar([500,600]),[-0.5,0.5]) }.play;

(

SynthDef(\swarmSaw, {| out |

	var arrySaw, arryMouse, arryFilt;

	arrySaw = [
		SawDPW.ar(100, 0, 0.025),
		SawDPW.ar(200, 0, 0.025),
		SawDPW.ar(300, 0, 0.025),
		SawDPW.ar(400, 0, 0.025)
	];

	arryMouse = [
		MouseX.kr(1,-1),
		MouseX.kr(0.5,-0.5),
		MouseX.kr(-0.5,0.5),
		MouseX.kr(-1,1)
	];

	Out( out, Pan2.ar( arrySaw, 0).sum)
}).add;

)

u=Synth.new(\swarmSaw);
s.boot

