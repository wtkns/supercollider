EffectListMgr {
	// this is a dictionary of each Peer's EffectList
	// this is ONLY the peer and the effect list (another dictionary)
	// the purpose for this is to know what running effects are on
	// other machines.the actual effects are in the EffectBank

	var dict;

	*new { ^super.new.init }

	init {
		dict = IdentityDictionary.newFrom(List[~addrBook.me, EffectList.new])
	}

	add {|peer, effList|
	}

	at {|name| ^dict[name] }

	remove {|peer| dict[peer.name] = nil; peer.removeDependant(this); this.changed(\remove, peer) }

	removeAt {|name| this.remove(dict[name]) }

	update {|changed, what| this.changed(what, changed) }

	names { ^dict.keys }


}
