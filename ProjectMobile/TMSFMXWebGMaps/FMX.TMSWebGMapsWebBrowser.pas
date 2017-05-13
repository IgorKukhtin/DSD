{********************************************************************}
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2014 - 2015                                 }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The complete source code remains property of the author and may    }
{ not be distributed, published, given or sold in any form as such.  }
{ No parts of the source code can be included in any other component }
{ or application without written authorization of the author.        }
{********************************************************************}

unit FMX.TMSWebGMapsWebBrowser;

interface

{$I TMSDEFS.INC}
{$DEFINE NOFMXPACK}

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  FMX.Dialogs,
  Classes, SysUtils, Types, UITypes, TypInfo, UIConsts,
  Generics.Collections, FMX.StdCtrls,
  FMX.Types, FMX.Types3D, FMX.Forms, FMX.Consts, FMX.Controls
  {$IFDEF DELPHIXE5_LVL}
  ,FMX.Graphics
  {$ENDIF}
  {$IFDEF ANDROID}
  ,FMX.Platform.Android, AndroidApi.JNI.Embarcadero, AndroidApi.JNI.App, Androidapi.JNI.GraphicsContentViewText, AndroidApi.JNI.JavaTypes,
  AndroidApi.JNI.Widget, FMX.Helpers.Android, AndroidApi.JNIBridge
  {$IFDEF DELPHIXE6_LVL}
  ,AndroidApi.Helpers
  {$ENDIF}
  {$ENDIF}
  {$IFDEF IOS}
  ,FMX.Platform.iOS, iOSApi.CocoaTypes, iOSApi.CoreGraphics, iOSApi.UIKit, iOSApi.Foundation,
  Macapi.ObjectiveC, MacApi.ObjcRuntime
  {$ENDIF}
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  ,MacApi.Foundation, MacApi.AppKit, MacApi.CocoaTypes, FMX.Platform.Mac
  {$ENDIF}
  {$IFDEF DELPHIXE6_LVL}
  ,MacApi.Helpers
  {$ENDIF}
  {$ENDIF}
  ;

const
  MAJ_VER = 1; // Major version nr.
  MIN_VER = 0; // Minor version nr.
  REL_VER = 1; // Release nr.
  BLD_VER = 8; // Build nr.

  //v1.0.0.0 : First release
  //v1.0.0.1 : Issue with Android keyboard input
  //v1.0.0.2 : Improved : DeleteCookies
  //v1.0.0.3 : Fixed : Issue with showmodal on Mac OSX and browser refresh issues
  //v1.0.0.4 : Fixed : Issue with Mac OSX rendering
  //v1.0.1.0 : New : Replaced TChromiumFMX implementation with default FireMonkey TWebBrowser implementation for XE8 and newer
  //         : New : Windows 64 bit support for XE8 and newer
  //v1.0.1.1 : Improved : moved interface declarations in FMX.TMSWebGMapsWebBrowser.Mac to access native webbrowser
  //v1.0.1.2 : Fixed : Issue in combination with runtime created frames
  //v1.0.1.3 : Fixed : LoadFile doesn't load when webbrowser is still initializing on Windows
  //v1.0.1.4 : Rendering issues on Mac in 10 Seattle
  //v1.0.1.5 : Initialization issue on Windows
  //v1.0.1.6 : CanGoBack and CanGoForward not returning a value in Android
  //v1.0.1.7 : Fixed : Issue with keyboard handling in Android
  //v1.0.1.8 : Fixed : Focus issue when toggling focus between edit and browser

