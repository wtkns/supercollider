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
