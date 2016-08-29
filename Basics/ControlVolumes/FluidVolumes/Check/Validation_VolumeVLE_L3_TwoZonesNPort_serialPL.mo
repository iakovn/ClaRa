within ClaRa.Basics.ControlVolumes.FluidVolumes.Check;
model Validation_VolumeVLE_L3_TwoZonesNPort_serialPL
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

extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  import SI = ClaRa.Basics.Units;

  parameter Units.EnthalpyMassSpecific
                                    h_in =  TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), p);
  parameter Units.EnthalpyMassSpecific
                                    h_out = TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), p);
  parameter Units.MassFlowRate
                            m_flow_D=1;

  parameter Units.Velocity
                        w_inf = 71.3;
  parameter Units.Temperature
                           T_w = T_s - 1.01;
  parameter Units.Temperature
                           T_s = 22.07 + 273.15;
  parameter Units.Length
                      diameter_shell_o= 0.092 "Outer diameter of shell";
  parameter Units.Length
                      diameter_tube_o= 0.014 "Outer diameter of tube";

  parameter Units.Pressure
                        p =  2.1e5;
  parameter Units.EnthalpyMassSpecific
                                    h = TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_Txi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),T_s);

  Real eta_l = TILMedia.VLEFluidFunctions.dynamicViscosity_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p, T_w,{0});
  Real cp_l =  TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p, T_w,{0});
  Real lambda_l = TILMedia.VLEFluidFunctions.thermalConductivity_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p, T_w,{0});
  Real rho_liq = TILMedia.VLEFluidFunctions.density_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p, T_w,{0});
  Real h_l = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p,T_w,{0});

  Real alpha "Heat transfer coefficient";
  Real Pr "Prandtl number of the film";
  Real Re "Reynolds number of flowing steam";
  Real Nu "Nusselt number";
  Real failureStatus
    "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";

