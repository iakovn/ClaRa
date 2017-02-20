within ClaRa.Components.TurboMachines.Fundamentals;
record ICom
  extends ClaRa.Basics.Icons.IComIcon;
  import SI = ClaRa.Basics.Units;

//____Inlet______________________________________________________________________________
  input SI.MassFlowRate  m_flow_in "Inlet mass flow" annotation(Dialog(tab="Inlet"));
  input SI.DensityMassSpecific  rho_in "Inlet density" annotation(Dialog(tab="Inlet"));
//_____Nominal___________________________________________________________________________
  parameter input SI.MassFlowRate  m_flow_nom=10 "Nominal mass flow" annotation(Dialog(tab="Nominal"));
  parameter input SI.DensityMassSpecific  rho_nom=10 "Nominal inlet density" annotation(Dialog(tab="Nominal"));

  input SI.RPM rpm "Shaft speed";
  input SI.EnthalpyMassSpecific Delta_h_is "Isentropic enthalpy drop";
end ICom;
