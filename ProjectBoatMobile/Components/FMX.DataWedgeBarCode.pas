unit FMX.DataWedgeBarCode;


interface

uses
  System.Classes
  {$IFDEF MSWINDOWS}
  , FMX.Dialogs
  {$ENDIF}
  {$IFDEF ANDROID}
  , System.SysUtils, Androidapi.Helpers, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes, Androidapi.JNI.App, Androidapi.JNIBridge, Androidapi.JNI.Embarcadero,
  FMX.TKRBarCodeScanner, FMX.Platform.Android, Androidapi.JNI.Os
  {$ENDIF}
  ;
type
  TDataWedgeBarCodeResult = procedure(Sender: TObject; AResult: String) of object;
  TDataWedgeBarCodeResultDetails = procedure(Sender: TObject; AAction, ASource, ALabel_Type, AData_String: String) of object;

type

  TDataWedgeBarCode = class;

  {$IFDEF ANDROID}
  TOnReceive = procedure (csContext: JContext; csIntent: JIntent) of object;

  TCSListener = class(TJavaLocal, JFMXBroadcastReceiverListener)
    private
      FOwner: TDataWedgeBarCode;
    public
      constructor Create(AOwner: TDataWedgeBarCode);
      procedure OnReceive(csContext: JContext; csIntent: JIntent); cdecl;
  end;
  {$ENDIF}

  [ComponentPlatformsAttribute(pidAndroid)]
  TDataWedgeBarCode = class(TComponent)
  public
  protected
    FOnScanResult: TDataWedgeBarCodeResult;
    FOnScanResultDetails: TDataWedgeBarCodeResultDetails;
  {$IFDEF ANDROID}
    FTKRBarCodeScanner: TTKRBarCodeScanner;
    FReceiver: JBroadcastReceiver;
    FListener : TCSListener;

    procedure OnScanResultCamera(Sender: TObject; AData_String: String);
    procedure BroadcastReceiverOnReceive(csContext: JContext; csIntent: JIntent);
    procedure CallScan;
  {$ENDIF}
  public
    procedure Scan;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnScanResult: TDataWedgeBarCodeResult read FOnScanResult write FOnScanResult;
    property OnScanResultDetails: TDataWedgeBarCodeResultDetails read FOnScanResultDetails write FOnScanResultDetails;
  end;


implementation

const
    // Let's define some intent strings
    // This intent string contains the source of the data as a string
  SOURCE_TAG = 'com.symbol.datawedge.source';
    // This intent string contains the barcode symbology as a string
  LABEL_TYPE_TAG = 'com.symbol.datawedge.label_type';
    // This intent string contains the barcode data as a byte array list
  DECODE_DATA_TAG = 'com.symbol.datawedge.decode_data';

    // This intent string contains the captured data as a string
    // (in the case of MSR this data string contains a concatenation of the track data)
  DATA_STRING_TAG = 'com.symbol.datawedge.data_string';

   // Let's define the API intent strings for the soft scan trigger
  ACTION_SOFTSCANTRIGGER = 'com.symbol.datawedge.api.ACTION';
  EXTRA_PARAM = 'com.symbol.datawedge.api.SOFT_SCAN_TRIGGER';
  DWAPI_START_SCANNING = 'START_SCANNING';
  DWAPI_STOP_SCANNING = 'STOP_SCANNING';
  DWAPI_TOGGLE_SCANNING = 'TOGGLE_SCANNING';

  ourIntentAction = 'com.dwoutput.ACTION';
{ TCSListener }

{$IFDEF ANDROID}
constructor TCSListener.Create(AOwner: TDataWedgeBarCode);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TCSListener.OnReceive(csContext: JContext; csIntent: JIntent);
begin
  FOwner.BroadcastReceiverOnReceive(csContext, csIntent);
end;

{$ENDIF}


{ TDataWedgeBarCode }

constructor TDataWedgeBarCode.Create(AOwner: TComponent);
{$IFDEF ANDROID}
var
   IntentFilter: JIntentFilter;
{$ENDIF}
begin
  inherited Create(AOwner);
  {$IFDEF ANDROID}
  FTKRBarCodeScanner := Nil;

  if Pos('Zebra', JStringToString(TJBuild.JavaClass.MANUFACTURER)) > 0 then
  begin
    FListener := TCSListener.Create(Self);
    FReceiver := TJFMXBroadcastReceiver.JavaClass.init(FListener);
    IntentFilter := TJIntentFilter.Create;
    IntentFilter.addAction(StringToJString(ourIntentAction));
    IntentFilter.addCategory(TJIntent.JavaClass.CATEGORY_DEFAULT);
    TAndroidHelper.Context.registerReceiver(FReceiver, IntentFilter);
  end else
  begin
    FTKRBarCodeScanner := TTKRBarCodeScanner.Create(Nil);
    FTKRBarCodeScanner.OnScanResult := OnScanResultCamera;
  end;
  {$ENDIF}
end;

destructor TDataWedgeBarCode.Destroy;
begin
  {$IFDEF ANDROID}
  if FReceiver <> nil then TAndroidHelper.Activity.UnregisterReceiver(FReceiver);
  if Assigned(FTKRBarCodeScanner) then FTKRBarCodeScanner.Free;
  {$ENDIF}
  inherited Destroy;
end;

procedure TDataWedgeBarCode.Scan;
  {$IFDEF MSWINDOWS}
  var S: String;
  {$ENDIF}
begin
  {$IFDEF ANDROID}
  if Assigned(FTKRBarCodeScanner) then
    FTKRBarCodeScanner.Scan
  else CallScan;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  S := InputBox('Введите код', 'Код', '');
  if S = '' then Exit;

  if Assigned(FOnScanResultDetails) then
      FOnScanResultDetails(Self, '', 'InputBox', '', S);

  if Assigned(FOnScanResult) then
      FOnScanResult(Self, S);
  {$ENDIF}
end;

{$IFDEF ANDROID}
procedure TDataWedgeBarCode.BroadcastReceiverOnReceive(csContext: JContext; csIntent: JIntent);
begin
  if csIntent = Nil then Exit;

  if Assigned(FOnScanResultDetails) then
      FOnScanResultDetails(Self, JStringToString(csIntent.getAction),
                                 JStringToString(csIntent.getStringExtra(StringToJString(SOURCE_TAG))),
                                 JStringToString(csIntent.getStringExtra(StringToJString(LABEL_TYPE_TAG))),
                                 JStringToString(csIntent.getStringExtra(StringToJString(DATA_STRING_TAG))));

  if Assigned(FOnScanResult) then
      FOnScanResult(Self, JStringToString(csIntent.getStringExtra(StringToJString(DATA_STRING_TAG))));

end;
{$ENDIF}

{$IFDEF ANDROID}
procedure TDataWedgeBarCode.OnScanResultCamera(Sender: TObject; AData_String: String);
begin
  if Assigned(FOnScanResultDetails) then
      FOnScanResultDetails(Self, '', 'Camera', '', AData_String);

  if Assigned(FOnScanResult) then
      FOnScanResult(Self, AData_String);
end;
{$ENDIF}

{$IFDEF ANDROID}
procedure TDataWedgeBarCode.CallScan;
var
  intent: JIntent;
begin
  intent := TJIntent.Create;
  intent.setAction(stringtojstring(ACTION_SOFTSCANTRIGGER));
  intent.putExtra(stringtojstring(EXTRA_PARAM), stringtojstring(DWAPI_TOGGLE_SCANNING));
  TAndroidHelper.Activity.sendBroadcast(intent);
end;
{$ENDIF}

end.
