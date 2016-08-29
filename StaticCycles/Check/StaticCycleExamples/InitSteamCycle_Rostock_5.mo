within ClaRa.StaticCycles.Check.StaticCycleExamples;
model InitSteamCycle_Rostock_5
  "Helps you to find reasonable start values for steam cycles"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.1                        //
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
  extends ClaRa.Basics.Icons.Init;
  import TILMedia.VLEFluidFunctions.*;
  import SI = ClaRa.Basics.Units;
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1
    "Medium in the component"
    annotation(choices(choice=simCenter.fluid1
        "First fluid defined in global simCenter",
                       choice=simCenter.fluid2
        "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3
        "Third fluid defined in global simCenter"),       Dialog(group="Fundamental Definitions"));

//__________________global parameter_______________________
  inner parameter Real P_target_= 1 "Value of load in p.u."    annotation(Dialog(group="Global parameter"));
  inner parameter SI.MassFlowRate m_flow_nom=417
    "Feedwater massflow rate at nominal point"                                              annotation (Dialog(group="Global parameter"));
  parameter SI.Temperature T_LS_nom=823
    "Live steam temperature at nominal point"                                     annotation (Dialog(group="Global parameter"));
  parameter SI.Temperature T_RS_nom=833
    "Reheated steam temperature at nominal point"                                     annotation (Dialog(group="Global parameter"));
  parameter String mediumName = "R718" annotation(Dialog(group="Global parameter"));
//  // parameter SI.HeatFlowRate Q_nom=boiler.m_flow_feed*(boiler.h_LS_out - boiler.h_LS_in) + boiler.m_flow_cRH*(boiler.h_RS_out - boiler.h_RS_in)
//     "Nominal heat flow rate"
//     annotation (Dialog(group="Global parameter"));
  final parameter SI.MassFlowRate m_flow_FW=m_flow_nom*P_target_
    "Feedwater massflow rate at nominal point"                                                              annotation (Dialog(group="Global parameter"));

//________________preheater_HP parameter________________________
parameter ClaRa.Basics.Units.Pressure preheater_HP_p_tap=55.95e5
                                                              annotation(Dialog(group = "preheater_HP",tab="Preheater"));
parameter ClaRa.Basics.Units.MassFlowRate preheater_HP_m_flow_tap=42.812
                                                                       annotation(Dialog(group = "preheater_HP",tab="Preheater"));

//____________________boiler parameter_____________________
//  parameter ClaRa.Basics.Units.HeatFlowRate Q_nom = 1150e6 annotation(Dialog(tab="Boiler"));
  parameter SI.Pressure p_LS_out_nom=250.2e5
    "Live steam pressure at nomninal point"                                          annotation (Dialog(tab="Boiler"));
  parameter SI.Pressure p_RS_out_nom=51e5
    "Reaheated steam pressure at nomninal point"                                       annotation (Dialog(tab="Boiler"));
  parameter SI.Pressure dp_LS_nom=89e5
    "Live steam pressure loss in boiler at nomninal point"                                    annotation (Dialog(tab="Boiler"));
  parameter SI.Pressure dp_RS_nom=5e5
    "Reheated steam pressure loss in boiler at nomninal point"                                   annotation (Dialog(tab="Boiler"));

  parameter Real CharLine_dpHP_mLS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1]
    "Characteristic line of pressure drop as function of mass flow rate" annotation(Dialog(group = "CharLines", tab="Boiler"));
  parameter Real CharLine_dpIP_mRS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1]
    "Characteristic line of pressure drop as function of mass flow rate" annotation(Dialog(group = "CharLines",  tab="Boiler"));

//___________________pump parameter________________________
parameter Real efficiency_Pump_FW=1 "Efficiency of freshwater pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_cond=1 "Efficiency of condenser pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_preheat=1 "Efficiency of preheater pump" annotation(Dialog(tab="Pumps"));
//________________turbine parameter________________________
parameter Real efficiency_Turb_HP=1 "Efficiency of turbine" annotation(Dialog(tab= "Turbines"));
parameter Real efficiency_Turb_LP=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
//__________________reheater parameter____________________
parameter SI.Pressure p_shell_preheater=20700
    "Pressure on preheater shell side"                                          annotation(Dialog(tab="Heat exchangers",group="Preheater"));
