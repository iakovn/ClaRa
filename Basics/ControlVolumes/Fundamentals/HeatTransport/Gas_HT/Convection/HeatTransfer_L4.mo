within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection;
partial model HeatTransfer_L4 "Gas || HT Base Class"
  extends ClaRa.Basics.Icons.Alpha;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_L4;
  outer ClaRa.Basics.Records.IComGas_L3 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv geo;
  outer parameter Boolean useHomotopy;

  Modelica.SIunits.MassFlowRate m_flow[iCom.N_cv + 1] "Mass flow rate";
  Modelica.SIunits.Temperature T_mean[iCom.N_cv];
  ClaRa.Basics.Interfaces.HeatPort_a heat[iCom.N_cv] annotation (Placement(transformation(extent={{80,80},{100,100}}), iconTransformation(extent={{80,80},{100,100}})));
  annotation (Icon(graphics));
end HeatTransfer_L4;
