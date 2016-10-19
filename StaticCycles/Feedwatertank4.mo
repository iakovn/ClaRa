within ClaRa.StaticCycles;
model Feedwatertank4 "Feedwatertank || par.: m_flow_FW, p_FW_nom || blue | blue | red | green"
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
  // Red input:    Values of p and m_flow are known in component and provided FOR neighbor component, value of h is unknown and provided BY neighbor component.
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.
   outer parameter Real P_target_ "Target power in p.u.";
  outer ClaRa.SimCenter simCenter;
   parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
                                                       annotation(Dialog(group="Fundamental Definitions"), choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                        choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                        choice=simCenter.fluid3 "Third fluid defined in global simCenter"));
  parameter ClaRa.Basics.Units.Pressure p_FWT_nom "Feed water tank pressure at nominal load" annotation(Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom "Mass flow rate at nomoinal load" annotation(Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Length level_abs= 0 "Filling level" annotation(Dialog(group="Fundamental Definitions"));

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap_in1(fixed=false,start=1);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap_in2(fixed=false,start=1);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_in(fixed=false);
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_cond(fixed=false);
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_tap1(fixed=false);

//__________________________________________________

  final parameter ClaRa.Basics.Units.Pressure p_FWT=P_target_*p_FWT_nom "Feedwater tank pressure at current load";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_tap2=(h_cond_out*m_flow_FW - h_cond_in*m_flow_cond - m_flow_tap1*h_tap_in1)/h_tap_in2 "Mass flow of the heating steam";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_FW=P_target_*m_flow_nom "Mass flow of the condensate";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_out= TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_FWT);

  Fundamentals.SteamSignal_blue cond_in(p=p_FWT) annotation (Placement(
        transformation(extent={{-106,-70},{-86,-50}}), iconTransformation(
          extent={{-108,-70},{-100,-50}})));
  Fundamentals.SteamSignal_red tap_in2(m_flow=m_flow_tap2, p=p_FWT) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,16}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=-90,
        origin={1.77636e-015,24})));
  Fundamentals.SteamSignal_green cond_out(
    h=h_cond_out,
    p=p_FWT + Modelica.Constants.g_n * level_abs* TILMedia.VLEFluidFunctions.bubbleDensity_pxi(medium, p_FWT),
    m_flow=m_flow_FW) annotation (Placement(transformation(extent={{88,-70},{108,-50}}),
                         iconTransformation(extent={{100,-70},{108,-50}})));
  Fundamentals.SteamSignal_blue tap_in1(p=p_FWT) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-42,16}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=-90,
        origin={40,24})));
initial equation
  m_flow_cond = cond_in.m_flow;
  m_flow_tap1 = tap_in1.m_flow;
  h_tap_in1=tap_in1.h;
  h_tap_in2=tap_in2.h;
  h_cond_in=cond_in.h;

equation
  connect(cond_out, cond_out) annotation (Line(
      points={{98,-60},{98,-60}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
                                                             extent={{-100,-100},{100,20}}), graphics={
        Polygon(
          points={{-60,-100},{-100,-100},{-100,-60},{-100,-20},{-60,-20},{-20,-20},{-20,-20},{-20,0},{-20,20},{0,20},{20,20},{20,0},{20,-20},{20,-20},{60,-20},{100,-20},{100,-60},{100,-100},{60,-100},{-60,-100}},
          fillColor={255,255,255},
          lineColor=DynamicSelect({0,131,169}, if m_flow_FW - m_flow_cond - m_flow_tap1 - m_flow_tap2 <1e-3 then {0,131,169} else {235,183,0}),
          fillPattern=DynamicSelect(FillPattern.Solid, if m_flow_FW - m_flow_cond - m_flow_tap1 - m_flow_tap2 < 1e-3 then FillPattern.Solid else FillPattern.CrossDiag),
          smooth=Smooth.Bezier),
        Line(
          points={{0,12},{0,-58},{-8,-48}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{0,-58},{8,-48}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{-92,-60},{92,-60},{78,-72}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{92,-60},{78,-48}},
          color={0,131,169},
          smooth=Smooth.None)}),
                         Diagram(coordinateSystem(preserveAspectRatio=false,
                                                                           extent={{-100,-100},{100,20}})));
end Feedwatertank4;
