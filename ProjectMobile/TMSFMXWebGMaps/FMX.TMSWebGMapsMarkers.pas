{***************************************************************************)
{ TMS FMX WebGMaps component                                                    }
{ for Delphi & C++Builder                                                   }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2013 - 2016                                        }
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

unit FMX.TMSWebGMapsMarkers;

interface

{$I TMSDEFS.INC}

uses
  SysUtils, Classes, FMX.Controls, Types, FMX.Graphics, StrUtils,
  FMX.TMSWebGMapsCommon, FMX.TMSWebGMapsConst, FMX.TMSWebGMapsCommonFunctions,
  FMX.TMSWebGMapsClusters
  {$IFDEF FMXLIB}
  , UITypes, UIConsts
  {$ENDIF}
  ;

type

  TMapLabel = class(TPersistent)
  private
    FBorderColor: TAlphaColor;
    FColor: TAlphaColor;
    FFont: TFont;
    {$IFDEF FMXLIB}
    FFontColor: TAlphaColor;
    {$ENDIF}
    FMargin: integer;
    FText: string;
    FOwner: TCollectionItem;
    FOffsetTop: integer;
    FOffsetLeft: integer;
    procedure SetBorderColor(const Value: TAlphaColor);
    procedure SetColor(const Value: TAlphaColor);
    {$IFDEF FMXLIB}
    procedure SetFontColor(const Value: TAlphaColor);
    {$ENDIF}
    procedure SetFont(const Value: TFont);
    procedure SetText(const Value: string);
    procedure SetOwner(const Value: TCollectionItem);
    procedure SetMargin(const Value: integer);
    procedure SetOffsetLeft(const Value: integer);
    procedure SetOffsetTop(const Value: integer);
  protected
    property Owner : TCollectionItem read FOwner write SetOwner;
    procedure FontChanged(Sender: TObject);
  public
    constructor Create(CollectionItem : TCollectionItem);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property OffsetLeft: integer read FOffsetLeft write SetOffsetLeft;
    property OffsetTop: integer read FOffsetTop write SetOffsetTop;
  published
    property Text: string read FText write SetText;
    property Color: TAlphaColor read FColor write SetColor default claWhite;
    property BorderColor: TAlphaColor read FBorderColor write SetBorderColor default claBlack;
    property Margin: integer read FMargin write SetMargin default 2;
    property Font: TFont read FFont write SetFont;
    {$IFDEF FMXLIB}
    property FontColor: TAlphaColor read FFontColor write SetFontColor default claBlack;
    {$ENDIF}
  end;

  TMarker = class(TCollectionItem)
  private
    FWebGMaps: TControl;
    FLatitude: double;
    FDraggable: boolean;
    FTitle: String;
    FLongitude: double;
    FIcon: String;
    FVisible: boolean;
    FClickable: boolean;
    FFlat: boolean;
    FInitialDropAnimation: boolean;
    FZindex: integer;
    FMapLabel: TMapLabel;
    FTag: integer;
    FData: String;
    FClusterIndex: integer;
    FCluster: TMapCluster;
    FClusterItem: TClusterItem;
    FIconColor: TMarkerIconColor;
    FIconHeight: Integer;
    FIconWidth: integer;
    FIconZoomHeight: Integer;
    FIconZoomWidth: integer;
    FMarkerIconState: TMarkerIconState;
    FText: String;
    procedure SetDraggable(const Value: boolean);
    procedure SetIcon(const Value: String);
    procedure SetLatitude(const Value: double);
    procedure SetLongitude(const Value: double);
    procedure SetTitle(const Value: String);
    procedure SetVisible(const Value: boolean);
    procedure SetClickable(const Value: boolean);
    procedure SetFlat(const Value: boolean);
    procedure SetInitialDropAnimation(const Value: boolean);
    procedure SetZindex(const Value: integer);
    procedure SetMapLabel(const Value: TMapLabel);
    procedure SetTag(const Value: integer);
    procedure SetClusterIndex(const Value: integer);
    procedure SetCluster(const Value: TMapCluster);
    procedure SetClusterItem(const Value: TClusterItem);
    procedure SetIconColor(const Value: TMarkerIconColor);
    procedure SetIconHeight(const Value: Integer);
    procedure SetIconWidth(const Value: integer);
    procedure SetIconZoomHeight(const Value: Integer);
    procedure SetIconZoomWidth(const Value: integer);
    procedure SetMarkerIconState(const Value: TMarkerIconState);
    procedure SetText(const Value: String);
  protected
  public
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published
    property Clickable: boolean read FClickable write SetClickable;
    property Cluster: TMapCluster read FCluster write SetCluster;
    property ClusterItem: TClusterItem read FClusterItem write SetClusterItem;
    property ClusterIndex: integer read FClusterIndex write SetClusterIndex default -1;
    property Data: string read FData write FData;
    property Draggable: boolean read FDraggable write SetDraggable;
    property Latitude: double read FLatitude write SetLatitude;
    property Longitude: double read FLongitude write SetLongitude;
    property Icon: String read FIcon write SetIcon;
    property IconColor: TMarkerIconColor read FIconColor write SetIconColor default icDefault;
    property IconWidth: integer read FIconWidth write SetIconWidth default -1;
    property IconHeight: Integer read FIconHeight write SetIconHeight default -1;
    property IconZoomWidth: integer read FIconZoomWidth write SetIconZoomWidth default -1;
    property IconZoomHeight: Integer read FIconZoomHeight write SetIconZoomHeight default -1;
    property IconState: TMarkerIconState read FMarkerIconState write SetMarkerIconState default msDefault;
    property Flat: boolean read FFlat write SetFlat;
    property InitialDropAnimation: boolean read FInitialDropAnimation write SetInitialDropAnimation;
    property MapLabel: TMapLabel read FMapLabel write SetMapLabel;
    property Tag: integer read FTag write SetTag default 0;
    property Text: String read FText write SetText;
    property Title: String read FTitle write SetTitle;
    property Visible: boolean read FVisible write SetVisible;
    property Zindex: integer read FZindex write SetZindex;
  end;

  TMarkers = class(TCollection)
  private
    FBounds: TBounds;
    FWebGMaps : TControl;
    function GetItem(Index : integer) : TMarker;
    procedure SetItem(Index : integer; Value : TMarker);
  protected
    function GetOwner : TPersistent; override;
    procedure Update(Item : TCollectionItem); override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(AWebGMaps : TControl);
    destructor Destroy; override;
    function Add(Latitude, Longitude: Double; Title, Icon :string; Draggable, Visible, Clickable, Flat, InitialDropAnimation: Boolean; zIndex: Integer; IconColor: TMarkerIconColor; IconWidth: Integer = -1; IconHeight: Integer = -1; IconZoomWidth: Integer = -1; IconZoomHeight: Integer = -1; Text: string = ''): TMarker; overload;
    function Add(Latitude, Longitude: Double; Title, Icon :string; Draggable, Visible, Clickable, Flat, InitialDropAnimation: Boolean; zIndex: Integer; IconWidth: Integer; IconHeight: Integer; IconZoomWidth: Integer = -1; IconZoomHeight: Integer = -1): TMarker; overload;
    function Add(Latitude, Longitude: Double; Title, Icon :string; Draggable, Visible, Clickable, Flat, InitialDropAnimation: Boolean; zIndex: Integer): TMarker; overload;
    function Add(Latitude, Longitude: Double; Title: string = ''; Text: string = ''): TMarker; overload;
    function Add(Latitude, Longitude: Double; Title: string; IconColor: TMarkerIconColor): TMarker; overload;
    function Add: TMarker; overload;
    property Items[index : integer] : TMarker read GetItem write SetItem; default;
    function Bounds: TBounds;
  end;


