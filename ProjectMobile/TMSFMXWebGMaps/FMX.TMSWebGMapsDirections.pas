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

unit FMX.TMSWebGMapsDirections;

{$I TMSDEFS.INC}

interface

uses
  SysUtils, Classes, FMX.Controls, Types, FMX.TMSWebGMapsCommon, StrUtils,
  FMX.TMSWebGMapsConst, FMX.TMSWebGMapsCommonFunctions, FMX.TMSWebGMapsPolylines, FMX.Graphics
{$IFDEF DELPHIXE_LVL}
{$IFDEF DELPHIXE6_LVL}
  , JSON
{$ELSE}
  , DBXJSON
{$ENDIF}
{$ENDIF}
  ;

type
  {$IFNDEF MSWINDOWS}
  AChar = #0..'ÿ';
  PAChar = ^AChar;
  AnsiChar = AChar;
  AnsiString = string;
  UTF8String = string;
  rawbytestring = string;
  {$ENDIF}

  TDirections = class;
  TRoute = class;
  TLeg = class;

  TStep = class(TCollectionItem)
  private
    FLeg: TLeg;
    FInstructions: string;
    FDistance: integer;
    FDuration: integer;
    FStartLocation: TLocation;
    FEndLocation: TLocation;
    FPolyline: TPolyline;
    FTravelMode: TTravelMode;
    FDistanceText: string;
    FDurationText: string;
    procedure SetDistance(const Value: integer);
    procedure SetDuration(const Value: integer);
    procedure SetEndLocation(const Value: TLocation);
    procedure SetStartLocation(const Value: TLocation);
    procedure SetTravelMode(const Value: TTravelMode);
    procedure SetInstructions(const Value: string);
    procedure SetDistanceText(const Value: string);
    procedure SetDurationText(const Value: string);
  protected
  public
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
    {$IFDEF DELPHIXE_LVL}
    procedure FromJSON(jo: TJSONObject);
    {$ENDIF}
  published
    property Instructions: string read FInstructions write SetInstructions;
    property Distance: integer read FDistance write SetDistance default 0;
    property DistanceText: string read FDistanceText write SetDistanceText;
    property Duration: integer read FDuration write SetDuration default 0;
    property DurationText: string read FDurationText write SetDurationText;
    property EndLocation: TLocation read FEndLocation write SetEndLocation;
    property StartLocation: TLocation read FStartLocation write SetStartLocation;
    property Polyline: TPolyline read FPolyline write FPolyline;
    property TravelMode: TTravelMode read FTravelMode write SetTravelMode default tmDriving;
  end;

  TSteps = class(TCollection)
  private
    FLeg: TLeg;
    function GetItem(Index: integer) : TStep;
    procedure SetItem(Index: integer; Value : TStep);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(ALeg: TLeg);
    function Add: TStep; overload;
    property Items[index: integer]: TStep read GetItem write SetItem; default;
  end;

  TLeg = class(TCollectionItem)
  private
    FRoute: TRoute;
    FDistance: integer;
    FStartAddress: string;
    FDuration: integer;
    FSteps: TSteps;
    FStartLocation: TLocation;
    FEndAddress: string;
    FEndLocation: TLocation;
    FDistanceText: string;
    FDurationText: string;
    FWayPointIndex: integer;
    procedure SetSteps(const Value: TSteps);
    procedure SetDistance(const Value: integer);
    procedure SetDuration(const Value: integer);
    procedure SetEndAddress(const Value: string);
    procedure SetEndLocation(const Value: TLocation);
    procedure SetStartAddress(const Value: string);
    procedure SetStartLocation(const Value: TLocation);
    procedure SetDistanceText(const Value: string);
    procedure SetDurationText(const Value: string);
    procedure SetWayPointIndex(const Value: integer);
  protected
  public
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    {$IFDEF DELPHIXE_LVL}
    procedure FromJSON(jo: TJSONObject; UTF8Decode: boolean = true);
    {$ENDIF}
  published
    property Distance: integer read FDistance write SetDistance default 0;
    property DistanceText: string read FDistanceText write SetDistanceText;
    property Duration: integer read FDuration write SetDuration default 0;
    property DurationText: string read FDurationText write SetDurationText;
    property EndAddress: string read FEndAddress write SetEndAddress;
    property EndLocation: TLocation read FEndLocation write SetEndLocation;
    property StartAddress: string read FStartAddress write SetStartAddress;
    property StartLocation: TLocation read FStartLocation write SetStartLocation;
    property Steps: TSteps read FSteps write SetSteps;
    property WayPointIndex: integer read FWayPointIndex write SetWayPointIndex default -1;
  end;

  TLegs = class(TCollection)
  private
    FRoute : TRoute;
    function GetItem(Index : integer) : TLeg;
    procedure SetItem(Index : integer; Value : TLeg);
  protected
    function GetOwner : TPersistent; override;
    procedure Update(Item : TCollectionItem); override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(ARoute : TRoute); overload;
    function Add: TLeg; overload;
    property Items[index : integer] : TLeg read GetItem write SetItem; default;
  end;

  TRoute = class(TCollectionItem)
  private
    FWebGMaps : TControl;
    FPolyline: TPolyline;
    FSummary: string;
    FBounds: TBounds;
    FCopyRights: string;
    FLegs: TLegs;
    FWayPointOrder: TStringList;
    procedure SetBounds(const Value: TBounds);
    procedure SetSummary(const Value: string);
    procedure SetLegs(const Value: TLegs);
    procedure SetPolyline(const Value: TPolyline);
  protected
  public
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
    {$IFDEF DELPHIXE_LVL}
    procedure FromJSON(jo: TJSONObject; UTF8Decode: boolean = true);
    {$ENDIF}
  published
    property Polyline : TPolyline read FPolyline write SetPolyline;
    property Summary : string read FSummary write SetSummary;
    property Bounds : TBounds read FBounds write SetBounds;
    property CopyRights : string read FCopyRights;
    property Legs: TLegs read FLegs write SetLegs;
  end;

  TDirections = class(TCollection)
  private
    FWebGMaps: TControl;
    FStrings: TStringList;
    function GetItem(Index: integer) : TRoute;
    procedure SetItem(Index: integer; Value : TRoute);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(AWebGMaps : TControl);
    destructor Destroy; override;
    function Add: TRoute; overload;
    function AsStrings(Units: TUnits): TStringList;
    property Items[index: integer] : TRoute read GetItem write SetItem; default;
  end;


