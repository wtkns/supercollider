
-----------------
Extending SuperCollider


As well as rich libraries of classes and UGens which come with SuperCollider, there are many third party extensions (examples, classes and UGens) which you can download from various places:

the swiki site
http://swiki.hfbk-hamburg.de:8888/MusicTechnology/6

the sc-plugins SourceForge project:
http://sourceforge.net/projects/sc3-plugins/


the Quarks repository (see [Quarks])

Various third party websites

Off the sc-users mailing list (archive via Google if you search with sc-users in the search line, or via the swiki site or Nabble archives)






























The easiest way to install such packages is to put all help files, .sc class files and plugin files (like .scx, .sco and similar) into the platform specific Extensions directory.


on my Mac this is :

/Library/Application Support/SuperCollider/Extensions/


Then startup SuperCollider or recompile SuperCollider if it is already open (cmd+K on a Mac). Now open any main help file for the library in SC, boot the server and try the examples. 

(otherwise you will need to put classes in SCClassLibrary, plugin files in the plugins directory and the help files in Help, within the main SuperCollider directory folder)

Most extensions should come with a readme file with instructions.













Customising SuperCollider

You may also wish to change the default options in SuperCollider. 

You might do this by modifying these classes:

ServerOptions 
Main

But it is much more straight forward to modify a platform specific startup file. 

On a Mac, this is located at:

~/scwork/startup.rtf

(i.e. in your home directory)








To give an example of the sort of thing that can go in there, here is an extract from mine:
 
Server.local.options.numOutputBusChannels = 8;
Server.local.options.numInputBusChannels = 8;
Server.internal.options.numOutputBusChannels = 8;
Server.internal.options.numInputBusChannels = 8;
Server.local.options.memSize = 10*8192; //so lots of memory for delay lines in Comb UGens etc
Server.internal.options.memSize = 10*8192;
 
Server.local.latency=0.045; //low latency is helpful for optimal performance for some machine listening processes
Server.internal.latency= 0.025;

"SC_PLUGIN_PATH".setenv("~/scwork/plugins".standardizePath); // all defs in this directory will be loaded at startup
"echo \"Loading Plugins From '$SC_PLUGIN_PATH'\"".unixCmd;

SynthDef.synthDefDir_("~/scwork/synthdefs/".standardizePath);

"SC_SYNTHDEF_PATH".setenv("~/scwork/synthdefs".standardizePath); // all defs in this directory will be loaded at startup
"echo \"Loading SynthDefs From '$SC_SYNTHDEF_PATH'\"".unixCmd;
 
 
//Server.local.recSampleFormat_("int16"); //I sometimes might use this for standard wav file out as deafult, but currently accepting the float default
//Server.internal.recSampleFormat_("int16"); 
Server.local.recHeaderFormat_("wav"); 
Server.internal.recHeaderFormat_("wav"); 

 
//for general use I also use symbolic links (ln -s path) from /Library/Application Support/SuperCollider/Extensions to my own class folder and help folder directories- I also use a symbolic link to put the startup file in a different place to begin with! 















It is also possible to overwrite existing methods of classes or add extra methods to classes, without modifying original source files- this is really helpful if you are frequently updating SuperCollider and don't want to have to change anything in a new download.


To hack my own Server window GUIs I made a class file of the form

+ Server {
 makeWindow { arg w;
 
 ...
 
 }
 
 }

The + Server part means that this class file is adding extra methods to the Server class (which can be instance or class methods). If a method exists already, it can be overwritten- hence my suppressal of the standard Server GUI.

 



















Because SC3 is open source, it is even possible to compile SuperCollider yourself after modifying the server or language code. This, however, is not recommended for the faint hearted. The furthest you might go in normal practise is writing new plug-ins for the server (new UGens) which is carried out with C programming. 




