implementation

uses
  FMX.TMSWebGMaps;

{ TMarker }

procedure TMarker.Assign(Source: TPersistent);
var
  MarkerSource: TMarker;
begin
  if (Source is TMarker) then
  begin
    MarkerSource := TMarker(Source);
    FCluster := MarkerSource.Cluster;
    FClusterItem := MarkerSource.ClusterItem;
    FClusterIndex := MarkerSource.ClusterIndex;
    FLatitude := MarkerSource.FLatitude;
    FLongitude := MarkerSource.FLongitude;
    FDraggable := MarkerSource.FDraggable;
    FClickable := MarkerSource.FClickable;
    FFlat := MarkerSource.FFlat;
    FInitialDropAnimation := MarkerSource.FInitialDropAnimation;
    FTitle := MarkerSource.FTitle;
    FIcon := MarkerSource.FIcon;
    FIconColor := MarkerSource.FIconColor;
    FIconHeight := MarkerSource.FIconHeight;
    FIconWidth := MarkerSource.FIconWidth;
    FIconZoomHeight := MarkerSource.FIconZoomHeight;
    FIconZoomWidth := MarkerSource.FIconZoomWidth;
    FMarkerIconState := MarkerSource.FMarkerIconState;
    FVisible := MarkerSource.FVisible;
    FZindex := MarkerSource.FZindex;
    FTag := MarkerSource.FTag;
    FText := MarkerSource.FText;
    FMapLabel.Assign(MarkerSource.FMapLabel);
    FData := MarkerSource.Data;
    Changed(True);
  end;