type
  TTMSFMXWebGMapsCustomWebBrowser = class;

  ITMSFMXWebGMapsCustomWebBrowser = interface(IInterface)
  ['{A23E0353-2AEC-449A-9949-EFD5C59E683A}']
    procedure SetURL(const AValue: string);
    procedure SetExternalBrowser(const AValue: Boolean);
    procedure Navigate(const AURL: String); overload;
    procedure Navigate; overload;
    procedure LoadHTML(AHTML: String);
    procedure LoadFile(AFile: String);
    procedure GoForward;
    procedure GoBack;
    procedure Reload;
    procedure Close;
    procedure StopLoading;
    procedure UpdateBounds;
    procedure UpdateVisible;
    procedure UpdateEnabled;
    procedure Initialize;
    procedure DeInitialize;
    function GetURL: string;
    function GetExternalBrowser: Boolean;
    function ExecuteJavascript(AScript: String): String;
    function NativeBrowser: Pointer;
    function GetBrowserInstance: IInterface;
    function CanGoBack: Boolean;
    function CanGoForward: Boolean;
    function BodyInnerHTML: string;
    function NativeDialog: Pointer;
    function IsFMXBrowser: Boolean;
    property URL: string read GetURL write SetURL;
    property ExternalBrowser: Boolean read GetExternalBrowser write SetExternalBrowser;
  end;

  ITMSFMXWebGMapsWebBrowserService = interface(IInterface)
  ['{E6CA59A6-E741-455D-BC22-8B5FC1C80196}']
    function CreateWebBrowser(const AValue: TTMSFMXWebGMapsCustomWebBrowser): ITMSFMXWebGMapsCustomWebBrowser;
    procedure DeleteCookies;
    procedure DestroyWebBrowser(const AValue: ITMSFMXWebGMapsCustomWebBrowser);
  end;

  TTMSFMXWebGMapsCustomWebBrowserNavigateCompleteParams = record
    URL: String;
  end;

  TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams = record
    URL: String;
    Cancel: Boolean;
  end;

  TTMSFMXWebGMapsCustomWebBrowserNavigateComplete = procedure(Sender: TObject; var Params: TTMSFMXWebGMapsCustomWebBrowserNavigateCompleteParams) of object;
  TTMSFMXWebGMapsCustomWebBrowserBeforeNavigate = procedure(Sender: TObject; var Params: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams) of object;

  TTMSFMXWebGMapsWebBrowserHTMLElement = class
  private
    FWebBrowser: ITMSFMXWebGMapsCustomWebBrowser;
    function GetInnerHTMLByName(AName: string): string;
  protected
    property InnerHTMLByName[AName: string]: string read GetInnerHTMLByName;
  public
    constructor Create(const AWebBrowser: ITMSFMXWebGMapsCustomWebBrowser);
  end;

  TTMSFMXWebGMapsWebBrowserHTMLBodyElement = class(TTMSFMXWebGMapsWebBrowserHTMLElement)
  private
    function GetInnerHTML: string;
  public
    property InnerHTML: string read GetInnerHTML;
  end;

  TTMSFMXWebGMapsWebBrowserDocument = class
  private
    FWebBrowser: ITMSFMXWebGMapsCustomWebBrowser;
    FBody: TTMSFMXWebGMapsWebBrowserHTMLBodyElement;
    function GetBody: TTMSFMXWebGMapsWebBrowserHTMLBodyElement;
  public
    constructor Create(const AWebBrowser: ITMSFMXWebGMapsCustomWebBrowser);
    destructor Destroy; override;
    property Body: TTMSFMXWebGMapsWebBrowserHTMLBodyElement read GetBody;
  end;

  TTMSFMXWebGMapsCustomWebBrowser = class(TControl)
  private
    FWebBrowser: ITMSFMXWebGMapsCustomWebBrowser;
    FDocument: TTMSFMXWebGMapsWebBrowserDocument;
    FURL: string;
    FExternalBrowser: Boolean;
    FOnNavigateComplete: TTMSFMXWebGMapsCustomWebBrowserNavigateComplete;
    FOnBeforeNavigate: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigate;
    FOnHardwareButtonClicked: TNotifyEvent;
    FOnInitialized: TNotifyEvent;
    FShowScrollBars: Boolean;
    FEnableAutoComplete: Boolean;
    FShow3DBorder: Boolean;
    FApplyTheme: Boolean;
    FOnCloseForm: TNotifyEvent;
    function GetURL: string;
    procedure SetURL(const Value: string);
    function GetVersion: string;
    function GetVersionNr: Integer;
    procedure SetVersion(const Value: string);
    function GetDocument: TTMSFMXWebGMapsWebBrowserDocument;
    function GetExternalBrowser: Boolean;
    procedure SetExternalBrowser(const Value: Boolean);
  protected
    procedure DoHardwareButtonClicked; virtual;
    procedure DoCloseForm; virtual;
    procedure BeforeNavigate(var Params: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams); virtual;
    procedure NavigateComplete(var Params: TTMSFMXWebGMapsCustomWebBrowserNavigateCompleteParams); virtual;
    procedure Initialized; virtual;
    procedure SetParent(const Value: TFmxObject); override;
    procedure SetVisible(const Value: Boolean); override;
    procedure SetEnabled(const Value: Boolean); override;
    procedure Loaded; override;
    procedure ShowMsgTrial;
    property OnInitialized: TNotifyEvent read FOnInitialized write FOnInitialized;
    property ShowScrollBars: Boolean read FShowScrollBars write FShowScrollBars default True;
    property Show3DBorder: Boolean read FShow3DBorder write FShow3DBorder default True;
    property ApplyTheme: Boolean read FApplyTheme write FApplyTheme default False;
    property EnableAutoComplete: Boolean read FEnableAutoComplete write FEnableAutoComplete default False;
    property ExternalBrowser: Boolean read GetExternalBrowser write SetExternalBrowser default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Show; override;
    procedure Hide; override;
    procedure Move; override;
    procedure SetBounds(X, Y, AWidth, AHeight: Single); override;
    procedure Resize; override;
    {$IFDEF DELPHIXE6_LVL}
    procedure DoAbsoluteChanged; override;
    {$ENDIF}
    procedure Paint; override;
    procedure Navigate; overload; virtual;
    procedure Navigate(const AURL: string); overload; virtual;
    function GetPaintString: String; virtual;
    function ExecuteJavascript(AScript: String): String; virtual;
    procedure LoadHTML(AHTML: String); virtual;
    procedure LoadFile(AFile: String); virtual;
    procedure Initialize; virtual;
    procedure GoForward; virtual;
    procedure GoBack; virtual;
    procedure Reload; virtual;
    procedure StopLoading; virtual;
    class procedure DeleteCookies; virtual;
    property URL: string read GetURL write SetURL;
    function NativeBrowser: Pointer;
    function IsFMXBrowser: Boolean;
    function CanGoBack: Boolean;
    function CanGoForward: Boolean;
    {$IFDEF ANDROID}
    function NativeDialog: Pointer;
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    function GetWebBrowserInstance: IInterface;
    {$ENDIF}
    property OnCloseForm: TNotifyEvent read FOnCloseForm write FOnCloseForm;
    property OnBeforeNavigate: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigate read FOnBeforeNavigate write FOnBeforeNavigate;
    property OnNavigateComplete: TTMSFMXWebGMapsCustomWebBrowserNavigateComplete read FOnNavigateComplete write FOnNavigateComplete;
    property OnHardwareButtonClicked: TNotifyEvent read FOnHardwareButtonClicked write FOnHardwareButtonClicked;
    property Document: TTMSFMXWebGMapsWebBrowserDocument read GetDocument;
    property Version: string read GetVersion write SetVersion;
  end;

  TTMSFMXWebGMapsWebBrowserFactoryService = class abstract(TInterfacedObject, ITMSFMXWebGMapsWebBrowserService)
  protected
    FWebBrowsers: TList<ITMSFMXWebGMapsCustomWebBrowser>;
    function DoCreateWebBrowser(const AValue: TTMSFMXWebGMapsCustomWebBrowser): ITMSFMXWebGMapsCustomWebBrowser; virtual; abstract;
    procedure DoRemoveWebBrowser(const AValue: ITMSFMXWebGMapsCustomWebBrowser);
  public
    constructor Create;
    destructor Destroy; override;
    function CreateWebBrowser(const AValue: TTMSFMXWebGMapsCustomWebBrowser): ITMSFMXWebGMapsCustomWebBrowser;
    procedure DeleteCookies; virtual; abstract;
    procedure DestroyWebBrowser(const AValue: ITMSFMXWebGMapsCustomWebBrowser);
  end;

  [ComponentPlatformsAttribute(pidWin32 {$IFDEF DELPHIXE8_LVL} or pidWin64 {$ENDIF} or pidOSX32 or pidiOSSimulator or {$IFDEF DELPHIXE8_LVL}pidiOSDevice32 or pidiOSDevice64{$ELSE}pidiOSDevice{$ENDIF} or pidAndroid)]
  TTMSFMXWebGMapsWebBrowser = class(TTMSFMXWebGMapsCustomWebBrowser)
  published
    property Align;
    property Anchors;
    property Height;
    property Margins;
    property Position;
    property URL;
    property Visible default True;
    property Width;
    property Enabled default True;
    property OnBeforeNavigate;
    property OnNavigateComplete;
    property OnHardwareButtonClicked;
    property Version;
    {$IFDEF DELPHIXE7_LVL}
    property Size;
    {$ENDIF}
  end;

  TTMSFMXWebGMapsWebBrowserPopup = class;

  {$IFDEF DELPHI_LLVM}
  TTMSFMXWebGMapsWebBrowserPopupForm = class(TCommonCustomForm)
  {$ELSE}
  TTMSFMXWebGMapsWebBrowserPopupForm = class(TCustomForm)
  {$ENDIF}
  private
    FWebBrowserPopup: TTMSFMXWebGMapsWebBrowserPopup;
  protected
    procedure UpdateBackGround;
  public
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  end;

  {$IFDEF IOS}
  ITMSFMXWebGMapsWebBrowserPopupButtonEventHandler = interface(NSObject)
  ['{D8C26DD2-2CC4-4A0D-B71F-7490BFF53E9F}']
    procedure Click; cdecl;
  end;

  TTMSFMXWebGMapsWebBrowserPopupButtonEventHandler = class(TOCLocal)
  private
    FWebBrowserPopup: TTMSFMXWebGMapsWebBrowserPopup;
  protected
    function GetObjectiveCClass: PTypeInfo; override;
  public
    procedure Click; cdecl;
  end;
  {$ENDIF}

  {$IFDEF ANDROID}
  TTMSFMXWebGMapsWebBrowserPopupButtonEventHandler = class(TJavaLocal, JView_OnClickListener)
  private
    FWebBrowserPopup: TTMSFMXWebGMapsWebBrowserPopup;
  public
    procedure onClick(P1: JView); cdecl;
  end;
  {$ENDIF}

  [ComponentPlatformsAttribute(pidWin32 or pidOSX32 or pidiOSSimulator or {$IFDEF DELPHIXE8_LVL}pidiOSDevice32 or pidiOSDevice64{$ELSE}pidiOSDevice{$ENDIF} or pidAndroid)]
  TTMSFMXWebGMapsWebBrowserPopup = class(TComponent)
  private
    {$IF DEFINED(MSWINDOWS) AND DEFINED(DELPHIXE8_LVL)}
    FLoadURL: String;
    FFirstLoad: Boolean;
    {$ENDIF}
    FModal: Boolean;
    {$IFDEF IOS}
    FButton: UIButton;
    {$ENDIF}
    {$IFNDEF ANDROID}
    FWebBrowserForm: TTMSFMXWebGMapsWebBrowserPopupForm;
    {$ENDIF}
    {$IFDEF ANDROID}
    FButton: JButton;
    {$ENDIF}
    {$IFDEF DELPHI_LLVM}
    FButtonEventHandler: TTMSFMXWebGMapsWebBrowserPopupButtonEventHandler;
    {$ENDIF}
    FWebBrowser: TTMSFMXWebGMapsCustomWebBrowser;
    FOnNavigateComplete: TTMSFMXWebGMapsCustomWebBrowserNavigateComplete;
    FOnBeforeNavigate: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigate;
    FURL: String;
    FPosition: TFormPosition;
    FWidth: Integer;
    FHeight: Integer;
    FTop: Integer;
    FLeft: Integer;
    FFullScreen: Boolean;
    FCloseButton: Boolean;
    FOnClose: TNotifyEvent;
    FCloseButtonText: String;
    FExternalBrowser: Boolean;
  protected
    procedure ButtonClose(Sender: TObject);
    {$IF DEFINED(MSWINDOWS) AND DEFINED(DELPHIXE8_LVL)}
    procedure FormShow(Sender: TObject);
    {$ENDIF}
    {$IFNDEF ANDROID}
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    {$ENDIF}
    procedure CloseForm(Sender: TObject);
    procedure BeforeNavigate(Sender: TObject; var Params: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams);
    procedure NavigateComplete(Sender: TObject; var Params: TTMSFMXWebGMapsCustomWebBrowserNavigateCompleteParams);
    property ExternalBrowser: Boolean read FExternalBrowser write FExternalBrowser default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Open(AModal: Boolean = True): TModalResult; overload;
    function Open(AURL: String; AModal: Boolean = True): TModalResult; overload;
    procedure Close(AModalResult: TModalResult = mrOk);
    function WebBrowser: TTMSFMXWebGMapsCustomWebBrowser;
  published
    property OnBeforeNavigate: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigate read FOnBeforeNavigate write FOnBeforeNavigate;
    property OnNavigateComplete: TTMSFMXWebGMapsCustomWebBrowserNavigateComplete read FOnNavigateComplete write FOnNavigateComplete;
    property URL: String read FURL write FURL;
    {$IFDEF DELPHIXE6_LVL}
    property Position: TFormPosition read FPosition write FPosition default TFormPosition.ScreenCenter;
    {$ELSE}
    property Position: TFormPosition read FPosition write FPosition default TFormPosition.poScreenCenter;
    {$ENDIF}
    property FullScreen: Boolean read FFullScreen write FFullScreen default False;
    property Width: Integer read FWidth write FWidth default 640;
    property Height: Integer read FHeight write FHeight default 480;
    property Left: Integer read FLeft write FLeft default 0;
    property Top: Integer read FTop write FTop default 0;
    property CloseButton: Boolean read FCloseButton write FCloseButton default False;
    property CloseButtonText: String read FCloseButtonText write FCloseButtonText;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
  end;

