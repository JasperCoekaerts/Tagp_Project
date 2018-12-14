-module(test).
-export([start/0,createConnection/0]).

start() -> 
	survivor:start().
	
createConnection() -> 
	{ok,PidR} = resourceType:create(cableTyp, []),
	{ok,Pid1} = resourceInst:create(cableInst, [self(), PidR]),
	{ok,Pid2} = resourceInst:create(cableInst, [self(), PidR]),
	{ok, [C1, C2]} = resourceInst:list_connectors(Pid1),
	{ok, [C3, C4]} = resourceInst:list_connectors(Pid2),
	connector:connect(C1, C2),
	connector:connect(C3, C4), 
	{C1, C2, C3, C4}.
