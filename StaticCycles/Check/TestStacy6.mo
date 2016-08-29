within ClaRa.StaticCycles.Check;
model TestStacy6
  extends Basics.Icons.PackageIcons.ExecutableRegressiong100;
model Regression
  extends ClaRa.Basics.Icons.RegressionSummary;
  Modelica.Blocks.Interfaces.RealInput p_HP_out "HP turbine outlet pressure";
  Modelica.Blocks.Interfaces.RealInput m_flow2_split_LP "Outlet 2 mass flow at LP splitter";
  Modelica.Blocks.Interfaces.RealInput h_cond_out_PHIP3 "Tube side outlet enthalpy at preheater IP3";
  Modelica.Blocks.Interfaces.RealInput Delta_p_vlv2 "Pressure difference at valve2";
end Regression;

  StaticCycleExamples.SteamCycle_4NDV_3HDV_01 staCy annotation (Placement(transformation(extent={{-74,-22},{2,50}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));

  Regression regression(p_HP_out = staCy.turbine_HP.p_out,
    m_flow2_split_LP = staCy.split_LP.m_flow_3,
    h_cond_out_PHIP3 = staCy.preheater_IP3.h_cond_out,
    Delta_p_vlv2= staCy.valve2.Delta_p) annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{380,100}}), graphics={Rectangle(
          extent={{-100,100},{380,-100}},
          lineColor={115,150,0},
          lineThickness=0.5)}),                                          Icon(coordinateSystem(initialScale=0.1)));
end TestStacy6;
