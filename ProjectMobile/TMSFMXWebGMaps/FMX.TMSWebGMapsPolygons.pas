{***************************************************************************)
{ TMS FMX WebGMaps component                                                    }
{ for Delphi & C++Builder                                                   }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2012 - 2016                                        }
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

unit FMX.TMSWebGMapsPolygons;

interface

{$I TMSDEFS.INC}

uses
  SysUtils, Classes, FMX.Controls, Types, FMX.TMSWebGMapsCommon, StrUtils,
  FMX.TMSWebGMapsConst, FMX.TMSWebGMapsCommonFunctions, FMX.TMSWebGMapsPolylines, FMX.Graphics
  {$IFDEF FMXLIB}
  , UIConsts, UITypes
  {$ENDIF}
  ;


type
  TPolygons = class;
  TMapPolygon = class;

  TMapPolygon = class(TPersistent)
  private
    FZindex: integer;
    FWidth: integer;
    FVisible: boolean;
    FGeodesic: boolean;
    FClickable: boolean;
    FEditable: boolean;
    FTitle: string;
    FItemIndex: integer;
    FBorderColor: TAlphaColor;
    FBackgroundOpacity: integer;
    FBorderOpacity: integer;
    FBackgroundColor: TAlphaColor;
    FBorderWidth: integer;
    FPath: TPath;
    FTag: integer;
    FPolygonType: TPolygonType;
    FRadius: integer;
    FCenter: TLocation;
    FBounds: TBounds;
    FOwner: TPersistent;
    procedure SetClickable(const Value: boolean);
    procedure SetEditable(const Value: boolean);
    procedure SetVisible(const Value: boolean);
    procedure SetZindex(const Value: integer);
    procedure SetGeodesic(const Value: boolean);
    procedure SetBackgroundColor(const Value: TAlphaColor);
    procedure SetBackgroundOpacity(const Value: integer);
    procedure SetBorderColor(const Value: TAlphaColor);
    procedure SetBorderOpacity(const Value: integer);
    procedure SetBorderWidth(const Value: integer);
    procedure SetPath(const Value: TPath);
    procedure SetTag(const Value: integer);
    procedure SetPolygonType(const Value: TPolygonType);
    procedure SetRadius(const Value: integer);
    procedure SetCenter(const Value: TLocation);
    procedure SetBounds(const Value: TBounds);
    procedure SetItemIndex(const Value: integer);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent);
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
    property ItemIndex: integer read FItemIndex write SetItemIndex;
    function PathBounds: TBounds;
  published
    property Clickable: boolean read FClickable write SetClickable default True;
    property Editable: boolean read FEditable write SetEditable default False;
    property Geodesic: boolean read FGeodesic write SetGeodesic default False;
    property Path: TPath read FPath write SetPath;
    property BackgroundColor: TAlphaColor read FBackgroundColor write SetBackgroundColor default claBlue;
    property BackgroundOpacity: integer read FBackgroundOpacity write SetBackgroundOpacity default 100;
    property BorderColor: TAlphaColor read FBorderColor write SetBorderColor default claBlue;
    property BorderOpacity: integer read FBorderOpacity write SetBorderOpacity default 255;
    property BorderWidth: integer read FBorderWidth write SetBorderWidth default 4;
    property Visible: boolean read FVisible write SetVisible default True;
    property PolygonType: TPolygonType read FPolygonType write SetPolygonType default ptPath;
    property Radius: integer read FRadius write SetRadius default 10000;
    property Center: TLocation read FCenter write SetCenter;
    property Bounds: TBounds read FBounds write SetBounds;
    property Tag: integer read FTag write SetTag default 0;
    property Zindex: integer read FZindex write SetZindex default 0;
  end;

  TPolygonItem = class(TCollectionItem)
  private
    FPolygon: TMapPolygon;
    procedure SetPolygon(const Value: TMapPolygon);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Polygon: TMapPolygon read FPolygon write SetPolygon;
  end;

  TPolygons = class(TOwnedCollection)
  private
    FWebGMaps : TControl;
    function GetItem(Index : integer) : TPolygonItem;
    procedure SetItem(Index : integer; Value : TPolygonItem);
  protected
    function GetOwner : TPersistent; override;
    procedure Update(Item : TCollectionItem); override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(AWebGMaps : TControl);
    function Add(Clickable, Editable, Geodesic: boolean; Path: TPath;
    BackgroundColor, BorderColor: TAlphaColor; BackgroundOpacity, BorderOpacity,
    BorderWidth: integer; Visible: boolean; Zindex: integer): TPolygonItem; overload;
    function Add(Path: TPath): TPolygonItem; overload;
    function Add: TPolygonItem; overload;
    property Items[index : integer] : TPolygonItem read GetItem write SetItem; default;
    function Bounds: TBounds;
  end;

