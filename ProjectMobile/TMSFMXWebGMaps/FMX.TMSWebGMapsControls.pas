{***************************************************************************)
{ TMS FMX WebGMaps component                                                    }
{ for Delphi & C++Builder                                                   }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2012 - 2014                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}

unit FMX.TMSWebGMapsControls;

interface

{$I TMSDEFS.INC}

uses
  Classes, FMX.Graphics, FMX.Controls, FMX.TMSWebGMapsConst, SysUtils, FMX.TMSWebGMapsCommon, StrUtils
  {$IFDEF FMXLIB}
  ,UITypes, UIConsts
  {$ENDIF}
  ;

type
  TRotateControl = class(TPersistent)
  private
    FPosition: TControlPosition;
    FVisible: Boolean;
    FWebGmaps: TControl;
    procedure SetPosition(const Value: TControlPosition);
    procedure SetVisible(const Value: Boolean);
  protected
  public
    constructor Create(AWebGmaps: TControl);
    procedure Assign(Source: TPersistent); override;
  published
    property Position : TControlPosition read FPosition write SetPosition default cpRightBottom;
    property Visible : Boolean read FVisible write SetVisible default true;
  end;

  TPanControl = class(TPersistent)
  private
    FPosition: TControlPosition;
    FVisible: Boolean;
    FWebGmaps: TControl;
    procedure SetPosition(const Value: TControlPosition);
    procedure SetVisible(const Value: Boolean);
  protected
  public
    constructor Create(AWebGmaps: TControl);
    procedure Assign(Source: TPersistent); override;
  published
    property Position : TControlPosition read FPosition write SetPosition default cpTopLeft;
    property Visible : Boolean read FVisible write SetVisible default true;
  end;

  TZoomControl = class(TPersistent)
  private
    FPosition: TControlPosition;
    FVisible: Boolean;
    FWebGmaps: TControl;
    FStyle: TZoomStyle;
    procedure SetPosition(const Value: TControlPosition);
    procedure SetVisible(const Value: Boolean);
    procedure SetStyle(const Value: TZoomStyle);
  protected
  public
    constructor Create(AWebGmaps: TControl);
    procedure Assign(Source: TPersistent); override;
  published
    property Position : TControlPosition read FPosition write SetPosition default cpTopLeft;
    property Style : TZoomStyle read FStyle write SetStyle default zsDefault;
    property Visible : Boolean read FVisible write SetVisible default true;
  end;

  TMapTypeControl = class(TPersistent)
  private
    FWebGmaps: TControl;
    FVisible: Boolean;
    FStyle: TMapTypeStyle;
    FPosition: TControlPosition;
    procedure SetPosition(const Value: TControlPosition);
    procedure SetStyle(const Value: TMapTypeStyle);
    procedure SetVisible(const Value: Boolean);
  protected
  public
    constructor Create(AWebGmaps: TControl);
    procedure Assign(Source: TPersistent); override;
  published
    property Position : TControlPosition read FPosition write SetPosition default cpTopRight;
    property Style : TMapTypeStyle read FStyle write SetStyle default mtsDefault;
    property Visible : Boolean read FVisible write SetVisible default true;
  end;

  TScaleControl = class(TPersistent)
  private
    FWebGmaps: TControl;
    FVisible: Boolean;
    FPosition: TControlPosition;
    procedure SetPosition(const Value: TControlPosition);
    procedure SetVisible(const Value: Boolean);
  protected
  public
    constructor Create(AWebGmaps: TControl);
    procedure Assign(Source: TPersistent); override;
  published
    property Position : TControlPosition read FPosition write SetPosition default cpBottomLeft;
    property Visible : Boolean read FVisible write SetVisible default true;
  end;

  TStreetViewControl = class(TPersistent)
  private
    FWebGmaps: TControl;
    FVisible: Boolean;
    FPosition: TControlPosition;
    procedure SetPosition(const Value: TControlPosition);
    procedure SetVisible(const Value: Boolean);
  protected
  public
    constructor Create(AWebGmaps: TControl);
    procedure Assign(Source: TPersistent); override;
  published
    property Position : TControlPosition read FPosition write SetPosition default cpTopLeft;
    property Visible : Boolean read FVisible write SetVisible default true;
  end;

  TOverviewMapControl = class(TPersistent)
  private
    FWebGmaps: TControl;
    FOpen: Boolean;
    FVisible: Boolean;
    procedure SetOpen(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
  protected
  public
    constructor Create(AWebGmaps: TControl);
    procedure Assign(Source: TPersistent); override;
  published
    property Visible : Boolean read FVisible write SetVisible default true;
    property Open : Boolean read FOpen write SetOpen default false;
  end;

  TControlsOptions = class(TPersistent)
  private
    FWebGmaps: TControl;
    FControlsType: TControlsType;
    FOverviewMapControl: TOverviewMapControl;
    FScaleControl: TScaleControl;
    FZoomControl: TZoomControl;
    FMapTypeControl: TMapTypeControl;
    FPanControl: TPanControl;
    FStreetViewControl: TStreetViewControl;
    FRotateControl: TRotateControl;
    procedure SetControlsType(const Value: TControlsType);
    procedure SetMapTypeControl(const Value: TMapTypeControl);
    procedure SetOverviewMapControl(const Value: TOverviewMapControl);
    procedure SetPanControl(const Value: TPanControl);
    procedure SetScaleControl(const Value: TScaleControl);
    procedure SetStreetViewControl(const Value: TStreetViewControl);
    procedure SetZoomControl(const Value: TZoomControl);
    procedure SetRotateControl(const Value: TRotateControl);
  protected
  public
    constructor Create(AWebGmaps: TControl);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ControlsType : TControlsType read FControlsType write SetControlsType default ctDefault;
    property PanControl : TPanControl read FPanControl write SetPanControl;
    property ZoomControl : TZoomControl read FZoomControl write SetZoomControl;
    property MapTypeControl : TMapTypeControl read FMapTypeControl write SetMapTypeControl;
    property ScaleControl : TScaleControl read FScaleControl write SetScaleControl;
    property StreetViewControl : TStreetViewControl read FStreetViewControl write SetStreetViewControl;
    property OverviewMapControl : TOverviewMapControl read FOverviewMapControl write SetOverviewMapControl;
    property RotateControl : TRotateControl read FRotateControl write SetRotateControl;
  end;


implementation

uses
  FMX.TMSWebGMaps;

{ TPanControl }

procedure TPanControl.Assign(Source: TPersistent);
begin
  if (Source is TPanControl) then
  begin
    FVisible := (Source as TPanControl).Visible;
    FPosition := (Source as TPanControl).Position;
  end;
end;

constructor TPanControl.Create(AWebGmaps: TControl);
begin
  inherited Create;
  FWebGmaps  := AWebGmaps;
  FVisible   := True;
  FPosition  := cpTopLeft;
end;

procedure TPanControl.SetPosition(const Value: TControlPosition);
var
  Script:String;
begin
  FPosition:=Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    Script:='map.setOptions( {' +
            '  panControlOptions: {' +
            '    position: google.maps.ControlPosition.'+CONTROL_POSITION_TEXT+
            '  }'+
            '} );';
    Script:=ReplaceTextControlPosition(Script,CONTROL_POSITION_TEXT,Value);
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript(Script);
  end;
end;

procedure TPanControl.SetVisible(const Value: Boolean);
begin
  FVisible:=Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {panControl:true} );')
    else
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {panControl:false} );');
  end;
