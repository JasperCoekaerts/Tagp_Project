-module(cableTyp).
-export([create/1]).

-export([loop/1, init/1]).

-export([create_test/0,init_test/1, setResistance/2, getResistance/1]).

create(State) -> {ok, spawn_link(?MODULE, init, [State])}.
init(State) -> survivor:entry(cableTyp_created), loop(State).


create_test() -> {ok, spawn_link(?MODULE, init_test, [{3, 'Copper', 'Circle', 0.2, 230, 0.016, 3.68, {2, 1000}}])}.
init_test(State) -> survivor:entry(test_cableTyp_created), 
		    loop(State).
% Things that define a cable(TypeOptions):
	% Resistance in ohms
	% material: Cu, Al, Sn, Au, Ag
	% shape of section: Circle, rectangle, oval
	% Width of insulation
	% Umax, Imax, Pmax
	% In, out
	% dimensions
		% surface area of section mm^2
		% length in mm
		
	%State = {Resistance(ohms), Material, CrossSectionShape, InsulationWidth(mm), Umax(V), Imax(A), Pmax(W), {SectionArea(mm^2), Length(mm)}}}

loop(State) ->
    receive
	{initial_state, [ResInst_Pid, TypeOptions], ReplyFn} ->
	    Location = location:create(ResInst_Pid, emptySpace),
	    In = connector:create(ResInst_Pid, cable),
	    Out = connector:create(ResInst_Pid, cable),
	    ReplyFn(#{resInst => ResInst_Pid, chambers => [Location], 
	    cList => [In, Out], typeOptions => TypeOptions}),
	    loop(State);
	{connections_list, State , ReplyFn} -> 
	    #{cList := C_List} = State, ReplyFn(C_List), 
	    loop(State);
	{locations_list, State, ReplyFn} -> 
	    #{chambers := L_List} = State, ReplyFn(L_List),
	    loop(State);
	{get_resistance, ReplyFn} -> 
		ReplyFn(element(1, State)),
		loop(State);
	{set_resistance, Resistance} ->
	    State2 = setelement(1, State, Resistance),
	    loop(State2)
    end. 
    
setResistance(Cable_Pid, Resistance) ->  Cable_Pid ! {set_resistance, Resistance}.
getResistance(Cable_Pid) ->
	msg:get(Cable_Pid, get_resistance).
	
	