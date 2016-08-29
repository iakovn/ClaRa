within ClaRa.Visualisation.Check;
model TestDynamicBar
extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  Modelica.Blocks.Sources.Sine sine(
    offset=0.5,
    freqHz=2,
    amplitude=0.6) annotation (Placement(transformation(extent={{-48,-32},{-28,-12}})));
  DynamicBar dynamicBar(
    u=sine.y,
    decimalSpaces=3,
    provideConnector=true,
    u_set=0.4,
    u_high=0.7,
    u_low=0.3)             annotation (Placement(transformation(extent={{-4,-40},{16,0}})));
  Modelica.Blocks.Interfaces.RealOutput y1 annotation (Placement(transformation(extent={{44,-50},{64,-30}})));
equation
  connect(dynamicBar.y, y1) annotation (Line(points={{18,-40},{18,-40},{54,-40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestDynamicBar;
