within ClaRa.Components.Furnace.FlameRoom;
model FlameRoomWithTubeBundle_L2_Static "Model for a combustion chamber section with inner tube bundle heating surfaces"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.0                        //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright � 2013-2016, DYNCAP/DYNSTART research team.                     //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

extends ClaRa.Components.Furnace.BaseClasses.CombustionChamberBase(redeclare replaceable model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes,
        geo(flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical));

extends ClaRa.Components.Furnace.BaseClasses.CombustionChamberBase_additional_HPs(redeclare replaceable model HeatTransfer_CarrierTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_finnedTubes_L2);
extends ClaRa.Basics.Icons.FlameRoomTubeBundle;

//## P A R A M E T E R S #######################################################################################
inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));

//## V A R I A B L E   P A R T##################################################################################
//___________________/ iCom record \\__________________
protected
  inner ClaRa.Basics.Records.IComGas_L2 iCom(
    m_flow_nom=m_flow_nom,
    T_bulk=flueGasOutlet.T,
    p_bulk=inlet.flueGas.p,
    fluidPointer_in=flueGasInlet.gasPointer,
    fluidPointer_bulk=flueGasOutlet.gasPointer,
    fluidPointer_out=flueGasOutlet.gasPointer,
    mediumModel=flueGas,
    p_in=inlet.flueGas.p,
    T_in=inStream(inlet.flueGas.T_outflow),
    m_flow_in=inlet.flueGas.m_flow,
    V_flow_in=V_flow_flueGas_in,
    xi_in=inStream(inlet.flueGas.xi_outflow),
    p_out=outlet.flueGas.p,
    T_out=flueGasOutlet.T,
    m_flow_out=outlet.flueGas.m_flow,
    V_flow_out=V_flow_flueGas_out,
    xi_out=xi_flueGas) annotation (Placement(transformation(extent={{244,-102},{268,-76}})));

equation
  mass = geo.volume * (flueGasOutlet.d + flueGasInlet.d)/2;

  //____________/ Resulting Xi for entire fuel mass in the volume \______________
  xi_fuel_in = inStream(inlet.fuel.xi_outflow);

  //________________/ Mass balance - flue gas \______________________________________
  0 =m_flow_fuel_burned*(1 - xi_fuel_in[6]*reactionZone.xi_slag) + inlet.flueGas.m_flow + outlet.flueGas.m_flow;

  //______________ / Mass balance - Slag \____________________________________________________________________________
  0 =inlet.slag.m_flow + m_flow_fuel_burned*xi_fuel_in[6]*reactionZone.xi_slag + outlet.slag.m_flow;

  //______________/ Mass balance - Fuel \____________________________
  0 =outlet.fuel.m_flow + inlet.fuel.m_flow - m_flow_fuel_burned;

  //__________/ molar flow rates of combustable components (educts) into the whole burner system (maybe not all of it is burned) \________
  n_flow_C = xi_fuel_in[1]*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_C;
  n_flow_H = xi_fuel_in[2]*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_H;
  n_flow_O = xi_fuel_in[3]*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_O;
  n_flow_N = xi_fuel_in[4]*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_N;
                                                             // N not N2!!!!!!
  n_flow_S = xi_fuel_in[5]*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_S;
  n_flow_Ash = xi_fuel_in[6]*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_Ash;
  n_flow_H2O = (1-sum(xi_fuel_in))*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_H2O;

  //_______________/ determination of lambda \_________________________
  // theoretically required oxygen mass flow rate to burn all the fuel
   m_flow_oxygen_req = (1-fuel_diffusity)*(n_flow_C + n_flow_H/4.0 + n_flow_S - n_flow_O/2)*ClaRa.Basics.Constants.M_O
                                                                                            *2.0;
   m_flow_air_req*max(1e-32,flueGasInlet.xi[6]) = m_flow_oxygen_req;

    if noEvent(m_flow_oxygen_req <= 0) then
    lambdaComb = 1.0e3;
    else
    lambdaComb = (inlet.flueGas.m_flow*flueGasInlet.xi[6])/max(1e-12, m_flow_oxygen_req);
    end if;

  //calculation of actual fuel and oxygen mass flow rates that are burned
  if noEvent(lambdaComb > 1) then
    m_flow_fuel_burned = (1 - fuel_diffusity)*inlet.fuel.m_flow;
    m_flow_oxygen_burned = m_flow_oxygen_req;
  else
    m_flow_fuel_burned = lambdaComb*(1 - fuel_diffusity)*inlet.fuel.m_flow;
    m_flow_oxygen_burned = lambdaComb*m_flow_oxygen_req;
  end if;

  //_____________/ Calculation of the LHV \______________________________________

  if inlet.fuel.LHV_calculationType == "predefined" then
   LHV = inStream(inlet.fuel.LHV_outflow);
  elseif inlet.fuel.LHV_calculationType == "Verbandsformel" then
   LHV =(33907*xi_fuel_in[1] + 142324*(xi_fuel_in[2] - xi_fuel_in[3]/8.) + 10465*xi_fuel_in[5] - 2512*((1 - sum(xi_fuel_in)) + 9*xi_fuel_in[2]))*1000;
  else
   LHV = inStream(inlet.fuel.LHV_outflow);
  end if;

