within ClaRa.Basics.ControlVolumes.SolidVolumes;
model NTU_L3 "Base heat exchanger wall model with liquid, vapour and 2ph zones"
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

  import SI = ClaRa.Basics.Units;
  import ClaRa.Basics.Functions.Stepsmoother;

  extends ClaRa.Basics.Icons.NTU;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;

//_____________material definitions_________________________________________//

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium_shell=simCenter.fluid1 "Medium of shell side"
                              annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium_tubes=simCenter.fluid1 "Medium of tubes side"
                              annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
                                                               annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model HeatExchangerType =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow_L3
    constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger_L3 "Type of HeatExchanger"
                            annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  inner parameter Boolean outerPhaseChange=true "True, if phase change may occur at outer side"
                                                    annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);

//______________geometry definitions________________________________________//
  parameter Integer N_t=1 "Number of tubes in one pass" annotation(Dialog(group="Geometry"));
  parameter Integer N_p=1 "Number of passes" annotation(Dialog(group="Geometry"));
  parameter SI.Length length "Tube length (for one pass)" annotation(Dialog(group="Geometry"));
  parameter SI.Length radius_i "Inner radius of tube" annotation(Dialog(group="Geometry"));
  parameter SI.Length radius_o "Outer radius of tube" annotation(Dialog(group="Geometry"));
  parameter Real mass_struc = 0 "Mass of inner structure elements, additional to the tubes itself"                   annotation(Dialog(group="Geometry"));
  discrete SI.Mass mass "Total mass of HEX";
  parameter Real CF_geo=1 "Correction coefficient due to fins etc." annotation(Dialog(group="Geometry"));

//Area of Heat Transfer
  final parameter SI.Area A_heat_m = (A_heat_o-A_heat_i)/log(A_heat_o/A_heat_i) "Mean area of heat transfer (single tube)";
  final parameter SI.Area A_heat_i= 2*Modelica.Constants.pi*radius_i*length*N_t*N_p "Area of heat transfer at inner phase";
  final parameter SI.Area A_heat_o= 2*Modelica.Constants.pi*radius_o*length*N_t*N_p "Area of heat transfer at oter phase";

//______________Initialisation______________________________________________//
  parameter SI.Temperature T_w_i_start[3]= ones(3)*293.15 "|Initialisation||Initial temperature at inner phase";
  parameter SI.Temperature T_w_o_start[3] = ones(3)*293.15 "|Initialisation||Initial temperature at outer phase";
  parameter ClaRa.Basics.Choices.Init initChoice=ClaRa.Basics.Choices.Init.noInit "|Initialisation||Init Option"                    annotation(Dialog(group="Initialisation"));

protected
  final parameter Boolean smallShellFlow_start[3] = {not outerPhaseChange,not outerPhaseChange,not outerPhaseChange};

//______________Expert Settings____________________________________________//
public
  replaceable function HeatCapacityAveraging =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.ArithmeticMean
    constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.GeneralMean "|Expert Settings||Method for Averaging of heat capacities"
                                                                annotation(choicesAllMatching);
  parameter Real gain_eff= 1 "|Expert Settings||Avoid effectiveness > 1, high gain_eff leads to stricter observation but may cause numeric errors";
  parameter SI.Time Tau_stab=0.1 "|Expert Settings||Time constant for state stabilisation";
//______________Inputs_____________________________________________________//

public
  input SI.Pressure p_o "Pressure at outer side" annotation (Dialog(group="Input"));
  input SI.Pressure p_i "Pressure at inner side" annotation (Dialog(group="Input"));
  input SI.EnthalpyMassSpecific h_i_inlet "Inlet temperature of inner flow"
    annotation (Dialog(group="Input"));
  input SI.EnthalpyMassSpecific h_o_inlet "Inlet temperature of outer flow"
    annotation (Dialog(group="Input"));

  input SI.MassFlowRate m_flow_i "Mass flow rate of inner side"      annotation (Dialog(group="Input"));
  input SI.MassFlowRate m_flow_o "Mass flow rate of outer side" annotation (Dialog(group="Input"));

  input SI.CoefficientOfHeatTransfer alpha_i[3] "Coefficient of heatTransfer for inner side for regions |1|2|3|"
                                                                     annotation (Dialog(group="Input"));
  input SI.CoefficientOfHeatTransfer alpha_o[3] "Coefficient of heatTransfer for outer side for regions |1|2|3|"
                                                                     annotation (Dialog(group="Input"));

  inner input SI.AreaFraction yps_1ph "Area fraction of zone A"
                                                               annotation (Dialog(group="Input"));
  inner input SI.AreaFraction yps_2ph "Area fraction of zone B"
                                                               annotation (Dialog(group="Input"));