end;

constructor TMarker.Create(Collection: TCollection);
begin
  inherited;
  FWebGMaps := TMarkers(Collection).FWebGMaps;
  FCluster := nil;
  FClusterItem := nil;
  FClusterIndex := -1;
  FLatitude := 0;
  FLongitude := 0;
  FDraggable := True;
  FClickable := True;
  FFlat := False;
  FInitialDropAnimation := False;
  FTitle := 'Marker'+inttostr(Index);
  FIcon := '';
  FIconColor := icDefault;
  FIconHeight := -1;
  FIconWidth := -1;
  FIconZoomHeight := -1;
  FIconZoomWidth := -1;
  FMarkerIconState := msDefault;
  FVisible := True;
  FZindex := Index;
  FTag := 0;
  FText := '';
  FMapLabel := TMapLabel.Create(Self);
end;

destructor TMarker.Destroy;
begin
  FMapLabel.Free;
  inherited;
end;

procedure TMarker.SetClickable(const Value: boolean);
begin
  FClickable := Value;
  if Value then
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<allmarkers.length) allmarkers['+inttostr(Index)+'].setClickable(true);')
  else
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<allmarkers.length) allmarkers['+inttostr(Index)+'].setClickable(false);');
end;

procedure TMarker.SetCluster(const Value: TMapCluster);
begin
  FCluster := Value;
end;

procedure TMarker.SetClusterIndex(const Value: integer);
begin
  FClusterIndex := Value;
end;

procedure TMarker.SetClusterItem(const Value: TClusterItem);
begin
  FClusterItem := Value;
end;

procedure TMarker.SetDraggable(const Value: boolean);
begin
  FDraggable := Value;
  if Value then
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<allmarkers.length) allmarkers['+inttostr(Index)+'].setDraggable(true);')
  else
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<allmarkers.length) allmarkers['+inttostr(Index)+'].setDraggable(false);');
end;

procedure TMarker.SetFlat(const Value: boolean);
begin
  FFlat := Value;
  if Value then
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<allmarkers.length) allmarkers['+inttostr(Index)+'].setFlat(true);')
  else
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<allmarkers.length) allmarkers['+inttostr(Index)+'].setFlat(false);');
end;

procedure TMarker.SetIcon(const Value: String);
begin
  if FIcon <> Value then
  begin
    FIcon := Value;
    (FWebGmaps as TTMSFMXWebGMaps).UpdateMapMarker(Self);
  end;
end;

procedure TMarker.SetIconColor(const Value: TMarkerIconColor);
var
  TextIcon: string;