implementation

uses
  FMX.TMSWebGMaps;

{ TMapPolygon }

procedure TMapPolygon.Assign(Source: TPersistent);
var
  FSource : TMapPolygon;
begin
  if (Source is TMapPolygon) then
  begin
    FSource               := TMapPolygon(Source);
    FClickable            := FSource.FClickable;
    FEditable             := FSource.FEditable;
    FGeodesic             := FSource.FGeoDesic;
    FPath.Assign(FSource.FPath);
    FBackgroundColor      := FSource.FBackgroundColor;
    FBackgroundOpacity    := FSource.FBackgroundOpacity;
    FBorderColor          := FSource.FBorderColor;
    FBorderOpacity        := FSource.FBorderOpacity;
    FTitle                := FSource.FTitle;
    FBorderWidth          := FSource.FWidth;
    FVisible              := FSource.FVisible;
    FZindex               := FSource.FZindex;
    FItemIndex            := FSource.FItemIndex;
    FTag                  := FSource.FTag;
    FPolygonType          := FSource.FPolygonType;
    FRadius               := FSource.FRadius;
    FCenter.Assign(FSource.FCenter);
    FBounds.Assign(FSource.FBounds);
  end;
end;

constructor TMapPolygon.Create(AOwner: TPersistent);
begin
  FOwner := AOwner;
  FClickable            := True;
  FEditable             := False;
  FGeodesic             := False;
  FPath                 := TPath.Create(Self);
  FBackgroundColor      := claBlue;
  FBackgroundOpacity    := 100;
  FBorderColor          := claBlue;
  FBorderOpacity        := 255;
  FBorderWidth          := 4;
  FVisible              := True;
  TPolygonCount         := TPolygonCount + 1;
  FZindex               := TPolygonCount;
  FItemIndex            := TPolygonCount;
  FTag                  := 0;
  FPolygonType          := ptPath;
  FRadius               := 10000;
  FCenter               := TLocation.Create;
  FBounds               := TBounds.Create;
end;

destructor TMapPolygon.Destroy;
begin
  inherited;
  FPath.Free;
  FCenter.Free;
  FBounds.Free;
end;

function TMapPolygon.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TMapPolygon.PathBounds: TBounds;
var
  maxlat,minlat: double;
  maxlon,minlon: double;
  i: integer;
begin
  maxlat := -180;
  maxlon := -90;
  minlat := +180;
  minlon := +90;

  for i := 0 to Path.Count - 1 do
  begin
    if Path[i].Longitude < minlon then
      minlon := Path[i].Longitude;

    if Path[i].Latitude < minlat then
      minlat := Path[i].Latitude;

    if Path[i].Longitude > maxlon then
      maxlon := Path[i].Longitude;

    if Path[i].Latitude > maxlat then
      maxlat := Path[i].Latitude;
  end;

  if (maxlat = -180) then
    maxlat := 180;

  if (maxlon = -90) then
    maxlat := 90;

  if (minlat = 180) then
    minlat := -180;

  if (minlon = 90) then
    minlon := -90;

  Result := TBounds.Create;
  Result.NorthEast.Latitude := maxlat;
  Result.NorthEast.Longitude := maxlon;

  Result.SouthWest.Latitude := minlat;
  Result.SouthWest.Longitude := minlon;
end;

procedure TMapPolygon.SetBackgroundColor(const Value: TAlphaColor);
begin
  FBackgroundColor := Value;
end;

procedure TMapPolygon.SetBackgroundOpacity(const Value: integer);
begin
  FBackgroundOpacity := Value;
end;

procedure TMapPolygon.SetBorderColor(const Value: TAlphaColor);
begin
  FBorderColor := Value;
end;

procedure TMapPolygon.SetBorderOpacity(const Value: integer);
begin
  FBorderOpacity := Value;
end;

procedure TMapPolygon.SetBorderWidth(const Value: integer);
begin
  FBorderWidth := Value;
end;

procedure TMapPolygon.SetBounds(const Value: TBounds);
begin
  FBounds := Value;
end;

procedure TMapPolygon.SetCenter(const Value: TLocation);
begin
  FCenter := Value;
end;

procedure TMapPolygon.SetClickable(const Value: boolean);
begin
  FClickable := Value;
end;

procedure TMapPolygon.SetEditable(const Value: boolean);
begin
  FEditable := Value;
end;

procedure TMapPolygon.SetGeodesic(const Value: boolean);
begin
  FGeodesic := Value;
end;

procedure TMapPolygon.SetItemIndex(const Value: integer);
begin
  if (Value >= 0) then
    FItemIndex := Value;
end;

procedure TMapPolygon.SetPath(const Value: TPath);
begin
  FPath.Assign(Value);
end;

