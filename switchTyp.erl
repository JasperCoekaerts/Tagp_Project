-module(switchTyp).
-export([create/1, create_test/0]).

-export([loop/1, init/1, init_test/1, setResistance/2, getResistance/1, setType/2, getType/1, setOnOff/2, getOnOff/1]).


% Things that define a switch:
	% dimmer switch, on of,
	% % of power at input is passing through (in case of on of 100% or 0, in case of dimmer between 0% and 100%)
	% connectors

create(State) -> {ok, spawn_link(?MODULE, init, [State])}.
init(State) -> survivor:entry(switchTyp_created), loop(State).

	
create_test() -> {ok, spawn_link(?MODULE, init_test, [{on_off, 100}])}.% Type, dimmer, onoff; % E passing through
init_test(State) -> survivor:entry(test_switchTyp_created), loop(State).
	
loop(State) ->
    receive
	{initial_state, [ResInst_Pid, TypeOptions], ReplyFn} ->
	    Location = location:create(ResInst_Pid, emptySpace),
	    In = connector:create(ResInst_Pid, switch),
	    Out = connector:create(ResInst_Pid, switch),
	    ReplyFn(#{resInst => ResInst_Pid, chambers => [Location], 
	    cList => [In, Out], typeOptions => TypeOptions, state => State}),
	    loop(State);
	{connections_list, S , ReplyFn} -> 
	    #{cList := C_List} = S, ReplyFn(C_List), 
	    loop(State);
	{locations_list, S, ReplyFn} -> 
	    #{chambers := L_List} = S, ReplyFn(L_List),
	    loop(State);
	{get_type, ReplyFn} -> 
		ReplyFn(element(1, State)),
		loop(State);
	{set_type, Type} ->
	    State2 = setelement(1, State, Type),
	    loop(State2);
	{getOnOff, ReplyFn} -> 
		ReplyFn(element(2, State)),
		loop(State);
	{setOnOff, OnorOff} ->
	    State2 = setelement(2, State, OnorOff),
	    loop(State2)
    end.

setResistance(Switch_Pid, Resistance) ->  Switch_Pid ! {set_resistance, Resistance}.
getResistance(Switch_Pid) ->
	msg:get(Switch_Pid, get_resistance).
	
setType(Switch_Pid, Resistance) ->  Switch_Pid ! {set_type, Resistance}.
getType(Switch_Pid) ->
	msg:get(Switch_Pid, get_type).
	
setOnOff(Switch_Pid, OnorOff) ->  Switch_Pid ! {setOnOff, OnorOff}.
getOnOff(Switch_Pid) ->
	msg:get(Switch_Pid, getOnOff).