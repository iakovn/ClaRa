within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model NusseltShell2ph_L2 "Shell Geo, Horizontal Piping || L2 || HTC || Nusselt || 2ph"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.2.1                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2016, DYNCAP/DYNSTART research team.                     //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferVLE;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L2;

  outer ClaRa.SimCenter simCenter;
  outer parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium;

  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;

  import ClaRa.Basics.Functions.Stepsmoother;
  import FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph;
  import FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_KC;
  import FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam;
  import FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_KC;

  // TILMedia VLEFluidFunctions
  import fluidFunction_cp = TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_phxi;
  import fluidFunction_lambda = TILMedia.VLEFluidFunctions.thermalConductivity_phxi;
  import fluidFunction_eta = TILMedia.VLEFluidFunctions.dynamicViscosity_phxi;
  import fluidFunction_rho = TILMedia.VLEFluidFunctions.density_phxi;
  import fluidFunction_rho_bubble = TILMedia.VLEFluidFunctions.bubbleDensity_pxi;
  import fluidFunction_h_bubble = TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi;
  import fluidFunction_rho_dew = TILMedia.VLEFluidFunctions.dewDensity_pxi;
  import fluidFunction_h_dew = TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi;
  import fluidFunction_T_dew = TILMedia.VLEFluidFunctions.dewTemperature_pxi;
  import fluidFunction_x = TILMedia.VLEFluidFunctions.steamMassFraction_phxi;

  // TILMedia VLEFluidObjectFunctions
  import fluidObjectFunction_cp = TILMedia.VLEFluidObjectFunctions.specificIsobaricHeatCapacity_phxi;
  import fluidObjectFunction_lambda = TILMedia.VLEFluidObjectFunctions.thermalConductivity_phxi;
  import fluidObjectFunction_eta = TILMedia.VLEFluidObjectFunctions.dynamicViscosity_phxi;
  import fluidObjectFunction_x = TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi;
  import fluidObjectFunction_h_bubble = TILMedia.VLEFluidObjectFunctions.bubbleSpecificEnthalpy_pxi;
  import fluidObjectFunction_cp_bubble = TILMedia.VLEFluidObjectFunctions.bubbleSpecificIsobaricHeatCapacity_pxi;
  import fluidObjectFunction_rho_bubble = TILMedia.VLEFluidObjectFunctions.bubbleDensity_pxi;
  import fluidObjectFunction_h_dew = TILMedia.VLEFluidObjectFunctions.dewSpecificEnthalpy_pxi;
  import fluidObjectFunction_rho_dew = TILMedia.VLEFluidObjectFunctions.dewDensity_pxi;
  import fluidObjectFunction_T_dew = TILMedia.VLEFluidObjectFunctions.dewTemperature_pxi;
  import fluidObjectFunction_rho = TILMedia.VLEFluidObjectFunctions.density_phxi;

protected
  Modelica.SIunits.ReynoldsNumber Re_1ph "Reynolds number for one phase";
  Modelica.SIunits.NusseltNumber Nu_1ph "Nusselt number one tube row for one phase";
  Modelica.SIunits.PrandtlNumber Pr_1ph "Prandtl number of fluid for one phase";
  Real failureStatus_1ph "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";
  Real alpha_1ph;

  Modelica.SIunits.ReynoldsNumber Re_2ph "Reynolds number for one phase";
  Modelica.SIunits.NusseltNumber Nu_2ph "Nusselt number one tube row for one phase";
  Modelica.SIunits.PrandtlNumber Pr_2ph "Prandtl number of fluid for one phase";
  Real failureStatus_2ph "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";
  Real alpha_2ph;
  parameter Real steamQuality = TILMedia.VLEFluidFunctions.steamMassFraction_phxi(iCom.mediumModel, iCom.p_nom,iCom.h_nom,iCom.xi_nom);

