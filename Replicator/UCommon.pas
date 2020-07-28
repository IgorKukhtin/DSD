unit UCommon;

interface

  function Elapsed(const AStartTick: Cardinal): string; overload;
  function Elapsed(const AStart: TDateTime): string; overload;

implementation

uses
  System.SysUtils,
  Winapi.Windows,
  UConstants;

function Elapsed(const AStartTick: Cardinal): string;
begin
  Result := FormatDateTime(cTimeStr, (GetTickCount - AStartTick) * c1MsecDate);
end;

function Elapsed(const AStart: TDateTime): string; overload;
begin
  Result := FormatDateTime(cTimeStr, (Now - AStart));
end;

end.
