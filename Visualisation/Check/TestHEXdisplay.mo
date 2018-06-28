within ClaRa.Visualisation.Check;
model TestHEXdisplay "Illustrates the capabilities of the HEXdisplay"
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

extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;

  import SI = ClaRa.Basics.Units;
  parameter SI.Temperature T_i_in=100 + 273.15 "Temperature of cold side";
  parameter SI.Temperature T_o_in=300 + 273.15 "Temperature of hot side";
  parameter SI.MassFlowRate m_flow_i=10 "Mass flow of cold side";
  parameter SI.MassFlowRate m_flow_o=100 "Mass flow of hot side";
  parameter SI.Pressure p_i=2e5 "Pressure of cold side";
  parameter SI.Pressure p_o=300e5 "Pressure of hot side";

  parameter SI.CoefficientOfHeatTransfer alpha_i=730 "Heat transfer coefficient of cold side";
  parameter SI.CoefficientOfHeatTransfer alpha_o=7300 "Heat transfer coefficient of hot side";

  parameter Integer N_tubes = 200 "Number of parallel tubes";
  parameter Integer N_passes = 1 "Number of passes";
  parameter SI.Length diameter_i=0.05*2 "Diameter of cold side tubes";
  parameter SI.Length diameter_o=(0.05 + 1e-6)*2 "Diameter of hot side tubes";
  parameter SI.Length radius_i=diameter_i/2 "Diameter of cold side tubes";
  parameter SI.Length radius_o=diameter_o/2 "Diameter of hot side tubes";
  parameter SI.Length length=4 "Length of tubes";
  parameter Integer N_cv = 400 "Number of Cells";

  SI.EnthalpyMassSpecific h_i_in=
      TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
      TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),
      p_i,
      T_i_in);
  SI.EnthalpyMassSpecific h_o_in=
      TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
      TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),
      p_o,
      T.y);



  inner SimCenter simCenter(
    steamCycleAllowFlowReversal=true,
    useHomotopy=false,
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{-100,-120},{-60,-100}})));

  Visualisation.Hexdisplay_3 ConterFlowDisplay(
    y_min=373,
    T_o=NTU_counter.summary.T_o,
    T_i=NTU_counter.summary.T_i,
    Unit="CounterFlow",
    y_max=610,
    z_i=NTU_counter.summary.eCom.z_i,
    z_o=NTU_counter.summary.eCom.z_o) annotation (Placement(transformation(extent={{-18,-108},{94,-4}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone NTU_counter(
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    outerPhaseChange=false,
    redeclare model HeatCapacityAveraging = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp.ArithmeticMean,
    radius_i=radius_i,
    radius_o=radius_o,
    p_o=p_o,
    p_i=p_i,
    h_i_inlet=h_i_in,
    h_o_inlet=h_o_in,
    m_flow_i=m_flow_i,
    m_flow_o=m_flow_o,
    alpha_i=ones(3)*alpha_i,
    alpha_o=ones(3)*alpha_o,
    T_w_i_start=ones(3)*T_i_in,
    T_w_o_start=ones(3)*T_o_in,
    redeclare model HeatExchangerType = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow_L3,
    showExpertSummary=true,
    initOption=204,
    initOption_yps=4,
    yps_start={0,0}) annotation (Placement(transformation(extent={{74,-106},{94,-86}})));

  Hexdisplay_3 hexdisplay_3_2(
    y_min=373,
    T_i=NTU_parallel.summary.T_i,
    T_o=NTU_parallel.summary.T_o,
    Unit="Parallel Flow",
    y_max=610,
    z_i=NTU_parallel.summary.eCom.z_i,
    z_o=NTU_parallel.summary.eCom.z_o) annotation (Placement(transformation(extent={{128,-108},{240,-4}})));
  Hexdisplay_3 hexdisplay_3_3(
    y_min=373,
    Unit="Cross Flow",
    T_o=NTU_cross.summary.T_o,
    T_i=NTU_cross.summary.T_i,
    y_max=610,
    z_i=NTU_cross.summary.eCom.z_i,
    z_o=NTU_cross.summary.eCom.z_o) annotation (Placement(transformation(extent={{278,-108},{390,-4}})));
  Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone NTU_cross(
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    outerPhaseChange=false,
    redeclare model HeatCapacityAveraging = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp.ArithmeticMean,
    radius_i=radius_i,
    radius_o=radius_o,
    p_o=p_o,
    p_i=p_i,
    h_i_inlet=h_i_in,
    h_o_inlet=h_o_in,
    m_flow_i=m_flow_i,
    m_flow_o=m_flow_o,
    alpha_i=ones(3)*alpha_i,
    alpha_o=ones(3)*alpha_o,
    T_w_i_start=ones(3)*T_i_in,
    T_w_o_start=ones(3)*T_o_in,
    redeclare model HeatExchangerType = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CrossFlow_L3,
    showExpertSummary=true,
    initOption=204,
    initOption_yps=4,
    yps_start={0,0})
                    annotation (Placement(transformation(extent={{368,-108},{388,-88}})));
  Modelica.Blocks.Sources.Ramp T(
    height=20,
    offset=T_o_in,
    duration=10,
    startTime=10)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

public
  Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone NTU_parallel(
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    outerPhaseChange=false,
    radius_i=radius_i,
    radius_o=radius_o,
    p_o=p_o,
    p_i=p_i,
    h_i_inlet=h_i_in,
    h_o_inlet=h_o_in,
    m_flow_i=m_flow_i,
    m_flow_o=m_flow_o,
    alpha_i=ones(3)*alpha_i,
    alpha_o=ones(3)*alpha_o,
    T_w_i_start=ones(3)*T_i_in,
    T_w_o_start=ones(3)*T_o_in,
    redeclare model HeatExchangerType = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.ParallelFlow_L3,
    redeclare model HeatCapacityAveraging = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp.ArithmeticMean,
    initOption=204,
    initOption_yps=4,
    yps_start={0,0}) annotation (Placement(transformation(extent={{220,-108},{240,-88}})));

  annotation (                                                        Diagram(
        coordinateSystem(extent={{-100,-120},{400,100}}, preserveAspectRatio=true),
        graphics={Text(
          extent={{-100,100},{292,58}},
          lineColor={115,150,0},
          horizontalAlignment=TextAlignment.Left,
          textString="_______________________________________________________________________________________________________
SCENARIO:
* Comparison of NTU counter,parallel and cross flow
* heating water at inner side, cooling steam at outer side
* phase change at tube side
_______________________________________________________________________________________________________
LOOK AT:
Outlet temperatures of heated liquid: NTU_counter.summary.T_i[6]>NTU_cross.summary.T_i[2]>NTU_parallel.summary.T_i[6]
Outlet temperatures of cooled steam: NTU_counter.summary.T_o[6]<NTU_cross.summary.T_o[2]<NTU_parallel.summary.T_o[6]
_______________________________________________________________________________________________________")}),
    experiment(
      StopTime=300,
      __Dymola_NumberOfIntervals=1500,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true),
        graphics));
end TestHEXdisplay;
