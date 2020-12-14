+ String {

openRelative { arg warn = true, action;
		var path = thisProcess.nowExecutingPath;
		if(path.isNil) { Error("can't open relative to an unsaved file").throw};
		if(path.basename == this) { Error("should not open a file from itself").throw };

		^Document.open(path.dirname ++ thisProcess.platform.pathSeparator ++ this)
	}

firstToUpper {
	    ^ this[0].toUpper ++ this[1..];
	  }
}