{$IFDEF MACOS}
function NSStrEx(AString: string): NSString;
{$ENDIF}

implementation

uses
{$IFDEF MSWINDOWS}
  FMX.TMSWebGMapsWebBrowser.Win,
{$ENDIF}
{$IFDEF MACOS}
{$IFDEF IOS}
  FMX.TMSWebGMapsWebBrowser.iOS,
{$ELSE}
  FMX.TMSWebGMapsWebBrowser.Mac,
{$ENDIF}
{$ENDIF}
{$IFDEF DELPHIXE5_LVL}
{$IFDEF ANDROID}
  FMX.TMSWebGMapsWebBrowser.Android,
{$ENDIF}
{$ENDIF}
  FMX.Platform
{$IFNDEF DELPHI_LLVM}
{$IFDEF FREEWARE}
  ,FMX.Objects
  {$IFNDEF MACOS}
  ,System.Win.Registry, WinApi.ShellApi
  {$ENDIF}
{$ENDIF}
{$ENDIF}
  ;

var
  FTrial: Integer = 0;

function Hiword(L: DWORD): integer;
begin
  Result := L shr 16;
end;

function LoWord(L: DWORD): Integer;
begin
  Result := L AND $FFFF;
end;

function MakeWord(b1,b2: integer): integer;
begin
  Result := b1 or b2 shl 8;
end;

function MakeLong(i1,i2: integer): integer;
begin
  Result := i1 or i2 shl 16;
end;

{$IFDEF ANDROID}
function SharedActivityEx: JActivity;
begin
  {$IFDEF DELPHIXE9_LVL}
  Result := TAndroidHelper.Activity;
  {$ELSE}
  Result := SharedActivity;
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF MACOS}
function NSStrEx(AString: string): NSString;
begin
  {$IFDEF DELPHIXE6_LVL}
  Result := StrToNSStr(AString);
  {$ELSE}
  Result := NSStr(AString);
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF IOS}
function GetSharedApplication: UIApplication;
begin
  Result := TUIApplication.Wrap(TUIApplication.OCClass.sharedApplication);
