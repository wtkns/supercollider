SphnxrStreamManager{
	var <streamLib;

	*new { ^super.new.init }

	init {
		streamLib = SphnxrStreamLibrary.new;
	}

	addStream { }

	removeStream { }

	listStreams { }

	playStream { }

	listPlaying { }

	stopStream { }

	stopAllStreams { }

	setStream { }
}

SphnxrStreamLibrary : IdentityDictionary {

	add { }

	remove { }

	stopAll { }

	playAll { }

	playing { }

}

SphnxrStream { }

SphnxrAStream : SphnxrStream { }

SphnxrPStream : SphnxrStream { }

SphnxrCStream : SphnxrStream { }

