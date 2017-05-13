{***************************************************************************)
{ TMS FMX WebGMaps component                                                    }
{ for Delphi & C++Builder                                                   }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2012 - 2017                                        }
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

unit FMX.TMSWebGMapsPolylines;

interface

{$I TMSDEFS.INC}

uses
  SysUtils, Classes, FMX.Controls, Types, FMX.TMSWebGMapsCommon, StrUtils,
  FMX.TMSWebGMapsConst, FMX.TMSWebGMapsCommonFunctions, FMX.Graphics
  {$IFDEF FMXLIB}
  , UITypes, UIConsts
  {$ENDIF}
  ;

type
  TPolylines = class;
  TPolyline = class;

  TSymbol = class(TCollectionItem)
  private
    FPolyline: TPolyline;
    FSymbolType: TSymbolType;
    FOffset: integer;
    FRepeatType: TDistanceType;
    FRepeatValue: integer;
    FOffsetType: TDistanceType;
    FFixedRotation: boolean;
    procedure SetOffset(const Value: integer);
    procedure SetSymbolType(const Value: TSymbolType);
    procedure SetOffsetType(const Value: TDistanceType);
    procedure SetRepeatValue(const Value: integer);
    procedure SetFixedRotation(const Value: boolean);
    procedure SetRepeatType(const Value: TDistanceType);
  protected
  public
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published
    property SymbolType : TSymbolType read FSymbolType write SetSymbolType default stCircle;
    property Offset : integer read FOffset write SetOffset default 0;
    property OffsetType : TDistanceType read FOffsetType write SetOffsetType default dtPercentage;
    property RepeatValue : integer read FRepeatValue write SetRepeatValue default 0;
    property RepeatType : TDistanceType read FRepeatType write SetRepeatType default dtPercentage;
    property FixedRotation : boolean read FFixedRotation write SetFixedRotation default false;
  end;

  TSymbols = class(TCollection)
  private
    FOwner: TPolyline;
    function GetItem(Index : integer) : TSymbol;
    procedure SetItem(Index : integer; Value : TSymbol);
  protected
    function GetOwner : TPersistent; override;
    procedure Update(Item : TCollectionItem); override;
  public
    constructor Create(APolyline : TPolyline); overload;
    constructor Create(); overload;
    function Add: TSymbol; overload;
    property Items[index : integer] : TSymbol read GetItem write SetItem; default;
  end;

  TPathItem = class(TCollectionItem)
  private
    FLatitude: double;
    FLongitude: double;
    FIsWayPoint: boolean;
    procedure SetLatitude(const Value: double);
    procedure SetLongitude(const Value: double);
  protected
  public
    property IsWayPoint: boolean read FIsWayPoint write FIsWayPoint default false;
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published
    property Latitude: double read FLatitude write SetLatitude;
    property Longitude: double read FLongitude write SetLongitude;
  end;

  TPath = class(TOwnedCollection)
  private
    FOwner : TPersistent;
    function GetItem(Index : integer) : TPathItem;
    procedure SetItem(Index : integer; Value : TPathItem);
  protected
    function GetOwner : TPersistent; override;
    procedure Update(Item : TCollectionItem); override;
  public
    constructor Create(APersistent : TPersistent); overload;
    constructor Create(); overload;
    function Add: TPathItem; overload;
    function Add(Latitude, Longitude: double): TPathItem; overload;
    function Add(Location: TLocation): TPathItem; overload;
    property Items[index : integer] : TPathItem read GetItem write SetItem; default;
  end;

  TPolyline = class(TPersistent)
  private
    FZindex: integer;
    FOpacity: integer;
    FWidth: integer;
    FColor: TAlphaColor;
    FVisible: boolean;
    FGeodesic: boolean;
    FClickable: boolean;
    FEditable: boolean;
    FPath: TPath;
    FIcons: TSymbols;
    FItemIndex: integer;
    FTag: integer;
    FOwner: TPersistent;
    procedure SetClickable(const Value: boolean);
    procedure SetColor(const Value: TAlphaColor);
    procedure SetEditable(const Value: boolean);
    procedure SetOpacity(const Value: integer);
    procedure SetVisible(const Value: boolean);
    procedure SetZindex(const Value: integer);
    procedure SetWidth(const Value: integer);
    procedure SetPath(const Value: TPath);
    procedure SetGeodesic(const Value: boolean);
    procedure SetIcons(const Value: TSymbols);
    procedure SetTag(const Value: integer);
    procedure SetItemIndex(const Value: integer);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent);
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
    procedure DecodeValues(s: string);
    property ItemIndex : integer read FItemIndex write SetItemIndex;
    function PathBounds: TBounds;
  published
    property Clickable : boolean read FClickable write SetClickable default True;
    property Editable : boolean read FEditable write SetEditable default False;
    property Geodesic : boolean read FGeodesic write SetGeodesic default False;
    property Icons : TSymbols read FIcons write SetIcons;
    property Path : TPath read FPath write SetPath;
    property Color : TAlphaColor read FColor write SetColor default claBlue;
    property Opacity : integer read FOpacity write SetOpacity default 100;
    property Width : integer read FWidth write SetWidth default 4;
    property Visible : boolean read FVisible write SetVisible default True;
    property Zindex : integer read FZindex write SetZindex default 0;
    property Tag : integer read FTag write SetTag default 0;
  end;

  TPolylineItem = class(TCollectionItem)
  private
    FPolyline: TPolyline;
    procedure SetPolyline(const Value: TPolyline);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Polyline: TPolyline read FPolyline write SetPolyline;
  end;

  TPolylines = class(TOwnedCollection)
  private
    FWebGMaps : TControl;
    function GetItem(Index : integer) : TPolylineItem;
    procedure SetItem(Index : integer; Value : TPolylineItem);
  protected
    function GetOwner : TPersistent; override;
    procedure Update(Item : TCollectionItem); override;
  public
    constructor Create(AWebGMaps : TControl);
    function Add(Clickable, Editable, Geodesic: boolean; Icons: TSymbols; Path: TPath; Color: TAlphaColor; Opacity, Width: integer; Visible: boolean; Zindex: integer): TPolylineItem; overload;
    function Add(Path: TPath): TPolylineItem; overload;
    function Add: TPolylineItem; overload;
    property Items[index : integer] : TPolylineItem read GetItem write SetItem; default;
    function Bounds: TBounds;
  end;