end;
{$ENDIF}

{$IFDEF FREEWARE}
function ScrambleEx(s:string): string;
var
  r:string;
  i: integer;
  c: char;
  b: byte;
begin
  r := '';
  {$IFDEF DELPHI_LLVM}
  for i := 0 to length(s) - 1 do
  {$ELSE}
  for i := 1 to length(s) do
  {$ENDIF}
  begin
    b := ord(s[i]);
    b := (b and $E0) + ((b and $1F) xor 5);
    c := chr(b);
    r := r + c;
  end;
  Result := r;
end;
{$ENDIF}

{ TTMSFMXWebGMapsCustomWebBrowser }

procedure TTMSFMXWebGMapsCustomWebBrowser.Show;
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.ShowMsgTrial;
{$IFDEF FREEWARE}
{$IFDEF MACOS}
var
{$IFDEF IOS}
  str: String;
  lbl: UILabel;
  vw: UIView;
  r: NSRect;
{$ELSE}
  str: String;
  lbl: NSTextField;
  vw: NSView;
  r: NSRect;
  h: TMacWindowHandle;
{$ENDIF}
{$ENDIF}
{$IFDEF ANDROID}
var
  str: string;
  ad: JAlertDialog;
  bd: JAlertDialog_Builder;
{$ENDIF}

{$ENDIF}
begin
  {$IFDEF FREEWARE}
  {$IFDEF ANDROID}
  if FTrial = 0 then
  begin
    str := ScrambleEx('Duuilfdqljk%pv`v%qwldi%s`wvljk%jc%QHV%vjcqrdw`%fjhujk`kqv+')+#13#10+ScrambleEx('Fjkqdfq%QHV%vjcqrdw`%mqqu?**rrr+qhvvjcqrdw`+fjh%cjw%sdila%ilf`kvlkb+');
    CallInUIThread(
    procedure
    begin
      bd := TJAlertDialog_Builder.JavaClass.init(SharedActivityEx);
      bd.setTitle(StrToJCharSequence('Trial'));
      bd.setMessage(StrToJCharSequence(str));
      bd.setNegativeButton(StrToJCharSequence('OK'), nil);
      ad := bd.create;
      ad.show;
    end
    );
    FTrial := 1;
  end;
  {$ENDIF}
  {$IFDEF MACOS}
  {$IFDEF IOS}
  vw := GetSharedApplication.keyWindow.rootViewController.view;
  if Assigned(vw) and (FTrial = 0) then
  begin
    str := ScrambleEx('Duuilfdqljk%pv`v%qwldi%s`wvljk%jc%QHV%vjcqrdw`%fjhujk`kqv+')+#13#10+ScrambleEx('Fjkqdfq%QHV%vjcqrdw`%mqqu?**rrr+qhvvjcqrdw`+fjh%cjw%sdila%ilf`kvlkb+');
    r.origin.x := 0;
    r.origin.y := 0;
    r.size.width := 500;
    r.size.height := 50;
    lbl := TUILabel.Wrap(TUILabel.Wrap(TUILabel.OCClass.alloc).initWithFrame(r));
    lbl.setText(NSStrEx(str));
    lbl.setUserInteractionEnabled(False);
    lbl.setBackgroundColor(TUIColor.Wrap(TUIColor.OCClass.clearColor));
    lbl.setLineBreakMode(UILineBreakModeWordWrap);
    lbl.setNumberOfLines(0);
    lbl.setFont(TUIFont.Wrap(TUIFont.OCClass.systemFontOfSize(14)));
    lbl.setTextColor(TUIColor.Wrap(TUIColor.OCClass.redColor));
    vw.addSubview(lbl);
    lbl.layer.setZPosition(99);
    lbl.setNeedsLayout;
    FTrial := 1;
  end;
  {$ELSE}
  vw := nil;
  if Assigned(Application.MainForm) then
  begin
    h := WindowHandleToPlatform(Application.MainForm.Handle);
    vw := h.View;
  end;

  if Assigned(vw) and (FTrial = 0) then
  begin
    str := ScrambleEx('Duuilfdqljk%pv`v%qwldi%s`wvljk%jc%QHV%vjcqrdw`%fjhujk`kqv+')+#13#10+ScrambleEx('Fjkqdfq%QHV%vjcqrdw`%mqqu?**rrr+qhvvjcqrdw`+fjh%cjw%sdila%ilf`kvlkb+');
    r.origin.x := 0;
    r.origin.y := 0;
    r.size.width := 500;
    r.size.height := 50;
    lbl := TNSTextField.Wrap(TNSTextField.Wrap(TNSTextField.OCClass.alloc).initWithFrame(r));
    lbl.setStringValue(NSStrEx(str));
    lbl.setDrawsBackground(false);
    lbl.setBordered(false);
    lbl.setWantsLayer(true);
    lbl.setEditable(false);
    lbl.setFont(TNSFont.Wrap(TNSFont.OCClass.systemFontOfSize(14)));
    lbl.setTextColor(TNSColor.Wrap(TNSColor.OCClass.redColor));
    vw.addSubview(lbl);
    FTrial := 1;
  end;
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.BeforeNavigate(
  var Params: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams);
begin
  if Assigned(OnBeforeNavigate) then
    OnBeforeNavigate(Self, Params);
end;

function TTMSFMXWebGMapsCustomWebBrowser.CanGoBack: Boolean;
begin
  Result := False;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.CanGoBack;
end;

function TTMSFMXWebGMapsCustomWebBrowser.CanGoForward: Boolean;
begin
  Result := False;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.CanGoForward;
end;

constructor TTMSFMXWebGMapsCustomWebBrowser.Create(AOwner: TComponent);
var
  WebBrowserService: ITMSFMXWebGMapsWebBrowserService;
begin
  inherited;
  FExternalBrowser := False;
  FShowScrollBars := True;
  FEnableAutoComplete := False;
  FShow3DBorder := True;
  FApplyTheme := False;
  if not (csDesigning in ComponentState) then
    if TPlatformServices.Current.SupportsPlatformService(ITMSFMXWebGMapsWebBrowserService, IInterface(WebBrowserService)) then
      FWebBrowser := WebBrowserService.CreateWebBrowser(Self);

  FDocument := TTMSFMXWebGMapsWebBrowserDocument.Create(FWebBrowser);

  Width := 500;
  Height := 350;
end;

destructor TTMSFMXWebGMapsCustomWebBrowser.Destroy;
var
  WebBrowserService: ITMSFMXWebGMapsWebBrowserService;
