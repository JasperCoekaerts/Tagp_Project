-module(sourceTyp).
-export([create/0, create_test/0]).

-export([init/0, loop/0, init_test/1, loop_test/1, setImax/2, getImax/1, setVoltage/2, getVoltage/1, setType/2, getType/1]).


create() -> {ok, spawn_link(?MODULE, init, [])}.
init() -> survivor:entry(sourceTyp_created), loop().

% Things that define a source:
	% Imax it can safely deliver
	% Voltage
	% Type: 3fase, Alternating, direct
	% connectors 
	
	%TypeOptions = {Imax, Voltage, Type}

loop() ->
    receive
	{initial_state, [ResInst_Pid, [CableInst_Pid, RealWorldCmdFn], TypeOptions], ReplyFn} ->
		ReplyFn(#{resInst => ResInst_Pid, cableInst => CableInst_Pid, 
					rw_cmd => RealWorldCmdFn, on_or_off => off, typeOptions => TypeOptions}), 
		loop();
	{switchOff, State, ReplyFn} -> 
		#{rw_cmd := ExecFn} = State, ExecFn(off), 
		ReplyFn(State#{on_or_off := off}),
		loop(); 
	{switchOn, State, ReplyFn} -> 
		#{rw_cmd := ExecFn} = State, ExecFn(on), 
		ReplyFn(State#{on_or_off := on}),
		loop(); 
	{isOn, State, ReplyFn} -> 
		#{on_or_off := OnOrOff} = State, 
		ReplyFn(OnOrOff),
		loop()
    end.

create_test() -> {ok, spawn_link(?MODULE, init_test, [{100, 50, direct}])}.% Imax, V, Type
init_test(State) -> survivor:entry(sourceTyp_created), loop_test(State).


loop_test(State) ->
    receive
	{initial_state, [ResInst_Pid, [CableInst_Pid, RealWorldCmdFn], TypeOptions], ReplyFn} ->
		ReplyFn(#{resInst => ResInst_Pid, cableInst => CableInst_Pid, 
					rw_cmd => RealWorldCmdFn, on_or_off => off, typeOptions => TypeOptions}), 
		loop_test(State);
	{switchOff, State, ReplyFn} -> 
		#{rw_cmd := ExecFn} = State, ExecFn(off), 
		ReplyFn(State#{on_or_off := off}),
		loop_test(State); 
	{switchOn, State, ReplyFn} -> 
		#{rw_cmd := ExecFn} = State, ExecFn(on), 
		ReplyFn(State#{on_or_off := on}),
		loop_test(State); 
	{isOn, State, ReplyFn} -> 
		#{on_or_off := OnOrOff} = State, 
		ReplyFn(OnOrOff),
		loop_test(State);
	{get_imax, ReplyFn} -> 
		ReplyFn(element(1, State)),
		loop_test(State);
	{set_imax, Imax} ->
	    State2 = setelement(1, State, Imax),
	    loop_test(State2);
	{get_voltage, ReplyFn} -> 
		ReplyFn(element(2, State)),
		loop_test(State);
	{set_voltage, Voltage} ->
	    State2 = setelement(2, State, Voltage),
	    loop_test(State2);
	{get_type, ReplyFn} -> 
		ReplyFn(element(3, State)),
		loop_test(State);
	{set_type, Type} ->
	    State2 = setelement(3, State, Type),
	    loop_test(State2)
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