implementation

uses
  FMX.TMSWebGMaps;

{ TRoute }

procedure TRoute.Assign(Source: TPersistent);
var
  FSource : TRoute;
begin
  if (Source is TRoute) then
  begin
    FSource := TRoute(Source);
    FLegs.Assign(FSource.FLegs);
    FPolyline.Assign(FSource.FPolyline);
    FBounds.Assign(FSource.FBounds);
    FSummary := FSource.Summary;
    FCopyRights := FSource.FCopyRights;
    Changed(True);
  end
  else
    inherited;
end;

constructor TRoute.Create(Collection: TCollection);
begin
  inherited;

  if Assigned(Collection) then
    FWebGMaps := TDirections(Collection).FWebGMaps;

  FLegs := TLegs.Create(Self);
  FPolyline := TPolyline.Create(Collection);
  FSummary := '';
  FCopyRights := '';
  FBounds := TBounds.Create;
  FWayPointOrder := TStringList.Create;
end;

destructor TRoute.Destroy;
begin
  inherited;
  FLegs.Free;
  FPolyline.Free;
  FBounds.Free;
  FWayPointOrder.Free;
end;

{$IFNDEF MSWINDOWS}
function UTF8ToString(AString: AnsiString): String;
begin
  Result := String(AString);
end;
{$ENDIF}

