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


p = Pspawner({ |sp|


	sp.par( Pchain(
		Pmono(\swarmSaw, \dur, 0.25),
		Pbindef(\swarm, \amp1, Pmeanrand(0.1, 0.2))
	));
	sp.wait(1.0);		
	sp.par(Pbindef(\swarm, \freq1, Pmeanrand(100, 200)));
	//});
}).asStream;
		

25.do({
 	p.next(Event.default).postln;
});


p.class.postln;

)