unit GetSystemInfo;

interface

uses System.SysUtils, System.Types, System.Variants, System.UITypes, System.Classes,
     Winapi.Windows, System.Win.ComObj, Winapi.ActiveX;

function GetComputerName : string;
function GetBaseBoardProduct : string;
function GetProcessorName : string;
function GetDiskDriveModel : string;
function GetPhysicalMemory : string;

implementation

function GetMemoryType(AType : Integer) : string;
begin
  case AType of
    $01 : Result := '';
    $02 : Result := '';
    $03 : Result := 'DRAM';
    $04 : Result := 'EDRAM';
    $05 : Result := 'VRAM';
    $06 : Result := 'SRAM';
    $07 : Result := 'RAM';
    $08 : Result := 'ROM';
    $09 : Result := 'FLASH';
    $0A : Result := 'EEPROM';
    $0B : Result := 'FEPROM';
    $0C : Result := 'EPROM';
    $0D : Result := 'CDRAM';
    $0E : Result := '3DRAM';
    $0F : Result := 'SDRAM';
    $10 : Result := 'SGRAM';
    $11 : Result := 'RDRAM';
    $12 : Result := 'DDR';
    $13 : Result := 'DDR2';
    $14 : Result := 'DDR2 FB-DIMM';
    $18 : Result := 'DDR3';
    $19 : Result := 'FBD2';
    $1A : Result := 'DDR4';
    $1B : Result := 'LPDDR';
    $1C : Result := 'LPDDR2';
    $1D : Result := 'LPDDR3';
    $1E : Result := 'LPDDR4';
    ELSE Result := '';
  end;
end;

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
          varEmpty    : Result := '';
          varNull     : Result := '';
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

function GetComputerName : string;
begin
  Result := GetWMIInfo('Win32_ComputerSystem', 'Name');
end;

function GetBaseBoardProduct : string;
begin
  Result := GetWMIInfo('Win32_BaseBoard', 'Product');
end;

function GetProcessorName : string;
begin
  Result := GetWMIInfo('Win32_Processor', 'Name');
end;

function GetDiskDriveModel : string;
begin
  Result := GetWMIInfo('Win32_DiskDrive', 'Model') + ' ' + IntToStr(GetWMIInt64('Win32_DiskDrive', 'Size') div 1000 div 1000 div 1000) + ' รม';
end;

function GetPhysicalMemory : string;
  var S : String;
begin
  Result := GetMemoryType(GetWMIInt64('Win32_PhysicalMemory', 'MemoryType'));
  if Result <> '' then Result := Result + ' ';
  Result := Result + CurrToStr(GetWMISum('Win32_PhysicalMemory', 'Capacity') / 1024 / 1024 / 1024) + ' รม';
  S := GetWMIInfo('Win32_PhysicalMemory', 'Speed');
  if S <> '' THEN  Result := Result + ' ' + S + ' ฬร๖';
end;

end.