end;

{ TZoomControl }

procedure TZoomControl.Assign(Source: TPersistent);
begin
  if (Source is TZoomControl) then
  begin
    FPosition := (Source as TZoomControl).Position;
    FStyle := (Source as TZoomControl).Style;
    FVisible := (Source as TZoomControl).Visible;
  end;
end;

constructor TZoomControl.Create(AWebGmaps: TControl);
begin
  inherited Create;
  FWebGmaps  := AWebGmaps;
  FVisible   := True;
  FPosition  := cpTopLeft;
  FStyle     := zsDefault;
end;

procedure TZoomControl.SetPosition(const Value: TControlPosition);
var
  Script:String;
begin
  FPosition:=Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    Script:='map.setOptions( {' +
            '  zoomControlOptions: {' +
            '    position: google.maps.ControlPosition.'+CONTROL_POSITION_TEXT+
            '  }'+
            '} );';
    Script:=ReplaceTextControlPosition(Script,CONTROL_POSITION_TEXT,Value);
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript(Script);
  end;
end;

procedure TZoomControl.SetStyle(const Value: TZoomStyle);
var
  Script:String;
begin
  FStyle := Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    Script:='map.setOptions( {' +
            '  zoomControlOptions: {' +
            '    style: google.maps.ZoomControlStyle.%style%' +
            '  }'+
            '} );';
    case value of
      zsDefault:
        begin
          Script:=ReplaceText(Script,'%style%',ZOOM_DEFAULT);
        end;
      zsSmall:
        begin
          Script:=ReplaceText(Script,'%style%',ZOOM_SMALL);
        end;
      zsLarge:
        begin
          Script:=ReplaceText(Script,'%style%',ZOOM_LARGE);
        end;
    end;
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript(Script);
    // force position update, otherwise, Google Maps forgets it
    SetPosition(FPosition);
  end;
