-module(cableInst).
-export([create/2]).

-export([init/2, loop/3]).

create(Host, ResTyp_Pid) -> {ok, spawn(?MODULE, init, [Host, ResTyp_Pid])}.

init(Host, ResTyp_Pid) -> 
	{ok, State} = resource_type:get_initial_state(ResTyp_Pid, self(), []),
	survivor:entry({ cableInst_created, State }),
	loop(Host, State, ResTyp_Pid).

loop(Host, State, ResTyp_Pid) -> 
	receive
		{get_connectors, ReplyFn} ->
			{ok,C_List} = resource_type:get_connections_list(ResTyp_Pid, State), 
			ReplyFn(C_List),
			loop(Host, State, ResTyp_Pid);
		{get_locations, ReplyFn} ->
			{ok, List} = resource_type:get_locations_list(ResTyp_Pid, State),
			ReplyFn(List),
			loop(Host, State, ResTyp_Pid);
		{get_type, ReplyFn} -> 
			ReplyFn(ResTyp_Pid),
			loop(Host, State, ResTyp_Pid);
		{get_ops, ReplyFn} ->
			ReplyFn([]),
			loop(Host, State, ResTyp_Pid);
		{get_state, ReplyFn} ->
			ReplyFn(State),
			loop(Host, State, ResTyp_Pid)
	end.