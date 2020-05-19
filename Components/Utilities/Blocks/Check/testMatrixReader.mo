within ClaRa.Components.Utilities.Blocks.Check;
model testMatrixReader "Two ways how to read a matrix from file"
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

//   import DataFiles;
  parameter Real  A[:,:]=readMATRIX.M;
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  ClaRa.Components.Utilities.Blocks.ReadMatrixFromFile readMATRIX(
    fileName="modelica://ClaRa/Resources/TableBase/exampleTable.mat", matrixName="ABCD")
    annotation (Placement(transformation(extent={{-24,-16},{-4,4}})));
equation

  annotation (experiment(StopTime=1));
end testMatrixReader;