{$IFDEF DELPHIXE_LVL}
procedure TRoute.FromJSON(jo: TJSONObject; UTF8Decode: boolean = true);
var
  fo, ffo, fffo: TJSONObject;
  fja, ffja: TJSONArray;
  j: integer;
  leg: TLeg;
  jp: TJSONPair;
  I: Integer;
  jv: TJSONValue;
  plat, plon: double;
begin
  jp := jo.Get('legs');
  if Assigned(jp) then
  begin
    fja := GetJSONValue(jo,'legs') as TJSONArray;

    if Assigned(fja) then
    begin
      {$IFDEF DELPHIXE6_LVL}
      for j := 0 to fja.Count - 1 do
      begin
        fo := fja.Items[j] as TJSONObject;
      {$ELSE}
      for j := 0 to fja.Size - 1 do
      begin
        fo := fja.Get(j) as TJSONObject;
      {$ENDIF}
        leg := FLegs.Add;
        leg.FromJSON(fo, UTF8Decode);
      end;

      jp := jo.Get('overview_polyline');
      if Assigned(jp) then
      begin
        jv := GetJSONValue(jo,'overview_polyline');

        if Assigned(jv) and (jv is TJSONObject) then
        begin
          ffo := jv as TJSONObject;
          Polyline.Path.Clear;
          Polyline.DecodeValues(GetJSONProp(ffo,'points'));
        end;
      end;

      jp := jo.Get('overview_path');
      if Assigned(jp) then
      begin
        Polyline.Path.Clear;
        ffja := GetJSONValue(jo,'overview_path') as TJSONArray;

        if Assigned(ffja) then
        begin
          {$IFDEF DELPHIXE6_LVL}
          for j := 0 to ffja.Count - 1 do
          begin
             plat := StrToFloat(GetJSONProp(ffja.Items[j] as TJSONObject, 'lat'));
             plon := StrToFloat(GetJSONProp(ffja.Items[j] as TJSONObject, 'lng'));
             Polyline.Path.Add(plat, plon);
          {$ELSE}
          for j := 0 to ffja.Size - 1 do
          begin
             plat := StrToFloat(GetJSONProp(ffja.Get(j) as TJSONObject, 'lat'));
             plon := StrToFloat(GetJSONProp(ffja.Get(j) as TJSONObject, 'lng'));
             Polyline.Path.Add(plat, plon);
          {$ENDIF}
          end;
        end;
      end;

      jp := jo.Get('bounds');
      if Assigned(jp) then
      begin
        ffo := GetJSONValue(jo,'bounds') as TJSONObject;

        fffo := GetJSONValue(ffo,'northeast') as TJSONObject;
        if Assigned(fffo) then
        begin
          Bounds.NorthEast.Latitude := StrToFloat(GetJSONProp(fffo,'lat'));
          Bounds.NorthEast.Longitude := StrToFloat(GetJSONProp(fffo,'lng'));
        end;

        fffo := GetJSONValue(ffo,'southwest') as TJSONObject;
        if Assigned(fffo) then
        begin
          Bounds.SouthWest.Latitude := StrToFloat(GetJSONProp(fffo,'lat'));
          Bounds.SouthWest.Longitude := StrToFloat(GetJSONProp(fffo,'lng'));
        end;
      end;

      jp := jo.Get('summary');
      if Assigned(jp) then
        FSummary := UTF8ToString(RawByteString(GetJSONProp(jo,'summary')));

      jp := jo.Get('copyrights');
      if Assigned(jp) then
        FCopyRights := UTF8ToString(RawByteString(GetJSONProp(jo,'copyrights')));

      //Retrieve optimized waypoint order indexes
      ffja := GetJSONValue(jo,'waypoint_order') as TJSONArray;

      if Assigned(ffja) then
      begin
        {$IFDEF DELPHIXE6_LVL}
        for j := 0 to ffja.Count - 1 do
        begin
          FWayPointOrder.Add(ffja.Items[j].Value);
        {$ELSE}
        for j := 0 to ffja.Size - 1 do
        begin
          FWayPointOrder.Add(ffja.Get(j).Value);
        {$ENDIF}
        end;
      end;
    end;
  end;

  //Set WayPointIndex for each WayPoint (Leg)
  for I := 0 to FLegs.Count - 1 do
  begin
    if FWayPointOrder.Count > I then
    begin
      if FWayPointOrder[I] <> EmptyStr then
        FLegs[I].WayPointIndex := StrToInt(FWayPointOrder[I]);
    end;
  end;