//______________Summaries and Visualisation________________________________//
  parameter Boolean showExpertSummary = false "|Summaries and Visualisation||True,if expert summaries shall be shown";
//______________Variables__________________________________________________//
//
  Real kA[3](unit="W/K") "The product U*S for regions |1|2|3|";
  SI.HeatFlowRate Q_flow[3] "Heat flow rate of zones |1|2|3|";
  HeatExchangerType HEXtype(NTU_1=NTU_1, R_1=R_1);
  Real cp_error_[3] "Check: Deviation from constant cp in zones |1|2|3|";
  Real effectiveness_act[3] "Actual effectiveness of zones |1|2|3|";
  Real effectiveness[3] "Effectiveness of zones |1|2|3|";
  Real NTU_1[3] "Number of transfer units in zones |1|2|3|";
  Real C_flow_low[3] "Lower heat capacity flow in zones |1|2|3|";
  Real C_flow_high[3] "Higher heat capacity flow in zones |1|2|3|";
  SI.HeatCapacityMassSpecific cp_o[3](start=ones(3)*3000);
  SI.HeatCapacityMassSpecific cp_i[3](start=ones(3)*3000);
//   Real k=(0.5*mass*solid[3].cp)/100;
protected
  SI.Temperature T_w_i[3](start=T_w_i_start) "Wall temperature at inner phase";
  SI.Temperature T_w_o[3](start=T_w_o_start) "Wall temperature at outer phase";
  Boolean smallShellFlow[3](start=smallShellFlow_start);
  SI.HeatFlowRate Q_flow_s[3] "Stabilised heat flow rate of zones |1|2|3|";

  Real R_1[3] "Aspect ratio of heat capacity flows in zones |1|2|3|";
  Real yps[3] "Area fractions";

public
record Summary
extends ClaRa.Basics.Icons.RecordIcon;
ECom eCom;
  parameter Boolean showExpertSummary;
  SI.HeatFlowRate Q_flow[3] "Heat flow rate of zones |1|2|3|";
  SI.HeatFlowRate Q_flow_tot "Total heat flow rate";
  Real C_flow_low[3] if  showExpertSummary "Lower heat capacity flow in zones |1|2|3|";
  Real C_flow_high[3] if  showExpertSummary "Higher heat capacity flow in zones |1|2|3|";
  Real C_flow_i[3] if  showExpertSummary "Inner side heat capacity flow in zones |1|2|3|";
  Real C_flow_o[3] if  showExpertSummary "Outer side heat capacity flow in zones |1|2|3|";

  SI.Temperature T_i[6] "Temperatures (i/o) of outer flow zones |1|2|3|";
  SI.Temperature T_o[6] "Temperatures (i/o) of outer flow zones |1|2|3|";

  SI.Temperature T_i_sat "Inner side saturation temperature";
  SI.Temperature T_o_sat "Outer side saturation temperature";

  Real yps[3] "Area fractions";
  Real effectiveness[3];
  Real cp_error_[3] if showExpertSummary "Check: Deviation from constant cp in zones |1|2|3|";
  Real kA[3](unit="W/K") "The product U*A for regions |1|2|3|";
  SI.HeatCapacityMassSpecific cp_o[3] "Heat capacity";
  SI.HeatCapacityMassSpecific cp_i[3] "Heat capacity";
  Units.DensityMassSpecific d[3] "Material density";
end Summary;

record ECom
extends ClaRa.Basics.Icons.RecordIcon;
  Real z_i[6] "Zone positions at the inner side of the heat exchanger";
  Real z_o[6] "Zone positions at the outer side of the heat exchanger";
  SI.EnthalpyMassSpecific h_i[6] "Specific enthalpies (i/o) of inner flow zones |1|2|3|";
  SI.EnthalpyMassSpecific h_o[6] "Specific enthalpies (i/o) of outer flow zones |1|2|3|";
end ECom;
public
inner TILMedia.VLEFluid_ph O1_in(
     vleFluidType=medium_shell,
    h=(iCom.h_o_in[1]),
    p=p_o)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