end;

procedure TZoomControl.SetVisible(const Value: Boolean);
begin
  FVisible:=Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {zoomControl:true} );')
    else
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {zoomControl:false} );');
  end;
end;

{ TMapTypeControl }

procedure TMapTypeControl.Assign(Source: TPersistent);
begin
  if (Source is TMapTypeControl) then
  begin
    FVisible := (Source as TMapTypeControl).Visible;
    FStyle := (Source as TMapTypeControl).Style;
    FPosition := (Source as TMapTypeControl).Position;
  end;
end;

constructor TMapTypeControl.Create(AWebGmaps: TControl);
begin
  inherited Create;
  FWebGmaps  := AWebGmaps;
  FVisible   := True;
  FPosition  := cpTopRight;
  FStyle     := mtsDefault;
end;

procedure TMapTypeControl.SetPosition(const Value: TControlPosition);
var
  Script:String;
begin
  FPosition := Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    Script := 'map.setOptions( {' +
            '  mapTypeControlOptions: {' +
            '    position: google.maps.ControlPosition.'+CONTROL_POSITION_TEXT+
            '  }'+
            '} );';
    Script := ReplaceTextControlPosition(Script,CONTROL_POSITION_TEXT,Value);
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript(Script);
  end;
end;

procedure TMapTypeControl.SetStyle(const Value: TMapTypeStyle);
var
  Script:String;
begin
  FStyle := Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    Script := 'map.setOptions( {' +
            '  mapTypeControlOptions: {' +
            '    style: google.maps.MapTypeControlStyle.%style%' +
            '  }'+
            '} );';
    case value of
      mtsDefault:
        begin
          Script:=ReplaceText(Script,'%style%',MAPTYPE_DEFAULT);
        end;
      mtsDropDownMenu:
        begin
          Script:=ReplaceText(Script,'%style%',MAPTYPE_DROPDOWNMENU);
        end;
      mtsHorizontalBar:
        begin
          Script:=ReplaceText(Script,'%style%',MAPTYPE_HORIZONTALBAR);
        end;
    end;
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript(Script);
    // force position update, otherwise, Google Maps forgets it
    SetPosition(FPosition);
  end;
end;

procedure TMapTypeControl.SetVisible(const Value: Boolean);
begin
  FVisible:=Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {mapTypeControl:true} );')
    else
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {mapTypeControl:false} );');
  end;
end;

{ TScaleControl }

procedure TScaleControl.Assign(Source: TPersistent);
begin
  if (Source is TScaleControl) then
  begin
    FVisible := (Source as TScaleControl).Visible;
    FPosition := (Source as TScaleControl).Position;
  end;
end;

constructor TScaleControl.Create(AWebGmaps: TControl);
begin
  inherited Create;
  FWebGmaps  := AWebGmaps;
  FVisible   := True;
  FPosition  := cpBottomLeft;