end;
{$ENDIF}

procedure TRoute.SetBounds(const Value: TBounds);
begin
  FBounds := Value;
end;

procedure TRoute.SetLegs(const Value: TLegs);
begin
  FLegs := Value;
end;

procedure TRoute.SetPolyline(const Value: TPolyline);
begin
  FPolyline := Value;
end;

procedure TRoute.SetSummary(const Value: string);
begin
  FSummary := Value;
end;

{ TDirections }

function TDirections.Add: TRoute;
begin
  Result := TRoute(inherited Add);
end;

function TDirections.AsStrings(Units: TUnits): TStringList;
var
  I,J: integer;
  Description: string;
  TotalDistance, TotalDuration: integer;
begin
  FStrings.Clear;
  for I := 0 to Count - 1 do
  begin
    Description := Items[I].Summary + ': ';

    if Items[I].Legs.Count = 1 then
        Description := Description
        + Items[I].Legs[0].DistanceText + ', '
        + Items[I].Legs[0].DurationText
      else
      begin
        TotalDistance := 0;
        TotalDuration := 0;
        for J := 0 to Items[I].Legs.Count - 1 do
        begin
          TotalDistance := TotalDistance + Items[I].Legs[J].Distance;
          TotalDuration := TotalDuration + Items[I].Legs[J].Duration;
        end;

        if Units = usMetric then
          Description := Description +
            FormatFloat('0.00', TotalDistance / 1000) + ' km, '
            + FormatFloat('0.00', (TotalDuration / 60) / 60) + ' h'
        else
          Description := Description +
            FormatFloat('0.00', (TotalDistance / 1000) / 1.6) + ' mi, '
            + FormatFloat('0.00', (TotalDuration / 60) / 60) + ' h';
      end;

    FStrings.Add(Description);
  end;

  Result := FStrings;
end;

constructor TDirections.Create(AWebGMaps : TControl);
begin
  inherited Create(TRoute);
  FWebGMaps := AWebGMaps;
  FStrings := TStringList.Create;
end;

destructor TDirections.Destroy;
begin
  FStrings.Free;
  inherited;
end;

function TDirections.GetItem(Index: integer): TRoute;
begin
  Result := TRoute(inherited GetItem(Index));
end;

procedure TDirections.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
end;

function TDirections.GetOwner: TPersistent;
begin
  Result := FWebGMaps;
end;

procedure TDirections.SetItem(Index: integer; Value: TRoute);
begin
  inherited SetItem(Index, Value);
end;

procedure TDirections.Update(Item: TCollectionItem);
begin
  inherited;
end;

{ TLeg }

procedure TLeg.Assign(Source: TPersistent);
var
  FSource : TLeg;
begin
  if (Source is TLeg) then
  begin
    FSource := Source as TLeg;
    FDistance := FSource.FDistance;
    FDistanceText := FSource.FDistanceText;
    FDuration := FSource.FDuration;
    FDurationText := FSource.FDurationText;
    FEndLocation.Assign(FSource.FEndLocation);
    FEndAddress := FSource.FEndAddress;
    FStartLocation.Assign(FSource.FStartLocation);
    FStartAddress := FSource.FStartAddress;
    FSteps.Assign(FSource.FSteps);
    FWayPointIndex := FSource.WayPointIndex;
    Changed(True);
  end;
end;

constructor TLeg.Create(Collection: TCollection);
begin
  inherited;
  FRoute               := TLegs(Collection).FRoute;
  FDistance            := 0;
  FDistanceText        := '';
  FDuration            := 0;
  FDurationText        := '';
  FEndLocation         := TLocation.Create;
  FEndAddress          := '';
  FStartLocation       := TLocation.Create;
  FStartAddress        := '';
  FSteps               := TSteps.Create(Self);
  FWayPointIndex       := -1;