implementation

uses
  FMX.TMSWebGMaps;

{ TPolyline }

procedure TPolyline.Assign(Source: TPersistent);
var
  PolylineSource : TPolyline;
begin
  if (Source is TPolyline) then
  begin
    PolylineSource        := TPolyline(Source);
    FClickable            := PolylineSource.FClickable;
    FEditable             := PolylineSource.FEditable;
    FGeodesic             := PolylineSource.FGeoDesic;
    FColor                := PolylineSource.FColor;
    FOpacity              := PolylineSource.FOpacity;
    FWidth                := PolylineSource.FWidth;
    FVisible              := PolylineSource.FVisible;
    FZindex               := PolylineSource.FZindex;
    FItemIndex            := PolylineSource.FItemIndex;
    FTag                  := PolylineSource.FTag;
    FPath.Assign(PolyLineSource.Path);
    FIcons.Assign(PolylineSource.Icons);
  end;
end;

constructor TPolyline.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
  FClickable := True;
  FEditable := False;
  FGeodesic := False;
  FIcons := TSymbols.Create(Self);
  FPath := TPath.Create(Self);
  FColor := claBlue;
  FOpacity := 100;
  FWidth := 4;
  FVisible := True;
  TPolylineCount        := TPolylineCount + 1;
  FZindex               := TPolylineCount;
  FItemIndex            := TPolylineCount;
  FTag                  := 0;
end;

destructor TPolyline.Destroy;
begin
  inherited;
  FIcons.Free;
  FPath.Free;
