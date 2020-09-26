Vertex {
	var <key, <>item1, <>item2;
	classvar <>all;

	*initClass { all = IdentityDictionary.new }

	*at { |key| ^ this.all.at(key) }

	*new { |argKey, argItem1, argItem2|
		var current = this.at(argKey);
		if (current.isNil)
		   { current = super.newCopyArgs(argKey, argItem1, argItem2).classDictAdd(argKey) }
		   { if(argItem1.notNil) { current.item1 = argItem1 };
			 if(argItem2.notNil) { current.item2 = argItem2 }};
		^current
	}

	classDictAdd { |argKey|
		key = argKey;
		all.put(argKey, this);
	}

	*control { |argKey, argItem1, argItem2, argPbind|
		var current = this.at(argKey);
		if (current.isNil)
		   { current = ControlVertex.init(argKey, argItem1, argItem2, argPbind).classDictAdd(argKey) }
		   { if(argItem1.notNil) { current.item1 = argItem1 };
			 if(argItem2.notNil) { current.item2 = argItem2 };
			 if(argPbind.notNil) { current.pbind = argPbind }
		};
		^current
	}

	*synth { |argKey, argItem1, argItem2, argSynthDef|
		var current = this.at(argKey);
		if (current.isNil)
		   { current = SynthVertex.init(argKey, argItem1, argItem2, argSynthDef).classDictAdd(argKey) }
		   { if(argItem1.notNil) { current.item1 = argItem1 };
			 if(argItem2.notNil) { current.item2 = argItem2 };
			 if(argSynthDef.notNil) { current.synthDef = argSynthDef }
		};
		^current
	}

	play {|argKey| this.at(argKey).play}

}

ControlVertex : Vertex {
	var <>pbind;

	*init{|argKey, argItem1, argItem2, argPbind|
		^super.newCopyArgs(argKey, argItem1, argItem2, argPbind);
	}

	play { "control Playing".postln}
}

SynthVertex : Vertex {
	var <>synthDef;

	*init{|argKey, argItem1, argItem2, argSynthDef|
		^super.newCopyArgs(argKey, argItem1, argItem2, argSynthDef);
	}

	play { "Synth Playing".postln}

}