// bugs!

// 1. creating another effect with the same name will replace the existing one.

// 2. using a wrong bus name will default to bus 0. unknown effect when using a number.


// 4. we need a new method for freeing all busses and synths



// 3. Temp Fixed: MOVED TO init file
//    not executing
         ~me=~addrBook.me
//    in the session file will break the oscdef.
//    (also need to look for other misuses of enironment variables like this.
