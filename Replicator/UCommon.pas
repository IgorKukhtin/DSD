unit UCommon;

interface

uses
  UDefinitions;

  function Elapsed(const AStartTick: Cardinal): string; overload;
  function Elapsed(const AStart: TDateTime): string; overload;
  procedure WaitFor(const AInterval: Cardinal; AWaitCondition: TConditionFunc);

implementation

uses
  System.SysUtils,
  Winapi.Windows,
  Vcl.Forms,
  UConstants;

function Elapsed(const AStartTick: Cardinal): string;
begin
  Result := FormatDateTime(cTimeStr, (GetTickCount - AStartTick) * c1MsecDate);
end;

function Elapsed(const AStart: TDateTime): string; overload;
begin
  Result := FormatDateTime(cTimeStr, (Now - AStart));
end;

procedure WaitFor(const AInterval: Cardinal; AWaitCondition: TConditionFunc);
var
  crdStart: Cardinal;
begin
  crdStart := GetTickCount;

  while ((GetTickCount - crdStart) < AInterval) and AWaitCondition do
    Application.ProcessMessages;
end;


end.
