-module(deviceTyp).
-export([create/0]).

-export([init/0, loop/0]).


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



		