within ClaRa.StaticCycles;
model FixedFlow "Flow Anchour || par.: m_flow_nom || red | blue"
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
// Red input:    Values of p and m_flow are known in component and provided FOR neighbor component, value of h is unknown and provided BY neighbor component.
// Blue output:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  outer parameter Real P_target_ "Target power in p.u.";

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom2 "Nominal mass flow" annotation(Dialog(group="Fundamental Definitions"));
  parameter Real CharLine_m_flow_P_target_[:,2] = [0,0;1,1] "Pressure drop depending on rel. power in p.u."
                                                                                                annotation(Dialog(group="Fundamental Definitions"));

  final parameter ClaRa.Basics.Units.Pressure p_in=p_out "Inlet perssure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "Outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in "Outlet spec. enthalpy";
protected
  ClaRa.Components.Utilities.Blocks.ParameterizableTable1D table1(table=CharLine_m_flow_P_target_, u = {P_target_});

public
  Fundamentals.SteamSignal_red inlet(p=p_in, m_flow=m_flow)
    annotation (Placement(transformation(extent={{-65,-10},{-45,10}}),
        iconTransformation(extent={{-58,-10},{-50,10}})));
  Fundamentals.SteamSignal_blue outlet(h=h_out, m_flow=m_flow)
    annotation (Placement(transformation(extent={{44,-10},{64,10}}),
        iconTransformation(extent={{50,-10},{58,10}})));
initial equation
  outlet.p=p_out;
  inlet.h=h_in;
  m_flow = table1.y[1]*m_flow_nom2;

equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
                                                             extent={{-50,-25},{50,25}}),
                   graphics={Polygon(
          points={{-20,0},{0,-20},{20,0},{0,20},{-20,0}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={0,0},
          rotation=360,
          lineThickness=0.25),
        Text(
          extent={{-20,6},{20,-4}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="m_flow"),
        Line(
          points={{-50,0},{-20,0}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{20,0},{50,0}},
          color={0,131,169},
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-50,-25},{50,25}}),   graphics));
end FixedFlow;
