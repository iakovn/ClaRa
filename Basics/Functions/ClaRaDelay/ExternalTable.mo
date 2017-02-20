within ClaRa.Basics.Functions.ClaRaDelay;
class ExternalTable
  extends ExternalObject;
  function constructor
    output ExternalTable table;
    external "C" table = initXRGDelay() annotation (__iti_dll="ITI_Delay-V1.dll",Library={"Delay-V1","ModelicaExternalC"});
  end constructor;

  function destructor "Release storage of table"
    input ExternalTable table;
    external "C" deleteXRGDelay(table) annotation (__iti_dll="ITI_Delay-V1.dll",Library={"Delay-V1","ModelicaExternalC"});
  end destructor;
end ExternalTable;
