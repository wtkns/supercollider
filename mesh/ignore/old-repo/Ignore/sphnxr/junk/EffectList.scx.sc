EffectList {
		// this is just a copy of the information from each Peer's Effect Bank,
		// on every machine for looking up remote server bus information.
		// this is ONLY the names and bus numbers,
		// the actual effects are in the EffectBank

	var dict;

	*new { ^super.new.init }

	init {
		dict = IdentityDictionary.newFrom(List[\masterOut, 0])
	}

	list { ^dict }

	names { ^dict.keys }

	// effectIndex {|key|
	// 	key.postln;
	// 	this.dict.atFail(key.asSymbol, {"Effect List: Effect not found".postln; ^nil});
	// 	^this.dict.at(key.asSymbol);
	// }
	//
	// var dict;
	//
	// *new { ^super.new.init }
	//
	// init {
	// 	dict = IdentityDictionary.newFrom(List[~addrBook.me, EffectList.new])
	// }
	//
	// add {|peer, effList|
	// }
	//
	// at {|name| ^dict[name] }
	//
	// remove {|peer| dict[peer.name] = nil; peer.removeDependant(this); this.changed(\remove, peer) }
	//
	// removeAt {|name| this.remove(dict[name]) }
	//
	// update {|changed, what| this.changed(what, changed) }
	//
	// names { ^dict.keys }

}