//__________________reboiler parameter____________________
parameter SI.Pressure p_reboiler=3.5e5 "Reboiler pressure"       annotation(Dialog(tab="Heat exchangers",group="Reboiler"));
parameter SI.MassFlowRate m_flow_reboiler=150 "Reboiler mass flow rate"
                                                                       annotation(Dialog(tab="Heat exchangers",group="Reboiler"));
// __________________Feewatertank parameter________________
parameter SI.Pressure p_FWT=14e5 "Feedwater tank pressure" annotation(Dialog(tab="Heat exchangers",group="Feedwatertank"));
//___________________condenser parameter___________________
  parameter SI.Pressure p_condenser=4000 "Condenser Pressure" annotation (Dialog(tab="Heat exchangers",group="Condenser"));
//________________ valves parameter________________________
parameter ClaRa.Basics.Units.Pressure valve_IP_dp_nominal=1e5  annotation(Dialog(tab="Valves"));
parameter ClaRa.Basics.Units.Pressure valve_LP1_dp_nominal=0.001e5   annotation(Dialog(tab="Valves"));

//parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

  ClaRa.StaticCycles.Pump pump_fw(efficiency=efficiency_Pump_FW)
                                   annotation (Placement(transformation(extent={{-140,-68},{-160,-48}})));
  ClaRa.StaticCycles.Turbine turbine_HP(
    efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-192,120},{-180,140}})));
  ClaRa.StaticCycles.Turbine turbine_LP(
    efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{-140,118},{-128,138}})));
  ClaRa.StaticCycles.Boiler boiler(
    p_LS_out_nom=p_LS_out_nom,
    p_RS_out_nom=p_RS_out_nom,
    CharLine_Delta_p_IP_mRS_=CharLine_dpIP_mRS_,
    T_LS_nom=T_LS_nom,
    T_RS_nom=T_RS_nom,
    CharLine_Delta_p_HP_mLS_=CharLine_dpHP_mLS_,
    Delta_p_LS_nom=dp_LS_nom,
    Delta_p_RS_nom=dp_RS_nom) annotation (Placement(transformation(extent={{-220,60},{-200,80}})));

  ClaRa.StaticCycles.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{142,-24},{162,-4}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_LP(Delta_p_nom=valve_IP_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=270,
        origin={-81,10})));
  ClaRa.StaticCycles.Feedwatertank3 feedwatertank(p_FWT_nom=p_FWT, m_flow_nom=m_flow_FW) annotation (Placement(transformation(extent={{-62,-68},{-100,-48}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_LP1(Delta_p_nom=valve_LP1_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=270,
        origin={95,10})));
  ClaRa.StaticCycles.Pump pump_cond(efficiency=efficiency_Pump_cond)
    annotation (Placement(transformation(extent={{136,-62},{116,-42}})));
  ClaRa.StaticCycles.Turbine turbine_LP1(
    efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{-40,118},{-28,138}})));
  ClaRa.StaticCycles.Turbine turbine_LP2(
    efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{52,118},{64,138}})));
  ClaRa.StaticCycles.Split1 split_LP annotation (Placement(transformation(extent={{-92,112},{-72,122}})));
  ClaRa.StaticCycles.Split1 split_LP1 annotation (Placement(transformation(extent={{84,112},{104,122}})));
  ClaRa.StaticCycles.Preheater1 preheater_LP1(p_tap=p_shell_preheater, m_flow_tap=42.812) annotation (Placement(transformation(extent={{106,-62},{86,-42}})));
  ClaRa.StaticCycles.Pump pump_preheater(efficiency=efficiency_Pump_preheat)
    annotation (Placement(transformation(extent={{80,-108},{60,-88}})));
  ClaRa.StaticCycles.Mixer1 mixer annotation (Placement(transformation(extent={{32,-60},{50,-50}})));
  ClaRa.StaticCycles.Turbine turbine_LP3(
    efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{138,118},{150,138}})));
  ClaRa.StaticCycles.Split1 split annotation (Placement(transformation(extent={{-2,128},{16,118}})));
  ClaRa.StaticCycles.Reboiler reboiler(p_reb=3.5e5, m_flow_reb=150)
    annotation (Placement(transformation(extent={{96,168},{116,188}})));
  ClaRa.StaticCycles.Pump pump_preheater1(
                      efficiency=efficiency_Pump_preheat)
    annotation (Placement(transformation(extent={{154,168},{174,188}})));
  ClaRa.StaticCycles.Mixer1 mixer1 annotation (Placement(transformation(extent={{-2,-60},{16,-50}})));
