-module(switchTyp).
-export([create/0, create_test/0]).

-export([loop/0, init/0, loop_test/1, init_test/1]).


% Things that define a switch:
	% dimmer switch, on of, ...
	% leak current
	% internal resistance
	% % of power at input is passing through (in case of on of 100% or 0, in case of dimmer between 0% and 100%)
	% connectors

create() -> {ok, spawn_link(?MODULE, init, [{}])}.
init() -> survivor:entry(switchTyp_created), loop().

loop() ->
    receive
	{initial_state, [ResInst_Pid, TypeOptions], ReplyFn} ->
	    Location = location:create(ResInst_Pid, emptySpace),
	    In = connector:create(ResInst_Pid, switch),
	    Out = connector:create(ResInst_Pid, switch),
	    ReplyFn(#{resInst => ResInst_Pid, chambers => [Location], 
	    cList => [In, Out], typeOptions => TypeOptions}),
	    loop();
	{connections_list, State , ReplyFn} -> 
	    #{cList := C_List} = State, ReplyFn(C_List), 
	    loop();
	{locations_list, State, ReplyFn} -> 
	    #{chambers := L_List} = State, ReplyFn(L_List),
	    loop()
    end.

	
create_test() -> {ok, spawn_link(?MODULE, init_test, [{0.01 , type}])}.
init_test(State) -> survivor:entry(test_switchTyp_created), loop_test(State).
	
loop_test(State) ->
    receive
	{initial_state, [ResInst_Pid, TypeOptions], ReplyFn} ->
	    Location = location:create(ResInst_Pid, emptySpace),
	    In = connector:create(ResInst_Pid, switch),
	    Out = connector:create(ResInst_Pid, switch),
	    ReplyFn(#{resInst => ResInst_Pid, chambers => [Location], 
	    cList => [In, Out], typeOptions => TypeOptions}),
	    loop_test(State);
	{connections_list, State , ReplyFn} -> 
	    #{cList := C_List} = State, ReplyFn(C_List), 
	    loop_test(State);
	{locations_list, State, ReplyFn} -> 
	    #{chambers := L_List} = State, ReplyFn(L_List),
	    loop_test(State)
    end.
