unit FMX.CursorUtils;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,  FMX.Types, FMX.Controls, 
  FMX.Forms, FMX.Dialogs, FMX.Platform, FMX.StdCtrls;

Procedure Screen_Cursor_crHourGlass;
Procedure Screen_Cursor_crDefault;
function  Screen_MonitorCount:Integer;

function Application_ExeName:String;
function Screen_Width:Single;
function Screen_Height:Single;

{$IF (Defined(VER240)) or (Defined(VER250)) or (Defined(VER260)) or (Defined(VER270)) or (Defined(VER280)) or (Defined(VER290)) or (Defined(VER300))  }

//{$IFDEF VER240}
var
  Glbl_Cursor:TCursor;
  CursorService: IFMXCursorService;
{$ENDIF}

implementation

// uses FMX.Platform, System.UITypes;
Procedure Screen_Cursor_crHourGlass;
{$IF DEFINED(iOS) or DEFINED(ANDROID)}
  var aiWait: TAniIndicator;
{$ENDIF}
begin
{$IF DEFINED(iOS) or DEFINED(ANDROID)}
  aiWait := TAniIndicator(Application.MainForm.FindComponent('aiWait'));
  if Assigned(aiWait) then
  begin
    aiWait.Visible := true;
    aiWait.Enabled := true;
  end;
{$ELSE}
  {$IFDEF VER230}
    Platform.SetCursor(nil, crHourGlass);
  {$ENDIF}

  {$IF (Defined(VER240)) or (Defined(VER250)) or (Defined(VER260)) or (Defined(VER270)) or (Defined(VER280)) or (Defined(VER290)) or (Defined(VER300))  }
    Glbl_Cursor := crHourGlass;

    if TPlatformServices.Current.SupportsPlatformService(IFMXCursorService, IInterface(CursorService)) then
      CursorService.SetCursor(Glbl_Cursor);
  {$ENDIF}
{$ENDIF}
end;

Procedure Screen_Cursor_crDefault;
{$IF DEFINED(iOS) or DEFINED(ANDROID)}
  var aiWait: TAniIndicator;
{$ENDIF}
begin
{$IF DEFINED(iOS) or DEFINED(ANDROID)}
  aiWait := TAniIndicator(Application.MainForm.FindComponent('aiWait'));
  if Assigned(aiWait) then
  begin
    aiWait.Visible := false;
    aiWait.Enabled := false;
  end;
{$ELSE}
  {$IFDEF VER230}
    Platform.SetCursor(nil, crDefault);
  {$ENDIF}

  {$IF (Defined(VER240)) or (Defined(VER250)) or (Defined(VER260)) or (Defined(VER270)) or (Defined(VER280)) or (Defined(VER290)) or (Defined(VER300))  }
    Glbl_Cursor := crDefault;

    if TPlatformServices.Current.SupportsPlatformService(IFMXCursorService, IInterface(CursorService)) then
      CursorService.SetCursor(Glbl_Cursor);
  {$ENDIF}
{$ENDIF}
end;

function  Screen_MonitorCount:Integer;
begin
Result := 1;  // TO DO
end;

function Application_ExeName:String;
begin
Result := ParamStr(0);
end;

function Screen_Width:Single;
{$IF (Defined(VER240)) or (Defined(VER250)) or (Defined(VER260)) or (Defined(VER270)) or (Defined(VER280)) or (Defined(VER290)) or (Defined(VER300))  }
var
ScreenService: IFMXScreenService;
{$ENDIF}
begin
  Result := 0;

  {$IFDEF VER230}
  Result := Platform.GetScreenSize.X;
  {$ENDIF}

  {$IF (Defined(VER240)) or (Defined(VER250)) or (Defined(VER260)) or (Defined(VER270)) or (Defined(VER280)) or (Defined(VER290)) or (Defined(VER300))  }
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
    Result := ScreenService.GetScreenSize.Truncate.X
  else
    Result := 0;
  {$ENDIF}
end;

function Screen_Height:Single;
{$IF (Defined(VER240)) or (Defined(VER250)) or (Defined(VER260)) or (Defined(VER270)) or (Defined(VER280)) or (Defined(VER290)) or (Defined(VER300))  }
var
ScreenService: IFMXScreenService;
{$ENDIF}
begin
  Result := 0;

  {$IFDEF VER230}
  Result := Platform.GetScreenSize.Y;
  {$ENDIF}

  {$IF (Defined(VER240)) or (Defined(VER250)) or (Defined(VER260)) or (Defined(VER270)) or (Defined(VER280)) or (Defined(VER290)) or (Defined(VER300))  }
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
    Result := ScreenService.GetScreenSize.Truncate.Y
  else
    Result := 0;
  {$ENDIF}
end;

end.