inner TILMedia.VLEFluid_ph   O3_out(
     vleFluidType=medium_shell,
    p=p_o,
    h=iCom.h_o_out[3])
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

inner TILMedia.VLEFluid_ph   I1_out(
     vleFluidType=medium_tubes,
    p=p_i,
    h=iCom.h_i_out[1])
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

inner TILMedia.VLEFluid_ph O2_in(
    vleFluidType=medium_shell,
    p=p_o,
    h=iCom.h_o_in[2])
    annotation (Placement(transformation(extent={{-32,10},{-12,30}})));

inner TILMedia.VLEFluid_ph I2_out(
     vleFluidType=medium_tubes,
    p=p_i,
    h=iCom.h_i_out[2])
    annotation (Placement(transformation(extent={{-34,-30},{-14,-10}})));
inner TILMedia.VLEFluid_ph I3_in(
   vleFluidType=medium_tubes,
    p=p_i,
    h=iCom.h_i_in[3])
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
inner TILMedia.VLEFluid_ph O2_out(
    vleFluidType=medium_shell,
    p=p_o,
    h=iCom.h_o_out[2])
    annotation (Placement(transformation(extent={{14,10},{34,30}})));
inner TILMedia.VLEFluid_ph I2_in(
     vleFluidType=medium_tubes,
    p=p_i,
    h=iCom.h_i_in[2])
    annotation (Placement(transformation(extent={{14,-30},{34,-10}})));

   TILMedia.Solid solid[3](redeclare replaceable model SolidType = Material, T=(
        T_w_i + T_w_o)/2)
     annotation (Placement(transformation(extent={{40,54},{60,74}})));
public
  Summary summary(eCom( z_o = HEXtype.z_o,
    z_i = HEXtype.z_i,
    h_i={iCom.h_i_in[1], iCom.h_i_out[1],iCom.h_i_in[2], iCom.h_i_out[2],iCom.h_i_in[3], iCom.h_i_out[3]},
    h_o={iCom.h_o_in[1], iCom.h_o_out[1],iCom.h_o_in[2], iCom.h_o_out[2],iCom.h_o_in[3], iCom.h_o_out[3]}),
    showExpertSummary = showExpertSummary,
    Q_flow=Q_flow,
    T_i_sat=I3_in.VLE.T_v,
    T_o_sat=O1_in.VLE.T_v,
    C_flow_low=C_flow_low,
    C_flow_high=C_flow_high,
    C_flow_i=cp_i*m_flow_i.*HEXtype.ff_i,
    C_flow_o=cp_o*m_flow_o.*HEXtype.ff_o,
    T_i= iCom.T_in2out_i,
    T_o= iCom.T_in2out_o,
    yps=HEXtype.yps,
    Q_flow_tot = sum(Q_flow_s),
    effectiveness=effectiveness_act,
    cp_error_=cp_error_,
    kA=kA,
    cp_o={cp_o[1],cp_o[2],cp_o[3]},
    cp_i={cp_i[1],cp_i[2],cp_i[3]},
    d={solid[1].d,solid[2].d,solid[3].d})
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
    ClaRa.Basics.Interfaces.HeatPort_a
                                     outerPhase[3] "outer side of cylinder"
                                           annotation (Placement(transformation(
          extent={{-10,80},{10,100}}, rotation=0), iconTransformation(extent={{-10,80},{10,100}})));
    ClaRa.Basics.Interfaces.HeatPort_a
                                     innerPhase[3] "inner side of cylinder"
                                           annotation (Placement(transformation(extent={{-10,-100},{10,-80}},rotation=0),
        iconTransformation(extent={{-10,-100},{10,-80}})));
public
  inner ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.ICom_NTU_L3
                                    iCom(
    h_o_inlet=h_o_inlet,
    h_i_inlet=h_i_inlet,
    h_i_in=HEXtype.h_i_in,
    h_o_in=HEXtype.h_o_in,
    h_o_vap=O1_in.VLE.h_v,
    h_o_bub=O1_in.VLE.h_l,
    h_i_vap=I1_in.VLE.h_v,
    h_i_bub=I1_in.VLE.h_l,
    T_in2out_o=HEXtype.T_in2out_o,
    T_in2out_i=HEXtype.T_in2out_i,
    T_123_o={O1_in.T,O1_out.T,O2_in.T,O2_out.T,O3_in.T,O3_out.T},
    T_123_i={I1_in.T,I1_out.T,I2_in.T,I2_out.T,I3_in.T,I3_out.T})
    annotation (Placement(transformation(extent={{60,-102},{80,-82}})));

