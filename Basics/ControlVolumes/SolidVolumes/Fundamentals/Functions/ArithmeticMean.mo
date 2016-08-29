within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions;
function ArithmeticMean "Use arithmetic mean, i.e. (In1 + In2)/2"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.1                        //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright © 2013-2016, DYNCAP/DYNSTART research team.                     //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  extends GeneralMean;

algorithm
  Out :=(in1 + in2)/2;
end ArithmeticMean;
