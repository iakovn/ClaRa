within ClaRa.Basics.Records;
model StaCyFlangeVLE "A summary of flange flow properties for StaCy components"
  extends Icons.RecordIcon;

  input Units.MassFlowRate m_flow "Mass flow rate" annotation(Dialog);
  input Units.Pressure p "Pressure" annotation(Dialog);
  input Units.EnthalpyMassSpecific h "Specific enthalpy" annotation(Dialog);

end StaCyFlangeVLE;