begin
  if FIconColor <> Value then
  begin
    FIconColor := Value;

    case FIconColor of
      icDefault: TextIcon := FIcon;
      icBlue: TextIcon := 'http://mt.google.com/vt/icon?color=ff004C13&name=icons/spotlight/spotlight-waypoint-blue.png';
      icRed: TextIcon := 'http://mt.googleapis.com/vt/icon/name=icons/spotlight/spotlight-poi.png&scale=1';
      icPurple: TextIcon := 'http://mt.google.com/vt/icon/name=icons/spotlight/spotlight-ad.png';
      icGreen: TextIcon := 'http://mt.google.com/vt/icon?psize=30&font=fonts/arialuni_t.ttf&color=ff304C13&name=icons/spotlight/spotlight-waypoint-a.png&ax=43&ay=48&text=%E2%80%A2';
    end;

    (FWebGmaps as TTMSFMXWebGMaps).UpdateMapMarker(Self);
  end;
end;

procedure TMarker.SetIconHeight(const Value: Integer);
begin
  if FIconHeight <> Value then
  begin
    FIconHeight := Value;
    (FWebGmaps as TTMSFMXWebGMaps).UpdateMapMarker(Self);
  end;
end;

procedure TMarker.SetIconWidth(const Value: integer);
begin
  if FIconWidth <> Value then
  begin
    FIconWidth := Value;
    (FWebGmaps as TTMSFMXWebGMaps).UpdateMapMarker(Self);
  end;
end;

procedure TMarker.SetIconZoomHeight(const Value: Integer);
begin
  if FIconZoomHeight <> Value then
  begin
    FIconZoomHeight := Value;
    (FWebGmaps as TTMSFMXWebGMaps).UpdateMapMarker(Self);
  end;
end;

procedure TMarker.SetIconZoomWidth(const Value: integer);
begin
  if FIconZoomWidth <> Value then
  begin
    FIconZoomWidth := Value;
    (FWebGmaps as TTMSFMXWebGMaps).UpdateMapMarker(Self);
  end;
end;

procedure TMarker.SetInitialDropAnimation(const Value: boolean);
begin
  FInitialDropAnimation := Value;
end;

procedure TMarker.SetLatitude(const Value: double);
var
  TextLat, TextLong:String;
begin
  FLatitude := Value;
  TextLat := ConvertCoordinateToString(FLatitude);
  TextLong := ConvertCoordinateToString(FLongitude);
  (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<allmarkers.length) allmarkers['+inttostr(Index)+'].setPosition(new google.maps.LatLng('+TextLat+','+TextLong+'));');
end;

procedure TMarker.SetLongitude(const Value: double);
var
  TextLat, TextLong:String;
begin
  FLongitude := Value;
  TextLat := ConvertCoordinateToString(FLatitude);
  TextLong := ConvertCoordinateToString(FLongitude);
  (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<allmarkers.length) allmarkers['+inttostr(Index)+'].setPosition(new google.maps.LatLng('+TextLat+','+TextLong+'));');
end;

procedure TMarker.SetMapLabel(const Value: TMapLabel);
begin
  FMapLabel := Value;
end;

procedure TMarker.SetMarkerIconState(const Value: TMarkerIconState);
begin
  if FMarkerIconState <> Value then
  begin
    FMarkerIconState := Value;
    (FWebGmaps as TTMSFMXWebGMaps).UpdateMapMarker(Self);
  end;
end;

procedure TMarker.SetTag(const Value: integer);
begin
  FTag := Value;
end;

procedure TMarker.SetText(const Value: String);
begin
  FText := Value;
  (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<allmarkers.length) allmarkers['+inttostr(Index)+'].setLabel("' + StringReplace(value, '"', '\"', [rfReplaceAll]) + '");');
end;

procedure TMarker.SetTitle(const Value: String);
begin
  FTitle := Value;
  (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<allmarkers.length) allmarkers['+inttostr(Index)+'].setTitle("' + StringReplace(value, '"', '\"', [rfReplaceAll]) + '");');
end;

