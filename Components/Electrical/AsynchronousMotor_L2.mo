within ClaRa.Components.Electrical;
model AsynchronousMotor_L2 "A simple asynchronous e-motor"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.5.0                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  extends ClaRa.Basics.Icons.Motor;
  extends ClaRa.Components.Electrical.AsynchronousMotor_L2_base;


/////////////////////////////////////////////////////////
  Modelica.Blocks.Interfaces.RealInput U_term "Terminal voltage" annotation (Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput f_term "Excitation frequency" annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}),  iconTransformation(extent={{-140,20},{-100,60}})));


equation

  U_term=U;
  f_term=f;

end AsynchronousMotor_L2;
