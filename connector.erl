-module(connector).

-export([create/2, connect/2, disconnect/2, discard/1, connStatus/2, remove/2,checkList/1]).
-export([get_connected/1, get_ResInst/1, get_type/1]).

-export([init/2, test/0]). % for internal use only. 

create(ResInst_Pid, ConnectTyp_Pid) -> 
	spawn(?MODULE, init, [ResInst_Pid, ConnectTyp_Pid]).

init(ResInst_Pid, ConnectTyp_Pid) -> 
	survivor:entry(connector_created), 
	loop(ResInst_Pid, disconnected, ConnectTyp_Pid).

connect(Connector_Pid, C_Pid) ->
	Connector_Pid ! {connect, C_Pid}.

disconnect(Connector_Pid, C_Pid) ->
	Connector_Pid ! {disconnect, C_Pid}.
 
get_connected(Connector_Pid) ->
	msg:get(Connector_Pid, get_connected).

get_ResInst(Connector_Pid) ->
	msg:get(Connector_Pid, get_ResInst).

	
get_type(Connector_Pid) ->
	msg:get(Connector_Pid, get_type ).

		
discard(Connector_Pid) -> 
	Connector_Pid ! discard. 
	
% Connectors do not survive their ResInst, nor do they 
% move/change from one ResInst to another. 

loop(ResInst_Pid, Connected_Pid_List, ConnectTyp_Pid) -> 
	receive
		{connect, C_Pid} -> 
			survivor:entry({connection_made, self(), C_Pid, for , ResInst_Pid}),
			loop(ResInst_Pid, connStatus(Connected_Pid_List, C_Pid), ConnectTyp_Pid);
		{disconnect, Pid} -> 
			loop(ResInst_Pid, remove(Pid, Connected_Pid_List), ConnectTyp_Pid);
		{get_connected, ReplyFn} -> 
			ReplyFn(Connected_Pid_List),
			loop(ResInst_Pid, Connected_Pid_List, ConnectTyp_Pid);
		{get_ResInst, ReplyFn} -> 
			ReplyFn(ResInst_Pid),
			loop(ResInst_Pid, Connected_Pid_List, ConnectTyp_Pid);
		{get_type, ReplyFn} -> 
			ReplyFn(ConnectTyp_Pid),
			loop(ResInst_Pid, Connected_Pid_List, ConnectTyp_Pid);	
		discard -> 
			survivor:entry(connector_discarded),
			stopped
	end. 

connStatus(disconnected, C_Pid) -> [C_Pid];
connStatus(List,  C_Pid) -> [C_Pid| List].

remove(X, L) ->
    checkList([Y || Y <- L, Y =/= X]).
    
checkList([]) -> disconnected;
checkList(L) -> L.

test() -> 
	C1_Pid = create(self(), dummy1_pid),
	C2_Pid = create(self(), dummy2_pid),
	connect(C1_Pid, C2_Pid),
	{C1_Pid, C2_Pid}.

	
		