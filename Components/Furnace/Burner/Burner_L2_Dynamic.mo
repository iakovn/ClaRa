within ClaRa.Components.Furnace.Burner;
model Burner_L2_Dynamic "Model for a burner section inside a combustion chamber"
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

extends ClaRa.Components.Furnace.BaseClasses.CombustionChamberBase_Advanced(
        geo(flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical));
                                                                                //(flueGasCombustion(p = outlet.flueGas.p, xi = xi_flueGas));
extends ClaRa.Basics.Icons.Burner;
//import ClaRa.Basics.Functions.Stepsmoother;

//## P A R A M E T E R S #######################################################################################
inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));

//## V A R I A B L E   P A R T##################################################################################
public
 Real lambdaComb_primary "Primary lambda";
 ClaRa.Basics.Units.MassFlowRate m_flow_oxygen_req_primary "Required oxygen mass flwo for primary lambda calculation";
 ClaRa.Basics.Units.MassFlowRate m_flow_air_req_primary "Required air mass flwo for primary lambda calculation";

protected
  Modelica.SIunits.MolarFlowRate  n_flow_C_primary "Primary molar flow of C";
  Modelica.SIunits.MolarFlowRate  n_flow_H_primary "Primary molar flow of H";
  Modelica.SIunits.MolarFlowRate  n_flow_O_primary "Primary molar flow of O";
  Modelica.SIunits.MolarFlowRate  n_flow_S_primary "Primary molar flow of S";

  Real drhodt "Density derivative";

  ClaRa.Basics.Units.MassFraction xi_flueGasMix[flueGas.nc - 1] "Flue gas mixture composition";
  ClaRa.Basics.Units.MassFraction xi_flueGasMix_del[flueGas.nc - 1] "Pseudo state for flue gas mixture composition";

  ClaRa.Basics.Units.EnthalpyMassSpecific h_flueGasMix "Specific enthalpy of flue gas mixture";
  ClaRa.Basics.Units.EnthalpyMassSpecific h_flueGasMix_del "Pseudo state for specific enthalpy of flue gas mixture";

  ClaRa.Basics.Units.MassFlowRate m_flow_in_del "Pseudo state for inlet mass flow";
  ClaRa.Basics.Units.MassFlowRate m_flow_out_del "Pseudo state for outlet mass flow";

//_____________________/ Connectors \______________________________
public
  ClaRa.Basics.Interfaces.FuelFlueGas_inlet fuelFlueGas_inlet(flueGas(Medium=flueGas), final fuelType=fuelType) annotation (Placement(transformation(extent={{-310,-10},{-290,10}}), iconTransformation(extent={{-310,-10},{-290,10}})));

//_____________________/ Media Objects \_________________________________
protected
     TILMedia.Gas_pT    primaryAir_inlet(p=fuelFlueGas_inlet.flueGas.p, T=actualStream(fuelFlueGas_inlet.flueGas.T_outflow), xi=actualStream(
        fuelFlueGas_inlet.flueGas.xi_outflow),
     gasType=flueGas)
     annotation (Placement(transformation(extent={{-290,-10},{-270,10}})));

  TILMedia.Gas_ph inlet_GasMix(p=inlet.flueGas.p,xi=xi_flueGasMix_del,gasType=flueGas,h(start = 1.0E4)=h_flueGasMix_del)
     annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));

//___________________/ iCom record \\__________________
protected
  inner ClaRa.Basics.Records.IComGas_L2 iCom(
    m_flow_nom=m_flow_nom,
    T_bulk=bulk.T,
    p_bulk=bulk.p,
    fluidPointer_in=inlet_GasMix.gasPointer,
    fluidPointer_bulk=bulk.gasPointer,
    fluidPointer_out=flueGasOutlet.gasPointer,
    mediumModel=flueGas,
    p_in=inlet.flueGas.p,
    T_in=inlet_GasMix.T,
    m_flow_in=m_flow_in_del,
    V_flow_in=V_flow_flueGas_in,
    xi_in=xi_flueGasMix_del,
    p_out=outlet.flueGas.p,
    T_out=bulk.T,
    m_flow_out=m_flow_out_del,
    V_flow_out=V_flow_flueGas_out,
    xi_out=xi_flueGas_del) annotation (Placement(transformation(extent={{244,-102},{268,-76}})));

