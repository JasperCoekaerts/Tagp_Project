-module(main).
-export([test/0, get_time/0]).

test() -> {ok, Gpio17} = gpio:start_link(17, input),
		gpio:read(Gpio17),
		gpio:register_int(Gpio17),
		gpio:set_int(Gpio17, both).
		
get_time() -> calendar:now_to_local_time(erlang:timestamp()).