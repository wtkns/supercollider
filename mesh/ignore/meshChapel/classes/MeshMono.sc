MeshMono : Pmono {
	classvar <>all;

	*initClass {
		all = Set.new
	}

	*killAll {
		^ this.all.do({ arg item; item.stop });
	}

	play {
		| clock, protoEvent, quant |
		var ret = this.asEventStreamPlayer(protoEvent).play(clock, false, quant);
		all.add(ret);
		^ ret
	}

	*makeMono {
		|synthDefKey, uniqueID, group, includePattern|
		var synth = SynthDescLib.at(synthDefKey);
		var monoID = "Mono" ++ uniqueID;
		var monoName = "~" ++ synthDefKey ++ monoID;
		var monoNodeID = monoName ++ "NodeID";
		var metadataPairs = MeshMetaData.getMetadataPairs(synth, monoID, includePattern);
		var break = "\n\n/////////////////////////\n\n";
		var metadataText = String.new;
		var text = "\n\n\n";
		if(group.notNil){ text = text ++ group ++ " = Group.after(1); \n\n(\n"};
		metadataPairs.pairsDo({|key, val|
			metadataText = metadataText ++ ",\n  \\" ++ key ++ ", " ++ val});
		text = text ++ monoName + "="
		++ " MeshMono(\\" ++ synthDefKey;
		if(group.notNil){ text = text ++ ",\n  \\group, " ++ group };
		text = text	++ metadataText
		++ "\n).collect {|event| "
		++ monoNodeID
		++ " = event[\\id]; event}.play;\n"
		++ ")\n\n\n"
		++ monoName ++ "Node" ++ " = " ++ monoNodeID ++ "[0].asTarget;\n"
		++ break
		++ "MeshBindef.writeBindef(\\" ++ synthDefKey
		++ ", " ++ uniqueID
		++ ", " ++ monoName ++ "Node"
		++ ");\n\n\n"
		++ monoName ++ ".stop;\n"
		++ monoName ++ "Node.free;\n";

		^ text;
	}

	*postMono {
		|synthDefKey, uniqueID, group, includePattern = true|
		var text = this.makeMono(synthDefKey, uniqueID, group, includePattern);
		Post << (text);
	}

	// *insertMono {
	// 	|synthDefKey, uniqueID, group, includePattern = true|
	// 	var text = this.makeMono(synthDefKey, uniqueID, group, includePattern);
	// 	Document.current.insertText("\n\n"++text, Document.current.selectionStart);
	// }
    //
	// *writeMono {
	// 	|synthDefKey, uniqueID, group, includePattern = true|
	// 	var text = this.makeMono(synthDefKey, uniqueID, group, includePattern);
	// 	text.newTextWindow;
	// }



}