end;

procedure TScaleControl.SetPosition(const Value: TControlPosition);
var
  Script:String;
begin
  FPosition := Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    Script:='map.setOptions( {' +
            '  scaleControlOptions: {' +
            '    position: google.maps.ControlPosition.'+CONTROL_POSITION_TEXT+
            '  }'+
            '} );';
    Script:=ReplaceTextControlPosition(Script,CONTROL_POSITION_TEXT,Value);
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript(Script);
  end;
end;

procedure TScaleControl.SetVisible(const Value: Boolean);
begin
  FVisible:=Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {scaleControl:true} );')
    else
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {scaleControl:false} );');
  end;
end;

{ TStreetViewControl }

procedure TStreetViewControl.Assign(Source: TPersistent);
begin
  if (Source is TStreetViewControl) then
  begin
    FVisible := (Source as TStreetViewControl).Visible;
    FPosition := (Source as TStreetViewControl).Position;
  end;
end;

constructor TStreetViewControl.Create(AWebGmaps: TControl);
begin
  inherited Create;
  FWebGmaps  := AWebGmaps;
  FVisible   := True;
  FPosition  := cpTopLeft;
end;

procedure TStreetViewControl.SetPosition(const Value: TControlPosition);
var
  Script:String;
begin
  FPosition := Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    Script:='map.setOptions( {' +
            '  streetViewControlOptions: {' +
            '    position: google.maps.ControlPosition.'+CONTROL_POSITION_TEXT+
            '  }'+
            '} );';
    Script:=ReplaceTextControlPosition(Script,CONTROL_POSITION_TEXT,Value);
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript(Script);
  end;
end;

procedure TStreetViewControl.SetVisible(const Value: Boolean);
begin
  FVisible:=Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {streetViewControl:true} );')
    else
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {streetViewControl:false} );');
  end;
end;

{ TOverviewMapControl }

procedure TOverviewMapControl.Assign(Source: TPersistent);
begin
  if (Source is TOverviewMapControl) then
  begin
    FVisible := (Source as TOverviewMapControl).Visible;
    FOpen := (Source as TOverviewMapControl).Open;
  end;

end;

constructor TOverviewMapControl.Create(AWebGmaps: TControl);
begin
  inherited Create;
  FWebGmaps  := AWebGmaps;
  FVisible   := True;
  FOpen      := False;
end;

procedure TOverviewMapControl.SetOpen(const Value: Boolean);
var
  Script:String;
begin
  FOpen := Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    Script:='map.setOptions( {' +
            '  overviewMapControlOptions: {' +
            '    opened: %opened%' +
            '  }'+
            '} );';
    if Value then
      Script:=ReplaceText(Script,'%opened%','true')
    else
      Script:=ReplaceText(Script,'%opened%','false');
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript(Script);
  end;
end;

procedure TOverviewMapControl.SetVisible(const Value: Boolean);
begin
  FVisible:=Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {overviewMapControl:true} );')
    else
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {overviewMapControl:false} );');
  end;
end;

{ TControlsOptions }

procedure TControlsOptions.Assign(Source: TPersistent);
begin
  if (Source is TControlsOptions) then
  begin
    FControlsType := (Source as TControlsOptions).ControlsType;
    FPanControl.Assign((Source as TControlsOptions).PanControl);
    FZoomControl.Assign((Source as TControlsOptions).ZoomControl);
    FMapTypeControl.Assign((Source as TControlsOptions).MapTypeControl);
    FScaleControl.Assign((Source as TControlsOptions).ScaleControl);
    FStreetViewControl.Assign((Source as TControlsOptions).StreetViewControl);
    FOverviewMapControl.Assign((Source as TControlsOptions).OverviewMapControl);
    FRotateControl.Assign((Source as TControlsOptions).RotateControl);
  end;
end;