begin
  if Assigned(FDocument) then
  begin
    FDocument.Free;
    FDocument := nil;
  end;

  if not (csDesigning in ComponentState) and TPlatformServices.Current.SupportsPlatformService(ITMSFMXWebGMapsWebBrowserService, IInterface(WebBrowserService)) then
    WebBrowserService.DestroyWebBrowser(FWebBrowser);

  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.Deinitialize;
    FWebBrowser := nil;
  end;
  inherited;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.DoCloseForm;
begin
  if Assigned(OnCloseForm) then
    OnCloseForm(Self);
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.DoHardwareButtonClicked;
begin
  if Assigned(OnHardwareButtonClicked) then
    OnHardwareButtonClicked(Self);
end;

{$IFDEF DELPHIXE6_LVL}
procedure TTMSFMXWebGMapsCustomWebBrowser.DoAbsoluteChanged;
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;
end;
{$ENDIF}

function TTMSFMXWebGMapsCustomWebBrowser.ExecuteJavascript(AScript: String): String;
begin
  Result := '';
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.ExecuteJavascript(AScript);
end;

function TTMSFMXWebGMapsCustomWebBrowser.GetDocument: TTMSFMXWebGMapsWebBrowserDocument;
begin
  Result := FDocument;
end;

function TTMSFMXWebGMapsCustomWebBrowser.GetExternalBrowser: Boolean;
begin
  if FWebBrowser <> nil then
    Result := FWebBrowser.ExternalBrowser
  else
    Result := FExternalBrowser;
end;

function TTMSFMXWebGMapsCustomWebBrowser.GetPaintString: String;
begin
  {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(DELPHIXE8_LVL)}
  Result := 'Please follow the instructions located at %installdir%\doc\winsupport.txt to install the Chromium webbrowser for FireMonkey Windows applications. '+
    'Please note that the Windows version of the TTMSFMXWebGMapsWebBrowser is only supported in the registered version.'
  {$ELSE}
  Result := '';
  {$ENDIF}
end;

function TTMSFMXWebGMapsCustomWebBrowser.GetURL: string;
begin
  if FWebBrowser <> nil then
    Result := FWebBrowser.URL
  else
    Result := FURL;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.GoBack;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.GoBack;
end;

function TTMSFMXWebGMapsCustomWebBrowser.GetVersion: string;
var
  vn: Integer;
begin
  vn := GetVersionNr;
  Result := IntToStr(Hi(Hiword(vn)))+'.'+IntToStr(Lo(Hiword(vn)))+'.'+IntToStr(Hi(Loword(vn)))+'.'+IntToStr(Lo(Loword(vn)));
end;

function TTMSFMXWebGMapsCustomWebBrowser.GetVersionNr: Integer;
begin
  Result := MakeLong(MakeWord(BLD_VER,REL_VER),MakeWord(MIN_VER,MAJ_VER));
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.GoForward;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.GoForward;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.Hide;
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.Initialize;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.Initialize;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.Initialized;
begin
  if Assigned(OnInitialized) then
    OnInitialized(Self);
end;

function TTMSFMXWebGMapsCustomWebBrowser.IsFMXBrowser: Boolean;
begin
  Result := False;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.IsFMXBrowser;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.Loaded;
begin
  inherited;
  Initialize;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.LoadFile(AFile: String);
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.LoadFile(AFile);
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.LoadHTML(AHTML: String);
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.LoadHTML(AHTML);
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.Move;
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;
end;

{$IFDEF ANDROID}
function TTMSFMXWebGMapsCustomWebBrowser.NativeDialog: Pointer;
begin
  Result := nil;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.NativeDialog;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function TTMSFMXWebGMapsCustomWebBrowser.GetWebBrowserInstance: IInterface;
begin
  Result := nil;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.GetBrowserInstance;
end;
{$ENDIF}

function TTMSFMXWebGMapsCustomWebBrowser.NativeBrowser: Pointer;
begin
  Result := nil;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.NativeBrowser;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.Navigate(const AURL: string);
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.Navigate(AURL);
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.NavigateComplete(
  var Params: TTMSFMXWebGMapsCustomWebBrowserNavigateCompleteParams);
begin
  if Assigned(OnNavigateComplete) then
    OnNavigateComplete(Self, Params);
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.Paint;
var
  R: TRectF;
  st: TCanvasSaveState;
  str: String;
begin
  R := LocalRect;
  if (csDesigning in ComponentState) then
  begin
    InflateRect(R, -0.5, -0.5);
    st := Canvas.SaveState;
    Canvas.Stroke.Thickness := 1;
    {$IFDEF DELPHIXE6_LVL}
    Canvas.Stroke.Dash := TStrokeDash.Dash;
    Canvas.Stroke.Kind := TBrushKind.Solid;
    {$ELSE}
    Canvas.Stroke.Dash := TStrokeDash.sdDash;
    Canvas.Stroke.Kind := TBrushKind.bkSolid;
    {$ENDIF}
    Canvas.Stroke.Color := $A0909090;
    Canvas.Fill.Color := claWhite;
    Canvas.FillRect(R, 0, 0, AllCorners, AbsoluteOpacity);
    Canvas.DrawRect(R, 0, 0, AllCorners, AbsoluteOpacity);
    str := GetPaintString;
    if str <> '' then
    begin
      Canvas.Fill.Color := claBlack;
      {$IFDEF DELPHIXE6_LVL}
      Canvas.FillText(R, str, True, 1, [], TTextAlign.Center, TTextAlign.Center);
      {$ELSE}
      Canvas.FillText(R, str, True, 1, [], TTextAlign.taCenter, TTextAlign.taCenter);
      {$ENDIF}
    end;
    Canvas.RestoreState(st);
  end;
  ShowMsgTrial;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.Reload;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.Reload;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.Resize;
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.Navigate;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.Navigate;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.SetBounds(X, Y, AWidth, AHeight: Single);
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.SetEnabled(const Value: Boolean);
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateEnabled;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.SetExternalBrowser(const Value: Boolean);
begin
  FExternalBrowser := Value;
  if Assigned(FWebBrowser) then
    FWebBrowser.ExternalBrowser := Value;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.SetParent(const Value: TFmxObject);
begin
  inherited;
  Initialize;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.SetURL(const Value: string);
begin
  FURL := Value;
  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.URL := Value;
    if not(csDesigning in ComponentState) and (Value <> '') then
      Navigate;
  end;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.SetVersion(const Value: string);
begin

end;

procedure TTMSFMXWebGMapsCustomWebBrowser.SetVisible(const Value: Boolean);
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateVisible;
end;

class procedure TTMSFMXWebGMapsCustomWebBrowser.DeleteCookies;
var
  WebBrowserService: ITMSFMXWebGMapsWebBrowserService;
begin
  inherited;
  if TPlatformServices.Current.SupportsPlatformService(ITMSFMXWebGMapsWebBrowserService, IInterface(WebBrowserService)) then
    WebBrowserService.DeleteCookies;
end;