end;

destructor TLeg.Destroy;
begin
  FEndLocation.Free;
  FStartLocation.Free;
  FSteps.Free;
  inherited;
end;

{$IFDEF DELPHIXE_LVL}
procedure TLeg.FromJSON(jo: TJSONObject; UTF8Decode: boolean = true);
var
  jp: TJSONPair;
  ffo: TJSONObject;
  sja: TJSONArray;
  st: TStep;
  i: integer;
begin
  if (Assigned(jo)) then
  begin
    if UTF8Decode then
    begin
      FEndAddress := UTF8ToString(RawByteString(GetJSONProp(jo,'end_address')));
      FStartAddress := UTF8ToString(RawByteString(GetJSONProp(jo,'start_address')));
    end
    else
    begin
      FEndAddress := GetJSONProp(jo,'end_address');
      FStartAddress := GetJSONProp(jo,'start_address');
    end;

    jp := jo.Get('distance');
    if Assigned(jp) then
    begin
      ffo := GetJSONValue(jo,'distance') as TJSONObject;
      jp := ffo.Get('value');
      if Assigned(jp) then
        FDistance := StrToInt(GetJSONProp(ffo,'value'));
      jp := ffo.Get('text');
      if Assigned(jp) then
        FDistanceText := GetJSONProp(ffo,'text');
    end;

    jp := jo.Get('duration');
    if Assigned(jp) then
    begin
      ffo := GetJSONValue(jo,'duration') as TJSONObject;
      jp := ffo.Get('value');
      if Assigned(jp) then
        FDuration := StrToInt(GetJSONProp(ffo,'value'));
      jp := ffo.Get('text');
      if Assigned(jp) then
        FDurationText := GetJSONProp(ffo,'text');
    end;

    jp := jo.Get('end_location');
    if Assigned(jp) then
    begin
      ffo := GetJSONValue(jo,'end_location') as TJSONObject;
      jp := ffo.Get('lat');
      if Assigned(jp) then
        FEndLocation.Latitude := StrToFloat(GetJSONProp(ffo,'lat'));
      jp := ffo.Get('lng');
      if Assigned(jp) then
        FEndLocation.Longitude := StrToFloat(GetJSONProp(ffo,'lng'));
    end;

    jp := jo.Get('start_location');
    if Assigned(jp) then
    begin
      ffo := GetJSONValue(jo,'start_location') as TJSONObject;
      jp := ffo.Get('lat');
      if Assigned(jp) then
        FStartLocation.Latitude := StrToFloat(GetJSONProp(ffo,'lat'));
      jp := ffo.Get('lng');
      if Assigned(jp) then
        FStartLocation.Longitude := StrToFloat(GetJSONProp(ffo,'lng'));
    end;

    jp := jo.Get('steps');
    if Assigned(jp) then
    begin
      sja := GetJSONValue(jo,'steps') as TJSONArray;

      if Assigned(sja) then
      begin
        Steps.Clear;
        {$IFDEF DELPHIXE6_LVL}
        for i := 0 to sja.Count - 1 do
        begin
          ffo := sja.Items[i] as TJSONObject;
        {$ELSE}
        for i := 0 to sja.Size - 1 do
        begin
          ffo := sja.Get(i) as TJSONObject;
        {$ENDIF}
          if (Assigned(ffo)) then
          begin
            st := Steps.Add;
            st.FromJSON(ffo);
          end;
        end;
      end;
    end;
  end;
end;
{$ENDIF}

procedure TLeg.SetDistance(const Value: integer);
begin
  FDistance := Value;
end;

procedure TLeg.SetDistanceText(const Value: string);
begin
  FDistanceText := Value;
end;

procedure TLeg.SetDuration(const Value: integer);
begin
  FDuration := Value;
end;

procedure TLeg.SetDurationText(const Value: string);
begin
  FDurationText := Value;
end;

