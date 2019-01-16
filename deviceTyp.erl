-module(deviceTyp).
-export([create/1, create_test/0]).

-export([init/1, loop/1, init_test/1, getResistance/1, setResistance/2, getCapacitance/1, setCapacitance/2, getInductance/1, setInductance/2, setVmax/2, getVmax/1, getPowerUse/1, setPowerUse/2, getOn_off/1, setOn_off/2]).


create(State) -> {ok, spawn_link(?MODULE, init, [State])}.
init(State) -> survivor:entry(deviceTyp_created), loop(State).

% Things that define a device:
	% Resistance, inductance, capacitance
	% Power draw in Watt
	% start/stop and runtime behaviour
	% Type of source(alternating/direct current, Voltage)
	% connectors
	% on - off
	
	
	%TypeOptions = {Resistance, inductance, capacitance, Vmax, Pmax, sourceTyp}

create_test() -> {ok, spawn_link(?MODULE, init_test, [{100, 10, 0, 230, 1000, 2, off}])}.%Resistance, inductance, capacitance, Vmax, kWatt/h, connectors, on-off
init_test(State) -> survivor:entry(deviceTyp_created), loop(State).
	
loop(State) ->
    receive
	{initial_state, [ResInst_Pid, TypeOptions], ReplyFn} ->
		In = connector:create(ResInst_Pid, device),
	    Out = connector:create(ResInst_Pid, device),
		ReplyFn(#{resInst => ResInst_Pid, on_or_off => off, typeOptions => TypeOptions, state => State, cList => [In, Out]}), 
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
	{get_resistance, ReplyFn} -> 
		ReplyFn(element(1, State)),
		loop(State);
	{set_resistance, Resistance} ->
	    State2 = setelement(1, State, Resistance),
	    loop(State2);
	{get_inductance, ReplyFn} -> 
		ReplyFn(element(2, State)),
		loop(State);
	{set_inductance, Inductance} ->
	    State2 = setelement(2, State, Inductance),
	    loop(State2);
	{get_capacitance, ReplyFn} -> 
		ReplyFn(element(3, State)),
		loop(State);
	{set_capacitance, Capacitance} ->
	    State2 = setelement(3, State, Capacitance),
	    loop(State2);
	{get_Vmax, ReplyFn} -> 
		ReplyFn(element(4, State)),
		loop(State);
	{set_Vmax, Vmax} ->
	    State2 = setelement(4, State, Vmax),
	    loop(State2);
	{get_poweruse, ReplyFn} -> 
		ReplyFn(element(5, State)),
		loop(State);
	{set_poweruse, PowerUse} ->
	    State2 = setelement(5, State, PowerUse),
	    loop(State2);
	{get_on_off, ReplyFn} -> 
		ReplyFn(element(6, State)),
		loop(State);
	{set_on_off, On_off} ->
	    State2 = setelement(6, State, On_off),
	    loop(State2)
    end.
	
setResistance(Device_Pid, Resistance) ->  Device_Pid ! {set_resistance, Resistance}.
getResistance(Device_Pid) ->
	msg:get(Device_Pid, get_resistance).
	
setInductance(Device_Pid, Inductance) ->  Device_Pid ! {set_inductance, Inductance}.
getInductance(Device_Pid) ->
	msg:get(Device_Pid, get_inductance).
	
setCapacitance(Device_Pid, Capacitance) ->  Device_Pid ! {set_capacitance, Capacitance}.
getCapacitance(Device_Pid) ->
	msg:get(Device_Pid, get_capacitance).

setVmax(Device_Pid, Vmax) ->  Device_Pid ! {set_Vmax, Vmax}.
getVmax(Device_Pid) ->
	msg:get(Device_Pid, get_Vmax).
	
	
setPowerUse(Device_Pid, PowerUse) ->  Device_Pid ! {set_poweruse, PowerUse}.
getPowerUse(Device_Pid) ->
	msg:get(Device_Pid, get_poweruse).
	
setOn_off(Device_Pid, On_off) ->  Device_Pid ! {set_on_off, On_off}.
getOn_off(Device_Pid) ->
	msg:get(Device_Pid, get_on_off).