//  Real Re_test;

  VolumeVLE_L3_TwoZonesNPort Volume_3inlet_serial(
    p_start(displayUnit="Pa") = p + 30,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L3,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealMixed,
    heatSurfaceAlloc=1,
    initType=ClaRa.Basics.Choices.Init.steadyEnthalpy,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (                       N_inlet=3),
    p_nom(displayUnit="Pa"),
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearSerialZones_L3)
    "max(0.000001, ((1 - Volume.bulk.q)*Volume.M))/noEvent(max(Volume.bulk.VLE.d_l, Volume.bulk.d))"
                                                                                          annotation (Placement(transformation(extent={{52,-80},{32,-60}})));

  Components.BoundaryConditions.BoundaryVLE_hxim_flow MassFlowSource(
    variable_m_flow=true,
    variable_h=true,
    p_nom(displayUnit="Pa")) annotation (Placement(transformation(extent={{110,-80},{90,-60}})));
  Components.BoundaryConditions.BoundaryVLE_phxi      MassFlowSink(
    h_const=h_in,
    variable_h=true,
    m_flow_nom=m_flow_D,
    p_const=2e5)         annotation (Placement(transformation(extent={{-38,-80},{-18,-60}})));
  inner SimCenter simCenter(redeclare replaceable
      TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater                                             fluid1, useHomotopy=true) annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  TILMedia.VLEFluid_ph vleFluid(
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater vleFluidType,
    computeTransportProperties=true,
    computeVLEAdditionalProperties=true,
    computeVLETransportProperties=true,
    p=p,
    h=h)
        annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Modelica.Blocks.Sources.Constant const1(k=h_in)
              annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Modelica.Blocks.Sources.Step const2(offset=1, startTime=100) annotation (Placement(transformation(extent={{160,-60},{140,-40}})));
  Modelica.Blocks.Sources.Constant const3(k=h_in) annotation (Placement(transformation(extent={{160,-100},{140,-80}})));
  VolumeVLE_L3_TwoZonesNPort Volume_3inlet_parallel(
    p_start(displayUnit="Pa") = p + 30,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L3,
    heatSurfaceAlloc=1,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (                       N_inlet=3),
    p_nom(displayUnit="Pa"),
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3,
    initType=ClaRa.Basics.Choices.Init.steadyDensity,
    level_rel_start=0.3,
    redeclare model PhaseBorder =
        Fundamentals.SpacialDistribution.RealMixed)
    "max(0.000001, ((1 - Volume.bulk.q)*Volume.M))/noEvent(max(Volume.bulk.VLE.d_l, Volume.bulk.d))"
                                                                                          annotation (Placement(transformation(extent={{50,-10},{30,10}})));
  Components.BoundaryConditions.BoundaryVLE_hxim_flow MassFlowSource1(
    variable_m_flow=true,
    variable_h=true,
    p_nom(displayUnit="Pa")) annotation (Placement(transformation(extent={{108,-10},{88,10}})));
  Components.BoundaryConditions.BoundaryVLE_phxi      MassFlowSink1(
    h_const=h_in,
    variable_h=true,
    m_flow_nom=m_flow_D,
    p_const=2e5)         annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.Constant const4(k=h_in)
              annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  Modelica.Blocks.Sources.Step const5(offset=1, startTime=100) annotation (Placement(transformation(extent={{158,10},{138,30}})));
  Modelica.Blocks.Sources.Constant const6(k=h_in) annotation (Placement(transformation(extent={{158,-30},{138,-10}})));
  VolumeVLE_L3_TwoZonesNPort Volume_1inlet_parallel(
    p_start(displayUnit="Pa") = p + 30,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L3,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealMixed,
    heatSurfaceAlloc=1,
    initType=ClaRa.Basics.Choices.Init.steadyEnthalpy,
    p_nom(displayUnit="Pa"),
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock)
    "max(0.000001, ((1 - Volume.bulk.q)*Volume.M))/noEvent(max(Volume.bulk.VLE.d_l, Volume.bulk.d))"
                                                                                          annotation (Placement(transformation(extent={{310,6},{290,26}})));
  Components.BoundaryConditions.BoundaryVLE_hxim_flow MassFlowSource2(
    variable_m_flow=true,
    variable_h=true,
    p_nom(displayUnit="Pa")) annotation (Placement(transformation(extent={{368,6},{348,26}})));
  Components.BoundaryConditions.BoundaryVLE_phxi      MassFlowSink2(
    h_const=h_in,
    variable_h=true,
    m_flow_nom=m_flow_D,
    p_const=2e5)         annotation (Placement(transformation(extent={{220,6},{240,26}})));
  Modelica.Blocks.Sources.Constant const7(k=h_in)
              annotation (Placement(transformation(extent={{178,6},{198,26}})));
  Modelica.Blocks.Sources.Step const8(offset=1, startTime=100) annotation (Placement(transformation(extent={{418,26},{398,46}})));
  Modelica.Blocks.Sources.Constant const9(k=h_in) annotation (Placement(transformation(extent={{418,-14},{398,6}})));
  VolumeVLE_L3_TwoZonesNPort Volume_1inlet_serial(
    p_start(displayUnit="Pa") = p + 30,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L3,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealMixed,
    heatSurfaceAlloc=1,
    initType=ClaRa.Basics.Choices.Init.steadyEnthalpy,
    p_nom(displayUnit="Pa"),
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearSerialZones_L3,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock)
    "max(0.000001, ((1 - Volume.bulk.q)*Volume.M))/noEvent(max(Volume.bulk.VLE.d_l, Volume.bulk.d))"
                                                                                          annotation (Placement(transformation(extent={{312,-80},{292,-60}})));
  Components.BoundaryConditions.BoundaryVLE_hxim_flow MassFlowSource3(
    variable_m_flow=true,
    variable_h=true,
    p_nom(displayUnit="Pa")) annotation (Placement(transformation(extent={{370,-80},{350,-60}})));
  Components.BoundaryConditions.BoundaryVLE_phxi      MassFlowSink3(
    h_const=h_in,
    variable_h=true,
    m_flow_nom=m_flow_D,
    p_const=2e5)         annotation (Placement(transformation(extent={{222,-80},{242,-60}})));
  Modelica.Blocks.Sources.Constant const10(
                                          k=h_in)
              annotation (Placement(transformation(extent={{180,-80},{200,-60}})));
  Modelica.Blocks.Sources.Step const11(
                                      offset=1, startTime=100) annotation (Placement(transformation(extent={{420,-60},{400,-40}})));
  Modelica.Blocks.Sources.Constant const12(
                                          k=h_in) annotation (Placement(transformation(extent={{420,-100},{400,-80}})));
equation

(alpha, Pr,Re,Nu,failureStatus)=FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam(
FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_con(d=diameter_tube_o, A_front=Modelica.Constants.pi/4*diameter_shell_o ^2),
FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_var(cp_l=vleFluid.VLEAdditional.cp_l, lambda_l=vleFluid.VLETransp.lambda_l, rho_g=vleFluid.VLE.d_v, rho_l=vleFluid.VLE.d_l, eta_g=vleFluid.VLETransp.eta_v, eta_l=vleFluid.VLETransp.eta_l, T_s=T_s, dh_lg=vleFluid.VLE.h_v-vleFluid.VLE.h_l, m_flow=vleFluid.d*w_inf*Modelica.Constants.pi/4*diameter_shell_o ^2, T_w=T_w));

