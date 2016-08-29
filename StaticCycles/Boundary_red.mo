within ClaRa.StaticCycles;
model Boundary_red "Red boundary"

  parameter Boolean source = true "True if boundary is source else sink";
  parameter ClaRa.Basics.Units.MassFlowRate  m_flow(fixed= not source) annotation(Dialog(enable = not source));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h(fixed=source) annotation(Dialog(enable = source));
  parameter ClaRa.Basics.Units.Pressure p(fixed= not source) annotation(Dialog(enable = not source));

  Fundamentals.SteamSignal_red inlet(m_flow=m_flow, p=p)  annotation (Placement(transformation(extent={{-104,-10},{-96,10}})));
  Fundamentals.SteamSignal_red outlet(h=h)  annotation (Placement(transformation(extent={{96,-10},{104,10}})));
initial equation
  if source then
    m_flow= outlet.m_flow;
    p=outlet.p;
  else

    h=inlet.h;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Line(
          points={{-60,0},{-96,0}},
          color={0,131,169},
          smooth=Smooth.None, visible= not source),
          Line(
          points={{60,0},{96,0}},
          color={0,131,169},
          smooth=Smooth.None, visible= source),
        Polygon(
          points={{-60,60},{60,60},{60,-60},{-60,-60},{-60,60}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-60,60},{60,20}},
          lineColor={150,25,48},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%p",
          visible=not source),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={150,25,48},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%m_flow",
          visible=not source),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={150,25,48},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%h",
          visible=source)}),               Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end Boundary_red;
