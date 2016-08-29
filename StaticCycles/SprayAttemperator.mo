within ClaRa.StaticCycles;
model SprayAttemperator "Mixer || green | red | green"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.1                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright © 2013-2016, DYNCAP/DYNSTART research team.                     //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  // Green input: Values of p, m_flow and h are unknown and provided BY neighbor component.
  // Red input:    Values of p and m_flow are known in component and provided FOR neighbor component, value of h is unknown and provided BY neighbor component.
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h1(fixed=false)
    "|Internals|Internally set values - do not edit!|Specific enthalpy of flow 1";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h2(fixed=false)
    "|Internals|Internally set values - do not edit!|Specific enthalpy of flow 2";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_1(fixed=false)
    "|Internals|Internally set values - do not edit!|Mass flow rate of flow 1";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_2 = (h3*m_flow_3 - h1*m_flow_1)/h2
    "|Internals|Internally set values - do not edit!|Mass flow rate of flow 2";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h3 = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(medium, p, T, zeros(medium.nc - 1))
    "|Internals|Internally set values - do not edit!|Mixer outlet enthalpy";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_3=m_flow_1 + m_flow_2
    "|Internals|Internally set values - do not edit!|Mixer outlet mass flow rate";
  final parameter ClaRa.Basics.Units.Pressure p(fixed=false)
    "|Internals|Internally set values - do not edit!|Mixer pressure";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1
    "Medium in the component";

  parameter ClaRa.Basics.Units.Temperature T "Outlet Temperature";

  Fundamentals.SteamSignal_green inlet_1
    annotation (Placement(transformation(extent={{36,10},{56,30}}),
        iconTransformation(extent={{44,-10},{50,10}})));
  Fundamentals.SteamSignal_red inlet_2(p=p, m_flow=m_flow_2) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-104}), iconTransformation(
        extent={{-3,-10},{3,10}},
        rotation=-90,
        origin={1.77636e-015,-27})));
  Fundamentals.SteamSignal_green outlet(
    p=p,
    h=h3,
    m_flow=m_flow_3)
    annotation (Placement(transformation(extent={{-56,10},{-36,30}}),
        iconTransformation(extent={{-50,-10},{-44,10}})));
initial equation
  inlet_1.p=p;
  inlet_1.h=h1;
  inlet_1.m_flow=m_flow_1;
  inlet_2.h=h2;

equation
  connect(outlet, outlet) annotation (Line(
      points={{-46,20},{-46,20},{-46,20}},
      color={0,131,169},
      smooth=Smooth.Bezier));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-50,-30},{50,30}}),
                         graphics={
        Rectangle(extent={{-50,30},{50,-30}}, lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,-24},{0,0},{20,20}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{20,0},{0,0},{20,-20}},
          color={0,131,169},
          smooth=Smooth.None)}),            Diagram(coordinateSystem(
          preserveAspectRatio=true,  extent={{-60,-20},{60,30}}),     graphics));
end SprayAttemperator;
