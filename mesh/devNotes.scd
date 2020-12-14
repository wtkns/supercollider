Development notes
=======================
Working On before show:
------------------

* SYNTAX: add method to reevaluate existing pdefn (eg. pshuf) or all pdefn for a synth
  Vertex(\sawSynth).update(\dur)

* add method to query for pdefns (and values?) by vertex
  Vertex(\sawSynth).listPdefns;

* thorough network testing:
  * remote server synthdef loading,
  * proxy updating for pdefns, etc.
  * tests for:
      . Messaging
      . Interfaces
      . Patchbay
      . Synth
      . Pattern

* final refactor/cleanup/documentation/diagrams of codebase, esp. messaging and interfaces.

* More synths, eg grancloud, fm, etc.

* manually create/patch a single pdefn, or patch one pdefn from a pattern to two synths.

* add patch method to vertex?
  instead of Mesh(\mesh1).patchbay.addPatch(\sawPattern, \sawSynth);
  maybe Vertex(\sawPattern).patch(\sawSynth);

* add some stuff to the gui window?

* clocks?

* knobs?


OTHER:
  * add multiple in/out port possibility to patchbay process (will need to add vertex type class descriptor field/s to hold information) this is only necessary for effects...
  * use Preprocessor for command confirmation request? e.g. Create a 'Confirm' class. pass a fn into it, and only execute it if/when ' //**confirm or similar is executed.
  * use ServerTree to set up ordered groups for VertexTypes
  * should CmdPeriod remove host from mesh? could we add confirmation to cmd period? "you have N vertexes hosted on your machine. are you REALLY sure you want to kill the server?"


