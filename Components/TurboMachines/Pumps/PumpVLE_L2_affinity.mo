within ClaRa.Components.TurboMachines.Pumps;
model PumpVLE_L2_affinity "A pump for VLE mixtures with a finite fluid volume, based on affinity laws"
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

  extends ClaRa.Basics.Icons.Pump;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut=inlet.m_flow*(pump.fluidIn.h - pump.fluidOut.h),
    powerAux=(pump.P_shaft - inlet.m_flow*(pump.fluidOut.h - pump.fluidIn.h))) if  contributeToCycleSummary;

  model Outline
    extends ClaRa.Components.TurboMachines.Pumps.Fundamentals.Outline;
   input SI.Power P_iso "Power for isentropic flow";
   input SI.Power P_shaft "Mechanicl power at shaft";
    input ClaRa.Basics.Units.RPM rpm "Pump revolutions per minute";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeVLE  inlet;
    ClaRa.Basics.Records.FlangeVLE  outlet;
  end Summary;

   parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium in the component" annotation(choicesAllMatching=true, Dialog(group="Fundamental Definitions"));

  parameter Boolean useMechanicalPort=false "True, if a mechenical flange should be used" annotation (Dialog( group = "Fundamental Definitions"));
  parameter Boolean steadyStateTorque=false "True, if steady state mechanical momentum shall be used" annotation (Dialog( group = "Fundamental Definitions"));
  parameter SI.RPM rpm_fixed = 60 "Constant rotational speed of pump" annotation (Dialog( group = "Fundamental Definitions", enable = not useMechanicalPort));
  parameter Modelica.SIunits.Inertia J "Moment of Inertia" annotation(Dialog(group="Time Response Definitions", enable= not steadyStateTorque));

  parameter SI.RPM rpm_nom "Nomial rotational speed"
                                                    annotation(Dialog(group = "Characteristic Field",groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/PumpCharField1.png"));
  parameter SI.VolumeFlowRate V_flow_max "Maximum volume flow rate at nominal speed" annotation(Dialog(group = "Characteristic Field"));
  parameter SI.Pressure Delta_p_max "Maximum pressure difference at nominal speed" annotation(Dialog(group = "Characteristic Field"));


  //_____/ Inner fluid model \__________________________________________________________
  replaceable model Hydraulics =   ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics.MetaStable_Q124 constrainedby ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics.BaseHydraulics "Hydraulic characteristic" annotation(choicesAllMatching, Dialog(group= "Characteristic Field"));
  replaceable model Losses =  ClaRa.Components.TurboMachines.Fundamentals.PumpEfficiency.EfficiencyCurves_Q1  constrainedby ClaRa.Components.TurboMachines.Fundamentals.PumpEfficiency.BaseEfficiency "Model for losses"         annotation(choicesAllMatching, Dialog(group= "Characteristic Field"));

  replaceable model PressureLoss =
    ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2
  constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "1st: choose friction model | 2nd: edit corresponding record"
  annotation(Dialog(tab="Pump Volume", group="Fundamental Definitions"), choicesAllMatching=true);

  parameter SI.Volume volume_fluid=0.01 "Volume of fluid"  annotation(Dialog(tab="Pump Volume", group="Fundamental Definitions"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nom= 10 "Nominal mass flow rates at inlet" annotation(Dialog(tab="Pump Volume", group="Nominal Values"));

  parameter Modelica.SIunits.Pressure p_nom=1e5 "Nominal pressure" annotation(Dialog(tab="Pump Volume",group="Nominal Values"));
  parameter Modelica.SIunits.SpecificEnthalpy h_nom=1e5 "Nominal specific enthalpy" annotation(Dialog(tab="Pump Volume",group="Nominal Values"));

  parameter Modelica.SIunits.SpecificEnthalpy h_start= 1e5 "Start value of outlet specific enthalpy" annotation(Dialog(tab="Pump Volume", group="Initialisation"));
  parameter Modelica.SIunits.Pressure p_start= 1e5 "Start value of outlet pressure" annotation(Dialog(tab="Pump Volume", group="Initialisation"));
  parameter Integer initOption=0 "Type of initialisation at tube side"
    annotation (Dialog(tab="Pump Volume", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));

  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"   annotation(Dialog(tab="Pump Volume", group="Initialisation"));

  //________________________________________________________________________________

  parameter Boolean showExpertSummary = simCenter.showExpertSummary "True, if expert summary should be applied"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));

  outer ClaRa.SimCenter simCenter;
  ClaRa.Basics.Interfaces.FluidPortIn inlet( Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  TILMedia.VLEFluid_ph  fluidIn(vleFluidType =    medium, p=inlet.p, h=actualStream(inlet.h_outflow)) annotation (Placement(transformation(extent={{-90,14},{-70,34}})));
  TILMedia.VLEFluid_ph  fluidOut( vleFluidType =    medium, p=outlet.p, h=actualStream(outlet.h_outflow)) annotation (Placement(transformation(extent={{70,14},{90,34}})));
public
  Basics.Interfaces.EyeOut       eye if showData annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

protected
  Basics.Interfaces.EyeIn       eye_int[1] annotation (Placement(transformation(extent={{45,-61},{47,-59}})));

  PumpVLE_L1_affinity pump(outlet(p(start=p_start)),
    showExpertSummary=showExpertSummary,
    useMechanicalPort=useMechanicalPort,
    steadyStateTorque=steadyStateTorque,
    rpm_fixed=rpm_fixed,
    rpm_nom=rpm_nom,
    V_flow_max=V_flow_max,
    Delta_p_max=Delta_p_max,
    J=J,
    medium=medium,
    showData=false,
    contributeToCycleSummary=contributeToCycleSummary,
    redeclare model Hydraulics = Hydraulics,
    redeclare model Losses = Losses) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 pumpFluidVolume(
    medium=medium,
    useHomotopy=useHomotopy,
    m_flow_nom=m_flow_nom,
    p_nom=p_nom,
    h_nom=h_nom,
    h_start=h_start,
    p_start=p_start,
    showExpertSummary=showExpertSummary,
    redeclare model PressureLoss = PressureLoss,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry,
    initOption=initOption) annotation (Placement(transformation(extent={{24,-10},{44,10}})));
public
  Summary summary(
     outline( V_flow=pump.V_flow,
              P_fluid=pump.P_fluid,
              P_iso=pump.summary.outline.P_iso,
              P_shaft=pump.summary.outline.P_shaft,
              Delta_p=pump.Delta_p,
              head= pump.Delta_p/(fluidIn.d*Modelica.Constants.g_n),
              NPSHa = (inlet.p - fluidIn.VLE.p_l)/(fluidIn.d*Modelica.Constants.g_n),
              eta_hyd= pump.losses.eta,
              eta_mech=1,
              rpm=pump.rpm),
      inlet(  showExpertSummary = showExpertSummary,
              m_flow=inlet.m_flow,
              T=fluidIn.T,
              p=inlet.p,
              h=fluidIn.h,
              s=fluidIn.s,
              steamQuality = fluidIn.q,
              H_flow= fluidIn.h*inlet.m_flow,
              rho=fluidIn.d),
    outlet(
      showExpertSummary=showExpertSummary,
      m_flow=-outlet.m_flow,
      T=fluidOut.T,
      p=outlet.p,
      h=fluidOut.h,
      s=fluidOut.s,
      steamQuality=fluidOut.q,
      H_flow=-fluidOut.h*outlet.m_flow,
      rho=fluidOut.d))          annotation(Placement(transformation(
        extent={{-10,-11},{10,11}},
        origin={-70,-91})));

  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft if  useMechanicalPort
    annotation (Placement(transformation(extent={{-10,62},{10,82}}),
        iconTransformation(extent={{-10,89},{10,109}})));

  SI.Power P_shaft=pump.summary.outline.P_shaft "Mechanicl power at shaft";

// initial equation
//   inlet.m_flow=m_flow_in_start;
//   outlet.m_flow=m_flow_out_start;
//   h_iso_start=pump.h_iso;
equation
  eye_int[1].m_flow = -outlet.m_flow;
  eye_int[1].T = fluidOut.T-273.15;
  eye_int[1].s = fluidOut.s/1e3;
  eye_int[1].p = outlet.p/1e5;
  eye_int[1].h = fluidOut.h/1e3;

  connect(inlet, pump.inlet)                      annotation (Line(
      points={{-100,0},{-10,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pump.outlet, pumpFluidVolume.inlet)                    annotation (
      Line(
      points={{10,0},{24,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(pumpFluidVolume.outlet, outlet)
                                        annotation (Line(
      points={{44,0},{100,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(pump.shaft, shaft)                      annotation (Line(
      points={{0,9.9},{0,72}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(eye_int[1], eye) annotation (Line(points={{46,-60},{72,-60},{72,-60},{100,-60}}, color={190,190,190}));
  annotation (Icon(graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineThickness=1,
            lineColor={167,25,48},
            fillPattern=FillPattern.None,
            pattern=DynamicSelect(LinePattern.None, if summary.outline.NPSHa <0 then LinePattern.Solid else LinePattern.None))}), Diagram(graphics));
end PumpVLE_L2_affinity;