end;


function TPolyline.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TPolyline.PathBounds: TBounds;
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

procedure TPolyline.SetClickable(const Value: boolean);
begin
  FClickable := Value;
end;

procedure TPolyline.SetColor(const Value: TAlphaColor);
begin
  FColor := Value;
end;

procedure TPolyline.SetEditable(const Value: boolean);
begin
  FEditable := Value;
//  if Value then
//    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('allpolylines['+inttostr(Index)+'].setEditable(true);')
//  else
//    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('allpolylines['+inttostr(Index)+'].setEditable(false);');
end;

procedure TPolyline.SetGeodesic(const Value: boolean);
begin
  FGeodesic := Value;
end;

procedure TPolyline.SetIcons(const Value: TSymbols);
begin
  FIcons.Assign(Value);
end;

procedure TPolyline.SetItemIndex(const Value: integer);
begin
  if (Value >= 0) then
    FItemIndex := Value;
end;

procedure TPolyline.SetOpacity(const Value: integer);
begin
  FOpacity := Value;
end;

procedure TPolyline.SetPath(const Value: TPath);
begin
  FPath.Assign(Value);
end;

procedure TPolyline.SetTag(const Value: integer);
begin
  FTag := Value;
end;

procedure TPolyline.SetVisible(const Value: boolean);
begin
  FVisible := Value;
//  if Value then
//    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('allpolylines['+inttostr(Index)+'].setVisible(true);')
//  else
//    (FWebGmaps as TTMSFMXWebGMaps).ExecJScript('allpolylines['+inttostr(Index)+'].setVisible(false);');
end;

procedure TPolyline.SetWidth(const Value: integer);
begin
  FWidth := Value;
end;

procedure TPolyline.SetZindex(const Value: integer);
begin
  FZindex := Value;
end;

procedure TPolyline.DecodeValues(s: string);
var
  index: integer;
  shifter: integer;
  sum: integer;
  currentLat: integer;
  currentLng: integer;
  next5bits: integer;
  lat: double;
  lng: double;
begin
//  sum := 0;
  {$IFDEF DELPHI_LLVM}
  index := 0;
  {$ELSE}
  index := 1;
  {$ENDIF}
//  shifter := 0;
  currentlng := 0; //round(lng * 100000);
  currentlat := 0; //round(lat * 100000);

  {$IFDEF DELPHI_LLVM}
  while index <= length(s) - 1 do
  {$ELSE}
  while index <= length(s) do
  {$ENDIF}
  begin
    sum := 0;
    shifter := 0;
    //calculate next latitude
    repeat
      next5bits := ord(s[index]) - 63;
      inc(index);
      sum := sum or ((next5bits AND 31) shl shifter);
      shifter := shifter + 5;
    until (next5bits < 32) or (index > length(s));

    {$IFDEF DELPHI_LLVM}
    if (index >= Length(s) - 1) then
      break;
    {$ELSE}
    if (index >= Length(s)) then
      break;
    {$ENDIF}

    if sum and 1 = 1 then
      currentLat := currentlat - (sum shr 1)
    else
      currentLat := currentlat + (sum shr 1);

    //calculate next longitude
    sum := 0;
    shifter := 0;

    repeat
      next5bits := ord(s[index]) - 63;
      inc(index);
      sum := sum or ((next5bits AND 31) shl shifter);
      shifter := shifter + 5;
    until (next5bits < 32) or (index > length(s));

    {$IFDEF DELPHI_LLVM}
    if (index >= Length(s) - 1) and (next5bits >= 32) then
      break;
    {$ELSE}
    if (index >= Length(s)) and (next5bits >= 32) then
      break;
    {$ENDIF}

    if sum and 1 = 1 then
      currentLng := currentlng - (sum shr 1)
    else
      currentLng := currentLng + (sum shr 1);

    lng := currentLng / 100000;
    lat := (currentLat / 100000);

    //-> add to collection
    Path.Add(lat, lng);
  end;
