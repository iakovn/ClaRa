within ClaRa.StaticCycles;
model Valve_fixedFlow "Valve || yellow | blue"
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
   // Yellow input: Values of p and h are unknown and provided BY neighbor component, value of m_flow is known and provided FOR neighbor component.
   // Blue output:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom= 10
    "Nominal mass flow rate";

  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false)
    "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false)
    "Outlet pressure";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false)
    "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in
    "Outlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.Pressure Delta_p=p_in-p_out
    "Pressure difference";

  Fundamentals.SteamSignal_yellow inlet(m_flow=m_flow_nom)
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}}),
        iconTransformation(extent={{-58,-10},{-50,10}})));
  Fundamentals.SteamSignal_blue outlet(m_flow=m_flow_nom, h=h_out) annotation (
      Placement(transformation(extent={{44,-10},{64,10}}), iconTransformation(
          extent={{50,-10},{58,10}})));
initial equation
  outlet.p=p_out;
  inlet.p=p_in;
  inlet.h=h_in;

equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,extent={{-50,-25},{50,25}}),
                   graphics={Polygon(
          points={{-50,-25},{50,25},{50,-25},{-50,25},{-50,-25}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={0,0},
          rotation=360,
          lineThickness=0.25)}), Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-50,-25},{50,25}}),   graphics));
end Valve_fixedFlow;
