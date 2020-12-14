//  get present working directory
("Finding present working directory:\n" + ~pwd=thisProcess.nowExecutingPath.dirname).postln;

"Loading Local Configuration file".postln;

(~pwd +/+ "/config.scd").loadPaths;
("Server Configuration Loaded. \nBooting server with new values:" + (~delim = "\n\n-----------\n")).postln;

s.reboot;

s.waitForBoot({
	(~delim + "\nServer booted Successfully").postln;

	"Joining Network".postln;
	(~pwd +/+ "/join_utopia.scd").loadPaths;
	("Joined Network: Success" + ~delim).postln;

	// Load OSC listeners
	(~pwd +/+ "/oscDefs.scd").loadPaths;
	s.sync;
	("Local OSC Listeners initialized: Success").postln;


	// groups
	~groups = Dictionary.newFrom(List[
		\synthGroup,  ~synthGroup = Group.tail(s),
		\effectGroup,  ~effectGroup = Group.tail(s)
	]);
	s.sync;
	("Local Groups initialized: Success").postln;


	//effects
	~effectList = EffectList.new;
	("Effect Busses initialized: Success " + ~delim).postln;


	// Load Buffers
	~buffers = (~pwd +/+ "/granSamples/*").pathMatch.collect {
		|file|
		(file+"loaded").postln;
		Buffer.readChannel(s, file, channels:0);
	};

	("Local Buffers loaded: Success" + ~delim).postln;

	s.sync;

	// Synths
	"Loading Synths".postln;
	~synths = (~pwd +/+ "/synths/*").pathMatch.collect {
		|file|
			file.loadPaths;
		(file +/+ "  loaded").postln };
	("Synths initialized: Success " + ~delim).postln;


	// Effects
	"Loading Effects".postln;
	~effectFiles = (~pwd +/+ "/effects/*").pathMatch.collect {
		|file|
			file.loadPaths;
		(file +/+ " loaded").postln };
	("Effects initialized: Success " + ~delim).postln;


	// starting clock
	~clock = BeaconClock(~addrBook).permanent_(true);
	// this use a default name (osc path) for this clock,
	// so it will be the same clock for each participant


	// set as default clock to not have to write ~clock for each pattern
	TempoClock.default = ~clock;

	"Ready to Collide >>".postln;

});