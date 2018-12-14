-module(deviceTyp).
-export([create/0]).

-export([init/0, loop/0]).


create() -> spawn_link(?MODULE, init, []).
init() -> survivor:entry(deviceTyp_created), loop().

% Things that define a device:
	% ElectricBehavior: Resistance, inductance, capacitance
	% Power draw in Watt
	% start/stop and runtime behaviour
	% Type of source(alternating/direct current, Voltage)
	% connectors
	
	
	%TypeOptions = {ElectricBehavior, PowerDraw, StartBehavior, StopBehaviour, RuntimeBehaviour, Vmax, Pmax, sourceTyp}

loop() ->
    receive
	{initial_state, [ResInst_Pid, TypeOptions], ReplyFn} ->
	    Location = location:create(ResInst_Pid, emptySpace),
	    In = connector:create(ResInst_Pid, device),
	    Out = connector:create(ResInst_Pid, device),
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



		