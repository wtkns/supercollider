// link in ~/.config/SuperCollider/startup.scd, according to the xdg base directory specification
"SC_JACK_DEFAULT_INPUTS".setenv("");
"SC_JACK_DEFAULT_OUTPUTS".setenv("");

o = Server.default.options;
o.numOutputBusChannels = 6; // The next time it boots, this will take effect
o.numInputBusChannels = 6; // The next time it boots, this will take effect
o.memSize_(65536 * 4);
Server.default.reboot;