protected
inner TILMedia.VLEFluid_ph O1_out(
     vleFluidType=medium_shell,
    p=p_o,
    h=iCom.h_o_out[1])
    annotation (Placement(transformation(extent={{-54,10},{-34,30}})));
inner TILMedia.VLEFluid_ph O3_in(
    vleFluidType=medium_shell,
    p=p_o,
    h=iCom.h_o_in[3])
    annotation (Placement(transformation(extent={{34,10},{54,30}})));
inner TILMedia.VLEFluid_ph I1_in(
    vleFluidType=medium_tubes,
    p=p_i,
    h=iCom.h_i_in[1])
    annotation (Placement(transformation(extent={{-54,-30},{-34,-10}})));
inner TILMedia.VLEFluid_ph I3_out(
   vleFluidType=medium_tubes,
    p=p_i,
    h=iCom.h_i_out[3])
annotation (Placement(transformation(extent={{36,-30},{56,-10}})));

equation
  cp_o[1] = homotopy(HeatCapacityAveraging(O1_in.cp, O1_out.cp), 3000);
  cp_o[2] = if not outerPhaseChange then homotopy(HeatCapacityAveraging(O2_in.cp,O2_out.cp), 3000) else Modelica.Constants.inf;
  cp_o[3] = homotopy( HeatCapacityAveraging(O3_in.cp,  O3_out.cp), 3000);

  cp_i[1] = homotopy(HeatCapacityAveraging(I1_in.cp,  I1_out.cp), 3000); //case2:2085.84;//case1:4189.93;//
  cp_i[2] = if outerPhaseChange then homotopy(HeatCapacityAveraging(I2_in.cp,  I2_out.cp), 3000) else Modelica.Constants.inf;
  cp_i[3] = homotopy(HeatCapacityAveraging(I3_in.cp,  I3_out.cp), 3000);

  der(yps) = (HEXtype.yps-yps)/Tau_stab;

when initial() then
  mass = mass_struc + solid[1].d*N_t*N_p*length*Modelica.Constants.pi*(radius_o^2-radius_i^2);
end when;

//Heat transfer coefficient
  kA = {HEXtype.yps[1], HEXtype.yps[2], HEXtype.yps[3]}.*{2*Modelica.Constants.pi*length*N_p*N_t/(1/(alpha_i[i]*radius_i) + log(radius_o/radius_i)/solid[i].lambda + 1/(CF_geo * alpha_o[i]*radius_o)) for i in 1:3};

//Wall temperatures:
    innerPhase.T = T_w_i;
    outerPhase.T = T_w_o;

// innerPhase.T=k*(innerPhase.T-T_w_i);
// outerPhase.T=k*(outerPhase.T-T_w_o);

//Energy Balance:
  der(T_w_i[1])=(innerPhase[1].Q_flow+Q_flow_s[1] - solid[1].cp*solid[1].T * mass/2*der(yps[1]))/(max(1e-3,yps[1])*mass/2*solid[1].cp);
  der(T_w_o[1])=(outerPhase[1].Q_flow-Q_flow_s[1] - solid[1].cp*solid[1].T * mass/2*der(yps[1]))/(max(1e-3,yps[1])*mass/2*solid[1].cp);
  der(T_w_i[2])=(innerPhase[2].Q_flow+Q_flow_s[2] - solid[2].cp*solid[2].T * mass/2*der(yps[2]))/(max(1e-3,yps[2])*mass/2*solid[2].cp);
  der(T_w_o[2])=(outerPhase[2].Q_flow-Q_flow_s[2] - solid[2].cp*solid[2].T * mass/2*der(yps[2]))/(max(1e-3,yps[2])*mass/2*solid[2].cp);
  der(T_w_i[3])=(innerPhase[3].Q_flow+Q_flow_s[3] - solid[3].cp*solid[3].T * mass/2*der(yps[3]))/(max(1e-3,yps[3])*mass/2*solid[3].cp);
  der(T_w_o[3])=(outerPhase[3].Q_flow-Q_flow_s[3] - solid[3].cp*solid[3].T * mass/2*der(yps[3]))/(max(1e-3,yps[3])*mass/2*solid[3].cp);