end;

{ TPolylineItem }

procedure TPolylineItem.Assign(Source: TPersistent);
begin
  if (Source is TPolyLineItem) then
  begin
    FPolyline := (Source as TPolylineItem).PolyLine;
  end;
end;

constructor TPolylineItem.Create(Collection: TCollection);
begin
  inherited;
  FPolyline := TPolyline.Create(Collection);
end;

destructor TPolylineItem.Destroy;
begin
  FPolyline.Free;
  inherited;
end;

procedure TPolylineItem.SetPolyline(const Value: TPolyline);
begin
  FPolyline := Value;
end;

{ TPolylines }

function TPolylines.Add(Path: TPath): TPolylineItem;
begin
  Result := Add(True, False, False, nil, Path, claBlue, 100, 1, True, 0);
end;

function TPolylines.Add: TPolylineItem;
begin
  Result := TPolylineItem(inherited Add);
end;

function TPolylines.Bounds: TBounds;
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
    for j := 0 to Items[i].Polyline.Path.Count - 1 do
    begin
      if Items[i].PolyLine.Path[j].Longitude < minlon then
        minlon := Items[i].PolyLine.Path[j].Longitude;

      if Items[i].PolyLine.Path[j].Latitude < minlat then
        minlat := Items[i].PolyLine.Path[j].Latitude;

      if Items[i].PolyLine.Path[j].Longitude > maxlon then
        maxlon := Items[i].PolyLine.Path[j].Longitude;

      if Items[i].PolyLine.Path[j].Latitude > maxlat then
        maxlat := Items[i].PolyLine.Path[j].Latitude;
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

function TPolylines.Add(Clickable, Editable, Geodesic: boolean; Icons: TSymbols;
  Path: TPath; Color: TAlphaColor; Opacity, Width: integer; Visible: boolean;
  Zindex: integer): TPolylineItem;
begin
  Result                                := TPolylineItem(inherited Add);
  Result.Polyline.FClickable            := Clickable;
  Result.Polyline.FEditable             := Editable;
  Result.Polyline.Geodesic              := Geodesic;

  if Icons <> nil then
    Result.Polyline.Icons.Assign(Icons);

  if Path <> nil then
    Result.Polyline.Path.Assign(Path);

  Result.Polyline.Color                 := Color;
  Result.Polyline.Opacity               := Opacity;
  Result.Polyline.Width                 := Width;
  Result.Polyline.FVisible              := Visible;
  Result.Polyline.FZindex               := zIndex;
  Result.Changed(False);
end;

constructor TPolylines.Create(AWebGMaps : TControl);
begin
  inherited Create(AWebGMaps,TPolylineItem);
  FWebGMaps := AWebGMaps;
end;

function TPolylines.GetItem(Index: integer): TPolylineItem;
begin
  Result := TPolylineItem(inherited GetItem(Index));
end;

function TPolylines.GetOwner: TPersistent;
begin
  Result := FWebGMaps;
end;

