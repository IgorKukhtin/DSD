{***************************************************************************)
{ TMS FMX WebGMaps component                                                    }
{ for Delphi & C++Builder                                                   }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2012 - 2015                                        }
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

unit FMX.TMSWebGMapsClusters;

interface

{$I TMSDEFS.INC}

uses
  Classes, FMX.Graphics, FMX.Controls, FMX.TMSWebGMapsConst, SysUtils, FMX.TMSWebGMapsCommon, FMX.TMSWebGMapsCommonFunctions, FMX.TMSWebGMapsPolylines
  {$IFDEF FMXLIB}
  ,UITypes, UIConsts
  {$ENDIF}
  ;

type
  TClusters = class;
  TMapCluster = class;
  TClusterStyles = class;

  TClusterStyle = class(TCollectionItem)
  private
    FTag: integer;
    FIconOffsetY: integer;
    FTextOffsetX: integer;
    FTextOffsetY: integer;
    FIconURL: string;
    FIconHeight: integer;
    FFont: TFont;
    {$IFDEF FMXLIB}
    FFontColor: TAlphaColor;
    {$ENDIF}
    FIconWidth: integer;
    FBackgroundPositionX: integer;
    FBackgroundPositionY: integer;
    FIconOffsetX: integer;
    procedure SetBackgroundPositionX(const Value: integer);
    procedure SetBackgroundPositionY(const Value: integer);
    procedure SetFont(const Value: TFont);
    {$IFDEF FMXLIB}
    procedure SetFontColor(const Value: TAlphaColor);
    {$ENDIF}
    procedure SetIconHeight(const Value: integer);
    procedure SetIconOffsetX(const Value: integer);
    procedure SetIconOffsetY(const Value: integer);
    procedure SetIconURL(const Value: string);
    procedure SetIconWidth(const Value: integer);
    procedure SetTag(const Value: integer);
    procedure SetTextOffsetX(const Value: integer);
    procedure SetTextOffsetY(const Value: integer);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property IconOffsetX: integer read FIconOffsetX write SetIconOffsetX default 0;
    property IconOffsetY: integer read FIconOffsetY write SetIconOffsetY default 0;
    property TextOffsetX: integer read FTextOffsetX write SetTextOffsetX default 0;
    property TextOffsetY: integer read FTextOffsetY write SetTextOffsetY default 0;
    property BackgroundPositionX: integer read FBackgroundPositionX write SetBackgroundPositionX default 0;
    property BackgroundPositionY: integer read FBackgroundPositionY write SetBackgroundPositionY default 0;
    property Font: TFont read FFont write SetFont;
    {$IFDEF FMXLIB}
    property FontColor: TAlphaColor read FFontColor write SetFontColor;
    {$ENDIF}
    property IconHeight: integer read FIconHeight write SetIconHeight default 32;
    property IconWidth: integer read FIconWidth write SetIconWidth default 32;
    property IconURL: string read FIconURL write SetIconURL;
    property Tag: integer read FTag write SetTag default 0;
  end;

  TClusterStyles = class(TOwnedCollection)
  private
    FOwner : TMapCluster;
    function GetItem(Index : integer) : TClusterStyle;
    procedure SetItem(Index : integer; Value : TClusterStyle);
  protected
    function GetOwner : TPersistent; override;
    procedure Update(Item : TCollectionItem); override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(AOwner: TMapCluster);
    function Add: TClusterStyle; overload;
    property Items[index : integer] : TClusterStyle read GetItem write SetItem; default;
  end;

  TMapCluster = class(TPersistent)
  private
    FItemIndex: integer;
    FTag: integer;
    FOwner: TPersistent;
    FIgnoreHidden: Boolean;
    FGridSize: integer;
    FAverageCenter: boolean;
    FClusterClass: string;
    FBatchSize: integer;
    FTitle: string;
    FMinimumClusterSize: integer;
    FZoomOnClick: boolean;
    FMaxZoom: integer;
    FCalculator: TStringList;
    FStyles: TClusterStyles;
    procedure SetTag(const Value: integer);
    procedure SetAverageCenter(const Value: boolean);
    procedure SetBatchSize(const Value: integer);
    procedure SetClusterClass(const Value: string);
    procedure SetGridSize(const Value: integer);
    procedure SetIgnorHidden(const Value: Boolean);
    procedure SetMaxZoom(const Value: integer);
    procedure SetTitle(const Value: string);
    procedure SetZoomOnClick(const Value: boolean);
    procedure SetMinimumClusterSize(const Value: integer);
    procedure SetCalculator(const Value: TStringList);
    procedure SetStyles(const Value: TClusterStyles);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent);
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
    property ItemIndex: integer read FItemIndex;
    function FitMapToMarkers(): boolean;
  published
    property AverageCenter: boolean read FAverageCenter write SetAverageCenter default true;
    property BatchSize: integer read FBatchSize write SetBatchSize default 0;
    property Calculator: TStringList read FCalculator write SetCalculator;
    property ClusterClass: string read FClusterClass write SetClusterClass;
    property GridSize: integer read FGridSize write SetGridSize;
    property IgnoreHidden: Boolean read FIgnoreHidden write SetIgnorHidden default false;
    property MaxZoom: integer read FMaxZoom write SetMaxZoom default -1;
    property MinimumClusterSize: integer read FMinimumClusterSize write SetMinimumClusterSize default 2;
    property Styles: TClusterStyles read FStyles write SetStyles;
    property Title: string read FTitle write SetTitle;
    property ZoomOnClick: boolean read FZoomOnClick write SetZoomOnClick default true;
    property Tag: integer read FTag write SetTag default 0;
  end;

  TClusterItem = class(TCollectionItem)
  private
    FWebGMaps: TControl;
    FCluster: TMapCluster;
    procedure SetCluster(const Value: TMapCluster);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Cluster: TMapCluster read FCluster write SetCluster;
  end;

  TClusters = class(TOwnedCollection)
  private
    FWebGMaps : TControl;
    function GetItem(Index : integer) : TClusterItem;
    procedure SetItem(Index : integer; Value : TClusterItem);
  protected
    function GetOwner : TPersistent; override;
    procedure Update(Item : TCollectionItem); override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(AWebGMaps : TControl);
    function Add: TClusterItem; overload;
    property Items[index : integer] : TClusterItem read GetItem write SetItem; default;
  end;

