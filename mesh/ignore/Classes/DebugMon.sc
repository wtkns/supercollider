MeshDebugMon {
	classvar debug = true;
	*new {|...args|

		if (debug){
			"DEBUG:".warn;
			args.do({|item| item.postln });
			//"\n".postln;
		}
	}

	*on {debug = true}
	*off {debug = false}
	*status { if (debug) {^"on"}{^"off"} }
}
