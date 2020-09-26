
-----------------
'Getting around in SC3'

Getting help 

cmd+d 

If you just press help this brings up the main help menu. If you have selected some text you may be able to get help on that specific thing, but the help pages only exist for certain items. These are usually things with capital letters in front, like:

SinOsc //try double clicking on SinOsc then pressing cmd+d 

There are further hints on obtaining help available from the help page itself, or double click on the underlined text here:

[More-On-Getting-Help]




Searching for stuff

Use your system text file search tools. 

(OS X) using Find in the OS X Finder- use cmd+F to bring up the search



unix Commands can also be used within SC3 using the unixCmd method for String

"ls -l".unixCmd //run by pressing enter

"grep -r 'TempoClock.default' SCClassLibrary/*".unixCmd


(OS X) Use a Terminal window to do this from the command line. You find the Terminal under Utilities in the Applications folder on your OS X drive. 


-----------------------------------------------------------------------
Advanced- getting the result of unix commands back to SuperCollider:

(
//var p, l,
d = "";
p = Pipe.new("ls -l", "r");
l = p.getLine;
while({l.notNil}, {d = d ++ l ++ "\n"; l = p.getLine; }); 
p.close; 

 
)

Post << d << nl; 

d[0..20]
-----------------------------------------------------------------------







Looking at source code

to see class definitions

Object //highlight Object and then press cmd+J

to see which classes respond to a particular method

series //highlight 'series' and then press cmd+Y

to find cases in the class library where that method is called

series //highlight 'series' and press shift+cmd+Y

to find out class hierarchies- what derives from this? 

Clock.dumpClassSubtree //run this by pressing enter with cursor on the line 

to see the interface (methods of a class)

Array.dumpInterface //see instance methods

Meta_Array.dumpInterface //see class methods

does it have a help file or not? 

Array.hasHelpFile














Getting out of trouble

If you accidentally close a Server window

Server.local.makeWindow; //see Main.startup
Server.internal.makeWindow; //see Main.startup


If things can't be stopped! 

first- Cmd+period (.) 

second- quit the Server

third- Recompile the library cmd+K


Occasionally a Server/Lang crash might force you to kill the applications from the system. On the command line you use

ps -aux

or

top

To see what processes are running and their numerical IDs then 

kill (processnumber) 

To stop them. If on boot SC3 can't set up OSC, there may be an old Server instance running which you have to go in an kill explicitly via the command line.

(OS X) You can do the same kill operations from the graphical ProcessViewer program, or via the Force Quit option from the Dock. 






Managing SC

To purge your synthdef files:

"rm synthdefs/*.scsyndef".unixCmd;

But it may be best to just go in via the Finder to browse selectively...











