SphnxrSphincterManager {
	var <sphincterLib;

	*new { ^super.new.init }

	init {
		sphincterLib = SphnxrSphincterLibrary.new;
		// add masterOut Bus
		sphincterLib.addSphincter

	}

	add { }

}

SphnxrSphincterLibrary : IdentityDictionary {
	// this stores the sphincter with a name:
	// Dictionary (Sphincter Name -> Sphincter (any type))

	addSphincter {}

	removeSphincter {}

}

SphnxrSphincter {
}

SphnxrASphincter : SphnxrSphincter{
	var nodeName, bus;
}

SphnxrPSphincter : SphnxrSphincter{
}

SphnxrCSphincter : SphnxrSphincter{
}
