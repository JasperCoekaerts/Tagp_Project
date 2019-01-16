-module(test).
-export([start/0,createConnection/0, test_conn/0, test_circuit/0]).

start() -> 
	survivor:start(),
	observer:start().
	
createConnection() -> 
	{ok,PidR} = resourceType:create(cableTyp, [{1,2,3,4,5,6,7,{8,9}}]),
	{ok, PidS} = resourceType:create(sourceTyp, [{100, 50, direct}]),
	{ok,Pid1} = resourceInst:create(cableInst, [self(), PidR]),
	{ok,Pid2} = resourceInst:create(cableInst, [self(), PidR]),
	{ok, Pid0} = resourceInst:create(sourceInst, [self(), PidS, Pid1]),
	{ok, [C1, C2]} = resourceInst:list_connectors(Pid1),
	{ok, [C3, C4]} = resourceInst:list_connectors(Pid2),
	connector:connect(C1, Pid0),
	connector:connect(C1, C2),
	connector:connect(C3, C4), 
	{C1, C2, C3, C4}.
	
test_conn() ->
    {ok, Cable_T} = resourceType:create(cableTyp, [{3, 'Copper', 'Circle', 0.2, 230, 0.016, 3.68, {2, 1000}}]),
    {ok, Cable_I} = resourceInst:create(cableInst,[self(), Cable_T]),
    {ok, Source_T} = resourceType:create(sourceTyp,[{100, 50, direct}]),
    {ok, Source_I} = resourceInst:create(sourceInst,[self(), Source_T, Cable_I]),
    {ok,[C,D]} = resourceInst:list_connectors(Cable_I),
    connector:connect(C,Source_I).
	
test_circuit() ->
	{ok, Kabel} = resourceType:create(cableTyp, [{1,2,3,4,5,6,7,{8,9}}]),
	{ok, Bron} = resourceType:create(sourceTyp, [{100, 50, direct}]),
	{ok, Gebruiker} = resourceType:create(deviceTyp, [{100, 10, 0, 230, 1000, 2, off}]),
	{ok,Kabel_1} = resourceInst:create(cableInst, [self(), Kabel]),
	{ok, Bron_1} = resourceInst:create(sourceInst, [self(), Bron, Kabel_1]),
	{ok, Gebruiker_1} = resourceType:create(deviceTyp, [self(), Gebruiker, Kabel_1]),
	{ok, [C1, C2]} = resourceInst:list_connectors(Kabel_1),
	connector:connect(C1, Bron_1),
	connector:connect(C2, Gebruiker_1).