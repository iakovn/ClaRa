within ClaRa.Components.Adapters.Check;
model TestFluidConverters
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;
  Fluid2ClaRa fluid2ClaRa
    annotation (Placement(transformation(extent={{-20,34},{0,14}})));
  Modelica.Fluid.Sources.Boundary_ph boundary(
    use_p_in=false,
    use_h_in=false,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=1000000,
    h=100e3)
    annotation (Placement(transformation(extent={{-144,14},{-124,34}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_T(variable_m_flow=true, variable_h=true,
    showData=true)                                                                                 annotation (Placement(transformation(extent={{60,14},{40,34}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-2,
    duration=0.1,
    offset=1,
    startTime=0.75) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,30})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=0.1,
    offset=1e5,
    startTime=0.25,
    height=3e6)     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,0})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-98,14},{-118,34}})));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-30,24},{-50,44}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_T1(variable_m_flow=true, variable_h=true,
    showData=true)                                                                                  annotation (Placement(transformation(extent={{60,-34},{40,-14}})));
  Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{26,-48},{-12,-38}})));
  ThermoPower2ClaRa thermoPower2ClaRa
    annotation (Placement(transformation(extent={{-20,-34},{0,-14}})));
  Visualisation.DynDisplay dynDisplay2(
    varname="MSL.T",
    unit="°C",
    x1=sensT.T - 273.15)
    annotation (Placement(transformation(extent={{-28,-18},{8,-6}})));
  Visualisation.DynDisplay dynDisplay3(
    varname="MSL.m_flow",
    unit="kg/s",
    x1=sensT.outlet.w)
    annotation (Placement(transformation(extent={{-82,-48},{-46,-36}})));
  Fundamentals.SourceP sourceP(p0=1000000) annotation (Placement(transformation(extent={{-80,-34},{-60,-14}})));
  Fundamentals.SensT sensT annotation (Placement(transformation(extent={{-44,-30},{-24,-10}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_T2(variable_m_flow=true, variable_h=true,
    showData=true)                                                                                  annotation (Placement(transformation(extent={{60,-84},{40,-64}})));
  Visualisation.Quadruple quadruple2
    annotation (Placement(transformation(extent={{26,-98},{-12,-88}})));
  ClaRa2ThermoPower thermoPower2ClaRa1
    annotation (Placement(transformation(extent={{0,-84},{-20,-64}})));
  Visualisation.DynDisplay dynDisplay4(
    unit="°C",
    varname="TP.T",
    x1=sensT1.T - 273.15)
    annotation (Placement(transformation(extent={{-24,-70},{12,-58}})));
  Visualisation.DynDisplay dynDisplay5(
    unit="kg/s",
    varname="TP.m_flow",
    x1=sensT1.inlet.w)
    annotation (Placement(transformation(extent={{-82,-98},{-46,-86}})));
  Fundamentals.SinkP sourceP1(p0=1000000) annotation (Placement(transformation(extent={{-60,-84},{-80,-64}})));
  Fundamentals.SensT sensT1 annotation (Placement(transformation(extent={{-24,-80},{-44,-60}})));
  Modelica.Blocks.Interaction.Show.RealValue realValue(significantDigits=3)
                                                       annotation (Placement(transformation(extent={{-80,24},{-100,44}})));
  Modelica.Blocks.Interaction.Show.RealValue realValue1(significantDigits=3)
                                                        annotation (Placement(transformation(extent={{-114,34},{-134,54}})));
  Sensors.vleMassflowSensor Flow annotation (Placement(transformation(extent={{34,24},{14,44}})));
  Sensors.Temperature Temperature annotation (Placement(transformation(extent={{24,24},{4,4}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{-54,44},{-74,24}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=273.15) annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
equation
  connect(ramp.y, massFlowSource_T.m_flow) annotation (Line(
      points={{79,30},{62,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource_T.h) annotation (Line(
      points={{79,0},{74,0},{74,24},{62,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowRate.port_a, fluid2ClaRa.port_a) annotation (Line(
      points={{-98,24},{-98,24},{-19.8,24}},
      color={0,127,255},
      smooth=Smooth.Bezier));
  connect(boundary.ports[1], massFlowRate.port_b) annotation (Line(
      points={{-124,24},{-118,24}},
      color={0,127,255},
      smooth=Smooth.Bezier));
  connect(temperature.port, massFlowRate.port_a) annotation (Line(
      points={{-40,24},{-98,24}},
      color={0,127,255},
      smooth=Smooth.Bezier));
  connect(ramp.y, massFlowSource_T1.m_flow) annotation (Line(
      points={{79,30},{72,30},{72,-18},{62,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource_T1.h) annotation (Line(
      points={{79,0},{74,0},{74,-24},{62,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_T1.steam_a, thermoPower2ClaRa.outlet) annotation (Line(
      points={{40,-24},{0,-24}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_T1.eye, quadruple1.eye) annotation (Line(
      points={{40,-32},{34,-32},{34,-43},{26,-43}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(sensT.outlet, thermoPower2ClaRa.flangeA) annotation (Line(
      points={{-28,-24},{-19.8,-24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceP.flange, sensT.inlet) annotation (Line(
      points={{-60,-24},{-40,-24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(massFlowSource_T2.eye,quadruple2. eye) annotation (Line(
      points={{40,-82},{34,-82},{34,-93},{26,-93}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(sensT1.outlet, sourceP1.flange) annotation (Line(
      points={{-40,-74},{-60,-74}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(thermoPower2ClaRa1.flangeB, sensT1.inlet) annotation (Line(
      points={{-20,-74},{-28,-74}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(thermoPower2ClaRa1.inlet, massFlowSource_T2.steam_a) annotation (Line(
      points={{0,-74},{40,-74}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource_T2.h) annotation (Line(
      points={{79,0},{74,0},{74,-74},{62,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, massFlowSource_T2.m_flow) annotation (Line(
      points={{79,30},{72,30},{72,-68},{62,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realValue1.numberPort, massFlowRate.m_flow) annotation (Line(points={{-112.5,44},{-108,44},{-108,35}},    color={0,0,127}));
  connect(Flow.inlet, massFlowSource_T.steam_a) annotation (Line(
      points={{34,24},{40,24}},
      color={0,131,169},
      thickness=0.5));
  connect(Flow.outlet, fluid2ClaRa.steam_a) annotation (Line(
      points={{14,24},{-0.05,24},{-0.05,24.0025}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fluid2ClaRa.steam_a, Temperature.port) annotation (Line(
      points={{-0.05,24.0025},{14,24.0025},{14,24}},
      color={0,131,169},
      thickness=0.5));
  connect(temperature.T, feedback.u1) annotation (Line(points={{-47,34},{-47,34},{-56,34}}, color={0,0,127}));
  connect(feedback.y, realValue.numberPort) annotation (Line(points={{-73,34},{-76,34},{-78.5,34}}, color={0,0,127}));
  connect(realExpression.y, feedback.u2) annotation (Line(points={{-79,50},{-64,50},{-64,42}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-150,-100},{100,100}}, initialScale=0.1), graphics={
        Polygon(
          points={{-150,80},{36,80},{-28,0},{-150,0},{-150,80}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,80},{100,80},{100,0},{-28,0},{36,80}},
          lineColor={215,215,215},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-32,78},{28,70}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Modelica Standard Library"),
        Text(
          extent={{20,78},{80,70}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="ClaRa Library",
          fontName="Miso")}), Icon(coordinateSystem(extent={{-150,-100},{100,100}}, initialScale=0.1)));
end TestFluidConverters;
