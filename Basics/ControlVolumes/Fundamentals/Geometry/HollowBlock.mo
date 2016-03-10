within ClaRa.Basics.ControlVolumes.Fundamentals.Geometry;
model HollowBlock "Block shape || No interior"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.BlockShape;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry(
    final volume=width*height*length,
    final N_heat=1,
    final A_heat={if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then 2*(width + length)*height else 2*(width + height)*length},
    final A_cross=if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then (width*length) else (width*height),
    final A_front=A_cross,
    final A_hor=length*width,
    height_fill=height,
    final shape=[0, 1; 1, 1]);

  import SI = ClaRa.Basics.Units;

  parameter Units.Length height=1 "|Essential Geometry Definition|Height of the component; Fixed flow direction in case of vertical flow orientation";
  parameter Units.Length width=1 "|Essential Geometry Definition|Width of the component";
  parameter Units.Length length=1 "|Essential Geometry Definition|Length of the component; Fixed flow direction in case of horizontal flow orientation";
  parameter ClaRa.Basics.Choices.GeometryOrientation flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical "|Essential Geometry Definition|Flow orientation of the component";

equation
   for i in 1:N_inlet loop
     assert(if height_fill <> -1 then z_in[i]<=height_fill else true, "Position of inlet flange no. " +integerString(i, 1, 1)+ "("+realString(z_in[i], 1,3)+" m) must be below max. fill height of "+ realString(height_fill, 1,3) + " m in component " +  getInstanceName() + ".");
   end for;
   for i in 1:N_outlet loop
     assert(if height_fill <> -1 then z_out[i]<=height_fill else true, "Position of outlet flange no. " +integerString(i, 1, 1)+ "("+realString(z_out[i], 1,3)+" m) must be below max. fill height of "+ realString(height_fill, 1,3) + " m in component " +  getInstanceName() + ".");
   end for;
  for i in 1:N_inlet loop
    assert(z_in[i]>=0, "Position of inlet flange no. " +integerString(i, 1, 1)+ "("+realString(z_in[i], 1,3)+" m) must be positive in component " +  getInstanceName() + ".");
  end for;
  for i in 1:N_outlet loop
    assert(z_out[i]>=0, "Position of outlet flange no. " +integerString(i, 1, 1)+ "("+realString(z_out[i], 1,3)+" m) must be positive in component " +  getInstanceName() + ".");
  end for;
  assert(A_cross>0, "The cross section of the shell side must be > 0 but is "+realString(A_cross, 1, 3) + " in instance" + getInstanceName() + ".");
  assert(volume>0, "The volume of the shell side must be > 0 but is "+realString(volume, 1, 3) + " in instance" + getInstanceName() + ".");
  annotation (Icon(graphics={Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource=
            "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I0MAADjmzP13/OwhAgAA8GhCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEAAOqECAAAUCdEAACAOiECAADUCREAAKBOiAAAAHVCBAAAqBMiAABAnRABAADqhAgAAFAnRAAAgDohAgAA1AkRAACgTogAAAB1QgQAAKgTIgAAQJ0QAQAA6oQIAABQJ0QAAIA6IQIAANQJEQAAoE6IAAAAdUIEAACoEyIAAECdEAEA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",
          fileName="modelica://ClaRa/figures/Components/HollowBlock.png")}));
end HollowBlock;
