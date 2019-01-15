-module(sourceInst).
-export([create/3, switch_off/1, switch_on/1, is_on/1]).

-export([init/3, loop/4]).
% De source moet verbonden worden met de meegegeven draad
create(Host, SourceTyp_Pid, CableInst_Pid) -> {ok, spawn(?MODULE, init, [Host, SourceTyp_Pid, CableInst_Pid])}.

init(Host, SourceTyp_Pid, CableInst_Pid) -> 
	{ok, State} = resourceType:get_initial_state(SourceTyp_Pid, self(), []),
	survivor:entry({ sourceInst_created, State }),
	loop(Host, State, SourceTyp_Pid, CableInst_Pid).

switch_off(SourceInst_Pid) ->
	SourceInst_Pid ! switchOff. 

switch_on(SourceInst_Pid) ->
	SourceInst_Pid ! switchOn. 

is_on(SourceInst_Pid) -> 
	msg:get(SourceInst_Pid, isOn).

loop(Host, State, SourceTyp_Pid, CableInst_Pid) -> 
	receive
		switchOn -> 
			{ok, NewState} = msg:set_ack(SourceTyp_Pid, switchOn, State),
			loop(Host, NewState, SourceTyp_Pid, CableInst_Pid);
		switchOff -> 
			{ok, NewState} = msg:set_ack(SourceTyp_Pid, switchOff, State), 
			loop(Host, NewState, SourceTyp_Pid, CableInst_Pid);
		{isOn, ReplyFn} -> 
			{ok, Answer} = msg:get(SourceTyp_Pid, isOn, State), 
			ReplyFn(Answer), 
			loop(Host, State, SourceTyp_Pid, CableInst_Pid);
		{get_type, ReplyFn} -> 
			ReplyFn(SourceTyp_Pid),
			loop(Host, State, SourceTyp_Pid, CableInst_Pid);
		OtherMessage -> 
			CableInst_Pid ! OtherMessage,
			loop(Host, State, SourceTyp_Pid, CableInst_Pid)
end.