procedure TLeg.SetEndAddress(const Value: string);
begin
  FEndAddress := Value;
end;

procedure TLeg.SetEndLocation(const Value: TLocation);
begin
  FEndLocation := Value;
end;

procedure TLeg.SetStartAddress(const Value: string);
begin
  FStartAddress := Value;
end;

procedure TLeg.SetStartLocation(const Value: TLocation);
begin
  FStartLocation := Value;
end;

procedure TLeg.SetSteps(const Value: TSteps);
begin
  FSteps := Value;
end;

procedure TLeg.SetWayPointIndex(const Value: integer);
begin
  FWayPointIndex := Value;
end;

{ TLegs }

function TLegs.Add: TLeg;
begin
  Result := TLeg(inherited Add);
end;

constructor TLegs.Create(ARoute: TRoute);
begin
  inherited Create(TLeg);
  FRoute := ARoute;
end;

function TLegs.GetItem(Index: integer): TLeg;
begin
  Result := TLeg(inherited GetItem(Index));
end;

function TLegs.GetOwner: TPersistent;
begin
  Result := FRoute;
end;

procedure TLegs.Notify(Item: TCollectionItem; Action: TCollectionNotification);
begin
  inherited;
end;

procedure TLegs.SetItem(Index: integer; Value: TLeg);
begin
  inherited SetItem(Index, Value);
end;

procedure TLegs.Update(Item: TCollectionItem);
begin
  inherited;
end;

{ TStep }

procedure TStep.Assign(Source: TPersistent);
var
  FSource : TStep;
begin
  if (Source is TStep) then
  begin
    FSource := Source as TStep;
    FInstructions := FSource.FInstructions;
    FDistance := FSource.FDistance;
    FDistanceText := FSource.FDistanceText;
    FDuration := FSource.FDuration;
    FDurationText := FSource.FDurationText;
    FEndLocation.Assign(FSource.FEndLocation);
    FStartLocation.Assign(FSource.FStartLocation);
    FPolyline.Assign(FSource.FPolyline);
    FTravelMode := FSource.FTravelMode;
    Changed(True);
  end;
end;

constructor TStep.Create(Collection: TCollection);
begin
  inherited;
  FLeg                 := TSteps(Collection).FLeg;
  FInstructions        := '';
  FDistance            := 0;
  FDistanceText        := '';
  FDuration            := 0;
  FDurationText        := '';
  FEndLocation         := TLocation.Create;
  FStartLocation       := TLocation.Create;
  FPolyline            := TPolyline.Create(Collection);
  FTravelMode          := tmDriving;
end;

destructor TStep.Destroy;
begin
  FEndLocation.Free;
  FStartLocation.Free;
  FPolyline.Free;
  inherited;
end;

procedure TStep.SetDistance(const Value: integer);
begin
  FDistance := Value;
end;

procedure TStep.SetDistanceText(const Value: string);
begin
  FDistanceText := Value;
end;

procedure TStep.SetDuration(const Value: integer);
begin
  FDuration := Value;
end;

procedure TStep.SetDurationText(const Value: string);
begin
  FDurationText := Value;
end;

procedure TStep.SetEndLocation(const Value: TLocation);
begin
  FEndLocation := Value;
end;

procedure TStep.SetInstructions(const Value: string);
begin
  FInstructions := Value;
end;

procedure TStep.SetStartLocation(const Value: TLocation);
begin
  FStartLocation := Value;
end;

procedure TStep.SetTravelMode(const Value: TTravelMode);
begin
  FTravelMode := Value;
end;

function DivToBR(s: string): string;
var
  res: string;
  vp: integer;
begin
  res := '';

  while pos('</div>',s) > 0 do
  begin
    vp := pos('<div',s);
    res := res + copy(s,1,vp - 1) + '<BR>';
    delete(s,1,vp + 4);
    vp := pos('>',s);
    delete(s,1,vp);
    vp := pos('</div>',s);
    res := res + '<font size="7">'+ copy(s,1,vp - 1) + '</font>';
    delete(s,1,vp + 5);
  end;

  Result := res + s;
