within ClaRa.Basics.ControlVolumes.SolidVolumes.Check;
model TestThinWall

  ThinWall_L4 thinWall(
    diameter_o=0.5,
    diameter_i=0.44,
    length=1,
    T_start=ones(thinWall.N_ax)*500.15,
    initChoice=ClaRa.Basics.Choices.Init.steadyTemperature) annotation (Placement(transformation(extent={{-30,-4},{-2,6}})));
end TestThinWall;
