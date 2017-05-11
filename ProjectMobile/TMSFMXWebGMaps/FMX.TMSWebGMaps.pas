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

unit FMX.TMSWebGMaps;

interface

{$I TMSDEFS.INC}

uses
  {$IFNDEF FMXLIB}
  Windows, Messages, OleCtrls, SHDocVw, ActiveX,
  Forms, mshtml, ExtCtrls, GIFImg, Dialogs, variants,
  jpeg, FMX.TMSWebGMapsIdoc, FMX.TMSWebGMapsAutomation, IniFiles, Registry,
  {$IFDEF DELPHIXE7_LVL}
  IdHMACSHA1, IdGlobal, System.NetEncoding,
  {$ENDIF}
  {$IFDEF DELPHIXE_LVL}
  FMX.TMSWebGMapsExif,
  {$ENDIF}
  {$IFDEF DELPHI_UNICODE}
  PNGImage,
  {$ENDIF}
  {$ENDIF}
  {$IFDEF FMXLIB}
  UIConsts,
  {$IFDEF MACOS}
  MacApi.CoreFoundation,
  {$IFDEF IOS}
  iOSApi.Foundation,
  {$ELSE}
  MacApi.Foundation,
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  SysUtils, TypInfo, Classes, FMX.Graphics, Types, FMX.Controls, StrUtils, FMX.TMSWebGMapsWebBrowser,
  FMX.TMSWebGMapsCommon, FMX.TMSWebGMapsControls, FMX.TMSWebGMapsMarkers,
  FMX.TMSWebGMapsConst, FMX.TMSWebGMapsCommonFunctions, FMX.TMSWebGMapsPolylines,
  FMX.TMSWebGMapsPolygons, FMX.TMSWebGMapsClusters, FMX.TMSWebGMapsDirections
  {$IFDEF DELPHIXE3_LVL}
  , System.UITypes
  {$ENDIF}
  {$IFDEF DELPHIXE_LVL}
  {$IFDEF DELPHIXE6_LVL}
  , JSON
  {$ELSE}
  , DBXJSON
  {$ENDIF}
  {$ENDIF}
  ;


const
  MAJ_VER = 2; // Major version nr.
  MIN_VER = 7; // Minor version nr.
  REL_VER = 1; // Release nr.
  BLD_VER = 1; // Build nr.

  // version history
  // v1.0.0.0 : First release
  // v1.0.1.0 : Fixed : Issue with encoding for URLs for geocoding
  // v1.0.2.0 : Fixed : Issue with compiling with C++
  //          : Improved : optimized default properties
  // v1.1.0.0 : New : Option to show weather indication on map
  //          : New : Option to show clouds layer on map
  //          : Fixed : Issue on Delphi 2007
  // v1.5.0.0 : New : Show polylines on map
  //          : New : Show polygons on map
  //          : New : Show custom labels with Markers on map
  //          : New : Directions support
  //          : New : Show directions on map
  // v1.5.0.1 : Fixed : Issues with use of TWebGMaps in C++Builder
  // v1.5.1.0 : Improved : Streetview rendering
  //          : Improved : Handling of WebGMaps launch when control is not visible
  // v1.5.1.1 : Fixed : Issue with UTF8 encoding used in TWebGMapsGeoLocation in older Delphi versions
  // v1.5.2.0 : New : Data property added at Marker level
  // v1.6.0.0 : New : TWebGMapsReverseGeocoding component
  // v1.6.0.1 : Fixed : Issue with UTF8 encoding used in TWebGMapsGeoLocation in Delphi 2007
  // v1.6.1.0 : New : RemoveDirections function
  // v1.6.2.0 : New : function DegreesToLonLat() added
  // v1.6.2.1 : Fixed : Issue with use from C++Builder 2007,2009
  // v1.7.0.0 : New : Support for Delphi XE4 & C++Builder XE4
  // v1.8.0.0 : New : Directions extended with WayPoints, avoid Tolls/Highways
  // v1.8.1.0 : New : Public property APIKey
  //            Improved : Polygons and Polylines are automatically displayed when added via the Object Inspector
  //            Fixed : Issue with updating Polylines that have identical ZIndex values
  //            Fixed : Issue with programmatically adding multiple Polylines
  //            Fixed : Issue with deleting Markers
  // v1.8.2.0 : New : Function Distance() added
  //            New : Procedure GetDirections() overload to use coordinates instead of string values as origin/destination
  //            New : OnStreetViewChange() event
  // v1.8.2.1 : Improved : StreetView mode displayed immediately on launch if required 
  //            Improved : Code optimizations
  //            Fixed : Possible incorrect values returned by OnStreetViewChange Heading parameter
  // v1.9.0.0 : New : Support for Delphi XE5 & C++Builder XE5 added
  // v1.9.1.0 : New : WebGMaps.Markers.Bounds to retrieve outer bounds of markers
  //          : New : WebGMaps.PolyLines.Bounds to retrieve outer bounds of all poly lines
  //          : New : WebGMaps.PolyLines[].Paths[].PathBounds to retrieve outer bounds of a single polyline
  //          : New : WebGMaps.Polygon.Bounds to retrieve outer bounds of all polygons
  //          : New : WebGMaps.Polygon[].Paths[].PathBounds to retrieve outer bounds of a single polygon
  // v1.9.1.1 : Fixed : Issue with releasing memory for runtime created TWebGMaps instance
  // v1.9.2.0 : New : Public method Flush() added for forcing memory release of internal WebBrowser
  // v1.9.3.0 : New : RenderDirections overload added with long/lat parameters
  // v1.9.3.1 : Fixed : Issue with updating controls style
  // v1.9.4.0 : New : ProxyServer and ProxyPort properties in TWebGMapsGeocoding & TWebGMapsReverseGeocoding
  // v1.9.4.1 : Improved : In OpenMarkerInfoWindowHTML double quotes are now accepted
  // v1.9.4.2 : Fixed : Issue with using special characters in the Origin, Destination, Waypoints parameters of the GetDirections procedure
  // v1.9.5.0 : New : Support for Delphi XE6 & C++Builder XE6 added
  // v1.9.6.0 : New : KML Layer support: AddMapKMLLayer, DeleteMapKMLLayer, DeleteMapAllKMLLayer functions and OnKMLLayerClick event added
  // v1.9.6.1 : Fixed : Issue with header files in C++
  // v1.9.7.0 : New : MapOptions.DisablePOI to disable the display of points of interest icons on the map
  // v1.9.8.0 : New : Support for Delphi XE7 & C++Builder XE7 added
  //            Fixed : Issue with OnStreetViewChange event
  // v1.9.8.1 : Fixed : Issue in Component Package for C++Builder
  // v2.0.0.0 : New : TWebGMapsTimeZone component
  //            New : Function GetCurrentLocation and property CurrentLocation
  //            New : Property MapOptions.DefaultToCurrentLocation
  // v2.0.0.1 : Fixed : Issue with C++Bulder installation
  // v2.0.1.0 : New : Support for Delphi XE8 & C++Builder XE8 added
  // v2.1.0.0 : New : Support for marker clusters added
  //            New : Event added OnInitHTML
  //            New : Function GetElevation and property Elevations
  //            New : Support for Google Maps for Work with new public properties APIClientID and APISignature
  //            New : The GetDirections call will use the APIKey value when available
  //            Improved : Refresh with F5 key is now disabled
  //            Improved : Assign procedure
  //            Fixed : Blank map after using ALT or arrow keys
  // v2.2.0.0 : New : LoadGPSRoute() function added to load routes from GPX files
  //            New : WayPointIndex property for each Leg of a Direction
  //            Fixed : Issue with adding a Marker Label immediately after the map has finished loading
  // v2.3.0.0 : New : GetModifiedMapPolygon function to retrieve modified polygon coordinates
  //            New : GetModifiedMapPolyline function to retrieve modified polyline coordinates
  //            New : XYToLonLat function to convert XY to LonLat coordinates
  //            New : LonLatToXY function to convert LonLat to XY coordinates
  //            New : OnPolygonChanged event
  //            New : OnPolylineChanged event
  //            Fixed : Issue with Polygon.ItemIndex when using DeleteMapPolygon
  // v2.3.0.1 : Fixed : Issue with C++ include files
  // v2.3.0.2 : Fixed : Issue with TMarkers.Bounds
  //            Fixed : Issue with retrieving the Directions Instructions text
  // v2.4.0.0 : New : RAD Studio Berlin Support
  // v2.4.0.1 : Fixed : Issue with latitude and longitude conversion on iOS / Android
  //            Fixed : Issue with GetDirections call in Delphi XE5 or prior
  // v2.4.0.2 : Fixed : Issue with OnMapDblClick event
  //            Fixed : Issue with executing javascript on a nil referenced webbrowser instance in Android
  //            Fixed : Issues with marker clusters due to changes in the Google API
  // v2.5.0.0 : New : AddGeoImage method for Delphi XE and up
  //            New : MapOptions.ZoomMarker property
  //            New : IconColor, IconState properties for Markers
  //            New : IconWidth, IconZoomWidth, IconHeight, IconZoomHeight properties for Markers
  //            New : Events OnMarkerZoomIn, OnMarkerZoomOut added
  //            Fixed : Issue with OnPolygonChanged event after updating a polygon
  //            Fixed : Issue with OnPolylineChanged event after updating a polyline
  //            Fixed : Issue with OnMapDblClick event parameters
  // v2.5.0.1 : Fixed : Installation issue
  // v2.5.0.2 : Fixed : Issue with IconColor property default value
  // v2.5.0.3 : Improved : Return value of ExecJScript in FMX
  // v2.5.5.0 : New : LoadMarkersFromPOI method added
  //            New : OnMapTilesLoad event added
  //            New : APIChannel property added
  //            Fixed: Issue with APISignature
  // v2.6.0.0 : New : FMX.TMSWebGMapsDialog component
  //            New : Design-time markers editor
  //            New : SaveMarkersToPOI method added
  //            New : SaveMapBounds, LoadMapBounds methods added
  //            New : Markers.Text property added
  //            New : MapOptions.DisableTilt property added
  //            New : ControlsOptions.RotateControl property added
  //            New : Markers[].MapLabel.OffsetLeft/OffsetTop properties added
  //            New : Added support to update the Markers[].MapLabel settings on the map
  //            New : RenderDirections parameter added: RouteColor
  //            Improved : Google Maps Premium compatibility
  //            Fixed : Issue with Android class memory limitation
  // v2.6.1.0 : New : APIClientSecret property in VCL
  //            New : APIClientAuthURL property
  //            New : Support to generate an API Signature based on APIClientID and APIClientSecret in VCL
  //            Improved : Timeout handler for browser initialization to prevent hanging app
  //            Fixed : Possible issue with the default browser location in VCL
  //            Fixed : Issue with installation through subscription manager
  //            Fixed : Issue with executing javascript on Android
  //            Fixed : Handling Google API key setting via URL
  // v2.7.0.0 : New : Routing property added
  //            New : OnRoutingWaypointAdded event added
  //            New : SavePathToGPSRoute method added
  //            New : Overload Path.Add(Location: TLocation) added
  //            New : Method FillRouteList() added
  //            New : Parameter ZoomToRoute added in LoadGPSRoute() method
  //            New : AutoLaunch property (VCL only)
  //            Fixed : Map events compatibility in iOS 10 (FMX only)
  // v2.7.1.0 : New : Published property APIKey
  //            New : Public property ShowDebugConsole
  //            New : OnAfterRoutingWaypointAdded event added
  //            Fixed : Issue with assigning APIKey property on Android (FMX only)
  //            Fixed : Issue with switching focus to other controls on Android (FMX only)
  // v2.7.1.1 : Fixed : Issue with hiding the Debug Console