//Re_test=m_flow_D/(Modelica.Constants.pi/4*diameter_shell_o ^2)/(Volume.iCom.d_dew)*diameter_tube_o/(Volume.iCom.eta_bub/Volume.iCom.d_bub);
  connect(const1.y, MassFlowSink.h) annotation (Line(
      points={{-59,-70},{-38,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MassFlowSink.steam_a, Volume_3inlet_serial.outlet[1]) annotation (Line(
      points={{-18,-70},{32,-70}},
      color={0,131,169},
      thickness=0.5));
  connect(const2.y, MassFlowSource.m_flow) annotation (Line(points={{139,-50},{132,-50},{132,-64},{112,-64}}, color={0,0,127}));
  connect(const3.y, MassFlowSource.h) annotation (Line(points={{139,-90},{130,-90},{130,-70},{112,-70}}, color={0,0,127}));
  connect(MassFlowSource.steam_a, Volume_3inlet_serial.inlet[1]) annotation (Line(
      points={{90,-70},{72,-70},{52,-70}},
      color={0,131,169},
      thickness=0.5));
  connect(MassFlowSource.steam_a, Volume_3inlet_serial.inlet[2]) annotation (Line(
      points={{90,-70},{52,-70}},
      color={0,131,169},
      thickness=0.5));
  connect(MassFlowSource.steam_a, Volume_3inlet_serial.inlet[3]) annotation (Line(
      points={{90,-70},{71,-70},{52,-70}},
      color={0,131,169},
      thickness=0.5));
  connect(const4.y, MassFlowSink1.h) annotation (Line(
      points={{-61,0},{-40,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MassFlowSink1.steam_a, Volume_3inlet_parallel.outlet[1]) annotation (Line(
      points={{-20,0},{30,0}},
      color={0,131,169},
      thickness=0.5));
  connect(const5.y, MassFlowSource1.m_flow) annotation (Line(points={{137,20},{130,20},{130,6},{110,6}}, color={0,0,127}));
  connect(const6.y, MassFlowSource1.h) annotation (Line(points={{137,-20},{128,-20},{128,0},{110,0}}, color={0,0,127}));
  connect(MassFlowSource1.steam_a, Volume_3inlet_parallel.inlet[1]) annotation (Line(
      points={{88,0},{70,0},{50,0}},
      color={0,131,169},
      thickness=0.5));
  connect(MassFlowSource1.steam_a, Volume_3inlet_parallel.inlet[2]) annotation (Line(
      points={{88,0},{50,0}},
      color={0,131,169},
      thickness=0.5));
  connect(MassFlowSource1.steam_a, Volume_3inlet_parallel.inlet[3]) annotation (Line(
      points={{88,0},{69,0},{50,0}},
      color={0,131,169},
      thickness=0.5));
  connect(const7.y,MassFlowSink2. h) annotation (Line(
      points={{199,16},{220,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MassFlowSink2.steam_a, Volume_1inlet_parallel.outlet[1]) annotation (Line(
      points={{240,16},{290,16}},
      color={0,131,169},
      thickness=0.5));
  connect(const8.y,MassFlowSource2. m_flow) annotation (Line(points={{397,36},{390,36},{390,22},{370,22}},
                                                                                          color={0,0,127}));
  connect(const9.y,MassFlowSource2. h) annotation (Line(points={{397,-4},{388,-4},{388,16},{370,16}}, color={0,0,127}));
  connect(MassFlowSource2.steam_a, Volume_1inlet_parallel.inlet[1]) annotation (Line(
      points={{348,16},{330,16},{310,16}},
      color={0,131,169},
      thickness=0.5));
  connect(const10.y, MassFlowSink3.h) annotation (Line(
      points={{201,-70},{222,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MassFlowSink3.steam_a, Volume_1inlet_serial.outlet[1]) annotation (Line(
      points={{242,-70},{268,-70},{292,-70}},
      color={0,131,169},
      thickness=0.5));
  connect(const11.y, MassFlowSource3.m_flow) annotation (Line(points={{399,-50},{392,-50},{392,-64},{372,-64}}, color={0,0,127}));
  connect(const12.y, MassFlowSource3.h) annotation (Line(points={{399,-90},{390,-90},{390,-70},{372,-70}}, color={0,0,127}));
  connect(MassFlowSource3.steam_a, Volume_1inlet_serial.inlet[1]) annotation (Line(
      points={{350,-70},{312,-70}},
      color={0,131,169},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(extent={{-100,-140},{440,120}},
          preserveAspectRatio=false),
                      graphics={Text(
          extent={{-110,110},{110,110}},
          lineColor={0,128,0},
          fontSize=27,
          textString="Validated -- 2013-01-22 //AR"),
                                Text(
          extent={{-100,100},{180,0}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="_______________________________________________________________________________________
PURPOSE:
>> compare L3 pressure loss models
_______________________________________________________________________________________


")}),
    experiment(
      StopTime=50000,
      NumberOfIntervals=10000,
      Tolerance=1e-006,
      Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equdistant=false),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics));
end Validation_VolumeVLE_L3_TwoZonesNPort_serialPL;
