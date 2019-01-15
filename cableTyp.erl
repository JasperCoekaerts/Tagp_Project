-module(cableTyp).
-export([create/1, setResistance/2, getResistance/1, setMaterial/2, getMaterial/1, setShape/2, getShape/1, setInsulationWidth/2, getInsulationWidth/1, setmaxVoltage/2, getmaxVoltage/1, setmaxAmpere/2, getmaxAmpere/1, setmaxWattage/2, getmaxWattage/1, setDimensions/2, getDimensions/1]).

-export([loop/1, init/1]).

create(State) -> {ok, spawn_link(?MODULE, init, [State])}.
init(State) -> survivor:entry(cableTyp_created), loop(State).

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
	%TODO setter: controle op geldigheid nieuwe waardes

loop(State) ->
    receive
	{initial_state, [ResInst_Pid, TypeOptions], ReplyFn} ->
	    Location = location:create(ResInst_Pid, emptySpace),
	    In = connector:create(ResInst_Pid, cable),
	    Out = connector:create(ResInst_Pid, cable),
	    ReplyFn(#{resInst => ResInst_Pid, chambers => [Location], 
	    cList => [In, Out], typeOptions => TypeOptions, state => State}),
	    loop(State);
	{connections_list, S , ReplyFn} -> 
	    #{cList := C_List} = S, ReplyFn(C_List), 
	    loop(State);
	{locations_list, State, ReplyFn} -> 
	    #{chambers := L_List} = State, ReplyFn(L_List),
	    loop(State);
	%Resistance
	{get_resistance, ReplyFn} -> 	ReplyFn(element(1, State)),			loop(State);
	{set_resistance, Resistance} ->	State2 = setelement(1, State, Resistance),	loop(State2);
	%Material
	{get_material, ReplyFn} -> 	ReplyFn(element(2, State)),			loop(State);
	{set_material, Material} ->	State2 = setelement(2, State, Material),	loop(State2);
	%Shape
	{get_shape, ReplyFn} -> 	ReplyFn(element(3, State)),			loop(State);
	{set_shape, Shape} ->		State2 = setelement(3, State, Shape),		loop(State2);
	%InsulationWidth
	{get_IW, ReplyFn} -> 		ReplyFn(element(4, State)),			loop(State);
	{set_IW, Width} ->		State2 = setelement(4, State, Width),		loop(State2);
	%Umax(V)
	{get_maxvoltage, ReplyFn} -> 	ReplyFn(element(5, State)),			loop(State);
	{set_maxvoltage, Vm} ->		State2 = setelement(5, State, Vm),		loop(State2);
	%Imax(A)
	{get_maxampere, ReplyFn} -> 	ReplyFn(element(6, State)),			loop(State);
	{set_maxampere, Am} ->		State2 = setelement(6, State, Am),		loop(State2);
	%Pmax(W)
	{get_maxwattage, ReplyFn} -> 	ReplyFn(element(7, State)),			loop(State);
	{set_maxwattage, Wm} ->		State2 = setelement(7, State, Wm),		loop(State2);
	%{SectionArea(mm^2), Length(mm)}	
	{get_dimensions, ReplyFn} -> 	ReplyFn(element(7, State)),			loop(State);
	{set_dimensions, AreaLength} ->	State2 = setelement(7, State, AreaLength),	loop(State2)
    end. 
    
%Resistance
setResistance(Cable_Pid, Resistance) ->  Cable_Pid ! {set_resistance, Resistance}.
getResistance(Cable_Pid) -> msg:get(Cable_Pid, get_resistance).
	
%Material
setMaterial(Cable_Pid, Material) ->  Cable_Pid ! {set_material, Material}.
getMaterial(Cable_Pid) -> msg:get(Cable_Pid, get_material).
	
%Shape
setShape(Cable_Pid, Shape) ->  Cable_Pid ! {set_shape, Shape}.
getShape(Cable_Pid) -> msg:get(Cable_Pid, get_shape).
	
%InsulationWidth
setInsulationWidth(Cable_Pid, Width) ->  Cable_Pid ! {set_IW, Width}.
getInsulationWidth(Cable_Pid) -> msg:get(Cable_Pid, get_IW).
	
%Umax(V)
setmaxVoltage(Cable_Pid, Vm) ->  Cable_Pid ! {set_maxvoltage, Vm}.
getmaxVoltage(Cable_Pid) -> msg:get(Cable_Pid, get_maxvoltage).

%Imax(A)
setmaxAmpere(Cable_Pid, Am) ->  Cable_Pid ! {set_maxampere, Am}.
getmaxAmpere(Cable_Pid) -> msg:get(Cable_Pid, get_maxampere).

%Pmax(W)
setmaxWattage(Cable_Pid, Wm) ->  Cable_Pid ! {set_maxwattage, Wm}.
getmaxWattage(Cable_Pid) -> msg:get(Cable_Pid, get_maxwattage).

%{SectionArea(mm^2), Length(mm)}	
setDimensions(Cable_Pid, AreaLength) ->  Cable_Pid ! {set_dimensions, AreaLength}.
getDimensions(Cable_Pid) -> msg:get(Cable_Pid, get_dimensions).