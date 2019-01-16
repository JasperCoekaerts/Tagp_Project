-module(sourceTyp).
-export([create/1, create_test/0]).

-export([init/1, loop/1, init_test/1, setImax/2, getImax/1, setVoltage/2, getVoltage/1, setType/2, getType/1]).


create(State) -> {ok, spawn_link(?MODULE, init, [State])}.
init(State) -> survivor:entry(sourceTyp_created), loop(State).

% Things that define a source:
	% Imax it can safely deliver
	% Voltage
	% Type: 3fase, Alternating, direct
	% connectors 
	
	%TypeOptions = {Imax, Voltage, Type}

create_test() -> {ok, spawn_link(?MODULE, init_test, [{100, 50, direct}])}.% Imax, V, Type
init_test(State) -> survivor:entry(sourceTyp_created), loop(State).


loop(State) ->
    receive
	{initial_state, [ResInst_Pid, TypeOptions], ReplyFn} ->
		Out_conn = connector:create(ResInst_Pid, cable),
		ReplyFn(#{resInst => ResInst_Pid, on_or_off => off,  typeOptions => TypeOptions, state => State, cList => [Out_conn]}), 
		loop(State);
	{connections_list, S , ReplyFn} -> 
	    #{cList := C_List} = S, ReplyFn(C_List), 
	    loop(State);
	{switchOff, State, ReplyFn} -> 
		#{rw_cmd := ExecFn} = State, ExecFn(off), 
		ReplyFn(State#{on_or_off := off}),
		loop(State); 
	{switchOn, State, ReplyFn} -> 
		#{rw_cmd := ExecFn} = State, ExecFn(on), 
		ReplyFn(State#{on_or_off := on}),
		loop(State); 
	{isOn, State, ReplyFn} -> 
		#{on_or_off := OnOrOff} = State, 
		ReplyFn(OnOrOff),
		loop(State);
		
	{get_imax, ReplyFn} -> 
		ReplyFn(element(1, State)),
		loop(State);
	{set_imax, Imax} ->
	    State2 = setelement(1, State, Imax),
	    loop(State2);
	    
	{get_voltage, ReplyFn} -> 
		ReplyFn(element(2, State)),
		loop(State);
	{set_voltage, Voltage} ->
	    State2 = setelement(2, State, Voltage),
	    loop(State2);
	    
	{get_type, ReplyFn} -> 
		ReplyFn(element(3, State)),
		loop(State);
	{set_type, Type} ->
	    State2 = setelement(3, State, Type),
	    loop(State2)
    end.
	
setImax(Source_Pid, Imax) ->  Source_Pid ! {set_imax, Imax}.
getImax(Source_Pid) ->
	msg:get(Source_Pid, get_imax).
	
setVoltage(Source_Pid, Voltage) ->  Source_Pid ! {set_voltage, Voltage}.
getVoltage(Source_Pid) ->
	msg:get(Source_Pid, get_voltage).
	
setType(Source_Pid, Type) ->  Source_Pid ! {set_type, Type}.
getType(Source_Pid) ->
	msg:get(Source_Pid, get_type).