SphnxrBufferManager {
	var <dict;

	*new { ^super.new.init }

	init {
		dict = IdentityDictionary.new;


	}

}


/*
		~buffers = "granSamples/*".resolveRelative.pathMatch.collect {
			|file|
			(file+"loaded").postln;
			Buffer.readChannel(s, file, channels:0);
		("Local Buffers loaded: Success" + ~delim).postln;
*/