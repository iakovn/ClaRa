within ClaRa.StaticCycles;
model Split4 "Split || blue | yellow | blue"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.2                            //
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
   // Blue input:   Value of p is known in component and provided FOR neighbor component, values of m_flow and h are unknown and provided BY neighbor component.
   // Yellow output: Values of p, and h are known in component and provided FOR neighbor component, value of m_flow is unknown and provided BY beighbor component.
   // Red output:   Values of p and m_flow are unknown and provided BY neighbor component, value of h is known and provided FOR neighbor component.
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_2(fixed=false) "Mass flow rate of flow 1";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_3 = m_flow_1-m_flow_2 "Mass flow rate of flow 2";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h1(fixed=false);
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_1(fixed=false) "Mixer outlet mass flow rate";
  final parameter ClaRa.Basics.Units.Pressure p(fixed=false) "Mixer pressure";
  //final parameter Real splitRatio=outlet_1.m_flow/inlet.m_flow "ratio of outlet_1.m_flow/inlet.m_flow";

  Fundamentals.SteamSignal_blue inlet(p=p) annotation (Placement(transformation(
          extent={{-56,10},{-36,30}}), iconTransformation(extent={{-50,10},{-44,30}})));
  Fundamentals.SteamSignal_yellow outlet_1(
    h=h1,
    p=p) annotation (Placement(transformation(extent={{36,10},{56,30}}), iconTransformation(extent={{44,10},{50,30}})));
  Fundamentals.SteamSignal_blue outlet_2(h=h1, m_flow=m_flow_3) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-104}), iconTransformation(
        extent={{-3,-10},{3,10}},
        rotation=-90,
        origin={0,-27})));
initial equation
  inlet.m_flow=m_flow_1;
  inlet.h=h1;
  outlet_2.p=p;
  outlet_1.m_flow=m_flow_2;

equation
  connect(outlet_1, outlet_1) annotation (Line(
      points={{46,20},{46,24},{46,24},{46,20}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(outlet_2, outlet_2) annotation (Line(
      points={{0,-104},{-5,-104},{-5,-104},{0,-104}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(inlet, inlet) annotation (Line(
      points={{-46,20},{-46,24},{-46,24},{-46,20}},
      color={0,131,169},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-50,-30},{50,30}}),
                         graphics={Polygon(
          points={{-50,30},{50,30},{50,10},{10,10},{10,-30},{-10,-30},{-10,10},{-50,10},{-50,30}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-50,-30},{50,30}}),     graphics));
end Split4;