//   if (inlet.fuel.m_flow < 0 or inlet.fuel.m_flow > 0) or (outlet.fuel.m_flow < 0 or outlet.fuel.m_flow > 0) then
//      LHV * (max(0,inlet.fuel.m_flow) + max(0,outlet.fuel.m_flow)) = (max(0,inlet.fuel.m_flow)*inStream(inlet.fuel.LHV_outflow) +  max(0,outlet.fuel.m_flow)*inStream(outlet.fuel.LHV_outflow));
//   else
//      LHV = inStream(inlet.fuel.LHV_outflow);
//   end if;

  //______________________________/ mass balance of flue gas components \__________________________
  zeros(flueGas.nc-1) =inlet.flueGas.m_flow*flueGasInlet.xi + outlet.flueGas.m_flow*xi_flueGas + m_flow_fuel_burned*reactionZone.prod_comp;

  //_____________/ Calculation of fuel formation enthalpy with LHV for an ideal combustion\__________________
  m_flow_fuel_id = 1.0;
  m_flow_flueGas_id =(m_flow_fuel_id*(1 - xi_fuel_in[6]*reactionZone.xi_slag));           //ideal flue gas mass flow
   xi_flueGas_id =1/m_flow_flueGas_id*reactionZone.prod_comp;   //products of an ideal combustion

   sum_comp = sum(xi_flueGas_id);
  Delta_h_f - LHV =m_flow_flueGas_id*((ideal_combustion.h_i)*cat(1,xi_flueGas_id,{1 - sum(xi_flueGas_id)})) + xi_fuel_in[6]*reactionZone.xi_slag*outlet.slagType.cp*T_0; //formation enthalpy of used fuel

  //_______________/ Energy Balance flueGasCombustion \__________________________
  0 =Q_flow_wall + Q_flow_top + Q_flow_bottom + Q_flow_CarrierTubes + Q_flow_TubeBundle + inlet.flueGas.m_flow*flueGasInlet.h + inlet.fuel.m_flow*(inlet.fuelType.cp*(inStream(inlet.fuel.T_outflow) - T_0) + Delta_h_f) + outlet.fuel.m_flow*(outlet.fuelType.cp*(outlet.fuel.T_outflow - T_0) + Delta_h_f) + outlet.slag.m_flow*outlet.slagType.cp*(inStream(outlet.slag.T_outflow) - T_0) + inlet.slag.m_flow*inlet.slagType.cp*(inlet.slag.T_outflow - T_0) + outlet.flueGas.m_flow*h_flueGas_out;

  //______________/Properties for heat transfer corellation\_________

  der(V_flow_flueGas_out) = 1/Tau*(outlet.flueGas.m_flow/flueGasOutlet.d - V_flow_flueGas_out);
  V_flow_flueGas_in = inlet.flueGas.m_flow/flueGasInlet.d;

  sum_xi = sum(flueGasOutlet.xi);

  xi_fuel_out = xi_fuel_in; //no change of fuel composition during combustion

  xi_fuel = (inlet.fuel.m_flow)/(inlet.flueGas.m_flow);// amount of fuel per flue gas mass

  //___________/ T_outflows \__________________________________________
  outlet.fuel.T_outflow = flueGasOutlet.T;
  outlet.flueGas.T_outflow = flueGasOutlet.T;
  inlet.slag.T_outflow =T_slag;
  heat_bottom.T = iCom.T_out;

  //___________/ LHV_outflows \__________________________________________
  outlet.fuel.LHV_outflow =LHV;
  inlet.fuel.LHV_outflow =LHV;
  outlet.fuel.LHV_calculationType = inlet.fuel.LHV_calculationType;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,-100},
            {300,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-300,-100},{300,100}}), graphics={
        Text(
          extent={{34,90},{242,56}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "T_out="+realString(T_outlet,1,integer(0)) +"K")),
        Text(
          extent={{34,44},{242,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "lambda="+realString(min(99,lambda),1,integer(1)))),
        Text(
          extent={{34,-54},{242,-88}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "Q="+realString(-Q_combustion/1e6,1,integer(0))+"MW")),
        Text(
          extent={{32,-14},{240,-48}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "alphaA="+realString(heattransfer.effAlphaA,1,integer(0))+""))}),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><b>Model description: </b>A stationary model for furnace sections with convective tube bundles inside (additional heat ports)</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Stationary mass and energy balances are used</li>
<li>Tube bundles are regarded with replaceable geometry models</li>
<li>Additional heat transfer ports to regard heat transfer for tube banks and carrier tubes</li>
<li>The formation enthalpy of the used fuel is calculated with the given Lower heating value and and ideal combustion with the given elemental composition of the fuel</li>
<li>Lower heating can be regarded with a fixed value or calculated according to the &QUOT;Verbandsformel&QUOT;</li>
<li>Different heat transfer correlations can be chosen</li>
<li>Capable to burn unburnt fuel from lower burner sections</li>
<li>Amount of burnable fuel mass is calculated with particle diffusity which depends on models used to determine the mean migration speed according to the volume flow rates of the flue gas</li>
</ul></p>
</html>"));
end FlameRoomWithTubeBundle_L2_Static;