procedure TTMSFMXWebGMapsCustomWebBrowser.StopLoading;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.StopLoading;
end;

{ TTMSFMXWebGMapsWebBrowserFactoryService }

constructor TTMSFMXWebGMapsWebBrowserFactoryService.Create;
begin
  inherited Create;
  FWebBrowsers := TList<ITMSFMXWebGMapsCustomWebBrowser>.Create;
end;

function TTMSFMXWebGMapsWebBrowserFactoryService.CreateWebBrowser(const AValue: TTMSFMXWebGMapsCustomWebBrowser): ITMSFMXWebGMapsCustomWebBrowser;
begin
  Result := DoCreateWebBrowser(AValue);
  FWebBrowsers.Add(Result);
end;

destructor TTMSFMXWebGMapsWebBrowserFactoryService.Destroy;
begin
  FreeAndNil(FWebBrowsers);
  inherited Destroy;
end;

procedure TTMSFMXWebGMapsWebBrowserFactoryService.DestroyWebBrowser(
  const AValue: ITMSFMXWebGMapsCustomWebBrowser);
begin
  DoRemoveWebBrowser(AValue);
end;

procedure TTMSFMXWebGMapsWebBrowserFactoryService.DoRemoveWebBrowser(
  const AValue: ITMSFMXWebGMapsCustomWebBrowser);
begin
  if (FWebBrowsers <> nil) and (AValue <> nil) then
    FWebBrowsers.Remove(AValue);
end;

{ TTMSFMXWebGMapsWebBrowserPopup }

procedure TTMSFMXWebGMapsWebBrowserPopup.BeforeNavigate(Sender: TObject;
  var Params: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams);
begin
  if Assigned(OnBeforeNavigate) then
    OnBeforeNavigate(Self, Params);
end;

function TTMSFMXWebGMapsWebBrowserPopup.WebBrowser: TTMSFMXWebGMapsCustomWebBrowser;
begin
  Result := FWebBrowser;
end;

procedure TTMSFMXWebGMapsWebBrowserPopup.Close(AModalResult: TModalResult = mrOk);
begin
  {$IFDEF ANDROID}
  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.DisposeOf;
    FWebBrowser := nil;
  end;
  if Assigned(OnClose) then
    OnClose(Self);
  {$ELSE}
  if Assigned(FWebBrowserForm) then
  begin
    if FModal then
      FWebBrowserForm.ModalResult := AModalResult
    else
    begin
      if Assigned(FWebBrowserForm) then
        FWebBrowserForm.Close;
    end;
  end;
  {$ENDIF}
end;

procedure TTMSFMXWebGMapsWebBrowserPopup.CloseForm(Sender: TObject);
begin
  Close;
end;

constructor TTMSFMXWebGMapsWebBrowserPopup.Create(AOwner: TComponent);
begin
  inherited;
  {$IFDEF DELPHIXE6_LVL}
  FPosition := TFormPosition.ScreenCenter;
  {$ELSE}
  FPosition := TFormPosition.poScreenCenter;
  {$ENDIF}
  {$IFDEF DELPHI_LLVM}
  FButtonEventHandler := TTMSFMXWebGMapsWebBrowserPopupButtonEventHandler.Create;
  FButtonEventHandler.FWebBrowserPopup := Self;
  {$ENDIF}
  FFullScreen := False;
  FWidth := 640;
  FHeight := 480;
  FLeft := 0;
  FTop := 0;
  FExternalBrowser := False;
  if (csDesigning in ComponentState) then
    FCloseButtonText := 'Close';
end;

destructor TTMSFMXWebGMapsWebBrowserPopup.Destroy;
begin
  inherited;
  {$IFDEF DELPHI_LLVM}
  if Assigned(FButtonEventHandler) then
  begin
    FButtonEventHandler.Free;
    FButtonEventHandler := nil;
  end;
  {$ENDIF}
  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.DisposeOf;
    FWebBrowser := nil;
  end;
end;

{$IF DEFINED(MSWINDOWS) AND DEFINED(DELPHIXE8_LVL)}
procedure TTMSFMXWebGMapsWebBrowserPopup.FormShow(Sender: TObject);
begin
  if FFirstLoad then
  begin
    FFirstLoad := False;
    if Assigned(FWebBrowser) then
      FWebBrowser.URL := FLoadURL;
  end;
end;
{$ENDIF}

{$IFNDEF ANDROID}
procedure TTMSFMXWebGMapsWebBrowserPopup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FModal then
  begin
    {$IFDEF MACOS}
    {$IFDEF IOS}
    Action := TCloseAction.caFree;
    {$ENDIF}
    {$ELSE}
    Action := TCloseAction.caFree;
    {$ENDIF}
  end
  else
    Action := TCloseAction.caFree;

  FWebBrowserForm := nil;
  FWebBrowser := nil;

  if Assigned(OnClose) then
    OnClose(Self);
end;

{$ENDIF}

procedure TTMSFMXWebGMapsWebBrowserPopup.NavigateComplete(Sender: TObject;
  var Params: TTMSFMXWebGMapsCustomWebBrowserNavigateCompleteParams);
begin
  if Assigned(OnNavigateComplete) then
    OnNavigateComplete(Self, Params);
end;

function TTMSFMXWebGMapsWebBrowserPopup.Open(AURL: String;
  AModal: Boolean = True): TModalResult;
begin
  URL := AURL;
  Result := Open(AModal);
end;

procedure TTMSFMXWebGMapsWebBrowserPopup.ButtonClose(Sender: TObject);
begin
  Close;
end;

