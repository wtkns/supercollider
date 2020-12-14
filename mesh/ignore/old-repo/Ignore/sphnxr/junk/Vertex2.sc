Vertex {
	var <key, <>item;
	classvar <>all;

	*initClass { all = IdentityDictionary.new }

	*at { |key| ^ this.all.at(key) }

	*new { |argKey, argItem|
		var current = this.at(argKey);
		if (current.isNil)
		   { current = super.new.item_(argItem).classDictAdd(argKey) }
		   { if(argItem.notNil) { current.item = argItem } };
		^current
	}

	classDictAdd { |argKey|
		key = argKey;
		all.put(argKey, this);
	}

	*control { |argKey, argItem|
		var current = this.at(argKey);
		if (current.isNil)
		   { current = super.new.pbind_(argItem).classDictAdd(argKey) }
		   { if(argItem.notNil) { current.item = argItem } };
		^current
	}
}


ControlVertex : Vertex {
	var <>pbind



}






// }
//
//
// SynthVertex : Vertex {
//
// }
//
// //
// //
// //
// //
// // SynthVertex :
// // *new { arg key, item;
// // 	var res = this.at(key);
// // 	if(res.isNil) {
// // 		res = super.new(item).prAdd(key);
// // 	} {
// // 		if(item.notNil) { res.source = item }
// // 	}
// // 	^res
// //
// // }
// //
// // map { arg ... args;
// // 	if(envir.isNil) { this.envir = () };
// // 	args.pairsDo { |key, name| envir.put(key, Pdefn(name)) };
// // 	this.changed(\map, args);
// // }
// //
// // storeArgs { ^[key] } // assume it was created globally
// // copy { |toKey|
// // 	if(key == toKey) { Error("cannot copy to identical key").throw };
// // 	^this.class.new(toKey).copyState(this)
// // }
// //
// // prAdd { arg argKey;
// // 	key = argKey;
// // 	all.put(argKey, this);
// // }
// //
// // *hasGlobalDictionary { ^true }
// //
// // }