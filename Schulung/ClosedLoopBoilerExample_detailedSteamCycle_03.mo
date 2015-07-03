within ClaRa.Schulung;
model ClosedLoopBoilerExample_detailedSteamCycle_03
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;

  inner SimCenter simCenter(
    redeclare ClaRa.Basics.Media.Fuel.Coal_Reference fuelModel1,
    redeclare ClaRa.Basics.Media.Fuel.Slag_v2 slagModel,
    useHomotopy=false,
    redeclare TILMedia.GasTypes.FlueGasTILMedia flueGasModel,
    contributeToCycleSummary=true,
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1)
                                                              annotation (Placement(transformation(extent={{420,360},{460,380}})));

  Components.Adapters.CoalSlagFlueGas_split                      coalSlagFlueGas_split_top
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={42,290})));
  Components.BoundaryConditions.BoundarySlag_Tm_flow
                                               slagFlowSource_top(m_flow_const=0.0, T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={42,340})));
  Components.BoundaryConditions.BoundaryCoal_pTxi coalSink_top(T_const=658.15)
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={18,342})));
  Components.BoundaryConditions.BoundaryCoal_Txim_flow
                                               coalFlowSource(
    xi_const={0.661,0.0383,0.066,0.016,0.0057,0.135},
    m_flow_const=15,
    variable_m_flow=true,
    T_const=293.15) annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Components.Adapters.CoalGas_join
                        coalGas_join_burner(coal_inlet(xi_outflow(start={0.661,
            0.0383,0.066,0.016,0.0057,0.135})))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-56,4})));
  Components.Adapters.CoalSlagFlueGas_join
    coalSlagFlueGas_join
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={42,-70})));
  Components.BoundaryConditions.BoundaryGas_Txim_flow
                                                fluelGasFlowSource_bottom(
    m_flow_const=0.0,
    T_const=293.15,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={62,-108})));
  Components.BoundaryConditions.BoundaryCoal_Txim_flow
                                               coalFlowSource_bottom(
    xi_const={0.86,0.035,0.025,0.014,0.007,0.0505},
    m_flow_const=0,
    T_const=293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={22,-110})));
  Components.BoundaryConditions.BoundarySlag_pT    slaglSink_bottom(T_const=
        373.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={42,-110})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperatureBottom(Q_flow=0)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={102,-66})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop(T=658.15)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={116,318})));
  Components.Furnace.Burner.Burner_L2_Dynamic burner1(
    T_slag=873,
    LHV_calculationType="fixed",
    LHV_fixed=25.1e6/0.91,
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (            w_initial=5),
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (
                                                                                                suspension_calculationType="Calculated"),
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (suspension_calculationType="Calculated", CF_fouling=0.95),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=11,
        z_in={3},
        z_out={13},
        length=11,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        height=7.5),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.1),
    T_start_flueGas_out=1620,
    m_flow_nom=500)                                                                             annotation (Placement(transformation(extent={{28,-6},{88,14}})));

  Components.Furnace.Hopper.Hopper_L2 hopper(
    flueGasOutlet(h(start=-22790)),
    SlagTemperature=873,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=
          10,
        z_in={0},
        z_out={3},
        height=
          3,
        length=
          10,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal),
    T_start_flueGas_out=780,
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (
        emissivity_source_calculationType="Calculate",
        emissivity_sink_calculationType="Calculate",
        absorbance_source_calculationType="Calculate",
        suspension_calculationType="Gas calculated, particles fixed"),
    xi_start_flueGas_out={0.0103,0,0.2270,0.001,0.6999,0.0225,0,0.0393,0},
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (suspension_calculationType="Calculated", CF_fouling=0.95))
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={58,-30})));

  Components.Furnace.Burner.Burner_L2_Dynamic burner2(
    T_slag=873,
    LHV_calculationType="fixed",
    LHV_fixed=25.1e6/0.91,
    xi_coal_in(start={0.661,0.0383,0.066,0.016,0.0057,0.135}),
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (            w_initial=15),
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (
                                                                                                suspension_calculationType="Calculated"),
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (suspension_calculationType="Calculated", CF_fouling=0.95),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=11,
        z_in={13},
        z_out={23},
        length=11,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        height=7.5),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.1),
    T_start_flueGas_out=1370,
    m_flow_nom=500)                                                                             annotation (Placement(transformation(extent={{28,24},{88,44}})));

  Components.BoundaryConditions.BoundaryCoal_Txim_flow
                                               coalFlowSource1(
    xi_const={0.661,0.0383,0.066,0.016,0.0057,0.135},
    m_flow_const=15,
    variable_m_flow=true,
    T_const=293.15) annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Components.Adapters.CoalGas_join
                        coalGas_join_burner1
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-56,34})));
  Components.Furnace.FlameRoom.FlameRoomAdditionalAir_L2_Dynamic
                                                            flameRoom_1(
    LHV_fixed=25.1e6/0.91,
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (
         w_initial=16),
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (
         suspension_calculationType="Calculated"),
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (suspension_calculationType="Calculated", CF_fouling=0.95),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=11,
        z_in={23},
        z_out={33},
        length=11,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        height=5),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.1),
    T_start_flueGas_out=1370,
    m_flow_nom=500)
    annotation (Placement(transformation(extent={{28,52},{88,72}})));

  Components.Furnace.FlameRoom.FlameRoom_L2_Dynamic
                                               flameRoom_2(
    LHV_fixed=25.1e6/0.91,
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (
         w_initial=16),
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (
         suspension_calculationType="Calculated"),
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=11,
        z_out={50},
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        z_in={33},
        length=11,
        height=18),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (suspension_calculationType="Calculated", CF_fouling=0.95),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.1),
    T_start_flueGas_out=1320,
    m_flow_nom=500)
    annotation (Placement(transformation(extent={{28,82},{88,102}})));

  Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic
                                                             flameRoom_oh_1(
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    LHV_fixed=25.1e6/0.91,
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (
         w_initial=13),
    redeclare model Burning_time =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (
         Tau_burn_const =      1.3),
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=80),
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (alpha_nom=30),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        width=11,
        length=11,
        diameter_t=0.04,
        Delta_z_par=0.1,
        Delta_z_ort=0.1,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        N_rows=40,
        N_tubes=3000,
        height=6),
    redeclare model HeatTransfer_TubeBundle = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (
        epsilon_gas_calculationType="Calculated",
        alpha_gas_calculationType="Calculated",
        CF_fouling=0.95),
    T_start_flueGas_out=680,
    m_flow_nom=500)
    annotation (Placement(transformation(extent={{28,112},{88,132}})));

  Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic
                                                             flameRoom_oh_2(
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    LHV_fixed=25.1e6/0.91,
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (
         w_initial=9),
    redeclare model Burning_time =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (
         Tau_burn_const =      1.3),
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=20),
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (alpha_nom=30),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        width=11,
        length=11,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        diameter_t=0.04,
        Delta_z_par=0.1,
        Delta_z_ort=0.1,
        N_rows=40,
        N_tubes=4000,
        height=6),
    redeclare model HeatTransfer_TubeBundle = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (
        epsilon_gas_calculationType="Calculated",
        alpha_gas_calculationType="Calculated",
        CF_fouling=0.95),
    T_start_flueGas_out=530,
    m_flow_nom=500)
    annotation (Placement(transformation(extent={{28,158},{88,178}})));

  Components.BoundaryConditions.BoundaryCoal_Txim_flow
                                               coalFlowSource2(
    xi_const={0.661,0.0383,0.066,0.016,0.0057,0.135},
    m_flow_const=0,
    T_const=293.15) annotation (Placement(transformation(extent={{-140,58},{-120,78}})));
  Components.BoundaryConditions.BoundaryGas_Txim_flow
                                                fluelGasFlowSource2(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=2*10.396,
    T_const=573.15,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01}) annotation (Placement(transformation(extent={{-122,46},{-102,66}})));
  Components.Adapters.CoalGas_join
                        coalGas_join_burner2
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-56,62})));
  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple evap(
    diameter_i=0.03,
    z_in=0,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (                      alpha_nom=20000),
    length=80,
    z_out=80,
    frictionAtInlet=true,
    initType=ClaRa.Basics.Choices.Init.noInit,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4,
    h_start=linspace(
        697563,
        2.21373e6,
        evap.N_cv),
    p_start=linspace(
        296.9e5,
        290.2e5,
        evap.N_cv),
    N_tubes=400,
    frictionAtOutlet=false,
    N_cv=9,
    m_flow_nom=NOM.m_flow_nom,
    Delta_p_nom=NOM.Delta_p_LS_nom/5,
    p_nom=linspace(
        NOM.p_LS_out_nom + NOM.Delta_p_LS_nom*4/5,
        NOM.p_LS_out_nom + NOM.Delta_p_LS_nom*3/5,
        evap.N_cv),
    h_nom=linspace(
        1000e3 + (2300e3)*1/5,
        1000e3 + 2300e3*2/5,
        evap.N_cv))                annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={266,62})));
  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple ct(
    diameter_i=0.03,
    length=30,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (                      alpha_nom=10000),
    z_in=80,
    z_out=50,
    frictionAtInlet=true,
    initType=ClaRa.Basics.Choices.Init.noInit,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4,
    h_start=linspace(
        2.21373e6,
        2.21525e6,
        ct.N_cv),
    p_start=linspace(
        290.2e5,
        287.43e5,
        ct.N_cv),
    N_tubes=160,
    frictionAtOutlet=false,
    N_cv=4,
    m_flow_nom=NOM.m_flow_nom,
    Delta_p_nom=NOM.Delta_p_LS_nom/5,
    p_nom=linspace(
        NOM.p_LS_out_nom + NOM.Delta_p_LS_nom*3/5,
        NOM.p_LS_out_nom + NOM.Delta_p_LS_nom*2/5,
        ct.N_cv),
    h_nom=linspace(
        1000e3 + (2300e3)*2/5,
        1000e3 + 2300e3*3/5,
        ct.N_cv))
            annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=-90,
        origin={338,202})));
  Basics.ControlVolumes.SolidVolumes.ThinWall_L4 evap_wall(
    diameter_i=evap.diameter_i,
    length=evap.length,
    N_tubes=evap.N_tubes,
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=evap.N_cv,
    diameter_o=evap.diameter_i + 0.01,
    T_start=ones(evap_wall.N_ax)*(273.15 + 300),
    initChoice=ClaRa.Basics.Choices.Init.steadyTemperature,
    suppressChattering="True",
    stateLocation=3)            annotation (Placement(transformation(
        extent={{-12,-4.00036},{12,4.00035}},
        rotation=90,
        origin={232,62})));
  Basics.ControlVolumes.SolidVolumes.ThinWall_L4 ct_wall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    stateLocation=3,
    N_ax=ct.N_cv,
    diameter_o=ct.diameter_i + 0.01,
    diameter_i=ct.diameter_i,
    length=ct.length,
    N_tubes=ct.N_tubes,
    T_start=ones(ct_wall.N_ax)*(273.15 + 395),
    initChoice=ClaRa.Basics.Choices.Init.steadyTemperature,
    suppressChattering="False") annotation (Placement(transformation(
        extent={{-12,-4.00036},{12,4.00035}},
        rotation=90,
        origin={292,202})));
  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple oh_1(
    diameter_i=0.03,
    N_cv=4,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (                      alpha_nom=10000),
    z_in=60,
    z_out=50,
    frictionAtInlet=true,
    initType=ClaRa.Basics.Choices.Init.noInit,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4,
    length=300,
    h_start=linspace(
        2.21525e6,
        3.3501e6,
        oh_1.N_cv),
    p_start=linspace(
        287.43e5,
        275.699e5,
        oh_1.N_cv),
    N_tubes=400,
    frictionAtOutlet=false,
    m_flow_nom=NOM.m_flow_nom,
    Delta_p_nom=NOM.Delta_p_LS_nom/5,
    p_nom=linspace(
        NOM.p_LS_out_nom + NOM.Delta_p_LS_nom*2/5,
        NOM.p_LS_out_nom + NOM.Delta_p_LS_nom/5,
        oh_1.N_cv),
    h_nom=linspace(
        1000e3 + (2300e3)*3/5,
        1000e3 + 2300e3*4/5,
        oh_1.N_cv))                annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=-90,
        origin={338,112})));
  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple oh_2(
    diameter_i=0.03,
    N_cv=4,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (                      alpha_nom=10000),
    z_in=60,
    z_out=70,
    frictionAtInlet=true,
    initType=ClaRa.Basics.Choices.Init.noInit,
    length=300,
    h_start=linspace(
        3.3501e6,
        3.545e6,
        oh_2.N_cv),
    p_start=linspace(
        275.699e5,
        260e5,
        oh_2.N_cv),
    N_tubes=400,
    frictionAtOutlet=false,
    showData=true,
    m_flow_nom=NOM.m_flow_nom,
    Delta_p_nom=NOM.Delta_p_LS_nom/5,
    p_nom=linspace(
        NOM.p_LS_out_nom + NOM.Delta_p_LS_nom/5,
        NOM.p_LS_out_nom,
        oh_2.N_cv),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4,
    h_nom=linspace(
        NOM.boiler.h_LS_in + (2300e3)*4/5,
        1000e3 + 2300e3*5/5,
        oh_2.N_cv))                annotation (Placement(transformation(
        extent={{10,6},{-10,-6}},
        rotation=-90,
        origin={398,158})));
  Basics.ControlVolumes.SolidVolumes.ThinWall_L4 oh_1_wall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    stateLocation=3,
    N_ax=oh_1.N_cv,
    diameter_o=oh_1.diameter_i + 0.01,
    diameter_i=oh_1.diameter_i,
    length=oh_1.length,
    N_tubes=oh_1.N_tubes,
    T_start=ones(oh_1_wall.N_ax)*(273.15 + 330),
    initChoice=ClaRa.Basics.Choices.Init.steadyTemperature,
    suppressChattering="False") annotation (Placement(transformation(
        extent={{-12,-4.00036},{12,4.00034}},
        rotation=90,
        origin={292,112})));
  Basics.ControlVolumes.SolidVolumes.ThinWall_L4 oh_2_wall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    stateLocation=3,
    N_ax=oh_2.N_cv,
    diameter_o=oh_2.diameter_i + 0.01,
    diameter_i=oh_2.diameter_i,
    length=oh_2.length,
    N_tubes=oh_2.N_tubes,
    T_start=ones(oh_2_wall.N_ax)*(273.15 + 400),
    initChoice=ClaRa.Basics.Choices.Init.steadyTemperature,
    suppressChattering="False") annotation (Placement(transformation(
        extent={{-12,-3.99984},{12,3.99984}},
        rotation=90,
        origin={292,158})));
  Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort2(
    length=oh_1.length,
    N=oh_1.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        oh_1.length,
        oh_1.N_cv)) annotation (Placement(transformation(extent={{220,102},{240,122}})));
  Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort3(
    length=100,
    N=4,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        100,
        4)) annotation (Placement(transformation(extent={{220,148},{240,168}})));
  Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic
                                                             flameRoom_eco(
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    LHV_fixed=25.1e6/0.91,
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=20),
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (alpha_nom=30),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        width=11,
        length=11,
        diameter_t=0.04,
        Delta_z_par=0.13,
        Delta_z_ort=0.11,
        N_rows=40,
        N_tubes=4000,
        height=5),
    redeclare model HeatTransfer_TubeBundle = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_tubeBank_L2 (CF_fouling=0.95),
    T_start_flueGas_out=390,
    m_flow_nom=500)
    annotation (Placement(transformation(extent={{28,242},{88,262}})));

  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple eco(
    N_cv=7,
    diameter_i=0.03,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (                      alpha_nom=20000),
    N_tubes=150,
    z_in=80,
    z_out=70,
    frictionAtInlet=false,
    initType=ClaRa.Basics.Choices.Init.noInit,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4,
    length=300,
    h_start=linspace(
        99766,
        697563,
        eco.N_cv),
    p_start=linspace(
        297.3e5,
        296.9e5,
        eco.N_cv),
    frictionAtOutlet=false,
    m_flow_nom=NOM.m_flow_nom,
    Delta_p_nom=NOM.Delta_p_LS_nom/5,
    p_nom=linspace(
        NOM.p_LS_out_nom + NOM.Delta_p_LS_nom*5/5,
        NOM.p_LS_out_nom + NOM.Delta_p_LS_nom*4/5,
        eco.N_cv),
    h_nom=linspace(
        1000e3 + (2300e3)*0/5,
        1000e3 + 2300e3*1/5,
        eco.N_cv))                annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={266,-20})));
  Basics.ControlVolumes.SolidVolumes.ThinWall_L4 eco_wall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=eco.N_cv,
    diameter_o=eco.diameter_i + 0.01,
    diameter_i=eco.diameter_i,
    length=eco.length,
    N_tubes=eco.N_tubes,
    T_start=ones(eco_wall.N_ax)*(273.15 + 280),
    stateLocation=3,
    initChoice=ClaRa.Basics.Choices.Init.steadyTemperature,
    suppressChattering="False") annotation (Placement(transformation(
        extent={{-12,-3.99985},{12,3.99985}},
        rotation=90,
        origin={232,-20})));
  Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort4(
    length=eco.length,
    N=eco.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco.length,
        eco.N_cv)) annotation (Placement(transformation(extent={{192,-30},{212,-10}})));
  Components.Utilities.Blocks.LimPID PID_lambda(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ni=0.90,
    y_max=600,
    y_min=100,
    y_start=28*10.396,
    sign=1,
    u_ref=1.12,
    y_ref=28*10.369,
    k=1,
    y_inactive=28*10.369,
    t_activation=0,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    Tau_i=1)
    annotation (Placement(transformation(extent={{-314,186},{-294,166}})));
  Modelica.Blocks.Sources.RealExpression actual_lambda(y=burner1.lambdaComb_primary) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-356,206})));
  Modelica.Blocks.Sources.Ramp lambda(
    offset=1.12,
    duration=1000,
    startTime=4000,
    height=0.03)
    annotation (Placement(transformation(extent={{-366,166},{-346,186}})));
  Modelica.Blocks.Sources.Ramp coalMassFlow(
    startTime=4000,
    duration=1000,
    height=-0.03*15,
    offset=22.7)
    annotation (Placement(transformation(extent={{-194,36},{-174,56}})));
  Components.Mills.HardCoalMills.VerticalMill_L3 mill(initChoice=ClaRa.Basics.Choices.Init.steadyState)
    annotation (Placement(transformation(extent={{-12,-6},{8,14}})));
  Components.Mills.HardCoalMills.VerticalMill_L3 mill1(initChoice=ClaRa.Basics.Choices.Init.steadyState)
    annotation (Placement(transformation(extent={{-34,24},{-14,44}})));
  Components.BoundaryConditions.BoundaryGas_pTxi
    flueGasPressureSink2(p_const=101300)
    annotation (Placement(transformation(extent={{-172,160},{-192,180}})));
  Components.BoundaryConditions.BoundaryGas_Txim_flow
                                                fluelGasFlowSource4(
    variable_T=false,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    m_flow_const=291,
    variable_m_flow=true,
    T_const=313.15) annotation (Placement(transformation(extent={{-264,160},{-244,180}})));
  Components.HeatExchangers.RegenerativeAirPreheater_L4_array regenerativeAirPreheater(
    s_sp=0.6e-3,
    redeclare model Material = TILMedia.SolidTypes.TILMedia_St35_8,
    A_flueGas=0.45*(regenerativeAirPreheater.A_cross - regenerativeAirPreheater.A_hub),
    A_air=0.45*(regenerativeAirPreheater.A_cross - regenerativeAirPreheater.A_hub),
    diameter_reg=10,
    height_reg=3,
    N_sp=1000,
    N_cv=10,
    Delta_p_flueGas_nom=1000,
    Delta_p_freshAir_nom=1000,
    m_flow_freshAir_nom=291,
    m_flow_flueGas_nom=341,
    xi_start_flueGas={0.01,0,0.25,0,0.7,0,0,0.04,0},
    xi_start_freshAir={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    T_start_wall={385,675},
    T_start_flueGas={677,398},
    T_start_freshAir={376,673},
    p_start_flueGas={100002,99000},
    frictionAtFlueGasInlet=false,
    frictionAtFlueGasOutlet=false,
    frictionAtFreshAirInlet=false,
    frictionAtFreshAirOutlet=true,
    p_start_freshAir={142169,141311},
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4)
                                   annotation (Placement(transformation(extent={{-226,154},{-206,174}})));

  Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2
    flueGasJunction1(
    volume=1,
    portA(m_flow(fixed=false)),
    portB(m_flow(fixed=false)),
    mixingRatio_initial={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    T_start=273.15 + 40,
    p_start=1.4e5)                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-216,130})));
  Components.VolumesValvesFittings.Valves.ValveGas_L1     flueGasValve_L1_1(
      redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         Delta_p_nom=1000, m_flow_nom=200))
    annotation (Placement(transformation(extent={{-160,124},{-140,138}})));

  Components.VolumesValvesFittings.Valves.ValveGas_L1     flueGasValve_L1_2(
      redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         Delta_p_nom=1000, m_flow_nom=200))
    annotation (Placement(transformation(extent={{-160,94},{-140,108}})));

  Modelica.Blocks.Sources.RealExpression classifierSpeed1(y=1.50) annotation (Placement(transformation(extent={{-64,94},{-38,112}})));
  Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameroom_ZUE(
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    LHV_fixed=25.1e6/0.91,
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant = ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (Tau=0.1),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=20),
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (alpha_nom=30),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        width=11,
        length=11,
        diameter_t=0.04,
        Delta_z_par=0.13,
        Delta_z_ort=0.11,
        N_rows=40,
        N_tubes=4000,
        height=5),
    redeclare model HeatTransfer_TubeBundle = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_tubeBank_L2 (CF_fouling=0.95),
    T_start_flueGas_out=390,
    m_flow_nom=500) annotation (Placement(transformation(extent={{28,200},{88,220}})));
  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple ZUE(
    diameter_i=0.03,
    N_cv=4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=10000),
    z_in=60,
    z_out=50,
    frictionAtInlet=true,
    initType=ClaRa.Basics.Choices.Init.noInit,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4,
    length=300,
    N_tubes=400,
    Delta_p_nom=2e5,
    frictionAtOutlet=false,
    m_flow_nom=373.18,
    h_start=linspace(
        2.96193e6,
        3.5728e6,
        ZUE.N_cv),
    p_start=linspace(
        55.95e5,
        51e5,
        ZUE.N_cv),
    showData=true,
    p_nom=linspace(
        45e5,
        43e5,
        ZUE.N_cv),
    h_nom=linspace(
        3200e3,
        3450e3,
        ZUE.N_cv)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={364,258})));
  Basics.ControlVolumes.SolidVolumes.ThinWall_L4 ZUE_wall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    stateLocation=3,
    N_ax=oh_1.N_cv,
    diameter_o=oh_1.diameter_i + 0.01,
    diameter_i=oh_1.diameter_i,
    length=oh_1.length,
    N_tubes=oh_1.N_tubes,
    T_start=ones(oh_1_wall.N_ax)*(273.15 + 330),
    initChoice=ClaRa.Basics.Choices.Init.steadyTemperature,
    suppressChattering="False") annotation (Placement(transformation(
        extent={{-12,-4.00036},{12,4.00034}},
        rotation=90,
        origin={292,258})));
  Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort1(
    length=oh_1.length,
    N=oh_1.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        oh_1.length,
        oh_1.N_cv)) annotation (Placement(transformation(extent={{220,248},{240,268}})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1       turbine_HP1(
    p_nom=NOM.Turbine_HP.p_in,
    m_flow_nom=NOM.Turbine_HP.m_flow,
    Pi=NOM.Turbine_HP.p_out/NOM.Turbine_HP.p_in,
    rho_nom=TILMedia.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_HP.p_in,
        NOM.Turbine_HP.h_in),
    p_in_0=INIT.Turbine_HP.p_in,
    p_out_0=INIT.Turbine_HP.p_out,
    eta_mech=1,
    CL_eta_mflow=[0.0,NOM.efficiency_Turb_HP; 1,NOM.efficiency_Turb_HP],
    allowFlowReversal=true) annotation (Placement(transformation(extent={{822,196},{832,216}})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1       Turbine_IP(
    p_in_0(displayUnit="Pa") = INIT.Turbine_IP.p_in,
    p_out_0(displayUnit="Pa") = INIT.Turbine_IP.p_out,
    p_nom=NOM.Turbine_IP.p_in,
    m_flow_nom=NOM.Turbine_IP.m_flow,
    Pi=NOM.Turbine_IP.p_out/NOM.Turbine_IP.p_in,
    rho_nom=TILMedia.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_IP.p_in,
        NOM.Turbine_IP.h_in),
    eta_mech=1,
    allowFlowReversal=true,
    CL_eta_mflow=[0.0,NOM.Turbine_IP.efficiency; 1,NOM.Turbine_IP.efficiency])
                            annotation (Placement(transformation(extent={{868,196},{878,216}})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1       Turbine_LP2(
    p_out_0(displayUnit="Pa") = INIT.Turbine_LP2.p_out,
    p_in_0(displayUnit="Pa") = INIT.Turbine_LP2.p_in,
    p_nom=NOM.Turbine_LP2.p_in,
    m_flow_nom=NOM.Turbine_LP2.m_flow,
    Pi=NOM.Turbine_LP2.p_out/NOM.Turbine_LP2.p_in,
    rho_nom=TILMedia.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP2.p_in,
        NOM.Turbine_LP2.h_in),
    eta_mech=1,
    allowFlowReversal=true,
    CL_eta_mflow=[0.0,NOM.Turbine_LP2.efficiency; 1,NOM.Turbine_LP2.efficiency])
                            annotation (Placement(transformation(extent={{1112,164},{1122,184}})));
  Modelica.Blocks.Sources.Ramp PTarget(
    offset=INIT.P_target_,
    duration=1,
    startTime=10000,
    height=-0.2)
    annotation (Placement(transformation(extent={{946,-50},{926,-30}})));
  Components.TurboMachines.Pumps.PumpVLE_L1_simple       Pump_FW(                                                 eta_hyd=NOM.Pump_FW.efficiency, eta_mech=0.8)
                                                                                                annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=90,
        origin={872,-38})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={1152,124})));
  Modelica.Blocks.Sources.RealExpression Q_cond(y=-(Turbine_LP2.summary.outlet.h
         - TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(
        simCenter.fluid1, NOM.p_condenser))*Turbine_LP2.summary.outlet.m_flow)
    annotation (Placement(transformation(extent={{1212,110},{1176,138}})));
  Visualisation.Quadruple       quadruple(decimalSpaces(p=2))
                                          annotation (Placement(transformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1160,168})));
  Visualisation.Quadruple       quadruple3
    annotation (Placement(transformation(extent={{888,208},{948,228}})));
  Visualisation.Quadruple       quadruple4
    annotation (Placement(transformation(extent={{740,180},{800,200}})));
  Components.HeatExchangers.HEXvle_L3_2ph_BU condenser(
    height=5,
    width=5,
    length=10,
    initTypeShell=ClaRa.Basics.Choices.Init.steadyDensity,
    diameter_o=0.025,
    redeclare model HeatTransfer_Shell =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (             alpha_nom=
                                                                                                {10000,10000}),
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (            Delta_p_nom={100,100,100}),
    Tau_cond=0.3,
    Tau_evap=0.03,
    width_hotwell=4,
    length_hotwell=6,
    z_in_shell=4.9,
    z_out_shell=0.1,
    level_rel_start=0.5/6,
    m_flow_nom_shell=NOM.condenser.m_flow_in,
    p_nom_shell=NOM.condenser.p_condenser,
    p_start_shell=INIT.condenser.p_condenser)
                           annotation (Placement(transformation(extent={{1112,112},{1132,136}})));
  Visualisation.Quadruple       quadruple5(decimalSpaces(p=2))
    annotation (Placement(transformation(extent={{1132,86},{1192,106}})));
  Components.MechanicalSeparation.FeedWaterTank_L3_advanced feedWaterTank(
    level_rel_start=0.5,
    diameter=5,
    orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
    p_start(displayUnit="bar") = INIT.feedwatertank.p_FWT,
    length=10,
    z_tapping=4.5,
    z_aux=4.5,
    z_vent=4.5,
    z_condensate=4.5,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={1000,1000,1000}),
    initType=ClaRa.Basics.Choices.Init.steadyDensity,
    m_flow_cond_nom=NOM.feedwatertank.m_flow_cond,
    p_nom=NOM.feedwatertank.p_FWT,
    h_nom=NOM.feedwatertank.h_cond_in,
    m_flow_heat_nom=NOM.feedwatertank.m_flow_tap1 + NOM.feedwatertank.m_flow_tap2) "INIT.feedwatertank.h_cond_out"
                                                      annotation (Placement(transformation(extent={{868,20},{928,40}})));
  Components.TurboMachines.Pumps.PumpVLE_L1_simple       Pump_cond(
    eta_mech=1,
    showExpertSummary=true,
    eta_hyd=NOM.Pump_cond.efficiency)
                            annotation (Placement(transformation(extent={{1092,46},{1072,26}})));
  Modelica.Blocks.Sources.Constant const3(k=0.5/6)
    annotation (Placement(transformation(extent={{1142,-4},{1122,16}})));
  Modelica.Blocks.Sources.RealExpression condenser_relLevel(y=condenser.shell.phaseBorder.level_rel) annotation (Placement(transformation(extent={{1196,-38},{1156,-10}})));
  Components.Utilities.Blocks.LimPID       PI_Pump_cond(
    sign=-1,
    y_ref=1e6,
    k=50,
    Tau_d=30,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Tau_i=300,
    y_max=NOM.Pump_cond.P_pump*10,
    y_min=NOM.Pump_cond.P_pump/200,
    y_start=INIT.Pump_cond.P_pump)
    annotation (Placement(transformation(extent={{1112,-4},{1092,16}})));
  Visualisation.Quadruple       quadruple6
    annotation (Placement(transformation(extent={{876,-4},{936,16}})));
  Components.VolumesValvesFittings.Fittings.Split_L2_Y       join_IP(
    h_start=INIT.Turbine_IP.h_out,
    p_start=INIT.Turbine_IP.p_out,
    volume=0.1,
    initType=ClaRa.Basics.Choices.Init.noInit,
    p_nom=NOM.Turbine_IP.p_out,
    h_nom=NOM.Turbine_IP.h_out,
    m_flow_out_nom={NOM.feedwatertank.m_flow_cond,NOM.feedwatertank.m_flow_tap2})                                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={914,196})));
  Components.VolumesValvesFittings.Valves.ValveVLE_L1       valve_IP(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=20e5 - 12.8e5, m_flow_nom=65.895))
    annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=270,
        origin={914,116})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1       Turbine_LP1(
    p_in_0(displayUnit="Pa") = INIT.Turbine_LP1.p_in,
    p_out_0(displayUnit="Pa") = INIT.Turbine_LP1.p_out,
    p_nom=NOM.Turbine_LP1.p_in,
    m_flow_nom=NOM.Turbine_LP1.m_flow,
    Pi=NOM.Turbine_LP1.p_out/NOM.Turbine_LP1.p_in,
    rho_nom=TILMedia.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP1.p_in,
        NOM.Turbine_LP1.h_in),
    eta_mech=1,
    allowFlowReversal=true,
    CL_eta_mflow=[0.0,NOM.Turbine_LP1.efficiency; 1,NOM.Turbine_LP1.efficiency])
                            annotation (Placement(transformation(extent={{968,180},{978,200}})));
  Visualisation.Quadruple       quadruple7
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1022,216})));
  Components.VolumesValvesFittings.Fittings.Split_L2_Y       join_LP1(
    p_nom=INIT.Turbine_LP1.p_out,
    h_nom=INIT.Turbine_LP1.h_out,
    h_start=INIT.Turbine_LP1.h_out,
    p_start=INIT.Turbine_LP1.p_out,
    volume=0.1,
    initType=ClaRa.Basics.Choices.Init.noInit,
    m_flow_out_nom={-NOM.preheater_LP1.m_flow_cond,-NOM.preheater_LP1.m_flow_tap}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={1042,180})));
  Components.TurboMachines.Pumps.PumpVLE_L1_simple       Pump_preheater_LP1(                                                eta_mech=1, eta_hyd=NOM.Pump_preheater_LP1.efficiency)
                                                                                                annotation (Placement(transformation(extent={{982,0},{962,-20}})));
  Components.VolumesValvesFittings.Valves.ValveVLE_L1       valve_LP1(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (Delta_p_nom=NOM.valve_LP1.Delta_p_nom, m_flow_nom=NOM.valve_LP1.m_flow))
    annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=270,
        origin={1042,116})));
  Modelica.Blocks.Sources.Constant const_reheater_LP1_relLevel(k=0.5)
    annotation (Placement(transformation(extent={{1042,-44},{1022,-24}})));
  Modelica.Blocks.Sources.RealExpression preheater_LP1_relLevel(y=preheater_LP1.shell.phaseBorder.level_rel) annotation (Placement(transformation(extent={{1042,-78},{1002,-50}})));
  Components.VolumesValvesFittings.Fittings.Split_L2_Y       join_HP(
    volume=0.1,
    p_start=INIT.Turbine_HP.p_out,
    p_nom=NOM.Turbine_HP.p_out,
    h_nom=NOM.Turbine_HP.h_out,
    h_start=INIT.Turbine_HP.h_out,
    initType=ClaRa.Basics.Choices.Init.noInit,
    showExpertSummary=true,
    m_flow_out_nom={NOM.join_HP.m_flow_2,NOM.join_HP.m_flow_3})
                            annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={580,174})));
  Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple       preheater_HP(
    redeclare replaceable model WallMaterial =
        TILMedia.SolidTypes.TILMedia_Steel,
    initTypeTubes=ClaRa.Basics.Choices.Init.noInit,
    m_flow_nom_shell=NOM.preheater_HP.m_flow_tap,
    p_nom_shell=NOM.preheater_HP.p_tap,
    h_nom_shell=NOM.preheater_HP.h_tap_out,
    m_flow_nom_tubes=NOM.preheater_HP.m_flow_cond,
    h_nom_tubes=NOM.preheater_HP.h_cond_out,
    h_start_tubes=INIT.preheater_HP.h_cond_out,
    N_passes=1,
    diameter_i=0.0189,
    diameter_o=0.0269,
    z_in_tubes=0.1,
    z_out_tubes=0.1,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    length=15,
    z_in_shell=preheater_HP.length,
    p_start_shell=INIT.preheater_HP.p_tap,
    N_tubes=1081,
    diameter=2.6,
    showExpertSummary=true,
    initTypeWall=ClaRa.Basics.Choices.Init.steadyState,
    Tau_cond=0.3,
    Tau_evap=0.03,
    alpha_ph=50000,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=3500),
    initTypeShell=ClaRa.Basics.Choices.Init.steadyDensity,
    p_nom_tubes=NOM.preheater_HP.p_cond,
    p_start_tubes(displayUnit="bar") = INIT.preheater_HP.p_cond,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (alpha_nom={1650,10000}),
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={1000,1000,1000}),
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=10))
                    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={580,-62})));
  Components.VolumesValvesFittings.Valves.ValveVLE_L1       valve1_HP(
    openingInputIsActive=false,
    showExpertSummary=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (
        rho_in_nom=23,
        Delta_p_nom=NOM.valve1_HP.Delta_p_nom,
        m_flow_nom=NOM.valve1_HP.m_flow),
    checkValve=true)
    annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=90,
        origin={580,148})));
  Components.VolumesValvesFittings.Valves.ValveVLE_L1       valve2_HP(
    openingInputIsActive=true, redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (m_flow_nom=NOM.valve_cut.m_flow, Delta_p_nom=NOM.valve_cut.Delta_p))
    annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={812,76})));
  Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple       preheater_LP1(
    redeclare replaceable model WallMaterial =
        TILMedia.SolidTypes.TILMedia_Steel,
    m_flow_nom_shell=NOM.preheater_LP1.m_flow_tap,
    p_nom_shell=NOM.preheater_LP1.p_tap,
    h_nom_shell=NOM.preheater_LP1.h_tap_out,
    m_flow_nom_tubes=NOM.preheater_LP1.m_flow_cond,
    h_nom_tubes=NOM.preheater_LP1.h_cond_out,
    h_start_tubes=INIT.preheater_LP1.h_cond_out,
    p_start_shell=INIT.preheater_LP1.p_tap,
    diameter_i=0.017,
    diameter_o=0.020,
    N_passes=1,
    N_tubes=500,
    Q_flow_nom=2e8,
    initTypeShell=ClaRa.Basics.Choices.Init.steadyDensity,
    diameter=1.5,
    z_in_shell=preheater_LP1.length,
    z_in_tubes=preheater_LP1.diameter/2,
    z_out_tubes=preheater_LP1.diameter/2,
    length=13,
    z_out_shell=0.1,
    redeclare model HeatTransferTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (                      PL_alpha=[0,0.55; 0.5,0.65; 0.7,0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (             Delta_p_nom=1000),
    T_w_start={300,320,340},
    initTypeWall=ClaRa.Basics.Choices.Init.steadyState,
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (alpha_nom={1500,8000}),
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),
    p_nom_tubes=NOM.preheater_LP1.p_cond,
    p_start_tubes(displayUnit="bar") = INIT.preheater_LP1.p_cond,
    initTypeTubes=ClaRa.Basics.Choices.Init.steadyTemperature)
                   annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={1042,34})));
  Modelica.Blocks.Sources.Constant const2(k=0.5)
    annotation (Placement(transformation(extent={{746,84},{766,104}})));
  Modelica.Blocks.Sources.RealExpression preheater_HP_relLevel2(y=preheater_HP.shell.phaseBorder.level_rel) annotation (Placement(transformation(extent={{702,100},{742,128}})));
  Modelica.Blocks.Continuous.LimPID PI_Pump_preheater2(
    Td=1,
    yMax=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=100,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    y_start=1,
    yMin=0.01,
    Ti=10000)
    annotation (Placement(transformation(extent={{774,104},{794,124}})));
  Modelica.Blocks.Continuous.FirstOrder measurement(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.1,
    T=10)
    annotation (Placement(transformation(extent={{1142,-34},{1122,-14}})));
  StaticCycles.Check.InitSteamCycle_T_4_Pr_F1_C1_version2 INIT(
    P_target_=1,
    p_condenser=NOM.p_condenser,
    preheater_HP_p_tap=NOM.preheater_HP_p_tap,
    preheater_HP_m_flow_tap=NOM.preheater_HP_m_flow_tap,
    preheater_LP1_p_tap=NOM.preheater_LP1_p_tap,
    preheater_LP1_m_flow_tap=NOM.preheater_LP1_m_flow_tap,
    p_FWT=NOM.p_FWT,
    valve1_HP_Delta_p_nom=NOM.valve1_HP_Delta_p_nom,
    valve_LP1_Delta_p_nom=NOM.valve_LP1_Delta_p_nom,
    valve_LP2_Delta_p_nom=NOM.valve_LP2_Delta_p_nom,
    T_LS_nom=NOM.T_LS_nom,
    T_RS_nom=NOM.T_RS_nom,
    p_LS_out_nom=NOM.p_LS_out_nom,
    p_RS_out_nom=NOM.p_RS_out_nom,
    Delta_p_LS_nom=NOM.Delta_p_LS_nom,
    Delta_p_RS_nom=NOM.Delta_p_RS_nom,
    CharLine_Delta_p_HP_mLS_=NOM.CharLine_Delta_p_HP_mLS_,
    CharLine_Delta_p_IP_mRS_=NOM.CharLine_Delta_p_IP_mRS_,
    efficiency_Pump_cond=NOM.efficiency_Pump_cond,
    efficiency_Pump_preheater_LP1=NOM.efficiency_Pump_preheater_LP1,
    efficiency_Pump_FW=NOM.efficiency_Pump_FW,
    tapping_IP_pressure=NOM.tapping_IP_pressure,
    efficiency_Turb_HP=NOM.efficiency_Turb_HP,
    efficiency_Turb_IP=NOM.efficiency_Turb_IP,
    efficiency_Turb_LP1=NOM.efficiency_Turb_LP1,
    efficiency_Turb_LP2=NOM.efficiency_Turb_LP2,
    m_flow_nom=NOM.m_flow_nom) annotation (Placement(transformation(extent={{560,360},{580,380}})));
  Components.VolumesValvesFittings.Valves.ValveVLE_L1       valve_LP2(
                                          Tau=1e-3, redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (m_flow_nom=NOM.valve_LP2.m_flow, Delta_p_nom=NOM.valve_LP2.Delta_p_nom))
    annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=180,
        origin={982,36})));
  Components.VolumesValvesFittings.Fittings.Join_L2_Y       join_LP_main(
    initType=ClaRa.Basics.Choices.Init.noInit,
    useHomotopy=false,
    volume=0.2,
    m_flow_in_nom={NOM.join_LP_main.m_flow_1,NOM.join_LP_main.m_flow_2},
    p_nom=NOM.join_LP_main.p,
    h_nom=NOM.join_LP_main.h3,
    h_start=INIT.join_LP_main.h3,
    p_start=INIT.join_LP_main.p)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={942,36})));
  Components.Utilities.Blocks.LimPID       PI_preheater1(
    sign=-1,
    Tau_d=30,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    y_max=NOM.Pump_preheater_LP1.P_pump*1.5,
    y_min=NOM.Pump_preheater_LP1.P_pump/100,
    y_ref=1e5,
    y_start=INIT.Pump_preheater_LP1.P_pump,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=200,
    Tau_i=200)
    annotation (Placement(transformation(extent={{1002,-44},{982,-24}})));
  Visualisation.Quadruple       quadruple8
    annotation (Placement(transformation(extent={{-27,-8},{27,8}},
        rotation=0,
        origin={951,96})));
  Visualisation.Quadruple       quadruple9
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1082,96})));
  Visualisation.Quadruple       quadruple10
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={982,56})));
  Visualisation.Quadruple       quadruple11
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={618,126})));
  Visualisation.Quadruple       quadruple12
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={812,54})));
  Visualisation.Quadruple       quadruple13
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1082,66})));
  Visualisation.Quadruple       quadruple14
    annotation (Placement(transformation(extent={{-26,-8},{26,8}},
        rotation=0,
        origin={982,16})));
  Visualisation.StatePoint_phTs       statePoint_XRG2
    annotation (Placement(transformation(extent={{1022,-4},{1038,12}})));
  Visualisation.StatePoint_phTs       statePoint_XRG3
    annotation (Placement(transformation(extent={{1022,40},{1038,56}})));
  Modelica.Blocks.Math.Gain Nominal_PowerFeedwaterPump1(k=NOM.Pump_FW.P_pump)
    annotation (Placement(transformation(extent={{916,-50},{896,-30}})));
  StaticCycles.Check.InitSteamCycle_T_4_Pr_F1_C1_version2 NOM(
    final P_target_=1,
    preheater_HP_p_tap=51.95e5,
    Delta_p_RS_nom=4.91e5,
    tapping_IP_pressure=13e5,
    efficiency_Pump_cond=0.9,
    efficiency_Pump_preheater_LP1=0.8,
    efficiency_Pump_FW=0.9,
    efficiency_Turb_HP=0.93,
    efficiency_Turb_IP=0.93,
    efficiency_Turb_LP1=0.94,
    efficiency_Turb_LP2=0.94) annotation (Placement(transformation(extent={{512,360},{532,380}})));
  Visualisation.Quadruple       quadruple1
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={420,268})));
  Visualisation.Quadruple       quadruple2
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={442,192})));
  Visualisation.Quadruple       quadruple15
    annotation (Placement(transformation(extent={{800,-59},{860,-39}})));
  Visualisation.Quadruple       quadruple16
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={506,-76})));
  Visualisation.Quadruple       quadruple17
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={622,-78})));
equation
  connect(burner1.heat_bottom, hopper.heat_top) annotation (Line(
      points={{60,-6},{60,-20}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hopper.heat_bottom, fixedTemperatureBottom.port)  annotation (Line(
      points={{60,-40},{60,-66},{92,-66}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner2.heat_top,flameRoom_1. heat_bottom)
    annotation (Line(
      points={{60,44},{60,52}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_1.heat_top,flameRoom_2. heat_bottom)
    annotation (Line(
      points={{60,72},{60,82}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_2.heat_top,flameRoom_oh_1. heat_bottom)      annotation (
      Line(
      points={{60,102},{60,112}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.heat_top,flameRoom_oh_2. heat_bottom)
    annotation (Line(
      points={{60,132},{60,158}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.heat_top, burner2.heat_bottom)
                                                annotation (Line(
      points={{60,14},{60,24}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap_wall.innerPhase,evap. heat) annotation (Line(
      points={{236,62},{261.2,62}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hopper.heat_wall, evap_wall.outerPhase[1])  annotation (Line(
      points={{88,-30},{158,-30},{158,62},{228,62}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.heat_wall, evap_wall.outerPhase[2])
                                                     annotation (Line(
      points={{88,4},{158,4},{158,62},{228,62}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner2.heat_wall,evap_wall. outerPhase[3]) annotation (Line(
      points={{88,34},{158,34},{158,62},{228,62}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_1.heat_wall,evap_wall. outerPhase[4])
    annotation (Line(
      points={{88,62},{228,62}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_2.heat_wall,evap_wall. outerPhase[5]) annotation (Line(
      points={{88,92},{158,92},{158,62},{228,62}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.heat_wall,evap_wall. outerPhase[6])      annotation (
      Line(
      points={{88,122},{158,122},{158,62},{228,62}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.heat_wall,evap_wall. outerPhase[7])       annotation (
      Line(
      points={{88,168},{158,168},{158,62},{228,62}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ct_wall.innerPhase,ct. heat) annotation (Line(
      points={{296,202},{333.2,202}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort2.heatVector,oh_1_wall. outerPhase) annotation (
      Line(
      points={{240,112},{288,112}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_1_wall.innerPhase,oh_1. heat) annotation (Line(
      points={{296,112},{333.2,112}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.heat_TubeBundle,scalar2VectorHeatPort2. heatScalar)
    annotation (Line(
      points={{78,112},{220,112}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.heat_TubeBundle,scalar2VectorHeatPort3. heatScalar)
    annotation (Line(
      points={{78,158},{220,158}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort3.heatVector,oh_2_wall. outerPhase)
                                                                  annotation (
      Line(
      points={{240,158},{288,158}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_2_wall.innerPhase,oh_2. heat)
                                         annotation (Line(
      points={{296,158},{393.2,158}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_top,fixedTemperatureTop. port)        annotation (
      Line(
      points={{60,262},{60,318},{106,318}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_TubeBundle,scalar2VectorHeatPort4. heatScalar)
    annotation (Line(
      points={{78,242},{138,242},{138,-20},{192,-20}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort4.heatVector,eco_wall. outerPhase) annotation (
      Line(
      points={{212,-20},{228,-20}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eco_wall.innerPhase,eco. heat) annotation (Line(
      points={{236,-20},{261.2,-20}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PID_lambda.u_m,actual_lambda. y) annotation (Line(
      points={{-304,188},{-304,206},{-345,206}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_CarrierTubes, ct_wall.outerPhase[1]) annotation (
      Line(
      points={{78,262},{176,262},{176,202},{288,202}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap.inlet, eco.outlet) annotation (Line(
      points={{266,52},{266,-10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ct.inlet, evap.outlet) annotation (Line(
      points={{338,212},{338,224},{266,224},{266,72}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_1.inlet, ct.outlet) annotation (Line(
      points={{338,122},{338,192}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_2.inlet, oh_1.outlet) annotation (Line(
      points={{398,148},{398,80},{338,80},{338,102}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_split_top.coalSlagFlueGas_outlet, flameRoom_eco.outlet)
    annotation (Line(
      points={{42,280},{42,262}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.inlet, flameRoom_oh_1.outlet) annotation (Line(
      points={{42,158},{42,132}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.inlet, flameRoom_2.outlet) annotation (Line(
      points={{42,112},{42,102}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_2.inlet, flameRoom_1.outlet) annotation (Line(
      points={{42,82},{42,72}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_1.inlet, burner2.outlet) annotation (Line(
      points={{42,52},{42,44}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hopper.inlet, coalSlagFlueGas_join.coalSlagFlueGas_outlet)
    annotation (Line(
      points={{42,-40},{42,-60}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hopper.outlet, burner1.inlet) annotation (Line(
      points={{42,-20},{42,-6}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.outlet, burner2.inlet) annotation (Line(
      points={{42,14},{42,24}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner2.coalDust_outlet, flameRoom_1.coalDust_inlet)
    annotation (Line(
      points={{-46,62},{28,62}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mill1.outlet, burner2.coalDust_inlet) annotation (Line(
      points={{-14,34},{28,34}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mill.outlet, burner1.coalDust_inlet) annotation (Line(
      points={{8,4},{28,4}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner1.coalDust_outlet, mill1.inlet) annotation (Line(
      points={{-46,34},{-34,34}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner.coalDust_outlet, mill.inlet) annotation (Line(
      points={{-46,4},{-12,4}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasValve_L1_1.outlet, coalGas_join_burner1.flueGas_inlet)
    annotation (Line(
      points={{-140,129.833},{-80,129.833},{-80,28},{-66,28}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasValve_L1_2.outlet, coalGas_join_burner.flueGas_inlet)
    annotation (Line(
      points={{-140,99.8333},{-96,99.8333},{-96,-2},{-66,-2}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource.coal_a, coalGas_join_burner.coal_inlet) annotation (
      Line(
      points={{-120,10},{-66,10}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource1.coal_a, coalGas_join_burner1.coal_inlet) annotation (
      Line(
      points={{-120,40},{-66,40}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource2.coal_a, coalGas_join_burner2.coal_inlet) annotation (
      Line(
      points={{-120,68},{-66,68}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasJunction1.portB, flueGasValve_L1_1.inlet) annotation (Line(
      points={{-206,130},{-174,130},{-174,129.833},{-160,129.833}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));

  connect(flueGasJunction1.portC, flueGasValve_L1_2.inlet) annotation (Line(
      points={{-216,120},{-216,100},{-160,100},{-160,99.8333}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fluelGasFlowSource4.gas_a, regenerativeAirPreheater.freshAirInlet)
    annotation (Line(
      points={{-244,170},{-226,170}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasPressureSink2.gas_a, regenerativeAirPreheater.flueGasOutlet)
    annotation (Line(
      points={{-192,170},{-206,170}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slagFlowSource_top.slag_outlet, coalSlagFlueGas_split_top.slag_outlet)
    annotation (Line(
      points={{42,330},{42,300}},
      color={234,171,0},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSink_top.coal_a, coalSlagFlueGas_split_top.coal_inlet)
    annotation (Line(
      points={{18,332},{18,326},{36,326},{36,300}},
      color={27,36,42},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.coal_inlet, coalFlowSource_bottom.coal_a)
    annotation (Line(
      points={{36,-80},{36,-90},{22,-90},{22,-100}},
      color={27,36,42},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slaglSink_bottom.slag_inlet, coalSlagFlueGas_join.slag_outlet)
    annotation (Line(
      points={{42.2,-100},{42.2,-90},{42,-90},{42,-80}},
      color={234,171,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.flueGas_inlet, fluelGasFlowSource_bottom.gas_a)
    annotation (Line(
      points={{48,-80},{48,-90},{62,-90},{62,-98}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fluelGasFlowSource2.gas_a, coalGas_join_burner2.flueGas_inlet)
    annotation (Line(
      points={{-102,56},{-66,56}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(regenerativeAirPreheater.flueGasInlet, coalSlagFlueGas_split_top.flueGas_inlet)
    annotation (Line(
      points={{-206,158},{-18,158},{-18,386},{64,386},{64,326},{48,326},{48,300}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(regenerativeAirPreheater.freshAirOutlet, flueGasJunction1.portA)
    annotation (Line(
      points={{-226,158},{-238,158},{-238,130},{-226,130}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PID_lambda.y, fluelGasFlowSource4.m_flow) annotation (Line(
      points={{-293.1,176},{-264,176}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(classifierSpeed1.y, mill1.classifierSpeed) annotation (Line(
      points={{-36.7,103},{-24,103},{-24,44.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(classifierSpeed1.y, mill.classifierSpeed) annotation (Line(
      points={{-36.7,103},{-2,103},{-2,14.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lambda.y, PID_lambda.u_s) annotation (Line(
      points={{-345,176},{-316,176}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalMassFlow.y, coalFlowSource1.m_flow) annotation (Line(
      points={{-173,46},{-140,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalMassFlow.y, coalFlowSource.m_flow) annotation (Line(
      points={{-173,46},{-156,46},{-156,16},{-140,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flameRoom_oh_2.outlet, flameroom_ZUE.inlet) annotation (Line(
      points={{42,178},{42,200}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.heat_top, flameroom_ZUE.heat_bottom) annotation (Line(
      points={{60,178},{60,200}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameroom_ZUE.outlet, flameRoom_eco.inlet) annotation (Line(
      points={{42,220},{42,242}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameroom_ZUE.heat_top, flameRoom_eco.heat_bottom) annotation (Line(
      points={{60,220},{60,242}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameroom_ZUE.heat_CarrierTubes, ct_wall.outerPhase[2]) annotation (Line(
      points={{78,220},{176,220},{176,202},{288,202}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.heat_CarrierTubes, ct_wall.outerPhase[3]) annotation (Line(
      points={{78,178},{80,178},{80,178},{176,178},{176,202},{288,202}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.heat_CarrierTubes, ct_wall.outerPhase[4]) annotation (Line(
      points={{78,132},{78,132},{176,132},{176,202},{288,202}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameroom_ZUE.heat_wall, evap_wall.outerPhase[8]) annotation (Line(
      points={{88,210},{158,210},{158,62},{228,62}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_wall, evap_wall.outerPhase[9]) annotation (Line(
      points={{88,252},{158,252},{158,62},{228,62}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ZUE_wall.innerPhase, ZUE.heat) annotation (Line(
      points={{296,258},{359.2,258}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort1.heatVector, ZUE_wall.outerPhase) annotation (Line(
      points={{240,258},{288,258}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameroom_ZUE.heat_TubeBundle, scalar2VectorHeatPort1.heatScalar) annotation (Line(
      points={{78,200},{78,190},{204,190},{204,258},{220,258}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Pump_FW.inlet,feedWaterTank. outlet)
                                            annotation (Line(
      points={{872,-28},{872,20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Pump_FW.outlet,preheater_HP. In2) annotation (Line(
      points={{872,-48},{872,-60},{590,-60},{590,-59.8}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve1_HP.outlet,preheater_HP. In1)
                                             annotation (Line(
      points={{580,138},{580,-52.2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_LP1.In1,valve_LP1. outlet) annotation (Line(
      points={{1042,43.8},{1042,106}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_LP1.In2,Pump_cond. outlet) annotation (Line(
      points={{1052,36.2},{1072,36.2},{1072,36}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_LP1.Out1,Pump_preheater_LP1. inlet) annotation (Line(
      points={{1042,24},{1042,-10},{982,-10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PI_Pump_preheater2.y,valve2_HP. opening_in) annotation (Line(
      points={{795,114},{812,114},{812,85}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const2.y,PI_Pump_preheater2. u_m) annotation (Line(
      points={{767,94},{784,94},{784,102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const3.y,PI_Pump_cond. u_s) annotation (Line(
      points={{1121,6},{1114,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(measurement.u,condenser_relLevel. y) annotation (Line(
      points={{1144,-24},{1154,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(measurement.y,PI_Pump_cond. u_m) annotation (Line(
      points={{1121,-24},{1102,-24},{1102,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(join_LP1.inlet,Turbine_LP1. outlet) annotation (Line(
      points={{1032,180},{978,180}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_LP1.outlet1,Turbine_LP2. inlet) annotation (Line(
      points={{1052,180},{1112,180}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_LP1.outlet2,valve_LP1. inlet) annotation (Line(
      points={{1042,170},{1042,126}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Turbine_IP.outlet,join_IP. inlet) annotation (Line(
      points={{878,196},{904,196}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_IP.outlet1,Turbine_LP1. inlet) annotation (Line(
      points={{924,196},{968,196}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_IP.outlet2,valve_IP. inlet) annotation (Line(
      points={{914,186},{914,126}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.inlet,turbine_HP1. outlet) annotation (Line(
      points={{590,174},{842,174},{842,196},{832,196}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.outlet2,valve1_HP. inlet) annotation (Line(
      points={{580,164},{580,158}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_LP2.inlet,preheater_LP1. Out2) annotation (Line(
      points={{992,36},{1032,36}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_LP2.outlet,join_LP_main. inlet1) annotation (Line(
      points={{972,36},{952,36}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PI_Pump_cond.y,Pump_cond. P_drive) annotation (Line(
      points={{1091.1,6},{1082,6},{1082,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PI_preheater1.u_s,const_reheater_LP1_relLevel. y) annotation (Line(
      points={{1004,-34},{1021,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preheater_LP1_relLevel.y,PI_preheater1. u_m) annotation (Line(
      points={{1000,-64},{991.8,-64},{991.8,-46},{992,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PI_preheater1.y,Pump_preheater_LP1. P_drive) annotation (Line(
      points={{981.1,-34},{972,-34},{972,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(turbine_HP1.eye,quadruple4. eye) annotation (Line(
      points={{833,200},{834,200},{834,190},{740,190}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_IP.eye,quadruple3. eye) annotation (Line(
      points={{879,200},{882,200},{882,218},{888,218}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_LP1.eye,quadruple7. eye) annotation (Line(
      points={{979,184},{982,184},{982,216},{992,216}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_LP2.eye,quadruple. eye) annotation (Line(
      points={{1123,168},{1130,168}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple6.eye,feedWaterTank. eye) annotation (Line(
      points={{876,6},{876,8},{878,8},{878,19}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple8.eye,valve_IP. eye) annotation (Line(
      points={{924,96},{918,96},{918,106}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple9.eye,valve_LP1. eye) annotation (Line(
      points={{1052,96},{1046,96},{1046,106}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple10.eye,valve_LP2. eye) annotation (Line(
      points={{952,56},{948,56},{948,44},{972,44},{972,40}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(valve1_HP.eye,quadruple11. eye) annotation (Line(
      points={{584,138},{584,136.3},{588,136.3},{588,126}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple12.eye,valve2_HP. eye) annotation (Line(
      points={{782,54},{848,54},{848,72},{822,72}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple13.eye,Pump_cond. eye) annotation (Line(
      points={{1052,66},{1052,42},{1071,42}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple14.eye,Pump_preheater_LP1. eye) annotation (Line(
      points={{956,16},{950,16},{950,-4},{961,-4}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(statePoint_XRG2.port,Pump_preheater_LP1. inlet) annotation (Line(
      points={{1022,-4},{1022,-10},{982,-10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(statePoint_XRG3.port,preheater_LP1. Out2) annotation (Line(
      points={{1022,40},{1022,36},{1032,36}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_HP.Out1,valve2_HP. inlet) annotation (Line(
      points={{580,-72},{580,-94},{756,-94},{756,76},{802,76}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Nominal_PowerFeedwaterPump1.y,Pump_FW. P_drive) annotation (Line(
      points={{895,-40},{888,-40},{888,-38},{884,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valve_IP.outlet,feedWaterTank. aux) annotation (Line(
      points={{914,106},{914,36}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(feedWaterTank.heatingSteam,valve2_HP. outlet) annotation (Line(
      points={{878,38},{878,76},{822,76}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Pump_preheater_LP1.outlet,join_LP_main. inlet2) annotation (Line(
      points={{962,-10},{942,-10},{942,26}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_LP_main.outlet,feedWaterTank. condensate) annotation (Line(
      points={{932,36},{918,36}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(PTarget.y,Nominal_PowerFeedwaterPump1. u) annotation (Line(
      points={{925,-40},{918,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(condenser.outlet,Pump_cond. inlet)
    annotation (Line(
      points={{1122,112},{1122,36},{1092,36}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(Turbine_LP2.outlet,condenser. inlet)
    annotation (Line(
      points={{1122,164},{1122,136}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(condenser.eye,quadruple5. eye) annotation (Line(
      points={{1124.8,112.24},{1124.8,96},{1132,96}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(condenser.heat,prescribedHeatFlow. port) annotation (Line(
      points={{1132,124},{1142,124}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Q_cond.y,prescribedHeatFlow. Q_flow) annotation (Line(
      points={{1174.2,124},{1162,124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preheater_HP_relLevel2.y,PI_Pump_preheater2. u_s) annotation (Line(
      points={{744,114},{772,114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(oh_2.outlet, turbine_HP1.inlet) annotation (Line(
      points={{398,168},{398,212},{822,212}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.outlet1, ZUE.inlet) annotation (Line(
      points={{570,174},{364,174},{364,248}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(ZUE.outlet, Turbine_IP.inlet) annotation (Line(
      points={{364,268},{364,284},{868,284},{868,212}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_HP.Out2, eco.inlet) annotation (Line(
      points={{570,-60},{266,-60},{266,-30}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(quadruple1.eye, ZUE.eye) annotation (Line(
      points={{390,268},{448,268},{448,268.429},{368.08,268.429}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(oh_2.eye, quadruple2.eye) annotation (Line(
      points={{402.08,168.429},{402.08,192},{412,192}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple15.eye, Pump_FW.eye) annotation (Line(
      points={{800,-49},{866,-49}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple16.eye, preheater_HP.eye2) annotation (Line(
      points={{476,-76},{569,-76},{569,-62}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple17.eye, preheater_HP.eye1) annotation (Line(
      points={{592,-78},{588,-78},{588,-71.8},{582.8,-71.8}},
      color={190,190,190},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-400,-160},{1280,400}},
          preserveAspectRatio=false),graphics={
        Text(
          extent={{508,396},{536,376}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="CycleINIT"),
        Text(
          extent={{550,396},{590,376}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="CycleSettings"),
        Text(
          extent={{424,398},{458,380}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="Model
Properties")}),                                                          Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true)),
    experiment(StopTime=10000, NumberOfIntervals=1001),
    __Dymola_experimentSetupOutput);
end ClosedLoopBoilerExample_detailedSteamCycle_03;
