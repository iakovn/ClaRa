within ClaRa.StaticCycles.Check;
model TestBoundaries
  extends ClaRa.Basics.Icons.Init;

  Boundary_blue boundary_blue(
    m_flow=10,
    h=3000e3,
    source=true) annotation (Placement(transformation(extent={{20,0},{0,20}})));
  Boundary_green boundary_green(source=false) annotation (Placement(transformation(extent={{-40,0},{-60,20}})));
  FixedPressure fixedPressure(p=10e5) annotation (Placement(transformation(extent={{-28,8},{-18,12}})));
  Triple triple annotation (Placement(transformation(extent={{-4,16},{10,28}})));
  Triple triple1 annotation (Placement(transformation(extent={{-52,30},{-40,42}})));
  Turbine turbine annotation (Placement(transformation(extent={{-32,-60},{-20,-40}})));
  Boundary_green boundary_green1(
    source=true,
    m_flow=10,
    h=3000e3,
    p=20e5) annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Boundary_blue boundary_blue1(source=false, p=5e5) annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Triple triple2 annotation (Placement(transformation(extent={{-4,-44},{10,-32}})));
  Triple triple3 annotation (Placement(transformation(extent={{-52,-30},{-40,-18}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
equation
  connect(boundary_green.inlet, fixedPressure.outlet) annotation (Line(
      points={{-40,10},{-28.4,10}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boundary_blue.outlet, fixedPressure.inlet) annotation (Line(
      points={{0,10},{-17.6,10}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple.steamSignal, boundary_blue.outlet) annotation (Line(
      points={{-4.4375,20.7143},{-4.4375,15.3572},{0,15.3572},{0,10}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple1.steamSignal, boundary_green.inlet) annotation (Line(
      points={{-52.375,34.7143},{-52.375,22.3572},{-40,22.3572},{-40,10}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boundary_green1.outlet, turbine.inlet) annotation (Line(
      points={{-40,-50},{-36,-50},{-36,-46},{-30.8,-46}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boundary_blue1.inlet, turbine.outlet) annotation (Line(
      points={{0,-50},{-10,-50},{-10,-58},{-20.4,-58}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple2.steamSignal, boundary_blue1.inlet) annotation (Line(
      points={{-4.4375,-39.2857},{-4.4375,-44.6428},{0,-44.6428},{0,-50}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple3.steamSignal, boundary_green1.outlet) annotation (Line(
      points={{-52.375,-25.2857},{-52.375,-37.6428},{-40,-37.6428},{-40,-50}},
      color={0,131,169},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end TestBoundaries;
