within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes;
model GeneralHeatExchanger
  import Modelica.Constants.eps;
  input Real NTU_1 "Number of Transfer Units at limiting side";
  input Real R_1 "Ratio of heat capacity flows at limiting side";
  output Real CF_NTU "Correction factor for heat flow based on the NTU method";

  parameter Real a "Geometry fitting factor";
  parameter Real b "Geometry fitting exponent";
  parameter Real c "Geometry fitting exponent";
  parameter Real d "Geometry fitting exponent";

equation
  CF_NTU = 1/abs(1+a*R_1^(d*b)*max(eps,NTU_1)^b)^c;

  annotation (Icon(graphics={        Polygon(
          points={{100,-34},{100,-36},{66,4},{66,4},{10,-46},{-40,6},{-48,16},{-22,36},{-20,38},{-100,56},{-100,56},{-100,-28},{-100,-28},{-72.8125,-12.4375},{-72,-14},{0,-100},{100,-34}},
          smooth=Smooth.Bezier,
          fillColor={51,156,186},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid,
          origin={0,-10},
          rotation=0,
          lineColor={0,0,0}),        Polygon(
          points={{100,-34},{100,-36},{46,-24},{46,-24},{10,-46},{-40,6},{-48,
              16},{-22,36},{-20,38},{-100,56},{-100,56},{-100,-28},{-98,-26},{
              -72.8125,-12.4375},{-72,-14},{0,-102},{100,-34}},
          smooth=Smooth.Bezier,
          fillColor={153,205,211},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid,
          origin={0,10},
          rotation=180,
          lineColor={0,0,0})}));
end GeneralHeatExchanger;
