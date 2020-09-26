// extension of stream for purposes of sending over network

// add a class method .allStop to stop all PStream routines on a machine?


PStream {
    var <>bind, <>interval, <>addrBook, <>clock, <>quant, <>routine;

    *new {|bind, interval, addrBook, clock, quant|
        ^super.newCopyArgs(bind, interval, addrBook, clock, quant);
    }

    send {|msg|
        var target, path, sndMsg;
		target = (addrBook.at(msg.removeAt(\target))).addr;
        path = msg.removeAt(\oscpath);
        sndMsg = msg.getPairs;
        target.sendMsg(path, *sndMsg);
		//sndMsg.postln;
    }

    stop { routine.stop;}

	step{
		var bindStream = bind.asStream;
		this.send(bindStream.next(()));
	}

    play{
		var bindStream = bind.asStream;
		var intervalStream = interval.asStream;
        routine = {
            loop({
                this.send(bindStream.next(()));
				intervalStream.next(()).wait
            })
        }.fork(clock, quant: quant)
    }
}