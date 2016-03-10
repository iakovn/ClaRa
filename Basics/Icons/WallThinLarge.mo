within ClaRa.Basics.Icons;
model WallThinLarge
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.0                        //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright � 2013-2016, DYNCAP/DYNSTART research team.                     //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -50},{140,50}}),
                   graphics={Bitmap(
          extent={{-140,-50},{140,50}},
          imageSource=
              "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",
          fileName="modelica://ClaRa/figures/Components/WallThinLarge.png")}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},{
            140,50}})));

end WallThinLarge;
