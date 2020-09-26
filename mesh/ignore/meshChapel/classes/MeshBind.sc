MeshBindef : Pbindef {

	*makeBindef {
		|synthDefKey, uniqueID, nodeID, includePattern|
		var synth = SynthDescLib.at(synthDefKey);
		var bindefID = "Bindef" ++ uniqueID;
		var bindefName = synthDefKey ++ bindefID;
		var metadataPairs = MeshMetaData.getMetadataPairs(synth, bindefID, includePattern);
		var pbindefText;
		var text = "\n(\n";

		metadataPairs.pairsDo({|key, val|
			pbindefText = pbindefText ++ "Pbindef("
			++ "\\" ++ bindefName
			++ ", \\" ++ key ++ ", " ++ val
			++ "); \n";
		});

		text = text ++ "~" ++ bindefName
		++ " = Pbindef(\\" ++ bindefName
		++ ",\n\\instrument, \\" ++ synthDefKey
		++ ",\n\\id, " ++ nodeID
		++ ",\n\\type, \\set"
		++ ",\n\\args, #[]"
		++ ",\n\\dur, Pdefn(\\"
		++ synthDefKey ++ "Dur" ++ bindefID
		++ ", 0.1, inf)"
		++ "\n).play;\n)\n\n"
		++ pbindefText;

		^ text
	}

	*writeBindef {
		|synthDefKey, uniqueID, group, includePattern = true|
		var text = this.makeBindef(synthDefKey, uniqueID, group, includePattern);
		Post << (text);
		//text.newTextWindow;
	}
}