end;

{$IFDEF DELPHIXE_LVL}
procedure TStep.FromJSON(jo: TJSONObject);
var
  ffo: TJSONObject;
  jp: TJSONPair;
  TextTravelMode: string;
begin
  FInstructions := UTF8ToString(RawByteString(GetJSONProp(jo,'html_instructions')));

  FInstructions := DivToBR(FInstructions);
//  if pos('</div',FInstructions) > 0 then
//    outputdebugstring(pchar(FInstructions));

  TextTravelMode := GetJSONProp(jo,'travel_mode');
  if TextTravelMode = 'DRIVING' then
    FTravelMode := tmDriving
  else if TextTravelMode = 'WALKING' then
    FTravelMode := tmWalking
  else if TextTravelMode = 'BICYLCLING' then
    FTravelMode := tmBicycling;
//  else if TextTravelMode = 'TRANSIT' then
//    FTravelMode := tmTransit;

  jp := jo.Get('distance');
  if Assigned(jp) then
  begin
    ffo := GetJSONValue(jo,'distance') as TJSONObject;
    jp := ffo.Get('value');
    if Assigned(jp) then
      FDistance := StrToInt(GetJSONProp(ffo,'value'));
    jp := ffo.Get('text');
    if Assigned(jp) then
      FDistanceText := GetJSONProp(ffo,'text');
  end;

  jp := jo.Get('duration');
  if Assigned(jp) then
  begin
    ffo := GetJSONValue(jo,'duration') as TJSONObject;
    jp := ffo.Get('value');
    if Assigned(jp) then
      FDuration := StrToInt(GetJSONProp(ffo,'value'));
    jp := ffo.Get('text');
    if Assigned(jp) then
      FDurationText := GetJSONProp(ffo,'text');
  end;

  jp := Jo.Get('end_location');
  if Assigned(jp) then
  begin
    ffo := GetJSONValue(jo,'end_location') as TJSONObject;
    jp := ffo.Get('lat');
    if Assigned(jp) then
      FEndLocation.Latitude := StrToFloat(GetJSONProp(ffo,'lat'));
    jp := ffo.Get('lng');
    if Assigned(jp) then
      FEndLocation.Longitude := StrToFloat(GetJSONProp(ffo,'lng'));
  end;

  jp := jo.Get('start_location');
  if Assigned(jp) then
  begin
    ffo := GetJSONValue(jo,'start_location') as TJSONObject;
    jp := ffo.Get('lat');
    if Assigned(jp) then
      FStartLocation.Latitude := StrToFloat(GetJSONProp(ffo,'lat'));
    jp := ffo.Get('lng');
    if Assigned(jp) then
      FStartLocation.Longitude := StrToFloat(GetJSONProp(ffo,'lng'));
  end;

  jp := jo.Get('polyline');
  if Assigned(jp) then
  begin
    ffo := GetJSONValue(jo,'polyline') as TJSONObject;
    jp := ffo.Get('points');
    if Assigned(jp) then
    begin
      Polyline.Path.Clear;
      Polyline.DecodeValues(GetJSONProp(ffo,'points'));
    end;
  end;
end;
{$ENDIF}

{ TSteps }

function TSteps.Add: TStep;
begin
  Result := TStep(inherited Add);
end;

constructor TSteps.Create(ALeg: TLeg);
begin
  inherited Create(TStep);
  FLeg := ALeg;
end;

function TSteps.GetItem(Index: integer): TStep;
begin
  Result := TStep(inherited GetItem(Index));
end;

function TSteps.GetOwner: TPersistent;
begin
  Result := FLeg;
end;

procedure TSteps.Notify(Item: TCollectionItem; Action: TCollectionNotification);
begin
  inherited;
end;

procedure TSteps.SetItem(Index: integer; Value: TStep);
begin
  inherited SetItem(Index, Value);
end;

procedure TSteps.Update(Item: TCollectionItem);
begin
  inherited;
end;

end.