procedure TMapPolygon.SetPolygonType(const Value: TPolygonType);
begin
  FPolygonType := Value;
end;

procedure TMapPolygon.SetRadius(const Value: integer);
begin
  FRadius := Value;
end;

procedure TMapPolygon.SetTag(const Value: integer);
begin
  FTag := Value;
end;

procedure TMapPolygon.SetVisible(const Value: boolean);
begin
  FVisible := Value;
end;

procedure TMapPolygon.SetZindex(const Value: integer);
begin
  FZindex := Value;
end;

{ TPolygonItem }

procedure TPolygonItem.Assign(Source: TPersistent);
begin
  if (Source is TPolygonItem) then
  begin
    FPolygon.Assign(Source as TPolygonItem);
  end;

end;

constructor TPolygonItem.Create(Collection: TCollection);
begin
  inherited;
  FPolygon := TMapPolygon.Create(Collection);
end;

destructor TPolygonItem.Destroy;
begin
  FPolygon.Free;
  inherited;
end;

procedure TPolygonItem.SetPolygon(const Value: TMapPolygon);
begin
  FPolygon := Value;
end;

{ TPolygons }

function TPolygons.Add(Path: TPath): TPolygonItem;
begin
  Result := Add(True, False, False, Path, claBlue, claBlue, 100, 255, 1, True, 0);
end;

function TPolygons.Add: TPolygonItem;
begin
  Result := TPolygonItem(inherited Add);
end;

function TPolygons.Bounds: TBounds;
var
  maxlat,minlat: double;
  maxlon,minlon: double;
  i,j: integer;
begin
  maxlat := -180;
  maxlon := -90;
  minlat := +180;
  minlon := +90;

  for i := 0 to Count - 1 do
  begin
    for j := 0 to Items[i].Polygon.Path.Count - 1 do
    begin
      if Items[i].Polygon.Path[j].Longitude < minlon then
        minlon := Items[i].Polygon.Path[j].Longitude;

      if Items[i].Polygon.Path[j].Latitude < minlat then
        minlat := Items[i].Polygon.Path[j].Latitude;

      if Items[i].Polygon.Path[j].Longitude > maxlon then
        maxlon := Items[i].Polygon.Path[j].Longitude;

      if Items[i].Polygon.Path[j].Latitude > maxlat then
        maxlat := Items[i].Polygon.Path[j].Latitude;
    end;
  end;

  if (maxlat = -180) then
    maxlat := 180;

  if (maxlon = -90) then
    maxlat := 90;

  if (minlat = 180) then
    minlat := -180;

  if (minlon = 90) then
    minlon := -90;

  Result := TBounds.Create;
  Result.NorthEast.Latitude := maxlat;
  Result.NorthEast.Longitude := maxlon;

  Result.SouthWest.Latitude := minlat;
  Result.SouthWest.Longitude := minlon;
end;

function TPolygons.Add(Clickable, Editable, Geodesic: boolean;
  Path: TPath; BackgroundColor, BorderColor: TAlphaColor; BackgroundOpacity,
  BorderOpacity, BorderWidth: integer; Visible: boolean; Zindex: integer)
  : TPolygonItem;
begin
  Result                               := TPolygonItem(inherited Add);
  Result.Polygon.FClickable            := Clickable;
  Result.Polygon.FEditable             := Editable;
  Result.Polygon.Geodesic              := Geodesic;
  Result.Polygon.Path.Assign(Path);
  Result.Polygon.BackgroundColor       := BackgroundColor;
  Result.Polygon.BackgroundOpacity     := BackgroundOpacity;
  Result.Polygon.BorderColor           := BorderColor;
  Result.Polygon.BorderOpacity         := BorderOpacity;
  Result.Polygon.BorderWidth           := BorderWidth;
  Result.Polygon.FVisible              := Visible;
  Result.Polygon.FZindex               := zIndex;
  Result.Changed(False);
end;

constructor TPolygons.Create(AWebGMaps : TControl);
begin
  inherited Create(AWebGMaps,TPolygonItem);
  FWebGMaps := AWebGMaps;
end;

function TPolygons.GetItem(Index: integer): TPolygonItem;
begin
  Result := TPolygonItem(inherited GetItem(Index));
end;

procedure TPolygons.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
end;

function TPolygons.GetOwner: TPersistent;
begin
  Result := FWebGMaps;
end;

procedure TPolygons.SetItem(Index: integer; Value: TPolygonItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TPolygons.Update(Item: TCollectionItem);
var
  PolygonItem:TPolygonItem;
begin
  inherited;
  if item<>nil then
  begin
    PolygonItem:=(Item as TPolygonItem);
    (FWebGmaps as TTMSFMXWebGMaps).CreateMapPolygon(PolygonItem.Polygon);
  end;
end;

end.
