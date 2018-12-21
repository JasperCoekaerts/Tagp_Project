-module(deviceTyp).
-export([create/0, create_test/0]).

-export([init/0, loop/0, init_test/1, loop_test/1, getResistance/1, setResistance/2, getCapacitance/1, setCapacitance/2, getInductance/1, setInductance/2, getPowerUse/1, setPowerUse/2, getOn_off/1, setOn_off/2]).


create() -> {ok, spawn_link(?MODULE, init, [])}.
init() -> survivor:entry(deviceTyp_created), loop().

% Things that define a device:
	% ElectricBehavior: Resistance, inductance, capacitance
	% Power draw in Watt
	% start/stop and runtime behaviour
	% Type of source(alternating/direct current, Voltage)
	% connectors
	% on - off
	
	
	%TypeOptions = {ElectricBehavior, PowerDraw, StartBehaviorFN, StopBehaviourFN, RuntimeBehaviourFN, Vmax, Pmax, sourceTyp}

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


create_test() -> {ok, spawn_link(?MODULE, init_test, [{100, 10, 5, 1000, 2, on}])}.%Resistance, inductance, capacitance, kWatt/h, connectors, on-off
init_test(State) -> survivor:entry(deviceTyp_created), loop_test(State).
	
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
	{get_resistance, ReplyFn} -> 
		ReplyFn(element(1, State)),
		loop_test(State);
	{set_resistance, Resistance} ->
	    State2 = setelement(1, State, Resistance),
	    loop_test(State2);
	{get_inductance, ReplyFn} -> 
		ReplyFn(element(2, State)),
		loop_test(State);
	{set_inductance, Inductance} ->
	    State2 = setelement(2, State, Inductance),
	    loop_test(State2);
	{get_capacitance, ReplyFn} -> 
		ReplyFn(element(3, State)),
		loop_test(State);
	{set_capacitance, Capacitance} ->
	    State2 = setelement(3, State, Capacitance),
	    loop_test(State2);
	{get_poweruse, ReplyFn} -> 
		ReplyFn(element(4, State)),
		loop_test(State);
	{set_poweruse, PowerUse} ->
	    State2 = setelement(4, State, PowerUse),
	    loop_test(State2);
	{get_on_off, ReplyFn} -> 
		ReplyFn(element(6, State)),
		loop_test(State);
	{set_on_off, On_off} ->
	    State2 = setelement(6, State, On_off),
	    loop_test(State2)
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
	
setPowerUse(Device_Pid, PowerUse) ->  Device_Pid ! {set_poweruse, PowerUse}.
getPowerUse(Device_Pid) ->
	msg:get(Device_Pid, get_poweruse).
	
setOn_off(Device_Pid, On_off) ->  Device_Pid ! {set_on_off, On_off}.
getOn_off(Device_Pid) ->
	msg:get(Device_Pid, get_on_off).