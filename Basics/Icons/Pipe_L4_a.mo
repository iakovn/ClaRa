within ClaRa.Basics.Icons;
model Pipe_L4_a
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.3.1                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2018, DYNCAP/DYNSTART research team.                      //
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
          fileName="modelica://ClaRa/Resources/Images/Components/Pipe_L4_a.png")}),
      Diagram(graphics,
              coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},{
            140,50}})));

end Pipe_L4_a;
