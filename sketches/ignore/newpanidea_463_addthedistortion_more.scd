(

var freemaingrain, freesusgrain;
var grainBounce;
var sampleTest;
var synth, first, second;
var maingrainFunc, stopFunc, interuptFunc;
var rateEnv, rateResp, rateCtl;
var ampEnv, ampResp, ampCtl;
var posEnv, posResp, posCtl;
var maingrainResp, maingrainCtl;
var susgrainResp, susgrainCtl;
var distbus, distortion, distthing, distthingTwo, distbusTwo;
var recipr = 127.0.reciprocal;

Server.default = s = Server.internal.boot;

s.waitForBoot({
	
sampleTest = CtkBuffer("~/samp/drone_6.aiff".standardizePath).load(sync: true);


MIDIClient.init;
MIDIIn.connectAll;


rateCtl = CtkControl.play(1, 1);
ampCtl = CtkControl.play(1, 0.5);
posCtl = CtkControl.play(1, 1);

rateEnv = Env([0.5, 5.0], [1], \exp);
ampEnv = Env([0.0, 1.0], [1], \lin);
posEnv = Env([1.0, 40.0], [1], \lin);

freemaingrain = 0;
freesusgrain = 0;

maingrainResp = CCResponder({ |src,chan,num,value|
    var mappedVal;
    (freemaingrain == 0).if({
	    maingrainCtl.set(maingrainFunc.value); 
	freemaingrain = 1;
}, {
	first.free;	
	distthing.free;
	    freemaingrain = 0;
});
  [chan,num,value].postln;
},
    nil, // source
    nil, // channel
    23, // cc nr
    127 // value
    );

susgrainResp = CCResponder({ |src,chan,num,value|
    var mappedVal;
    (freesusgrain == 0).if({
	susgrainCtl.set(interuptFunc.value); 
	freesusgrain = 1;
}, {
	second.free;
	distthingTwo.free;
	    freesusgrain = 0;
});
  [chan,num,value].postln;
},

    nil, // source
    nil, // channel
    33, // cc nr
    127 // value
    );

rateResp = CCResponder({ |src,chan,num,value| 
    var mappedVal, grid;
    grid = 1;
    rateCtl.set(rateEnv[value * recipr].round(grid));
  [chan,num,value].postln;
    },
    nil, // source
    nil, // channel
    14, // cc nr
    nil // value
    );

ampResp = CCResponder({ |src,chan,num,value|
    var mappedVal, grid;
    grid = 0.1;
    ampCtl.set(ampEnv[value * recipr].round(grid)); 
  [chan,num,value].postln;
    },
    nil, // source
    nil, // channel
    2, // cc nr
    nil // value
    );

posResp = CCResponder({ |src,chan,num,value|
    var mappedVal, grid;
    grid = 0.1;
    posCtl.set(posEnv[value * recipr].round(grid)); 
  [chan,num,value].postln;
    },
    nil, // source
    nil, // channel
    15, // cc nr
    nil // value
    );


distbus = CtkAudio.new(1, 15);
distbusTwo = CtkAudio.new(1, 16);

distortion = CtkSynthDef(\EnvDists, {arg env, distortAmt, distortType, inbus = 98, gate = 15, pan;
		var in, dist, distortions, out;
		in = In.ar(inbus, 15);
		dist = in.sum * distortAmt;
		distortions = [dist.distort, dist.softclip, dist.tanh, dist.clip(-1, 1), dist.fold(-1, 1), dist.wrap(-1, 1)];
		out = Select.ar(distortType, distortions);
		Out.ar(0, Pan2.ar(out * env, 0))
	});
    
grainBounce = CtkSynthDef(\Cleanplayer, {arg bufnum, rate = 1, amp = 1, loopval = 0, startp = 0, dust = 100, gLo = 0.01, gHi = 0.05, posLo = 0.001,  posHi = 0.999, distsend, distsendTwo;
	var playbuf, out, scaledRate, 
	pan, trig, 
	posChanger, posTrigger, 
	rev,
	gRoutine, gSize, gTrigger,
	distortions;
	
	trig = Dust.ar(400);
	pan =  TExpRand.kr(0.05, 0.95, trig) * TIRand.kr(0, 1, trig).range(-3, 1);
	
	posTrigger = Dust.ar(30);
	posChanger = TExpRand.kr(posLo, posHi, posTrigger);
	
	gTrigger = Impulse.ar(100);
	gSize = TExpRand.kr(gLo, gHi, gTrigger);
	
	scaledRate = rate * BufRateScale.kr(bufnum);
	playbuf = GrainBuf.ar(1, Dust2.kr(dust, 0.5), gSize, bufnum, rate, posChanger, 1, pan, -1);
	out = playbuf * amp;
	
	OffsetOut.ar(0, [out, out]);
	OffsetOut.ar(distsend, [out, out]);
	OffsetOut.ar(distsendTwo, [out, out]);
	Out.ar(0, Pan2.ar(out, pan));
	});
	


maingrainFunc = {
	 
first = grainBounce.note(addAction: \head)
	.bufnum_(sampleTest)
	.rate_(rateCtl)
	.amp_(ampCtl)
	.distsend_(distbus)
	.play;
	
distthing = distortion.note(addAction: \tail)
	.env_(0.1)
	.inbus_(distbus)
	.distortType_(4)
	.distortAmt_(50)
	.play;
	
};

interuptFunc = {

second = grainBounce.note(addAction: \head)
	.bufnum_(sampleTest)
	.rate_(0.2)
	.gHi_(0.03)
	.gLo_(0.04)
	.posHi_(0.5)
	.posLo_(0.52)
	.dust_(850)
	.amp_(0.3)
	.distsendTwo_(distbusTwo)
	.play;
	
	
distthingTwo = distortion.note(addAction: \tail)
	.env_(0.1)
	.inbus_(distbusTwo)
	.distortType_(4)
	.distortAmt_(50)
	.play;
	
};

})   
)