equation
  connect(boiler.liveSteam, turbine_HP.inlet) annotation (Line(
      points={{-210,80.4},{-210,134},{-190.8,134}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.reheat_out, turbine_LP.inlet) annotation (Line(
      points={{-206,80.4},{-206,158},{-138,158},{-138,146},{-138.8,146},{-138.8,132}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.cond_out, pump_fw.inlet) annotation (Line(
      points={{-99.24,-61.3333},{-122,-61.3333},{-122,-58},{-139.6,-58}},
      color={0,131,169},
      smooth=Smooth.None));

  connect(pump_cond.inlet, condenser.outlet) annotation (Line(
      points={{136.4,-52},{152,-52},{152,-24.4}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_in, pump_cond.outlet) annotation (Line(
      points={{106.4,-52},{115.6,-52}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.tap_in, valve_LP1.outlet) annotation (Line(
      points={{96,-41.6},{96,-0.8},{95,-0.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_preheater.inlet, preheater_LP1.tap_out) annotation (Line(
      points={{80.4,-98},{96,-98},{96,-62.4}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer.inlet_2, pump_preheater.outlet) annotation (Line(
      points={{41,-59.3333},{41,-98},{59.6,-98}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_out, mixer.inlet_1) annotation (Line(
      points={{85.6,-52},{58,-52},{58,-51.6667},{49.1,-51.6667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.tap_in, valve_LP.outlet) annotation (Line(
      points={{-81,-48.6667},{-81,-0.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP3.outlet, condenser.inlet) annotation (Line(
      points={{149.6,120},{150,120},{150,-3.6},{152,-3.6}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(reboiler.outlet, pump_preheater1.inlet) annotation (Line(
      points={{116.4,178},{153.6,178}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer1.inlet_1, mixer.outlet) annotation (Line(
      points={{15.1,-51.6667},{20,-51.6667},{20,-50},{22.4,-50},{22.4,-51.6667},{32.72,-51.6667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer1.inlet_2, pump_preheater1.outlet) annotation (Line(
      points={{7,-59.3333},{7,-72},{8,-72},{8,-108},{196,-108},{196,178},{174.4,178}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP.outlet, split_LP.inlet) annotation (Line(
      points={{-128.4,120},{-96,120},{-96,120.333},{-91.4,120.333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_2, valve_LP.inlet) annotation (Line(
      points={{-82,112.5},{-82,20.8},{-81,20.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_1, turbine_LP1.inlet) annotation (Line(
      points={{-72.6,120.333},{-54,120.333},{-54,132},{-38.8,132}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP1.outlet, split.inlet) annotation (Line(
      points={{-28.4,120},{-6,120},{-6,119.667},{-1.46,119.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split.outlet_2, reboiler.inlet) annotation (Line(
      points={{7,127.5},{7,178},{95.6,178}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split.outlet_1, turbine_LP2.inlet) annotation (Line(
      points={{15.46,119.667},{28,119.667},{28,132},{53.2,132},{53.2,132}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP2.outlet, split_LP1.inlet) annotation (Line(
      points={{63.6,120},{80,120},{80,120.333},{84.6,120.333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_2, valve_LP1.inlet) annotation (Line(
      points={{94,112.5},{94,20.8},{95,20.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_1, turbine_LP3.inlet) annotation (Line(
      points={{103.4,120.333},{122,120.333},{122,132},{139.2,132}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_HP.outlet, boiler.reheat_in) annotation (Line(
      points={{-180.4,122},{-162,122},{-162,86},{-162,86},{-162,12},{-206,12},{-206,59.6}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.feedwater, pump_fw.outlet) annotation (Line(
      points={{-210,59.6},{-210,-58},{-160.4,-58}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer1.outlet, feedwatertank.cond_in) annotation (Line(
      points={{-1.28,-51.6667},{-10,-51.6667},{-10,-61.3333},{-62.76,-61.3333}},
      color={0,131,169},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                   graphics),      Diagram(coordinateSystem(preserveAspectRatio=false,
                 extent={{-240,-140},{200,200}},
        initialScale=0.1),                        graphics),
    experiment(
      StopTime=20000,
      NumberOfIntervals=5000,
      Tolerance=1e-005),
    __Dymola_experimentSetupOutput);
end InitSteamCycle_Rostock_5;