=======================
Completed:
=======================

  7/20
  * SYNTAX: add method to update pdefn via Vertex.parameter, eg:
    instead of: Pdefn(\sawSynthDur, Pshuf([1/4, 1/4, 1/8, 1/8, 1/2, 1/2], inf));
    maybe either:

    Vertex(\sawSynth).update(\dur, Pshuf([1/4, 1/4, 1/8, 1/8, 1/2, 1/2], inf));
    or: Vertex(\sawSynth).dur(Pshuf([1/4, 1/4, 1/8, 1/8, 1/2, 1/2], inf));

  fixed issue in meshMessage, where Objects used as message arguments, eg. Pshuf([1/4, 1/2], inf) are getting lost.

      using in MeshMessage:

      args = args.collect({|item|
        if (item.isKindOf(Symbol))
        {item} {item.asCompileString};
        });

      and in VertexPattern:

      pattern = patternString.interpret;
      on the receiving end.

  7/18:
  * added playhandler for pattern vertex
    instead of: Vertex(\sinPattern).pbind.play;
    just: Vertex(\sinPattern).play;



  7/17/17:
  VertexSynth
    .pdefnDict
    .synthDef

    Initialization:
      * Mesh loads list of synths from folder

    Instantiation:
      * creates vertex
      * sets .synthDef
      * creates pdefns in VertexSynth.pdefnList (on vertex and proxies) named as
          (pdefn \vertexNameParameter)

    Patching out:
      * loads synthdef to server (if necessary)
      * moves vertex object to patched server, sets others to proxy
      * loads pdefnList on that server

  VertexPattern
    .pbind
    .pdefnDict

    Initialization:

    Instantiation:

    Patching Out:
      * sets the VertexPattern.pdefnDict from the VertexSynth.pdefnList, (and default values fromt the synth file if possible?)
      * sets the target server and instrument for pattern from vertexSynth
      * constructs a pbind from the pdefnDict


  7/6/17:
    * added -Local flag to mesh creation, Mesh(\mesh1, true).push; will create a mesh, but switch the broadcast address to localhost. just makes it easier to do testing on the bus, etc.
    * added message forwarding for VertexType.patchInput and .patchOutput, so that creating a patch will update the vertex if necessary

	7/5/17: (amongst many changes since last update to this file)
		* made significant changes to the method passing for vertex instances and classes, in VertexInterfaces.

		* added messaging components (still need a good refactoring for cleaner code, better consistency)

		* added basic patch bay and patch objects to keep adjacency lists for vertexes. these might be better kept in Mesh.vertexes somehow, because there's duplication, but fine for now.

		* using NamedList from the Modality-Toolkit Quark, in the patchbay, with a couple of things overloaded (basically just for sensible output of a nested NamedList).

		* reworked the unit tests slightly but havent been using them as much. need to fix them and start using them consistently again. Need to write tests for Interface and Messaging components

	5/6/17:
		* created skeleton for messages for VertexAbstract

	4/9/17:
  	* Set up initial requestor, OSCdef, requestHandler

	4/2/17:
  	* Merged Vertex branch back into master,
  	* started VertexServer Branch

	4/1/17:
  	* fixed dynamic Vertex Type List to include all subclasses of VertexAbstract, and to initialize OSCdefs if possible
  	* added doesNotUnderstand to MeshHost to pass method requests to the MeshHostAddr

	3/31/17:
  	* Trying to use doesNotUnderstand to pass unknown method calls up the chain of command, not by Object Inheritance, but by the definitions of our own occult system. e.g.

     	Vertex(\serverOne).protocol should pass through to VertexServer.server.protocol;

  		NOT AbstractServer.proocol. I think IdentityDictionary does something similar but my Aramaic is rusty. maybe: tryPerform... YES!!!!

	3/30/17:
		* added MeshDebugMon. allows adding Debug(something) calls anywhere in the code and when MeshDebugMon.on it outputs something to the post window.  These should be removed from performance code where latency might matter

			needs:
       * Documentation
       * Help File
       * Unit Test

  	* added MeshCommandParser. when MeshCommandParser.on, this runs in the interpreter and preprocesses executed code, checking for a matching expression this will allow shortcuts to pretty much anything, of the type:

      			** -> Mesh.peek.ping

    		this could add a little latency (one extra conditional per shortcut checked)

    needs:
       * maybe a better/more legible init class,
       * a way to map shortcuts on the fly?
       * Documentation
       * Help File
       * Unit Test

  Created initial VertexServer vertex type
    intended to provide access to SC Servers on local and remote machines on the mesh

  3/29/17:
    Basic Vertex functionality,
    Class Vertex serves as a factory and a registry
    VertexAbstract is abstract superclass for the classes located in Classes/VertexTypes

  3/28/17:
    Fixed gui bug (look at defer)
    Better ping for Jeff:
      Mesh(\mesh1).ping;

  3/27/17:
    Quark Install Working (w/dependency on UnitTesting)
    Making and unmaking Meshes
    Pushing, Popping them
    Monitoring other Hosts (online/offline) in a gui
    Basic (stub) help files for all classes,
    Basic (stub) Inline Documentation
    Unit Tests (stub) for all classes/methods
    Basic Readme and Guide files




=======================
Conceptual/Documentation Notes:
=======================

Mesh should emulate as closely as possible a broader method of communication protocol.
While this is currently based on SC, I'd like to try to keep it abstract enough to use
for IOT devices, etc. down the road, where no SC is even in the graph.

so the goal is, Vertexes, once added to a Mesh should say hello to one another, and negotiate
connections WITHOUT an omniscient manager. admittedly v.0 may not be quite like that, but
i'd like to base the grammar/syntax on this concept.

Vertexes

Initial handshake might be TCP. Object passing might be TCP (in an ideal world)
Should HELLO on connection to the network, check for conflicts,
generate a useful OSC namespace for the device, and distribute that information
to other vertexes on the nesh.

a Vertex with outgoing ports should be able to receive an OSC message that names a second vertex,
( Target IP address, port number, and an OSC path) and an outgoing port.
it should then start passing data:
from the outgoing port of the first Vertex
to the incoming port of the second vertex.

could be exceptions to this, eg. a vertex device that chooses a compatible target randomly, or accdg to some function.

vertex with ONLY incoming ports (eg. hardware synth or dmx controller, etc?)
some "dumb" devices might need a way to serve the vertex info to other nodes/hosts, via proxy (eg. supercollider/max, etc)

Namespace based on:

1.  the device Name
2.  Device Number (due to any collision from a similar device on the network)
3.  Device Port (input or output)

