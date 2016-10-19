within ;
package ClaRa "Simulation of Clausius-Rankine Cycles"
  extends ClaRa.Basics.Icons.PackageIcons.ClaRab100;
  import SI = ClaRa.Basics.Units;









  annotation (preferedView="info",version="1.1.2",
                           uses(
      Modelica(version="3.2.1"),
      ClaRa_Obsolete(version="1.1.2"),
    TILMedia(version="1.1.2 ClaRa"),
    FluidDissipation(version="1.1.8")),
                                 Icon(coordinateSystem(preserveAspectRatio=
          false, extent={{-100,-100},{100,100}})),
  conversion(from(version="0.0", script="modelica://ClaRa/Scripts/ConvertFrom000.mos"),
    from(version="0.1 alpha", script="modelica://ClaRa/Scripts/ConvertFrom010.mos"),
    from(version="0.2 alpha", script="modelica://ClaRa/Scripts/ConvertFrom020.mos"),
    from(version="0.2.1 alpha", script="modelica://ClaRa/Scripts/ConvertFrom021.mos"),
    from(version="0.2.2 alpha", script="modelica://ClaRa/Scripts/ConvertFrom022.mos"),
    from(version="1.0.1", script="modelica://ClaRa/Scripts/ConvertFrom101.mos")),
  Documentation(info="<html>
<p><img src=\"modelica://ClaRa/figures/ClaRaLibraryInfo.png\"/></p>
</html>"));
end ClaRa;
