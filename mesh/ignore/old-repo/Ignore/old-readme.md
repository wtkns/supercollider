# Mesh:

## Conceptual:
Create a mesh of vertexes, which pass signals to each other via patches

Artists directly interact with the mesh, and do not need to know many of the details of how it works behind the scenes:

### Vocabulary:

**Mesh:** an environment that contains any number of vertexes

**Vertex:** a node which either generates, processes, or outputs data. Vertexes have an arbitrary number of Ports. and may or may not have a one-to-one relationship with hardware. Vertexes are based on a vertex "type", for example:
* Instrument
* Effect
* Midi Controller
* Arduino
* Pattern
* Audio Out
* Audio In
* CV Out
* Display
* DMX Controller
* Sample Bank
* Clock

![Image of Vertex Invocation Diagram](Diagrams/VertexInvocation.png)


**Port:** a single data terminal on a vertex, eg one control value from one knob on an Arduino, one pdefn from a pattern, one channel of audio in or out.

**Patch:** a connection between two ports

**Trunk:** a collection of patches (meant to make it easier to connect many ports at one time)

**Host:** part of the infrastructure that provides the Mesh by offering lists of available VertexTypes and connections to hardware, a host has a name and an address. generally artists do not interact with other hosts directly.

## Code Notes

A Mesh is created with a name:
```SuperCollider
Mesh(\name)
```
and activated:
```SuperCollider
Mesh(\name).push;
```

As other machines on the network create a Mesh with the same name, they are added to that mesh as hosts.

Users do not address other hosts directly. instead, they may choose from a list of vertexTypes pooled from all of the hosts. They may need to specify what hardware is to be made available on their host (audio interface, sample folders, arduino, etc.)


#Mesh

##Description
**A peer-to-peer virtual patchbay for routing OSC messages on multiple nodes. Provides a distributed address list for valid OSC Paths available in a session, and allows users to dynamically add and remove valid paths on their own peer and modify routing and parameters on other peers **

##Requirements
- A Peer may dynamically create one Session or multiple Sessions.
- A Peer may join, or leave multiple Sessions, which are already in progress.
- The Session will continue until all peers have left.
- The Session will be controlled by OSC Messages.
- A Peer may offer Jacks.
- Jack types will include streams and sphincters.
- A Stream Jack provides a stream of data (generated privately by the peer).
- A Sphincter Jack receives data (processed and routed privately by the peer)
- Sphincter data may be processed in one peer and routed back out to another Stream.
- Patches connect the jacks.
- Any Peer may create or destroy patches.
- Streams may be patched to more than one sphincter.
- Sphincters may receive more than one stream.
- All modifications to the Session are handled by OSC Requests to the SessionManager

###Basic procedure for new session:

	I. Peer 1 starts Session Manager (at class init?)
		i. SessionManager gets node information
			a. SessionManager.getThisPeer() sets object sessionManager.thisPeer
			b. SessionManager.thisPeer is stored in environment variable ~thisPeer
		ii. SessionManager.startListener() starts OSCListener
		ii. OSCListener listens for OSC Messages at paths:
			a. /OSCListener
				1. NewSessionRequest
				2. ListSessionRequest
			b. /OSCListener/Session
				1. SubscribeRequest
				2. AddPeerRequest
				3. RemovePeerRequest
				4. ListPeersRequest
				5. ListStreamsRequest (on all peers in session)
				6. ListSphinctersRequest (on all peers in session)
				7. AddPatchRequest
				8. RemovePatchRequest
				9. ListPatchRequest
			c. /OSCListener/Session/Peer
				1. AddStreamRequest
				2. RemoveStreamRequest
				3. ListStreamsRequest (on this peer only)
				4. AddSphincterRequest
				5. RemoveSphincterRequest
				6. ListSphinctersRequest (on this peer only)

	II. Peer 1 Starts a new Session, session1
		i. SessionManager.newSession("session1") returns object session1
		ii. session1 is added to peer1.sessionList[]
		iii. thisPeer is added to Session1.clientList[]

	III. Peer 2 joins session1
		i. peer2 SessionManager.joinSession(peer1, session1, peer2) sends OSC message to peer1
		ii. peer1's OSCListener receives the request and calls session1.subscribePeer(peer2)
		iii. session1.subscribePeer(peer2) sends OSC message to peer2
		iv. peer2's OSCListener receives the request and calls addSession(session1)
		v. peer2 adds session1 to sessionList[]
		vi. peer1 calls session1.addPeer(peer2)
		vii. session1.addPeer(peer2) sends OSC Message to all peers in session1.peerList[]

	IV. new Sphincter

	V. new patch



##Class Diagram


###Session Manager