procedure TPolylines.SetItem(Index: integer; Value: TPolylineItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TPolylines.Update(Item: TCollectionItem);
var
  PolylineItem:TPolylineItem;
begin
  inherited;
  if item<>nil then
  begin
    PolylineItem:=(Item as TPolylineItem);
    (FWebGmaps as TTMSFMXWebGMaps).CreateMapPolyline(PolylineItem.Polyline);
  end;
end;

{ TPathItem }

procedure TPathItem.Assign(Source: TPersistent);
var
  PathItemSource : TPathItem;
begin
  if (Source is TPathItem) then
  begin
    PathItemSource        := TPathItem(Source);
    FLatitude             := PathItemSource.FLatitude;
    FLongitude            := PathItemSource.FLongitude;
  end;
end;

constructor TPathItem.Create(Collection: TCollection);
begin
  inherited;
  //FPolyline            := TPathItem(Collection).FPolyline;
  FIsWayPoint           := false;
  FLatitude             := 0;
  FLongitude            := 0;

end;

destructor TPathItem.Destroy;
begin
  inherited;
end;

procedure TPathItem.SetLatitude(const Value: double);
begin
  FLatitude := Value;
end;

procedure TPathItem.SetLongitude(const Value: double);
begin
  FLongitude := Value;
end;

{ TPath }

function TPath.Add: TPathItem;
begin
  Result := TPathItem(inherited Add);
end;

constructor TPath.Create(APersistent: TPersistent);
begin
//  inherited Create(TPathItem);
  inherited Create(APersistent, TPathItem);
  FOwner := APersistent;
end;

function TPath.Add(Latitude, Longitude: double): TPathItem;
begin
  Result                       := TPathItem(inherited Add);
  Result.FLatitude             := Latitude;
  Result.FLongitude            := Longitude;
  Result.Changed(False);
end;

function TPath.Add(Location: TLocation): TPathItem;
begin
  Result                       := TPathItem(inherited Add);
  Result.FLatitude             := Location.Latitude;
  Result.FLongitude            := Location.Longitude;
  Result.Changed(False);
end;

constructor TPath.Create;
begin
  inherited Create(FOwner, TPathItem);
end;

function TPath.GetItem(Index: integer): TPathItem;
begin
  Result := TPathItem(inherited GetItem(Index));
end;

function TPath.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TPath.SetItem(Index: integer; Value: TPathItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TPath.Update(Item: TCollectionItem);
begin
  inherited;
end;

{ TSymbol }

procedure TSymbol.Assign(Source: TPersistent);
var
  SymbolSource : TSymbol;
begin
  if (Source is TSymbol) then
  begin
    SymbolSource        := (Source as TSymbol);
    FSymbolType         := SymbolSource.FSymbolType;
    FOffset             := SymbolSource.FOffset;
    FOffsetType         := SymbolSource.FOffsetType;
    FRepeatValue        := SymbolSource.FRepeatValue;
    FRepeatType         := SymbolSource.FRepeatType;
    FFixedRotation      := SymbolSource.FFixedRotation;
  end;
end;

constructor TSymbol.Create(Collection: TCollection);
begin
  inherited;
  FPolyline            := (Collection as TSymbols).FOwner;
  FSymbolType          := stCircle;
  FOffset              := 0;
  FOffsetType          := dtPercentage;
  FRepeatValue         := 0;
  FRepeatType          := dtPercentage;
  FFixedRotation       := false;
end;

destructor TSymbol.Destroy;
begin
  inherited;
end;

procedure TSymbol.SetFixedRotation(const Value: boolean);
begin
  FFixedRotation := Value;
end;

procedure TSymbol.SetOffset(const Value: integer);
begin
  FOffset := Value;
end;

procedure TSymbol.SetOffsetType(const Value: TDistanceType);
begin
  FOffsetType := Value;
end;

procedure TSymbol.SetRepeatType(const Value: TDistanceType);
begin
  FRepeatType := Value;
end;

procedure TSymbol.SetRepeatValue(const Value: integer);
begin
  FRepeatValue := Value;
end;

procedure TSymbol.SetSymbolType(const Value: TSymbolType);
begin
  FSymbolType := Value;
end;

{ TSymbols }

function TSymbols.Add: TSymbol;
begin
  Result := TSymbol(inherited Add);
end;

constructor TSymbols.Create;
begin
  inherited Create(TSymbol);
end;

constructor TSymbols.Create(APolyline: TPolyline);
begin
  inherited Create(TSymbol);
  FOwner := APolyline;
end;

function TSymbols.GetItem(Index: integer): TSymbol;
begin
  Result := TSymbol(inherited GetItem(Index));
end;

function TSymbols.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSymbols.SetItem(Index: integer; Value: TSymbol);
begin
  inherited SetItem(Index, Value);
end;

procedure TSymbols.Update(Item: TCollectionItem);
begin
  inherited;
end;

end.
