-module(tijd).
-export([tijd/0, tijd/1, get_time/0]).

get_time() -> calendar:now_to_local_time(erlang:timestamp()).

tijd() -> {_, Time} = get_time(),
			{H, _, _} = Time, 
			Vochtend = H < 7,
			Ochtend = 7 =< H andalso H < 11,
			Middag = 11 =< H andalso H < 13,
			Namiddag = 13 =< H andalso H < 17,
			Avond = 17 =< H andalso H < 23,
			Nacht = 23 =< H,
			tijd({Vochtend, Ochtend, Middag, Namiddag, Avond, Nacht}).

tijd({true,_,_,_,_,_}) -> nacht; 			
tijd({_,true,_,_,_,_}) -> ochtend; 
tijd({_,_,true,_,_,_}) -> middag;
tijd({_,_,_,true,_,_}) -> namiddag;
tijd({_,_,_,_,true,_}) -> avond;
tijd({_,_,_,_,_,true}) -> nacht.
