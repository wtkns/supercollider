Mesh {
	classvar <>all, <>stack, <thisHost, <>broadcastAddr;
	var <>name, <>environment, <>hosts, <>vertexes, <>proxies, <>window, <>patchbay;

	// test
	*initClass {
		stack = [];
		all = IdentityDictionary.new;
		thisHost = thisHost.as(MeshHost);
		Vertex.initVertexTypes;
		this.setBroadcastAddr;
	}

	*setBroadcastAddr{
				broadcastAddr = BroadcastHost.new(\broadcast, MeshHostAddr("255.255.255.255", 57120 + (0..7)));
	}

	*setLocalBroadcastAddr{
				broadcastAddr = BroadcastHost.new(\broadcast, MeshHostAddr("127.0.0.1", 57120 + (0..7)));
	}

	*at {|key|
		^ all.at(key) }

	*new {|key, local = false|
		^ all.at(key) ?? { ^ super.new.init(key, local).addMesh };
	}

	*newFrom {|mesh|
		if(mesh.isKindOf(this)) { ^ mesh };
		^ this.new(mesh)
	}

	*current {
		if (Mesh.hasCurrent)
		{	^ stack[(stack.size-1)]}
		{("No current mesh").warn; ^ List.new}
	}

	*hasPrevious {
		^ stack.size > 1
	}

	*previous {
		if (Mesh.hasPrevious)
		{	^ stack[(stack.size-2)]}
		{("No Previous mesh").warn; ^ List.new}
	}

	*isPrevious { |key|
		if (Mesh.hasPrevious.not) {^ false};
		^ Mesh.previous.name == key
	}

	*hasCurrent {
		if (stack.notNil and: { stack.notEmpty })
		{	^ true}
		{	^ false}
	}

	*isCurrent { |key|
		if (Mesh.hasCurrent.not) {^ false};
		^ Mesh.current.name == key
	}

	*exists { |key|
		^ all.includesKey(key)
	}

	*list {
		^ all.keys
	}


	*onStack { |key|
		Mesh.stack.do({|mesh|
			if (mesh.name == key) {^true};
		});
		^ false
	}

	*pop {
		if (Mesh.hasCurrent)
		{Mesh.current.pop}
		{"No active mesh".warn};
		^ stack;
	}

	*popAll {
		stack.size.do({Mesh.pop});
		"No active mesh".warn;
		^ stack;
	}

	*popEvery {|key|
		Mesh.at(key).pop;
		Mesh.removeFromStack(key);
	}

	*removeFromStack {|key|
		stack = stack.reject({|mesh|
			mesh == Mesh.at(key)
		});
	}

	*freeAll {
		Mesh.popAll;
		Mesh.all.do({|mesh|
			mesh.free;
		});
	}

	init {|key, local|
		name = key.asSymbol;
		this.initializeInstanceVariables(name);
		this.initializeInstanceEnvironment;
		if (local == true) {
			"Local Testing Only, Resetting Broadcast to LoopBack address. Try: \n  Mesh.setBroadcastAddr; to reset, and \n Mesh.current.hosts.beacon.start to restart.".postln;
			Mesh.setLocalBroadcastAddr;
		};
		postf("New Mesh Created: % \n", (name));
	}

	initializeInstanceVariables {
		hosts = MeshHostsManager.new(this, thisHost);
		vertexes = VertexDict.new;
		proxies = VertexDict.new;
		window = MeshView(this);
		patchbay = MeshPatchbay.new
	}

	initializeInstanceEnvironment {
		environment = Environment.make {};
		environment.put(name, this);
		this.addEnvironmentShortcuts;
	}

	addEnvironmentShortcuts {
		environment.use({
			~mesh = name;
			~me = thisHost;
			~vl = vertexes;
			~win = window;
		});
	}

	hasVertex {|key| ^ this.vertexes.includesKey(key)}

	hideCurrentWindow { Mesh.current.window.deactivate }

	showCurrentWindow { Mesh.current.window.activate }

	isCurrent { ^ Mesh.current == this }

	printOn { |stream| stream << this.class.name << "(" << name << ")" }

	addMesh { all.put(this.name, this) }

	at {|key| ^ hosts.at(key)}

	ping { ^hosts.ping(thisHost) }

	push {
		if (this.isCurrent) { ^ stack; };
		if (Mesh.hasCurrent) { this.hideCurrentWindow };
		stack = stack.add(this);
		environment.push; // push this Mesh's Environment onto the Environment Stack
		("Entering Mesh: " ++ name).inform; // post a confirmation,
		window.activate;
		^ stack;
	}

	pop {
		if (this.isCurrent)
		{
			this.hideCurrentWindow;
			("Leaving Mesh: " ++ name).inform; // post a confirmation,
			environment.pop;
			stack.pop;
			if (Mesh.hasCurrent) {this.showCurrentWindow};
			^ stack;
		}

		{
			(name ++ "is not the current Mesh.").warn;
			^ stack;
		}
	}

	free {
		("freeing" ++ name).postln;
		Mesh.popEvery(name);
		hosts.free(thisHost);
		all.removeAt(this.name);
		window.free;
		("removed mesh").warn;
	}

}
