MeshNamedList : NamedList {
  // depends upon Modality-Toolkit Quark

storeOn { |stream|
		stream << this.class.name << "("
		<<<* this.storeArgs << ")";
	}

storeArgs { ^[names, array].flop }

printOn {|stream|
  stream << "Patches: \n";
  names.do({|item, i|
    stream << item << Char.nl;
    array[i].keysDo({|key| stream << ("  " ++ key ++ Char.nl)});
    stream << Char.nl;
    });
}
}