constructor TControlsOptions.Create(AWebGmaps: TControl);
begin
  inherited Create;
  FWebGmaps             := AWebGmaps;
  FControlsType         := ctDefault;
  FPanControl           := TPanControl.Create(AWebGmaps);
  FZoomControl          := TZoomControl.Create(AWebGmaps);
  FMapTypeControl       := TMapTypeControl.Create(AWebGmaps);
  FScaleControl         := TScaleControl.Create(AWebGmaps);
  FStreetViewControl    := TStreetViewControl.Create(AWebGmaps);
  FOverviewMapControl   := TOverviewMapControl.Create(AWebGmaps);
  FRotateControl        := TRotateControl.Create(AWebGmaps);
end;

destructor TControlsOptions.Destroy;
begin
  FreeAndNil(FOverviewMapControl);
  FreeAndNil(FStreetViewControl);
  FreeAndNil(FScaleControl);
  FreeAndNil(FMapTypeControl);
  FreeAndNil(FZoomControl);
  FreeAndNil(FPanControl);
  FreeAndNil(FRotateControl);
  inherited Destroy;
end;

procedure TControlsOptions.SetControlsType(const Value: TControlsType);
var
  Script:String;
begin
  FControlsType := Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    Script:='map.setOptions( {' +
            '  navigationControlOptions: {' +
            '    style: google.maps.NavigationControlStyle.%controlstype%' +
            '  }'+
            '} );';
    case Value of
      ctDefault:
        begin
          Script := ReplaceText(Script,'%controlstype%',CONTROL_DEFAULT);
        end;
      ctAndroid:
        begin
          Script := ReplaceText(Script,'%controlstype%',CONTROL_ANDROID);
        end;
      ctSmall:
        begin
          Script := ReplaceText(Script,'%controlstype%',CONTROL_SMALL);
        end;
      ctZoomPan:
        begin
          Script := ReplaceText(Script,'%controlstype%',CONTROL_ZOOMPAN);
        end;
    end;
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript(Script);
  end;
end;

procedure TControlsOptions.SetMapTypeControl(const Value: TMapTypeControl);
begin
  FMapTypeControl := Value;
end;

procedure TControlsOptions.SetOverviewMapControl(
  const Value: TOverviewMapControl);
begin
  FOverviewMapControl := Value;
end;

procedure TControlsOptions.SetPanControl(const Value: TPanControl);
begin
  FPanControl := Value;
end;

procedure TControlsOptions.SetRotateControl(const Value: TRotateControl);
begin
  FRotateControl := Value;
end;

procedure TControlsOptions.SetScaleControl(const Value: TScaleControl);
begin
  FScaleControl := Value;
end;

procedure TControlsOptions.SetStreetViewControl(
  const Value: TStreetViewControl);
begin
  FStreetViewControl := Value;
end;

procedure TControlsOptions.SetZoomControl(const Value: TZoomControl);
begin
  FZoomControl := Value;
end;

{ TRotateControl }

procedure TRotateControl.Assign(Source: TPersistent);
begin
  if (Source is TRotateControl) then
  begin
    FVisible := (Source as TRotateControl).Visible;
    FPosition := (Source as TRotateControl).Position;
  end;
end;

constructor TRotateControl.Create(AWebGmaps: TControl);
begin
  inherited Create;
  FWebGmaps  := AWebGmaps;
  FVisible   := True;
  FPosition  := cpRightBottom;
end;

procedure TRotateControl.SetPosition(const Value: TControlPosition);
var
  Script:String;
begin
  FPosition:=Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    Script:='map.setOptions( {' +
            '  rotateControlOptions: {' +
            '    position: google.maps.ControlPosition.'+CONTROL_POSITION_TEXT+
            '  }'+
            '} );';
    Script:=ReplaceTextControlPosition(Script,CONTROL_POSITION_TEXT,Value);
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript(Script);
  end;
end;

procedure TRotateControl.SetVisible(const Value: Boolean);
begin
  FVisible:=Value;
  {$IFNDEF FMXLIB}
  if ((FWebGmaps as TTMSFMXWebGMaps).HTMLWindow2<>nil) and ((FWebGmaps as TTMSFMXWebGMaps).WebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {rotateControl:true} );')
    else
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('map.setOptions( {rotateControl:false} );');
  end;
end;

end.
