SphnxrSesMgr {
	var <session;

	*new { ^super.new.init }

	init {
		"config.scd".loadRelative;

		session = Environment.make({
			~hostname = ("hostname".unixCmdGetStdOut.split($.)[0]).asSymbol;
			~win = Window("network").minimize;
			~addrBook = AddrBook.new;
			~addrBook.addMe(~hostname); // add this machine
			~effectManager = EffectManager.new;
			~synthManager = SynthManager.new;
			~bufferManager = BufferManager.new;
			~hail = Hail(~addrBook);
			~me=~addrBook.me;
		});



	}
}