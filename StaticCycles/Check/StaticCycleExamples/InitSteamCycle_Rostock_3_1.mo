within ClaRa.StaticCycles.Check.StaticCycleExamples;
model InitSteamCycle_Rostock_3_1 "Helps you to find reasonable start values for steam cycles"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.2                        //
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
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

//__________________global parameter_______________________
  inner parameter Real P_target_= 1 "Value of load in p.u."    annotation(Dialog(group="Global parameter"));
  inner parameter SI.MassFlowRate m_flow_nom=417 "Feedwater massflow rate at nominal point" annotation (Dialog(group="Global parameter"));
  parameter SI.Temperature T_LS_nom=823 "Live steam temperature at nominal point" annotation (Dialog(group="Global parameter"));
  parameter SI.Temperature T_RS_nom=833 "Reheated steam temperature at nominal point" annotation (Dialog(group="Global parameter"));
  parameter String mediumName = "R718" annotation(Dialog(group="Global parameter"));
//  // parameter SI.HeatFlowRate Q_nom=boiler.m_flow_feed*(boiler.h_LS_out - boiler.h_LS_in) + boiler.m_flow_cRH*(boiler.h_RS_out - boiler.h_RS_in)
//     "Nominal heat flow rate"
//     annotation (Dialog(group="Global parameter"));
  final parameter SI.MassFlowRate m_flow_FW=m_flow_nom*P_target_ "Feedwater massflow rate at nominal point" annotation (Dialog(group="Global parameter"));

//____________________boiler parameter_____________________
//  parameter ClaRa.Basics.Units.HeatFlowRate Q_nom = 1150e6 annotation(Dialog(tab="Boiler"));
  parameter SI.Pressure p_LS_out_nom=250.2e5 "Live steam pressure at nomninal point" annotation (Dialog(tab="Boiler"));
  parameter SI.Pressure p_RS_out_nom=51e5 "Reaheated steam pressure at nomninal point" annotation (Dialog(tab="Boiler"));
  parameter SI.Pressure dp_LS_nom=89e5 "Live steam pressure loss in boiler at nomninal point" annotation (Dialog(tab="Boiler"));
  parameter SI.Pressure dp_RS_nom=5e5 "Reheated steam pressure loss in boiler at nomninal point" annotation (Dialog(tab="Boiler"));

  parameter Real CharLine_dpHP_mLS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(group = "CharLines", tab="Boiler"));
  parameter Real CharLine_dpIP_mRS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(group = "CharLines",  tab="Boiler"));

//___________________pump parameter________________________
parameter Real efficiency_Pump_FW=1 "Efficiency of freshwater pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_cond=1 "Efficiency of condenser pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_preheat=1 "Efficiency of preheater pump" annotation(Dialog(tab="Pumps"));
//________________turbine parameter________________________
parameter Real efficiency_Turb_HP=1 "Efficiency of turbine" annotation(Dialog(tab= "Turbines"));
parameter Real efficiency_Turb_LP=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
//__________________reheater parameter____________________
parameter SI.Pressure p_shell_preheater=20700 "Pressure on preheater shell side"
                                                                                annotation(Dialog(tab="Heat exchangers",group="Preheater"));
// __________________Feewatertank parameter________________
parameter SI.Pressure p_FWT=14e5 "Feedwater tank pressure" annotation(Dialog(tab="Heat exchangers",group="Feedwatertank"));
//___________________condenser parameter___________________
  parameter SI.Pressure p_condenser=4000 "Condenser Pressure" annotation (Dialog(tab="Heat exchangers",group="Condenser"));
//________________ valves parameter________________________
parameter ClaRa.Basics.Units.Pressure valve_IP_dp_nominal=1e5  annotation(Dialog(tab="Valves"));
parameter ClaRa.Basics.Units.Pressure valve_LP1_dp_nominal=0.001e5   annotation(Dialog(tab="Valves"));

//parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

  ClaRa.StaticCycles.Pump_real
       pump_fw(efficiency=efficiency_Pump_FW)
                                   annotation (Placement(transformation(extent={{-120,-98},{-140,-78}})));
  ClaRa.StaticCycles.Turbine turbine_HP(
    efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-130,122},{-120,142}})));
  ClaRa.StaticCycles.Turbine turbine_LP(
    efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{-70,122},{-60,142}})));
  ClaRa.StaticCycles.Boiler boiler(
    p_LS_out_nom=p_LS_out_nom,
    p_RS_out_nom=p_RS_out_nom,
    CharLine_Delta_p_IP_mRS_=CharLine_dpIP_mRS_,
    T_LS_nom=T_LS_nom,
    T_RS_nom=T_RS_nom,
    CharLine_Delta_p_HP_mLS_=CharLine_dpHP_mLS_,
    Delta_p_LS_nom=dp_LS_nom,
    Delta_p_RS_nom=dp_RS_nom) annotation (Placement(transformation(extent={{-160,42},{-140,62}})));

  ClaRa.StaticCycles.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{140,6},{160,26}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_LP(Delta_p_nom=valve_IP_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={-40,17})));
  ClaRa.StaticCycles.Feedwatertank3 feedwatertank(p_FWT_nom=p_FWT, m_flow_nom=m_flow_FW) annotation (Placement(transformation(extent={{-20,-95},{-60,-75}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_LP1(Delta_p_nom=valve_LP1_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={71,8})));
  ClaRa.StaticCycles.Pump_real
       pump_cond(efficiency=efficiency_Pump_cond)
    annotation (Placement(transformation(extent={{124,-100},{104,-80}})));
  ClaRa.StaticCycles.Turbine turbine_LP1(
    efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{22,120},{32,140}})));
  ClaRa.StaticCycles.Turbine turbine_LP2(
    efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{108,108},{118,128}})));
  ClaRa.StaticCycles.Split1 split_LP annotation (Placement(transformation(extent={{-50,116},{-30,126}})));
  ClaRa.StaticCycles.Split1 split_LP1 annotation (Placement(transformation(extent={{62,112},{82,124}})));
  ClaRa.StaticCycles.Preheater1 preheater_LP1(p_tap=p_shell_preheater, m_flow_tap=14) annotation (Placement(transformation(extent={{80,-100},{60,-80}})));
  ClaRa.StaticCycles.Pump_real
       pump_preheater(efficiency=efficiency_Pump_preheat)
    annotation (Placement(transformation(extent={{40,-120},{20,-100}})));
  ClaRa.StaticCycles.Mixer1 mixer annotation (Placement(transformation(extent={{0,-98},{18,-88}})));
equation
  connect(boiler.liveSteam, turbine_HP.inlet) annotation (Line(
      points={{-150,62.4},{-150,136},{-129,136}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.reheat_out, turbine_LP.inlet) annotation (Line(
      points={{-146,62.4},{-146,148},{-70,148},{-70,142},{-69,142},{-69,136}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.cond_out, pump_fw.inlet) annotation (Line(
      points={{-59.2,-88.3333},{-96,-88.3333},{-96,-88},{-119.6,-88}},
      color={0,131,169},
      smooth=Smooth.None));

  connect(pump_cond.inlet, condenser.outlet) annotation (Line(
      points={{124.4,-90},{150,-90},{150,5.6}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP2.outlet, condenser.inlet) annotation (Line(
      points={{117.667,110},{150,110},{150,26.4}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_in, pump_cond.outlet) annotation (Line(
      points={{80.4,-90},{103.6,-90}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.tap_in, valve_LP1.outlet) annotation (Line(
      points={{70,-79.6},{70,-2.8},{71,-2.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_preheater.inlet, preheater_LP1.tap_out) annotation (Line(
      points={{40.4,-110},{70,-110},{70,-100.4}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer.inlet_2, pump_preheater.outlet) annotation (Line(
      points={{9,-97.3333},{9,-110},{19.6,-110}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_out, mixer.inlet_1) annotation (Line(
      points={{59.6,-90},{56,-90},{56,-89.6667},{17.1,-89.6667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer.outlet, feedwatertank.cond_in) annotation (Line(
      points={{0.72,-89.6667},{-20.8,-89.6667},{-20.8,-88.3333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.tap_in, valve_LP.outlet) annotation (Line(
      points={{-40,-75.6667},{-40,6.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP.outlet, split_LP.inlet) annotation (Line(
      points={{-60.3333,124},{-50,124},{-50,124.333},{-49.4,124.333}},
      color={0,131,169},
      smooth=Smooth.None));

  connect(turbine_LP1.outlet, split_LP1.inlet) annotation (Line(
      points={{31.6667,122},{62.6,122}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_1, turbine_LP2.inlet) annotation (Line(
      points={{81.4,122},{109,122}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_2, valve_LP1.inlet) annotation (Line(
      points={{72,112.6},{71,112.6},{71,18.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_2, valve_LP.inlet) annotation (Line(
      points={{-40,116.5},{-40,27.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_fw.outlet, boiler.feedwater) annotation (Line(
      points={{-140.4,-88},{-150,-88},{-150,41.6}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_HP.outlet, boiler.reheat_in) annotation (Line(
      points={{-120.333,124},{-108,124},{-108,24},{-146,24},{-146,41.6}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_1, turbine_LP1.inlet) annotation (Line(points={{-30.6,124.333},{-3.3,124.333},{-3.3,134},{23,134}}, color={0,131,169}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, initialScale=0.1),
                   graphics),      Diagram(coordinateSystem(preserveAspectRatio=false,
        initialScale=0.1,
        extent={{-160,-120},{180,160}})),
    experiment(
      StopTime=20000,
      NumberOfIntervals=5000,
      Tolerance=1e-005),
    __Dymola_experimentSetupOutput);
end InitSteamCycle_Rostock_3_1;