type
  TWebGMapsErrorEvent = procedure(Sender: TObject; ErrorType:TErrorType) of object;
  TMapTypeChange = procedure(Sender: TObject; NewMapType:TMapType) of object;
  TInitHTMLEvent = procedure(Sender: TObject; var HTML: string) of object;
  TRoutingWaypointAdded = procedure(Sender: TObject; Latitude, Longitude: Double; Route: TPath; var Allow: boolean) of object;
  TAfterRoutingWaypointAdded = procedure(Sender: TObject; Latitude, Longitude: Double; Route: TPath) of object;

  {$IFDEF FMXLIB}
  TEventMarker           = procedure(Sender: TObject; MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double) of object;
  TEventMarkerClick      = procedure(Sender: TObject; MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double) of object;
  TEventMarkerZoom       = procedure(Sender: TObject; IdMarker:Integer; var Allow: Boolean) of object;
  TEventKMLLayer         = procedure(Sender: TObject; ObjectName:String; IdLayer:Integer; Latitude,Longitude:Double) of object;
  TEventPolyline         = procedure(Sender: TObject; IdPolyline:Integer) of object;
  TEventPolylineClick    = procedure(Sender: TObject; IdPolyline:Integer) of object;
  TEventPolygon          = procedure(Sender: TObject; IdPolygon:Integer) of object;
  TEventPolygonClick     = procedure(Sender: TObject; IdPolygon:Integer) of object;
  TEventCluster          = procedure(Sender: TObject; IdCluster:Integer; MarkerCount: integer; Latitude, Longitude: Double) of object;
  TEventBounds           = procedure(Sender: TObject; Bounds: FMX.TMSWebGMapsCommonFunctions.TBounds) of object;
  TEventInfoWindow       = procedure(Sender: TObject; IdMarker:Integer) of object;
  TPositionMap           = procedure(Sender: TObject; Latitude,Longitude:Double;X,Y:Integer) of object;
  TPositionMouseMap      = procedure(Sender: TObject; Latitude,Longitude:Double;X,Y:Integer) of object;
  TMapZoomChange         = procedure(Sender: TObject; NewLevel:Integer) of object;
  TExternalMapTypeChange = procedure(Sender: TObject; NewMapType:Integer) of object;
  TStreetViewChange      = procedure(Sender: TObject; Heading,Pitch,Zoom:Integer) of object;
  {$ENDIF}

  TTMSFMXWebGMaps = class;
  TElevations = class;

  {$IFNDEF FMXLIB}
  THTMLProcEvent = procedure(Sender: TObject; Event: IHTMLEventObj) of object;

  THTMLEventLink = class(TInterfacedObject, IDispatch)
  private
    FOnEvent: THTMLProcEvent;
  private
    constructor Create(Handler: THTMLProcEvent);
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  public
    destructor Destroy; override;
    property OnEvent: THTMLProcEvent read FOnEvent write FOnEvent;
  end;
  {$ENDIF}

  TStreetViewOptions = class(TPersistent)
  private
    FDefaultLongitude: Double;
    FPitch: TPitchStreetView;
    FDefaultLatitude: Double;
    FHeading: THeadingStreetView;
    FZoom: TZoomStreetView;
    FWebGmaps: TTMSFMXWebGMaps;
    FVisible: Boolean;
    procedure InitStreetView;
    procedure SetDefaultLatitude(const Value: Double);
    procedure SetDefaultLongitude(const Value: Double);
    procedure SetHeading(const Value: THeadingStreetView);
    procedure SetPitch(const Value: TPitchStreetView);
    procedure SetZoom(const Value: TZoomStreetView);
    procedure SetVisible(const Value: Boolean);
  protected
  public
    constructor Create(AWebGmaps: TTMSFMXWebGMaps);
    procedure Assign(Source: TPersistent); override;
  published
    property DefaultLatitude : Double read FDefaultLatitude write SetDefaultLatitude;
    property DefaultLongitude : Double read FDefaultLongitude write SetDefaultLongitude;
    property Heading : THeadingStreetView read FHeading write SetHeading default 0;
    property Pitch : TPitchStreetView read FPitch write SetPitch default 0;
    property Zoom : TZoomStreetView read FZoom write SetZoom default 0;
    property Visible : Boolean read FVisible write SetVisible default false;
  end;

  TMapOptions = class(TPersistent)
  private
    FDraggable: Boolean;
    FDefaultLongitude: Double;
    FDisableDoubleClickZoom: Boolean;
    {$IFNDEF FMXLIB}
    FPreloaderVisible: Boolean;
    {$ENDIF}
    FDefaultLatitude: Double;
    FZoomMap: TZoomMap;
    FMapType: TMapType;
    FWebGmaps: TTMSFMXWebGMaps;
    FEnableKeyboard: Boolean;
    FScrollWheel: Boolean;
    FDisableControls: Boolean;
    FShowTraffic: Boolean;
    FLanguage: TLanguageName;
    FShowBicycling: Boolean;
    FShowPanoramio: Boolean;
    FShowCloud: Boolean;
    FShowWeather: Boolean;
    FDisablePOI: Boolean;
    FZoomMarker: TZoomMarker;
    FDisableTilt: Boolean;
    {$IFDEF DELPHIXE_LVL}
    FDefaultToCurrentLocation: Boolean;
    {$ENDIF}
    procedure SetDraggable(const Value: Boolean);
    procedure SetDefaultLatitude(const Value: Double);
    procedure SetDefaultLongitude(const Value: Double);
    procedure SetDisableDoubleClickZoom(const Value: Boolean);
    procedure SetMapType(const Value: TMapType);
    {$IFNDEF FMXLIB}
    procedure SetPreloaderVisible(const Value: Boolean);
    {$ENDIF}
    procedure SetZoomMap(const Value: TZoomMap);
    procedure SetEnableKeyboard(const Value: Boolean);
    procedure SetScrollWheel(const Value: Boolean);
    procedure SetDisableControls(const Value: Boolean);
    procedure SetShowTraffic(const Value: Boolean);
    procedure SetLanguage(const Value: TLanguageName);
    procedure SetShowBicycling(const Value: Boolean);
    procedure SetShowPanoramio(const Value: Boolean);
    procedure SetShowCloud(const Value: Boolean);
    procedure SetShowWeather(const Value: Boolean);
    procedure SetDisablePOI(const Value: Boolean);
    procedure SetZoomMarker(const Value: TZoomMarker);
    procedure SetDisableTilt(const Value: Boolean);
    {$IFDEF DELPHIXE_LVL}
    procedure SetDefaultToCurrentLocation(const Value: Boolean);
    {$ENDIF}
  protected
  public
    constructor Create(AWebGmaps: TTMSFMXWebGMaps);
    procedure Assign(Source: TPersistent); override;
  published
    property Language : TLanguageName read FLanguage write SetLanguage default lnDefault;
    property Draggable : Boolean read FDraggable write SetDraggable default true;
    property ZoomMap : TZoomMap read FZoomMap write SetZoomMap default DEFAULT_ZOOM;
    property ZoomMarker : TZoomMarker read FZoomMarker write SetZoomMarker default zmNone;
    property MapType : TMapType read FMapType write SetMapType default mtDefault;
    property DefaultLatitude : Double read FDefaultLatitude write SetDefaultLatitude;
    property DefaultLongitude : Double read FDefaultLongitude write SetDefaultLongitude;
    {$IFDEF DELPHIXE_LVL}
    property DefaultToCurrentLocation: Boolean read FDefaultToCurrentLocation write SetDefaultToCurrentLocation default false;
    {$ENDIF}
    {$IFNDEF FMXLIB}
    property PreloaderVisible : Boolean read FPreloaderVisible write SetPreloaderVisible default false;
    {$ENDIF}
    property DisableDoubleClickZoom : Boolean read FDisableDoubleClickZoom write SetDisableDoubleClickZoom default false;
    property EnableKeyboard : Boolean read FEnableKeyboard write SetEnableKeyboard default true;
    property ShowTraffic : Boolean read FShowTraffic write SetShowTraffic default false;
    property ShowBicycling : Boolean read FShowBicycling write SetShowBicycling default false;
    property ShowPanoramio : Boolean read FShowPanoramio write SetShowPanoramio default false;
    property ShowCloud : Boolean read FShowCloud write SetShowCloud default false;
    property ShowWeather : Boolean read FShowWeather write SetShowWeather default false;
    property ScrollWheel : Boolean read FScrollWheel write SetScrollWheel default true;
    property DisableControls : Boolean read FDisableControls write SetDisableControls default false;
    property DisablePOI : Boolean read FDisablePOI write SetDisablePOI default false;
    property DisableTilt : Boolean read FDisableTilt write SetDisableTilt default false;
  end;

  TWeatherOptions = class(TPersistent)
  private
    FWindSpeedUnit: TWeatherWindSpeed;
    FShowInfoWindows: Boolean;
    FLabelColor: TWeatherLabelColor;
    FTemperatureUnit: TWeatherTemperatures;
    FWebGmaps: TTMSFMXWebGMaps;
    procedure SetLabelColor(const Value: TWeatherLabelColor);
    procedure SetShowInfoWindows(const Value: Boolean);
    procedure SetTemperatureUnit(const Value: TWeatherTemperatures);
    procedure SetWindSpeedUnit(const Value: TWeatherWindSpeed);
  protected
  public
    constructor Create(AWebGmaps: TTMSFMXWebGMaps);
    procedure Assign(Source: TPersistent); override;
  published
    property TemperatureUnit : TWeatherTemperatures read FTemperatureUnit write SetTemperatureUnit default wtCelsius;
    property LabelColor : TWeatherLabelColor read FLabelColor write SetLabelColor default wlcBlack;
    property WindSpeedUnit : TWeatherWindSpeed read FWindSpeedUnit write SetWindSpeedUnit default wwsKilometersPerHour;
    property ShowInfoWindows : Boolean read FShowInfoWindows write SetShowInfoWindows default true;
  end;

  TElevationItem = class(TCollectionItem)
  private
    FWebGMaps : TControl;
    FLatitude: Double;
    FElevation: Double;
    FLongitude: Double;
    FResolution: Double;
    procedure SetElevation(const Value: Double);
    procedure SetLatitude(const Value: Double);
    procedure SetLongitude(const Value: Double);
    procedure SetResolution(const Value: Double);
  protected
  public
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
    {$IFDEF DELPHIXE_LVL}
    procedure FromJSON(jo: TJSONObject);
    {$ENDIF}
  published
    property Elevation: Double read FElevation write SetElevation;
    property Latitude: Double read FLatitude write SetLatitude;
    property Longitude: Double read FLongitude write SetLongitude;
    property Resolution: Double read FResolution write SetResolution;
  end;

  TElevations = class(TCollection)
  private
    FWebGMaps: TControl;
    function GetItem(Index: integer) : TElevationItem;
    procedure SetItem(Index: integer; Value : TElevationItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(AWebGMaps : TControl);
    function Add: TElevationItem; overload;
    property Items[index: integer] : TElevationItem read GetItem write SetItem; default;
  end;

  TRoutingWaypoint = class(TCollectionItem)
  private
    FLocation: TLocation;
    FDistance: integer;
    FAddress: string;
    procedure SetLocation(const Value: TLocation);
  protected
  public
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published
    property Location: TLocation read FLocation write SetLocation;
    property Address: string read FAddress write FAddress;
    property Distance: integer read FDistance write FDistance;
  end;

  TRoutingWaypoints = class(TCollection)
  private
    function GetItem(Index: integer) : TRoutingWaypoint;
    procedure SetItem(Index: integer; Value : TRoutingWaypoint);
  protected
//    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create;
    function Add: TRoutingWaypoint; overload;
    property Items[index: integer] : TRoutingWaypoint read GetItem write SetItem; default;
  end;

  TMapPolylineOptions = class(TPersistent)
  private
    FOpacity: integer;
    FWidth: integer;
    FIcons: TSymbols;
    FColor: TAlphaColor;
    procedure SetColor(const Value: TAlphaColor);
    procedure SetIcons(const Value: TSymbols);
    procedure SetOpacity(const Value: integer);
    procedure SetWidth(const Value: integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Icons : TSymbols read FIcons write SetIcons;
    property Color : TAlphaColor read FColor write SetColor default claBlue;
    property Opacity : integer read FOpacity write SetOpacity default 100;
    property Width : integer read FWidth write SetWidth default 4;
  end;

  TMapRouting = class(TPersistent)
  private
    FWebGMaps: TControl;
    FEnabled: boolean;
    FRoutingMarkers: TRoutingMarkers;
    FRoutingType: TRoutingType;
    FPath: TPath;
    FWayPoints: TPath;
    FMarkerColor: TMarkerIconColor;
    FMarkerIcon: string;
    FPolylineOptions: TMapPolylineOptions;
    FUnits: TUnits;
    procedure SetPath(const Value: TPath);
    procedure SetEnabled(const Value: boolean);
    procedure SetWayPoints(const Value: TPath);
    procedure SetRoutingType(const Value: TRoutingType);
    function GetDistance: integer;
    function GetEndAddress: string;
    function GetStartAddress: string;
    property WayPoints: TPath read FWayPoints write SetWayPoints;
  protected
    FRoutingWaypoints: TRoutingWaypoints;
  public
    constructor Create(AWebGMaps: TControl);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Clear;
    procedure RemoveLastWayPoint;
    property Path: TPath read FPath write SetPath;
    property StartAddress: string read GetStartAddress;
    property EndAddress: string read GetEndAddress;
    property Distance: integer read GetDistance;
    property Units: TUnits read FUnits write FUnits default usMetric;
  published
    property Enabled: boolean read FEnabled write SetEnabled default false;
    property RoutingType: TRoutingType read FRoutingType write SetRoutingType default rtClick;
    property Markers: TRoutingMarkers read FRoutingMarkers write FRoutingMarkers default rmDefault;
    property MarkerColor: TMarkerIconColor read FMarkerColor write FMarkerColor default icRed;
    property MarkerIcon: string read FMarkerIcon write FMarkerIcon;
    property PolylineOptions: TMapPolylineOptions read FPolylineOptions write FPolylineOptions;
  end;

  {$IFDEF FMXLIB}
  TJSEventParameter = record
    parameter: String;
    value: String;
  end;

  TJSEventParameters = array of TJSEventParameter;
  {$ENDIF}

  {$IFNDEF FMXLIB}
  TMapPersistenceLocation = (mplInifile, mplRegistry);

  TMapPersist = class(TPersistent)
  private
    FLocation : TMapPersistenceLocation;
    FKey : string;
    FSection : string;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property Location: TMapPersistenceLocation read FLocation write FLocation;
    property Key: string read FKey write FKey;
    property Section: string read FSection write FSection;
  end;
  {$ENDIF}

  TGPSMetaData = record
    AuthorName: string;
    AuthorLink: string;
    TrackName: string;
    TrackType: string;
  end;

  {$IFNDEF FMXLIB}
  {$IFDEF DELPHIXE2_LVL}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF}
  {$ENDIF}
  {$IFDEF FMXLIB}
  [ComponentPlatformsAttribute(pidWin32 {$IFDEF DELPHIXE8_LVL} or pidWin64 {$ENDIF} or pidiOSSimulator or {$IFDEF DELPHIXE8_LVL}pidiOSDevice32 or pidiOSDevice64{$ELSE}pidiOSDevice{$ENDIF} or pidOSX32 or pidAndroid)]
  {$ENDIF}
  TTMSFMXWebGMaps = class(TTMSFMXWebGMapsWebBrowser)
  private
    {$IFNDEF FMXLIB}
    HTMLDocument2: IHTMLDocument2;
    FOnKeyDownConnector:  THTMLEventLink;
    FWebBrowser: TNewWebBrowser;
    Preloader: TImage;
    FMapPersist: TMapPersist;
    FMapPersisting: boolean;
    {$IFDEF DELPHIXE7_LVL}
    FAPIClientSecret: string;
    {$ENDIF}
    {$ENDIF}
    bLaunchFinish:Boolean;
    {$IFDEF FMXLIB}
    FReinitialize: Boolean;
    FRouting: Boolean;
    FRoutingString: String;
    {$ENDIF}
    FOnWebGMapsError: TWebGMapsErrorEvent;
    CompleteHtmlFile: String;
    FOnDownloadFinish: TNotifyEvent;
    FOnMapTilesLoad: TNotifyEvent;
    FOnDownloadStart: TNotifyEvent;
    FOnMarkerClick: TEventMarkerClick;
    FOnKMLLayerClick: TEventKMLLayer;
    FOnMapClick: TPositionMouseMap;
    FOnMapMouseMove: TPositionMap;
    {$IFNDEF FMXLIB}
    FOnDownloadProgress: TWebBrowserProgressChange;
    {$ENDIF}
    FOnMapMoveStart: TPositionMap;
    FOnMapMoveEnd: TPositionMap;
    FOnMapZoomChange: TMapZoomChange;
    FOnMarkerDragStart: TEventMarker;
    FOnMarkerDragEnd: TEventMarker;
    FMarkers: TMarkers;
    FOnMapTypeChange: TMapTypeChange;
    FOnMapDblClick: TPositionMap;
    FOnMapMouseEnter: TPositionMap;
    FOnMapMouseExit: TPositionMap;
    FOnMapMove: TPositionMap;
    FMapOptions: TMapOptions;
    FOnMapIdle: TNotifyEvent;
    FOnMarkerInfoWindowCloseClick: TEventInfoWindow;
    FOnMarkerDblClick: TEventMarker;
    FOnMarkerMouseDown: TEventMarker;
    FOnMarkerMouseEnter: TEventMarker;
    FOnMarkerMouseUp: TEventMarker;
    FOnMarkerMouseExit: TEventMarker;
    FOnMarkerZoomIn: TEventMarkerZoom;
    FOnMarkerZoomOut: TEventMarkerZoom;
    FOnMarkerDrag: TEventMarker;
    FControlsOptions: TControlsOptions;
    FStreetViewOptions: TStreetViewOptions;
    FOnStreetViewMove: TPositionMap;
    FOnStreetViewChange: TStreetViewChange;
    FWeatherOptions: TWeatherOptions;
    FOnClusterClick: TEventCluster;
    FOnClusterMouseExit: TEventCluster;
    FOnClusterMouseEnter: TEventCluster;
    FPolylines: TPolylines;
    FOnPolylineClick: TEventPolylineClick;
    FOnPolylineDblClick: TEventPolyline;
    FOnPolylineMouseDown: TEventPolyline;
    FOnPolylineMouseEnter: TEventPolyline;
    FOnPolylineMouseUp: TEventPolyline;
    FOnPolylineMouseExit: TEventPolyline;
    FOnPolylineChanged: TEventPolyline;
    FOnPolygonClick: TEventPolygonClick;
    FOnPolygonDblClick: TEventPolygon;
    FOnPolygonMouseDown: TEventPolygon;
    FOnPolygonMouseEnter: TEventPolygon;
    FOnPolygonMouseUp: TEventPolygon;
    FOnPolygonMouseExit: TEventPolygon;
    FOnPolygonChanged: TEventPolygon;
    FOnBoundsRetrieved: TEventBounds;
    FOnRoutingWaypointAdded: TRoutingWayPointAdded;
    FDirections: TDirections;
    FPolygons: TPolygons;
    FAPIKey: string;
    FOnInitHTML: TInitHTMLEvent;
    FElevations: TElevations;
    FClusters: TClusters;
    FAPIClientID: string;
    FAPISignature: string;
    FAPIChannel: string;
    FAPIClientAuthURL: string;
    FMapRouting: TMapRouting;
    {$IFNDEF FMXLIB}
    FAutoLaunch: boolean;
    {$ENDIF}
    FShowDebugConsole: boolean;
    FOnAfterRoutingWaypointAdded: TAfterRoutingWaypointAdded;
    {$IFDEF DELPHIXE_LVL}
    FCurrentLocation: TLocation;
    {$ENDIF}
    {$IFNDEF FMXLIB}
    procedure SetWebBrowser(const Value: TNewWebBrowser);
    function GetDocument2: IHTMLDocument2;
    function GetHTMLWindow2: IHTMLWindow2;
    {$ENDIF}
    procedure SetMarkers(const Value: TMarkers);
    procedure SetMapOptions(const Value: TMapOptions);
    procedure SetControlsOptions(const Value: TControlsOptions);
    procedure SetStreetViewOptions(const Value: TStreetViewOptions);
    procedure SetVersion(const Value: string);
    procedure SetWeatherOptions(const Value: TWeatherOptions);
    procedure SetPolylines(const Value: TPolylines);
    function MapClusterToJS(Cluster: TMapCluster; IsUpdate: Boolean): Boolean;
    function MapPolylineToJS(Polyline: TPolyline; IsUpdate: Boolean): Boolean;
    function MapPolygonToJS(Polygon: TMapPolygon; IsUpdate: Boolean): Boolean;
    function ReplaceHTML(HTML: string): string;
    procedure SetDirections(const Value: TDirections);
    procedure SetPolygons(const Value: TPolygons);
    {$IFNDEF FMXLIB}
    procedure WMDestroy(var Msg: TMessage); message WM_DESTROY;
    procedure WebBrowserOnKeyDown(Sender: TObject; EventObjIfc: IHTMLEventObj);
    procedure SetMapPersist(const Value: TMapPersist);
    {$ENDIF}
    {$IFDEF DELPHIXE_LVL}
    procedure SetCurrentLocation(const Value: TLocation);
    {$ENDIF}
    procedure SetElevations(const Value: TElevations);
    procedure SetClusters(const Value: TClusters);
    procedure SetMapRouting(const Value: TMapRouting);
    procedure SetAPIKey(const Value: string);
    procedure SetShowDebugConsole(const Value: boolean);
    { Private }
  protected
    { Protected }
    {$IFDEF FMXLIB}
    procedure WBInitialized(Sender: TObject);
    procedure BeforeNavigate(var Params: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams); override;
    function ParseForJSEvent(urlstr: String): Boolean;
    {$ENDIF}

    {$IFNDEF FMXLIB}
    {$IFDEF DELPHIXE2_LVL}
    procedure OnBeforeNav(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant; const Flags: OleVariant;
                          const TargetFrameName: OleVariant; const PostData: OleVariant; const Headers: OleVariant; var Cancel: WordBool);
    {$ELSE}
    procedure OnBeforeNav(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant; var Flags: OleVariant;
                          var TargetFrameName: OleVariant; var PostData: OleVariant; var Headers: OleVariant; var Cancel: WordBool);
    {$ENDIF}
    {$IF CompilerVersion >= 23.0}
    procedure NavigateComplete2(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
    {$else}
    procedure NavigateComplete2(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    {$ifend}
    procedure OnProgressChange(Sender: TObject; Progress: Integer; ProgressMax: Integer);
    {$ENDIF}
    {$IFNDEF FMXLIB}
    procedure MarkerClick(Sender: TObject; MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double; Button: TMouseButton);
    procedure PolylineClick(Sender: TObject; IdPolyline:Integer; Button: TMouseButton);
    procedure PolygonClick(Sender: TObject; IdPolygon:Integer; Button: TMouseButton);
    procedure MapClick(Sender: TObject; Latitude,Longitude:Double;X,Y:Integer;Button: TMouseButton);
    procedure DoSaveMapBounds(Bounds: TBounds);
    {$IFDEF DELPHIXE7_LVL}
    function SignUrl(AUrl: String): String;
    {$ENDIF}
    {$ENDIF}
    {$IFDEF FMXLIB}
    procedure MarkerClick(Sender: TObject; MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double);
    procedure PolylineClick(Sender: TObject; IdPolyline:Integer);
    procedure PolygonClick(Sender: TObject; IdPolygon:Integer);
    procedure MapClick(Sender: TObject; Latitude,Longitude:Double;X,Y:Integer);
    {$ENDIF}
    procedure KMLLayerClick(Sender: TObject; ObjectName:String; IdLayer:Integer; Latitude,Longitude:Double);
    procedure RoutingWaypointAdded(Sender: TObject; Route: String);
    procedure ClusterClick(Sender: TObject; IdCluster:Integer; MarkerCount: Integer; Latitude, Longitude: Double);
    procedure ClusterMouseEnter(Sender: TObject; IdCluster:Integer; MarkerCount: Integer; Latitude, Longitude: Double);
    procedure ClusterMouseExit(Sender: TObject; IdCluster:Integer; MarkerCount: Integer; Latitude, Longitude: Double);
    procedure MarkerDblClick(Sender: TObject; MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double);
    procedure MarkerInfoWindowCloseClick(Sender: TObject; IdMarker:Integer);
    procedure MarkerDragStart(Sender: TObject; MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double);
    procedure MarkerDrag(Sender: TObject; MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double);
    procedure MarkerDragEnd(Sender: TObject; MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double);
    procedure MarkerMouseDown(Sender: TObject; MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double);
    procedure MarkerMouseUp(Sender: TObject; MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double);
    procedure MarkerMouseEnter(Sender: TObject; MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double);
    procedure MarkerMouseExit(Sender: TObject; MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double);
    procedure MarkerZoom(Sender: TObject; IdMarker: Integer);
    procedure MarkerMapZoom(Sender: TObject);
    procedure MarkerZoomIn(Sender: TObject; IdMarker:Integer; var Allow: boolean);
    procedure MarkerZoomOut(Sender: TObject; IdMarker:Integer; var Allow: boolean);
    procedure PolylineDblClick(Sender: TObject; IdPolyline:Integer);
    procedure PolylineMouseDown(Sender: TObject; IdPolyline:Integer);
    procedure PolylineMouseUp(Sender: TObject; IdPolyline:Integer);
    procedure PolylineMouseEnter(Sender: TObject; IdPolyline:Integer);
    procedure PolylineMouseExit(Sender: TObject; IdPolyline:Integer);
    procedure PolylineChanged(Sender: TObject; IdPolyline:Integer);
    procedure PolygonDblClick(Sender: TObject; IdPolygon:Integer);
    procedure PolygonMouseDown(Sender: TObject; IdPolygon:Integer);
    procedure PolygonMouseUp(Sender: TObject; IdPolygon:Integer);
    procedure PolygonMouseEnter(Sender: TObject; IdPolygon:Integer);
    procedure PolygonMouseExit(Sender: TObject; IdPolygon:Integer);
    procedure PolygonChanged(Sender: TObject; IdPolygon:Integer);
    procedure BoundsRetrieved(Sender: TObject; Bounds: FMX.TMSWebGMapsCommonFunctions.TBounds);
    procedure MapDblClick(Sender: TObject; Latitude,Longitude:Double;X,Y:Integer);
    procedure MapMoveStart(Sender: TObject; Latitude,Longitude:Double;X,Y:Integer);
    procedure MapMoveEnd(Sender: TObject; Latitude,Longitude:Double;X,Y:Integer);
    procedure MapMove(Sender: TObject; Latitude,Longitude:Double;X,Y:Integer);
    procedure StreetViewMove(Sender: TObject; Latitude,Longitude:Double;X,Y:Integer);
    procedure StreetViewChange(Sender: TObject; Heading,Pitch,Zoom:Integer);
    procedure MapTilesLoad(Sender: TObject);
    procedure MapIdle(Sender: TObject);
    procedure MapZoomChange(Sender: TObject; NewLevel:Integer);
    procedure MapTypeChange(Sender: TObject;NewMapType: Integer);
    procedure MapMouseMove(Sender: TObject;Latitude,Longitude:Double;X,Y:Integer);
    procedure MapMouseEnter(Sender: TObject;Latitude,Longitude:Double;X,Y:Integer);
    procedure MapMouseExit(Sender: TObject;Latitude,Longitude:Double;X,Y:Integer);
    procedure GMapsError(Sender: TObject;ErrorType:TErrorType);
    function FoundMousePosition : TPoint;
    function InitHtmlFile:string;
    function GetVersionNr: Integer; virtual;
    function GetElevationInt(Locations: TStringList; ResultCount: integer = 2): boolean;
    function InvokeScript(const AScript: string): string;
    procedure GetPolygonFromJavaScript(var APolygon: TStringList; Index: integer);
    procedure GetPolygonCircleFromJavaScript(var APolygon: string; Index: integer);
    procedure GetPolygonRectangleFromJavaScript(var APolygon: string; Index: integer);
    procedure GetPolylineFromJavaScript(var APolyline: TStringlist; Index: integer);
    procedure HandleRouting(Latitude, Longitude: Double);
    {$IFNDEF FMXLIB}
    procedure CreateWnd; override;
    {$ENDIF}
  public
    { Public }
    function GetVersion: string;

    {$IFDEF DELPHIXE_LVL}
    property CurrentLocation: TLocation read FCurrentLocation write SetCurrentLocation;
    {$ENDIF}

    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
    {$IFNDEF FMXLIB}
    function ScreenShot(ImgType: TImgType): TGraphic;
    function Launch: Boolean;
    {$ENDIF}
    {$IFDEF FMXLIB}
    procedure Loaded; override;
    procedure Initialize; override;
    procedure DoEvent(AEvent: String; AParameters: TJSEventParameters);
    procedure Reinitialize; virtual;
    procedure SetVisible(const Value: Boolean); override;
    {$ENDIF}
    procedure Flush;
    function CreateMapCluster(Cluster: TMapCluster): Boolean;
    function UpdateMapCluster(Cluster: TMapCluster): Boolean;
    function DeleteMapCluster(Id: Integer): Boolean;
    function DeleteAllMapCluster: Boolean;
    function AddMarkerToCluster(Cluster: TMapCluster; Marker: TMarker): Boolean;
    function DeleteMarkerFromCluster(Cluster: TMapCluster; Marker: TMarker): Boolean;
    {$IFNDEF FMXLIB}
    {$IFDEF DELPHIXE_LVL}
    function AddGeoImage(FileName: string; Title: string = ''; Width: integer = -1; Height: integer = -1; ZoomWidth: integer = -1; ZoomHeight: integer = -1): TMarker;
    {$ENDIF}
    {$ENDIF}
    function AddMapKMLLayer(Url: string; ZoomToBounds: boolean = true): Boolean;
    function DeleteMapKMLLayer(Id:integer): boolean;
    function DeleteAllMapKMLLayer(): boolean;
    function DeleteAllMapMarker:Boolean;
    function CreateMapMarker(Marker: TMarker):Boolean;
    function DeleteMapMarker(Id: Integer):Boolean;
    function UpdateMapMarker(Marker: TMarker):Boolean;
    function UpdateMapMarkers: Boolean;
    function CreateMapPolyline(Polyline: TPolyline):Boolean;
    function UpdateMapPolyline(Polyline: TPolyline):Boolean;
    function DeleteMapPolyline(Id: Integer):Boolean;
    function DeleteAllMapPolyline:Boolean;
    function GetModifiedMapPolyline(Polyline: TPolyline):Boolean;
    function CreateMapPolygon(Polygon: TMapPolygon):Boolean;
    function UpdateMapPolygon(Polygon: TMapPolygon):Boolean;
    function DeleteMapPolygon(Id: Integer):Boolean;
    function DeleteAllMapPolygon:Boolean;
    function GetModifiedMapPolygon(Polygon: TMapPolygon):Boolean;
    function OpenMarkerInfoWindowHtml(Id: Integer; HtmlText:String):Boolean;
    function CloseMarkerInfoWindowHtml(Id: Integer):Boolean;
    function StartMarkerBounceAnimation(Id: Integer):Boolean;
    function StopMarkerBounceAnimation(Id: Integer):Boolean;
    function MapPanTo(Latitude,Longitude:Double):Boolean;
    function MapZoomTo(Bounds: FMX.TMSWebGMapsCommonFunctions.TBounds):Boolean;
    function MapPanBy(X,Y: Integer):Boolean;
    function GetMapBounds: Boolean;
    function DegreesToLonLat(StrLon, StrLat: string; var Lon,Lat: double): boolean;
    function XYToLonLat(X, Y: integer; var Lon, Lat: double): boolean;
    function LonLatToXY(Lon, Lat: double; var X, Y: integer): boolean;
    function RenderDirections(Origin, Destination: string; RouteColor: TAlphaColor): Boolean; overload;
    function RenderDirections(OriginLatitude, OriginLongitude,
      DestinationLatitude, DestinationLongitude: double; RouteColor: TAlphaColor): Boolean; overload;
    function RenderDirections(Origin, Destination: string;
      TravelMode: TTravelMode = tmDriving; AvoidHighways: Boolean = false;
      AvoidTolls: Boolean = false; WayPoints: TStringList = nil;
      OptimizeWayPoints: Boolean = false; RouteColor: TAlphaColor = claNull): Boolean; overload;
    function RenderDirections(OriginLatitude, OriginLongitude,
      DestinationLatitude, DestinationLongitude: double;
      TravelMode: TTravelMode = tmDriving; AvoidHighways: Boolean = false;
      AvoidTolls: Boolean = false; WayPoints: TStringList = nil;
      OptimizeWayPoints: Boolean = false; RouteColor: TAlphaColor = claNull): Boolean; overload;
    function RemoveDirections(): Boolean;
    function ExecJScript(const Script: string):Boolean;
    {$IFNDEF FMXLIB}
    {$IFDEF DELPHIXE7_LVL}
    property APIClientSecret: string read FAPIClientSecret write FAPIClientSecret;
    {$ENDIF}
    property WebBrowser: TNewWebBrowser read FWebBrowser write SetWebBrowser;
    property Document2: IHTMLDocument2 read GetDocument2;
    property HTMLWindow2: IHTMLWindow2 read GetHTMLWindow2;
    procedure SaveMapBounds;
    procedure LoadMapBounds;
    {$ENDIF}
    property APIChannel: string read FAPIChannel write FAPIChannel;
    property APIClientID: string read FAPIClientID write FAPIClientID;
    property APISignature: string read FAPISignature write FAPISignature;
    property APIClientAuthURL: string read FAPIClientAuthURL write FAPIClientAuthURL;
    property ShowDebugConsole: boolean read FShowDebugConsole write SetShowDebugConsole;
    procedure SwitchToStreetView;
    procedure SwitchToMap;
    procedure GetDirections(Origin, Destination: string;
      Alternatives: Boolean = false; TravelMode: TTravelMode = tmDriving;
      Units: TUnits = usMetric; Language: TLanguageName = lnDefault;
      AvoidHighways: Boolean = false; AvoidTolls: Boolean = false;
      WayPoints: TStringList = nil; OptimizeWayPoints: Boolean = false); overload;
    procedure GetDirections(OriginLatitude, OriginLongitude,
      DestinationLatitude, DestinationLongitude: double;
      Alternatives: Boolean = false; TravelMode: TTravelMode = tmDriving;
      Units: TUnits = usMetric; Language: TLanguageName = lnDefault;
      AvoidHighways: Boolean = false; AvoidTolls: Boolean = false;
      WayPoints: TStringList = nil; OptimizeWayPoints: Boolean = false); overload;
    procedure FillDirectionList(List: TStrings; Route: integer = 0);
    procedure FillRouteList(List: TStrings; Units: TUnits);
    function Distance(la1, lo1, la2, lo2: double): double;
    {$IFDEF DELPHIXE_LVL}
    function GetCurrentLocation(): boolean;
    {$ENDIF}
    function GetElevation(Latitude, Longitude: double): boolean; overload;
    function GetElevation(Path: TPath; ResultCount: integer = 2): boolean; overload;
    property Elevations: TElevations read FElevations write SetElevations;
    procedure DoInitHTML(var HTML: string); virtual;
    {$IFNDEF FMXLIB}
    function LoadGPSRoute(AFilename: string; AColor: TAlphaColor = clRed; AWidth: integer = 2; ZoomToRoute: boolean = false): string;
    procedure SavePathToGPSRoute(Path: TPath; AStrings: TStrings; MetaData: TGPSMetaData); overload;
    procedure SavePathToGPSRoute(Path: TPath; AFileName: string; MetaData: TGPSMetaData); overload;
    procedure SavePathToGPSRoute(Path: TPath; AStrings: TStrings); overload;
    procedure SavePathToGPSRoute(Path: TPath; AFileName: string); overload;
    {$ENDIF}
    {$IFDEF FMXLIB}
    function LoadGPSRoute(AFilename: string; AColor: TAlphaColor = claRed; AWidth: integer = 2; ZoomToRoute: boolean = false): string;
    {$ENDIF}
    procedure LoadMarkersFromPoi(PoiFile: string; MarkerColor: TMarkerIconColor = icDefault);
    procedure SaveMarkersToPoi(PoiFile: string);
  published
    { Published }

    // Properties
    property Align;
    property Anchors;
    property APIKey: string read FAPIKey write SetAPIKey;
    {$IFNDEF FMXLIB}
    property AutoLaunch: boolean read FAutoLaunch write FAutoLaunch default true;
    {$ENDIF}
    property Clusters: TClusters read FClusters write SetClusters;
    property Markers: TMarkers read FMarkers write SetMarkers;
    property Polylines: TPolylines read FPolylines write SetPolylines;
    property Polygons: TPolygons  read FPolygons write SetPolygons;
    property Directions: TDirections read FDirections write SetDirections;
    property MapOptions: TMapOptions read FMapOptions write SetMapOptions;
    property Routing: TMapRouting read FMapRouting write SetMapRouting;
    property StreetViewOptions: TStreetViewOptions read FStreetViewOptions write SetStreetViewOptions;
    property ControlsOptions: TControlsOptions read FControlsOptions write SetControlsOptions;
    {$IFNDEF FMXLIB}
    property MapPersist: TMapPersist read FMapPersist write SetMapPersist;
    {$ENDIF}
    property TabStop default true;
    property TabOrder;
    property WeatherOptions: TWeatherOptions read FWeatherOptions write SetWeatherOptions;
    property Version: string read GetVersion write SetVersion;

    // Events
    property OnInitHTML: TInitHTMLEvent read FOnInitHTML write FOnInitHTML;
    property OnWebGMapsError: TWebGMapsErrorEvent read fOnWebGMapsError write fOnWebGMapsError;
    property OnDownloadStart: TNotifyEvent read FOnDownloadStart write FOnDownloadStart;
    property OnDownloadFinish: TNotifyEvent read FOnDownloadFinish write FOnDownloadFinish;
    property OnMapTilesLoad: TNotifyEvent read FOnMapTilesLoad write FOnMapTilesLoad;
    property OnMapIdle: TNotifyEvent read FOnMapIdle write FOnMapIdle;
    {$IFNDEF FMXLIB}
    property OnDownloadProgress: TWebBrowserProgressChange read FOnDownloadProgress write FOnDownloadProgress;
    {$ENDIF}
    property OnMarkerClick: TEventMarkerClick read FOnMarkerClick write FOnMarkerClick;
    property OnKMLLayerClick: TEventKMLLayer read FOnKMLLayerClick write FOnKMLLayerClick;
    property OnRoutingWaypointAdded: TRoutingWaypointAdded read FOnRoutingWaypointAdded write FOnRoutingWaypointAdded;
    property OnAfterRoutingWaypointAdded: TAfterRoutingWaypointAdded read FOnAfterRoutingWaypointAdded write FOnAfterRoutingWaypointAdded;
    property OnClusterClick: TEventCluster read FOnClusterClick write FOnClusterClick;
    property OnClusterMouseEnter: TEventCluster read FOnClusterMouseEnter write FOnClusterMouseEnter;
    property OnClusterMouseExit: TEventCluster read FOnClusterMouseExit write FOnClusterMouseExit;
    property OnMarkerDblClick: TEventMarker read FOnMarkerDblClick write FOnMarkerDblClick;
    property OnMarkerInfoWindowCloseClick: TEventInfoWindow read FOnMarkerInfoWindowCloseClick write FOnMarkerInfoWindowCloseClick;
    property OnMarkerDragStart: TEventMarker read FOnMarkerDragStart write FOnMarkerDragStart;
    property OnMarkerDrag: TEventMarker read FOnMarkerDrag write FOnMarkerDrag;
    property OnMarkerDragEnd: TEventMarker read FOnMarkerDragEnd write FOnMarkerDragEnd;
    property OnMarkerMouseDown: TEventMarker read FOnMarkerMouseDown write FOnMarkerMouseDown;
    property OnMarkerMouseUp: TEventMarker read FOnMarkerMouseUp write FOnMarkerMouseUp;
    property OnMarkerMouseEnter: TEventMarker read FOnMarkerMouseEnter write FOnMarkerMouseEnter;
    property OnMarkerMouseExit: TEventMarker read FOnMarkerMouseExit write FOnMarkerMouseExit;
    property OnMarkerZoomIn: TEventMarkerZoom read FOnMarkerZoomIn write FOnMarkerZoomIn;
    property OnMarkerZoomOut: TEventMarkerZoom read FOnMarkerZoomOut write FOnMarkerZoomOut;
    property OnPolylineClick: TEventPolylineClick read FOnPolylineClick write FOnPolylineClick;
    property OnPolylineDblClick: TEventPolyline read FOnPolylineDblClick write FOnPolylineDblClick;
    property OnPolylineMouseDown: TEventPolyline read FOnPolylineMouseDown write FOnPolylineMouseDown;
    property OnPolylineMouseUp: TEventPolyline read FOnPolylineMouseUp write FOnPolylineMouseUp;
    property OnPolylineMouseEnter: TEventPolyline read FOnPolylineMouseEnter write FOnPolylineMouseEnter;
    property OnPolylineMouseExit: TEventPolyline read FOnPolylineMouseExit write FOnPolylineMouseExit;
    property OnPolylineChanged: TEventPolyline read FOnPolylineChanged write FOnPolylineChanged;
    property OnPolygonClick: TEventPolygonClick read FOnPolygonClick write FOnPolygonClick;
    property OnPolygonDblClick: TEventPolygon read FOnPolygonDblClick write FOnPolygonDblClick;
    property OnPolygonMouseDown: TEventPolygon read FOnPolygonMouseDown write FOnPolygonMouseDown;
    property OnPolygonMouseUp: TEventPolygon read FOnPolygonMouseUp write FOnPolygonMouseUp;
    property OnPolygonMouseEnter: TEventPolygon read FOnPolygonMouseEnter write FOnPolygonMouseEnter;
    property OnPolygonMouseExit: TEventPolygon read FOnPolygonMouseExit write FOnPolygonMouseExit;
    property OnPolygonChanged: TEventPolygon read FOnPolygonChanged write FOnPolygonChanged;
    property OnBoundsRetrieved: TEventBounds read FOnBoundsRetrieved write FOnBoundsRetrieved;
    property OnMapClick: TPositionMouseMap read FOnMapClick write FOnMapClick;
    property OnMapDblClick: TPositionMap read FOnMapDblClick write FOnMapDblClick;
    property OnMapMoveStart: TPositionMap read FOnMapMoveStart write FOnMapMoveStart;
    property OnMapMoveEnd: TPositionMap read FOnMapMoveEnd write FOnMapMoveEnd;
    property OnMapMove: TPositionMap read FOnMapMove write FOnMapMove;
    property OnStreetViewMove: TPositionMap read FOnStreetViewMove write FOnStreetViewMove;
    property OnStreetViewChange: TStreetViewChange read FOnStreetViewChange write FOnStreetViewChange;
    property OnMapZoomChange: TMapZoomChange read FOnMapZoomChange write FOnMapZoomChange;
    property OnMapTypeChange: TMapTypeChange read FOnMapTypeChange write FOnMapTypeChange;
    property OnMapMouseMove: TPositionMap read FOnMapMouseMove write FOnMapMouseMove;
    property OnMapMouseEnter: TPositionMap read FOnMapMouseEnter write FOnMapMouseEnter;
    property OnMapMouseExit: TPositionMap read FOnMapMouseExit write FOnMapMouseExit;
  end;

  function ReplaceTextControlPosition(Script:String; TextToReplace:String; Position:TControlPosition):String;

implementation

uses
  Math, XMLDoc, XMLIntf
  {$IFDEF FMXLIB}
  , FMX.Platform, FMX.Types, FMX.TMSWebGMapsWebKit
  {$ENDIF}
  {$IFNDEF FMXLIB}
  {$IFDEF FREEWARE}
  {$IFDEF DELPHIXE2_LVL}
  ,StdCtrls, ShellApi
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  ;

type
  TGeoCoordinate = record
    lon,lat: double;
  end;

{$IFNDEF FMXLIB}
{$R FMX.TMSWebGMaps.RES}
{$ENDIF}

function ReplaceTextControlPosition(Script:String; TextToReplace:String; Position:TControlPosition):String;
begin
  case Position of
    cpTopRight:
      begin
        Result:= ReplaceText(Script,TextToReplace,POSITION_TOPRIGHT);
      end;
    cpTopLeft:
      begin
        Result:= ReplaceText(Script,TextToReplace,POSITION_TOPLEFT);
      end;
    cpTopCenter:
      begin
        Result:= ReplaceText(Script,TextToReplace,POSITION_TOPCENTER);
      end;
    cpBottomRight:
      begin
        Result:= ReplaceText(Script,TextToReplace,POSITION_BOTTOMRIGHT);
      end;
    cpBottomLeft:
      begin
        Result:= ReplaceText(Script,TextToReplace,POSITION_BOTTOMLEFT);
      end;
    cpBottomCenter:
      begin
        Result:= ReplaceText(Script,TextToReplace,POSITION_BOTTOMCENTER);
      end;
    cpLeftBottom:
      begin
        Result:= ReplaceText(Script,TextToReplace,POSITION_LEFTBOTTOM);
      end;
    cpLeftCenter:
      begin
        Result:= ReplaceText(Script,TextToReplace,POSITION_LEFTCENTER);
      end;
    cpLeftTop:
      begin
        Result:= ReplaceText(Script,TextToReplace,POSITION_LEFTTOP);
      end;
    cpRightBottom:
      begin
        Result:= ReplaceText(Script,TextToReplace,POSITION_RIGHTBOTTOM);
      end;
    cpRightCenter:
      begin
        Result:= ReplaceText(Script,TextToReplace,POSITION_RIGHTCENTER);
      end;
    cpRightTop:
      begin
        Result:= ReplaceText(Script,TextToReplace,POSITION_RIGHTTOP);
      end;
  end;
end;

{$IFDEF DELPHIXE_LVL}

function ThousandSeparator: char;
begin
  Result := FormatSettings.ThousandSeparator;
end;

function DecimalSeparator: char;
begin
  Result := FormatSettings.DecimalSeparator;
end;

{$ENDIF}


{ TWebGMaps }

procedure TTMSFMXWebGMaps.MarkerMapZoom(Sender: TObject);
var
  m: TMarker;
  I: integer;
  Allow: Boolean;
begin

  if MapOptions.ZoomMarker = zmToggle then
  begin
    for I := 0 to Markers.Count - 1 do
    begin
      m := Markers[I];
      if m.IconState = msZoomedIn then
      begin
        Allow := true;

        if Assigned(FOnMarkerZoomOut) then
          FOnMarkerZoomOut(Sender,I,Allow);

        if Allow then
        begin
          m.IconState := msDefault;
          UpdateMapMarker(m);
        end;
      end;
    end;
  end;
end;


procedure TTMSFMXWebGMaps.MarkerZoom(Sender: TObject; IdMarker: Integer);
var
  m, selm: TMarker;
  I: integer;
  Allow: Boolean;
begin
  if MapOptions.ZoomMarker in [zmClick, zmToggle] then
  begin
    Allow := true;
    selm := Markers[IdMarker];

    if selm.IconState = msDefault then
    begin
      if Assigned(FOnMarkerZoomIn) then
        FOnMarkerZoomIn(Sender,IdMarker,Allow);

      if Allow then
        selm.IconState := msZoomedIn;
    end
    else
    begin
      if Assigned(FOnMarkerZoomOut) then
        FOnMarkerZoomOut(Sender,IdMarker,Allow);

      if Allow then
        selm.IconState := msDefault;
    end;

    if Allow then
      UpdateMapMarker(selm);

    if MapOptions.ZoomMarker = zmToggle then
    begin
      for I := 0 to Markers.Count - 1 do
      begin
        m := Markers[I];
        if m <> selm then
        begin
          if m.IconState = msZoomedIn then
          begin
            Allow := true;

            if Assigned(FOnMarkerZoomOut) then
              FOnMarkerZoomOut(Sender,I,Allow);

            if Allow then
            begin
              m.IconState := msDefault;
              UpdateMapMarker(m);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TTMSFMXWebGMaps.HandleRouting(Latitude, Longitude: Double);
var
  Count: integer;
begin
  if Routing.Enabled then
  begin
    Routing.WayPoints.Add(Latitude, Longitude);

    //For the first WayPoint added, calculate the route with the same coordinates
    //to retrieve the exact starting point of the route instead of the clicked
    //coordinates
    if Routing.WayPoints.Count = 1 then
      Routing.WayPoints.Add(Latitude, Longitude);

    Count := Routing.Waypoints.Count;
    RenderDirections(Routing.Waypoints[Count - 2].Latitude, Routing.Waypoints[Count - 2].Longitude, Latitude, Longitude);
  end;
end;

{$IFNDEF FMXLIB}
procedure TTMSFMXWebGMaps.PolygonClick(Sender: TObject; IdPolygon:Integer; Button: TMouseButton);
begin
  if Assigned(FOnPolygonClick) then
    FOnPolygonClick(Sender,IdPolygon,Button);
end;

procedure TTMSFMXWebGMaps.PolylineClick(Sender: TObject; IdPolyline:Integer; Button: TMouseButton);
begin
  if Assigned(FOnPolylineClick) then
    FOnPolylineClick(Sender,IdPolyline,Button);
end;

procedure TTMSFMXWebGMaps.MapClick(Sender: TObject;Latitude, Longitude: Double;X,Y:Integer;Button: TMouseButton);
begin
  MarkerMapZoom(Sender);

  if Routing.Enabled and (Routing.RoutingType = rtClick) then
    HandleRouting(Latitude, Longitude);

  if Assigned(FOnMapClick) then
    FOnMapClick(Sender,Latitude,Longitude,FoundMousePosition.X,FoundMousePosition.Y,Button);
end;

procedure TTMSFMXWebGMaps.MarkerClick(Sender: TObject; MarkerTitle: String; IdMarker: Integer; Latitude, Longitude: Double; Button: TMouseButton);
begin
  MarkerZoom(Sender, IdMarker);

  if Assigned(FOnMarkerClick) then
    FOnMarkerClick(Sender,MarkerTitle,IdMarker,Latitude,Longitude,Button);
end;
{$ENDIF}

{$IFDEF FMXLIB}
procedure TTMSFMXWebGMaps.PolygonClick(Sender: TObject; IdPolygon:Integer);
begin
  if Assigned(FOnPolygonClick) then
    FOnPolygonClick(Sender,IdPolygon);
end;

procedure TTMSFMXWebGMaps.PolylineClick(Sender: TObject; IdPolyline:Integer);
begin
  if Assigned(FOnPolylineClick) then
    FOnPolylineClick(Sender,IdPolyline);
end;

procedure TTMSFMXWebGMaps.MapClick(Sender: TObject;Latitude, Longitude: Double;X,Y:Integer);
begin
  MarkerMapZoom(Sender);

  if Routing.Enabled and (Routing.RoutingType = rtClick) then
    HandleRouting(Latitude, Longitude);

  if Assigned(FOnMapClick) then
    FOnMapClick(Sender,Latitude,Longitude,FoundMousePosition.X,FoundMousePosition.Y);
end;

procedure TTMSFMXWebGMaps.MarkerClick(Sender: TObject;MarkerTitle: String; IdMarker:Integer; Latitude,Longitude:Double);
begin
  MarkerZoom(Sender, IdMarker);

  if Assigned(FOnMarkerClick) then
    FOnMarkerClick(Sender,MarkerTitle,IdMarker,Latitude,Longitude);
end;
{$ENDIF}

procedure TTMSFMXWebGMaps.MapDblClick(Sender: TObject;Latitude, Longitude: Double;X,Y:Integer);
begin
  if Routing.Enabled and (Routing.RoutingType = rtDoubleClick) then
    HandleRouting(Latitude, Longitude);

  if Assigned(FOnMapDblClick) then
    FOnMapDblClick(Sender,Latitude,Longitude,FoundMousePosition.X,FoundMousePosition.Y);
end;

procedure TTMSFMXWebGMaps.MapIdle(Sender: TObject);
begin
  if Assigned(FOnMapIdle) then
    FOnMapIdle(Sender);
end;

procedure TTMSFMXWebGMaps.KMLLayerClick(Sender: TObject;ObjectName: String; IdLayer:Integer; Latitude,Longitude:Double);
begin
  if Assigned(FOnKMLLayerClick) then
    FOnKMLLayerClick(Sender,ObjectName,IdLayer,Latitude,Longitude);
end;

procedure TTMSFMXWebGMaps.RoutingWaypointAdded(Sender: TObject; Route: String);
{$IFDEF DELPHIXE_LVL}
var
  oRoute: TRoute;
  jv: TJSONValue;
  o, fo: TJSONObject;
  ja: TJSONArray;
  i, j: integer;
  m: TMarker;
  Allow: Boolean;
  Lat, Lon: Double;
  Waypoint: TRoutingWaypoint;
{$ENDIF}
begin
{$IFDEF DELPHIXE_LVL}
  if Route = 'no_route_found' then
  begin
    //Remove last added waypoint
    if Routing.WayPoints.Count > 0 then
    begin
      if Routing.WayPoints.Count = 2 then
        Routing.WayPoints.Clear
      else
        {$IFNDEF FMXLIB}
        Routing.WayPoints[Routing.WayPoints.Count - 1].Free;
        {$ENDIF}
        {$IFDEF FMXLIB}
        Routing.WayPoints[Routing.WayPoints.Count - 1].DisposeOf;
        {$ENDIF}
    end;

    if Assigned(FOnWebGMapsError) then
      FOnWebGMapsError(Self, etInvalidWayPoint);
  end
  else
  begin

    if Route <> '' then
    begin
      oRoute := TRoute.Create(nil);
      jv := TJSONObject.ParseJSONValue(string(Route));

      if Assigned(jv) and (jv is TJSONObject) then
      begin
        begin
          try
            o := jv as TJSONObject;
            ja := GetJSONValue(o,'routes') as TJSONArray;

            if Assigned(ja) then
            begin
              Directions.Clear;
            {$IFDEF DELPHIXE6_LVL}
              for i := 0 to ja.Count - 1 do
              begin
                fo := ja.Items[i] as TJSONObject;
            {$ELSE}
              for i := 0 to ja.Size - 1 do
              begin
                fo := ja.Get(i) as TJSONObject;
            {$ENDIF}
                if Assigned(fo) then
                begin
                  oRoute.FromJSON(fo, false);

                  Lat := oRoute.Polyline.Path[oRoute.Polyline.Path.Count - 1].Latitude;
                  Lon := oRoute.Polyline.Path[oRoute.Polyline.Path.Count - 1].Longitude;

                  Waypoint := Routing.FRoutingWaypoints.Add;
                  Waypoint.Distance := oRoute.Legs[0].Distance;
                  Waypoint.Address := oRoute.Legs[0].EndAddress;
                  Waypoint.Location.Latitude := Lat;
                  Waypoint.Location.Longitude := Lon;

                  Allow := true;

                  if Assigned(FOnRoutingWaypointAdded) then
                    FOnRoutingWaypointAdded(Sender, Lat, Lon, oRoute.Polyline.Path, Allow);

                  if Allow then
                  begin
                    if Routing.Enabled then
                    begin
                      oRoute.Polyline.Color := Routing.PolylineOptions.Color;

                      if Assigned(Routing.PolylineOptions.Icons) then
                        oRoute.Polyline.Icons.Assign(Routing.PolylineOptions.Icons);

                      oRoute.Polyline.Opacity := Routing.PolylineOptions.Opacity;
                      oRoute.Polyline.Width := Routing.PolylineOptions.Width;

                      Polylines.Add;
                      Polylines[Polylines.Count - 1].Polyline.Assign(oRoute.Polyline);
                      CreateMapPolyline(oRoute.Polyline);

                      if (Routing.Markers <> rmNone) then
                      begin
                        m :=  Markers.Add(Lat, Lon);
                        if Routing.Markers = rmColor then
                          m.IconColor := Routing.MarkerColor
                        else if Routing.Markers = rmCustom then
                          m.Icon := Routing.MarkerIcon;
                      end;
                    end;

                    //Even if Routing is not enabled, add the route to the Path when
                    //RenderDirections call is used
                    if (Routing.WayPoints.Count > 2) or (not Routing.Enabled) then
                    begin
                      if not Routing.Enabled then
                        Routing.Path.Clear;

                      for J := 0 to oRoute.Polyline.Path.Count - 1 do
                      begin
                        Routing.Path.Add(oRoute.Polyline.Path[J].Latitude, oRoute.Polyline.Path[J].Longitude);
                        if (J = 0) or (Routing.Path.Count = 1) then
                          Routing.Path[Routing.Path.Count - 1].IsWayPoint := true;
                      end;
                    end;
                  end;

                  if Assigned(FOnAfterRoutingWaypointAdded) then
                    FOnAfterRoutingWaypointAdded(Sender, Lat, Lon, oRoute.Polyline.Path);

                end;
              end;
            end;
          finally
            jv.Free;
          end;
        end;
      end;
      oRoute.Free;
    end;
  end;
{$ENDIF}
end;


procedure TTMSFMXWebGMaps.ClusterClick(Sender: TObject; IdCluster:Integer; MarkerCount: integer; Latitude, Longitude: Double);
begin
  if Assigned(FOnClusterClick) then
    FOnClusterClick(Sender, IdCluster, MarkerCount, Latitude, Longitude);
end;

procedure TTMSFMXWebGMaps.ClusterMouseEnter(Sender: TObject; IdCluster,
  MarkerCount: Integer; Latitude, Longitude: Double);
begin
  if Assigned(FOnClusterMouseEnter) then
    FOnClusterMouseEnter(Sender, IdCluster, MarkerCount, Latitude, Longitude);
end;

procedure TTMSFMXWebGMaps.ClusterMouseExit(Sender: TObject; IdCluster,
  MarkerCount: Integer; Latitude, Longitude: Double);
begin
  if Assigned(FOnClusterMouseExit) then
    FOnClusterMouseExit(Sender, IdCluster, MarkerCount, Latitude, Longitude);
end;

procedure TTMSFMXWebGMaps.PolylineDblClick(Sender: TObject; IdPolyline: Integer);
begin
  if Assigned(FOnPolylineDblClick) then
    FOnPolylineDblClick(Sender, IdPolyline);
end;

procedure TTMSFMXWebGMaps.PolylineMouseDown(Sender: TObject; IdPolyline: Integer);
begin
  if Assigned(FOnPolylineMouseDown) then
    FOnPolylineMouseDown(Sender, IdPolyline);
end;

procedure TTMSFMXWebGMaps.PolylineMouseEnter(Sender: TObject; IdPolyline: Integer);
begin
  if Assigned(FOnPolylineMouseEnter) then
    FOnPolylineMouseEnter(Sender,IdPolyline);
end;

procedure TTMSFMXWebGMaps.PolylineMouseExit(Sender: TObject; IdPolyline: Integer);
begin
  if Assigned(FOnPolylineMouseExit) then
    FOnPolylineMouseExit(Sender,IdPolyline);
end;

procedure TTMSFMXWebGMaps.PolylineMouseUp(Sender: TObject; IdPolyline: Integer);
begin
  if Assigned(FOnPolylineMouseUp) then
    FOnPolylineMouseUp(Sender,IdPolyline);
end;

procedure TTMSFMXWebGMaps.PolylineChanged(Sender: TObject; IdPolyline: Integer);
begin
  if Assigned(FOnPolylineChanged) then
    FOnPolylineChanged(Sender,IdPolyline);
end;

procedure TTMSFMXWebGMaps.PolygonDblClick(Sender: TObject; IdPolygon: Integer);
begin
  if Assigned(FOnPolygonDblClick) then
    FOnPolygonDblClick(Sender, IdPolygon);
end;

procedure TTMSFMXWebGMaps.PolygonMouseDown(Sender: TObject; IdPolygon: Integer);
begin
  if Assigned(FOnPolygonMouseDown) then
    FOnPolygonMouseDown(Sender, IdPolygon);
end;

procedure TTMSFMXWebGMaps.PolygonMouseEnter(Sender: TObject; IdPolygon: Integer);
begin
  if Assigned(FOnPolygonMouseEnter) then
    FOnPolygonMouseEnter(Sender,IdPolygon);
end;

procedure TTMSFMXWebGMaps.PolygonMouseExit(Sender: TObject; IdPolygon: Integer);
begin
  if Assigned(FOnPolygonMouseExit) then
    FOnPolygonMouseExit(Sender,IdPolygon);
end;

procedure TTMSFMXWebGMaps.PolygonMouseUp(Sender: TObject; IdPolygon: Integer);
begin
  if Assigned(FOnPolygonMouseUp) then
    FOnPolygonMouseUp(Sender,IdPolygon);
end;

procedure TTMSFMXWebGMaps.PolygonChanged(Sender: TObject; IdPolygon: Integer);
begin
  if Assigned(FOnPolygonChanged) then
    FOnPolygonChanged(Sender,IdPolygon);
end;

{$IFNDEF FMXLIB}
{$IFDEF DELPHIXE_LVL}
function TTMSFMXWebGMaps.AddGeoImage(FileName: string; Title: string = ''; Width: integer = -1; Height: integer = -1; ZoomWidth: integer = -1; ZoomHeight: integer = -1): TMarker;
var
  GeoImage: TWebGMapsExifImage;
  m: TMarker;
begin
  Result := nil;

  GeoImage := TWebGMapsExifImage.Create(nil);
  GeoImage.FileName := FileName;
//  GeoImage.LoadData;

  if GeoImage.HasGPSData then
  begin
    FileName := StringReplace(FileName, '\', '/', [rfReplaceAll]);

    m := Markers.Add(GeoImage.Latitude, GeoImage.Longitude, Title, FileName, false, true, true, true, false, 0, Width, Height, ZoomWidth, ZoomHeight);
    Result := m;
  end;

  GeoImage.Free;
end;
{$ENDIF}
{$ENDIF}

function TTMSFMXWebGMaps.AddMapKMLLayer(Url: string; ZoomToBounds: boolean): boolean;
var
  js, zoom: string;
begin
  if ZoomToBounds then
    zoom := 'false'
  else
    zoom :='true';

  js := 'addKMLLayer("' + url + '", ' + zoom + ');';

  Result := ExecJScript(js);
end;

{$IFNDEF FMXLIB}
procedure TTMSFMXWebGMaps.LoadMapBounds;
var
  Inifile: TCustomInifile;
  bounds: TBounds;

begin
  if FMapPersist.Location = mplInifile then
    inifile := TInifile.Create(FMapPersist.Key)
  else
    Inifile := TRegistryInifile.Create(FMapPersist.Key);

  bounds := TBounds.Create;

  try
    bounds.NorthEast.Latitude := IniFile.ReadFloat(FMapPersist.Section, 'NELat', 0);
    bounds.NorthEast.Longitude := IniFile.ReadFloat(FMapPersist.Section, 'NELon', 0);
    bounds.SouthWest.Latitude := IniFile.ReadFloat(FMapPersist.Section, 'SWLat', 0);
    bounds.SouthWest.Longitude := IniFile.ReadFloat(FMapPersist.Section, 'SWLon', 0);

    if bounds.NorthEast.Latitude <> bounds.SouthWest.Latitude then
    begin
      MapZoomTo(bounds);
    end;

    FMapOptions.ZoomMap :=   IniFile.ReadInteger(FMapPersist.Section, 'Zoom', DEFAULT_ZOOM);

  finally
    bounds.Free;
  end;
end;

procedure TTMSFMXWebGMaps.SaveMapBounds;
begin
  FMapPersisting := true;
  try
    GetMapBounds;
  finally
    FMapPersisting := false;
  end;
end;


procedure TTMSFMXWebGMaps.DoSaveMapBounds(Bounds: TBounds);
var
  Inifile: TCustomInifile;
begin
  if FMapPersist.Location = mplInifile then
    inifile := TInifile.Create(FMapPersist.Key)
  else
    Inifile := TRegistryInifile.Create(FMapPersist.Key);

  IniFile.WriteFloat(FMapPersist.Section, 'NELat', Bounds.NorthEast.Latitude);
  IniFile.WriteFloat(FMapPersist.Section, 'NELon', Bounds.NorthEast.Longitude);

  IniFile.WriteFloat(FMapPersist.Section, 'SWLat', Bounds.SouthWest.Latitude);
  IniFile.WriteFloat(FMapPersist.Section, 'SWLon', Bounds.SouthWest.Longitude);

  IniFile.WriteInteger(FMapPersist.Section, 'Zoom', FMapOptions.ZoomMap);

  Inifile.Free;
end;
{$ENDIF}

procedure TTMSFMXWebGMaps.SaveMarkersToPoi(PoiFile: string);
var
  sl: TStringList;
  ch: char;
  i: integer;
  s: string;
begin
  if Markers.Count = 0 then
    raise Exception.Create('No markers available to save to POI file');

  sl := TStringList.Create;
  sl.StrictDelimiter := true;

  try
    {$IFDEF DELPHIXE_LVL}
    ch := FormatSettings.DecimalSeparator;
    {$ENDIF}
    {$IFNDEF DELPHIXE_LVL}
    ch := DecimalSeparator;
    {$ENDIF}

    {$IFDEF DELPHIXE_LVL}
    FormatSettings.DecimalSeparator := '.';
    {$ENDIF}
    {$IFNDEF DELPHIXE_LVL}
    DecimalSeparator := '.';
    {$ENDIF}

    for i := 0 to Markers.Count - 1 do
    begin
      s := FloatToStr(Markers[i].Longitude)+','+FloatToStr(Markers[i].Latitude)+','+Markers[i].Data;
      sl.Add(s);
    end;

    sl.SaveToFile(PoiFile);

    {$IFDEF DELPHIXE_LVL}
    FormatSettings.DecimalSeparator := ch;
    {$ENDIF}
    {$IFNDEF DELPHIXE_LVL}
    DecimalSeparator := ch;
    {$ENDIF}
  finally
    sl.Free;
  end;
end;


procedure TTMSFMXWebGMaps.LoadMarkersFromPoi(PoiFile: string;
  MarkerColor: TMarkerIconColor = icDefault);
var
  sl,slc: TStringList;
  i: integer;
  data: string;
  lon,lat: double;
  ch: char;
begin
  sl := TStringList.Create;
  sl.LoadFromFile(PoiFile);
  slc := TStringList.Create;
  slc.StrictDelimiter := true;

  {$IFDEF DELPHIXE_LVL}
  ch := FormatSettings.DecimalSeparator;
  {$ENDIF}
  {$IFNDEF DELPHIXE_LVL}
  ch := DecimalSeparator;
  {$ENDIF}

  try
    {$IFDEF DELPHIXE_LVL}
    FormatSettings.DecimalSeparator := '.';
    {$ENDIF}
    {$IFNDEF DELPHIXE_LVL}
    DecimalSeparator := '.';
    {$ENDIF}

    Markers.BeginUpdate;

    for i := 0 to sl.Count - 1 do
    begin
      slc.CommaText := sl.Strings[i];

      lon := strtofloat(slc.Strings[0]);
      lat := strtofloat(slc.Strings[1]);
      data := slc.Strings[2];

      CreateMapMarker(Markers.Add(lat,lon,data, MarkerColor));
    end;

    Markers.EndUpdate;

  finally
    {$IFDEF DELPHIXE_LVL}
    FormatSettings.DecimalSeparator := ch;
    {$ENDIF}
    {$IFNDEF DELPHIXE_LVL}
    DecimalSeparator := ch;
    {$ENDIF}
    slc.Free;
    sl.Free;
  end;
end;


procedure TTMSFMXWebGMaps.Assign(Source: TPersistent);
begin
  if (Source is TTMSFMXWebGMaps) then
  begin
    FMarkers.Assign((Source as TTMSFMXWebGMaps).Markers);
    FPolylines.Assign((Source as TTMSFMXWebGMaps).Polylines);
    FPolygons.Assign((Source as TTMSFMXWebGMaps).Polygons);
    FDirections.Assign((Source as TTMSFMXWebGMaps).Directions);
    FMapOptions.Assign((Source as TTMSFMXWebGMaps).MapOptions);
    FStreetViewOptions.Assign((Source as TTMSFMXWebGMaps).StreetViewOptions);
    FControlsOptions.Assign((Source as TTMSFMXWebGMaps).ControlsOptions);
    FWeatherOptions.Assign((Source as TTMSFMXWebGMaps).WeatherOptions);
  end;
end;

procedure TTMSFMXWebGMaps.BoundsRetrieved(Sender: TObject; Bounds: FMX.TMSWebGMapsCommonFunctions.TBounds);
begin
  {$IFNDEF FMXLIB}
  if FMapPersisting then
  begin
    DoSaveMapBounds(Bounds);
    Exit;
  end;
  {$ENDIF}


  if Assigned(FOnBoundsRetrieved) then
    FOnBoundsRetrieved(Sender,Bounds);
end;

function TTMSFMXWebGMaps.CloseMarkerInfoWindowHtml(Id: Integer): Boolean;
begin
  Result:=ExecJScript('closeMarkerInfoWindowHtml('+inttostr(Id)+');');
end;

constructor TTMSFMXWebGMaps.Create(AOwner: TComponent);
{$IFNDEF FMXLIB}
var
  Res: TStream;
  GifImg: TGIFImage;
{$ENDIF}
begin
  inherited Create(AOwner);

  TabStop := True;
  {$IFDEF FMXLIB}
  if IsFMXBrowser then
  begin
    OnInitialized := WBInitialized;
    ShowScrollBars := False;
    Show3DBorder := False;
  end;
  {$ENDIF}
  {$IFNDEF FMXLIB}
  FAutoLaunch := true;
  {$ENDIF}
  FMapOptions := TMapOptions.Create(Self);
  FStreetViewOptions := TStreetViewOptions.Create(Self);
  FControlsOptions := TControlsOptions.Create(Self);
  FWeatherOptions := TWeatherOptions.Create(Self);
  FMapRouting := TMapRouting.Create(Self);
  {$IFNDEF FMXLIB}
  FOnKeyDownConnector := THTMLEventLink.Create(WebBrowserOnKeyDown);
  FMapPersist := TMapPersist.Create;
  {$IFDEF DELPHIXE7_LVL}
  FAPIClientSecret := EmptyStr;
  {$ENDIF}
  {$ENDIF}
  FAPIKey := EmptyStr;
  FAPIClientID := EmptyStr;
  FAPIChannel := EmptyStr;
  FAPISignature := EmptyStr;
  FAPIClientAuthURL := 'http://127.0.0.1';
  FShowDebugConsole := false;
  {$IFNDEF FMXLIB}
  //Fix: avoid blank map when the ALT or arrow keys are pressed after loading the map
  ControlStyle := ControlStyle + [csAcceptsControls];
  //
  Color := claWhite;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  BorderWidth := 0;

  if not(csDesigning in ComponentState) then
  begin
    GifImg := TGIFImage.Create;
    Res := TResourceStream.Create(hinstance, GIF_RESSOURCE_NAME, GIF_FORMAT);
    GifImg.LoadFromStream(Res);
    FreeAndNil(Res);

    Preloader := TImage.Create(Self);
    Preloader.Transparent := True;
    Preloader.Visible     := False;
    Preloader.Parent      := Self;
    Preloader.Align       := alClient;
    Preloader.Center      := True;
    Preloader.Picture.Assign(GifImg);
    {$IFDEF DELPHIXE_LVL}
      (Preloader.Picture.Graphic as TGIFImage).Dormant;
    {$ENDIF}
    FreeAndNil(GifImg);
  end;
  FWebBrowser := TNewWebBrowser.Create(Self);
  FWebBrowser.Visible := False;

  {$IFDEF DELPHI_UNICODE}
  FWebBrowser.SetParentComponent(Self);
  {$ENDIF}
  {$IFNDEF DELPHI_UNICODE}
  TWinControl(FWebBrowser).Parent := Self;
  {$ENDIF}

  FWebBrowser.Align := alClient;

  FWebBrowser.OnNavigateComplete2          := NavigateComplete2;
  FWebBrowser.OnBeforeNavigate2            := OnBeforeNav;
  FWebBrowser.OnProgressChange             := OnProgressChange;
  FWebBrowser.OnMarkerClick                := Self.MarkerClick;
  FWebBrowser.OnKMLLayerClick              := Self.KMLLayerClick;
  FWebBrowser.OnRouting                    := Self.RoutingWayPointAdded;
  FWebBrowser.OnClusterClick               := Self.ClusterClick;
  FWebBrowser.OnClusterMouseEnter          := Self.ClusterMouseEnter;
  FWebBrowser.OnClusterMouseExit           := Self.ClusterMouseExit;
  FWebBrowser.OnMarkerDblClick             := Self.MarkerDblClick;
  FWebBrowser.OnMarkerInfoWindowCloseClick := Self.MarkerInfoWindowCloseClick;
  FWebBrowser.OnMarkerDragStart            := Self.MarkerDragStart;
  FWebBrowser.OnMarkerDragEnd              := Self.MarkerDragEnd;
  FWebBrowser.OnMarkerDrag                 := Self.MarkerDrag;
  FWebBrowser.OnMarkerMouseUp              := Self.MarkerMouseUp;
  FWebBrowser.OnMarkerMouseDown            := Self.MarkerMouseDown;
  FWebBrowser.OnMarkerMouseEnter           := Self.MarkerMouseEnter;
  FWebBrowser.OnMarkerMouseExit            := Self.MarkerMouseExit;
  FWebBrowser.OnPolylineClick              := Self.PolylineClick;
  FWebBrowser.OnPolylineDblClick           := Self.PolylineDblClick;
  FWebBrowser.OnPolylineMouseUp            := Self.PolylineMouseUp;
  FWebBrowser.OnPolylineMouseDown          := Self.PolylineMouseDown;
  FWebBrowser.OnPolylineMouseEnter         := Self.PolylineMouseEnter;
  FWebBrowser.OnPolylineMouseExit          := Self.PolylineMouseExit;
  FWebBrowser.OnPolylineChanged            := Self.PolylineChanged;
  FWebBrowser.OnPolygonClick               := Self.PolygonClick;
  FWebBrowser.OnPolygonDblClick            := Self.PolygonDblClick;
  FWebBrowser.OnPolygonMouseUp             := Self.PolygonMouseUp;
  FWebBrowser.OnPolygonMouseDown           := Self.PolygonMouseDown;
  FWebBrowser.OnPolygonMouseEnter          := Self.PolygonMouseEnter;
  FWebBrowser.OnPolygonMouseExit           := Self.PolygonMouseExit;
  FWebBrowser.OnPolygonChanged             := Self.PolygonChanged;
  FWebBrowser.OnBoundsRetrieved            := Self.BoundsRetrieved;
  FWebBrowser.OnMapClick                   := Self.MapClick;
  FWebBrowser.onMapDblClick                := Self.MapDblClick;
  FWebBrowser.OnMapMoveStart               := Self.MapMoveStart;
  FWebBrowser.OnMapMoveEnd                 := Self.MapMoveEnd;
  FWebBrowser.OnMapMove                    := Self.MapMove;
  FWebBrowser.OnStreetViewMove             := Self.StreetViewMove;
  FWebBrowser.OnStreetViewChange           := Self.StreetViewChange;
  FWebBrowser.OnMapTilesLoad               := Self.MapTilesLoad;
  FWebBrowser.OnMapIdle                    := Self.MapIdle;
  FWebBrowser.OnMapMouseMove               := Self.MapMouseMove;
  FWebBrowser.OnMapMouseEnter              := Self.MapMouseEnter;
  FWebBrowser.OnMapMouseExit               := Self.MapMouseExit;
  FWebBrowser.OnMapZoomChange              := Self.MapZoomChange;
  FWebBrowser.OnMapTypeChange              := Self.MapTypeChange;
  FWebBrowser.OnGMapsError                 := Self.GMapsError;
  {$ENDIF}

  FClusters := TClusters.Create(Self);
  FMarkers := TMarkers.Create(Self);
  FPolylines := TPolylines.Create(Self);
  FPolygons := TPolygons.Create(Self);
  FDirections := TDirections.Create(Self);
  {$IFDEF DELPHIXE_LVL}
  FCurrentLocation := TLocation.Create;
  {$ENDIF}
  FElevations := TElevations.Create(Self);

  bLaunchFinish := False;

  // Init Values
  Width := DEFAULT_WIDTH;
  Height := DEFAULT_HEIGHT;
  CompleteHtmlFile  := '';
  Width := 400;
  Height := 250;
  TPolylineCount := 0;
  TPolygonCount := 0;
  TClusterCount := 0;
end;

function TTMSFMXWebGMaps.CreateMapCluster(Cluster: TMapCluster): Boolean;
begin
  Result := false;
  if not Assigned(Cluster) then
    exit;

  MapClusterToJS(Cluster, false);
end;

function TTMSFMXWebGMaps.CreateMapMarker(Marker:TMarker): Boolean;
var
  TextLat,TextLng,TextDrag,TextVisible,TextClickable,TextFlat,TextDropAnimation,
  TextZIndex,TextLabelColor,TextLabelBorderColor,TextLabelPadding,
  TextLabelFontName,TextLabelFontColor,TextLabelFontSize,TextLabelText,TextIcon,
  TextIconHeight,TextIconWidth,TextLabelOffsetLeft,TextLabelOffsetTop:String;
begin
  Result := false;
  if not Assigned(Marker) then
    exit;

  TextLat    := ConvertCoordinateToString(Marker.Latitude);
  TextLng    := ConvertCoordinateToString(Marker.Longitude);
  TextZIndex := IntToStr(Marker.Zindex);

  if Marker.Draggable then
    TextDrag := 'true'
  else
    TextDrag := 'false';

  if Marker.Visible then
    TextVisible := 'true'
  else
    TextVisible := 'false';

  if Marker.Clickable then
    TextClickable := 'true'
  else
    TextClickable := 'false';

  if Marker.Flat then
    TextFlat := 'true'
  else
    TextFlat := 'false';

  if Marker.InitialDropAnimation then
    TextDropAnimation := 'true'
  else
    TextDropAnimation := 'false';

  case Marker.IconColor of
    icDefault: TextIcon := Marker.Icon;
    icBlue: TextIcon := 'http://mt.google.com/vt/icon?color=ff004C13&name=icons/spotlight/spotlight-waypoint-blue.png';
    icRed: TextIcon := 'http://mt.googleapis.com/vt/icon/name=icons/spotlight/spotlight-poi.png&scale=1';
    icPurple: TextIcon := 'http://mt.google.com/vt/icon/name=icons/spotlight/spotlight-ad.png';
    icGreen: TextIcon := 'http://mt.google.com/vt/icon?psize=30&font=fonts/arialuni_t.ttf&color=ff304C13&name=icons/spotlight/spotlight-waypoint-a.png&ax=43&ay=48&text=%E2%80%A2';
  end;

  if Marker.IconHeight > 0 then
    TextIconHeight := IntToStr(Marker.IconHeight)
  else
    TextIconHeight := '0';
  if Marker.IconWidth > 0 then
    TextIconWidth := IntToStr(Marker.IconWidth)
  else
    TextIconWidth := '0';

  TextLabelText := Marker.MapLabel.Text;
  TextLabelColor := ColorToHTML(Marker.MapLabel.Color);
  TextLabelBorderColor := ColorToHTML(Marker.MapLabel.BorderColor);
  TextLabelPadding := IntToStr(Marker.MapLabel.Margin);
  TextLabelFontName := Marker.MapLabel.Font.Family;
  TextLabelFontColor := ColorToHTML(Marker.MapLabel.FontColor);
  TextLabelFontSize := IntToStr(Round(Marker.MapLabel.Font.Size));
  TextLabelOffsetLeft := IntToStr(Marker.MapLabel.OffsetLeft);
  TextLabelOffsetTop := IntToStr(Marker.MapLabel.OffsetTop);

  Result:=ExecJScript('createMapMarker("'+TextLat+'", "'
                                      +TextLng+'", "'
                                      +StringReplace(Marker.Title, '"', '\"', [rfReplaceAll]) +'", '
                                      +TextDrag+', '
                                      +TextVisible+', '
                                      +TextClickable+', '
                                      +TextFlat+', '
                                      +TextDropAnimation+', "'
                                      +TextIcon+'" , '
                                      +TextZIndex+' , "'
                                      +StringReplace(TextLabelText, '"', '&quot;', [rfReplaceAll]) +'", "'
                                      +TextLabelColor+'", "'
                                      +TextLabelBorderColor+'", '
                                      +TextLabelPadding+', "'
                                      +TextLabelFontName+'", "'
                                      +TextLabelFontColor+'", '
                                      +TextLabelFontSize+', '
                                      +TextIconWidth+', '
                                      +TextIconHeight+', "'
                                      +Marker.Text+'", '
                                      +TextLabelOffsetLeft+', '
                                      +TextLabelOffsetTop+' '
                                      +' );')
end;

function TTMSFMXWebGMaps.MapClusterToJS(Cluster: TMapCluster;
  IsUpdate: Boolean): Boolean;
var
  js, cmarkers, coptions, cstyles: String;
  I: integer;
begin
  cstyles := '';
  for I := 0 to Cluster.Styles.Count - 1 do
  begin
    if I > 0 then
      cstyles := cstyles + ', ';
    cstyles := cstyles + '{';
    cstyles := cstyles + 'textSize: ' + IntToStr(Round(Cluster.Styles[I].Font.Size));
    cstyles := cstyles + ', textColor: "' + ColorToHTML(Cluster.Styles[I].FontColor) + '"';

    if Cluster.Styles[I].Font.Family <> '' then
      cstyles := cstyles + ', fontFamily: "' + Cluster.Styles[I].Font.Family + '"';

    if not (TFontStyle.fsBold in Cluster.Styles[I].Font.Style) then
      cstyles := cstyles + ', fontWeight: "normal"';

    if TFontStyle.fsItalic in Cluster.Styles[I].Font.Style then
      cstyles := cstyles + ', fontStyle: "italic"';

    if TFontStyle.fsStrikeOut in Cluster.Styles[I].Font.Style then
      cstyles := cstyles + ', textDecoration: "line-through"'
    else if TFontStyle.fsUnderline in Cluster.Styles[I].Font.Style then
      cstyles := cstyles + ', textDecoration: "underline"';

    cstyles := cstyles + ', url: "' + Cluster.Styles[I].IconURL + '"';
    cstyles := cstyles + ', width: ' + IntToStr(Cluster.Styles[I].IconWidth);
    cstyles := cstyles + ', height: ' + IntToStr(Cluster.Styles[I].IconWidth);
    cstyles := cstyles + ', anchorIcon: [' + IntToStr(Cluster.Styles[I].IconOffsetY) + ', ' + IntToStr(Cluster.Styles[I].IconOffsetX) + ']';
    cstyles := cstyles + ', anchorText: [' + IntToStr(Cluster.Styles[I].TextOffsetY) + ', ' + IntToStr(Cluster.Styles[I].TextOffsetX) + ']';
    cstyles := cstyles + ', backgroundPosition: "' + IntToStr(Cluster.Styles[I].BackgroundPositionX) + ', ' + IntToStr(Cluster.Styles[I].BackgroundPositionY) + '"';
    cstyles := cstyles + '}';
  end;
  if cstyles <> '' then
    cstyles := '[' + cstyles + ']'
  else
    cstyles := 'null';

  if IsUpdate then
  begin
    js := 'citem = allclusters[' + IntToStr(Cluster.ItemIndex - 1) + '];';

    if cstyles <> 'null' then
      js := js + 'citem.setImagePath("");'
    else
      js := js + 'citem.setImagePath("https://cdn.rawgit.com/googlemaps/js-marker-clusterer/gh-pages/images/m");';
    js := js + 'citem.setAverageCenter(' + LowerCase(BoolToStr(Cluster.AverageCenter, true)) + ');';
    if Cluster.BatchSize > 0 then
      js := js + 'citem.setBatchSizeIE(' + IntToStr(Cluster.BatchSize) + ');';
    if Cluster.ClusterClass <> '' then
      js := js + 'citem.setClusterClass("' + Cluster.ClusterClass + '");';
    js := js + 'citem.setGridSize(' + IntToStr(Cluster.GridSize) + ');';
    js := js + 'citem.setIgnoreHidden(' + LowerCase(BoolToStr(Cluster.IgnoreHidden, true)) + ');';
    if Cluster.MaxZoom > -1 then
      js := js + 'citem.setMaxZoom(' + IntToStr(Cluster.MaxZoom) + ');'
    else
      js := js + 'citem.setMaxZoom(null);';
    js := js + 'citem.setMinimumClusterSize(' + IntToStr(Cluster.MinimumClusterSize) + ');';
    js := js + 'citem.setTitle("' + Cluster.Title + '");';
    js := js + 'citem.setZoomOnClick(' + LowerCase(BoolToStr(Cluster.ZoomOnClick, true)) + ');';

    if cstyles <> 'null' then
      js := js + 'citem.setStyles(' + cstyles + ');'
    else
      js := js + 'citem.setStyles(clusterstyles);';

    js := js + 'citem.repaint();';
    Result := (ExecJScript(js));
  end
  else
  begin
    cmarkers := '';
    for I := 0 to Markers.Count - 1 do
    begin
      if Markers[I].Cluster = Cluster then
      begin
        if cmarkers <> '' then
          cmarkers := cmarkers + ', ';
        cmarkers := cmarkers + IntToStr(I);
      end;
    end;
    cmarkers := '[' + cmarkers + ']';

    coptions := '';
    coptions := coptions + 'averageCenter: ' + LowerCase(BoolToStr(Cluster.AverageCenter, true));
    if Cluster.BatchSize > 0 then
      coptions := coptions + ', batchSizeIE: ' + IntToStr(Cluster.BatchSize);
    if Cluster.Calculator.Text <> '' then
      coptions := coptions + ', calculator: ' + Cluster.Calculator.Text;
    if Cluster.ClusterClass <> '' then
      coptions := coptions + ', clusterClass: "' + Cluster.ClusterClass + '"';
    coptions := coptions + ', gridSize: ' + IntToStr(Cluster.GridSize);
    coptions := coptions + ', ignoreHidden: ' + LowerCase(BoolToStr(Cluster.IgnoreHidden, true));
    if Cluster.MaxZoom > -1 then
      coptions := coptions + ', maxZoom: ' + IntToStr(Cluster.MaxZoom)
    else
      coptions := coptions + ', maxZoom: null';
    coptions := coptions + ', minimumClusterSize: ' + IntToStr(Cluster.MinimumClusterSize);
    coptions := coptions + ', title: "' + Cluster.Title + '"';
    coptions := coptions + ', zoomOnClick: ' + LowerCase(BoolToStr(Cluster.ZoomOnClick, true));
    if cstyles <> 'null' then
      coptions := coptions + ', imagePath: ""'
    else
      coptions := coptions + ', imagePath: "https://cdn.rawgit.com/googlemaps/js-marker-clusterer/gh-pages/images/m"';

    coptions := '{' + coptions + '}';

    js := 'createMapCluster(' + cmarkers + ', ' + coptions + ', ' + cstyles + ');';
    Result := ExecJScript(js)
  end;
end;


function TTMSFMXWebGMaps.MapPolylineToJS(Polyline: TPolyline; IsUpdate: Boolean): Boolean;
var
  TextLat,TextLng,TextZIndex,TextVisible,TextGeodesic,TextClickable,TextEditable,
  TextPath,TextIcons,TextRotation,TextOffset,TextRepeat:String;
  I: integer;
begin

  TextZIndex := IntToStr(Polyline.Zindex);

  if Polyline.Visible then
    TextVisible:='true'
  else
    TextVisible:='false';

  if Polyline.Geodesic then
    TextGeodesic:='true'
  else
    TextGeodesic:='false';

  if Polyline.Clickable then
    TextClickable:='true'
  else
    TextClickable:='false';

  if Polyline.Editable then
    TextEditable:='true'
  else
    TextEditable:='false';

  TextIcons := '[';
  for I := 0 to Polyline.Icons.Count - 1 do
  begin
    if Polyline.Icons[I].FixedRotation then
      TextRotation:='true'
    else
      TextRotation:='false';

    if Polyline.Icons[I].RepeatType = dtPixels then
      TextRepeat:='px'
    else
      TextRepeat:='%';

    if Polyline.Icons[I].OffsetType = dtPixels then
      TextOffset:='px'
    else
      TextOffset:='%';

    TextIcons := TextIcons + '{ icon: { path:';

    case Polyline.Icons[I].SymbolType of
      stBackwardClosedArrow: TextIcons := TextIcons + ' google.maps.SymbolPath.BACKWARD_CLOSED_ARROW';
      stBackwardOpenArrow: TextIcons := TextIcons + ' google.maps.SymbolPath.BACKWARD_OPEN_ARROW';
      stForwardClosedArrow: TextIcons := TextIcons + ' google.maps.SymbolPath.FORWARD_CLOSED_ARROW';
      stForwardOpenArrow: TextIcons := TextIcons + ' google.maps.SymbolPath.FORWARD_OPEN_ARROW';
      stCircle: TextIcons := TextIcons + ' google.maps.SymbolPath.CIRCLE';
    end;
    TextIcons := TextIcons + '}, fixedRotation: ' + TextRotation
    + ', repeat: "' + IntToStr(Polyline.Icons[I].RepeatValue) + TextRepeat + '", offset: "'
    + IntToStr(Polyline.Icons[I].Offset) + TextOffset + '" }';

    if I < Polyline.Icons.Count - 1 then
      TextIcons := TextIcons + ',';
  end;
  TextIcons := TextIcons + ']';

  TextPath := '[';
  for I := 0 to Polyline.Path.Count - 1 do
  begin
    TextLat    := ConvertCoordinateToString(Polyline.Path[I].Latitude);
    TextLng    := ConvertCoordinateToString(Polyline.Path[I].Longitude);

    TextPath := TextPath
    +'new google.maps.LatLng(' + TextLat + ', ' + TextLng + ')';

    if I < Polyline.Path.Count - 1 then
      TextPath := TextPath + ',';
  end;
  TextPath := TextPath + ']';

  if IsUpdate then
  begin
    Result:=ExecJScript('updateMapPolyline('+IntToStr(Polyline.ItemIndex - 1)+', '
                                      +TextClickable+', '
                                      +TextEditable+', '
                                      +TextIcons+', '
                                      +TextPath+', "'
                                      +ColorToHTML(Polyline.Color)+'", '
                                      +IntToStr(Polyline.Width)+', '
                                      +Convert255To1(Polyline.Opacity)+' , '
                                      +TextVisible+', '
                                      +TextGeodesic+', '
                                      +TextZIndex+');')
  end
  else
  begin
    Result:=ExecJScript('createMapPolyline('+TextClickable+', '
                                      +TextEditable+', '
                                      +TextIcons+', '
                                      +TextPath+', "'
                                      +ColorToHTML(Polyline.Color)+'", '
                                      +IntToStr(Polyline.Width)+', '
                                      +Convert255To1(Polyline.Opacity)+' , '
                                      +TextVisible+', '
                                      +TextGeodesic+', '
                                      +TextZIndex+');')
  end;
end;

function TTMSFMXWebGMaps.MapPolygonToJS(Polygon: TMapPolygon;
  IsUpdate: Boolean): Boolean;
var
  TextLat,TextLng,TextZIndex,TextVisible,TextGeodesic,TextClickable,TextEditable,
  TextPath, TextType, TextRadius, neTextLat,neTextLng,swTextLat,swTextLng,
  js:String;
  I: integer;
begin
  TextZIndex := IntToStr(Polygon.Zindex);

  if Polygon.Visible then
    TextVisible:='true'
  else
    TextVisible:='false';

  if Polygon.Geodesic then
    TextGeodesic:='true'
  else
    TextGeodesic:='false';

  if Polygon.Clickable then
    TextClickable:='true'
  else
    TextClickable:='false';

  if Polygon.Editable then
    TextEditable:='true'
  else
    TextEditable:='false';

  if Polygon.PolygonType = ptPath then
  begin
  TextPath := '[';
  for I := 0 to Polygon.Path.Count - 1 do
  begin
    TextLat    := ConvertCoordinateToString(Polygon.Path[I].Latitude);
    TextLng    := ConvertCoordinateToString(Polygon.Path[I].Longitude);

    TextPath := TextPath
    +'new google.maps.LatLng(' + TextLat + ', ' + TextLng + ')';

    if I < Polygon.Path.Count - 1 then
      TextPath := TextPath + ',';
  end;
  TextPath := TextPath + ']';
  TextType := 'path';
  end
  else
  begin
    TextPath := 'null';
    if Polygon.PolygonType = ptCircle then
      TextType := 'circle'
    else if Polygon.PolygonType = ptRectangle then
      TextType := 'rectangle';
  end;

  TextLat    := ConvertCoordinateToString(Polygon.Center.Latitude);
  TextLng    := ConvertCoordinateToString(Polygon.Center.Longitude);
  TextRadius := IntToStr(Polygon.Radius);

  neTextLat := ConvertCoordinateToString(Polygon.Bounds.NorthEast.Latitude);
  neTextLng := ConvertCoordinateToString(Polygon.Bounds.NorthEast.Longitude);
  swTextLat := ConvertCoordinateToString(Polygon.Bounds.SouthWest.Latitude);
  swTextLng := ConvertCoordinateToString(Polygon.Bounds.SouthWest.Longitude);

  if IsUpdate then
  begin
  js := 'updateMapPolygon('+IntToStr(Polygon.ItemIndex - 1)+', '
                                      +TextClickable+', '
                                      +TextEditable+', '
                                      +TextPath+', "'
                                      +ColorToHTML(Polygon.BackgroundColor)+'", "'
                                      +ColorToHTML(Polygon.BorderColor)+'", '
                                      +IntToStr(Polygon.BorderWidth)+', '
                                      +Convert255To1(Polygon.BackgroundOpacity)+' , '
                                      +Convert255To1(Polygon.BorderOpacity)+' , '
                                      +TextVisible+', '
                                      +TextGeodesic+', '
                                      +TextZIndex+', "'
                                      +TextType+'", '
                                      +TextLat+', '
                                      +TextLng+', '
                                      +TextRadius+', '
                                      +neTextLat+', '
                                      +neTextLng+', '
                                      +swTextLat+', '
                                      +swTextLng+
                                      ');';

    Result:=(ExecJScript(js));
  end
  else
  begin
    js := 'createMapPolygon('+TextClickable+', '
                                      +TextEditable+', '
                                      +TextPath+', "'
                                      +ColorToHTML(Polygon.BackgroundColor)+'", "'
                                      +ColorToHTML(Polygon.BorderColor)+'", '
                                      +IntToStr(Polygon.BorderWidth)+', '
                                      +Convert255To1(Polygon.BackgroundOpacity)+' , '
                                      +Convert255To1(Polygon.BorderOpacity)+' , '
                                      +TextVisible+', '
                                      +TextGeodesic+', '
                                      +TextZIndex+', "'
                                      +TextType+'", '
                                      +TextLat+', '
                                      +TextLng+', '
                                      +TextRadius+', '
                                      +neTextLat+', '
                                      +neTextLng+', '
                                      +swTextLat+', '
                                      +swTextLng+
                                      ');';
    Result:=ExecJScript(js)
  end;
end;

function TTMSFMXWebGMaps.CreateMapPolygon(Polygon: TMapPolygon): Boolean;
begin
  Result := false;
  if not Assigned(Polygon) then
    exit;

  Result := MapPolygonToJS(Polygon, false);
end;

function TTMSFMXWebGMaps.CreateMapPolyline(Polyline: TPolyline): Boolean;
begin
  Result := false;
  if not Assigned(Polyline) then
    exit;

  Result := MapPolylineToJS(Polyline, false);
end;

{$IFNDEF FMXLIB}
procedure TTMSFMXWebGMaps.CreateWnd;
begin
  inherited;
  If not (csDesigning in ComponentState) and AutoLaunch then
    Launch;
end;
{$ENDIF}

function TTMSFMXWebGMaps.UpdateMapPolyline(Polyline: TPolyline): Boolean;
begin
  Result := false;
  if not Assigned(Polyline) then
    exit;

  Result := MapPolylineToJS(Polyline, true);
end;

{$IFNDEF FMXLIB}
procedure TTMSFMXWebGMaps.WebBrowserOnKeyDown(Sender: TObject;
  EventObjIfc: IHTMLEventObj);
Var
  HTMLDocument2 : IHTMLDocument2;
begin
  //Intercept and block the F5 key.
  if Not Assigned(WebBrowser.Document) then
    Exit;

  HTMLDocument2 := (WebBrowser.Document as IHTMLDocument2);
  if HTMLDocument2.parentWindow.event.keyCode = VK_F5 then
  begin
    HTMLDocument2.parentWindow.event.cancelBubble := True;
    HTMLDocument2.parentWindow.event.keyCode := 0;
  end;
end;

procedure TTMSFMXWebGMaps.WMDestroy(var Msg: TMessage);
begin
  if Assigned(FWebBrowser) then
  begin
    if Assigned(FWebBrowser.Document) then
      (FWebBrowser.Document as IPersistStreamInit).InitNew;
  end;
  inherited;
end;
{$ENDIF}

function TTMSFMXWebGMaps.XYToLonLat(X, Y: integer; var Lon, Lat: double): boolean;
var
  TempStr, LatStr, LngStr: String;
begin
  Result := false;

  TempStr := Trim(InvokeScript('getXYToLatLng(' + IntToStr(X) + ', ' + IntToStr(Y) + ');'));
  Lon := -1;
  Lat := -1;

  if TempStr <> '' then
  begin
    // Get the Latitude
    Delete(TempStr, 1, Pos('LAT[', TempStr) + 3);
    LatStr := Copy(TempStr, 1, Pos(']', TempStr ) -1);
    LatStr := StringReplace(LatStr, '.', DecimalSeparator, []);
    Lat := StrToFloatDef(LatStr , -1);
    Delete(TempStr, 1, Pos(']', TempStr));

    // Get the Longitude
    Delete(TempStr, 1, Pos('LNG[', TempStr) + 3);
    LngStr := Copy(TempStr, 1, Pos( ']', TempStr) - 1);
    LngStr := StringReplace(LngStr, '.', DecimalSeparator, []);
    Lon := StrToFloatDef(LngStr, -1);
    Delete(TempStr, 1, Pos(']', TempStr));

    Result := true;
  end;
end;

function TTMSFMXWebGMaps.UpdateMapCluster(Cluster: TMapCluster): Boolean;
begin
  Result := False;
  if not Assigned(Cluster) then
    Exit;

  Result := MapClusterToJS(Cluster, true);
end;

function TTMSFMXWebGMaps.UpdateMapMarker(Marker: TMarker): Boolean;
var
  TextLat,TextLng,TextDrag,TextVisible,TextClickable,TextFlat,TextDropAnimation,
  TextZIndex,TextLabelColor,TextLabelBorderColor,TextLabelPadding,
  TextLabelFontName,TextLabelFontColor,TextLabelFontSize,TextLabelText,TextIcon,
  TextIconHeight,TextIconWidth:String;
begin
  Result := false;
  if not Assigned(Marker) then
    exit;

  TextLat    := ConvertCoordinateToString(Marker.Latitude);
  TextLng    := ConvertCoordinateToString(Marker.Longitude);

  if Marker.Draggable then
    TextDrag := 'true'
  else
    TextDrag := 'false';

  if Marker.Visible then
    TextVisible := 'true'
  else
    TextVisible := 'false';

  if Marker.Clickable then
    TextClickable := 'true'
  else
    TextClickable := 'false';

  if Marker.Flat then
    TextFlat := 'true'
  else
    TextFlat := 'false';

  if Marker.InitialDropAnimation then
    TextDropAnimation := 'true'
  else
    TextDropAnimation := 'false';

  case Marker.IconColor of
    icDefault: TextIcon := Marker.Icon;
    icBlue: TextIcon := 'http://mt.google.com/vt/icon?color=ff004C13&name=icons/spotlight/spotlight-waypoint-blue.png';
    icRed: TextIcon := 'http://mt.googleapis.com/vt/icon/name=icons/spotlight/spotlight-poi.png&scale=1';
    icPurple: TextIcon := 'http://mt.google.com/vt/icon/name=icons/spotlight/spotlight-ad.png';
    icGreen: TextIcon := 'http://mt.google.com/vt/icon?psize=30&font=fonts/arialuni_t.ttf&color=ff304C13&name=icons/spotlight/spotlight-waypoint-a.png&ax=43&ay=48&text=%E2%80%A2';
  end;

  if Marker.IconState = msZoomedIn then
  begin
    if Marker.IconZoomHeight > 0 then
      TextIconHeight := IntToStr(Marker.IconZoomHeight)
    else
      TextIconHeight := '0';

    if Marker.IconZoomWidth > 0 then
      TextIconWidth := IntToStr(Marker.IconZoomWidth)
    else
      TextIconWidth := '0';

    TextZIndex := '999';
  end
  else
  begin
    if Marker.IconHeight > 0 then
      TextIconHeight := IntToStr(Marker.IconHeight)
    else
      TextIconHeight := '0';

    if Marker.IconWidth > 0 then
      TextIconWidth := IntToStr(Marker.IconWidth)
    else
      TextIconWidth := '0';

    TextZIndex := IntToStr(Marker.Zindex);
  end;

  TextLabelText := Marker.MapLabel.Text;
  TextLabelColor := ColorToHTML(Marker.MapLabel.Color);
  TextLabelBorderColor := ColorToHTML(Marker.MapLabel.BorderColor);
  TextLabelPadding := IntToStr(Marker.MapLabel.Margin);
  TextLabelFontName := Marker.MapLabel.Font.Family;
  TextLabelFontColor := ColorToHTML(Marker.MapLabel.FontColor);
  TextLabelFontSize := IntToStr(Round(Marker.MapLabel.Font.Size));

  Result:=ExecJScript('updateMapMarker(' + IntToStr(Marker.Index) + ', "'
                                      +TextLat+'", "'
                                      +TextLng+'", "'
                                      +StringReplace(Marker.Title, '"', '\"', [rfReplaceAll]) +'", '
                                      +TextDrag+', '
                                      +TextVisible+', '
                                      +TextClickable+', '
                                      +TextFlat+', '
                                      +TextDropAnimation+', "'
                                      +TextIcon+'" , '
                                      +TextZIndex+' , "'
                                      +StringReplace(TextLabelText, '"', '&quot;', [rfReplaceAll]) +'", "'
                                      +TextLabelColor+'", "'
                                      +TextLabelBorderColor+'", '
                                      +TextLabelPadding+', "'
                                      +TextLabelFontName+'", "'
                                      +TextLabelFontColor+'", '
                                      +TextLabelFontSize+', '
                                      +TextIconWidth+', '
                                      +TextIconHeight+', "'
                                      +Marker.Text+'" '
                                      +' );')
end;

function TTMSFMXWebGMaps.UpdateMapMarkers: Boolean;
var
  I: integer;
  CreateResult: boolean;
begin
  Result := true;

  for I := 0 to Markers.Count - 1 do
  begin
    CreateResult := CreateMapMarker(Markers[I]);

    if not CreateResult then
      Result := false;
  end;
end;

function TTMSFMXWebGMaps.UpdateMapPolygon(Polygon: TMapPolygon): Boolean;
begin
  Result := False;
  if not Assigned(Polygon) then
    Exit;

  Result := MapPolygonToJS(Polygon, true);
end;

function TTMSFMXWebGMaps.DeleteMapPolygon(Id: Integer): Boolean;
var
  I: integer;
begin
  Result := false;
  if (Id < 0) then
    Exit;

  if (Id < Polygons.Count) then
  begin
    if (Polygons.Count = TPolygonCount) then
      Polygons[Id].Polygon.ItemIndex := 0;

    for I := Id + 1 to Polygons.Count - 1 do
      Polygons[I].Polygon.ItemIndex := Polygons[I].Polygon.ItemIndex - 1;
    TPolygonCount := TPolygonCount - 1;
  end;

  Result := ExecJScript('deleteMapPolygon('+inttostr(Id)+');');
end;

function TTMSFMXWebGMaps.DeleteMapPolyline(Id: Integer): Boolean;
var
  I: integer;
begin
  Result := false;
  if (Id < 0) then
    Exit;

  if (Id < Polylines.Count) then
  begin
    if (Polylines.Count = TPolylineCount) then
      Polylines[Id].Polyline.ItemIndex := 0;

    for I := Id + 1 to Polylines.Count - 1 do
      Polylines[I].Polyline.ItemIndex := Polylines[I].Polyline.ItemIndex - 1;
    TPolylineCount := TPolylineCount - 1;
  end;

  Result := ExecJScript('deleteMapPolyline('+inttostr(Id)+');');
end;

function TTMSFMXWebGMaps.AddMarkerToCluster(Cluster: TMapCluster;
  Marker: TMarker): Boolean;
begin
  Result := ExecJSCript('addMarkerToCluster(' + IntToStr(Cluster.ItemIndex - 1) + ', ' + IntToStr(Marker.Index) + ');');
end;

function TTMSFMXWebGMaps.DeleteMarkerFromCluster(Cluster: TMapCluster;
  Marker: TMarker): Boolean;
begin
  Result := ExecJSCript('deleteMarkerFromCluster(' + IntToStr(Cluster.ItemIndex - 1) + ', ' + IntToStr(Marker.Index - 1) + ');');
end;

function TTMSFMXWebGMaps.DeleteAllMapPolygon: Boolean;
begin
  TPolygonCount := 0;
  Result := ExecJScript('deleteAllMapPolygon();');
end;

function TTMSFMXWebGMaps.DeleteAllMapPolyline: Boolean;
begin
  TPolylineCount := 0;
  Result := ExecJScript('deleteAllMapPolyline();');
end;

function TTMSFMXWebGMaps.DeleteMapCluster(Id: Integer): Boolean;
begin
  TClusterCount := TClusterCount - 1;
  Result := ExecJScript('deleteMapCluster('+inttostr(Id)+');');
end;

function TTMSFMXWebGMaps.DeleteMapKMLLayer(Id: integer): boolean;
begin
  Result := ExecJScript('deleteKMLLayer(' + IntToStr(Id) + ');');
end;

function TTMSFMXWebGMaps.DeleteAllMapCluster: Boolean;
begin
  TClusterCount := 0;
  Result := ExecJScript('deleteAllMapCluster();');
end;

function TTMSFMXWebGMaps.DeleteAllMapKMLLayer(): boolean;
begin
  Result := ExecJScript('deleteAllKMLLayer();');
end;

function TTMSFMXWebGMaps.DegreesToLonLat(StrLon, StrLat: string; var Lon,
  Lat: double): boolean;
var
  deg,min,sec,dir: string;
  err1,err2,err3: integer;
  ddeg,dmin,dsec: double;
  dsep: char;

  function SplitDegrees(s: string; var sDeg,sMin,sSec,sDir: string): boolean;
  var
    vp: integer;
  begin
    Result := false;

    vp := Pos('°',s);

    if vp > 0 then
    begin
      sDeg := copy(s,1,vp-1);
      delete(s,1,vp );

      vp := Pos('''',s);
      if vp > 0 then
      begin
        sMin := copy(s,1,vp-1);
        delete(s,1,vp );

        vp := Pos('"',s);
        if vp > 0 then
        begin
          sSec := copy(s,1,vp - 1);
          delete(s,1,vp);
          sDir := s;
          Result := true;
        end;
      end;
    end;

  end;


begin
  Result := False;

  //Example: 49°31'46.604"N, 17°47'19.809"E

  if SplitDegrees(StrLon, Deg,Min,Sec,Dir) then
  begin
    {$IFDEF DELPHIXE_LVL}
    dsep := FormatSettings.DecimalSeparator;
    FormatSettings.DecimalSeparator := '.';
    {$ENDIF}
    {$IFNDEF DELPHIXE_LVL}
    dsep := DecimalSeparator;
    DecimalSeparator := '.';
    {$ENDIF}

    Val(Deg,ddeg,err1);
    Val(Min,dmin,err2);
    Val(Sec,dsec,err3);

    Lon := dDeg + (dmin * 60 + dsec)/3600;

    if Dir = 'E' then
      Lon := -Lon;


    if (err1 + err2 + err3 = 0) and SplitDegrees(StrLat, Deg,Min,Sec,Dir) then
    begin
      Val(Deg,ddeg,err1);
      Val(Min,dmin,err2);
      Val(Sec,dsec,err3);
      Lat := dDeg + (dmin * 60 + dsec)/3600;
      Result := (err1 + err2 + err3 = 0);

      if Dir = 'S' then
        Lat := -Lat;
    end;

    {$IFDEF DELPHIXE_LVL}
    FormatSettings.DecimalSeparator := dsep;
    {$ENDIF}
    {$IFNDEF DELPHIXE_LVL}
    DecimalSeparator := dsep;
    {$ENDIF}
  end;
end;

function TTMSFMXWebGMaps.DeleteAllMapMarker: Boolean;
begin
  Result := ExecJScript('deleteAllMapMarker();');
end;

function TTMSFMXWebGMaps.DeleteMapMarker(Id: Integer): Boolean;
begin
  Result := ExecJScript('deleteMapMarker('+inttostr(Id)+');');
end;

destructor TTMSFMXWebGMaps.Destroy;
{$IFNDEF FMXLIB}
var
  HTMLDocument:IHTMLDocument2;
{$ENDIF}
begin
  {$IFNDEF FMXLIB}
  FreeAndNil(Preloader);
  FreeAndNil(FMapPersist);
  {$ENDIF}
  FreeAndNil(FClusters);
  FreeAndNil(FMarkers);
  FreeAndNil(FPolylines);
  FreeAndNil(FPolygons);
  FreeAndNil(FDirections);
  {$IFDEF DELPHIXE_LVL}
  FreeAndNil(FCurrentLocation);
  {$ENDIF}
  FreeAndNil(FElevations);

  {$IFNDEF FMXLIB}
  //Free the interfaced object
  FOnKeyDownConnector._Release;
  FOnKeyDownConnector := nil;

  //HTMLDocument2.OnKeyDown := Unassigned;

  if HandleAllocated then
  begin
    if Assigned(FWebBrowser.Document) then
      (FWebBrowser.Document as IPersistStreamInit).InitNew;
  end;

  // force that the browser ActiveX will destroy document memory
  HTMLDocument := FWebBrowser.Document as IHTMLDocument2;
  FWebBrowser := nil;
  HTMLDocument := nil;
  {$ENDIF}

//  FreeAndNil(FWebBrowser);
  FreeAndNil(FWeatherOptions);
  FreeAndNil(FMapOptions);
  FreeAndNil(FMapRouting);
  FreeAndNil(FStreetViewOptions);
  FreeAndNil(FControlsOptions);

  inherited Destroy;
end;

function TTMSFMXWebGMaps.Distance(la1, lo1, la2, lo2: double): double;
var
  R: Double;
  dlat,dlon: double;
  a,c: double;
begin
  R := 6371; // km

  dLat := degtorad(la2-la1);
  dLon := degtorad(lo2-lo1);

  la1 := degtorad(la1);
  la2 := degtorad(la2);

  a := sin(dLat/2) * sin(dLat/2) +
       sin(dLon/2) * sin(dLon/2) * cos(la1) * cos(la2);

  c := 2 * arctan2(sqrt(a), sqrt(1-a));
  Result := R * c;

end;

procedure TTMSFMXWebGMaps.DoInitHTML(var HTML: string);
begin
  if Assigned(OnInitHTML) then
     OnInitHTML(Self, HTML);
end;

procedure TTMSFMXWebGMaps.MarkerDblClick(Sender: TObject;MarkerTitle: String; IdMarker: Integer;
  Latitude, Longitude: Double);
begin
  if Assigned(FOnMarkerDblClick) then
    FOnMarkerDblClick(Sender,MarkerTitle,IdMarker,Latitude,Longitude);
end;

procedure TTMSFMXWebGMaps.MarkerDrag(Sender: TObject;MarkerTitle: String; IdMarker: Integer; Latitude,
  Longitude: Double);
begin
  if Assigned(FOnMarkerDrag) then
    FOnMarkerDrag(Sender,MarkerTitle,IdMarker,Latitude,Longitude);
end;

procedure TTMSFMXWebGMaps.MarkerDragEnd(Sender: TObject;MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double);
begin
  if Assigned(FOnMarkerDragEnd) then
    FOnMarkerDragEnd(Sender,MarkerTitle,IdMarker,Latitude,Longitude);
end;

procedure TTMSFMXWebGMaps.MarkerDragStart(Sender: TObject;MarkerTitle:String; IdMarker:Integer; Latitude,Longitude:Double);
begin
  if Assigned(FOnMarkerDragStart) then
    FOnMarkerDragStart(Sender,MarkerTitle,IdMarker,Latitude,Longitude);
end;

procedure TTMSFMXWebGMaps.MarkerInfoWindowCloseClick(Sender: TObject;IdMarker: Integer);
begin
  if Assigned(FOnMarkerInfoWindowCloseClick) then
    FOnMarkerInfoWindowCloseClick(Sender,IdMarker);
end;

procedure TTMSFMXWebGMaps.MarkerMouseDown(Sender: TObject;MarkerTitle: String; IdMarker: Integer;
  Latitude, Longitude: Double);
begin
  if Assigned(FOnMarkerMouseDown) then
    FOnMarkerMouseDown(Sender,MarkerTitle,IdMarker,Latitude,Longitude);
end;

procedure TTMSFMXWebGMaps.MarkerMouseEnter(Sender: TObject;MarkerTitle: String; IdMarker: Integer;
  Latitude, Longitude: Double);
begin
  if Assigned(FOnMarkerMouseEnter) then
    FOnMarkerMouseEnter(Sender,MarkerTitle,IdMarker,Latitude,Longitude);
end;

procedure TTMSFMXWebGMaps.MarkerMouseExit(Sender: TObject;MarkerTitle: String; IdMarker: Integer;
  Latitude, Longitude: Double);
begin
  if Assigned(FOnMarkerMouseExit) then
    FOnMarkerMouseExit(Sender,MarkerTitle,IdMarker,Latitude,Longitude);
end;

procedure TTMSFMXWebGMaps.MarkerMouseUp(Sender: TObject;MarkerTitle: String; IdMarker: Integer;
  Latitude, Longitude: Double);
begin
  if Assigned(FOnMarkerMouseUp) then
    FOnMarkerMouseUp(Sender,MarkerTitle,IdMarker,Latitude,Longitude);
end;

procedure TTMSFMXWebGMaps.MarkerZoomIn(Sender: TObject; IdMarker: Integer;
  var Allow: boolean);
begin
  if Assigned(FOnMarkerZoomIn) then
    FOnMarkerZoomIn(Sender,IdMarker,Allow);
end;

procedure TTMSFMXWebGMaps.MarkerZoomOut(Sender: TObject; IdMarker: Integer;
  var Allow: boolean);
begin
  if Assigned(FOnMarkerZoomOut) then
    FOnMarkerZoomOut(Sender,IdMarker,Allow);
end;

{$IFNDEF FMXLIB}
{$IF CompilerVersion >= 23.0}
procedure TTMSFMXWebGMaps.NavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
{$else}
procedure TTMSFMXWebGMaps.NavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
{$ifend}
//var
//  HTMLDocument2: IHTMLDocument2;
begin
  HTMLDocument2 := (WebBrowser.Document AS IHTMLDocument2);
  HTMLDocument2.OnKeyDown := FOnKeyDownConnector as IDispatch;
end;
{$ENDIF}

function TTMSFMXWebGMaps.ExecJScript(const Script: string):Boolean;
begin
  Result := False;
  //Fix: only allow ExecJScript after the map has finished loading
  //to avoid JS errors
  if not bLaunchFinish then
    Exit;

  {$IFNDEF FMXLIB}
  if HTMLWindow2<>nil then
  begin
    try
      HTMLWindow2.ExecScript(Script, JAVASCRIPT);
      Result := True;
    except
      if Assigned(FOnWebGMapsError) then
        FOnWebGMapsError(Self, etJavascriptError);
    end;
  end;
  {$ENDIF}
  {$IFDEF FMXLIB}
  try
    ExecuteJavascript(Script);
    Result := True;
  except
    if Assigned(FOnWebGMapsError) then
      FOnWebGMapsError(Self, etJavascriptError);
  end;
  {$ENDIF}
end;

procedure TTMSFMXWebGMaps.FillRouteList(List: TStrings; Units: TUnits);
begin
  List.Clear;
  List.AddStrings(Directions.AsStrings(Units));
end;


procedure TTMSFMXWebGMaps.FillDirectionList(List: TStrings; Route: Integer = 0);
var
  i,j: integer;
begin
  for i := 0 to Directions[Route].Legs.Count - 1 do
  begin
    for j := 0 to Directions[Route].Legs[i].Steps.Count - 1 do
      List.Add(Directions[Route].Legs[i].Steps[j].Instructions
        + ' (' + Directions[Route].Legs[i].Steps[j].DistanceText + ')');
  end;
end;

procedure TTMSFMXWebGMaps.Flush;
begin
  {$IFNDEF FMXLIB}
  if HandleAllocated then
  begin
    if Assigned(FWebBrowser.Document) then
      (FWebBrowser.Document as IPersistStreamInit).InitNew;
  end;
  {$ENDIF}
end;

function TTMSFMXWebGMaps.FoundMousePosition: TPoint;
var
{$IFNDEF FMXLIB}
  ScreenPos: TPoint;
{$ENDIF}
{$IFDEF FMXLIB}
  pf: TPointF;
  m: IFMXMouseService;
{$ENDIF}
begin
  Result.X := 0;
  Result.Y := 0;
  {$IFDEF FMXLIB}
  pf := PointF(-1, -1);
  if TPlatformServices.Current.SupportsPlatformService(IFMXMouseService, IInterface(m)) then
    pf := m.GetMousePos;

  pf := AbsoluteToLocal(pf);
  Result := Point(Round(pf.X), Round(pf.Y));
  {$ENDIF}

  {$IFNDEF FMXLIB}
  if GetCursorPos(ScreenPos) then
    Result := FWebBrowser.ScreenToClient(ScreenPos);
  {$ENDIF}
end;

function TTMSFMXWebGMaps.RenderDirections(OriginLatitude, OriginLongitude,
      DestinationLatitude, DestinationLongitude: double;
      TravelMode: TTravelMode = tmDriving; AvoidHighways: Boolean = false;
      AvoidTolls: Boolean = false; WayPoints: TStringList = nil;
      OptimizeWayPoints: Boolean = false; RouteColor: TAlphaColor = claNull): Boolean;
var
  Origin, Destination: string;
begin
  Origin := ConvertCoordinateToString(OriginLatitude) + ','
    + ConvertCoordinateToString(OriginLongitude);
  Destination := ConvertCoordinateToString(DestinationLatitude) + ','
    + ConvertCoordinateToString(DestinationLongitude);

  Result := RenderDirections(Origin, Destination, TravelMode, AvoidHighWays, AvoidTolls, WayPoints, OptimizeWayPoints, RouteColor);
end;

function TTMSFMXWebGMaps.RenderDirections(Origin, Destination: string;
  RouteColor: TAlphaColor): Boolean;
begin
  Result := RenderDirections(Origin, Destination, tmDriving, false, false, nil, false, RouteColor);
end;

function TTMSFMXWebGMaps.RenderDirections(Origin, Destination: string;
  TravelMode: TTravelMode = tmDriving; AvoidHighways: Boolean = false;
  AvoidTolls: Boolean = false; WayPoints: TStringList = nil;
  OptimizeWayPoints: Boolean = false; RouteColor: TAlphaColor = claNull): Boolean;
var
  TextTravelMode, TextAvoidHighways, TextAvoidTolls, TextWayPoints,
  TextOptimizeWayPoints, TextRouteColor, TextDisplayRoute: string;
  I: integer;
begin
  case TravelMode of
    tmDriving: TextTravelMode := 'google.maps.TravelMode.DRIVING';
    tmWalking: TextTravelMode := 'google.maps.TravelMode.WALKING';
    tmBicycling: TextTravelMode := 'google.maps.TravelMode.BICYCLING';
//    tmTransit: TextTravelMode := '&mode=transit';
  end;

  if not Routing.Enabled then
    TextDisplayRoute := 'true'
  else
    TextDisplayRoute := 'false';

  if AvoidHighWays then
    TextAvoidHighways := 'true'
  else
    TextAvoidHighways := 'false';

  if AvoidTolls then
    TextAvoidTolls := 'true'
  else
    TextAvoidTolls := 'false';

  if OptimizeWayPoints then
    TextOptimizeWayPoints := 'true'
  else
    TextOptimizeWayPoints := 'false';

  TextWayPoints := '[]';
  if WayPoints <> nil then
  begin
    TextWayPoints := '';
    for I := 0 to WayPoints.Count - 1 do
    begin
      if I > 0 then
        TextWayPoints := TextWayPoints + ', ';

      TextWayPoints := TextWayPoints + '{ location: ''' + WayPoints.Strings[I] + '''}';
    end;
    TextWayPoints := '[' + TextWayPoints + ']';
  end;

  TextRouteColor := '';
  if RouteColor <> claNull then
  begin
    TextRouteColor := ColorToHTML(RouteColor);
  end;

  Result := ExecJScript('calcDirections("' + Origin + '", "' + Destination + '", ' + TextTravelMode + ', ' + TextAvoidHighways + ', ' + TextAvoidTolls + ', ' + TextWayPoints + ', ' + TextOptimizeWayPoints + ', "' + TextRouteColor + '", ' + TextDisplayRoute + ');');
end;

{$IFDEF DELPHIXE_LVL}
function TTMSFMXWebGMaps.GetCurrentLocation: boolean;
var
  o: TJSONObject;
  jv: TJSONValue;
  url: string;
  resdat: ansistring;
begin
  Result := false;
  url := 'http://freegeoip.net/json';

  resdat := HttpsGet(url);

  if (resdat <> '') then
  begin
    jv := TJSONObject.ParseJSONValue(string(resdat));

    if Assigned(jv) and (jv is TJSONObject) then
    begin
      try
        o := jv as TJSONObject;

        if Assigned(o) then
        begin
          Result := true;
          CurrentLocation.Latitude := GetJSONDouble(o,'latitude');
          CurrentLocation.Longitude := GetJSONDouble(o,'longitude');
        end;        
      finally
        jv.Free;
      end;    
    end;
  end;
end;
{$ENDIF}

function TTMSFMXWebGMaps.RemoveDirections(): Boolean;
begin
  Result := ExecJScript('if (directionsDisplay) directionsDisplay.setMap(null);');
end;

function TTMSFMXWebGMaps.RenderDirections(OriginLatitude, OriginLongitude,
  DestinationLatitude, DestinationLongitude: double;
  RouteColor: TAlphaColor): Boolean;
begin
  Result := RenderDirections(OriginLatitude, OriginLongitude, DestinationLatitude, DestinationLongitude, tmDriving, false, false, nil, false, RouteColor);
end;

{$IFNDEF DELPHIXE_LVL}
function TTMSFMXWebGMaps.GetElevation(Path: TPath; ResultCount: integer): boolean;
begin
  Result := false;
end;

function TTMSFMXWebGMaps.GetElevation(Latitude, Longitude: double): boolean;
begin
  Result := false;
end;

function TTMSFMXWebGMaps.GetElevationInt(Locations: TStringList;
  ResultCount: integer): boolean;
begin
  Result := false;
end;
{$ENDIF}

{$IFDEF DELPHIXE_LVL}
function TTMSFMXWebGMaps.GetElevation(Path: TPath; ResultCount: integer = 2): boolean;
var
  sl: TStringList;
  I: integer;
begin
  sl := TStringList.Create;
  for I := 0 to Path.Count - 1 do
  begin
    sl.Add(ConvertCoordinateToString(Path[I].Latitude) + ',' + ConvertCoordinateToString(Path[I].Longitude));
  end;
  Result := GetElevationInt(sl, ResultCount);
  sl.Free;
end;

function TTMSFMXWebGMaps.GetElevation(Latitude, Longitude: double): boolean;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  sl.Add(ConvertCoordinateToString(Latitude) + ',' + ConvertCoordinateToString(Longitude));
  Result := GetElevationInt(sl, 0);
  sl.Free;
end;

function TTMSFMXWebGMaps.GetElevationInt(Locations: TStringList; ResultCount: integer): boolean;
var
  url, surl: string;
  resdat: ansistring;
  jv: TJSONValue;
  o, fo: TJSONObject;
  ja: TJSONArray;
  i: integer;
  et: TElevationItem;
begin
  Result := false;

  if not Assigned(Locations) then
    Exit;

  if Locations.Count = 0 then
    Exit;

  surl := '/maps/api/elevation/json';

  if Locations.Count = 1 then
    surl := surl + '?locations=' + Locations[0]
  else
  begin
    if ResultCount < 2 then
      ResultCount := 2;
    if ResultCount > 100 then
      ResultCount := 100;
    surl := surl + '?samples=' + IntToStr(ResultCount) + '&path=';
    surl := surl + Locations[0];
    surl := surl + '|';
    surl := surl + Locations[Locations.Count - 1];
  end;

  if APIKey = '' then
  begin
    if (APIClientID <> '') then
      surl := surl + '&client=' + APIClientID;
    if (APIChannel <> '') then
      surl := surl + '&channel=' + APIChannel;
  end;

  url := 'https://maps.googleapis.com' + surl;

  if APIKey <> '' then
    url := url + '&key=' + APIKey
  else
  begin
    if (APIClientID <> '') and (APISignature <> '') then
      url := url + '&signature=' + APISignature

    {$IFNDEF FMXLIB}
    {$IFDEF DELPHIXE7_LVL}
    else if (APIClientID <> '') and (APIClientSecret <> '') then
      url := url + '&signature=' + SignUrl(surl);
    {$ENDIF}
    {$ENDIF}
  end;

  resdat := HttpsGet(url);

  if (resdat <> '') then
  begin
    jv := TJSONObject.ParseJSONValue(string(resdat));

    if Assigned(jv) and (jv is TJSONObject) then
    begin
      try
        o := jv as TJSONObject;
        ja := GetJSONValue(o,'results') as TJSONArray;

        if Assigned(ja) then
        begin
          Result := true;
          Elevations.Clear;
        {$IFDEF DELPHIXE6_LVL}
          for i := 0 to ja.Count - 1 do
          begin
            fo := ja.Items[i] as TJSONObject;
        {$ELSE}
          for i := 0 to ja.Size - 1 do
          begin
            fo := ja.Get(i) as TJSONObject;
        {$ENDIF}
            if Assigned(fo) then
            begin
              et := Elevations.Add;
              et.FromJSON(fo);
            end;
          end;
        end;
      finally
        jv.Free;
      end;
    end;
  end;
end;
{$ENDIF}

{$IFNDEF DELPHIXE_LVL}
procedure TTMSFMXWebGMaps.GetDirections(Origin, Destination: string;
  Alternatives: Boolean = false; TravelMode: TTravelMode = tmDriving;
  Units: TUnits = usMetric; Language: TLanguageName = lnDefault;
  AvoidHighways: Boolean = false; AvoidTolls: Boolean = false;
  WayPoints: TStringList = nil; OptimizeWayPoints: Boolean = false);
begin

end;

procedure TTMSFMXWebGMaps.GetDirections(OriginLatitude, OriginLongitude,
  DestinationLatitude, DestinationLongitude: double; Alternatives: Boolean;
  TravelMode: TTravelMode; Units: TUnits; Language: TLanguageName;
  AvoidHighways, AvoidTolls: Boolean; WayPoints: TStringList;
  OptimizeWayPoints: Boolean);
begin

end;
{$ENDIF}

{$IFDEF DELPHIXE_LVL}
procedure TTMSFMXWebGMaps.GetDirections(OriginLatitude, OriginLongitude,
  DestinationLatitude, DestinationLongitude: double; Alternatives: Boolean;
  TravelMode: TTravelMode; Units: TUnits; Language: TLanguageName;
  AvoidHighways, AvoidTolls: Boolean; WayPoints: TStringList;
  OptimizeWayPoints: Boolean);
var
  Origin, Destination: string;
begin
  Origin := ConvertCoordinateToString(OriginLatitude) + ','
    + ConvertCoordinateToString(OriginLongitude);
  Destination := ConvertCoordinateToString(DestinationLatitude) + ','
    + ConvertCoordinateToString(DestinationLongitude);

  GetDirections(Origin, Destination, Alternatives, TravelMode, Units, Language,
    AvoidHighWays, AvoidTolls, WayPoints, OptimizeWayPoints);
end;

{$IFNDEF FMXLIB}
{$IFDEF DELPHIXE7_LVL}
function TTMSFMXWebGMaps.SignUrl(AUrl: String): String;
Var
  CryptoKey: string;
  Signature: String;
  HMac: TIdHMACSHA1;
  CryptoIDByte: TIdBytes;
  SignatureHash: TidBytes;
  UrlAsByte: TBytes;
begin
  CryptoKey := StringReplace(APIClientSecret, '-', '+', [rfReplaceAll]);
  CryptoKey := StringReplace(CryptoKey, '_', '/', [rfReplaceAll]);
  CryptoIDByte := TIdBytes(TNetEncoding.Base64.DecodeStringToBytes(APIClientSecret));
  HMac := TIdHMACSHA1.Create;
  try
    UrlAsByte := TStringStream.Create(AUrl,TEncoding.UTF8).Bytes;
    HMac.Key := CryptoIDByte;
    SignatureHash := HMac.HashValue(TidBytes(UrlAsByte));
  finally
    FreeAndNil(HMac);
  end;
  Signature := TNetEncoding.Base64.EncodeBytesToString(SignatureHash);
  Signature := StringReplace(Signature, '+', '-', [rfReplaceAll]);
  Signature := StringReplace(Signature, '/', '_', [rfReplaceAll]);
  Result := Signature;
end;
{$ENDIF}
{$ENDIF}

procedure TTMSFMXWebGMaps.GetDirections(Origin, Destination: string;
  Alternatives: Boolean = false; TravelMode: TTravelMode = tmDriving;
  Units: TUnits = usMetric; Language: TLanguageName = lnDefault;
  AvoidHighways: Boolean = false; AvoidTolls: Boolean = false;
  WayPoints: TStringList = nil; OptimizeWayPoints: Boolean = false);
var
  url, surl, TextAlt, TextTravelMode, TextUnits, LanguageCode: string;
  TextAvoid, TextWayPoints: string;
  resdat: ansistring;
  jv: TJSONValue;
  o, fo: TJSONObject;
  ja: TJSONArray;
  i: integer;
  Route: TRoute;
begin
  if Alternatives then
    TextAlt := 'true'
  else
    TextAlt := 'false';

  if Language=lnDefault then
  begin
    LanguageCode := '';
  end
  else
  begin
    LanguageCode := GetEnumName(TypeInfo(TLanguageCode),ord(Language));
    LanguageCode := '&language=' + ReplaceText(LanguageCode,'_','-');
  end;

  case TravelMode of
    tmDriving: TextTravelMode := '';
    tmWalking: TextTravelMode := '&mode=walking';
    tmBicycling: TextTravelMode := '&mode=bicycling';
//    tmTransit: TextTravelMode := '&mode=transit';
  end;

  TextUnits := '&units=';
  if Units = usMetric then
    TextUnits := TextUnits + 'metric'
  else
    TextUnits := TextUnits + 'imperial';

  TextAvoid := '';
  if AvoidTolls or AvoidHighways then
  begin
    TextAvoid := '&avoid=';
    if AvoidTolls and AvoidHighways then
      TextAvoid := TextAvoid + 'tolls|highways'
    else if AvoidTolls then
      TextAvoid := TextAvoid + 'tolls'
    else if AvoidHighways then
      TextAvoid := TextAvoid + 'highways';
  end;

  TextWayPoints := '';
  if Waypoints <> nil then
  begin
    TextWayPoints := '&waypoints=';
    if OptimizeWayPoints then
      TextWayPoints := TextWayPoints + 'optimize:true|';
    for I := 0 to WayPoints.Count - 1 do
    begin
      if I > 0 then
        TextWayPoints := TextWayPoints + '|';

      TextWayPoints := TextWayPoints + URLEncode(WayPoints.Strings[I]);
    end;
  end;

  surl := '/maps/api/directions/json'
  + '?origin=' + URLEncode(Origin)
  + '&destination=' + URLEncode(Destination)
  + '&alternatives=' + TextAlt
  + TextTravelMode
  + TextUnits
  + LanguageCode
  + TextAvoid
  + TextWayPoints
  + '&sensor=false';

  if APIKey = '' then
  begin
    if (APIClientID <> '') then
      surl := surl + '&client=' + APIClientID;
    if (APIChannel <> '') then
      surl := surl + '&channel=' + APIChannel;
  end;

  url := 'https://maps.googleapis.com' + surl;

  if APIKey <> '' then
    url := url + '&key=' + APIKey
  else
  begin
    if (APIClientID <> '') and (APISignature <> '') then
      url := url + '&signature=' + APISignature

    {$IFNDEF FMXLIB}
    {$IFDEF DELPHIXE7_LVL}
    else if (APIClientID <> '') and (APIClientSecret <> '') then
      url := url + '&signature=' + SignUrl(surl);
    {$ENDIF}
    {$ENDIF}
  end;

  resdat := HttpsGet(url);

  if (resdat <> '') then
  begin
    jv := TJSONObject.ParseJSONValue(string(resdat));

    if Assigned(jv) and (jv is TJSONObject) then
    begin
      try
        o := jv as TJSONObject;
        ja := GetJSONValue(o,'routes') as TJSONArray;

        if Assigned(ja) then
        begin
          Directions.Clear;
        {$IFDEF DELPHIXE6_LVL}
          for i := 0 to ja.Count - 1 do
          begin
            fo := ja.Items[i] as TJSONObject;
        {$ELSE}
          for i := 0 to ja.Size - 1 do
          begin
            fo := ja.Get(i) as TJSONObject;
        {$ENDIF}
            if Assigned(fo) then
            begin
              Route := Directions.Add;
              Route.FromJSON(fo);

            end;
          end;
        end;
      finally
        jv.Free;
      end;
    end;
  end;
end;
{$ENDIF}

{$IFNDEF FMXLIB}
function TTMSFMXWebGMaps.GetDocument2: IHTMLDocument2;
begin
  if FWebBrowser.Document<>nil then
    Supports(FWebBrowser.Document, IHTMLDocument2, Result)
  else
    Result:=nil;
end;

function TTMSFMXWebGMaps.GetHTMLWindow2: IHTMLWindow2;
begin
  if FWebBrowser.Document<>nil then
    Result := Document2.parentWindow
  else
    Result:=nil;
end;
{$ENDIF}

function TTMSFMXWebGMaps.GetMapBounds: Boolean;
begin
  Result := ExecJScript('getBounds();');
end;

function TTMSFMXWebGMaps.GetModifiedMapPolygon(Polygon: TMapPolygon): Boolean;
var
  I: Integer;
  PolygonList: TStringList;
  PolygonStr, RadiusStr, TempStr, LatStr, LngStr: String;
  PolygonRadius, Latitude, Longitude, Latitude2, Longitude2: Double;
begin
  Result := false;

  if Polygon.PolygonType = ptPath then
  begin
    PolygonList := TStringList.Create;
    GetPolygonFromJavascript(PolygonList, Polygon.ItemIndex - 1);

    if PolygonList.Count > 0 then
    begin
      Polygon.Path.Clear;
      Result := true;
    end;

    for I := 0 to PolygonList.Count - 1 do
    begin
      //TempStr will be like: "Polygon[0] Coordinate[0] LAT[44.123456] LNG[103.123456];"
      TempStr := PolygonList[I];

      // Get the Latitude
      Delete(TempStr, 1, Pos('LAT[', TempStr) + 3);
      LatStr := Copy(TempStr, 1, Pos(']', TempStr ) -1);
      LatStr := StringReplace(LatStr, '.', DecimalSeparator, []);
      Latitude := StrToFloatDef(LatStr , -1);
      Delete(TempStr, 1, Pos(']', TempStr));

      // Get the Longitude
      Delete(TempStr, 1, Pos('LNG[', TempStr) + 3);
      LngStr := Copy(TempStr, 1, Pos( ']', TempStr) - 1);
      LngStr := StringReplace(LngStr, '.', DecimalSeparator, []);
      Longitude := StrToFloatDef(LngStr, -1);
      Delete(TempStr, 1, Pos(']', TempStr));

      if (Latitude <> -1) and (Longitude <> -1) then
        Polygon.Path.Add(Latitude, Longitude);
    end;

    PolygonList.Free;
  end
  else
  if Polygon.PolygonType = ptCircle then
  begin
    GetPolygonCircleFromJavascript(PolygonStr, Polygon.ItemIndex - 1);

    //TempStr will be like: "Polygon[0] Radius[10000] LAT[44.123456] LNG[103.123456];"
    TempStr := PolygonStr;

    // Get the PolygonRadius
    Delete(TempStr, 1, Pos('Radius[', TempStr) + 6);
    RadiusStr := Copy(TempStr, 1, Pos(']', TempStr) - 1);
    RadiusStr := StringReplace(RadiusStr, '.', DecimalSeparator, []);
    PolygonRadius := StrToFloatDef(RadiusStr, -1);
    Delete(TempStr, 1, Pos( ']', TempStr));

    // Get the Latitude
    Delete(TempStr, 1, Pos('LAT[', TempStr) + 3);
    LatStr := Copy(TempStr, 1, Pos(']', TempStr ) -1);
    LatStr := StringReplace(LatStr, '.', DecimalSeparator, []);
    Latitude := StrToFloatDef(LatStr , -1);
    Delete(TempStr, 1, Pos(']', TempStr));

    // Get the Longitude
    Delete(TempStr, 1, Pos('LNG[', TempStr) + 3);
    LngStr := Copy(TempStr, 1, Pos( ']', TempStr) - 1);
    LngStr := StringReplace(LngStr, '.', DecimalSeparator, []);
    Longitude := StrToFloatDef(LngStr, -1);
    Delete(TempStr, 1, Pos(']', TempStr));

    if (PolygonRadius <> -1) and (Latitude <> -1) and (Longitude <> -1) then
    begin
      Result := true;
      Polygon.Center.Latitude := Latitude;
      Polygon.Center.Longitude := Longitude;
      Polygon.Radius := Round(PolygonRadius);
    end;
  end
  else if Polygon.PolygonType = ptRectangle then
  begin
    GetPolygonRectangleFromJavascript(PolygonStr, Polygon.ItemIndex - 1);

    //TempStr will be like: "Polygon[0] NELA[44.123456] NELN[103.123456] SWLA[44.123456] SWLN[103.123456];"
    TempStr := PolygonStr;

    // Get the NE Latitude
    Delete(TempStr, 1, Pos('NELA[', TempStr) + 4);
    LatStr := Copy(TempStr, 1, Pos(']', TempStr ) -1);
    LatStr := StringReplace(LatStr, '.', DecimalSeparator, []);
    Latitude := StrToFloatDef(LatStr , -1);
    Delete(TempStr, 1, Pos(']', TempStr));

    // Get the NE Longitude
    Delete(TempStr, 1, Pos('NELN[', TempStr) + 4);
    LngStr := Copy(TempStr, 1, Pos( ']', TempStr) - 1);
    LngStr := StringReplace(LngStr, '.', DecimalSeparator, []);
    Longitude := StrToFloatDef(LngStr, -1);
    Delete(TempStr, 1, Pos(']', TempStr));

    // Get the SW Latitude
    Delete(TempStr, 1, Pos('SWLA[', TempStr) + 4);
    LatStr := Copy(TempStr, 1, Pos(']', TempStr ) -1);
    LatStr := StringReplace(LatStr, '.', DecimalSeparator, []);
    Latitude2 := StrToFloatDef(LatStr , -1);
    Delete(TempStr, 1, Pos(']', TempStr));

    // Get the SW Longitude
    Delete(TempStr, 1, Pos('SWLN[', TempStr) + 4);
    LngStr := Copy(TempStr, 1, Pos( ']', TempStr) - 1);
    LngStr := StringReplace(LngStr, '.', DecimalSeparator, []);
    Longitude2 := StrToFloatDef(LngStr, -1);
    Delete(TempStr, 1, Pos(']', TempStr));

    if (Latitude <> -1) and (Longitude <> -1)
      and (Latitude2 <> -1) and (Longitude2 <> -1) then
    begin
      Result := true;
      Polygon.Bounds.NorthEast.Latitude := Latitude;
      Polygon.Bounds.NorthEast.Longitude := Longitude;
      Polygon.Bounds.SouthWest.Latitude := Latitude2;
      Polygon.Bounds.SouthWest.Longitude := Longitude2;
    end;
  end;
end;

function TTMSFMXWebGMaps.GetModifiedMapPolyline(Polyline: TPolyline): Boolean;
var
  I: Integer;
  PolylineList: TStringList;
  TempStr, LatStr, LngStr: String;
  Latitude, Longitude: Double;
begin
  Result := false;

  PolylineList := TStringList.Create;
  GetPolylineFromJavascript(PolylineList, Polyline.ItemIndex - 1);

  if PolylineList.Count > 0 then
  begin
    Polyline.Path.Clear;
    Result := true;
  end;

  for I := 0 to PolylineList.Count - 1 do
  begin
    //TempStr will be like: "Polygon[0] Coordinate[0] LAT[44.123456] LNG[103.123456];"
    TempStr := PolylineList[I];

    // Get the Latitude
    Delete(TempStr, 1, Pos('LAT[', TempStr) + 3);
    LatStr := Copy(TempStr, 1, Pos(']', TempStr ) -1);
    LatStr := StringReplace(LatStr, '.', DecimalSeparator, []);
    Latitude := StrToFloatDef(LatStr , -1);
    Delete(TempStr, 1, Pos(']', TempStr));

    // Get the Longitude
    Delete(TempStr, 1, Pos('LNG[', TempStr) + 3);
    LngStr := Copy(TempStr, 1, Pos( ']', TempStr) - 1);
    LngStr := StringReplace(LngStr, '.', DecimalSeparator, []);
    Longitude := StrToFloatDef(LngStr, -1);
    Delete(TempStr, 1, Pos(']', TempStr));

    if (Latitude <> -1) and (Longitude <> -1) then
      Polyline.Path.Add(Latitude, Longitude);
  end;

  PolylineList.Free;
end;

function TTMSFMXWebGMaps.GetVersion: string;
var
  vn: Integer;
begin
  vn := GetVersionNr;
  Result := IntToStr(System.Hi(Hiword(vn)))+'.'+IntToStr(Lo(Hiword(vn)))+'.'+IntToStr(System.Hi(Loword(vn)))+'.'+IntToStr(Lo(Loword(vn)));
end;

function TTMSFMXWebGMaps.GetVersionNr: Integer;
begin
  Result := MakeLong(MakeWord(BLD_VER,REL_VER),MakeWord(MIN_VER,MAJ_VER));
end;

procedure TTMSFMXWebGMaps.GMapsError(Sender: TObject;ErrorType: TErrorType);
begin
  if Assigned(fOnWebGMapsError) then
    FOnWebGMapsError(Sender,ErrorType);
end;

function GetStr1: string;
begin
  Result := HTML_FILE_1 + HTML_FILE_2 + HTML_FILE_3;
end;

function GetStr2: string;
begin
  Result := HTML_FILE_4 + HTML_FILE_5 + HTML_FILE_6;
end;


function TTMSFMXWebGMaps.InitHtmlFile: string;
var
  TextLat, TextLng: string;
begin
  Result := GetStr1 + GetStr2;

  {$IFDEF DELPHIXE_LVL}
  if FMapOptions.FDefaultToCurrentLocation then
  begin
    if GetCurrentLocation then
    begin
      TextLat := ConvertCoordinateToString(CurrentLocation.Latitude);
      TextLng := ConvertCoordinateToString(CurrentLocation.Longitude);
    end;
  end
  else
  begin
  {$ENDIF}
    TextLat := ConvertCoordinateToString(FMapOptions.FDefaultLatitude);
    TextLng := ConvertCoordinateToString(FMapOptions.FDefaultLongitude);
  {$IFDEF DELPHIXE_LVL}
  end;
  {$ENDIF}

  Result  := ReplaceText(Result,'%latitude%',textlat);
  Result  := ReplaceText(Result,'%longitude%',textlng);
  Result  := ReplaceText(Result,'%zoom%',inttostr(FMapOptions.FZoomMap));

  //Avoid too many local constants error in XE
  Result := ReplaceHTML(Result);

  DoInitHTML(Result);
end;

function TTMSFMXWebGMaps.ReplaceHTML(HTML: string): string;
var
  LanguageCode, url: String;
begin
  Result := HTML;

  if ApiKey <> '' then
    Result  := ReplaceText(Result,'%apikey%','&key=' + APIKey)
  else
  begin
    url := '';

    if (APIClientID <> '') then
      url := url + '&client=' + APIClientID;
    if (APISignature <> '') then
      url := url + '&signature=' + APISignature;
    if (APIChannel <> '') then
      url := url + '&channel=' + APIChannel;

    Result  := ReplaceText(Result,'%apikey%', url);
  end;

  if ShowDebugConsole then
    Result  := ReplaceText(Result,'%showdebug%', '<script type="text/javascript" src="https://getfirebug.com/firebug-lite.js#startOpened"></script>')
  else
    Result  := ReplaceText(Result,'%showdebug%', '');

  case ControlsOptions.ControlsType of
    ctDefault:
      begin
        Result := ReplaceText(Result,'%controlstype%',CONTROL_DEFAULT);
      end;
    ctAndroid:
      begin
        Result := ReplaceText(Result,'%controlstype%',CONTROL_ANDROID);
      end;
    ctSmall:
      begin
        Result := ReplaceText(Result,'%controlstype%',CONTROL_SMALL);
      end;
    ctZoomPan:
      begin
        Result := ReplaceText(Result,'%controlstype%',CONTROL_ZOOMPAN);
      end;
  end;

  if MapOptions.DisablePOI then
    Result := ReplaceText(Result, '%disablepoi%', 'off')
  else
    Result := ReplaceText(Result, '%disablepoi%', 'on');

  if MapOptions.DisableTilt then
    Result := ReplaceText(Result, '%disabletilt%', '0')
  else
    Result := ReplaceText(Result, '%disabletilt%', '45');

  if MapOptions.FDraggable then
    Result:=ReplaceText(Result,'%draggable%','true')
  else
    Result:=ReplaceText(Result,'%draggable%','false');

  if MapOptions.FDisableDoubleClickZoom then
    Result:=ReplaceText(Result,'%disableDoubleClickZoom%','true')
  else
    Result:=ReplaceText(Result,'%disableDoubleClickZoom%','false');

  if MapOptions.FDisableControls then
    Result:=ReplaceText(Result,'%disableDefaultUI%','true')
  else
    Result:=ReplaceText(Result,'%disableDefaultUI%','false');

  if MapOptions.FEnableKeyboard then
    Result:=ReplaceText(Result,'%keyboardShortcuts%','true')
  else
    Result:=ReplaceText(Result,'%keyboardShortcuts%','false');

  if MapOptions.FScrollWheel then
    Result:=ReplaceText(Result,'%scrollwheel%','true')
  else
    Result:=ReplaceText(Result,'%scrollwheel%','false');

  if MapOptions.FShowTraffic then
    Result:=ReplaceText(Result,'%showtraffic%','map')
  else
    Result:=ReplaceText(Result,'%showtraffic%','null');

  if MapOptions.FShowBicycling then
    Result:=ReplaceText(Result,'%showbicycling%','map')
  else
    Result:=ReplaceText(Result,'%showbicycling%','null');

  if MapOptions.FShowPanoramio then
    Result:=ReplaceText(Result,'%showpanoramio%','map')
  else
    Result:=ReplaceText(Result,'%showpanoramio%','null');

  if MapOptions.FShowCloud then
    Result:=ReplaceText(Result,'%showcloud%','map')
  else
    Result:=ReplaceText(Result,'%showcloud%','null');

  if MapOptions.FShowWeather then
    Result:=ReplaceText(Result,'%showweather%','map')
  else
    Result:=ReplaceText(Result,'%showweather%','null');

  case FWeatherOptions.FTemperatureUnit of
    wtCelsius:
      Result:=ReplaceText(Result,'%weatherTemperature%',WEATHER_TEMPERATURE_CELSIUS);
    wtFahrenheit:
      Result:=ReplaceText(Result,'%weatherTemperature%',WEATHER_TEMPERATURE_FAHRENHEIT);
  end;

  case FWeatherOptions.FWindSpeedUnit of
    wwsKilometersPerHour:
      Result:=ReplaceText(Result,'%weatherWindSpeed%',WEATHER_WIND_SPEED_KILOMETERS_PER_HOUR);
    wwsMetersPerSecond:
      Result:=ReplaceText(Result,'%weatherWindSpeed%',WEATHER_WIND_SPEED_METERS_PER_SECOND);
    wwsMilesPerHour:
      Result:=ReplaceText(Result,'%weatherWindSpeed%',WEATHER_WIND_SPEED_MILES_PER_HOUR);
  end;

  case FWeatherOptions.FLabelColor of
    wlcBlack:
      Result:=ReplaceText(Result,'%weatherLabelColor%',WEATHER_LABEL_COLOR_BLACK);
    wlcWhite:
      Result:=ReplaceText(Result,'%weatherLabelColor%',WEATHER_LABEL_COLOR_WHITE);
  end;

  if FWeatherOptions.FShowInfoWindows then
  begin
    Result:=ReplaceText(Result,'%weatherSuppressInfoWinddows%','false');
  end
  else
  begin
    Result:=ReplaceText(Result,'%weatherSuppressInfoWinddows%','true');
  end;

  case FMapOptions.FMapType of
    mtDefault:
      Result:=ReplaceText(Result,'%maptype%',MAP_DEFAULT);
    mtSatellite:
      Result:=ReplaceText(Result,'%maptype%',MAP_SATELLITE);
    mtHybrid:
      Result:=ReplaceText(Result,'%maptype%',MAP_HYBRID);
    mtTerrain:
      Result:=ReplaceText(Result,'%maptype%',MAP_TERRAIN);
  end;

  if MapOptions.Language=lnDefault then
  begin
    Result:=ReplaceText(Result,'&language=%lang%','');
  end
  else
  begin
    LanguageCode := GetEnumName(TypeInfo(TLanguageCode),ord(FMapOptions.Language));
    LanguageCode := ReplaceText(LanguageCode,'_','-');
    Result:=ReplaceText(Result,'%lang%',LanguageCode);
  end;

  // PanControl
  if ControlsOptions.PanControl.Visible then
    Result:=ReplaceText(Result,'%panControl%','true')
  else
    Result:=ReplaceText(Result,'%panControl%','false');
  Result:=ReplaceTextControlPosition(Result,'%panControlPosition%',ControlsOptions.PanControl.Position);

  // ZoomControl
  if ControlsOptions.ZoomControl.Visible then
    Result:=ReplaceText(Result,'%zoomControl%','true')
  else
    Result:=ReplaceText(Result,'%zoomControl%','false');
  Result:=ReplaceTextControlPosition(Result,'%zoomControlPosition%',ControlsOptions.ZoomControl.Position);
  case ControlsOptions.ZoomControl.Style of
    zsDefault:
      Result:=ReplaceText(Result,'%zoomControlStyle%',ZOOM_DEFAULT);
    zsSmall:
      Result:=ReplaceText(Result,'%zoomControlStyle%',ZOOM_SMALL);
    zsLarge:
      Result:=ReplaceText(Result,'%zoomControlStyle%',ZOOM_LARGE);
  end;

  // MapTypeControl
  if ControlsOptions.MapTypeControl.Visible then
    Result:=ReplaceText(Result,'%mapTypeControl%','true')
  else
    Result:=ReplaceText(Result,'%mapTypeControl%','false');
  Result:=ReplaceTextControlPosition(Result,'%mapTypeControlPosition%',ControlsOptions.MapTypeControl.Position);
  case ControlsOptions.MapTypeControl.Style of
    mtsDefault:
      Result:=ReplaceText(Result,'%mapTypeControlStyle%',MAPTYPE_DEFAULT);
    mtsDropDownMenu:
      Result:=ReplaceText(Result,'%mapTypeControlStyle%',MAPTYPE_DROPDOWNMENU);
    mtsHorizontalBar:
      Result:=ReplaceText(Result,'%mapTypeControlStyle%',MAPTYPE_HORIZONTALBAR);
  end;

  // ScaleControl
  if ControlsOptions.ScaleControl.Visible then
    Result:=ReplaceText(Result,'%scaleControl%','true')
  else
    Result:=ReplaceText(Result,'%scaleControl%','false');
  Result:=ReplaceTextControlPosition(Result,'%scaleControlPosition%',ControlsOptions.ScaleControl.Position);

  // StreetViewControl
  if ControlsOptions.StreetViewControl.Visible then
    Result:=ReplaceText(Result,'%streetViewControl%','true')
  else
    Result:=ReplaceText(Result,'%streetViewControl%','false');

  Result:=ReplaceTextControlPosition(Result,'%streetViewControlPosition%',ControlsOptions.StreetViewControl.Position);

  // RotateControl
  if ControlsOptions.RotateControl.Visible then
    Result:=ReplaceText(Result,'%rotateControl%','true')
  else
    Result:=ReplaceText(Result,'%rotateControl%','false');

  Result:=ReplaceTextControlPosition(Result,'%rotateControlPosition%',ControlsOptions.RotateControl.Position);

  if StreetViewOptions.Visible then
    Result:=ReplaceText(Result,'%SVVisible%','true')
  else
    Result:=ReplaceText(Result,'%SVVisible%','false');
  Result:=ReplaceText(Result,'%SVLat%',ConvertCoordinateToString(StreetViewOptions.DefaultLatitude));
  Result:=ReplaceText(Result,'%SVLng%',ConvertCoordinateToString(StreetViewOptions.DefaultLongitude));
  Result:=ReplaceText(Result,'%SVHeading%',IntToStr(StreetViewOptions.Heading));
  Result:=ReplaceText(Result,'%SVZoom%',IntToStr(StreetViewOptions.Zoom));
  Result:=ReplaceText(Result,'%SVPitch%',IntToStr(StreetViewOptions.Pitch));

  // OverviewMapControl
  if ControlsOptions.OverviewMapControl.Visible then
    Result:=ReplaceText(Result,'%overviewMapControl%','true')
  else
    Result:=ReplaceText(Result,'%overviewMapControl%','false');
  if ControlsOptions.OverviewMapControl.Open then
    Result:=ReplaceText(Result,'%overviewMapControlOpened%','true')
  else
    Result:=ReplaceText(Result,'%overviewMapControlOpened%','false');
end;


{$IFDEF FMXLIB}
procedure TTMSFMXWebGMaps.SetVisible(const Value: Boolean);
begin
  inherited;
  {$IFDEF MSWINDOWS}
  Reinitialize;
  {$ENDIF}
end;

procedure TTMSFMXWebGMaps.WBInitialized(Sender: TObject);
begin
  if IsFMXBrowser then
    LoadHTML(InitHtmlFile);
end;

procedure TTMSFMXWebGMaps.BeforeNavigate(
  var Params: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams);
begin
  if Assigned(FOnDownloadStart) then
    FOnDownloadStart(Self);

  Params.Cancel := ParseForJSEvent(Params.URL);
  inherited;
  {$IFNDEF DELPHIXE9_LVL}
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  ExecuteJavascript('google.maps.event.trigger(map, ''resize'')');
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
end;

function TTMSFMXWebGMaps.ParseForJSEvent(urlstr: String): Boolean;
var
  pref, prefrouting: String;
  params: String;
  arr, arrparams, arrValue: TArray<string>;
  I, K: Integer;
  js: TJSEventParameters;
  functionName: String;
  strm: String;
  func: String;

  function UnescapeString(const AValue: string): string;
  var
    i: Integer;
    j: Integer;
    c: Integer;
    o: Integer;
  begin
    SetLength(Result, Length(AValue));
    {$IFDEF DELPHI_LLVM}
    o := 1;
    {$ENDIF}
    {$IFNDEF DELPHI_LLVM}
    o := 0;
    {$ENDIF}
    i := 1;
    j := 1;
    while i <= Length(AValue) do
    begin
      if AValue[i - o] = '\' then
      begin
        if i < Length(AValue) then
        begin
          if AValue[i + 1 - o] = '\' then
          begin
            Result[j - o] := '\';
            inc(i, 2);
          end
          else if (AValue[i + 1 - o] = 'u') and (i + 1 + 4 <= Length(AValue)) and TryStrToInt('$' + string(Copy(AValue, i + 2, 4)), c) then
          begin
            inc(i, 6);
            Result[j - o] := Char(c);
          end
          else
            raise Exception.CreateFmt('Invalid code at position %d', [i]);
        end
        else
          raise Exception.Create('Unexpected end of string');
      end
      else
      begin
        Result[j - o] := Char(AValue[i - o]);
        inc(i);
      end;
      inc(j);
    end;
    SetLength(Result, j - 1);
  end;
begin
  {$IFDEF MACOS}
  urlstr := UTF8ToString(NSStrEx(urlstr).stringByReplacingPercentEscapesUsingEncoding(NSASCIIStringEncoding).UTF8String);
  {$ENDIF}
  Result := False;
  pref := 'jsevent://';
  prefrouting := 'routing:title=';

  if urlstr.ToLower.StartsWith(pref) then
  begin
    urlStr := urlStr.Substring(pref.length);

    if FRouting and urlStr.StartsWith(prefrouting) then
    begin
      SetLength(js, 1);
      js[0].parameter := 'title';
      js[0].value := UnescapeString(urlStr.Substring(prefrouting.Length, urlStr.Length).Replace('/', ''));
      DoEvent('routing', js);
      Result := True;
    end
    else
    begin
      arr := urlStr.Split([':']);
      if Length(arr) > 0 then
      begin
        if Length(arr) > 2 then
        begin
          func := arr[0];
          strm := arr[1];

          for K := 2 to Length(arr) - 1 do
            strm := strm + ':' + arr[K];

          SetLength(arr, 2);
          arr[Length(arr) - 2] := func;
          arr[Length(arr) - 1] := strm;
        end;

        functionName := arr[0];
        SetLength(js, 0);
        if Length(arr) > 1 then
        begin
          params := arr[1];
          arrparams := params.Split(['#']);
          SetLength(js, Length(arrparams));
          for I := 0 to Length(arrparams) - 1 do
          begin
            arrvalue := arrParams[I].Split(['=']);
            if Length(arrvalue) > 1 then
            begin
              js[I].parameter := arrvalue[0].Replace('/', '');
              js[I].value := arrvalue[1].Replace('/', '');
            end;
          end;
        end;

        DoEvent(functionName.Replace('/', ''), js);
        Result := True;
      end;
    end;
  end;
end;

procedure TTMSFMXWebGMaps.DoEvent(AEvent: String; AParameters: TJSEventParameters);
var
  str, param, title: String;
  Lat, Lng, NorthEastLatitude, NorthEastLongitude, SouthWestLatitude, SouthWestLongitude: double;
  I, X, Y, ErrorType, id, maptype, zoomlevel, heading, pitch, zoom, MarkerCount: Integer;
  Bounds: FMX.TMSWebGMapsCommonFunctions.TBounds;
begin
  inherited;
  str := '';
  Lat := 0;
  Lng := 0;
  X := 0;
  Y := 0;
  ErrorType := 0;
  maptype := 0;
  zoomlevel := 0;
  id := 0;
  title := '';
  param := '';
  NorthEastLatitude := 0;
  NorthEastLongitude := 0;
  SouthWestLatitude := 0;
  SouthWestLongitude := 0;
  heading := 0;
  pitch := 0;
  zoom := 0;
  MarkerCount := 0;

  for I := 0 to Length(AParameters) - 1 do
  begin
    param := AParameters[I].value;
    str := str + AParameters[I].parameter + ' : ' + param + ' * ';

    if (AParameters[I].parameter = 'lat') and (param <> '') then
      Lat := ConvertStringToCoordinate(param);

    if (AParameters[I].parameter = 'lng') and (param <> '') then
      Lng := ConvertStringToCoordinate(param);

    if (AParameters[I].parameter = 'nelat') and (param <> '') then
      NorthEastLatitude := ConvertStringToCoordinate(param);

    if (AParameters[I].parameter = 'nelng') and (param <> '') then
      NorthEastLongitude := ConvertStringToCoordinate(param);

    if (AParameters[I].parameter = 'swlat') and (param <> '') then
      SouthWestLatitude := ConvertStringToCoordinate(param);

    if (AParameters[I].parameter = 'swlng') and (param <> '') then
      SouthWestLongitude := ConvertStringToCoordinate(param);

    if (AParameters[I].parameter = 'x') and (param <> '') then
      X := StrToInt(param);

    if (AParameters[I].parameter = 'y') and (param <> '') then
      Y := StrToInt(param);

    if (AParameters[I].parameter = 'errorid') and (param <> '') then
      ErrorType := StrToInt(param);

    if (AParameters[I].parameter = 'id') and (param <> '') then
      id := StrToInt(param);

    if (AParameters[I].parameter = 'title') and (param <> '') then
      title := param;

    if (AParameters[I].parameter = 'maptype') and (param <> '') then
      maptype := StrToInt(param);

    if (AParameters[I].parameter = 'zoomlevel') and (param <> '') then
      zoomlevel := StrToInt(param);

    if (AParameters[I].parameter = 'size') and (param <> '') then
      MarkerCount := StrToInt(param);

    if (AParameters[I].parameter = 'heading') and (param <> '') then
      heading := StrToInt(param);

    if (AParameters[I].parameter = 'pitch') and (param <> '') then
      pitch := StrToInt(param);

    if (AParameters[I].parameter = 'zoom') and (param <> '') then
      zoom := StrToInt(param);
  end;

  if AEvent = 'click' then
    MapClick(Self, Lat, Lng, X, Y);

  if AEvent = 'dblclick' then
    MapDblClick(Self, Lat, Lng, X, Y);

  if AEvent = 'boundsretrieved' then
  begin
  if Assigned(FOnBoundsRetrieved) then
    begin
      Bounds := FMX.TMSWebGMapsCommonFunctions.TBounds.Create;
      Bounds.NorthEast.Latitude := NorthEastLatitude;
      Bounds.NorthEast.Longitude := NorthEastLongitude;
      Bounds.SouthWest.Latitude := SouthWestLatitude;
      Bounds.SouthWest.Longitude := SouthWestLongitude;
      BoundsRetrieved(Self, Bounds);
      Bounds.Free;
    end;
  end;

  if AEvent = 'error' then
    GMapsError(Self, TErrorType(ErrorType));

  if AEvent = 'polylineclick' then
    PolylineClick(Self, Id);

  if AEvent = 'polylinemouseexit' then
    PolylineMouseExit(Self, Id);

  if AEvent = 'polylinemouseenter' then
    PolylineMouseEnter(Self, Id);

  if AEvent = 'polylinemousedown' then
    PolylineMouseDown(Self, Id);

  if AEvent = 'polylinemouseup' then
    PolylineMouseUp(Self, Id);

  if AEvent = 'polylinechanged' then
    PolylineChanged(Self, Id);

  if AEvent = 'polylinedblclick' then
    PolylineDblClick(Self, id);

  if AEvent = 'polygonclick' then
    PolygonClick(Self, Id);

  if AEvent = 'polygonmouseexit' then
    PolygonMouseExit(Self, Id);

  if AEvent = 'polygonmouseenter' then
    PolygonMouseEnter(Self, Id);

  if AEvent = 'polygonmousedown' then
    PolygonMouseDown(Self, Id);

  if AEvent = 'polygonmouseup' then
    PolygonMouseUp(Self, Id);

  if AEvent = 'polygonchanged' then
    PolygonChanged(Self, Id);

  if AEvent = 'polygondblclick' then
    PolygonDblClick(Self, id);

  if AEvent = 'clusterclick' then
    ClusterClick(Self, Id, MarkerCount, lat, lng);

  if AEvent = 'clustermouseexit' then
    ClusterMouseExit(Self, Id, MarkerCount, lat, lng);

  if AEvent = 'clustermouseenter' then
    ClusterMouseEnter(Self, Id, MarkerCount, lat, lng);

  if AEvent = 'markerinfowindowcloseclick' then
    MarkerInfoWindowCloseClick(Self, id);

  if AEvent = 'markerclick' then
    MarkerClick(Self, title, id, lat, lng);

  if AEvent = 'kmllayerclick' then
    KMLLayerClick(Self, title, id, lat, lng);

  if AEvent = 'routingstart' then
  begin
    FRouting := True;
    FRoutingString := '';
  end;

  if AEvent = 'routing' then
    FRoutingString := FRoutingString + title;

  if AEvent = 'routingend' then
  begin
    RoutingWaypointAdded(Self, FRoutingString);
    FRoutingString := '';
    FRouting := False;
  end;

  if AEvent = 'markerdblclick' then
    MarkerDblClick(Self, title, id, lat, lng);

  if AEvent = 'markerdragstart' then
    MarkerDragStart(Self, title, id, lat, lng);

  if AEvent = 'markerdrag' then
    MarkerDrag(Self, title, id, lat, lng);

  if AEvent = 'markerdragend' then
    MarkerDragEnd(Self, title, id, lat, lng);

  if AEvent = 'markermousedown' then
    MarkerMouseDown(Self, title, id, lat, lng);

  if AEvent = 'markermouseup' then
    MarkerMouseUp(Self, title, id, lat, lng);

  if AEvent = 'markermouseexit' then
    MarkerMouseExit(Self, title, id, lat, lng);

  if AEvent = 'markermouseenter' then
    MarkerMouseEnter(Self, title, id, lat, lng);

  if AEvent = 'streetviewmove' then
    StreetViewMove(Self, lat, lng, x, y);

  if AEvent = 'streetviewchange' then
    StreetViewChange(Self, heading, pitch, zoom);

  if AEvent = 'tilesload' then
    MapTilesLoad(Self);

  if AEvent = 'dragstart' then
    MapMoveStart(Self, lat, lng, x, y);

  if AEvent = 'dragend' then
    MapMoveEnd(Self, lat, lng, x, y);

  if AEvent = 'drag' then
    MapMove(Self, lat, lng, x, y);

  if AEvent = 'idle' then
    MapIdle(Self);

  if AEvent = 'typeidchange' then
    MapTypeChange(Self, maptype);

  if AEvent = 'mousemove' then
    MapMouseMove(Self, lat, lng, x, y);

  if AEvent = 'mouseenter' then
    MapMouseEnter(Self, lat, lng, x, y);

  if AEvent = 'mouseexit' then
    MapMouseExit(Self, lat, lng, x, y);

  if AEvent = 'zoomchange' then
    MapZoomChange(Self, zoomlevel);
end;

procedure TTMSFMXWebGMaps.Initialize;
begin
  inherited;
  try
    if not IsFMXBrowser then
    begin
      if (APIKey = '') and (APIClientID <> '') then
        Navigate(APIClientAuthURL)
      else
        Navigate(HTML_BLANK_PAGE);
      LoadHTML(InitHtmlFile);
    end;
  except
    if Assigned(FOnWebGMapsError) then
      FOnWebGMapsError(Self,etGMapsProblem);
  end;
end;

procedure TTMSFMXWebGMaps.Loaded;
begin
  inherited;
  if FReinitialize then
  begin
    Reinitialize;
    FReinitialize := False;
  end;
end;

procedure TTMSFMXWebGMaps.Reinitialize;
begin
  if not (csLoading in ComponentState) then
    LoadHTML(InitHtmlFile)
  else
    FReinitialize := True;
end;
{$ENDIF}

{$IFNDEF FMXLIB}
function TTMSFMXWebGMaps.Launch:Boolean;
var
  aStream: TStream;
  HtmlFile: String;
  dw: dword;
begin
  Result := False;
  HtmlFile := InitHtmlFile;

  if FMapOptions.FPreloaderVisible then
  begin
    Preloader.Visible := True;
    (Preloader.Picture.Graphic as TGifImage).Animate := True;
    Application.ProcessMessages;
  end;

  try
    if (APIKey = '') and (APIClientID <> '') then
      FWebBrowser.Navigate(APIClientAuthURL)
    else
      FWebBrowser.Navigate(HTML_BLANK_PAGE);

    dw := GetTickCount;

    while FWebBrowser.HandleAllocated and (FWebBrowser.ReadyState <> READYSTATE_COMPLETE) and (GetTickCount < dw + 5000) do
    begin
      Application.ProcessMessages;
    end;

    if GetTickCount > dw + 5000 then
      raise Exception.Create('Timeout initializing webbrowser');

    if Assigned(FWebBrowser.Document) then
    begin
      aStream := TStringStream.Create(HtmlFile);
      try
        try
          (FWebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(aStream));
          bLaunchFinish:=False;
          Result:=True;
        except
          if Assigned(FOnWebGMapsError) then
            FOnWebGMapsError(Self,etGMapsProblem);
        end;

      finally
        FreeAndNil(aStream);
      end;
    end
    else
    begin
      if Assigned(FOnWebGMapsError) then
        FOnWebGMapsError(Self,etGMapsProblem);
    end;
  except
    if Assigned(FOnWebGMapsError) then
      FOnWebGMapsError(Self,etGMapsProblem);
  end;
end;

procedure TTMSFMXWebGMaps.SavePathToGPSRoute(Path: TPath; AStrings: TStrings);
var
  MetaData: TGPSMetaData;
begin
  MetaData.AuthorName := 'tmssoftware';
  MetaData.AuthorLink := 'http://www.tmssoftware.com';
  MetaData.TrackName := 'WebGMapsTrack';
  MetaData.TrackType := 'Track';
  SavePathToGPSRoute(Path, AStrings, MetaData);
end;

procedure TTMSFMXWebGMaps.SavePathToGPSRoute(Path: TPath; AFileName: string);
var
  MetaData: TGPSMetaData;
begin
  MetaData.AuthorName := 'tmssoftware';
  MetaData.AuthorLink := 'http://www.tmssoftware.com';
  MetaData.TrackName := 'WebGMapsTrack';
  MetaData.TrackType := 'Track';
  SavePathToGPSRoute(Path, AFileName, MetaData);
end;

procedure TTMSFMXWebGMaps.SavePathToGPSRoute(Path: TPath; AStrings: TStrings; MetaData: TGPSMetaData);
var
  i: integer;
  hdr,ftr: string;
  ds: char;
begin
  hdr :=

    '<?xml version="1.0"?>'+
    '<gpx xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" '+
    'xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd" version="1.1" creator="TMS FMX WebGMaps" xmlns="http://www.topografix.com/GPX/1/1">'+
    '<metadata>'+
    '<author>'+
    '<name>%s</name>'+
    '<link href="%s" />'+
    '</author>'+
    '</metadata>'+
    '<trk>'+
    '<name>%s</name>'+
    '<type>%s</type>'+
    '<trkseg>';

  ftr :=
    '</trkseg>'+
    '</trk>'+
    '</gpx>';

  hdr := Format(hdr,[MetaData.AuthorName, MetaData.AuthorLink, MetaData.TrackName, MetaData.TrackType]);

  AStrings.Add(hdr);

  ds := DecimalSeparator;

  {$IFDEF DELPHIXE_LVL}
  FormatSettings.DecimalSeparator := '.';
  {$ENDIF}
  {$IFNDEF DELPHIXE_LVL}
  DecimalSeparator := '.';
  {$ENDIF}


  for i := 0 to Path.Count - 1 do
  begin
    AStrings.Add(Format('<trkpt lat="%.7f" lon="%.7f" />', [Path.Items[i].Latitude, Path.Items[i].Longitude]));
  end;

  {$IFDEF DELPHIXE_LVL}
  FormatSettings.DecimalSeparator := ds;
  {$ENDIF}
  {$IFNDEF DELPHIXE_LVL}
  DecimalSeparator := ds;
  {$ENDIF}

  AStrings.Add(ftr)
end;

procedure TTMSFMXWebGMaps.SavePathToGPSRoute(Path: TPath; AFileName: string; MetaData: TGPSMetaData);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    SavePathToGPSRoute(Path, sl);
    sl.SaveToFile(AFileName);
  finally
    sl.Free;
  end;


end;
{$ENDIF}

{$IFNDEF FMXLIB}
function TTMSFMXWebGMaps.LoadGPSRoute(AFilename: string; AColor: TAlphaColor = clRed;
  AWidth: integer = 2; ZoomToRoute: boolean = false): string;
{$ENDIF}
{$IFDEF FMXLIB}
function TTMSFMXWebGMaps.LoadGPSRoute(AFilename: string; AColor: TAlphaColor = claRed;
  AWidth: integer = 2; ZoomToRoute: boolean = false): string;
{$ENDIF}
var
  xmldoc: TXMLDocument;
  i: integer;
  iNode,nNode,sNode,pNode: IXMLNode;
  s: string;
  coords: array of TGeoCoordinate;
  pol: TPolylineItem;
  path: TPath;
  ts,ds: char;
  gpx11: boolean;
  cnt: integer;
  minlat,minlon,maxlat,maxlon: double;
  {$IFDEF FMXLIB}
  routebounds: FMX.TMSWebGMapsCommonFunctions.TBounds;
  {$ENDIF}
  {$IFNDEF FMXLIB}
  routebounds: TBounds;
  {$ENDIF}
begin
  Result := '';

  xmldoc := TXMLDocument.Create(Self);
  xmldoc.Active := true;
  xmldoc.LoadFromFile(AFileName);

  gpx11 := false;
  cnt := 0;

  iNode := xmldoc.DocumentElement.ChildNodes.FindNode('trk');

  if not Assigned(iNode) then
  begin
    iNode := xmldoc.DocumentElement.ChildNodes.FindNode('rte');
    gpx11 := true;
  end;

  if Assigned(iNode) then
  begin
    nNode := iNode.ChildNodes.FindNode('name');

    if Assigned(nNode) then
    begin
      Result := nNode.text;
    end;

    if not gpx11 then
      sNode := iNode.ChildNodes.FindNode('trkseg')
    else
      sNode := iNode;

    {$IFDEF DELPHIXE_LVL}
    ds := FormatSettings.DecimalSeparator;
    ts := FormatSettings.ThousandSeparator;

    FormatSettings.DecimalSeparator := '.';
    FormatSettings.ThousandSeparator := ',';
    {$ENDIF}
    {$IFNDEF DELPHIXE_LVL}
    ds := DecimalSeparator;
    ts := ThousandSeparator;

    DecimalSeparator := '.';
    ThousandSeparator := ',';
    {$ENDIF}

    if Assigned(sNode) then
    begin
      SetLength(coords,sNode.ChildNodes.Count);

      for i := 0 to sNode.ChildNodes.Count - 1 do
      begin
        pNode := sNode.ChildNodes[i];

        if not gpx11 or (gpx11 and (pNode.NodeName = 'rtept')) then
        begin
          if pNode.HasAttribute('lat') then
          begin
            s := pNode.Attributes['lat'];
            coords[cnt].lat := StrToFloat(s);
          end;

          if pNode.HasAttribute('lon') then
          begin
            s := pNode.Attributes['lon'];
            coords[cnt].lon := StrToFloat(s);
          end;

          inc(cnt);
        end;
      end;
    end;

    {$IFDEF DELPHIXE_LVL}
    FormatSettings.DecimalSeparator := ds;
    FormatSettings.ThousandSeparator := ts;
    {$ENDIF}
    {$IFNDEF DELPHIXE_LVL}
    DecimalSeparator := ds;
    ThousandSeparator := ts;
    {$ENDIF}
  end;

  xmldoc.Free;

  maxlon := -180;
  maxlat := -90;
  minlon := +180;
  minlat := +90;

  if ZoomToRoute then
  begin
    for i := 0 to cnt - 1 do
    begin
      if coords[i].lon < minlon then
        minlon := coords[i].lon;

      if coords[i].lat < minlat then
        minlat := coords[i].lat;

      if coords[i].lon > maxlon then
        maxlon := coords[i].lon;

      if coords[i].lat > maxlat then
        maxlat := coords[i].lat;

    end;

    if (maxlon = -180) then
      maxlon := 180;

    if (maxlat = -90) then
      maxlat := 90;

    if (minlon = 180) then
      minlon := -180;

    if (minlat = 90) then
      minlat := -90;
  end;

  path := TPath.Create(Self);

  try
    for i := 0 to cnt - 1 do
      Path.Add(coords[i].lat, coords[i].lon);

    pol := Polylines.Add(False,False,False,nil,path, AColor, 100, AWidth, True,1);

    CreateMapPolyline(pol.Polyline);
  finally
    path.Free;
  end;


  if ZoomToRoute then
  begin
    {$IFDEF FMXLIB}
    routebounds := FMX.TMSWebGMapsCommonFunctions.TBounds.Create;
    {$ENDIF}
    {$IFNDEF FMXLIB}
    routebounds := TBounds.Create;
    {$ENDIF}
    try
      routebounds.NorthEast.Latitude := maxlat;
      routebounds.NorthEast.Longitude := maxlon;

      routebounds.SouthWest.Latitude := minlat;
      routebounds.SouthWest.Longitude := minlon;
      MapZoomTo(routebounds);
    finally
      routebounds.Free;
    end;
  end;

end;

function TTMSFMXWebGMaps.LonLatToXY(Lon, Lat: double; var X, Y: integer): boolean;
var
  TempStr, XStr, YStr, LatStr, LonStr: String;
begin
  Result := false;

  LatStr := StringReplace(FloatToStr(Lat), DecimalSeparator, '.', []);
  LonStr := StringReplace(FloatToStr(Lon), DecimalSeparator, '.', []);
  TempStr := Trim(InvokeScript('getLatLngToXY(' + LatStr + ', ' + LonStr + ');'));
  X := -1;
  Y := -1;

  if TempStr <> '' then
  begin
    // Get the X Pos
    Delete(TempStr, 1, Pos('XPOS[', TempStr) + 4);
    XStr := Copy(TempStr, 1, Pos(']', TempStr ) -1);
    X := StrToIntDef(XStr , -1);
    Delete(TempStr, 1, Pos(']', TempStr));

    // Get the Y Pos
    Delete(TempStr, 1, Pos('YPOS[', TempStr) + 4);
    YStr := Copy(TempStr, 1, Pos( ']', TempStr) - 1);
    Y := StrToIntDef(YStr, -1);
    Delete(TempStr, 1, Pos(']', TempStr));

    Result := true;
  end;
end;

procedure TTMSFMXWebGMaps.MapMouseEnter(Sender: TObject;Latitude, Longitude: Double; X, Y: Integer);
begin
  if Assigned(FOnMapMouseEnter) then
    FOnMapMouseEnter(Sender,Latitude,Longitude,FoundMousePosition.X,FoundMousePosition.Y);
end;

procedure TTMSFMXWebGMaps.MapMouseExit(Sender: TObject;Latitude, Longitude: Double; X, Y: Integer);
begin
  if Assigned(FOnMapMouseExit) then
    FOnMapMouseExit(Sender,Latitude,Longitude,FoundMousePosition.X,FoundMousePosition.Y);
end;

procedure TTMSFMXWebGMaps.MapMouseMove(Sender: TObject;Latitude, Longitude: Double;X,Y:Integer);
begin
  if Assigned(FOnMapMouseMove) then
    FOnMapMouseMove(Sender,Latitude,Longitude,FoundMousePosition.X,FoundMousePosition.Y);
end;

function TTMSFMXWebGMaps.MapPanBy(X, Y: Integer): Boolean;
begin
  Result:=ExecJScript('map.panBy('+inttostr(X)+', '+inttostr(Y)+');');
end;

function TTMSFMXWebGMaps.MapPanTo(Latitude, Longitude: Double): Boolean;
var
  TextLat,TextLng:String;
begin
  TextLat := ConvertCoordinateToString(Latitude);
  TextLng := ConvertCoordinateToString(Longitude);
  Result:=ExecJScript('map.panTo(new google.maps.LatLng('+TextLat+', '+TextLng+'));');
end;

function TTMSFMXWebGMaps.MapZoomTo(Bounds: FMX.TMSWebGMapsCommonFunctions.TBounds): Boolean;
var
  neTextLat,neTextLng,swTextLat,swTextLng:String;
begin
  neTextLat := ConvertCoordinateToString(Bounds.NorthEast.Latitude);
  neTextLng := ConvertCoordinateToString(Bounds.NorthEast.Longitude);
  swTextLat := ConvertCoordinateToString(Bounds.SouthWest.Latitude);
  swTextLng := ConvertCoordinateToString(Bounds.SouthWest.Longitude);
  Result:=ExecJScript('map.fitBounds(new google.maps.LatLngBounds(new google.maps.LatLng('+swTextLat+', '+swTextLng+'), new google.maps.LatLng('+neTextLat+', '+neTextLng+')));');
end;

procedure TTMSFMXWebGMaps.MapTilesLoad(Sender: TObject);
var
  i: Integer;
begin
  if not(bLaunchFinish) then
  begin
    bLaunchFinish:=True;
    {$IFNDEF FMXLIB}
    if Document2<>nil then
    begin
      Document2.Body.style.overflow:= 'hidden';
      Document2.body.style.borderstyle := 'none';
    end;
    (Preloader.Picture.Graphic as TGifImage).Animate:=False;
    Preloader.Visible:=False;
    {$ENDIF}
    if Markers.Count>0 then
    begin
      for i := 0 to Markers.Count - 1 do
      begin
        CreateMapMarker(Markers[i]);
      end;
    end;
    if Polylines.Count>0 then
    begin
      for i := 0 to Polylines.Count - 1 do
      begin
        CreateMapPolyline(Polylines[i].Polyline);
      end;
    end;
    if Polygons.Count>0 then
    begin
      for i := 0 to Polygons.Count - 1 do
      begin
        CreateMapPolygon(Polygons[i].Polygon);
      end;
    end;
    if FStreetViewOptions.FVisible then
      FStreetViewOptions.InitStreetView;
    {$IFNDEF FMXLIB}
    FWebBrowser.Visible:=True;
    {$ENDIF}
    if Assigned(FOnDownloadFinish) then
      FOnDownloadFinish(Self);
  end;

  if Assigned(FOnMapTilesLoad) then
    FOnMapTilesLoad(Self);
end;

procedure TTMSFMXWebGMaps.MapTypeChange(Sender: TObject;NewMapType: Integer);
begin
  FMapOptions.FMapType:=TMapType(NewMapType);
  if Assigned(FOnMapTypeChange) then
    FOnMapTypeChange(Sender,TMapType(NewMapType));
end;

procedure TTMSFMXWebGMaps.MapMove(Sender: TObject;Latitude, Longitude: Double; X, Y: Integer);
begin
  if Assigned(FOnMapMove) then
    FOnMapMove(Sender,Latitude,Longitude,FoundMousePosition.X,FoundMousePosition.Y);
end;

procedure TTMSFMXWebGMaps.MapMoveEnd(Sender: TObject;Latitude, Longitude: Double;X,Y:Integer);
begin
  FMapOptions.FDefaultLatitude  := Latitude;
  FMapOptions.FDefaultLongitude := Longitude;
  if Assigned(FOnMapMoveEnd) then
    FOnMapMoveEnd(Sender,Latitude,Longitude,FoundMousePosition.X,FoundMousePosition.Y);
end;

procedure TTMSFMXWebGMaps.MapMoveStart(Sender: TObject;Latitude, Longitude: Double;X,Y:Integer);
begin
  if Assigned(FOnMapMoveStart) then
    FOnMapMoveStart(Sender,Latitude,Longitude,FoundMousePosition.X,FoundMousePosition.Y);
end;

{$IFNDEF FMXLIB}
{$IFDEF DELPHIXE2_LVL}
procedure TTMSFMXWebGMaps.OnBeforeNav(ASender: TObject; const pDisp: IDispatch;
  const URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
  var Cancel: WordBool);
{$ELSE}
procedure TTMSFMXWebGMaps.OnBeforeNav(ASender: TObject; const pDisp: IDispatch;
  var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
  var Cancel: WordBool);
{$ENDIF}
begin
  if Assigned(FOnDownloadStart) then
    FOnDownloadStart(Self);
end;

procedure TTMSFMXWebGMaps.OnProgressChange(Sender: TObject; Progress, ProgressMax: Integer);
begin
  if Assigned(FOnDownloadProgress) then
    FOnDownloadProgress(Sender,Progress,ProgressMax);
end;
{$ENDIF}

function TTMSFMXWebGMaps.OpenMarkerInfoWindowHtml(Id: Integer; HtmlText: String): Boolean;
begin
  HtmlText := StringReplace(HtmlText, '"', '\"', [rfReplaceAll]);
  Result:=ExecJScript('openMarkerInfoWindowHtml('+inttostr(Id)+',"'+HtmlText+'");');
end;

{$IFNDEF FMXLIB}

function TTMSFMXWebGMaps.ScreenShot(ImgType:TImgType): TGraphic;
var
  viewObject : IViewObject;
  r : Trect;
  BmpImage:TBitmap;
begin
  Result:=nil;
  if Document2 <> nil then
  begin
    Document2.QueryInterface(IViewObject, viewObject) ;
    if Assigned(viewObject) then
    begin
      try
        BmpImage:=TBitmap.Create;
        r := Rect(0, 0, Width, Height) ;
        BmpImage.Height := Height;
        BmpImage.Width := Width;
        viewObject.Draw(DVASPECT_CONTENT, 1, nil, nil, Application.Handle, BmpImage.Canvas.Handle, @r, nil, nil, 0) ;
        viewObject._Release;
        case ImgType of
          itBitmap:
            begin
              Result:=TBitmap.Create;
              Result.Assign(BmpImage);
            end;
          itJpeg:
            begin
              Result:=TJPEGImage.Create;
              Result.Assign(BmpImage);
            end;
{$IFNDEF VER185}
          itPng:
            begin
              Result:=TPngImage.Create;
              Result.Assign(BmpImage);
            end;
{$ENDIF}
        end;
        FreeAndNil(BmpImage);
      except
        begin
          Result:=nil;
          if Assigned(fOnWebGMapsError) then
            fOnWebGMapsError(Self,etScreenshotProblem);
        end;
      end;
    end;
  end;
end;
{$ENDIF}

procedure TTMSFMXWebGMaps.SetAPIKey(const Value: string);
begin
  FAPIKey := Value;
  {$IFDEF FMXLIB}
  Reinitialize;
  {$ENDIF}
end;

procedure TTMSFMXWebGMaps.SetClusters(const Value: TClusters);
begin
  FClusters := Value;
end;

procedure TTMSFMXWebGMaps.SetControlsOptions(const Value: TControlsOptions);
begin
  FControlsOptions := Value;
end;

{$IFDEF DELPHIXE_LVL}
procedure TTMSFMXWebGMaps.SetCurrentLocation(const Value: TLocation);
begin
  FCurrentLocation := Value;
end;
{$ENDIF}

procedure TTMSFMXWebGMaps.SetDirections(const Value: TDirections);
begin
  FDirections := Value;
end;

procedure TTMSFMXWebGMaps.SetElevations(const Value: TElevations);
begin
  FElevations := Value;
end;

procedure TTMSFMXWebGMaps.SetMapOptions(const Value: TMapOptions);
begin
  FMapOptions := Value;
end;

{$IFNDEF FMXLIB}
procedure TTMSFMXWebGMaps.SetMapPersist(const Value: TMapPersist);
begin
  FMapPersist.Assign(Value);
end;
{$ENDIF}

procedure TTMSFMXWebGMaps.SetMapRouting(const Value: TMapRouting);
begin
  FMapRouting := Value;
end;

procedure TTMSFMXWebGMaps.SetMarkers(const Value: TMarkers);
begin
  FMarkers := Value;
end;

procedure TTMSFMXWebGMaps.SetPolygons(const Value: TPolygons);
begin
  FPolygons := Value;
end;

procedure TTMSFMXWebGMaps.SetPolylines(const Value: TPolylines);
begin
  FPolylines := Value;
end;

procedure TTMSFMXWebGMaps.SetShowDebugConsole(const Value: boolean);
begin
  FShowDebugConsole := Value;
  {$IFDEF FMXLIB}
  Reinitialize;
  {$ENDIF}
end;

procedure TTMSFMXWebGMaps.SetStreetViewOptions(const Value: TStreetViewOptions);
begin
  FStreetViewOptions := Value;
end;

procedure TTMSFMXWebGMaps.SetVersion(const Value: string);
begin

end;

procedure TTMSFMXWebGMaps.SetWeatherOptions(const Value: TWeatherOptions);
begin
  FWeatherOptions := Value;
end;

{$IFNDEF FMXLIB}
procedure TTMSFMXWebGMaps.SetWebBrowser(const Value: TNewWebBrowser);
begin
  FWebBrowser := Value;
end;
{$ENDIF}

function TTMSFMXWebGMaps.StartMarkerBounceAnimation(Id: Integer): Boolean;
begin
  Result:=ExecJScript('startMarkerBounceAnimation('+inttostr(Id)+');');
end;

function TTMSFMXWebGMaps.StopMarkerBounceAnimation(Id: Integer): Boolean;
begin
  Result:=ExecJScript('stopMarkerBounceAnimation('+inttostr(Id)+');');
end;

procedure TTMSFMXWebGMaps.StreetViewChange(Sender: TObject; Heading, Pitch,
  Zoom: Integer);
begin
  if Heading < 0 then
    Heading := 360 + Heading
  else if Heading > 360 then
    Heading := Heading - 360;

  if Pitch < -90 then
    Pitch := -90
  else if Pitch > 90 then
    Pitch := 90;

  if Zoom < 0 then
    Zoom := 0
  else if Zoom > 5 then
    Zoom := 5;

  StreetViewOptions.Heading:=Heading;
  StreetViewOptions.Pitch:=Pitch;
  StreetViewOptions.Zoom:=Zoom;
  if Assigned(FOnStreetViewChange) then
    FOnStreetViewChange(Sender,Heading,Pitch,Zoom);
end;

procedure TTMSFMXWebGMaps.StreetViewMove(Sender: TObject;Latitude, Longitude: Double; X, Y: Integer);
begin
  StreetViewOptions.DefaultLatitude:=Latitude;
  StreetViewOptions.DefaultLongitude:=Longitude;
  if Assigned(FOnStreetViewMove) then
    FOnStreetViewMove(Sender,Latitude,Longitude,FoundMousePosition.X,FoundMousePosition.Y);
end;

procedure TTMSFMXWebGMaps.SwitchToMap;
begin
  MapOptions.DefaultLatitude := StreetViewOptions.DefaultLatitude;
  MapOptions.DefaultLongitude := StreetViewOptions.DefaultLongitude;
  StreetViewOptions.Visible := false;
end;

procedure TTMSFMXWebGMaps.SwitchToStreetView;
begin
  StreetViewOptions.DefaultLatitude := MapOptions.DefaultLatitude;
  StreetViewOptions.DefaultLongitude := MapOptions.DefaultLongitude;
  StreetViewOptions.Visible := true;
end;

procedure TTMSFMXWebGMaps.MapZoomChange(Sender: TObject;NewLevel: Integer);
begin
  FMapOptions.FZoomMap := NewLevel;
  if Assigned(FOnMapZoomChange) then
    FOnMapZoomChange(Sender,NewLevel);
end;


function TTMSFMXWebGMaps.InvokeScript(const AScript: String): String;
{Use InvokeScript when you need the result from a JavaScript function.
 It first calls/uses ExecJScript to execute the function, then saves the result
 into a hidden input (i.e. "result") that has been declared in
 FMX.TMSWebGMapsConst.pas (see const HTML_FILE_1). }

{$IFNDEF FMXLIB}
  function GetElementIdValue(AWebBrowser: TWebBrowser;
    TagName, TagId, TagAttrib: string):string;
  var
    Document: IHTMLDocument2;
    Body: IHTMLElement2;
    Tags: IHTMLElementCollection;
    Tag: IHTMLElement;
    I: Integer;
  begin
    Result:='';
    if not Supports(AWebBrowser.Document, IHTMLDocument2, Document) then
      raise Exception.Create('Invalid HTML document');
    if not Supports(document.body, IHTMLElement2, Body) then
      raise Exception.Create('Can''t find <body> element');
    Tags := body.getElementsByTagName(UpperCase(TagName));
    for I := 0 to Pred(Tags.length) do begin
      Tag:=Tags.item(I, EmptyParam) as IHTMLElement;
      if Tag.id=TagId then Result := Tag.getAttribute(TagAttrib, 0);
    end;
  end;

begin
  Result := '';

  // Run the script
  if ExecJScript(AScript) then
  begin
    // Get the result
    Result := GetElementIdValue(FWebBrowser, 'input', 'result', 'value')
  end;
{$ENDIF}
{$IFDEF FMXLIB}
begin
  Result := '';
  raise Exception.Create('Implement Invoke Script');
{$ENDIF}
end;

procedure TTMSFMXWebGMaps.GetPolygonCircleFromJavaScript(
  var APolygon: string; Index: Integer);
begin
  APolygon := Trim(InvokeScript('printPolygonCircle(' + IntToStr(Index) + ');'));
end;

procedure TTMSFMXWebGMaps.GetPolygonRectangleFromJavaScript(var APolygon: string;
  Index: integer);
begin
  APolygon := Trim(InvokeScript('printPolygonRectangle(' + IntToStr(Index) + ');'));
end;

procedure TTMSFMXWebGMaps.GetPolygonFromJavaScript(var APolygon: TStringlist;
  Index: Integer);
begin
  APolygon.Clear;
  APolygon.Delimiter := ';';
  APolygon.StrictDelimiter := True;
  APolygon.DelimitedText := Trim(InvokeScript('printPolygon(' + IntToStr(Index) + ');'));
end;

procedure TTMSFMXWebGMaps.GetPolylineFromJavaScript(var APolyline: TStringlist;
  Index: Integer);
begin
  APolyline.Clear;
  APolyline.Delimiter := ';';
  APolyline.StrictDelimiter := True;
  APolyline.DelimitedText := Trim(InvokeScript('printPolyline(' + IntToStr(Index) + ');'));
end;


{ TMapOptions }

procedure TMapOptions.Assign(Source: TPersistent);
begin
  if (Source is TMapOptions) then
  begin
    FDraggable := (Source as TMapOptions).Draggable;
    FDisableDoubleClickZoom := (Source as TMapOptions).DisableDoubleClickZoom;
    FDisableControls := (Source as TMapOptions).DisableControls;
    FDisablePOI := (Source as TMapOptions).DisablePOI;
    FEnableKeyboard := (Source as TMapOptions).EnableKeyboard;
    FScrollWheel := (Source as TMapOptions).ScrollWheel;
    FShowTraffic := (Source as TMapOptions).ShowTraffic;
    FShowBicycling := (Source as TMapOptions).ShowBicycling;
    FShowPanoramio := (Source as TMapOptions).ShowPanoramio;
    FShowCloud := (Source as TMapOptions).ShowCloud;
    FDefaultLatitude := (Source as TMapOptions).DefaultLatitude;
    FDefaultLongitude := (Source as TMapOptions).DefaultLongitude;
    {$IFDEF DELPHIXE_LVL}
    FDefaultToCurrentLocation := (Source as TMapOptions).DefaultToCurrentLocation;
    {$ENDIF}
    {$IFNDEF FMXLIB}
    FPreloaderVisible := (Source as TMapOptions).PreloaderVisible;
    {$ENDIF}
    FZoomMap := (Source as TMapOptions).ZoomMap;
    FMapType := (Source as TMapOptions).MapType;
    FLanguage := (Source as TMapOptions).Language;
  end;
end;

constructor TMapOptions.Create(AWebGmaps: TTMSFMXWebGMaps);
begin
  inherited Create;
  FWebGmaps               := AWebGmaps;
  FDraggable              := True;
  FDisableDoubleClickZoom := False;
  FDisableControls        := False;
  FDisablePOI             := False;
  FEnableKeyboard         := True;
  FScrollWheel            := True;
  FShowTraffic            := False;
  FShowBicycling          := False;
  FShowPanoramio          := False;
  FShowCloud              := False;
  FDefaultLatitude        := DEFAULT_LATITUDE;
  FDefaultLongitude       := DEFAULT_LONGITUDE;
  {$IFDEF DELPHIXE_LVL}
  FDefaultToCurrentLocation := false;
  {$ENDIF}
  {$IFNDEF FMXLIB}
  FPreloaderVisible       := False;
  {$ENDIF}
  FZoomMap                := DEFAULT_ZOOM;
  FZoomMarker             := zmNone;
  FMapType                := mtDefault;
  FLanguage               := lnDefault;
end;

procedure TMapOptions.SetDefaultLatitude(const Value: Double);
begin
  FDefaultLatitude := Value;
end;

procedure TMapOptions.SetDefaultLongitude(const Value: Double);
begin
  FDefaultLongitude := Value;
end;

{$IFDEF DELPHIXE_LVL}
procedure TMapOptions.SetDefaultToCurrentLocation(const Value: Boolean);
begin
  FDefaultToCurrentLocation := Value;
end;
{$ENDIF}

procedure TMapOptions.SetDisableControls(const Value: Boolean);
begin
  FDisableControls := Value;
  if Value then
    FWebGmaps.ExecJScript('map.setOptions( {disableDefaultUI:true} );')
  else
    FWebGmaps.ExecJScript('map.setOptions( {disableDefaultUI:false} );');
end;

procedure TMapOptions.SetDisableDoubleClickZoom(const Value: Boolean);
begin
  FDisableDoubleClickZoom := Value;
  if Value then
    FWebGmaps.ExecJScript('map.setOptions( {disableDoubleClickZoom:true} );')
  else
    FWebGmaps.ExecJScript('map.setOptions( {disableDoubleClickZoom:false} );');
end;

procedure TMapOptions.SetDisablePOI(const Value: Boolean);
begin
  FDisablePOI := Value;
end;

procedure TMapOptions.SetDisableTilt(const Value: Boolean);
begin
  FDisableTilt := Value;
  if Value then
    FWebGmaps.ExecJScript('map.setOptions( {tilt: 0 } );')
  else
    FWebGmaps.ExecJScript('map.setOptions( {tilt: 45 } );')
end;

procedure TMapOptions.SetDraggable(const Value: Boolean);
begin
  FDraggable := Value;
  if Value then
    FWebGmaps.ExecJScript('map.setOptions( {draggable:true} );')
  else
    FWebGmaps.ExecJScript('map.setOptions( {draggable:false} );')
end;

procedure TMapOptions.SetEnableKeyboard(const Value: Boolean);
begin
  FEnableKeyboard := Value;
  if Value then
    FWebGmaps.ExecJScript('map.setOptions( {keyboardShortcuts:true} );')
  else
    FWebGmaps.ExecJScript('map.setOptions( {keyboardShortcuts:false} );');
end;

procedure TMapOptions.SetLanguage(const Value: TLanguageName);
begin
  FLanguage := Value;
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2<>nil) and (FWebGmaps.FWebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  begin
    FWebGmaps.Launch;
  end;
  {$ENDIF}
  {$IFDEF FMXLIB}
  FWebGMaps.Reinitialize;
  {$ENDIF}
end;

procedure TMapOptions.SetMapType(const Value: TMapType);
begin
  FMapType := Value;
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2<>nil) and (FWebGmaps.FWebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    case Value of
      mtDefault:
        FWebGmaps.ExecJScript('map.setMapTypeId('+MAP_TYPE_PREFIX+MAP_DEFAULT+');');
      mtSatellite:
        FWebGmaps.ExecJScript('map.setMapTypeId('+MAP_TYPE_PREFIX+MAP_SATELLITE+');');
      mtHybrid:
        FWebGmaps.ExecJScript('map.setMapTypeId('+MAP_TYPE_PREFIX+MAP_HYBRID+');');
      mtTerrain:
        FWebGmaps.ExecJScript('map.setMapTypeId('+MAP_TYPE_PREFIX+MAP_TERRAIN+');');
    end;
  end;
end;

{$IFNDEF FMXLIB}
procedure TMapOptions.SetPreloaderVisible(const Value: Boolean);
begin
  FPreloaderVisible := Value;
end;
{$ENDIF}

procedure TMapOptions.SetScrollWheel(const Value: Boolean);
begin
  FScrollWheel := Value;
  if Value then
    FWebGmaps.ExecJScript('map.setOptions( {scrollwheel:true} );')
  else
    FWebGmaps.ExecJScript('map.setOptions( {scrollwheel:false} );');
end;

procedure TMapOptions.SetShowBicycling(const Value: Boolean);
begin
  FShowBicycling := Value;
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2<>nil) and (FWebGmaps.FWebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
      FWebGmaps.ExecJScript('ShowBicycling();')
    else
      FWebGmaps.ExecJScript('HideBicyling();');
  end;
end;

procedure TMapOptions.SetShowCloud(const Value: Boolean);
begin
  FShowCloud := Value;
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2<>nil) and (FWebGmaps.FWebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
      FWebGmaps.ExecJScript('ShowCloud();')
    else
      FWebGmaps.ExecJScript('HideCloud();');
  end;
end;

procedure TMapOptions.SetShowPanoramio(const Value: Boolean);
begin
  FShowPanoramio := Value;
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2<>nil) and (FWebGmaps.FWebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
      FWebGmaps.ExecJScript('ShowPanoramio();')
    else
      FWebGmaps.ExecJScript('HidePanoramio();');
  end;
end;

procedure TMapOptions.SetShowTraffic(const Value: Boolean);
begin
  FShowTraffic := Value;
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2<>nil) and (FWebGmaps.FWebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
      FWebGmaps.ExecJScript('ShowTraffic();')
    else
      FWebGmaps.ExecJScript('HideTraffic();');
  end;
end;

procedure TMapOptions.SetShowWeather(const Value: Boolean);
begin
  FShowWeather := Value;
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2<>nil) and (FWebGmaps.FWebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
      FWebGmaps.ExecJScript('ShowWeather();')
    else
      FWebGmaps.ExecJScript('HideWeather();');
  end;
end;

procedure TMapOptions.SetZoomMap(const Value: TZoomMap);
begin
  FZoomMap := Value;
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2<>nil) and (FWebGmaps.FWebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
    FWebGmaps.ExecJScript('setzoommap('+inttostr(Value)+');');
end;

procedure TMapOptions.SetZoomMarker(const Value: TZoomMarker);
begin
  FZoomMarker := Value;
end;

{ TStreetViewOptions }

procedure TStreetViewOptions.Assign(Source: TPersistent);
begin
  if (Source is TStreetViewOptions) then
  begin
     FDefaultLatitude := (Source as TStreetViewOptions).DefaultLatitude;
     FDefaultLongitude := (Source as TStreetViewOptions).DefaultLongitude;
     FHeading := (Source as TStreetViewOptions).Heading;
     FPitch := (Source as TStreetViewOptions).Pitch;
     FZoom := (Source as TStreetViewOptions).Zoom;
     FVisible := (Source as TStreetViewOptions).Visible;
  end;
end;

constructor TStreetViewOptions.Create(AWebGmaps: TTMSFMXWebGMaps);
begin
  inherited Create;
  FWebGmaps          := AWebGmaps;
  FDefaultLatitude   := DEFAULT_LATITUDE;
  FDefaultLongitude  := DEFAULT_LONGITUDE;
  FHeading           := 0;
  FZoom              := 0;
  FPitch             := 0;
end;

procedure TStreetViewOptions.InitStreetView;
var
  TextLat,TextLng:String;
begin
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2<>nil) and (not(csDesigning in FWebGmaps.ComponentState)) then
  {$ENDIF}
  begin
    TextLat := ConvertCoordinateToString(FDefaultLatitude);
    TextLng := ConvertCoordinateToString(FDefaultLongitude);
    FWebGmaps.ExecJScript('showStreetview("'+TextLat+'", "'+TextLng+'", '+
                                             inttostr(FHeading)+', '+
                                             inttostr(FZoom)+', '+
                                             inttostr(FPitch)+' );');
  end;
end;

procedure TStreetViewOptions.SetDefaultLatitude(const Value: Double);
begin
  FDefaultLatitude := Value;
end;

procedure TStreetViewOptions.SetDefaultLongitude(const Value: Double);
begin
  FDefaultLongitude := Value;
end;

procedure TStreetViewOptions.SetHeading(const Value: THeadingStreetView);
begin
  FHeading := Value;
end;

procedure TStreetViewOptions.SetPitch(const Value: TPitchStreetView);
begin
  FPitch := Value;
end;

procedure TStreetViewOptions.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2 <> nil) and (FWebGmaps.FWebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
    begin
      InitStreetView;
    end
    else
      FWebGmaps.ExecJScript('streetviewPanorama.setVisible(false);');
  end;
end;

procedure TStreetViewOptions.SetZoom(const Value: TZoomStreetView);
begin
  FZoom := Value;
end;

{ TWeatherOptions }

procedure TWeatherOptions.Assign(Source: TPersistent);
begin
  if (Source is TWeatherOptions) then
  begin
    FTemperatureUnit := (Source as TWeatherOptions).TemperatureUnit;
    FWindSpeedUnit := (Source as TWeatherOptions).WindSpeedUnit;
    FLabelColor := (Source as TWeatherOptions).LabelColor;
    FShowInfoWindows := (Source as TWeatherOptions).ShowInfoWindows;
  end;
end;

constructor TWeatherOptions.Create(AWebGmaps: TTMSFMXWebGMaps);
begin
  inherited Create;
  FWebGmaps        := AWebGmaps;
  FTemperatureUnit := wtCelsius;
  FWindSpeedUnit   := wwsKilometersPerHour;
  FLabelColor      := wlcBlack;
  FShowInfoWindows := True;
end;

procedure TWeatherOptions.SetLabelColor(const Value: TWeatherLabelColor);
begin
  FLabelColor := Value;
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2<>nil) and (FWebGmaps.FWebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    case Value of
      wlcBlack:
        FWebGmaps.ExecJScript('weatherLayer.setOptions( {labelColor:google.maps.weather.LabelColor.'+WEATHER_LABEL_COLOR_BLACK+'} );');
      wlcWhite:
        FWebGmaps.ExecJScript('weatherLayer.setOptions( {labelColor:google.maps.weather.LabelColor.'+WEATHER_LABEL_COLOR_WHITE+'} );');
    end;
  end;
end;

procedure TWeatherOptions.SetShowInfoWindows(const Value: Boolean);
begin
  FShowInfoWindows := Value;
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2<>nil) and (FWebGmaps.FWebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    if Value then
    begin
      FWebGmaps.ExecJScript('weatherLayer.setOptions( {suppressInfoWindows:false} );');
    end
    else
    begin
      FWebGmaps.ExecJScript('weatherLayer.setOptions( {suppressInfoWindows:true} );');
    end;
  end;
end;

procedure TWeatherOptions.SetTemperatureUnit(const Value: TWeatherTemperatures);
begin
  FTemperatureUnit := Value;
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2<>nil) and (FWebGmaps.FWebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    case Value of
      wtCelsius:
        FWebGmaps.ExecJScript('weatherLayer.setOptions( {temperatureUnits:google.maps.weather.TemperatureUnit.'+WEATHER_TEMPERATURE_CELSIUS+'} );');
      wtFahrenheit:
        FWebGmaps.ExecJScript('weatherLayer.setOptions( {temperatureUnits:google.maps.weather.TemperatureUnit.'+WEATHER_TEMPERATURE_FAHRENHEIT+'} );');
    end;
  end;
end;

procedure TWeatherOptions.SetWindSpeedUnit(const Value: TWeatherWindSpeed);
begin
  FWindSpeedUnit := Value;
  {$IFNDEF FMXLIB}
  if (FWebGmaps.HTMLWindow2<>nil) and (FWebGmaps.FWebBrowser.Visible) and (not(csDesigning in FWebGmaps.ComponentState))then
  {$ENDIF}
  begin
    case Value of
      wwsKilometersPerHour:
        FWebGmaps.ExecJScript('weatherLayer.setOptions( {windSpeedUnits:google.maps.weather.WindSpeedUnit.'+WEATHER_WIND_SPEED_KILOMETERS_PER_HOUR+'} );');
      wwsMetersPerSecond:
        FWebGmaps.ExecJScript('weatherLayer.setOptions( {windSpeedUnits:google.maps.weather.WindSpeedUnit.'+WEATHER_WIND_SPEED_METERS_PER_SECOND+'} );');
      wwsMilesPerHour:
        FWebGmaps.ExecJScript('weatherLayer.setOptions( {windSpeedUnits:google.maps.weather.WindSpeedUnit.'+WEATHER_WIND_SPEED_MILES_PER_HOUR+'} );');
    end;
  end;
end;


{$IFNDEF FMXLIB}

{ THTMLEventLink }

constructor THTMLEventLink.Create(Handler: THTMLProcEvent);
begin
  inherited Create;
  _AddRef;
  FOnEvent := Handler;
end;

destructor THTMLEventLink.Destroy;
begin
//  _Release;
  inherited Destroy;
end;

function THTMLEventLink.GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;

function THTMLEventLink.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
begin
  Result := E_NOTIMPL;
end;

function THTMLEventLink.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Result := E_NOTIMPL;
end;

function THTMLEventLink.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult;
var
  HTMLEventObjIfc: IHTMLEventObj;
begin
  Result := S_OK;
  if Assigned(FOnEvent) then FOnEvent(Self, HTMLEventObjIfc);
end;
{$ENDIF}

{ TElevationItem }

procedure TElevationItem.Assign(Source: TPersistent);
begin
  if (Source is TElevationItem) then
  begin
    FElevation := (Source as TElevationItem).Elevation;
    FLatitude := (Source as TElevationItem).Latitude;
    FLongitude := (Source as TElevationItem).Longitude;
  end;
end;

constructor TElevationItem.Create(Collection: TCollection);
begin
  inherited;
  FWebGMaps := TElevations(Collection).FWebGMaps;
  FElevation := 0;
  FLatitude := 0;
  FLongitude := 0;
end;

{$IFDEF DELPHIXE_LVL}
procedure TElevationItem.FromJSON(jo: TJSONObject);
var
  fo: TJSONObject;
  jp: TJSONPair;
begin
  jp := jo.Get('elevation');
  if Assigned(jp) then
    FElevation := StrToFloat(GetJSONProp(jo,'elevation'));

  jp := jo.Get('location');
  if Assigned(jp) then
  begin
    fo := GetJSONValue(jo,'location') as TJSONObject;

    Latitude := StrToFloat(GetJSONProp(fo,'lat'));
    Longitude := StrToFloat(GetJSONProp(fo,'lng'));
  end;

  jp := jo.Get('resolution');
  if Assigned(jp) then
    FResolution := StrToFloat(GetJSONProp(jo,'resolution'));
end;
{$ENDIF}

destructor TElevationItem.Destroy;
begin
  inherited;
end;

procedure TElevationItem.SetElevation(const Value: Double);
begin
  FElevation := Value;
end;

procedure TElevationItem.SetLatitude(const Value: Double);
begin
  FLatitude := Value;
end;

procedure TElevationItem.SetLongitude(const Value: Double);
begin
  FLongitude := Value;
end;

procedure TElevationItem.SetResolution(const Value: Double);
begin
  FResolution := Value;
end;

{ TElevations }

function TElevations.Add: TElevationItem;
begin
  Result := TElevationItem(inherited Add);
end;

constructor TElevations.Create(AWebGMaps: TControl);
begin
  inherited Create(TElevationItem);
  FWebGMaps := AWebGMaps;
end;

function TElevations.GetItem(Index: integer): TElevationItem;
begin
  Result := TElevationItem(inherited GetItem(Index));
end;

function TElevations.GetOwner: TPersistent;
begin
  Result := FWebGMaps;
end;

procedure TElevations.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
end;

procedure TElevations.SetItem(Index: integer; Value: TElevationItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TElevations.Update(Item: TCollectionItem);
begin
  inherited;
end;


{------------------------------------------------------------------------------}

{$IFNDEF FMXLIB}

{ TMapPersist }

procedure TMapPersist.Assign(Source: TPersistent);
begin
  if (Source is TMapPersist) then
  begin
    FLocation := (Source as TMapPersist).Location;
    FKey := (Source as TMapPersist).Key;
    FSection := (Source as TMapPersist).Section;
  end;
end;

constructor TMapPersist.Create;
begin
  inherited;
  FKey := 'WebGMaps';
  FSection := 'MapBounds';
end;

{$ENDIF}

{ TMapRouting }

procedure TMapRouting.Assign(Source: TPersistent);
begin
  if (Source is TMapRouting) then
  begin
    FEnabled := (Source as TMapRouting).Enabled;
    FRoutingType := (Source as TMapRouting).RoutingType;
    FRoutingMarkers := (Source as TMapRouting).Markers;
    FMarkerColor := (Source as TMapRouting).MarkerColor;
    FMarkerIcon := (Source as TMapRouting).MarkerIcon;
    FPath.Assign((Source as TMapRouting).Path);
    FWayPoints.Assign((Source as TMapRouting).WayPoints);
  end;
end;

procedure TMapRouting.Clear;
begin
  Path.Clear;
  WayPoints.Clear;
  FRoutingWaypoints.Clear;
  (FWebGMaps as TTMSFMXWebGMaps).Markers.Clear;
  (FWebGMaps as TTMSFMXWebGMaps).Polylines.Clear;
  (FWebGMaps as TTMSFMXWebGMaps).DeleteAllMapPolyline;
end;

constructor TMapRouting.Create(AWebGMaps: TControl);
begin
  inherited Create;
  FWebGMaps := AWebGMaps;
  FEnabled := false;
  FRoutingType := rtClick;
  FRoutingMarkers := rmDefault;
  FMarkerColor := icRed;
  FPath := TPath.Create;
  FPolylineOptions := TMapPolylineOptions.Create;
  FWayPoints := TPath.Create;
  FRoutingWaypoints := TRoutingWaypoints.Create;
end;

destructor TMapRouting.Destroy;
begin
  FPath.Free;
  FPolylineOptions.Free;
  FWayPoints.Free;
  FRoutingWaypoints.Free;
  inherited;
end;

function TMapRouting.GetDistance: integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FRoutingWaypoints.Count - 1 do
  begin
    Result := Result + FRoutingWaypoints[I].Distance;
  end;
  if Units = usImperial then
  begin
    Result := Round(Result * 3.2808399);
  end;
end;

function TMapRouting.GetEndAddress: string;
begin
  Result := '';
  if FRoutingWaypoints.Count > 0 then
    Result := FRoutingWaypoints[FRoutingWaypoints.Count - 1].Address;
end;

function TMapRouting.GetStartAddress: string;
begin
  Result := '';
  if FRoutingWaypoints.Count > 0 then
    Result := FRoutingWaypoints[0].Address;
end;

procedure TMapRouting.RemoveLastWayPoint;
var
  I: integer;
  foundWayPoint: boolean;
begin
  if WayPoints.Count > 0 then
  begin
    {$IFNDEF DELPHI_LLVM}
    WayPoints[WayPoints.Count - 1].Free;
    {$ENDIF}
    {$IFDEF DELPHI_LLVM}
    WayPoints[WayPoints.Count - 1].DisposeOf;
    {$ENDIF}

    //Remove the first waypoint that was added twice to calculate the
    //exact location of the start of the route
    if WayPoints.Count = 1 then
      WayPoints.Clear;
  end;

  if FRoutingWayPoints.Count > 0 then
  begin
    {$IFNDEF DELPHI_LLVM}
    FRoutingWaypoints[FRoutingWaypoints.Count - 1].Free;
    {$ENDIF}
    {$IFDEF DELPHI_LLVM}
    FRoutingWaypoints[FRoutingWaypoints.Count - 1].DisposeOf;
    {$ENDIF}
  end;

  if (FWebGMaps as TTMSFMXWebGMaps).Markers.Count > 0 then
    {$IFNDEF DELPHI_LLVM}
    (FWebGMaps as TTMSFMXWebGMaps).Markers[(FWebGMaps as TTMSFMXWebGMaps).Markers.Count - 1].Free;
    {$ENDIF}
    {$IFDEF DELPHI_LLVM}
    (FWebGMaps as TTMSFMXWebGMaps).Markers[(FWebGMaps as TTMSFMXWebGMaps).Markers.Count - 1].DisposeOf;
    {$ENDIF}

  if (FWebGMaps as TTMSFMXWebGMaps).Polylines.Count > 0 then
  begin
    (FWebGMaps as TTMSFMXWebGMaps).DeleteMapPolyline((FWebGMaps as TTMSFMXWebGMaps).Polylines.Count - 1);
    {$IFNDEF DELPHI_LLVM}
    (FWebGMaps as TTMSFMXWebGMaps).Polylines[(FWebGMaps as TTMSFMXWebGMaps).Polylines.Count - 1].Free;
    {$ENDIF}
    {$IFDEF DELPHI_LLVM}
    (FWebGMaps as TTMSFMXWebGMaps).Polylines[(FWebGMaps as TTMSFMXWebGMaps).Polylines.Count - 1].DisposeOf;
    {$ENDIF}
  end;

  foundWayPoint := false;
  for I := Path.Count - 1 downto 0 do
  begin
    if Path[I].IsWayPoint then    
      foundWayPoint := true;
    {$IFNDEF DELPHI_LLVM}
    Path[I].Free;
    {$ENDIF}
    {$IFDEF DELPHI_LLVM}
    Path[I].DisposeOf;
    {$ENDIF}
    if foundWayPoint then
      Exit;
  end;

end;

procedure TMapRouting.SetEnabled(const Value: boolean);
begin
  FEnabled := Value;
  (FWebGMaps as TTMSFMXWebGMaps).MapOptions.DisableDoubleClickZoom := Value and (RoutingType = rtDoubleClick);
end;

procedure TMapRouting.SetPath(const Value: TPath);
begin
  FPath.Assign(Value);
end;

procedure TMapRouting.SetRoutingType(const Value: TRoutingType);
begin
  FRoutingType := Value;
  (FWebGMaps as TTMSFMXWebGMaps).MapOptions.DisableDoubleClickZoom := (Value = rtDoubleClick);
end;

procedure TMapRouting.SetWayPoints(const Value: TPath);
begin
  FWayPoints.Assign(Value);
end;

{ TMapPolylineOptions }

procedure TMapPolylineOptions.Assign(Source: TPersistent);
begin
  if (Source is TMapPolylineOptions) then
  begin
    FColor := (Source as TMapPolylineOptions).Color;
    FIcons.Assign((Source as TMapPolylineOptions).Icons);
    FOpacity := (Source as TMapPolylineOptions).Opacity;
    FWidth := (Source as TMapPolylineOptions).Width;
  end;
end;

constructor TMapPolylineOptions.Create;
begin
  inherited Create;
  {$IFDEF FMXLIB}
  FColor := claBlue;
  {$ENDIF}
  {$IFNDEF FMXLIB}
  FColor := claBlue;
  {$ENDIF}
  FIcons := TSymbols.Create;
  FOpacity := 100;
  FWidth := 4;
end;

destructor TMapPolylineOptions.Destroy;
begin
  FIcons.Free;
  inherited;
end;

procedure TMapPolylineOptions.SetColor(const Value: TAlphaColor);
begin
  FColor := Value;
end;

procedure TMapPolylineOptions.SetIcons(const Value: TSymbols);
begin
  FIcons.Assign(Value);
end;

procedure TMapPolylineOptions.SetOpacity(const Value: integer);
begin
  if (Value >= 0) and (Value <= 255) then
    FOpacity := Value;
end;

procedure TMapPolylineOptions.SetWidth(const Value: integer);
begin
  if Value > 0 then
    FWidth := Value;
end;

{ TRoutingWaypoint }

procedure TRoutingWaypoint.Assign(Source: TPersistent);
begin
  if (Source is TRoutingWaypoint) then
  begin
    FLocation.Assign((Source as TRoutingWaypoint).Location);
    FAddress := (Source as TRoutingWaypoint).Address;
    FDistance := (Source as TRoutingWaypoint).Distance;
  end;
end;

constructor TRoutingWaypoint.Create(Collection: TCollection);
begin
  inherited;
  FLocation := TLocation.Create;
  FAddress := '';
  FDistance := 0;
end;

destructor TRoutingWaypoint.Destroy;
begin
  FLocation.Free;
  inherited;
end;

procedure TRoutingWaypoint.SetLocation(const Value: TLocation);
begin
  FLocation.Assign(Value);
end;

{ TRoutingWaypoints }

function TRoutingWaypoints.Add: TRoutingWaypoint;
begin
  Result := TRoutingWaypoint(inherited Add);
end;

constructor TRoutingWaypoints.Create;
begin
  inherited Create(TRoutingWaypoint);
end;

function TRoutingWaypoints.GetItem(Index: integer): TRoutingWaypoint;
begin
  Result := TRoutingWaypoint(inherited GetItem(Index));
end;

//function TRoutingWaypoints.GetOwner: TPersistent;
//begin
//  Result := FWebGMaps;
//end;

procedure TRoutingWaypoints.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
end;

procedure TRoutingWaypoints.SetItem(Index: integer; Value: TRoutingWaypoint);
begin
  inherited SetItem(Index, Value);
end;

procedure TRoutingWaypoints.Update(Item: TCollectionItem);
begin
  inherited;
end;


{------------------------------------------------------------------------------}

{$IFNDEF FMXLIB}
{$IFDEF FREEWARE}
{$IFDEF DELPHIXE2_LVL}
{$I TMSProductTrial.inc}
{$ELSE}
{$I TRIAL.INC}
{$ENDIF}
{$ENDIF}
{$ENDIF}


end.