implementation

uses
  FMX.TMSWebGMaps;

{ TMapCluster }

procedure TMapCluster.Assign(Source: TPersistent);
var
  FSource : TMapCluster;
begin
  if (Source is TMapCluster) then
  begin
    FSource := TMapCluster(Source);
    FItemIndex := FSource.FItemIndex;
    FAverageCenter := FSource.FAverageCenter;
    FBatchSize := FSource.FBatchSize;
    FCalculator := FSource.FCalculator;
    FClusterClass := FSource.Clusterclass;
    FGridSize := FSource.FGridSize;
    FIgnoreHidden := FSource.FIgnoreHidden;
    FMaxZoom := FSource.FMaxZoom;
    FMinimumClusterSize := FSource.FMinimumClusterSize;
    FStyles.Assign(FSource.FStyles);
    FTitle := FSource.FTitle;
    FZoomOnClick := FSource.FZoomOnClick;
    FTag := FSource.FTag;
  end;
end;

constructor TMapCluster.Create(AOwner: TPersistent);
begin
  FOwner := AOwner;
  TClusterCount := TClusterCount + 1;
  FItemIndex := TClusterCount;
  FAverageCenter := true;
  FBatchSize := 0;
  FCalculator := TStringList.Create;
  FClusterClass := 'cluster';
  FGridSize := 60;
  FIgnoreHidden := false;
  FMaxZoom := -1;
  FMinimumClusterSize := 2;
  FStyles := TClusterStyles.Create(Self);
  FTitle := '';
  FZoomOnClick := true;
  FTag := 0;
end;

destructor TMapCluster.Destroy;
begin
  FCalculator.Free;
  FStyles.Free;
  inherited;
end;

function TMapCluster.FitMapToMarkers: boolean;
begin
  if FOwner is TClusters then
    Result := ((FOwner as TClusters).FWebGmaps as TTMSFMXWebGMaps).ExecJScript('if ('+inttostr(ItemIndex - 1)+'<allclusters.length) allclusters['+inttostr(ItemIndex-1)+'].fitMapToMarkers();')
  else
    Result := false;
end;

function TMapCluster.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TMapCluster.SetAverageCenter(const Value: boolean);
begin
  FAverageCenter := Value;
end;

procedure TMapCluster.SetBatchSize(const Value: integer);
begin
  FBatchSize := Value;
end;

procedure TMapCluster.SetCalculator(const Value: TStringList);
begin
  FCalculator.Assign(Value);
end;

procedure TMapCluster.SetClusterClass(const Value: string);
begin
  FClusterClass := Value;
end;

procedure TMapCluster.SetGridSize(const Value: integer);
begin
  FGridSize := Value;
end;

procedure TMapCluster.SetIgnorHidden(const Value: Boolean);
begin
  FIgnoreHidden := Value;
end;

procedure TMapCluster.SetMaxZoom(const Value: integer);
begin
  FMaxZoom := Value;
end;

procedure TMapCluster.SetMinimumClusterSize(const Value: integer);
begin
  FMinimumClusterSize := Value;
end;

procedure TMapCluster.SetStyles(const Value: TClusterStyles);
begin
  FStyles.Assign(Value);
end;

procedure TMapCluster.SetTag(const Value: integer);
begin
  FTag := Value;
end;

procedure TMapCluster.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TMapCluster.SetZoomOnClick(const Value: boolean);
begin
  FZoomOnClick := Value;
end;

{ TClusterItem }

