unit UFileVersion;

interface

function GetFileVersion: string;

implementation

uses
  System.SysUtils
  , Winapi.Windows
  , Vcl.Forms;



procedure GetBuildInfo(var V1, V2, V3, V4: Word);
var
  VerInfoSize: DWORD;
  VerInfo: pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  if VerInfoSize > 0 then
  begin
    GetMem(VerInfo, VerInfoSize);
    try
      if GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo) then
      begin
        if VerQueryValue(VerInfo, '\', pointer(VerValue), VerValueSize) then
          with VerValue^ do
          begin
            V1 := dwFileVersionMS shr 16;
            V2 := dwFileVersionMS and $FFFF;
            V3 := dwFileVersionLS shr 16;
            V4 := dwFileVersionLS and $FFFF;
          end;
      end;
    finally
      FreeMem(VerInfo, VerInfoSize);
    end;
  end;
end;

function GetFileVersion: string;
var
  V1, V2, V3, V4: Word;
const
  cBuild = '%d.%d.%d.%d';
begin
  GetBuildInfo(V1, V2, V3, V4);
  Result := Format(cBuild, [V1, V2, V3, V4]);
end;



end.
