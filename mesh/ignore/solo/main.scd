(
var workFolder = "/Users/james/git/wtkns/solo/output/";
var patFile = "/Users/james/git/wtkns/solo/patterns/mainPattern.scd";
var synthFile = "/Users/james/git/wtkns/solo/synths/synthFile.scd";
var oscFilePath = workFolder++"osc-test.osc";
var audioFilePath = workFolder++"audio-test.aiff";
var score;

// load synthdefs
File.readAllString(synthFile).interpret;

// reset patterns
Pdefn.removeAll;
Pbindef.clear;
Pbindef.defaultQuant = nil;


p = File.readAllString(patFile).interpret;

score = p.asScore(~timeRecord);

o = ServerOptions.new.numOutputBusChannels = 2; // mono output

if ( ~preview,
	{ Server.default=Server.local;
		s.boot;
		s.doWhenBooted({
			score.play})},
	{Score.recordNRT(
		score.score,
		oscFilePath,
		audioFilePath,
		options: o)}
)

)