//  Real smoother;
  SI.EnthalpyMassSpecific h_bubble=fluidObjectFunction_h_bubble(
      iCom.p_in,
      iCom.xi_in,
      iCom.fluidPointer_in);
  SI.EnthalpyMassSpecific h_dew=fluidObjectFunction_h_dew(
      iCom.p_in,
      iCom.xi_in,
      iCom.fluidPointer_in);
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_nom=if steamQuality >= (1 - eps) or steamQuality <= eps or heating_nom == true then kc_tubeBundle_1ph_KC(inCon_1ph, inVar_1ph_nom) else kc_tubeBundleFilmCondensation_lam(inCon_2ph, inVar_2ph_nom);
//  constant Real Teps=1e-3;
  constant Real heps=1000;

public
  final parameter Real C=if geo.staggeredAlignment then 1 else 0.8 "Correction factor for tube arrangement: offset pattern=1| aligned pattern=0.8"
                                                                                        annotation (Dialog(tab="General", group="Geometry"));
  parameter Boolean heating_nom=false "Ture, if nominal state implies heating, else fasle" annotation (Dialog(group="Heat Transfer"));
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));
  Modelica.SIunits.CoefficientOfHeatTransfer alpha;

  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_var inVar_2ph(
    cp_l=fluidObjectFunction_cp_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    lambda_l=fluidObjectFunction_lambda(
        iCom.p_out,
        fluidObjectFunction_h_bubble(
          iCom.p_out,
          iCom.xi_out,
          iCom.fluidPointer_out),
        iCom.xi_out,
        iCom.fluidPointer_out),
    rho_g=fluidObjectFunction_rho_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    rho_l=fluidObjectFunction_rho_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    eta_g=fluidObjectFunction_eta(
        iCom.p_out,
        fluidObjectFunction_h_dew(
          iCom.p_out,
          iCom.xi_out,
          iCom.fluidPointer_out),
        iCom.xi_out,
        iCom.fluidPointer_out),
    eta_l=fluidObjectFunction_eta(
        iCom.p_out,
        fluidObjectFunction_h_bubble(
          iCom.p_out,
          iCom.xi_out,
          iCom.fluidPointer_out),
        iCom.xi_out,
        iCom.fluidPointer_out),
    T_s=fluidObjectFunction_T_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    T_w=min(inVar_2ph.T_s - 1e-5, heat.T),
    dh_lg=max(1e-3, fluidObjectFunction_h_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) - fluidObjectFunction_h_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out)),
    m_flow=max(1e-5, abs(iCom.m_flow_in))) "noEvent(max(Modelica.Constants.eps, max(iCom.m_flow_in, iCom.m_flow_out)))"
                                                                                        annotation (Placement(transformation(extent={{-42,-100},{-22,-80}})));

  final parameter FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_con inCon_2ph(
    A_front=geo.A_front,
    d=geo.diameter_t,
    C=if geo.N_rows > 1 then C else 1) annotation (Placement(transformation(extent={{-14,-100},{6,-80}})));
  final parameter FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_con inCon_1ph(
    d=geo.diameter_t,
    staggeredAlignment=geo.staggeredAlignment,
    A_front=geo.A_front,
    s_1=geo.Delta_z_ort,
    s_2=geo.Delta_z_par,
    n=geo.N_rows) annotation (Placement(transformation(extent={{34,-100},{54,-80}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_var inVar_1ph(
    cp_w=fluid_wall.cp,
    eta_w=if heat.T < (inVar_2ph.T_s + 1e-6) and heat.T > (inVar_2ph.T_s - 1e-6) then inVar_1ph_nom.eta_w else fluid_wall.transp.eta,
    lambda_w=if heat.T < (inVar_2ph.T_s + 1e-6) and heat.T > (inVar_2ph.T_s - 1e-6) then inVar_1ph_nom.lambda_w else fluid_wall.transp.lambda,
    cp=fluidObjectFunction_cp(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    eta=fluidObjectFunction_eta(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    lambda=fluidObjectFunction_lambda(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    rho=fluidObjectFunction_rho(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    m_flow=max(1e-5, abs(iCom.m_flow_in))) "noEvent(max(Modelica.Constants.eps, max(iCom.m_flow_in, iCom.m_flow_out)))"
                                                                                        annotation (Placement(transformation(extent={{62,-100},{82,-80}})));
  TILMedia.VLEFluid_pT fluid_wall(
    T = heat.T,
    p = iCom.p_bulk,
    vleFluidType=medium,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    computeVLEAdditionalProperties=true) annotation (Placement(transformation(extent={{80,80},{100,100}})));
  final parameter FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_var inVar_2ph_nom(
    rho_g=TILMedia.VLEFluidFunctions.dewDensity_pxi(medium, iCom.p_nom),
    rho_l=TILMedia.VLEFluidFunctions.bubbleDensity_pxi(medium, iCom.p_nom),
    dh_lg=TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, iCom.p_nom) - TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, iCom.p_nom),
    T_w=if heating_nom then inVar_2ph_nom.T_s + 5 else inVar_2ph_nom.T_s - 5,
    T_s=TILMedia.VLEFluidFunctions.dewTemperature_pxi(medium, iCom.p_nom),
    m_flow=noEvent(max(0.000001, abs(iCom.m_flow_nom))),
    cp_l=TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_phxi(
        medium,
        iCom.p_nom,
        TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, iCom.p_nom)),
    lambda_l=TILMedia.VLEFluidFunctions.thermalConductivity_phxi(
        medium,
        iCom.p_nom,
        TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, iCom.p_nom)),
    eta_g=TILMedia.VLEFluidFunctions.dynamicViscosity_phxi(
        medium,
        iCom.p_nom,
        TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, iCom.p_nom)),
    eta_l=TILMedia.VLEFluidFunctions.dynamicViscosity_phxi(
        medium,
        iCom.p_nom,
        TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, iCom.p_nom))) "The correction term for considering the heat flow direction is switched off for the nominal calculation"
                                                                                        annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

public
  final parameter FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_var inVar_1ph_nom(
    cp=TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_phxi(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom),
    eta=TILMedia.VLEFluidFunctions.dynamicViscosity_phxi(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom),
    lambda=TILMedia.VLEFluidFunctions.thermalConductivity_phxi(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom),
    rho=TILMedia.VLEFluidFunctions.density_phxi(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom),
    cp_w=TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_phxi(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom),
    eta_w=TILMedia.VLEFluidFunctions.dynamicViscosity_phxi(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom),
    lambda_w=TILMedia.VLEFluidFunctions.thermalConductivity_phxi(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom),
    m_flow=noEvent(abs(iCom.m_flow_nom))) annotation (Placement(transformation(extent={{62,-70},{82,-50}})));
equation

  heat.Q_flow = if useHomotopy then homotopy(alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean, alpha_nom*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean) else alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean;

  // defining the HTC for a shell area, either heated or cooled flow supporting laminar film condensation and one phase heat transfer. Evaporation is NOT supported

  //alpha = smoother*alpha_2ph + (1 - smoother)*alpha_1ph;
  alpha = Stepsmoother(h_bubble, h_bubble + heps, iCom.h_out)*alpha_1ph
        + Stepsmoother(h_dew, h_dew - heps, iCom.h_out)*alpha_1ph
        + Stepsmoother(h_bubble + heps, h_bubble, iCom.h_out)*Stepsmoother(h_dew - heps, h_dew, iCom.h_out)*alpha_2ph;
  (alpha_2ph,Pr_2ph,Re_2ph,Nu_2ph,failureStatus_2ph) = kc_tubeBundleFilmCondensation_lam(inCon_2ph, inVar_2ph);
  (alpha_1ph,Pr_1ph,Re_1ph,Nu_1ph,failureStatus_1ph) = kc_tubeBundle_1ph(inCon_1ph, inVar_1ph);

  annotation (Icon(graphics));
end NusseltShell2ph_L2;