procedure TMarker.SetVisible(const Value: boolean);
begin
  FVisible := Value;
  if Value then
  begin
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<allmarkers.length) allmarkers['+inttostr(Index)+'].setVisible(true);');
    if MapLabel.Text <> '' then
      (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<alllabels.length) alllabels['+inttostr(Index)+'].show();');
  end
  else
  begin
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<allmarkers.length) allmarkers['+inttostr(Index)+'].setVisible(false);');
    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<alllabels.length) alllabels['+inttostr(Index)+'].hide();');
  end;
end;

procedure TMarker.SetZindex(const Value: integer);
begin
  FZindex := Value;
  (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(Index)+'<allmarkers.length) allmarkers['+inttostr(Index)+'].setZIndex('+inttostr(Value)+');');
end;

{ TMarkers }

function TMarkers.Add(Latitude, Longitude: Double; Title, Icon: string;
  Draggable, Visible, Clickable, Flat, InitialDropAnimation: Boolean;
  zIndex: Integer; IconColor: TMarkerIconColor; IconWidth: integer = -1;
  IconHeight: integer = -1; IconZoomWidth: Integer = -1;
  IconZoomHeight: Integer = -1; Text: string = ''): TMarker;
begin
  Result := TMarker(inherited Add);
  Result.FLatitude := Latitude;
  Result.FLongitude := Longitude;
  Result.FTitle := Title;
  Result.FIcon := Icon;
  Result.FDraggable := Draggable;
  Result.FClickable := Clickable;
  Result.FFlat := Flat;
  Result.FInitialDropAnimation := InitialDropAnimation;
  Result.FVisible := Visible;
  Result.FZindex := zIndex;
  Result.FIconColor := IconColor;
  Result.IconHeight := IconHeight;
  Result.IconWidth := IconWidth;
  Result.IconZoomHeight := IconZoomHeight;
  Result.IconZoomWidth := IconZoomWidth;
  Result.Text := Text;
  Result.Changed(False);
end;

function TMarkers.Add(Latitude, Longitude: Double; Title, Icon: string;
  Draggable, Visible, Clickable, Flat, InitialDropAnimation: Boolean; zIndex,
  IconWidth, IconHeight: Integer; IconZoomWidth: Integer = -1; IconZoomHeight: Integer = -1): TMarker;
begin
  Result := Add(Latitude, Longitude, Title, Icon, Draggable, Visible, Clickable, Flat, InitialDropAnimation, 0, icDefault, IconWidth, IconHeight, IconZoomWidth, IconZoomHeight);
end;

function TMarkers.Add(Latitude, Longitude: Double; Title, Icon: string;
  Draggable, Visible, Clickable, Flat, InitialDropAnimation: Boolean; Zindex: Integer): TMarker;
begin
  Result := Add(Latitude, Longitude, Title, Icon, Draggable, Visible, Clickable, Flat, InitialDropAnimation, 0, icDefault, -1, -1);
end;

function TMarkers.Add(Latitude, Longitude: Double; Title: string = ''; Text: string = ''): TMarker;
begin
  Result := Add(Latitude, Longitude, Title, '', false, true, true, false, false, 0, icDefault, -1, -1, -1, -1, Text);
end;

function TMarkers.Add(Latitude, Longitude: Double; Title: string;
  IconColor: TMarkerIconColor): TMarker;
begin
  Result := Add(Latitude, Longitude, Title, '', false, true, true, false, false, 0, IconColor, -1, -1);
end;

function TMarkers.Add: TMarker;
begin
  Result := TMarker(inherited Add);
end;

function TMarkers.Bounds: TBounds;
var
  maxlat,minlat: double;
  maxlon,minlon: double;
  i: integer;
begin
  maxlon := -180;
  maxlat := -90;
  minlon := +180;
  minlat := +90;

  for i := 0 to Count - 1 do
  begin
    if Items[i].Longitude < minlon then
      minlon := Items[i].Longitude;

    if Items[i].Latitude < minlat then
      minlat := Items[i].Latitude;

    if Items[i].Longitude > maxlon then
      maxlon := Items[i].Longitude;

    if Items[i].Latitude > maxlat then
      maxlat := Items[i].Latitude;
  end;

  if (maxlon = -180) then
    maxlon := 180;

  if (maxlat = -90) then
    maxlat := 90;

  if (minlon = 180) then
    minlon := -180;

  if (minlat = 90) then
    minlat := -90;

  Result := FBounds;
  Result.NorthEast.Latitude := maxlat;
  Result.NorthEast.Longitude := maxlon;

  Result.SouthWest.Latitude := minlat;
  Result.SouthWest.Longitude := minlon;
