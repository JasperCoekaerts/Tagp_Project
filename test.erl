-module(test).
-export([start/0,createConnection/0, test_conn/0, test_circuit/0, test_room/0, useage/1]).

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
	{ok, Gebruiker_1} = resourceInst:create(deviceInst, [self(), Gebruiker, Kabel_2]),
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
	
test_room() -> %keuken 5x5m
	%instances
	{ok, Kabel_frigo} = 	resourceType:create(cableTyp, [{0,'Copper','Circle',0.2,230,0.016,3.68,{0.5,3000}}]),
	{ok, Kabel_microgolf} = resourceType:create(cableTyp, [{0,'Copper','Circle',0.2,230,0.016,3.68,{0.5,3000}}]),
	{ok, Kabel_oven} = 	resourceType:create(cableTyp, [{0,'Copper','Circle',0.2,230,0.016,3.68,{0.5,3000}}]),
	{ok, Kabel_vuur} = 	resourceType:create(cableTyp, [{0,'Copper','Circle',0.2,230,0.016,3.68,{0.5,3000}}]),
	{ok, Kabel_dampkap} = 	resourceType:create(cableTyp, [{0,'Copper','Circle',0.2,230,0.016,3.68,{0.5,5000}}]),
	{ok, Kabel_verwarming} =resourceType:create(cableTyp, [{0,'Copper','Circle',0.2,230,0.016,3.68,{0.5,6500}}]),
	{ok, Kabel_lamp1} = 	resourceType:create(cableTyp, [{0,'Copper','Circle',0.2,230,0.016,3.68,{0.5,4500}}]),
	{ok, Kabel_lamp2} = 	resourceType:create(cableTyp, [{0,'Copper','Circle',0.2,230,0.016,3.68,{0.5,7500}}]),
	{ok, Kabel_lamp3} = 	resourceType:create(cableTyp, [{0,'Copper','Circle',0.2,230,0.016,3.68,{0.5,8000}}]),
	{ok, Kabel_lamp4} = 	resourceType:create(cableTyp, [{0,'Copper','Circle',0.2,230,0.016,3.68,{0.5,11000}}]),
	
	{ok, Bron_T} = 		resourceType:create(sourceTyp, [{50, 230, direct}]),
	{ok, Lamp_T} = 		resourceType:create(deviceTyp, [{60, 0, 0, 230, 16, 2, off}]),
	{ok, Schakelaar_T} = 	resourceType:create(switchTyp, [{on_off, 0}]),
	{ok, Frigo_T} = 	resourceType:create(deviceTyp, [{1000,200,0,230,0.8,1,on}]), %geen flauw idee wat voor waarden geschikt zijn voor R L en C
	{ok, Microgolf_T} = 	resourceType:create(deviceTyp,[{1000,200,0,230,700,1,off}]), %geen flauw idee wat voor waarden geschikt zijn voor R L en C
	{ok, Oven_T} = 		resourceType:create(deviceTyp,[{1000,200,0,230,2500,1,on}]), %geen flauw idee wat voor waarden geschikt zijn voor R L en C
	{ok, Vuur_T} = 		resourceType:create(deviceTyp,[{1000,200,0,230,6000,1,on}]), %geen flauw idee wat voor waarden geschikt zijn voor R L en C
	{ok, Dampkap_T} = 	resourceType:create(deviceTyp,[{1000,200,0,230,205,1,on}]), %geen flauw idee wat voor waarden geschikt zijn voor R L en C
	{ok, Verwarming_T} = 	resourceType:create(deviceTyp,[{1000,200,0,230,1000,1,on}]), %geen flauw idee wat voor waarden geschikt zijn voor R L en C
	
	{ok, Kabel_f} = 	resourceInst:create(cableInst, [self(), Kabel_frigo]),
	{ok, Kabel_m} = 	resourceInst:create(cableInst, [self(), Kabel_microgolf]),
	{ok, Kabel_o} = 	resourceInst:create(cableInst, [self(), Kabel_oven]),
	{ok, Kabel_vu} = 	resourceInst:create(cableInst, [self(), Kabel_vuur]),
	{ok, Kabel_d} = 	resourceInst:create(cableInst, [self(), Kabel_dampkap]),
	{ok, Kabel_ve} = 	resourceInst:create(cableInst, [self(), Kabel_verwarming]),
	{ok, Kabel_l1} = 	resourceInst:create(cableInst, [self(), Kabel_lamp1]),
	{ok, Kabel_l2} = 	resourceInst:create(cableInst, [self(), Kabel_lamp2]),
	{ok, Kabel_l3} = 	resourceInst:create(cableInst, [self(), Kabel_lamp3]),
	{ok, Kabel_l4} = 	resourceInst:create(cableInst, [self(), Kabel_lamp4]),
	
	%instances
	{ok, Frigo_I} = 	resourceInst:create(deviceInst, [self(), Frigo_T, Kabel_frigo]),
	{ok, Microgolf_I} = 	resourceInst:create(deviceInst, [self(), Microgolf_T, Kabel_microgolf]),
	{ok, Oven_I} = 		resourceInst:create(deviceInst, [self(), Oven_T, Kabel_oven]),
	{ok, Vuur_I} = 		resourceInst:create(deviceInst, [self(), Vuur_T, Kabel_vuur]),
	{ok, Dampkap_I} = 	resourceInst:create(deviceInst, [self(), Dampkap_T, Kabel_dampkap]),
	{ok, Verwarming_I} = 	resourceInst:create(deviceInst, [self(), Verwarming_T, Kabel_verwarming]),
	{ok, Lamp_I1} = 	resourceInst:create(deviceInst, [self(), Lamp_T, Kabel_l1]),
	{ok, Lamp_I2} = 	resourceInst:create(deviceInst, [self(), Lamp_T, Kabel_l2]),
	{ok, Lamp_I3} = 	resourceInst:create(deviceInst, [self(), Lamp_T, Kabel_l3]),
	{ok, Lamp_I4} = 	resourceInst:create(deviceInst, [self(), Lamp_T, Kabel_l4]),
	{ok, Bron_I} = 		resourceInst:create(sourceInst, [self(), Bron_T, Kabel_f]),
	{ok, Schakelaar_I12} = 	resourceInst:create(switchInst, [self(), Schakelaar_T]),
	{ok, Schakelaar_I34} = 	resourceInst:create(switchInst, [self(), Schakelaar_T]),
	
	{ok, [Bron_Co]} = resourceInst:list_connectors(Bron_I),
	{ok, [Schakelaar_I12_Ci, Schakelaar_I12_Co]} = resourceInst:list_connectors(Schakelaar_I12),
	{ok, [Schakelaar_I34_Ci, Schakelaar_I34_Co]} = resourceInst:list_connectors(Schakelaar_I34),
	{ok, [Kabel_f_Ci, Kabel_f_Co]} = resourceInst:list_connectors(Kabel_f),
	{ok, [Kabel_m_Ci, Kabel_m_Co]} = resourceInst:list_connectors(Kabel_m),
	{ok, [Kabel_o_Ci, Kabel_o_Co]} = resourceInst:list_connectors(Kabel_o),
	{ok, [Kabel_vu_Ci, Kabel_vu_Co]} = resourceInst:list_connectors(Kabel_vu),
	{ok, [Kabel_d_Ci, Kabel_d_Co]} = resourceInst:list_connectors(Kabel_d),
	{ok, [Kabel_ve_Ci, Kabel_ve_Co]} = resourceInst:list_connectors(Kabel_ve),
	{ok, [Kabel_l1_Ci, Kabel_l1_Co]} = resourceInst:list_connectors(Kabel_l1),
	{ok, [Kabel_l2_Ci, Kabel_l2_Co]} = resourceInst:list_connectors(Kabel_l2),
	{ok, [Kabel_l3_Ci, Kabel_l3_Co]} = resourceInst:list_connectors(Kabel_l3),
	{ok, [Kabel_l4_Ci, Kabel_l4_Co]} = resourceInst:list_connectors(Kabel_l4),
	{ok, [Lamp_I1_Ci, Lamp_I1_Co]} = resourceInst:list_connectors(Lamp_I1),
	{ok, [Lamp_I2_Ci, Lamp_I2_Co]} = resourceInst:list_connectors(Lamp_I2),
	{ok, [Lamp_I3_Ci, Lamp_I3_Co]} = resourceInst:list_connectors(Lamp_I3),
	{ok, [Lamp_I4_Ci, Lamp_I4_Co]} = resourceInst:list_connectors(Lamp_I4),
	{ok, [Lamp_I4_Ci, Lamp_I4_Co]} = resourceInst:list_connectors(Lamp_I4),
	{ok, [Frigo_I_Ci, Frigo_I_Co]} = resourceInst:list_connectors(Frigo_I),
	{ok, [Microgolf_I_Ci, Microgolf_I_Co]} = resourceInst:list_connectors(Microgolf_I),
	{ok, [Oven_I_Ci, Oven_I_Co]} = resourceInst:list_connectors(Oven_I),
	{ok, [Vuur_I_Ci, Vuur_I_Co]} = resourceInst:list_connectors(Vuur_I),
	{ok, [Dampkap_I_Ci, Dampkap_I_Co]} = resourceInst:list_connectors(Dampkap_I),
	{ok, [Verwarming_I_Ci, Verwarming_I_Co]} = resourceInst:list_connectors(Verwarming_I),
	
	%connect all that will be connected to the source
	connector:connect(Bron_Co,Schakelaar_I12_Ci),
	connector:connect(Bron_Co,Schakelaar_I34_Ci),
	connector:connect(Bron_Co, Kabel_f_Ci),
	connector:connect(Bron_Co, Kabel_m_Ci),
	connector:connect(Bron_Co, Kabel_o_Ci),
	connector:connect(Bron_Co, Kabel_vu_Ci),
	connector:connect(Bron_Co, Kabel_d_Ci),
	connector:connect(Bron_Co, Kabel_ve_Ci),
	
	%connect the next element in the line
	connector:connect(Schakelaar_I12_Co, Kabel_l1_Ci),
	connector:connect(Schakelaar_I34_Co, Kabel_l3_Ci),
	connector:connect(Kabel_f_Co, Frigo_I_Ci),
	connector:connect(Kabel_m_Co, Microgolf_I_Ci),
	connector:connect(Kabel_o_Co, Oven_I_Ci),
	connector:connect(Kabel_vu_Co, Vuur_I_Ci),
	connector:connect(Kabel_d_Co, Dampkap_I_Ci),
	connector:connect(Kabel_ve_Co, Verwarming_I_Ci),
	
	%rest van de lampen aangezien deze serieel geschakelt zijn
	connector:connect(Kabel_l1_Co, Lamp_I1_Ci),
	connector:connect(Kabel_l3_Co, Lamp_I3_Ci),
	
	connector:connect(Lamp_I1_Co, Kabel_l2_Ci),
	connector:connect(Lamp_I3_Co, Kabel_l4_Ci),
	
	connector:connect(Kabel_l2_Co, Lamp_I2_Ci),
	connector:connect(Kabel_l4_Co, Lamp_I4_Ci).
	
useage(SourceInst_Pid) ->

	{ok, [Head|Tail]} = connector:get_connected(SourceInst_Pid), %Bepaald alle draden aan de bron
	{ok, CableInst_Pid} = connector:get_ResInst(Head), % Bekijkt de eerste kabel
	{ok, [C1|C2]} = resourceInst:list_connectors(CableInst_Pid), % Toont alle connecties van de kabel -> werkt niet
	{ok, DeviceC} = connector:get_connected(C2),% Toont de verbinding met een gebruiker
	{ok, DeviceInst} = connector:get_ResInst(DeviceC), %Bepaald welke Gebruiker het is
	{ok, State} = resourceInst:getState(DeviceInst).
	
	
	
	
	
	