function TTMSFMXWebGMapsWebBrowserPopup.Open(AModal: Boolean = True): TModalResult;
{$IFNDEF DELPHI_LLVM}
var
  b: TButton;
{$ENDIF}
{$IFDEF IOS}
var
  h: TiOSWindowHandle;
  wbv: UIView;
  p: Pointer;
{$ENDIF}
{$IFDEF ANDROID}
var
  wb: JWebBrowser;
  {$IFNDEF DELPHIXE10_LVL}
  wnd: JWindow;
  dl: JDialog;
  {$ENDIF}
  ll: JLinearLayout;
{$ENDIF}
begin
  try
    FModal := AModal;
    {$IFDEF ANDROID}
    FModal := False;
    {$ENDIF}

    {$IFNDEF ANDROID}
    FWebBrowserForm := TTMSFMXWebGMapsWebBrowserPopupForm.CreateNew(nil);
    FWebBrowserForm.FWebBrowserPopup := Self;
    {$IFDEF DELPHHI_LLVM}
    FWebBrowserForm.FullScreen := FullScreen;
    {$ENDIF}
    FWebBrowserForm.OnClose := FormClose;
    {$IF DEFINED(MSWINDOWS) AND DEFINED(DELPHIXE8_LVL)}
    FFirstLoad := True;
    FWebBrowserForm.OnShow := FormShow;
    {$ENDIF}
    FWebBrowserForm.Position := Position;
    FWebBrowserForm.Left := Left;
    FWebBrowserForm.Top := Top;
    FWebBrowserForm.Width := Width;
    FWebBrowserForm.Height := Height;
    {$ENDIF}

    FWebBrowser := TTMSFMXWebGMapsCustomWebBrowser.Create(Self);
    FWebBrowser.ExternalBrowser := ExternalBrowser;
    FWebBrowser.OnCloseForm := CloseForm;
    FWebBrowser.OnBeforeNavigate := BeforeNavigate;
    FWebBrowser.OnNavigateComplete := NavigateComplete;
    {$IF DEFINED(MSWINDOWS) AND DEFINED(DELPHIXE8_LVL)}
    FLoadURL := URL;
    if FWebBrowser.ExternalBrowser then
      FWebBrowser.URL := URL;
    {$ELSE}
    FWebBrowser.URL := URL;
    {$ENDIF}
    {$IFNDEF DELPHI_LLVM}
    {$IFDEF DELPHIXE6_LVL}
    FWebBrowser.Align := TAlignLayout.Client;
    {$ELSE}
    FWebBrowser.Align := TAlignLayout.alClient;
    {$ENDIF}
    {$ENDIF}

    {$IFDEF ANDROID}
    FWebBrowser.Parent := Application.MainForm;
    if FullScreen then
    begin
      {$IFDEF DELPHIXE6_LVL}
      FWebBrowser.Align := TAlignLayout.Client;
      {$ELSE}
      FWebBrowser.Align := TAlignLayout.alClient;
      {$ENDIF}
    end
    else
    begin
      {$IFDEF DELPHIXE6_LVL}
      case Position of
        TFormPosition.ScreenCenter, TFormPosition.DesktopCenter, TFormPosition.MainFormCenter,
          TFormPosition.OwnerFormCenter:
      {$ELSE}
      case Position of
        TFormPosition.poScreenCenter, TFormPosition.poDesktopCenter, TFormPosition.poMainFormCenter,
          TFormPosition.poOwnerFormCenter:
      {$ENDIF}
        {$IFDEF DELPHIXE6_LVL}
        FWebBrowser.Align := TAlignLayout.Center;
        {$ELSE}
        FWebBrowser.Align := TAlignLayout.alCenter;
        {$ENDIF}
      end;
    end;
    {$ELSE}
    FWebBrowser.Parent := FWebBrowserForm;
    {$ENDIF}

    FWebBrowser.Position.X := Left;
    FWebBrowser.Position.Y := Top;
    FWebBrowser.Width := Width;
    FWebBrowser.Height := Height;

    if CloseButton then
    begin
      {$IFNDEF DELPHI_LLVM}
      b := TButton.Create(FWebBrowserForm);
      b.Parent := FWebBrowserForm;
      b.Text := CloseButtonText;
      b.OnClick := ButtonClose;
      {$IFNDEF DELPHI_LLVM}
      {$IFDEF DELPHIXE6_LVL}
      b.Align := TAlignLayout.Top;
      {$ELSE}
      b.Align := TAlignLayout.alTop;
      {$ENDIF}
      {$ELSE}
      if FullScreen then
      begin
        {$IFDEF DELPHIXE6_LVL}
        b.Align := TAlignLayout.Top;
        {$ELSE}
        b.Align := TAlignLayout.alTop;
        {$ENDIF}
      end;
      FWebBrowser.Position.Y := FWebBrowser.Position.Y + b.Height;
      FWebBrowser.Height := FWebBrowser.Height - b.Height;
      b.Position.X := FWebBrowser.Position.X;
      b.Position.Y := FWebBrowser.Position.Y - b.Height;
      b.Width := FWebBrowserForm.Width;
      {$ENDIF}
      {$ELSE}
      {$IFDEF IOS}
      FButton := TUIButton.Wrap(TUIButton.OCClass.buttonWithType(UIButtonTypeRoundedRect));
      FButton.addTarget(FButtonEventHandler.GetObjectID, sel_getUid('Click'), UIControlEventTouchUpInside);
      FButton.setTitle(NSStrEx(CloseButtonText), UIControlStateNormal);
      FWebBrowser.Position.Y := FWebBrowser.Position.Y + FButton.frame.size.height;
      FWebBrowser.Height := FWebBrowser.Height - FButton.frame.size.height;
      FButton.setFrame(CGRectMake(FWebBrowser.Position.X, FWebBrowser.Position.Y - FButton.frame.size.height, FWebBrowser.Width, 30));
      {$ELSE}
      CallInUIThreadAndWaitFinishing(
      procedure
      begin
        FButton := TJButton.JavaClass.init(SharedActivityEx);
        FButton.setText(StrToJCharSequence(CloseButtonText));
        FButton.setOnClickListener(FButtonEventHandler);
        wb := TJWebBrowser.Wrap(FWebBrowser.NativeBrowser);
        ll := TJLinearLayout.Wrap((wb.getParent as ILocalObject).GetObjectID);
        ll.addView(FButton, 0);
      end
      );
      {$ENDIF}
      {$ENDIF}
    end;

    {$IFDEF ANDROID}
    {$IFNDEF DELPHIXE10_LVL}
    CallInUIThreadAndWaitFinishing(
    procedure
    begin
      dl := TJDialog.Wrap(FWebBrowser.NativeDialog);
      wnd := dl.getWindow;
      wnd.clearFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_NOT_TOUCH_MODAL);
      wnd.addFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_DIM_BEHIND);
    end
    );
    {$ENDIF}
    FWebBrowser.SetFocus;
    {$ENDIF}

    {$IFDEF IOS}
    p := FWebBrowser.NativeBrowser;
    if Assigned(p) then
    begin
      wbv := TUIView.Wrap(p);
      wbv.layer.setShadowColor(TUIColor.OCClass.blackColor);
      wbv.layer.setShadowColor(TUIColor.Wrap(TUIColor.OCClass.blackColor).CGColor);
      wbv.layer.setShadowOffset(CGSizeMake(1,1));
      wbv.layer.setShadowRadius(5);
      wbv.layer.setShadowOpacity(0.75);

      h := WindowHandleToPlatform(FWebBrowserForm.Handle);
      h.View.setBackgroundColor(TUIColor.Wrap(TUIColor.OCClass.whiteColor).colorWithAlphaComponent(0.75));
      if Assigned(FButton) then
      begin
        h.View.addSubview(FButton);
        FButton.layer.setShadowColor(TUIColor.OCClass.blackColor);
        FButton.layer.setShadowColor(TUIColor.Wrap(TUIColor.OCClass.blackColor).CGColor);
        FButton.layer.setShadowOffset(CGSizeMake(1,1));
        FButton.layer.setShadowRadius(5);
        FButton.layer.setShadowOpacity(0.75);
        h.View.sendSubviewToBack(FButton);
      end;
    end;
    {$ENDIF}

    if ExternalBrowser then
    begin
      if Assigned(FWebBrowser) then
      begin
        FWebBrowser.DisposeOf;
        FWebBrowser := nil;
      end;

      {$IFNDEF ANDROID}
      if Assigned(FWebBrowserForm) then
      begin
        FWebBrowserForm.Free;
        FWebBrowserForm := nil;
      end;
      {$ENDIF}

      Result := mrOk;
      Exit;
    end;

    {$IFNDEF ANDROID}
    if FModal then
    begin
      Result := FWebBrowserForm.ShowModal;
      {$IFDEF MACOS}
      {$IFNDEF IOS}
      FWebBrowserForm.Free;
      FWebBrowserForm := nil;
      {$ENDIF}
      {$ENDIF}
    end
    else
    begin
      FWebBrowserForm.Show;
      Result := mrOk;
    end;
    {$ELSE}
    Result := mrOk;
    {$ENDIF}
  finally
  end;