end;

constructor TMarkers.Create(AWebGMaps : TControl);
begin
  inherited Create(TMarker);
  FWebGMaps := AWebGMaps;
  FBounds := TBounds.Create;
end;

destructor TMarkers.Destroy;
begin
  FBounds.Free;
  inherited;
end;

function TMarkers.GetItem(Index: integer): TMarker;
begin
  Result := TMarker(inherited GetItem(Index));
end;

procedure TMarkers.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
var
  Marker:TMarker;
begin
  inherited;
//  if (Action=cnDeleting) or (Action=cnExtracting) then
//Fix DeleteMapMarker was triggered twice when using WebGMaps1.Markers.Delete(Index);
  if (Action=cnExtracting) then
  begin
    if item<>nil then
    begin
      Marker:=(Item as TMarker);
      (Marker.FWebGmaps as TTMSFMXWebGMaps).DeleteMapMarker(Marker.index);
    end;
  end;
end;

function TMarkers.GetOwner: TPersistent;
begin
  Result := FWebGMaps;
end;

procedure TMarkers.SetItem(Index: integer; Value: TMarker);
begin
  inherited SetItem(Index, Value);
end;

procedure TMarkers.Update(Item: TCollectionItem);
var
  Marker:TMarker;
begin
  inherited;
  if Item <> nil then
  begin
    Marker:=(Item as TMarker);
    (FWebGmaps as TTMSFMXWebGMaps).CreateMapMarker(Marker);
  end;
end;

{ TMapLabel }

procedure TMapLabel.Assign(Source: TPersistent);
var
  FSource : TMapLabel;
begin
  if (Source is TMapLabel) then
  begin
    FSource := TMapLabel(Source);
    FText := FSource.FText;
    FColor := FSource.Color;
    FBorderColor := FSource.BorderColor;
    FMargin := FSource.FMargin;
    FFont.Assign(FSource.FFont);
//    Changed(True);
  end;
end;

constructor TMapLabel.Create(CollectionItem: TCollectionItem);
begin
  FOwner := TMarker(CollectionItem);
  FText := '';
  FColor := claWhite;
  FBorderColor := claBlack;
  FMargin := 2;
  FFont := TFont.Create;
  FFont.Family := 'Arial';
  FFont.Size := 12;
  FFontColor := claBlack;
  {$IFNDEF FMXLIB}
  FFont.OnChange := FontChanged;
  {$ENDIF}
  {$IFDEF FMXLIB}
  FFont.OnChanged := FontChanged;
  {$ENDIF}
end;

destructor TMapLabel.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TMapLabel.FontChanged(Sender: TObject);
var
  js: string;
begin
  {$IFNDEF FMXLIB}
  js := 'if ('+inttostr(FOwner.Index)+'<alllabels.length) { ' + js + ' alllabels['+inttostr(FOwner.Index)+'].setColor("' + ColorToHTML(FontColor) + '"); }';
 (TMarker(FOwner).FWebGmaps as TTMSFMXWebGMaps).ExecJScript(js);

  js := 'if ('+inttostr(FOwner.Index)+'<alllabels.length) { ' + js + ' alllabels['+inttostr(FOwner.Index)+'].setFontSize("' + IntToStr(Font.Size) + '"); }';
 (TMarker(FOwner).FWebGmaps as TTMSFMXWebGMaps).ExecJScript(js);
 {$ENDIF}

 {$IFDEF FMXLIB}
  js := 'if ('+inttostr(FOwner.Index)+'<alllabels.length) { ' + js + ' alllabels['+inttostr(FOwner.Index)+'].setFontSize("' + FloatToStr(Round(Font.Size)) + '"); }';
 (TMarker(FOwner).FWebGmaps as TTMSFMXWebGMaps).ExecJScript(js);
 {$ENDIF}

  js := 'if ('+inttostr(FOwner.Index)+'<alllabels.length) { ' + js + ' alllabels['+inttostr(FOwner.Index)+'].setFont("' + Font.Family + '"); }';
 (TMarker(FOwner).FWebGmaps as TTMSFMXWebGMaps).ExecJScript(js);
