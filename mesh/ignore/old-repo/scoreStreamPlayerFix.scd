
p = Pspawner({ |sp|
        sp.par( Pchain(
                Pmono(\swarmSaw, \dummyArg, 0),
                Pbindef(\swarm,
                        \dur, 0.25,
                        \amp1,  Pdefn(\swarmAmp1, Pmeanrand(0.1, 0.25))
                )));

        sp.wait(2.0);
        sp.par(Pbindef(\swarm, \freq1, Pmeanrand(100, 200)));
});

~score = p.asScore(10.0);





he output is:

record : setting clientID to 0.
WARNING: Called from ScoreStreamPlayer:initScoreStreamPlayer, method
Meta_Server:set is deprecated and will be removed. Use Meta_Server:all
instead.
The definition of 'Meta_Server:set' is to be found here:
'/Applications/SuperCollider/SuperCollider.app/Contents/Resources/SCClassLibrary/deprecated/3.9/deprecated-3.9.sc'
PATH: /Users/james/git/wtkns/solo/scorePspawn.scd


ERROR: Message 'nextTimeOnGrid' not understood.
RECEIVER:
Instance of ScoreStreamPlayer {    (0x117137cc8, gc=B0, fmt=00, flg=00,
set=06)
  instance variables [33]
    name : Symbol 'record'
    addr : instance of NetAddr (0x1175564c8, size=4, set=2)
    clientID : Integer 0
    isLocal : true
    inProcess : false
    sendQuit : nil
    remoteControlled : false
    maxNumClients : nil
    options : instance of ServerOptions (0x117135f78, size=38, set=6)
    latency : Integer 0
    dumpMode : Integer 0
    nodeAllocator : instance of NodeIDAllocator (0x1167d8248, size=7, set=3)
    controlBusAllocator : instance of ContiguousBlockAllocator (0x1147a0a58,
size=6, set=3)
    audioBusAllocator : instance of ContiguousBlockAllocator (0x1148f1478,
size=6, set=3)
    bufferAllocator : instance of ContiguousBlockAllocator (0x11635b278,
size=6, set=3)
    scopeBufferAllocator : instance of StackNumberAllocator (0x11757e248,
size=4, set=2)
    tree : nil
    defaultGroup : instance of Group (0x1167e7c88, size=5, set=3)
    defaultGroups : instance of Array (0x117514738, size=1, set=2)
    syncThread : nil
    syncTasks : nil
    window : nil
    scopeWindow : nil
    emacsbuf : nil
    volume : instance of Volume (0x11959dc38, size=15, set=4)
    recorder : instance of Recorder (0x11959de98, size=14, set=4)
    statusWatcher : instance of ServerStatusWatcher (0x117bb1ac8, size=20,
set=5)
    pid : nil
    serverInterface : nil
    beats : Float 2.000000   00000000 40000000
    tempo : Integer 1
    bundleList : instance of Array (0x116d1a618, size=8, set=3)
    maxTime : Float 10.000000   00000000 40240000
}
ARGS:
   Float 1.000000   00000000 3FF00000
   Integer 0
PATH: /Users/james/git/wtkns/solo/scorePspawn.scd
CALL STACK:
        DoesNotUnderstandError:reportError
                arg this = <instance of DoesNotUnderstandError>
        Nil:handleError
                arg this = nil
                arg error = <instance of DoesNotUnderstandError>
        Thread:handleError
                arg this = <instance of Thread>
                arg error = <instance of DoesNotUnderstandError>
        Thread:handleError
                arg this = <instance of Routine>
                arg error = <instance of DoesNotUnderstandError>
        Thread:handleError
                arg this = <instance of Routine>
                arg error = <instance of DoesNotUnderstandError>
        Thread:handleError
                arg this = <instance of Routine>
                arg error = <instance of DoesNotUnderstandError>
        Thread:handleError
                arg this = <instance of Routine>
                arg error = <instance of DoesNotUnderstandError>
        Thread:handleError
                arg this = <instance of Routine>
                arg error = <instance of DoesNotUnderstandError>
        Thread:handleError
                arg this = <instance of Routine>
                arg error = <instance of DoesNotUnderstandError>
        Thread:handleError
                arg this = <instance of Routine>
                arg error = <instance of DoesNotUnderstandError>
        Thread:handleError
                arg this = <instance of Routine>
                arg error = <instance of DoesNotUnderstandError>
        Object:throw
                arg this = <instance of DoesNotUnderstandError>
        Object:doesNotUnderstand
                arg this = <instance of ScoreStreamPlayer>
                arg selector = 'nextTimeOnGrid'
                arg args = [*2]
        PfinQuant:embedInStream
                arg this = <instance of PfinQuant>
                arg inval = <instance of Event>
                var value = nil
                var stream = <instance of EmbedOnce>
                var referenceClock = <instance of ScoreStreamPlayer>
                var endAt = nil
        < FunctionDef in Method Pseq:embedInStream >
                arg i = 0
        Integer:do
                arg this = 2
                arg function = <instance of Function>
                var i = 0
...
^^ The preceding error dump is for ERROR: Message 'nextTimeOnGrid' not
understood.
RECEIVER: record




ames watkins wrote
>       Object:doesNotUnderstand
>               arg this =
> <instance of ScoreStreamPlayer>
>               arg selector = 'nextTimeOnGrid'
>               arg args = [*2]
>       PfinQuant:embedInStream
>               arg this =
> <instance of PfinQuant>
>               arg inval =
> <instance of Event>
>               var value = nil
>               var stream =
> <instance of EmbedOnce>
>               var referenceClock =
> <instance of ScoreStreamPlayer>
>               var endAt = nil

So the problem is the application of some form of quantization, which
expects a clock but is incompatible with score rendering.

Aha, here:

        constrainStream { arg stream, newStream;
                ^if(this.quant.isNil) {
                        newStream
                } {
                        Pseq([PfinQuant(EmbedOnce(stream), this.quant, clock),
newStream]).asStream
                }
        }

Pdefs and Pbindefs have a quant property, which must be non-nil in this
case, to activate this code.

So, possible solutions:

- Make sure quant is nil. It's probably coming from some defaultQuant. Try
"Pdef.defaultQuant = nil" but I'm not totally sure.

- Or, don't use Pbindef -- as a last resort. I'm reasonably confident
clearing the quant will be ok.

hjh
julian.rohrhuber@musikundmedien.net via lists.bham.ac.uk 
	
AttachmentsMar 2 (7 days ago)
	
to sc-users
The reason behind this is that ScoreStreamPlayer acts both as a Server (it is a subclass of Server) and as a clock. But of course it isn’t a subclass of Clock. The implementation of ScoreStreamPlayer is incomplete (I talked to Scot Wilson once about it and he said it wouldn’t be much work to do it. But it hasn’t been done yet).

An intermediate solution would be to have a class ScoreClock that the ScoreStreamPlayer passes to the thread in makeScore.




