within ClaRa.Visualisation;
model DynamicBar
  input Real u "Variable to be visualised" annotation(Dialog);
  parameter Real u_set = 0.5 "Set Value of filling level";
  parameter Real u_high(max=u_max, min=u_min)= 0.6 "High input threshold" annotation(Dialog);
  parameter Real u_low(max=u_max, min=u_min)= 0.4 "Low input threshold" annotation(Dialog);
  parameter Real u_max = 1 "Upper boundary for visualised variable" annotation(Dialog);
  parameter Real u_min = 0 "Lower boundary for visualised variable" annotation(Dialog);
  parameter String unit= "" "The input's unit";
  parameter Integer decimalSpaces=1 "Accuracy to be displayed";
  parameter Boolean provideConnector= false
    "If true a real output connector is provided";

  Modelica.Blocks.Interfaces.RealOutput y(value=u) if provideConnector annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));

equation
  assert(u_min < u_low and u_low< u_set and u_set< u_high and u_high < u_max, "The parameters in " + getInstanceName() + " have the following constraints: u_min < u_low < u_set < u_high < u_max.");

annotation (    Icon(coordinateSystem(preserveAspectRatio=false,extent={{0,0},{100,
            200}}),       graphics={
        Line(points=DynamicSelect({{0,100},{85,100}},{{0,u_set/(u_max-u_min)*200},{85,u_set/(u_max-u_min)*200}}), color={27,36,42}),
        Line(points=DynamicSelect({{0,120},{85,120}},{{0,u_high/(u_max-u_min)*200},{85,u_high/(u_max-u_min)*200}}), color={118,124,127}),
        Line(points=DynamicSelect({{0,80},{85,80}},{{0,u_low/(u_max-u_min)*200},{85,u_low/(u_max-u_min)*200}}), color={118,124,127}),
        Rectangle(
          extent={{20,0},{80,200}},
          lineColor={27,36,42},
          fillColor={164,167,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent=DynamicSelect({{20,0},{80,0}}, {{20,u/(u_max-u_min)*200},{80,0}}),
          lineColor=DynamicSelect({115,150,0}, if u>u_high then {167,25,48} elseif u<u_low then {0,131,169} else {115,150,0}),
          fillColor=DynamicSelect({115,150,0}, if u>u_high then {167,25,48} elseif u<u_low then {0,131,169} else {115,150,0}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,10},{100,-10}},
          lineColor={27,36,42},
          textString="%name",
          origin={50,-10},
          rotation=180),
        Text(
          extent={{-100,110},{100,90}},
          lineColor=DynamicSelect({27,36,42},if u>u_max then {27,36,42} elseif u>u_high then {167,25,48} elseif u<u_low then {0,131,169} else {115,150,0}),
          origin={50,110},
          textString=  DynamicSelect("value", String(u,format=  "1."+String(decimalSpaces)+"f")+ " %unit"),
          fontSize=0),
        Text(
          extent=DynamicSelect({{85, 90},{200, 110}},{{85,u_set/(u_max-u_min)*200-10},{200,u_set/(u_max-u_min)*200+10}}),
          lineColor={27,36,42},
          textString="%u_set",
          horizontalAlignment=TextAlignment.Left),
        Rectangle(extent={{20,200},{80,0}}, lineColor={27,36,42}),
        Line(points={{20,0},{100,0}}, color={27,36,42}, visible=provideConnector)}),
          Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-30,-10},{110,120}},
        grid={2,2},
        initialScale=0.1), graphics));
end DynamicBar;
