MeshMetaData {

	*getMetadataPairs {
		|synth, uniqueID, includePattern=true |
		var pairs = Array.new(maxSize: 0);

		// ALWAYS INCLUDE DUR
		pairs = pairs.add("\dur");
		pairs = pairs.add(this.getPdefn(\dur, synth, uniqueID, includePattern));

		synth.controlNames.do{|key|
			if(key != \dur){
				var pdefn = this.getPdefn(key, synth, uniqueID, includePattern);
				pairs = pairs.add(key);
				pairs = pairs.add(pdefn)}
		}

		^ pairs
	}



	*getPdefn {
		|key, synth, uniqueID, includePattern=true |

		var pdefName = (synth.name ++ key.asString.firstToUpper ++ uniqueID);
		var pdefn = "Pdefn(\\" ++ pdefName;

		if((includePattern),{
			var pattern = synth.metadata.at(key);
			if(pattern.isKindOf(SimpleNumber),
				{pattern = pattern.asString ++ ", inf"},
				{pattern = pattern.cs}
			);

			pdefn = pdefn ++ ", " ++ pattern
		});

		pdefn = pdefn ++ ")";

		^ pdefn
	}
}
