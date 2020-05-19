within ClaRa.Basics.ControlVolumes.GasVolumes.Check;
model TestFlueGasCell
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.5.0                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
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
  ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L2 flueGasCell(
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry,
    allow_reverseFlow=true,
    use_dynamicMassbalance=true,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    T_start=273.15 + 200,
    redeclare model HeatTransfer =
        Fundamentals.HeatTransport.Generic_HT.Constant_L2 (
          temperatureDifference="Arithmetic mean"),
    initOption=0,
    xi_start={0.7,0.1,0.1,0.05,0.01,0.02,0.01,0.01,0})
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Modelica.Blocks.Sources.Ramp massFlowRate(
    height=-1,
    offset=0.5,
    startTime=300,
    duration=20) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,10})));
  Modelica.Blocks.Sources.Ramp Temperature(
    duration=1,
    height=50,
    startTime=50,
    offset=273.15 + 200)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,-22})));
  Modelica.Blocks.Sources.Ramp QFlow(
    offset=0,
    startTime=150,
    duration=10,
    height=-10000)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,42})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Sources.Ramp dP(
    duration=0.1,
    offset=1.013e5,
    startTime=450,
    height=-0.1e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-6})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{40,80},{80,100}})));
  Components.BoundaryConditions.BoundaryGas_Txim_flow idealGasFlowSource_XRG(
    medium=simCenter.flueGasModel,
    m_flow_const=10,
    variable_xi=false,
    variable_T=true,
    variable_m_flow=true,
    xi_const={0.7,0.1,0.1,0.05,0.01,0.02,0.01,0.01,0})
                      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi(
    medium=simCenter.flueGasModel,
    variable_p=true,
    xi_const={0.1,0.05,0.1,0.3,0.4,0.001,0.001,0.001,0}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,0})));
equation
  connect(QFlow.y,prescribedHeatFlow. Q_flow) annotation (Line(
      points={{-63,42},{-56,42},{-56,20},{-40,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowRate.y, idealGasFlowSource_XRG.m_flow) annotation (Line(
      points={{-63,10},{-48,10},{-48,6},{-40,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temperature.y, idealGasFlowSource_XRG.T) annotation (Line(
      points={{-63,-22},{-48.5,-22},{-48.5,0},{-40,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dP.y, boundaryGas_pTxi.p) annotation (Line(
      points={{79,-6},{60,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, flueGasCell.heat) annotation (Line(
      points={{-20,20},{10,20},{10,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(flueGasCell.inlet, idealGasFlowSource_XRG.gas_a)
    annotation (Line(
      points={{0,0},{-20,0}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasCell.outlet, boundaryGas_pTxi.gas_a) annotation (Line(
      points={{20,0},{40,0}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                      graphics={Text(
          extent={{-98,80},{6,66}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________
PURPOSE:
>> Tester for basic flue gas cell model with different inputs
LOOK AT:
>> Outlet temperature of the flue gas cell


")}),
    experiment(StopTime=500),
    __Dymola_experimentSetupOutput);
end TestFlueGasCell;
