-module(cableTyp).
-export([create/0]).

-export([loop/0, init/0]).

create() -> spawn_link(?MODULE, init, []).
init() -> survivor:entry(cableTyp_created), loop().

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
		
	%TypeOptions = {Resistance, Material, CrossSectionShape, InsulationWidth, Umax, Imax, Pmax, {SectionArea, Length}}}

loop() ->
    receive
	{initial_state, [ResInst_Pid, TypeOptions], ReplyFn} ->
	    Location = location:create(ResInst_Pid, emptySpace),
	    In = connector:create(ResInst_Pid, cable),
	    Out = connector:create(ResInst_Pid, cable),
	    ReplyFn(#{resInst => ResInst_Pid, chambers => [Location], 
	    cList => [In, Out], typeOptions => TypeOptions}),
	    loop();
	{connections_list, State , ReplyFn} -> 
	    #{cList := C_List} = State, ReplyFn(C_List), 
	    loop();
	{locations_list, State, ReplyFn} -> 
	    #{chambers := L_List} = State, ReplyFn(L_List),
	    loop()
    end. 



		