/Arduino1/knob1

steps:
a. DHCP IP assigned to Host (if applicable)
b. Broadcast IP Announce "Mesh::Type::IP Address"
c. Peers reply:
	* IP Address
	* Device OSCPath
	* incomng port number
	* PortList (PortPath, PortType)
		PortTypes: eg. Int, Float, Audio, Video, Image
d. device selects its own OSCPath
e. device broadcasts PortList
f. device listens for OSC Messages on incoming Port Number,
g. listens for Broadcast of new Vertexes

Outgoing Ports: active (assigned)
Incoming: passive

Vertex:
Name
OSCPath
PortList
PatchList
Compatible ports

And if it has input ports, choose an ephemeral incoming UDP port number.

Outgoing UDP Ports of transmitters will just dynamically set to match the incoming port number of the receiver.

Should share their Port information, eg.
Namespace :: Type :: Units :: Min :: Max

Mapping functionality
eg Digital Music Orchestra
? Should Identify other ports with compatible Types for easy connection

? Patches could hold a transformation function (scaling/mapping) of some sort

VertexServer: A Vertex that represents a Supercollider server node.
  at least for version 0.0, the Server will be at the end of a signal path,
  so essentially it determines the location of running synth nodes.
  when any other node is created, in order for it to be played,
  a server node with an audio out device should be connected

	Instance Variables:
		Host : A MeshHostAddr
		Server: a Server (may be local OR remote)

+++++++++++

Generic Object creation pseudocode:

1. Artist issues Vertex(\vertexName, \vertexType, \hostName, \name);

2. Vertex checks to be sure the mesh exists, then checks \name.vertexList
   2a. if it exists (currently returns the Vertex)
       Might want to extend functionality for updating in this syntax.

   2b. if it does NOT exist, checks for vertexType in vertexTypeList.

3. Messages vertexType.vertexRequestor, and passes:
    a. ref to Mesh object,
    b. ref to Host object from all,
    c. any other Args as an array.

4. VertexRequestor class method generates an OSC message and sends it to the named Host.

       To:   Host Address
       Path: /VertexType/request/new
       Msg:  (vertexName, mesh.name, ...arguments);

   A generic vertexRequestor method is inherited from VertexAbstract,
   but could be overloaded by VertexType depending on specific needs.

----------------------------
- Machine/Process Boundary -
----------------------------

5a. OSCdef receives request and marshalls its arguments
5b. Handles any preprocessing, eg. supplying default arguments,
5c. Passes request off to VertexType.vertexRequestHandler

6. vertexRequestHandler class method calls super.new.init and passes an unpacked array of arguments.
   This step is necessary because the instance isn't created yet.

   A generic vertexRequestHandler class method is inherited from VertexAbstract,
   but could be overloaded by VertexType depending on specific needs.

7. The VertexType.init method:
   7a. sets the initial state of the VertexType object.
   7b. adds the Vertex to the Mesh.vertexList
 ----- stopped here -----
   7c. tests the Success of adding the object,
   7d. returns success status to vertexRequestHandler

8a. If Creation succeeded, vertexRequestHandler calls VertexType.vertexProxyRequestor
8b. If Creation failed, vertexRequestHandler returns an OSC Remoting Error Message to the invoking client

9. vertexProxyRequestor

General practices for Vertexes:

- invocation process:

On Requesting Host;
 1. Vertex.new(\name, \type, \args)
 2. VertexType.requestor, inherits from VertexAbstract
 3. sends OSC msg to Vertex Host

---
On Vertex Host
 4. OSCdef VertexTypeRequestVertex
 5. VertexType.tryMakeVertex
 6. checks Mesh for vertex,
    7. makes proxy and initializes it.
    8. puts name -> this vertex into Mesh(\thisMesh).vertexes
    9. sendVertexConfirmation back to Requesting Host
    10. sendProxyRequest to Broadcast address (all hosts)

   b. makes new server, stores reference somewhere?
   c. returns notification or exceptions
6. Broadcast proxy requestor with reference to 5.b.
7. Proxy Request Handler adds proxy to Mesh.Vertexes