Spawns sessions and creates the client object for the local machine. it has an OSC Listener (an OSCFunc) which receives and parses messages from other clients, and methods that send OSC requests to other clients in the session that can update the session. These requests are addressed like: "host/sessionName/requestType" and may contain objects or messages.


	----------------------
	- Class: SessionManager
	----------------------
	-	Attributes : Type [aggregation]
	-
	-		~thisClient : Client [1]
	-		~sessionList : Session [0..*]
	-		~oscListener : OSCListener [1]
	-
	-----------------------
	-	Methods (Args) -> Return type
	-		*new()
	-		*remove()
	-	 	newSession(name) -> Session
	-		quitSession(Session)
	-		joinSession(sessionName, ip) -> Session
	-		getThisPeer() -> Client
	-		startListener() -> OSCListener
	-		killListener() ->
	-		listSessions() -> array['string']
	-		subscribePeer(Peer, sessionName) -> Session
	-----------------------




###OSC Listener

because we need to move copies of objects around on the network (clients, matrix requests) we can create an OSC Function that takes a message over osc containing the contents of a remote object (maybe a blob?) and passes the contents to the Session Manager, which updates the session object recreates it on each peer to this Parses the request and calls the appropriate instance method from the requested Session:



	----------------------
	- Class: OSCListener : OSCFunc
	----------------------
	-	Attributes:
	-
	-----------------------
	-	Methods:
	-
	-		*initOSCListener
	-			newClient(Client)
	-			rmClient(client)
	-			newStream(Stream)
	-			rmStream(Stream)
	-			newSphincter(Sphincter)
	-			rmSphincter(Sphincter)
	-			newPatch(Patch)
	-			rmPatch(Patch)
	-
	-----------------------
	OSCFunc [1]


**OSC Request Types:**

- **NewSessionRequest(name)**
  - Creates new Session
  - adds thisClient to new Session

- **UpdateSessionRequest(<*Session*>)**
  - loads session into SessionManager

- **SubscribeRequest(<*Client*>)**
  - returns UpdateSessionRequest(<*Session*>) to subscriber
  - adds <*subscriber*> to Session.clients[]
  - sends NewClientRequest(<*subscriber*>) to all clients in Session

- **NewClientRequest(<*Client*>)**
  - adds <*Client*> to Session.clients[]

- **RmClientRequest(<*Client*>)**
  - removes <*Client*> from Session.clients[]

- **UpdateClientRequest(<*Client*>)**
  - maybe use this instead of separate requests for Streams/Sphxrs? might be better for keeping everything in sync?
  - NewStreamRequest
  - RmStreamRequest
  - NewSphincterRequest
  - RmSphincterRequest
  - NewPatchRequest
  - RmPatchRequest



###Session

Consists of clients (which can provide either streams or sphincters) and a routing matrix that directs the streams to sphincters.

	----------------------
	- Class: Session
	----------------------
	-	Attributes:
	-
	- 		name
	-
	- 		clients: Client [0..*]
	-		routingMatrix: RoutingMatrix [1]
	-
	-----------------------
	-	Methods:
	-
	-		*initOSCListener
	-			newClient(Client)
	-			rmClient(client)
	-			newStream(Stream)
	-			rmStream(Stream)
	-			newSphincter(Sphincter)
	-			rmSphincter(Sphincter)
	-			newPatch(Patch)
	-			rmPatch(Patch)
	-
	-----------------------


###Routing Matrix
contains patches, each client has a copy of the routing matrix and uses it to address outbound OSC Messages

	----------------------
	- 	Class: RoutingMatrix
	----------------------
	-	Attributes:
	-		patch: Patch [0..*]
	-
	-----------------------
	-	Methods:
	-		sendOSCMsg(Stream, data)
	-
	-----------------------


### Clients
Are anything with an IP address and a port, they can join dynamically and publish streams and sphincters.

	----------------------
	- Class: Client
	----------------------
	-	Attributes:
	-		hostname
	-		address
	-		port
	-		streams:Stream[0..*]
	-		sphincters:Sphincter[0..*]
	-
	-----------------------
	-	Methods:
	-
	-----------------------

### Jack
(parent class for both sphincters and streams)


	----------------------
	- Class: Jack
	----------------------
	-	Attributes:
	-		name
	-		description
	-		type
	-
	-----------------------
	-	Methods:
	-
	-----------------------

###Streams
are any source of a stream of OSC Messages.


	----------------------
	- Class: Stream :  Jack
	----------------------
	-	Attributes:
	-		private
	-
	-----------------------
	-	Methods:
	-
	-----------------------

###Sphincters
are anything which is listening for OSC Messages.


	----------------------
	- Class: Sphincter : Jack
	----------------------
	-
	-	Attributes:
	-		oscPath
	-
	-----------------------
	-	Methods:
	-
	-----------------------


###Patches
are links between Streams and Sphincters.


	----------------------
	- 	Class: Patch
	----------------------
	-	Attributes:
	-		stream: Stream [1]
	-		sphincter: Sphincter [1]
	-		owner:	Client [1]
	-		protected: Boolean
	-
	-----------------------
	-	Methods:
	-
	-----------------------




## Future Stuff

- visualizations or gui for managing routing matrix

- permissions system for routing matrix

- chat system

- logger(record)
