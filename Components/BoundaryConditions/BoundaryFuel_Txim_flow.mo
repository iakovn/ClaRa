within ClaRa.Components.BoundaryConditions;
model BoundaryFuel_Txim_flow "A source defining mass flow, temperature and composition"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.3.1                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2018, DYNCAP/DYNSTART research team.                      //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  extends ClaRa.Basics.Icons.FlowSource;
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=if massFlowIsLoss then 0 else min(0, fuel_a.m_flow*h_coal),
    powerOut=if massFlowIsLoss then 0 else max(0, fuel_a.m_flow*h_coal),
    powerAux=0) if                                                                                                     contributeToCycleSummary;
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                              annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean massFlowIsLoss = true "True if mass flow is a loss (not a process product)" annotation(Dialog(tab="Summary and Visualisation"));

  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Boolean variable_m_flow=false "True, if mass flow defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_T=false "True, if temperature defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_xi=false "True, if composition defined by variable input"    annotation(Dialog(group="Define Variable Boundaries"));

  parameter SI.MassFlowRate m_flow_const=0 "Constant mass flow rate" annotation(Dialog(group="Constant Boundaries", enable= not variable_m_flow));
  parameter SI.Temperature T_const=simCenter.T_amb_start "Constant specific temperature of source"
                                              annotation(Dialog(group="Constant Boundaries", enable= not variable_T));
  parameter SI.MassFraction xi_const[fuelModel.N_c-1]=fuelModel.defaultComposition "Constant composition"
                           annotation(Dialog(group="Constant Boundaries", enable= not variable_xi));
                                                                                            /*zeros(fuelModel.nc-1) */

  outer ClaRa.SimCenter simCenter;
protected
  Modelica.SIunits.MassFlowRate m_flow_in;
  Modelica.SIunits.Temperature T_in;
  Modelica.SIunits.MassFraction xi_in[fuelModel.N_c-1];
  SI.EnthalpyMassSpecific h_coal;
  Basics.Media.FuelObject fuelObject(
    p=fuel_a.p,
    T=fuel_a.T_outflow,
    xi_c=fuel_a.xi_outflow,
    fuelModel=fuelModel) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
public
  ClaRa.Basics.Interfaces.Fuel_outlet fuel_a(final fuelModel=fuelModel)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealInput m_flow(value=m_flow_in) if (variable_m_flow) "Variable mass flow rate"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput T(value=T_in) if (variable_T) "Variable specific temperature"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealInput xi[fuelModel.N_c-1](value=xi_in) if
       (variable_xi) "Variable composition"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));

equation

  h_coal = fuelObject.LHV + fuelObject.cp*(actualStream(fuel_a.T_outflow) - 298.15);

  if (not variable_m_flow) then
    m_flow_in=m_flow_const;
  end if;
  if (not variable_T) then
    T_in=T_const;
  end if;
  if (not variable_xi) then
    xi_in=xi_const;
  end if;

  fuel_a.T_outflow=T_in;
  fuel_a.m_flow=-m_flow_in;
  fuel_a.xi_outflow=xi_in;

                             annotation (Dialog(enable=(LHV_calculationType ==
          "predefined"), group="Combustion settings"),
             Icon(graphics={
        Text(
          extent={{-100,30},{60,-30}},
          lineColor={27,36,42},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="T, xi")}),
                             Diagram(graphics));
end BoundaryFuel_Txim_flow;