//_____________calculation of actual effectivenesses__________________________________//
    effectiveness_act[1] = noEvent(if O1_in.T-I1_in.T > 1e-6 then if smallShellFlow[1] then abs((O1_in.T - O1_out.T)/(O1_in.T-I1_in.T)) else abs((I1_in.T - I1_out.T)/(O1_in.T-I1_in.T)) else 0);
    effectiveness_act[2] = noEvent(if O2_in.T-I2_in.T > 1e-6 then if smallShellFlow[2] then abs((O2_in.T - O2_out.T)/(O2_in.T-I2_in.T)) else abs((I2_in.T - I2_out.T)/(O2_in.T-I2_in.T)) else 0);
    effectiveness_act[3] = noEvent(if O3_in.T-I3_in.T > 1e-6 then if smallShellFlow[3] then abs((O3_in.T - O3_out.T)/(O3_in.T-I3_in.T)) else abs((I3_in.T - I3_out.T)/(O3_in.T-I3_in.T)) else 0);

//  assert(cp_i_B < 1e10 and cp_o_B < 1e10, "PHASE CHANGE ON BOTH SIDES not supported");

//____________Heat capacity flows_____________________________________________________//

    C_flow_low = {noEvent(min(cp_o[i]*abs(m_flow_o*HEXtype.ff_o[i]+1e-6), cp_i[i]*abs(m_flow_i*HEXtype.ff_i[i]+1e-6))) for i in 1:3};
//____The following formulation can be seen as an alternative to the line above avoiding discontinuities arising from the min evaluation___________________________
//   C_flow_low = {Stepsmoother(-1e-3, +1e-3, cp_o[i]*abs(m_flow_o*HEXtype.ff_o[i]) - cp_i[i]*abs(m_flow_i*HEXtype.ff_i[i]))*cp_o[i]*abs(m_flow_o*HEXtype.ff_o[i])
//               + Stepsmoother(+1e-3, -1e-3, cp_o[i]*abs(m_flow_o*HEXtype.ff_o[i]) - cp_i[i]*abs(m_flow_i*HEXtype.ff_i[i]))*cp_i[i]*abs(m_flow_i*HEXtype.ff_i[i]) for i in 1:3};
//_________________________________________________________________________________________________________________________________________________________________

  C_flow_high[1] = noEvent(max(cp_o[1]*abs(m_flow_o*HEXtype.ff_o[1]+1e-6), cp_i[1]*abs(m_flow_i*HEXtype.ff_i[1]+1e-6)));
  C_flow_high[2] = noEvent(if cp_i[2] > 1e10 and cp_o[2] > 1e10 then  Modelica.Constants.inf else noEvent(max(cp_o[2]*abs(m_flow_o*HEXtype.ff_o[2]+1e-6), cp_i[2]*abs(m_flow_i*HEXtype.ff_i[2]+1e-6))));
  C_flow_high[3] = noEvent(max(cp_o[3]*abs(m_flow_o*HEXtype.ff_o[3]+1e-6), cp_i[3]*abs(m_flow_i*HEXtype.ff_i[3]+1e-6)));

  R_1 = C_flow_low./(C_flow_high + ones(3)*Modelica.Constants.eps);

   smallShellFlow[1] = if (cp_o[1]*abs(m_flow_o*HEXtype.ff_o[1]+1e-6) - cp_i[1]*abs(m_flow_i*HEXtype.ff_i[1]+1e-6))<1e-3 then true else false;
   smallShellFlow[2] = not outerPhaseChange; //if (cp_o_B*abs(m_flow_o) - cp_i_B*abs(m_flow_i))<1e-3 then true else false;
   smallShellFlow[3] = if (cp_o[1]*abs(m_flow_o*HEXtype.ff_o[3]+1e-6) - cp_i[1]*abs(m_flow_i*HEXtype.ff_i[3]+1e-36))<1e-3 then true else false;

//____________Number of Transer Units_______________________________________________//

  NTU_1 = kA./(C_flow_low + ones(3)*Modelica.Constants.eps).*HEXtype.CF_NTU;

