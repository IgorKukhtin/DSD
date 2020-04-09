unit GetSystemInfo;

interface

uses System.SysUtils, System.Types, System.Variants, System.UITypes, System.Classes,
     Winapi.Windows, System.Win.ComObj, Winapi.ActiveX;

function GetWMIInfo(const WMIClass, WMIProperty :string): string;
function GetWMISum(const WMIClass, WMIProperty :string): Int64;
function GetWMIInt64(const WMIClass, WMIProperty :string): Int64;

const MemoryType : array[0..25] of string = ('Unknown', 'Other', 'DRAM', 'Synchronous DRAM', 'Cache DRAM',
                                             'EDO', 'EDRAM', 'VRAM', 'SRAM', 'RAM',
                                             'ROM', 'FLASH', 'EEPROM', 'FEPROM', 'EPROM',
                                             'CDRAM', '3DRAM', 'SDRAM', 'SGRAM', 'RDRAM',
                                             'DDR', 'DDR2', 'DDR2 FB-DIMM', '', 'DDR3', 'FBD2');

implementation

function GetWMIInfo(const WMIClass, WMIProperty :string): string;
var
  sWbemLocator  : OLEVariant;
  sWMIService   : OLEVariant;
  sWbemObjectSet: OLEVariant;
  sWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
begin;
  Result:='';
  sWbemLocator  := CreateOleObject('WbemScripting.SWbemLocator');
  try
    try
      sWMIService   := sWbemLocator.ConnectServer('', 'root\CIMV2', '', '');
      sWbemObjectSet:= sWMIService.ExecQuery('SELECT ' + WMIProperty + ' FROM ' + WMIClass, 'WQL');
      oEnum         := IUnknown(sWbemObjectSet._NewEnum) as IEnumVariant;
      if oEnum.Next(1, sWbemObject, iValue) = 0 then
        case VarType(sWbemObject.Properties_.Item(WMIProperty).Value) of
          varEmpty    : Result := 'Empty';
          varNull     : Result := 'Null';
          varArray    : Result := sWbemObject.Properties_.Item(WMIProperty).Value[0];
          8204        : Result := sWbemObject.Properties_.Item(WMIProperty).Value[0];
          else Result := sWbemObject.Properties_.Item(WMIProperty).Value;
        end;
    except
    end
  finally
    sWbemLocator := Unassigned;
  end
end;

function GetWMISum(const WMIClass, WMIProperty :string): Int64;
var
  sWbemLocator  : OLEVariant;
  sWMIService   : OLEVariant;
  sWbemObjectSet: OLEVariant;
  sWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  I             : Int64;
begin;
  Result := 0;
  sWbemLocator  := CreateOleObject('WbemScripting.SWbemLocator');
  try
    try
      sWMIService   := sWbemLocator.ConnectServer('', 'root\CIMV2', '', '');
      sWbemObjectSet:= sWMIService.ExecQuery('SELECT ' + WMIProperty + ' FROM ' + WMIClass, 'WQL');
      oEnum         := IUnknown(sWbemObjectSet._NewEnum) as IEnumVariant;
      While oEnum.Next(1, sWbemObject, iValue) = 0 Do
      begin
        if TryStrToInt64(sWbemObject.Properties_.Item(WMIProperty).Value, I) then Result := Result + I;
      end;
    except
    end
  finally
    sWbemLocator := Unassigned;
  end
end;

function GetWMIInt64(const WMIClass, WMIProperty :string): Int64;
var
  sWbemLocator  : OLEVariant;
  sWMIService   : OLEVariant;
  sWbemObjectSet: OLEVariant;
  sWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  I             : Int64;
begin;
  Result := 0;
  sWbemLocator  := CreateOleObject('WbemScripting.SWbemLocator');
  try
    try
      sWMIService   := sWbemLocator.ConnectServer('', 'root\CIMV2', '', '');
      sWbemObjectSet:= sWMIService.ExecQuery('SELECT ' + WMIProperty + ' FROM ' + WMIClass, 'WQL');
      oEnum         := IUnknown(sWbemObjectSet._NewEnum) as IEnumVariant;
      if oEnum.Next(1, sWbemObject, iValue) = 0 then
      begin
        if TryStrToInt64(sWbemObject.Properties_.Item(WMIProperty).Value, I) then Result := I;
      end;
    except
    end
  finally
    sWbemLocator := Unassigned;
  end
end;

end.
