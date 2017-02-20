within ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions;
model NoReaction_L2 "Gas || L2 || No Chemical Reactions"

  extends ChemicalReactionsBaseGas(final i=1, final use_signal=false);

equation

  Q_flow_reaction = 0;
  m_flow_reaction[1] = 0;
  h_reaction[1] = 0;

  //No auxillary step
  xi_aux=iCom.xi_in;
  m_flow_aux=iCom.m_flow_in;
  h_aux=TILMedia.GasObjectFunctions.specificEnthalpy_pTxi(iCom.p_in,iCom.T_in,iCom.xi_in,iCom.fluidPointer_in);

  if use_dynamicMassbalance then
     der(xi) =
      1/mass * (iCom.m_flow_in*(iCom.xi_in - xi) + iCom.m_flow_out*(iCom.xi_out - xi));
  else
     zeros(iCom.mediumModel.nc-1) =
       (iCom.m_flow_in*(iCom.xi_in - xi) + iCom.m_flow_out*(iCom.xi_out - xi));
  end if;

end NoReaction_L2;