end;

{ TTMSFMXWebGMapsWebBrowserPopupForm }

procedure TTMSFMXWebGMapsWebBrowserPopupForm.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
begin
  inherited;
  UpdateBackGround;
end;

procedure TTMSFMXWebGMapsWebBrowserPopupForm.UpdateBackGround;
var
  wb: TTMSFMXWebGMapsCustomWebBrowser;
  {$IFDEF IOS}
  btn: UIButton;
  {$ENDIF}
begin
  if Assigned(FWebBrowserPopup) then
  begin
    wb := FWebBrowserPopup.FWebBrowser;
    if Assigned(wb) then
    begin
      if FWebBrowserPopup.FullScreen then
      begin
        wb.SetBounds(0, 0, Width, Height);
      end
      else
      begin
        {$IFDEF DELPHIXE6_LVL}
        case Position of
          TFormPosition.ScreenCenter, TFormPosition.DesktopCenter, TFormPosition.MainFormCenter,
            TFormPosition.OwnerFormCenter:
        {$ELSE}
        case Position of
          TFormPosition.poScreenCenter, TFormPosition.poDesktopCenter, TFormPosition.poMainFormCenter,
            TFormPosition.poOwnerFormCenter:
        {$ENDIF}
          begin
            wb.SetBounds((Width - FWebBrowserPopup.Width) / 2 , (Height - FWebBrowserPopup.Height) / 2, FWebBrowserPopup.Width, FWebBrowserPopup.Height);
          end;
          else
          begin
            wb.SetBounds(FWebBrowserPopup.Left, FWebBrowserPopup.Top, FWebBrowserPopup.Width, FWebBrowserPopup.Height);
          end;
        end;
      end;
      {$IFDEF IOS}
      if Assigned(FWebBrowserPopup.FButton) and FWebBrowserPopup.CloseButton then
      begin
        btn := FWebBrowserPopup.FButton;
        btn.setFrame(CGRectMake(wb.Position.X, wb.Position.Y - FWebBrowserPopup.FButton.frame.size.height, wb.Width, FWebBrowserPopup.FButton.frame.size.height));
        wb.Position.Y := wb.Position.Y + btn.frame.size.height;
        wb.Height := wb.Height - btn.frame.size.height;
        btn.setFrame(CGRectMake(wb.Position.X, wb.Position.Y - btn.frame.size.height, wb.Width, 30));
      end;
      {$ENDIF}
    end;
  end;
end;

{$IFDEF IOS}

{ TTMSFMXWebGMapsWebBrowserPopupButtonEventHandler }

procedure TTMSFMXWebGMapsWebBrowserPopupButtonEventHandler.Click;
begin
  if Assigned(FWebBrowserPopup) then
    FWebBrowserPopup.Close;
end;

function TTMSFMXWebGMapsWebBrowserPopupButtonEventHandler.GetObjectiveCClass: PTypeInfo;
begin
  Result := TypeInfo(ITMSFMXWebGMapsWebBrowserPopupButtonEventHandler);
end;
{$ENDIF}

{$IFDEF ANDROID}

{ TTMSFMXWebGMapsWebBrowserPopupButtonEventHandler }

procedure TTMSFMXWebGMapsWebBrowserPopupButtonEventHandler.onClick(P1: JView);
begin
  if Assigned(FWebBrowserPopup) then
    FWebBrowserPopup.Close;
end;

{$ENDIF}

{ TTMSFMXWebGMapsWebBrowserDocument }

constructor TTMSFMXWebGMapsWebBrowserDocument.Create(const AWebBrowser: ITMSFMXWebGMapsCustomWebBrowser);
begin
  FWebBrowser := AWebBrowser;
  FBody := TTMSFMXWebGMapsWebBrowserHTMLBodyElement.Create(AWebBrowser);
end;

destructor TTMSFMXWebGMapsWebBrowserDocument.Destroy;
begin
  FBody.Free;
  inherited;
end;

function TTMSFMXWebGMapsWebBrowserDocument.GetBody: TTMSFMXWebGMapsWebBrowserHTMLBodyElement;
begin
  Result := FBody;
end;

{ TTMSFMXWebGMapsWebBrowserHTMLElement }

constructor TTMSFMXWebGMapsWebBrowserHTMLElement.Create(
  const AWebBrowser: ITMSFMXWebGMapsCustomWebBrowser);
begin
  FWebBrowser := AWebBrowser;
end;

function TTMSFMXWebGMapsWebBrowserHTMLElement.GetInnerHTMLByName(AName: string): string;
begin
  if Assigned(FWebBrowser) then
  begin
    if AName = 'BODY' then
      Result := FWebBrowser.BodyInnerHTML;
  end;
end;

{ TTMSFMXWebGMapsWebBrowserHTMLBodyElement }

function TTMSFMXWebGMapsWebBrowserHTMLBodyElement.GetInnerHTML: string;
begin
  Result := InnerHTMLByName['BODY'];
end;

{$IFDEF NOFMXPACK}
{$IFNDEF DELPHI_LLVM}
{$IFDEF FREEWARE}
{$I TMSProductTrial.inc}
{$ENDIF}
{$ENDIF}

{$IFDEF DELPHI_LLVM}
initialization
{$ENDIF}
{$IFNDEF FREEWARE}
{$IFNDEF DELPHI_LLVM}
initialization
{$ENDIF}
{$ENDIF}
{$ELSE}
initialization
{$ENDIF}
  RegisterWebBrowserService;
  RegisterFmxClasses([TTMSFMXWebGMapsWebBrowser]);

finalization
  UnRegisterWebBrowserService;

end.
