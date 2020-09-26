(

// using Score and NRT
var workFolder = "/Users/james/git/wtkns/solo/output/";
var patFile = "/Users/james/git/wtkns/solo/patterns/pattern1.scd";
var synthFile ="/Users/james/git/wtkns/solo/synths/swarmSynth.scd";
var oscFilePath = workFolder++"osc-test.osc";
var audioFilePath = workFolder++"audio-test.aiff";
var score;// = CtkScore.new;
var drone = File.readAllString(synthFile).interpret;
var now = 0;

Pbindef(\swarm).clear;
Pbindef.defaultQuant = nil;

p = Pspawner({ |sp|
	
	sp.par( Pchain(
		Pmono(\swarmSaw, \dur, 0.25),
		Pbindef(\swarm, \amp1, 0)
	));
	
	sp.wait(2.0);
	Pbindef(\swarm, \amp1, Pmeanrand(0.1, 0.2), inf);
	Pbindef(\swarm, \freq1, Pmeanrand(100, 500), inf);
	Pbindef(\swarm, \pos1, 0, inf);

	sp.wait(2.0);
	Pbindef(\swarm, \amp2, Pmeanrand(0.1, 0.2), inf);
	Pbindef(\swarm, \freq2, Pmeanrand(100, 500), inf);
	Pbindef(\swarm, \pos2, 0, inf);

	sp.wait(2.0);
	Pbindef(\swarm, \amp3, Pmeanrand(0.1, 0.2), inf);
	Pbindef(\swarm, \freq3, Pmeanrand(500, 1500), inf);	
	Pbindef(\swarm, \pos3, 0, inf);

	sp.wait(2.0);
	Pbindef(\swarm, \amp4, Pmeanrand(0.1, 0.2), inf);
	Pbindef(\swarm, \freq4, Pmeanrand(1500, 3500), inf);
	Pbindef(\swarm, \pos4, 0, inf);

});

score = p.asScore(20.0);
o = ServerOptions.new.numOutputBusChannels = 2; // mono output

// score.play;
// score.asCompileString.postln
Score.recordNRT(
		score.score,
		oscFilePath,
		audioFilePath,
		options: o); // render to file. see also p.render?


// uncomment the following for preview
// Server.default=Server.local;
//s.boot;
//s.doWhenBooted({
//	score.play
//});

)