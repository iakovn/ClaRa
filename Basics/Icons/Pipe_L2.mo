within ClaRa.Basics.Icons;
model Pipe_L2
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
          fileName="modelica://ClaRa/figures/Components/PipeLarge.png")}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},{
            140,50}})));

end Pipe_L2;
