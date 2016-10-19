within ClaRa.StaticCycles;
model FixedPressure "Pressure fix point || blue | green"
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
// Green input: Values of p, m_flow and h are unknown and provided BY neighbor component.
// Blue output: Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  parameter ClaRa.Basics.Units.Pressure p "Pressure" annotation(Dialog(group= "Fundamental Definitions"));

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "Mass flow rate";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in "Outlet spec. enthalpy";

  Fundamentals.SteamSignal_green outlet(m_flow=m_flow, h=h_out, p=p)
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}}),
        iconTransformation(extent={{-58,-10},{-50,10}})));
  Fundamentals.SteamSignal_blue inlet(p=p) annotation (
      Placement(transformation(extent={{44,-10},{64,10}}), iconTransformation(
          extent={{50,-10},{58,10}})));
initial equation
  inlet.h=h_in;
  inlet.m_flow=m_flow;

equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
                                                             extent={{-50,-25},{50,25}}),
                   graphics={Polygon(
          points={{0,-20},{20,0},{0,20},{-20,0},{0,-20}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={0,0},
          rotation=360,
          lineThickness=0.25),
        Line(
          points={{-50,0},{-50,0},{-20,0}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{20,0},{50,0}},
          color={0,131,169},
          smooth=Smooth.None),
        Text(
          extent={{-20,10},{20,-10}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="p")}),     Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-50,-25},{50,25}}),   graphics));
end FixedPressure;
