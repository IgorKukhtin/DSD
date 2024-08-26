unit FMX.DataWedgeBarCode;


interface

uses
  System.Classes
  {$IFDEF MSWINDOWS}
  , FMX.Dialogs
  {$ENDIF}
  {$IFDEF ANDROID}
  , System.SysUtils, Androidapi.Helpers, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes, Androidapi.JNIBridge, Androidapi.JNI.Embarcadero,
  FMX.Platform.Android, Androidapi.JNI.Os, Androidapi.JNI.App
  {$ENDIF}
  ;
type
  TDataWedgeBarCodeResult = procedure(Sender: TObject; AResult: String) of object;
  TDataWedgeBarCodeResultDetails = procedure(Sender: TObject; AAction, ASource, ALabel_Type, AData_String: String) of object;

type

  TDataWedgeBarCode = class;

  {$IFDEF ANDROID}
  //TOnReceive = procedure (csContext: JContext; csIntent: JIntent) of object;

  TCSListener = class(TJavaLocal, JFMXBroadcastReceiverListener)
    private
      FOwner: TDataWedgeBarCode;
    public
      constructor Create(AOwner: TDataWedgeBarCode);
      procedure OnReceive(csContext: JContext; csIntent: JIntent); cdecl;
  end;
  {$ENDIF}

  [ComponentPlatformsAttribute(pidAndroidArm32)]
  TDataWedgeBarCode = class(TComponent)
  public
  protected
    FisIllumination: Boolean;
    FOnScanResult: TDataWedgeBarCodeResult;
    FOnScanResultDetails: TDataWedgeBarCodeResultDetails;
    FOnGetConfig: TNotifyEvent;
    //FListParam: TStrings;
  {$IFDEF ANDROID}
    FReceiver: JBroadcastReceiver;
    FListener : TCSListener;
    procedure BroadcastReceiverOnReceive(csContext: JContext; csIntent: JIntent);
    procedure CallScan;
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetIllumination;
    procedure Scan;
    //procedure ChangeIllumination;
  published
    property isIllumination: Boolean read FisIllumination write FisIllumination;
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
    //
  SWITCH_SCANNER_PARAMS = 'com.symbol.datawedge.api.SWITCH_SCANNER_PARAMS';

    // This intent string contains the captured data as a string
    // (in the case of MSR this data string contains a concatenation of the track data)
  DATA_STRING_TAG = 'com.symbol.datawedge.data_string';

   // Let's define the API intent strings for the soft scan trigger
  ACTION_SOFTSCANTRIGGER = 'com.symbol.datawedge.api.ACTION';
  EXTRA_PARAM = 'com.symbol.datawedge.api.SOFT_SCAN_TRIGGER';
  DWAPI_START_SCANNING = 'START_SCANNING';
  DWAPI_STOP_SCANNING = 'STOP_SCANNING';
  DWAPI_TOGGLE_SCANNING = 'TOGGLE_SCANNING';

  PROFILE_NAME_DEFAULT = 'Profile0 (default)';
  PROFILE_NAME = 'Profile0 (default)';

  SCAN_RESULT_ACTION = 'com.dwoutput.ACTION';

{$IFDEF ANDROID}

{ TCSListener }
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
  FisIllumination := True;
  //FListParam := TStrings.Create;
  {$IFDEF ANDROID}

  FListener := TCSListener.Create(Self);
  FReceiver := TJFMXBroadcastReceiver.JavaClass.init(FListener);
  IntentFilter := TJIntentFilter.Create;
  IntentFilter.addAction(StringToJString(SCAN_RESULT_ACTION));
  IntentFilter.addCategory(TJIntent.JavaClass.CATEGORY_DEFAULT);
  TAndroidHelper.Context.registerReceiver(FReceiver, IntentFilter);

  //GetConfig;
  {$ENDIF}
end;

destructor TDataWedgeBarCode.Destroy;
begin
  //FListParam.Free;
  {$IFDEF ANDROID}
  if FReceiver <> nil then TAndroidHelper.Activity.UnregisterReceiver(FReceiver);
  {$ENDIF}
  inherited Destroy;
end;

procedure TDataWedgeBarCode.SetIllumination;
  {$IFDEF ANDROID}
var
  intentParams: JIntent;
  bScannerParams: JBundle;
  {$ENDIF}
begin
  {$IFDEF ANDROID}
  intentParams := TJIntent.Create;
  intentParams.setAction(stringtojstring(ACTION_SOFTSCANTRIGGER));

  bScannerParams := TJBundle.Create;

  if FisIllumination then
    bScannerParams.putString(stringtojstring('illumination_mode'), stringtojstring('torch'))
  else bScannerParams.putString(stringtojstring('illumination_mode'), stringtojstring('off'));

  intentParams.putExtra(stringtojstring(SWITCH_SCANNER_PARAMS), bScannerParams);
  TAndroidHelper.Activity.sendBroadcast(intentParams);
  {$ENDIF}
end;

procedure TDataWedgeBarCode.Scan;
  {$IFDEF MSWINDOWS}
  var S: String;
  {$ENDIF}
begin
  {$IFDEF ANDROID}
  CallScan;
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
  var cDATA_STRING, cLABEL_TYPE: String;
begin
  if csIntent = Nil then Exit;

  cDATA_STRING := JStringToString(csIntent.getStringExtra(StringToJString(DATA_STRING_TAG)));
  cLABEL_TYPE := JStringToString(csIntent.getStringExtra(StringToJString(LABEL_TYPE_TAG)));

  if (POS('EAN', cLABEL_TYPE) > 0) or (POS('UPCA', cLABEL_TYPE) > 0) then cDATA_STRING := Copy(cDATA_STRING, 1, Length(cDATA_STRING) - 1);

  if Assigned(FOnScanResultDetails) then
      FOnScanResultDetails(Self, JStringToString(csIntent.getAction),
                                 JStringToString(csIntent.getStringExtra(StringToJString(SOURCE_TAG))),
                                 cLABEL_TYPE, cDATA_STRING);

  if Assigned(FOnScanResult) then FonScanResult(Self, cDATA_STRING);

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