initial equation

  h_flueGas_out = h_start;
  xi_flueGas = xi_start_flueGas_out;

equation
  mass = geo.volume * (bulk.d + inlet_GasMix.d)/2;

  //____________/ Resulting Xi for entire fuel mass in the volume \______________
  if (inlet.fuel.m_flow + fuelFlueGas_inlet.fuel.m_flow <= 0.0) then
     xi_fuel_in = inStream(inlet.fuel.xi_outflow);
   else
  (inlet.fuel.m_flow + fuelFlueGas_inlet.fuel.m_flow) * xi_fuel_in = inStream(fuelFlueGas_inlet.fuel.xi_outflow)* fuelFlueGas_inlet.fuel.m_flow + inStream(inlet.fuel.xi_outflow)                                                                                                    * inlet.fuel.m_flow;
  end if;
  //__________________________/ Resulting Xi for flue gas mix \____________________________
  inlet.flueGas.m_flow * flueGasInlet.xi +  fuelFlueGas_inlet.flueGas.m_flow * primaryAir_inlet.xi - (inlet.flueGas.m_flow+fuelFlueGas_inlet.flueGas.m_flow)*xi_flueGasMix = zeros(flueGas.nc-1);
  xi_flueGasMix_del = xi_flueGasMix;

  //________________/ Mass balance - flue gas \______________________________________
  drhodt*geo.volume =m_flow_fuel_burned*(1 - xi_fuel_in[6]*reactionZone.xi_slag) + inlet.flueGas.m_flow + fuelFlueGas_inlet.flueGas.m_flow + outlet.flueGas.m_flow;
  drhodt = bulk.drhodh_pxi * der(bulk.h) + sum({bulk.drhodxi_ph[i] * der(bulk.xi[i]) for i in 1:flueGas.nc-1});

  //______________ / Mass balance - Slag \____________________________________________________________________________
  0 =inlet.slag.m_flow + m_flow_fuel_burned*xi_fuel_in[6]*reactionZone.xi_slag + outlet.slag.m_flow;

  //______________/ Mass balance - Fuel \____________________________
  0 =outlet.fuel.m_flow + inlet.fuel.m_flow + fuelFlueGas_inlet.fuel.m_flow - m_flow_fuel_burned;

  //__________/ molar flow rates of combustable components (educts) into the whole burner system (maybe not all of it is burned) \________
  n_flow_C = xi_fuel_in[1]*(fuelFlueGas_inlet.fuel.m_flow + inlet.fuel.m_flow) /Basics.Constants.M_C;
  n_flow_H = xi_fuel_in[2]*(fuelFlueGas_inlet.fuel.m_flow + inlet.fuel.m_flow) /Basics.Constants.M_H;
  n_flow_O = xi_fuel_in[3]*(fuelFlueGas_inlet.fuel.m_flow + inlet.fuel.m_flow) /Basics.Constants.M_O;
  n_flow_N = xi_fuel_in[4]*(fuelFlueGas_inlet.fuel.m_flow + inlet.fuel.m_flow) /Basics.Constants.M_N;
  n_flow_S = xi_fuel_in[5]*(fuelFlueGas_inlet.fuel.m_flow + inlet.fuel.m_flow) /Basics.Constants.M_S;
  n_flow_Ash = xi_fuel_in[6]*(fuelFlueGas_inlet.fuel.m_flow + inlet.fuel.m_flow) /Basics.Constants.M_Ash;
  n_flow_H2O = (1-sum(xi_fuel_in))*(fuelFlueGas_inlet.fuel.m_flow + inlet.fuel.m_flow) /Basics.Constants.M_H2O;

  //_______________/ determination of lambda at burner\_________________________
  n_flow_C_primary =inStream(fuelFlueGas_inlet.fuel.xi_outflow[1])*fuelFlueGas_inlet.fuel.m_flow
    /Basics.Constants.M_C;
  n_flow_H_primary =inStream(fuelFlueGas_inlet.fuel.xi_outflow[2])*fuelFlueGas_inlet.fuel.m_flow
    /Basics.Constants.M_H;
  n_flow_O_primary =inStream(fuelFlueGas_inlet.fuel.xi_outflow[3])*fuelFlueGas_inlet.fuel.m_flow
    /Basics.Constants.M_O;
  n_flow_S_primary =inStream(fuelFlueGas_inlet.fuel.xi_outflow[5])*fuelFlueGas_inlet.fuel.m_flow
    /Basics.Constants.M_S;

  m_flow_oxygen_req_primary = (n_flow_C_primary + n_flow_H_primary/4.0 + n_flow_S_primary - n_flow_O_primary/2)*Basics.Constants.M_O
                                                                                            *2.0;
  m_flow_air_req_primary*max(1e-32,primaryAir_inlet.xi[6]) = m_flow_oxygen_req_primary;

    if noEvent(m_flow_oxygen_req_primary <= 0) then
        lambdaComb_primary  = 1.0e3;
    else
      lambdaComb_primary = (fuelFlueGas_inlet.flueGas.m_flow*primaryAir_inlet.xi[6]) /(max(1e-12,m_flow_oxygen_req_primary));
    end if;

  //_______________/ determination of lambda (overall volume, regarding unburnt fuel and oxygen)\_________________________
  // theoretically required oxygen mass flow rate to burn all the fuel
   m_flow_oxygen_req = (1-fuel_diffusity)*(n_flow_C + n_flow_H/4.0 + n_flow_S - n_flow_O/2)*Basics.Constants.M_O
                                                                                            *2.0;
   m_flow_air_req*max(1e-32,primaryAir_inlet.xi[6]) = m_flow_oxygen_req;

      if noEvent(m_flow_oxygen_req <= 0) then
    lambdaComb = 1.0e3;
        else
    lambdaComb = (fuelFlueGas_inlet.flueGas.m_flow*primaryAir_inlet.xi[6] + inlet.flueGas.m_flow*inStream(inlet.flueGas.xi_outflow[6]))/(max(1e-12, m_flow_oxygen_req));
      end if;

  //calculation of actual fuel and oxygen mass flow rates that are burned
  if noEvent(lambdaComb > 1) then
    m_flow_fuel_burned = min(1, (1 - fuel_diffusity))*(inlet.fuel.m_flow + fuelFlueGas_inlet.fuel.m_flow);
    m_flow_oxygen_burned = m_flow_oxygen_req;
   else
    m_flow_fuel_burned = lambdaComb*min(1, (1 - fuel_diffusity))*(inlet.fuel.m_flow + fuelFlueGas_inlet.fuel.m_flow);
    m_flow_oxygen_burned = lambdaComb*m_flow_oxygen_req;
   end if;

  //_____________/ Calculation of the mixed LHV \______________________________________
