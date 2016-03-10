within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
model RealSeparated "Separation | Real | outlet states depending on filling Level | All geometries"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealPhases;
  extends ClaRa.Basics.Icons.RealSeparation;
  import ClaRa.Basics.Functions.Stepsmoother;

  outer ClaRa.Basics.Records.IComVLE_L3 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;

  outer ClaRa.Basics.Choices.Init initType;
  outer parameter Boolean useHomotopy;

  parameter SI.Length radius_flange=0.05 "Flange radius";
  parameter Real absorbInflow(
    min=0,
    max=1) = 1 "absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality";
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "|Expert Settings|Shape interpretation|Smoothness of table interpolation";

  final parameter SI.Length z_max_in[geo.N_inlet]={min(geo.z_in[i] + radius_flange, geo.height_fill) for i in 1:geo.N_inlet} "Upper edges of inlet flanges";
  final parameter SI.Length z_min_in[geo.N_inlet]={max(1e-3, geo.z_in[i] - radius_flange) for i in 1:geo.N_inlet} "Lower edges of inlet flanges";
  final parameter SI.Length z_max_out[geo.N_outlet]={min(geo.z_out[i] + radius_flange, geo.height_fill) for i in 1:geo.N_outlet} "Upper edges of outlet flanges";
  final parameter SI.Length z_min_out[geo.N_outlet]={max(1e-3, geo.z_out[i] - radius_flange) for i in 1:geo.N_outlet} "Lower edges of outlet flanges";
  SI.DensityMassSpecific rho[iCom.N_cv];
  SI.MassFraction steamQuality_in[geo.N_inlet];
  SI.MassFraction steamQuality_out[geo.N_outlet];
  SI.Area A_hor_act "Actual horizontal surface size";
protected
  constant SI.Length level_abs_min=1e-6;
  Modelica.Blocks.Tables.CombiTable1D table(table=geo.shape, columns={2}, smoothness=smoothness);

equation
  //_________________________Calculation of the Level______________________________
  A_hor_act = geo.A_hor*table.y[1];
  table.u[1] = level_rel;

  level_abs = min(geo.height_fill, max(level_abs_min, iCom.volume[1]/(A_hor_act)));

  level_rel = level_abs/geo.height_fill;

  //_________________________Allocate mass flow rates to the two zones_____________
  m_flow_inliq = {semiLinear(
    iCom.m_flow_in[i],
    absorbInflow*(2 - zoneAlloc_in[i]) + (1 - absorbInflow)*(1 - steamQuality_in[i]),
    2 - zoneAlloc_in[i]) for i in 1:geo.N_inlet};
  m_flow_invap = {semiLinear(
    iCom.m_flow_in[i],
    absorbInflow*(zoneAlloc_in[i] - 1) + (1 - absorbInflow)*(steamQuality_in[i]),
    zoneAlloc_in[i] - 1) for i in 1:geo.N_inlet};
  m_flow_outliq = {semiLinear(
    iCom.m_flow_out[i],
    absorbInflow*(2 - zoneAlloc_out[i]) + (1 - absorbInflow)*(1 - steamQuality_out[i]),
    2 - zoneAlloc_out[i]) for i in 1:geo.N_outlet};
  m_flow_outvap = {semiLinear(
    iCom.m_flow_out[i],
    absorbInflow*(zoneAlloc_out[i] - 1) + (1 - absorbInflow)*(steamQuality_out[i]),
    zoneAlloc_out[i] - 1) for i in 1:geo.N_outlet};

  //_________________________Calculation of additional media data_________________
  rho = {TILMedia.VLEFluidObjectFunctions.density_phxi(
    iCom.p[i],
    iCom.h[i],
    iCom.xi[i, :],
    iCom.fluidPointer[i]) for i in 1:iCom.N_cv};
  steamQuality_in = {TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
    iCom.p_in[i],
    iCom.h_in[i],
    iCom.xi_in[i, :],
    iCom.fluidPointer_in[i]) for i in 1:iCom.N_inlet};
  steamQuality_out = {TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
    iCom.p_out[i],
    iCom.h_out[i],
    iCom.xi_out[i, :],
    iCom.fluidPointer_out[i]) for i in 1:iCom.N_outlet};

  //_________________________Calculation of the outflowing enthalpy _________________
  for i in 1:iCom.N_outlet loop
    //h_outflow_outliq[i] = Stepsmoother(z_min_out[i],z_max_out[i], level_abs)*iCom.h[2]+ (1-Stepsmoother(z_min_out[i],z_max_out[i], level_abs))*iCom.h[1];
    zoneAlloc_out[i] = Stepsmoother(
      z_min_out[i],
      z_max_out[i],
      level_abs) + 1;
  end for;
  for i in 1:iCom.N_inlet loop
    //h_inflow[i]  = Stepsmoother(z_min_in[i], z_max_in[i],  level_abs)*iCom.h[2]+ (1-Stepsmoother(z_min_in[i], z_max_in[i],  level_abs))*iCom.h[1];
    zoneAlloc_in[i] = Stepsmoother(
      z_min_in[i],
      z_max_in[i],
      level_abs) + 1;
  end for;

  //__________________Calculation of the geostatic pressure differences_______________
  Delta_p_geo_in = {(level_abs - geo.z_in[i])*Modelica.Constants.g_n*noEvent(if level_abs > geo.z_in[i] then rho[1] else rho[2]) for i in 1:geo.N_inlet};
  Delta_p_geo_out = {(level_abs - geo.z_out[i])*Modelica.Constants.g_n*noEvent(if level_abs > geo.z_out[i] then rho[1] else rho[2]) for i in 1:geo.N_outlet};

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end RealSeparated;
