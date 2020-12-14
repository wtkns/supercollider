+ Server {

        prHandleNotifyFailString {|failString, msg|

                // post info on some known error cases
                case
                { failString.asString.contains("already registered") } {
                        "% - already registered with clientID %.\n".postf(this, msg[3]);
                        ////////// redirect to a clearly named method ...
                        this.prRecoverRemoteLogin(msg[3]);
                } { failString.asString.contains("not registered") } {
                        // unregister when already not registered:
                        "% - not registered.\n".postf(this);
                        statusWatcher.notified = false;
                } { failString.asString.contains("too many users") } {
                        "% - could not register, too many users.\n".postf(this);
                        statusWatcher.notified = false;
                } {
                        // throw error if unknown failure
                        Error(
                                "Failed to register with server '%' for notifications: %\n"
                                "To recover, please reboot the server.".format(this, msg)).throw;
                };
        }

        prRecoverRemoteLogin { |clientID|
                "% - recovering a remote login with clientID %.\n".postf(this, clientID);
                this.clientID_(clientID);
                fork({
			statusWatcher.notified = true;
			statusWatcher.prFinalizeBoot;
			this.changed(\serverRunning);
                }, AppClock);
        }
}