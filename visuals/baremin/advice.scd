(some suggestion without digging very deep into your code...)

did you look at the the sort of universal perform method. �here are two examples...
a= \yellow;
Color.perform(a)
a= \rand;
Color.perform(a)

so using this trick you could just save the strategies as symbols and call the corresponding method when you update each particle. �something like this...
//anima.strategy= \fall;
move {
� � � �position= Strategy.perform(strategy, this);
}


or, as i do it in my redUniverse system, use functions. �each particle have a variable set to whatever strategy function. �say we have these two...
riseStratFunc= {|part| part.position= part.position+Point(0, 1)};
fallStartFunc= {|part| part.position= part.position+Point(0, -1)};

and then you assign one of them to a particle...
anima.strategy= riseStratFunc;

last you just call with .value whichever stored function and pass along this as an argument...
move {
� � � �position= strategy.value(this);
}


the reason your setup isn't working i believe is because of this...
> tempPart=strategy(this);

what you've stored in the strategy variable is the result of Strategy.rise, and then you're trying to call () on that - which doesn't make sense. �you'll need some kind of selector here like strategy.value(this) for functions or Strategy.perform(strategy) for the perform trick. �a dictionary lookup would also work. �dict[strategy].value(this) for example if you have symbol-function pairs stored in the dict.


and i'd stay away from letting Strategy modify the particles. �don't know but just a gut feeling. �so things like this...
> //thisPart.postition.set(thisPart.position.x, thisPart.position.y + 1);

i'd code differently letting the Anima class do the updating of it's own variables. �the Strategy class would in this case work more like a calculator for the next position. �so from inside Anima i'd ask the Strategy class... here's where i'm at (giving it position as an argument), now figure out where my next position will be and return that as a point.

//pseudocode
Anima {
� � � �move {
� � � � � � � �this.position= Strategy.perform(this.strategy, this.position);
� � � �}
}

or if you go the function route...
Anima {
� � � �move {
� � � � � � � �this.position= this.strategy.value(this.position);
� � � �}
}

hope that helped somewhat and wasn't too confusing. �there are other ways to do it as well.
_f