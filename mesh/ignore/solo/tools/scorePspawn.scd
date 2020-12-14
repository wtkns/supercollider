(

// using Score and NRT
var workFolder = "/Users/james/git/wtkns/solo/output/";
var patFile = "/Users/james/git/wtkns/solo/pattern1.scd";
var oscFilePath = workFolder++"osc-test.osc";
var audioFilePath = workFolder++"audio-test.aiff";
var score = Score.new;
var pDic = Dictionary.new;
var assn =  File.readAllString(patFile).interpret;

"synths.scd".loadRelative;

assn.do({ arg pat; pDic.add(pat)});


p = Pspawner({ |sp|
	sp.par( Pchain(
		Pmono(\swarmSaw, \dummyArg, 0),
		Pbindef(\swarm,
			\dur, 0.25,
			\amp1,  Pdefn(\swarmAmp1, Pmeanrand(0.1, 0.25)),
		)));
		
	sp.wait(2.0);
	sp.par(Pdefn(\swarmAmp1, Pmeanrand(100, 200)));
	//	sp.par(Pbindef(\swarm, \freq1, Pmeanrand(100, 200)));
});

~score = p.asScore(10.0);

o = ServerOptions.new.numOutputBusChannels = 2; // mono output

// score.play;
//~score.asCompileString.postln


Score.recordNRT(
		score.score,
		oscFilePath,
		audioFilePath,
		options: o); // render to file. see also p.render?


// // uncomment the following for preview
// Server.default=Server.local;
// s.boot;
// s.doWhenBooted({
// 	score.play
// });

)