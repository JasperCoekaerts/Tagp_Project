-module(deviceInst).
-export([create/4, switch_off/1, switch_on/1, is_on/1]).

-export([init/4, loop/4]).

create(Host, DeviceTyp_Pid, CableInst_Pid, RealWorldCmdFn) -> {ok, spawn(?MODULE, init, [Host, DeviceTyp_Pid, CableInst_Pid, RealWorldCmdFn])}.

init(Host, DeviceTyp_Pid, CableInst_Pid, RealWorldCmdFn) -> 
	{ok, State} = apply(resource_type, get_initial_state, [DeviceTyp_Pid, self(),     [CableInst_Pid, RealWorldCmdFn]]),
	survivor:entry({ deviceInst_created, State }),
	loop(Host, State, DeviceTyp_Pid, CableInst_Pid).

switch_off(DeviceInst_Pid) ->
	DeviceInst_Pid ! switchOff. 

switch_on(DeviceInst_Pid) ->
	DeviceInst_Pid ! switchOn. 

is_on(DeviceInst_Pid) -> 
	msg:get(DeviceInst_Pid, isOn).

loop(Host, State, DeviceTyp_Pid, CableInst_Pid) -> 
	receive
		switchOn -> 
			{ok, NewState} = msg:set_ack(DeviceTyp_Pid, switchOn, State),
			loop(Host, NewState, DeviceTyp_Pid, CableInst_Pid);
		switchOff -> 
			{ok, NewState} = msg:set_ack(DeviceTyp_Pid, switchOff, State), 
			loop(Host, NewState, DeviceTyp_Pid, CableInst_Pid);
		{isOn, ReplyFn} -> 
			{ok, Answer} = msg:get(DeviceTyp_Pid, isOn, State), 
			ReplyFn(Answer), 
			loop(Host, State, DeviceTyp_Pid, CableInst_Pid);
		{get_type, ReplyFn} -> 
			ReplyFn(DeviceTyp_Pid),
			loop(Host, State, DeviceTyp_Pid, CableInst_Pid);
		OtherMessage -> 
			CableInst_Pid ! OtherMessage,
			loop(Host, State, DeviceTyp_Pid, CableInst_Pid)
end.