//
   if fuelFlueGas_inlet.fuel.LHV_calculationType == "predefined" and inlet.fuel.LHV_calculationType == "predefined" then
     LHV = (inlet.fuel.m_flow*inStream(inlet.fuel.LHV_outflow) + fuelFlueGas_inlet.fuel.m_flow*inStream(fuelFlueGas_inlet.fuel.LHV_outflow))/(fuelFlueGas_inlet.fuel.m_flow + inlet.fuel.m_flow);
   elseif fuelFlueGas_inlet.fuel.LHV_calculationType == "Verbandsformel" and inlet.fuel.LHV_calculationType == "Verbandsformel" then
     LHV =(33907*xi_fuel_in[1] + 142324*(xi_fuel_in[2] - xi_fuel_in[3]/8.) + 10465*xi_fuel_in[5] - 2512*((1 - sum(xi_fuel_in)) + 9*xi_fuel_in[2]))*1000;
    else
     LHV = inStream(inlet.fuel.LHV_outflow);
   end if;

//   if (inlet.fuel.m_flow < 0 or inlet.fuel.m_flow > 0) or (outlet.fuel.m_flow < 0 or outlet.fuel.m_flow > 0) or (fuelFlueGas_inlet.fuel.m_flow < 0 or fuelFlueGas_inlet.fuel.m_flow > 0) then
//      LHV * (max(0,fuelFlueGas_inlet.fuel.m_flow) + max(0,inlet.fuel.m_flow) + max(0,outlet.fuel.m_flow)) = (max(0,fuelFlueGas_inlet.fuel.m_flow)*inStream(fuelFlueGas_inlet.fuel.LHV_outflow) + max(0,inlet.fuel.m_flow)*inStream(inlet.fuel.LHV_outflow) +  max(0,outlet.fuel.m_flow)*inStream(outlet.fuel.LHV_outflow));
//   else
//      LHV = inStream(inlet.fuel.LHV_outflow);
//   end if;
  //______________________________/ mass balance of flue gas components \__________________________
  der(xi_flueGas) =1/mass*(inlet.flueGas.m_flow*(flueGasInlet.xi - xi_flueGas) + fuelFlueGas_inlet.flueGas.m_flow*(primaryAir_inlet.xi - xi_flueGas) + outlet.flueGas.m_flow*(flueGasOutlet.xi - xi_flueGas) + m_flow_fuel_burned*(reactionZone.prod_comp - xi_flueGas));

  //_____________/ Calculation of fuel formation enthalpy with LHV for an ideal combustion\__________________
  m_flow_fuel_id = 1.0;
  m_flow_flueGas_id =(m_flow_fuel_id*(1 - xi_fuel_in[6]*reactionZone.xi_slag));           //ideal flue gas mass flow
   xi_flueGas_id =1/m_flow_flueGas_id*reactionZone.prod_comp;   //products of an ideal combustion

   sum_comp = sum(xi_flueGas_id);
  Delta_h_f - LHV =m_flow_flueGas_id*((ideal_combustion.h_i)*cat(1,xi_flueGas_id,{1 - sum(xi_flueGas_id)})) + xi_fuel_in[6]*reactionZone.xi_slag*outlet.slagType.cp*T_0;//formation enthalpy of used fuel

  //_______________/ Energy Balance flueGasCombustion \__________________________
  der(h_flueGas_out) =(Q_flow_wall + Q_flow_top + Q_flow_bottom + inlet.flueGas.m_flow*(flueGasInlet.h - h_flueGas_out) + fuelFlueGas_inlet.flueGas.m_flow*(primaryAir_inlet.h - h_flueGas_out) + inlet.fuel.m_flow*((inlet.fuelType.cp*(inStream(inlet.fuel.T_outflow) - T_0) + Delta_h_f) - h_flueGas_out) + fuelFlueGas_inlet.fuel.m_flow*((fuelFlueGas_inlet.fuelType.cp*(inStream(fuelFlueGas_inlet.fuel.T_outflow) - T_0) + Delta_h_f) - h_flueGas_out) + outlet.fuel.m_flow*((outlet.fuelType.cp*(outlet.fuel.T_outflow - T_0) + Delta_h_f) - h_flueGas_out) + outlet.slag.m_flow*(outlet.slagType.cp*(inStream(outlet.slag.T_outflow) - T_0) - h_flueGas_out) + inlet.slag.m_flow*(inlet.slagType.cp*(inlet.slag.T_outflow - T_0) - h_flueGas_out) + outlet.flueGas.m_flow*(flueGasOutlet.h - h_flueGas_out))/mass;

  sum_xi = sum(flueGasOutlet.xi);

  //______________/Calculation of Properties for heat transfer corellation (small energy balance for inlet flue gas streams) \_________

  V_flow_flueGas_out = outlet.flueGas.m_flow/flueGasOutlet.d;
  V_flow_flueGas_in = (inlet.flueGas.m_flow + fuelFlueGas_inlet.flueGas.m_flow)/inlet_GasMix.d;

  h_flueGasMix = (fuelFlueGas_inlet.flueGas.m_flow * primaryAir_inlet.h + inlet.flueGas.m_flow * flueGasInlet.h)/(inlet.flueGas.m_flow+fuelFlueGas_inlet.flueGas.m_flow);
  h_flueGasMix_del =h_flueGasMix;

  m_flow_in_del = inlet.flueGas.m_flow + fuelFlueGas_inlet.fuel.m_flow;
  m_flow_out_del = outlet.flueGas.m_flow;

  xi_fuel_out = xi_fuel_in; //no change of fuel composition during combustion

  xi_fuel = (inlet.fuel.m_flow + fuelFlueGas_inlet.fuel.m_flow)/(inlet.flueGas.m_flow + fuelFlueGas_inlet.flueGas.m_flow);// amount of fuel per flue gas mass

  //___________/ T_outflows \__________________________________________
  outlet.fuel.T_outflow = bulk.T;
  outlet.flueGas.T_outflow = bulk.T;
  fuelFlueGas_inlet.fuel.T_outflow = bulk.T;
  fuelFlueGas_inlet.flueGas.T_outflow = bulk.T;
  inlet.fuel.T_outflow = bulk.T;
  outlet.slag.T_outflow = inStream(outlet.slag.T_outflow); //outlet.slag is inflowing slag
  inlet.flueGas.T_outflow  = bulk.T;

  inlet.slag.T_outflow =T_slag;           //inlet.slag is outflowing slag
  heat_bottom.T = bulk.T;

    //___________/ LHV_outflows \__________________________________________
  outlet.fuel.LHV_outflow =LHV;
  inlet.fuel.LHV_outflow =LHV;
  fuelFlueGas_inlet.fuel.LHV_outflow =LHV;
    if (fuelFlueGas_inlet.fuel.LHV_calculationType == "predefined") and (inlet.fuel.LHV_calculationType == "predefined") then
    outlet.fuel.LHV_calculationType = "predefined";
  elseif (fuelFlueGas_inlet.fuel.LHV_calculationType == "Verbandsformel") and (inlet.fuel.LHV_calculationType == "Verbandsformel") then
    outlet.fuel.LHV_calculationType = "Verbandsformel";
  else
    outlet.fuel.LHV_calculationType = "predefined";
  assert(fuelFlueGas_inlet.fuel.LHV_calculationType == "predefined" and inlet.fuel.LHV_calculationType == "predefined" or fuelFlueGas_inlet.fuel.LHV_calculationType == "Verbandsformel" and inlet.fuel.LHV_calculationType == "Verbandsformel", "Please check your LHV calculation settings inside boundaries. Mixed LHV_calculationTypes are not supported inside one fuel stream");
  end if;

  //_____________/ Pressures \______________________________________________
  fuelFlueGas_inlet.fuel.p = outlet.flueGas.p;
  fuelFlueGas_inlet.flueGas.p = outlet.flueGas.p;

 //____________/ values for inlet_outflows \_____________
  fuelFlueGas_inlet.fuel.xi_outflow = xi_fuel_out;
  fuelFlueGas_inlet.flueGas.xi_outflow =  xi_flueGas_del;
  inlet.flueGas.xi_outflow = xi_flueGas_del;
  outlet.flueGas.xi_outflow = xi_flueGas_del;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-300,
            -100},{300,100}}),
                      graphics={
        Line(
          points={{-260,0},{-140,0}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Polygon(
          points={{-136,0},{-144,4},{-144,-4},{-136,0}},
          lineColor={0,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{4,0},{-4,4},{-4,-4},{4,0}},
          lineColor={0,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-120,-20},
          rotation=90),
        Line(
          points={{-120,-60},{-120,-20}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-300,-100},{300,100}}), graphics={
        Text(
          extent={{32,90},{240,56}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "T_out="+realString(T_outlet,1,integer(1)) +"K")),
        Text(
          extent={{32,-14},{240,-48}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "alphaA="+realString(heattransfer.effAlphaA,1,integer(0))+"")),
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
          textString=DynamicSelect("", "Q="+realString(-Q_combustion/1e6,1,integer(0))+"MW"))}),
    Documentation(info="<html>
<p><b>Model description: </b>A stationary burner model for fuel fired furnaces</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Stationary mass and energy balances are used</li>
<li>The formation enthalpy of the used fuel is calculated with the given Lower heating value and and ideal combustion with the given elemental composition of the fuel</li>
<li>Lower heating can be regarded with a fixed value or calculated according to the &QUOT;Verbandsformel&QUOT;</li>
<li>Different heat transfer correlations can be chosen </li>
<li>Amount of burnable fuel mass is calculated with particle diffusity which depends on models used to determine the mean migration speed according to the volume flow rates of the flue gas</li>
<li>Excess air is calculated for burner (lambda primary) and overall volume (lambda) separately</li>
</ul></p>
</html>"));
end Burner_L2_Dynamic;