//____________effectivenesses of the three zones_____________________________________//
  effectiveness[1] =  noEvent(if R_1[1] <1  then (1 - exp(-NTU_1[1] *(1-R_1[1])))/(1 - R_1[1]*exp(-NTU_1[1]*(1-R_1[1]))) else NTU_1[1]/(1+NTU_1[1]));//vapour zone
  effectiveness[2] =  (1 - exp(-NTU_1[2]));//2phase  zone
  effectiveness[3] =  noEvent(if R_1[3] < 1 then (1 - exp(-NTU_1[3] *(1-R_1[3])))/(1 - R_1[3]*exp(-NTU_1[3]*(1-R_1[3]))) else NTU_1[3]/(1+NTU_1[3])); //liquid zone

//____________Specific enthalpies in each zone _____________________________________//
  iCom.h_o_out   =  - Q_flow_s./(m_flow_o*HEXtype.ff_o+ones(3)*1e-6) + iCom.h_o_in;

  iCom.h_i_out   = Q_flow_s./(m_flow_i*HEXtype.ff_i+ones(3)*1e-6) + iCom.h_i_in;

//____________Heat flow rate from effectivenesses__________________________________//
  Q_flow  = {effectiveness[i] * C_flow_low[i] * (iCom.T_123_o[i*2-1] - iCom.T_123_i[i*2-1])  * noEvent(max(0,homotopy(1-gain_eff*max(0,min(1,effectiveness[i]-1)),1))) for i in 1:3};

  der(Q_flow_s) = (Q_flow - Q_flow_s)/Tau_stab;

//   cp_error_[1] = 1-(abs(Q_flow[1])-noEvent(if smallShellFlow[1] then abs(O1_in.T - O1_out.T) else abs(I2_out.T-I1_out.T)) *C_flow_low[1])/abs(Q_flow[1]+1e-3);
//   cp_error_[2] = 1-(abs(Q_flow[2])-noEvent(if smallShellFlow[2] then abs(O2_in.T - O2_out.T) else abs(I2_in.T-I2_out.T)) *C_flow_low[2])/abs(Q_flow[2]+1e-3);
//   cp_error_[3] = 1-(abs(Q_flow[3])-noEvent(if smallShellFlow[3] then abs(O2_out.T - O3_out.T) else abs(I3_in.T-I2_in.T)) *C_flow_low[3])/abs(Q_flow[3]+1e-3);
  cp_error_ = {(abs(Q_flow[i])-noEvent(if smallShellFlow[i] then abs(iCom.T_123_o[2*i-1] - iCom.T_123_o[2*i]) else abs(iCom.T_123_i[i*2-1]-iCom.T_123_i[2*i])) *C_flow_low[i])/abs(Q_flow[i]+1e-3) for i in 1:3};
initial equation
  yps=HEXtype.yps;

  if initChoice == ClaRa.Basics.Choices.Init.steadyState then
    der(Q_flow_s)=zeros(3);
    der(T_w_i)=zeros(3);
    der(T_w_o)=zeros(3);
  elseif initChoice == ClaRa.Basics.Choices.Init.steadyTemperature then
    der(T_w_i)=zeros(3);
    der(T_w_o)=zeros(3);
  else
    Q_flow_s=Q_flow;

  end if;

  annotation (Icon(coordinateSystem(
          preserveAspectRatio=false, initialScale=0.1)),
                           Diagram(coordinateSystem(extent={{-140,-100},{140,
            100}}, preserveAspectRatio=true),
                                   graphics={        Rectangle(
          extent={{-100,-4},{100,-30}},
          lineColor={127,0,0},
          fillColor={74,120,145},
          fillPattern=FillPattern.Backward),         Rectangle(
          extent={{-100,30},{100,4}},
          lineColor={127,0,0},
          fillColor={74,120,145},
          fillPattern=FillPattern.Backward),
        Line(
          points={{36,-4},{36,-30}},
          color={127,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-100,32},{-34,-2}},
          lineColor={127,0,0},
          textString="1"),
        Text(
          extent={{-34,32},{34,0}},
          lineColor={127,0,0},
          textString="2"),
        Text(
          extent={{34,34},{100,2}},
          lineColor={127,0,0},
          textString="3"),
        Text(
          extent={{-34,-4},{34,-36}},
          lineColor={127,0,0},
          textString="2"),
        Text(
          extent={{-100,-4},{-32,-34}},
          lineColor={127,0,0},
          textString="1"),
        Text(
          extent={{38,-4},{104,-36}},
          lineColor={127,0,0},
          textString="3"),
        Line(
          points={{36,30},{36,4}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-32,30},{-32,4}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-32,-4},{-32,-30}},
          color={127,0,0},
          smooth=Smooth.None)}));
end NTU_L3;
