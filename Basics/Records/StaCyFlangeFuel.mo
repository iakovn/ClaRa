within ClaRa.Basics.Records;
model StaCyFlangeFuel "A summary record for fuel flanges"
    extends ClaRa.Basics.Icons.RecordIcon;
    replaceable parameter ClaRa.Basics.Media.Fuel.PartialFuel fuelModel "Used medium model" annotation(Dialog(tab="System"));

    input ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate"
      annotation (Dialog);
    input ClaRa.Basics.Units.EnthalpyMassSpecific LHV "Lower heating value" annotation (Dialog);

    input ClaRa.Basics.Units.MassFraction xi[fuelModel.nc - 1] "Medium composition"  annotation(Dialog);
end StaCyFlangeFuel;
