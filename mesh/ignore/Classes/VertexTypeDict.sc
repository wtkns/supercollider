VertexTypeDict : IdentityDictionary {

  *new{
    var allTypes = VertexAbstract.subclasses;
    var dict = allTypes.collectAs({ |vertexType|
          var key = this.trimClassName(vertexType.name);
          key -> vertexType }, IdentityDictionary);

    this.initTypeOSCdefs(dict);
    ^ dict;
  }

	*trimClassName{ |key|
		key = key.asString.drop(6);
		key[0] = key.first.toLower;
		^ key.asSymbol;
	}

	*initTypeOSCdefs{ | dict |
		dict.keysValuesDo({ |key, value| 
      value.tryPerform(\makeClassInterface)
    })
	}
}

VertexDict : IdentityDictionary {}
