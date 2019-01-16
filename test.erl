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
	{ok,Schakelaar} = resourceType:create(switchTyp, [{on_off, 100}]),
	{ok,Kabel_1} = resourceInst:create(cableInst, [self(), Kabel]),
	{ok,Kabel_2} = resourceInst:create(cableInst, [self(), Kabel]),
	{ok, Bron_1} = resourceInst:create(sourceInst, [self(), Bron, Kabel_1]),
	{ok,Schakelaar_1} = resourceInst:create(switchInst, [self(), Schakelaar]),
	{ok, Gebruiker_1} = resourceType:create(deviceInst, [self(), Gebruiker, Kabel_2]),
	{ok, [C1, C2]} = resourceInst:list_connectors(Kabel_1),
	{ok, [C3, C4]} = resourceInst:list_connectors(Kabel_2),
	{ok, [C5, C6]} = resourceInst:list_connectors(Schakelaar_1),
	{ok, [C7]} = resourceInst:list_connectors(Bron_1),
	{ok, [C8, C9]} = resourceInst:list_connectors(Gebruiker_1),
	connector:connect(C7, C1),
	connector:connect(C7, C5),
	Conn_list = connector:get_connected(C7),
	survivor:entry({connection_Kabel, Conn_list}),
	connector:connect(C6, C3),
	survivor:entry({connection_Schakelaar, connector:get_connected(C6)}),
	connector:connect(C4, C8),
	survivor:entry({connection_Gebruiker, connector:get_connected(C4)}).
	
test_room() -> 
	{ok, Kabel} = resourceType:create(cableTyp, [{0,'Copper','Circle',0.2,230,0.016,3.68,{0.5,1000}}]),
	{ok, Bron} = resourceType:create(sourceTyp, [{100, 50, direct}]),
	{ok, Gebruiker} = resourceType:create(deviceTyp, [{100, 10, 0, 230, 1000, 2, off}]),
	{ok, Schakelaar} = resourceType:create(switchTyp, [{on_off, 100}]),

	