TestDepClassVar {
	var <key, <>item;
	classvar <>all;

	*initClass {
		all = IdentityDictionary.new
	}

	*at { arg key;
		^ all.at(key)
	}

	*new { arg argKey, newItem;
		var current = this.at(argKey);
		if(current.isNil)
		{current = super.newCopyArgs(newItem).dictAdd(argKey)}
		{ if (newItem.notNil) {current.item = newItem;
			current.changed(\updated, this);
			^ "item updated"
		}};
		^current
	}

	dictAdd { arg argKey;
		key = argKey;
		all.put(argKey, this);
		this.addDependant(this);
		this.changed(\added, this);
		^ "item added"
	}

	update { |obj, what, val|

		if(what == \added, {
			obj.key.postln;
			val.postln;
			"new dependant!".postln;
		});

		if(what == \updated, {
			obj.key.postln;
			val.postln;
			"updated dependant!".postln;
		});
	}

}