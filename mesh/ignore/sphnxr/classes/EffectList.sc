EffectList {
		// this is just a copy of the information from each Peer's Effect Bank,
		// on every machine for looking up remote server bus information.
		// this is ONLY the names and bus numbers,
		// the actual effects are in the EffectBank

	var <>dict;

	*new { ^super.new.init }

	init {
		dict = Dictionary.newFrom(List[\masterOut, 0])
	}

	list { ^dict }

	names { ^dict.keys }

	effectIndex {|key|
		this.dict.atFail(key.asSymbol, {"effect not found".postln; ^nil});
	 	^this.dict.at(key.asSymbol);
	}
}