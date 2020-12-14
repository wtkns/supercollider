# mesh_utopia
Basic starting point for a mesh collaborative session using Utopia and the Mesher

## Getting started
requires https://github.com/muellmusik/Utopia

open mesh_startup.scd in SuperCollider and run the parts of the code to bootstrap a the type of desired session.

## What does it include?
## mesh_startup.scd
**Start here** to get things going.
Includes a couple of optional lines to execute to enable different types of sessions.
types of sessions include:
- everyone on the same network with 1 machine acting as the scsynth server
- everyone on the same network with all machines running scsynth and all code executed on all machines
- everyone on a VPN server with 1 scsynth
- everyone on a VPN server each running a scsynth
### setup_utopia.scd
sets up an AddressBook, SynthDescRelay, CodeRelay with SuperCollider History.
### mesher_server_options.scd
configures the remote server to be Mesher.
### server_options.scd
bare bones local server
### 
