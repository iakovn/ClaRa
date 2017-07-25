within ClaRa.Basics.ControlVolumes.SolidVolumes.Check;
model TestThinWall
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  ThinWall_L4 thinWall(
    diameter_o=0.5,
    diameter_i=0.44,
    length=1,
    T_start=ones(thinWall.N_ax)*500.15,
    initOption=203)
    annotation (Placement(transformation(extent={{-30,-4},{-2,6}})));
end TestThinWall;