end;

procedure TMapLabel.SetBorderColor(const Value: TAlphaColor);
var
  js: string;
begin
  FBorderColor := Value;

  js := 'if ('+inttostr(FOwner.Index)+'<alllabels.length) { ' + js + ' alllabels['+inttostr(FOwner.Index)+'].setBorderColor("' + ColorToHTML(value) + '"); }';
 (TMarker(FOwner).FWebGmaps as TTMSFMXWebGMaps).ExecJScript(js);
end;

procedure TMapLabel.SetColor(const Value: TAlphaColor);
var
  js: string;
begin
  FColor := Value;

  js := 'if ('+inttostr(FOwner.Index)+'<alllabels.length) { ' + js + ' alllabels['+inttostr(FOwner.Index)+'].setBackgroundColor("' + ColorToHTML(value) + '"); }';
 (TMarker(FOwner).FWebGmaps as TTMSFMXWebGMaps).ExecJScript(js);
end;

{$IFDEF FMXLIB}
procedure TMapLabel.SetFontColor(const Value: TAlphaColor);
var
  js: string;
begin
  FFontColor := Value;

  js := 'if ('+inttostr(FOwner.Index)+'<alllabels.length) { ' + js + ' alllabels['+inttostr(FOwner.Index)+'].setColor("' + ColorToHTML(value) + '"); }';
 (TMarker(FOwner).FWebGmaps as TTMSFMXWebGMaps).ExecJScript(js);
end;
{$ENDIF}

procedure TMapLabel.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TMapLabel.SetMargin(const Value: integer);
var
  js: string;
begin
  FMargin := Value;

  js := 'if ('+inttostr(FOwner.Index)+'<alllabels.length) { ' + js + ' alllabels['+inttostr(FOwner.Index)+'].setPadding("' + IntToStr(value) + '"); }';
 (TMarker(FOwner).FWebGmaps as TTMSFMXWebGMaps).ExecJScript(js);
end;

procedure TMapLabel.SetOffsetLeft(const Value: integer);
var
  js: string;
begin
  FOffsetLeft := Value;

  js := 'if ('+inttostr(FOwner.Index)+'<alllabels.length) { ' + js + ' alllabels['+inttostr(FOwner.Index)+'].setOffsetLeft("' + IntToStr(value) + '"); }';
 (TMarker(FOwner).FWebGmaps as TTMSFMXWebGMaps).ExecJScript(js);
end;

procedure TMapLabel.SetOffsetTop(const Value: integer);
var
  js: string;
begin
  FOffsetTop := Value;

  js := 'if ('+inttostr(FOwner.Index)+'<alllabels.length) { ' + js + ' alllabels['+inttostr(FOwner.Index)+'].setOffsetTop("' + IntToStr(value) + '"); }';
 (TMarker(FOwner).FWebGmaps as TTMSFMXWebGMaps).ExecJScript(js);
end;

procedure TMapLabel.SetOwner(const Value: TCollectionItem);
begin
  FOwner := Value;
end;

procedure TMapLabel.SetText(const Value: string);
var
  js: string;
begin
  FText := Value;
  if Value = EmptyStr then
    js := 'alllabels['+inttostr(FOwner.Index)+'].hide();'
  else
    js := 'alllabels['+inttostr(FOwner.Index)+'].show();';

  js := 'if ('+inttostr(FOwner.Index)+'<alllabels.length) { ' + js + ' alllabels['+inttostr(FOwner.Index)+'].setText("' + StringReplace(value, '"', '&quote;', [rfReplaceAll]) + '"); }';
 (TMarker(FOwner).FWebGmaps as TTMSFMXWebGMaps).ExecJScript(js);
end;

end.
