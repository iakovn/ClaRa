within ;
package ClaRa "Simulation of Clausius-Rankine Cycles"
  extends ClaRa.Basics.Icons.PackageIcons.ClaRab100;
  import SI = ClaRa.Basics.Units;























  annotation (preferedView="info",version="1.2.1",
                           uses(
      ClaRa_Obsolete(version="1.2.1"),
    TILMedia(version="1.2.1 ClaRa"),
    FluidDissipation(version="1.1.8"),
    Modelica(version="3.2.2")),  Icon(coordinateSystem(preserveAspectRatio=
          false, extent={{-100,-100},{100,100}})),
  conversion(from(version="0.0",to="0.1 alpha",  script="modelica://ClaRa/Scripts/ConvertFrom000.mos"),
    from(version="0.1 alpha",to="0.2 alpha", script="modelica://ClaRa/Scripts/ConvertFrom010.mos"),
    from(version="0.2 alpha",to="0.2.1 alpha", script="modelica://ClaRa/Scripts/ConvertFrom020.mos"),
    from(version="0.2.1 alpha",to="0.2.2 alpha", script="modelica://ClaRa/Scripts/ConvertFrom021.mos"),
    from(version="0.2.2 alpha",to="1.0.1", script="modelica://ClaRa/Scripts/ConvertFrom022.mos"),
    from(version="1.0.1",to="1.1.2", script="modelica://ClaRa/Scripts/ConvertFrom101.mos"),
    from(version="1.1.2",to="1.2.1", script="modelica://ClaRa/Scripts/ConvertFrom112_to_121.mos")),
  Documentation(info="<html>
<p><img src=\"modelica://ClaRa/figures/ClaRaLibraryInfo.png\"/></p>
</html>"));
end ClaRa;