procedure TClusterItem.Assign(Source: TPersistent);
begin
  if (Source is TClusterItem) then
  begin
    FCluster.Assign(Source as TClusterItem);
  end;
end;

constructor TClusterItem.Create(Collection: TCollection);
begin
  inherited;
  FWebGMaps := TClusters(Collection).FWebGMaps;
  FCluster := TMapCluster.Create(Collection);
end;

destructor TClusterItem.Destroy;
begin
  FCluster.Free;
  inherited;
end;

procedure TClusterItem.SetCluster(const Value: TMapCluster);
begin
  FCluster := Value;
end;

{ TClusters }

function TClusters.Add: TClusterItem;
begin
  Result := TClusterItem(inherited Add);
end;

constructor TClusters.Create(AWebGMaps : TControl);
begin
  inherited Create(AWebGMaps, TClusterItem);
  FWebGMaps := AWebGMaps;
end;

function TClusters.GetItem(Index: integer): TClusterItem;
begin
  Result := TClusterItem(inherited GetItem(Index));
end;

procedure TClusters.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
end;

function TClusters.GetOwner: TPersistent;
begin
  Result := FWebGMaps;
end;

procedure TClusters.SetItem(Index: integer; Value: TClusterItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TClusters.Update(Item: TCollectionItem);
begin
  inherited;
end;

{ TClusterStyle }

procedure TClusterStyle.Assign(Source: TPersistent);
var
  FSource : TClusterStyle;
begin
  if (Source is TClusterStyle) then
  begin
    FSource := TClusterStyle(Source);
    FIconOffsetX := FSource.FIconOffsetX;
    FIconOffsetY := FSource.FIconOffsetY;
    FIconHeight := FSource.FIconHeight;
    FIconWidth := FSource.FIconWidth;
    FIconURL := FSource.FIconURL;
    FTextOffsetX := FSource.FTextOffsetX;
    FTextOffsetY := FSource.FTextOffsetY;
    FBackgroundPositionX := FSource.FBackgroundPositionX;
    FBackgroundPositionY := FSource.FBackgroundPositionY;
    FFont := TFont.Create;
  end;
end;

constructor TClusterStyle.Create(Collection: TCollection);
begin
  inherited;
  FIconOffsetX := 0;
  FIconOffsetY := 0;
  FIconHeight := 32;
  FIconWidth := 32;
  FIconURL := '';
  FTextOffsetX := 0;
  FTextOffsetY := 0;
  FBackgroundPositionX := 0;
  FBackgroundPositionY := 0;
  FFont := TFont.Create;
  FFont.Size := 11;
  FFont.Family := 'Arial,sans-serif';
  FFont.Style := [TFontStyle.fsBold];
  FFontColor := claBlack;
end;

destructor TClusterStyle.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TClusterStyle.SetBackgroundPositionX(const Value: integer);
begin
  FBackgroundPositionX := Value;
end;

procedure TClusterStyle.SetBackgroundPositionY(const Value: integer);
begin
  FBackgroundPositionY := Value;
end;

procedure TClusterStyle.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

{$IFDEF FMXLIB}
procedure TClusterStyle.SetFontColor(const Value: TAlphaColor);
begin
  FFontColor := Value;
end;
{$ENDIF}

procedure TClusterStyle.SetIconHeight(const Value: integer);
begin
  FIconHeight := Value;
end;

procedure TClusterStyle.SetIconOffsetX(const Value: integer);
begin
  FIconOffsetX := Value;
end;

procedure TClusterStyle.SetIconOffsetY(const Value: integer);
begin
  FIconOffsetY := Value;
end;

procedure TClusterStyle.SetIconURL(const Value: string);
begin
  FIconURL := Value;
end;

procedure TClusterStyle.SetIconWidth(const Value: integer);
begin
  FIconWidth := Value;
end;

procedure TClusterStyle.SetTag(const Value: integer);
begin
  FTag := Value;
end;

procedure TClusterStyle.SetTextOffsetX(const Value: integer);
begin
  FTextOffsetX := Value;
end;

procedure TClusterStyle.SetTextOffsetY(const Value: integer);
begin
  FTextOffsetY := Value;
end;

{ TClusterStyles }

function TClusterStyles.Add: TClusterStyle;
begin
  Result := TClusterStyle(inherited Add);
end;

constructor TClusterStyles.Create(AOwner: TMapCluster);
begin
  inherited Create(AOwner, TClusterStyle);
  FOwner := AOwner;
end;

function TClusterStyles.GetItem(Index: integer): TClusterStyle;
begin
  Result := TClusterStyle(inherited GetItem(Index));
end;

function TClusterStyles.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TClusterStyles.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
end;

procedure TClusterStyles.SetItem(Index: integer; Value: TClusterStyle);
begin
  inherited SetItem(Index, Value);
end;

procedure TClusterStyles.Update(Item: TCollectionItem);
begin
  inherited;
end;

end.
