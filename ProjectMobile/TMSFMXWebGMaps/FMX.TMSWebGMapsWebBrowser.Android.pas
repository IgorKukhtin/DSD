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

unit FMX.TMSWebGMapsWebBrowser.Android;

interface

{$I TMSDEFS.INC}
{$DEFINE USEJSOBJECT}

procedure RegisterWebBrowserService;
procedure UnRegisterWebBrowserService;

implementation

uses
  Classes, Math, SysUtils, FMX.Dialogs, FMX.Types, UITypes, Types, FMX.Forms, FMX.Platform, FMX.TMSWebGMapsWebBrowser
  {$IFDEF ANDROID}
  ,FMX.Platform.Android, AndroidApi.JNI.Embarcadero, AndroidApi.JNI.App, AndroidApi.JNIBridge, AndroidApi.JNI.Webkit,
  AndroidApi.JNI.JavaTypes, AndroidApi.JNI.Os, Androidapi.AppGlue, Androidapi.Input, AndroidApi.JNI.GraphicsContentViewText,
  AndroidApi.JNI.Net, AndroidApi.JNI.Widget, FMX.Helpers.Android
  {$IFDEF DELPHIXE6_LVL}
  ,AndroidApi.Helpers
  {$ENDIF}
  {$ENDIF}
  ;

type
  TTMSFMXAndroidWebGMapsWebBrowser = class;

  TTMSFMXAndroidWebGMapsWebBrowserService = class(TTMSFMXWebGMapsWebBrowserFactoryService)
  protected
    function DoCreateWebBrowser(const AValue: TTMSFMXWebGMapsCustomWebBrowser): ITMSFMXWebGMapsCustomWebBrowser; override;
    procedure DeleteCookies; override;
  end;

  {$IFDEF ANDROID}
  JCustomTabsIntent_Builder = interface;
  JCustomTabsIntent = interface;
  JURI = interface;

  JURIClass = interface(JObjectClass)
    ['{FB7B3704-4DEC-4796-866D-AB146E4D031F}']
  end;

  [JavaSignature('java/net/URI')]
  JURI = interface(JObject)
    ['{D1FFD342-BFFE-4DE0-9C0E-2BEC3BF75312}']
  end;
  TJURI = class(TJavaGenericImport<JURIClass, JURI>) end;

  JCustomTabsIntent_BuilderClass = interface(JObjectClass)
    ['{034D20C8-72C0-4129-B36D-F79731A2BBD9}']
    {class} function init: JCustomTabsIntent_Builder; cdecl; overload;
  end;

  [JavaSignature('android/support/customtabs/CustomTabsIntent$Builder')]
  JCustomTabsIntent_Builder = interface(JObject)
    ['{1219B554-E170-44E2-91F0-321A3ADB61C0}']
    function build: JCustomTabsIntent; cdecl;
  end;
  TJCustomTabsIntent_Builder = class(TJavaGenericImport<JCustomTabsIntent_BuilderClass, JCustomTabsIntent_Builder>) end;

  JCustomTabsIntentClass = interface(JObjectClass)
    ['{5BE926A8-8A77-4C3E-81AF-85E3B5C9C7D2}']
  end;

  [JavaSignature('android/support/customtabs/CustomTabsIntent')]
  JCustomTabsIntent = interface(JObject)
    ['{70E5A958-73B9-4A56-80F5-7F6754119223}']
    function _Getintent: JIntent; cdecl;
    property intent: JIntent read _Getintent;
    function _GetstartAnimationBundle: JBundle; cdecl;
    property startAnimationBundle: JBundle read _GetstartAnimationBundle;
  end;
  TJCustomTabsIntent = class(TJavaGenericImport<JCustomTabsIntentClass, JCustomTabsIntent>) end;

  TTMSFMXAndroidWebGMapsWebBrowserListener = class(TJavaLocal, JOnWebViewListener)
  private
    FStopLoading: Boolean;
    FWebBrowser: TTMSFMXAndroidWebGMapsWebBrowser;
  public
    procedure doUpdateVisitedHistory(view: JWebView; url: JString; isReload: Boolean); cdecl;
    procedure onFormResubmission(view: JWebView; dontResend: JMessage; resend: JMessage); cdecl;
    procedure onLoadResource(view: JWebView; url: JString); cdecl;
    procedure onPageFinished(view: JWebView; url: JString); cdecl;
    procedure onPageStarted(view: JWebView; url: JString; favicon: JBitmap); cdecl;
    procedure onReceivedError(view: JWebView; errorCode: Integer; description: JString; failingUrl: JString); cdecl;
    procedure onReceivedHttpAuthRequest(view: JWebView; handler: JHttpAuthHandler; host: JString; realm: JString); cdecl;
    procedure onReceivedSslError(view: JWebView; handler: JSslErrorHandler; error: JSslError); cdecl;
    procedure onScaleChanged(view: JWebView; oldScale: Single; newScale: Single); cdecl;
    procedure onUnhandledKeyEvent(view: JWebView; event: JKeyEvent); cdecl;
    function shouldOverrideKeyEvent(view: JWebView; event: JKeyEvent): Boolean; cdecl;
    function shouldOverrideUrlLoading(view: JWebView; url: JString): Boolean; cdecl;
  end;

  TTMSFMXAndroidWebGMapsWebBrowserClickListener = class(TJavaLocal, JView_OnClickListener)
  private
    FWebBrowser: TTMSFMXAndroidWebGMapsWebBrowser;
  public
    procedure onClick(v: JView); cdecl;
  end;

  TTMSFMXAndroidWebGMapsWebBrowserKeyListener = class(TJavaLocal, JView_OnKeyListener)
  private
    FWebBrowser: TTMSFMXAndroidWebGMapsWebBrowser;
  public   
    function onKey(v: JView; keyCode: Integer; event: JKeyEvent): Boolean; cdecl;
  end;

  TTMSFMXAndroidWebGMapsWebBrowserTouchListener = class(TJavaLocal, JView_OnTouchListener)
  private
    FFocusTimer: TTimer;
    FWebBrowser: TTMSFMXAndroidWebGMapsWebBrowser;
  protected
    procedure DoTimer(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    function onTouch(v: JView; event: JMotionEvent): Boolean; cdecl;
  end;
  {$ENDIF}

  TTMSFMXWebGMapsCustomWebBrowserProtected = class(TTMSFMXWebGMapsCustomWebBrowser);

  TTMSFMXAndroidWebGMapsWebBrowser = class(TInterfacedObject, ITMSFMXWebGMapsCustomWebBrowser)
  private
    {$IFDEF ANDROID}
    FWebBrowser: JWebBrowser;
    FWebBrowserWrapper: JDialog;
    FWebBrowserParams: JLinearLayout_LayoutParams;
    FWebBrowserLayout: JLinearLayout;
    FWebBrowserChromeClient: JWebChromeClient;
    FWebBrowserListener: TTMSFMXAndroidWebGMapsWebBrowserListener;
    FWebBrowserTouchListener: TTMSFMXAndroidWebGMapsWebBrowserTouchListener;
    FWebBrowserKeyListener: TTMSFMXAndroidWebGMapsWebBrowserKeyListener;
    {$IFDEF USEJSOBJECT}
    FJSObjectListener: TTMSFMXAndroidWebGMapsWebBrowserClickListener;
    FJSObject: JTextView;
    {$ENDIF}
    {$ENDIF}
    FURL: string;
    FExternalBrowser: Boolean;
    FJSInterfaceReady: Boolean;
    FJSInterfaceContent: string;
    FWebControl: TTMSFMXWebGMapsCustomWebBrowser;
  protected
    procedure WaitForJSInterface;
    procedure DoExit(Sender: TObject);
    procedure DoEnter(Sender: TObject);
    procedure RemoveFocus;
    procedure AddFocus;
    {$IFDEF ANDROID}
    function GetScale: Single;
    function GetOffset: TRect;
    {$ENDIF}
    function GetURL: string;
    procedure SetURL(const AValue: string);
    function GetExternalBrowser: Boolean;
    procedure SetExternalBrowser(const AValue: Boolean);
    procedure Navigate(const AURL: string); overload;
    procedure Navigate; overload;
    function ExecuteJavascript(AScript: String): String;
    procedure LoadHTML(AHTML: String);
    procedure LoadFile(AFile: String);
    procedure GoBack;
    procedure GoForward;
    procedure Close;
    procedure Reload;
    procedure StopLoading;
    procedure UpdateVisible;
    procedure UpdateEnabled;
    procedure UpdateBounds;
    procedure Initialize;
    procedure DeInitialize;
    function NativeBrowser: Pointer;
    function NativeDialog: Pointer;
    function GetBrowserInstance: IInterface;
    function IsFMXBrowser: Boolean;
    function CanGoBack: Boolean;
    function CanGoForward: Boolean;
    function BodyInnerHTML: string;
  public
    constructor Create(const AWebControl: TTMSFMXWebGMapsCustomWebBrowser);
  end;

var
  WebBrowserService: ITMSFMXWebGMapsWebBrowserService;

procedure RegisterWebBrowserService;
begin
  if not TPlatformServices.Current.SupportsPlatformService(ITMSFMXWebGMapsWebBrowserService, IInterface(WebBrowserService)) then
  begin
    WebBrowserService := TTMSFMXAndroidWebGMapsWebBrowserService.Create;
    TPlatformServices.Current.AddPlatformService(ITMSFMXWebGMapsWebBrowserService, WebBrowserService);
  end;
end;

procedure UnregisterWebBrowserService;
begin
  TPlatformServices.Current.RemovePlatformService(ITMSFMXWebGMapsWebBrowserService);
end;

function TTMSFMXAndroidWebGMapsWebBrowser.NativeDialog: Pointer;
begin
  Result := nil;
  {$IFDEF ANDROID}
  if Assigned(FWebBrowserWrapper) then
    Result := (FWebBrowserWrapper as ILocalObject).GetObjectID;
  {$ENDIF}
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

function TTMSFMXAndroidWebGMapsWebBrowser.GetOffset: TRect;
var
  NativeWin: JWindow;
  ContentRect: JRect;
begin
  NativeWin := SharedActivityEx.getWindow;
  if Assigned(NativeWin) then
  begin
    ContentRect := TJRect.Create;
    NativeWin.getDecorView.getDrawingRect(ContentRect);
    Result := Rect(ContentRect.left, ContentRect.top, ContentRect.right, ContentRect.bottom);
  end
  else
    Result := TRect.Empty;
end;

function TTMSFMXAndroidWebGMapsWebBrowser.GetScale: Single;
var
  Screensrv: IFMXScreenService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenSrv)) then
    Result := ScreenSrv.GetScreenScale
  else
    Result := 1;
end;
{$ENDIF}

procedure TTMSFMXAndroidWebGMapsWebBrowser.AddFocus;
begin
  {$IFDEF ANDROID}
  CallInUIThread(
  procedure
  var
    wn: JWindow;
  begin
    if Assigned(FWebBrowserWrapper) then
    begin
      wn := FWebBrowserWrapper.getWindow;
      if Assigned(wn) then
        wn.clearFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_NOT_FOCUSABLE or TJWindowManager_LayoutParams.JavaClass.FLAG_ALT_FOCUSABLE_IM);
    end;
  end
  );
  {$ENDIF}
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.RemoveFocus;
begin
  {$IFDEF ANDROID}
  CallInUIThread(
  procedure
  var
    wn: JWindow;
  begin
    if Assigned(FWebBrowserWrapper) then
    begin
      wn := FWebBrowserWrapper.getWindow;
      if Assigned(wn) and Assigned(FWebBrowser) then
      begin
        wn.addFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_NOT_FOCUSABLE or TJWindowManager_LayoutParams.JavaClass.FLAG_ALT_FOCUSABLE_IM);
        FWebBrowser.clearFocus;
      end;
    end;
  end
  );
  {$ENDIF}
end;

function TTMSFMXAndroidWebGMapsWebBrowser.GetBrowserInstance: IInterface;
begin

end;

function TTMSFMXAndroidWebGMapsWebBrowser.GetExternalBrowser: Boolean;
begin
  Result := FExternalBrowser;
end;

function TTMSFMXAndroidWebGMapsWebBrowser.GetURL: string;
begin
  Result := FURL;
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.GoBack;
begin
  {$IFDEF ANDROID}
  if not Assigned(FWebBrowser) then
    Exit;

  CallInUIThread(
  procedure
  begin
    FWebBrowser.goBack;
  end
  );
  {$ENDIF}
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.GoForward;
begin
  {$IFDEF ANDROID}
  if not Assigned(FWebBrowser) then
    Exit;

  CallInUIThread(
  procedure
  begin
    FWebBrowser.goForward;
  end
  );
  {$ENDIF}
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.Initialize;
begin
end;

function TTMSFMXAndroidWebGMapsWebBrowser.IsFMXBrowser: Boolean;
begin
  Result := False;
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.LoadFile(AFile: String);
begin
  {$IFDEF ANDROID}
  if not Assigned(FWebBrowser) then
    Exit;

  CallInUIThread(
  procedure
  begin
    FWebBrowser.loadUrl(StringToJString(AFile));
  end
  );
  {$ENDIF}
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.LoadHTML(AHTML: String);
begin
  {$IFDEF ANDROID}
  if not Assigned(FWebBrowser) then
    Exit;

  CallInUIThread(
  procedure
  begin
    FWebBrowser.loadDataWithBaseURL(StringToJString('x-data://base'),
      StringToJString(AHTML), StringToJString('text/html'), StringToJString('UTF-8'), nil);
  end
  );
  {$ENDIF}
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.Navigate(const AURL: string);
begin
  {$IFDEF ANDROID}
  CallInUIThread(
  procedure
  var
    b: JCustomTabsIntent_Builder;
    cb: JCustomTabsIntent;
    it: JIntent;
  begin
    if FExternalBrowser then
    begin
      b := TJCustomTabsIntent_Builder.JavaClass.init;
      cb := b.build;
      it := cb.intent;
      it.setData(StrToJURI(AURL));
      SharedActivityEx.startActivity(it, cb.startAnimationBundle);
    end
    else
    begin
      if not Assigned(FWebBrowser) then
        Exit;
      FWebBrowser.loadUrl(StringToJString(AURL));
    end;
  end
  );
  {$ENDIF}
end;

function TTMSFMXAndroidWebGMapsWebBrowser.NativeBrowser: Pointer;
begin
  Result := nil;
  {$IFDEF ANDROID}
  if Assigned(FWebBrowser) then
    Result := (FWebBrowser as ILocalObject).GetObjectID;
  {$ENDIF}
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.Navigate;
begin
  Navigate(FURL);
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.Reload;
begin
  {$IFDEF ANDROID}
  if not Assigned(FWebBrowser) then
    Exit;

  CallInUIThread(
  procedure
  begin
    FWebBrowser.reload;
  end
  );
  {$ENDIF}
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.SetExternalBrowser(const AValue: Boolean);
begin
  FExternalBrowser := AValue;
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.SetURL(const AValue: string);
begin
  FURL := AValue;
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.StopLoading;
begin
  {$IFDEF ANDROID}
  if not Assigned(FWebBrowser) then
    Exit;

  CallInUIThread(
  procedure
  begin
    FWebBrowser.stopLoading;
  end
  );
  {$ENDIF}
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.UpdateBounds;
{$IFDEF ANDROID}
var
  bd: TRect;
  sc: Single;
  offr: TRect;
  pos: TPointF;
  wn: JWindow;
  wlp: JWindowManager_LayoutParams;
{$ENDIF}
begin
  {$IFDEF ANDROID}
  if Assigned(FWebBrowserWrapper) and Assigned(FWebControl) and (FWebControl.Root <> nil)
    and (FWebControl.Root.GetObject is TCommonCustomForm) then
  begin
    CallInUIThread(
    procedure
    begin
      sc := GetScale;
      offr := GetOffset;

      if FWebControl.Parent is TCommonCustomForm then
        Pos := TPointF(offr.TopLeft) + FWebControl.Position.Point * sc
      else
        Pos := FWebControl.ParentControl.LocalToAbsolute(FWebControl.Position.Point) * sc;

      if FWebControl.Visible then
      begin
        bd := Rect(Round(Pos.X), Round(Pos.Y), Round(Pos.X + FWebControl.Width * sc), Round(Pos.Y + FWebControl.Height *
         sc));
        wn := FWebBrowserWrapper.getWindow;
        wlp := wn.getAttributes;
        wlp.x := bd.Left;
        wlp.y := bd.Top;
        wn.setLayout(bd.Width, bd.Height);
        FWebBrowserWrapper.show;
      end
      else
        FWebBrowserWrapper.hide;
    end
    );
  end;
  {$ENDIF}
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.UpdateEnabled;
begin
  if Assigned(FWebControl) then
  begin
    if not FWebControl.Enabled then
       RemoveFocus;
  end;
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.UpdateVisible;
begin
  UpdateBounds;
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.WaitForJSInterface;
var
  i: Integer;
begin
  i := 0;
  while not FJSInterfaceReady and (i <= 60000) do
  begin
    Application.ProcessMessages;
    Sleep(1);
    Inc(i);
  end;
end;

function TTMSFMXAndroidWebGMapsWebBrowser.BodyInnerHTML: string;
begin
  FJSInterfaceContent := '';
  FJSInterfaceReady := False;
  ExecuteJavaScript('injectedObject.setPrivateImeOptions(''JSINTERFACE:'' + document.body.innerHTML); injectedObject.performClick();');
  WaitForJSInterface;
  Result := FJSInterfaceContent;
end;

function TTMSFMXAndroidWebGMapsWebBrowser.CanGoBack: Boolean;
begin
  Result := False;
  {$IFDEF ANDROID}
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.canGoBack;
  {$ENDIF}
end;

function TTMSFMXAndroidWebGMapsWebBrowser.CanGoForward: Boolean;
begin
  Result := False;
  {$IFDEF ANDROID}
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.canGoForward;
  {$ENDIF}
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.Close;
begin
  TTMSFMXWebGMapsCustomWebBrowserProtected(FWebControl).DoCloseForm;
end;

constructor TTMSFMXAndroidWebGMapsWebBrowser.Create(const AWebControl: TTMSFMXWebGMapsCustomWebBrowser);
{$IFDEF ANDROID}
var
  wnd: JWindow;
  wlp: JWindowManager_LayoutParams;
{$ENDIF}
begin
  FExternalBrowser := False;
  FWebControl := AWebControl;
  FWebControl.CanFocus := True;
  FWebControl.OnExit := DoExit;
  FWebControl.OnEnter := DoEnter;

  {$IFDEF ANDROID}
  FWebBrowserListener := TTMSFMXAndroidWebGMapsWebBrowserListener.Create;
  FWebBrowserListener.FWebBrowser := Self;
  FWebBrowserTouchListener := TTMSFMXAndroidWebGMapsWebBrowserTouchListener.Create;
  FWebBrowserTouchListener.FWebBrowser := Self;
  FWebBrowserKeyListener := TTMSFMXAndroidWebGMapsWebBrowserKeyListener.Create;
  FWebBrowserKeyListener.FWebBrowser := Self;
  {$IFDEF USEJSOBJECT}
  FJSObjectListener := TTMSFMXAndroidWebGMapsWebBrowserClickListener.Create;
  FJSObjectListener.FWebBrowser := Self;
  {$ENDIF}

  CallInUIThreadAndWaitFinishing(
  procedure
  begin
    FWebBrowser := TJWebBrowser.JavaClass.init(SharedActivityEx);
    FWebBrowser.SetWebViewListener(FWebBrowserListener);
    FWebBrowser.setOnTouchListener(FWebBrowserTouchListener);
    FWebBrowser.setOnKeyListener(FWebBrowserKeyListener);

    FWebBrowserChromeClient := TJWebChromeClient.JavaClass.init;
    FWebBrowser.setWebChromeClient(FWebBrowserChromeClient);

    {$IFDEF USEJSOBJECT}
    FJSObject := TJTextView.JavaClass.init(SharedActivityEx);
    FJSObject.setOnClickListener(FJSObjectListener);
    FWebBrowser.addJavascriptInterface(FJSObject, StringToJString('injectedObject'));
    {$ENDIF}

    FWebBrowser.getSettings.setGeolocationEnabled(True);
    FWebBrowser.getSettings.setAppCacheEnabled(True);
    FWebBrowser.getSettings.setDatabaseEnabled(True);
    FWebBrowser.getSettings.setDomStorageEnabled(True);
    FWebBrowser.getSettings.setJavaScriptEnabled(True);
    FWebBrowser.getSettings.setSaveFormData(False);
    FWebBrowser.getSettings.setBuiltInZoomControls(True);
    FWebBrowser.getSettings.setDisplayZoomControls(False);
    FWebBrowser.getSettings.setLoadWithOverviewMode(True);
    FWebBrowser.getSettings.setUseWideViewPort(True);

    FWebBrowserParams := TJLinearLayout_LayoutParams.JavaClass.init(-1, -1);

    FWebBrowserLayout := TJLinearLayout.JavaClass.init(SharedActivityEx);
    FWebBrowserLayout.setOrientation(TJLinearLayout.JavaClass.VERTICAL);
    FWebBrowserLayout.addView(FWebBrowser, FWebBrowserParams);

    FWebBrowserWrapper := TJDialog.JavaClass.init(SharedActivityEx);
    FWebBrowserWrapper.setCancelable(false);
    wnd := FWebBrowserWrapper.getWindow;
    wnd.requestFeature(TJWindow.JavaClass.FEATURE_NO_TITLE);
    wnd.setWindowAnimations(-1);
    wnd.setBackgroundDrawable(TJColorDrawable.JavaClass.init(TJColor.JavaClass.TRANSPARENT));
    wlp := wnd.getAttributes;
    wlp.gravity := 3 or 48;
    wnd.setFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_NOT_TOUCH_MODAL, TJWindowManager_LayoutParams.JavaClass.FLAG_NOT_TOUCH_MODAL);
    wnd.clearFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_DIM_BEHIND);
    FWebBrowserWrapper.setContentView(FWebBrowserLayout);
  end
  );
  {$ENDIF}
  RemoveFocus;
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.DeInitialize;
begin
  {$IFDEF ANDROID}
  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.SetWebViewListener(nil);
    FWebBrowser.setOnTouchListener(nil);
    FWebBrowser.setOnKeyListener(nil);
  end;

  {$IFDEF USEJSOBJECT}
  if Assigned(FJSObject) then
  begin
    FJSObject.setOnClickListener(nil);
  end;
  {$ENDIF}

  if Assigned(FWebBrowserWrapper) then
  begin
    FWebBrowserWrapper.dismiss;
    FWebBrowserWrapper := nil;
  end;

  if Assigned(FWebBrowserListener) then
  begin
    FWebBrowserListener.Free;
    FWebBrowserListener := nil;
  end;

  if Assigned(FWebBrowserTouchListener) then
  begin
    FWebBrowserTouchListener.Free;
    FWebBrowserTouchListener := nil;
  end;

  if Assigned(FWebBrowserKeyListener) then
  begin
    FWebBrowserKeyListener.Free;
    FWebBrowserKeyListener := nil;
  end;

  {$IFDEF USEJSOBJECT}
  if Assigned(FJSObjectListener) then
  begin
    FJSObjectListener.Free;
    FJSObjectListener := nil;
  end;
  {$ENDIF}

  if Assigned(FWebBrowserChromeClient) then
    FWebBrowserChromeClient := nil;

  if Assigned(FWebBrowserLayout) then
    FWebBrowserLayout := nil;

  if Assigned(FWebBrowserParams) then
    FWebBrowserParams := nil;

  {$IFDEF USEJSOBJECT}
  if Assigned(FJSObject) then
    FJSObject := nil;
  {$ENDIF}

  if Assigned(FWebBrowser) then
    FWebBrowser := nil;
  {$ENDIF}
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.DoEnter(Sender: TObject);
begin
  AddFocus;
end;

procedure TTMSFMXAndroidWebGMapsWebBrowser.DoExit(Sender: TObject);
begin
  RemoveFocus;
end;

function TTMSFMXAndroidWebGMapsWebBrowser.ExecuteJavascript(AScript: String): String;
begin
  Result := '';
  {$IFDEF ANDROID}
  if not Assigned(FWebBrowser) then
    Exit;

  CallInUIThread(
  procedure
  begin
    if Assigned(FWebBrowser) then
      FWebBrowser.loadUrl(StringToJString('javascript:'+AScript));
  end
  );
  {$ENDIF}
end;

{ TTMSFMXAndroidWebGMapsWebBrowserService }

procedure TTMSFMXAndroidWebGMapsWebBrowserService.DeleteCookies;
begin
  {$IFDEF ANDROID}
  TJCookieManager.JavaClass.getInstance.removeAllCookie;
  {$ENDIF}
end;

function TTMSFMXAndroidWebGMapsWebBrowserService.DoCreateWebBrowser(const AValue: TTMSFMXWebGMapsCustomWebBrowser): ITMSFMXWebGMapsCustomWebBrowser;
begin
  Result := TTMSFMXAndroidWebGMapsWebBrowser.Create(AValue);
end;

{$IFDEF ANDROID}


{ TTMSFMXAndroidWebGMapsWebBrowserListener }

procedure TTMSFMXAndroidWebGMapsWebBrowserListener.doUpdateVisitedHistory(
  view: JWebView; url: JString; isReload: Boolean);
begin

end;

procedure TTMSFMXAndroidWebGMapsWebBrowserListener.onFormResubmission(view: JWebView;
  dontResend, resend: JMessage);
begin

end;

procedure TTMSFMXAndroidWebGMapsWebBrowserListener.onLoadResource(view: JWebView;
  url: JString);
begin

end;

procedure TTMSFMXAndroidWebGMapsWebBrowserListener.onPageFinished(view: JWebView;
  url: JString);
var
  Params: TTMSFMXWebGMapsCustomWebBrowserNavigateCompleteParams;
begin
  if not FStopLoading then
  begin
    Params.URL := JStringToString(url);
    if Assigned(FWebBrowser.FWebControl) then
    begin
      FWebBrowser.FURL := Params.URL;
      TThread.Queue(nil,
      procedure
      begin
        TTMSFMXWebGMapsCustomWebBrowserProtected(FWebBrowser.FWebControl).NavigateComplete(Params);
      end
      );
    end;
  end;
end;

procedure TTMSFMXAndroidWebGMapsWebBrowserListener.onPageStarted(view: JWebView;
  url: JString; favicon: JBitmap);
begin

end;

procedure TTMSFMXAndroidWebGMapsWebBrowserListener.onReceivedError(view: JWebView;
  errorCode: Integer; description, failingUrl: JString);
begin

end;

procedure TTMSFMXAndroidWebGMapsWebBrowserListener.onReceivedHttpAuthRequest(
  view: JWebView; handler: JHttpAuthHandler; host, realm: JString);
begin

end;

procedure TTMSFMXAndroidWebGMapsWebBrowserListener.onReceivedSslError(view: JWebView;
  handler: JSslErrorHandler; error: JSslError);
begin

end;

procedure TTMSFMXAndroidWebGMapsWebBrowserListener.onScaleChanged(view: JWebView;
  oldScale, newScale: Single);
begin

end;

procedure TTMSFMXAndroidWebGMapsWebBrowserListener.onUnhandledKeyEvent(view: JWebView;
  event: JKeyEvent);
begin

end;

function TTMSFMXAndroidWebGMapsWebBrowserListener.shouldOverrideKeyEvent(view: JWebView;
  event: JKeyEvent): Boolean;
begin
  Result := False;
end;

function TTMSFMXAndroidWebGMapsWebBrowserListener.shouldOverrideUrlLoading(
  view: JWebView; url: JString): Boolean;
var
  Params: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams;
begin
  FStopLoading := False;
  Params.URL := JStringToString(url);
  Params.Cancel := False;
  if Assigned(FWebBrowser.FWebControl) then
  begin
    FWebBrowser.FURL := Params.URL;
    TThread.Synchronize(nil,
    procedure
    begin
      TTMSFMXWebGMapsCustomWebBrowserProtected(FWebBrowser.FWebControl).BeforeNavigate(Params);
    end
    );
  end;
  Result := Params.Cancel;
  FStopLoading := Result;
  if Result then
    view.stopLoading;
end;

{ TTMSFMXAndroidWebGMapsWebBrowserClickListener }

procedure TTMSFMXAndroidWebGMapsWebBrowserClickListener.onClick(v: JView);
var
  Params: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams;
  s: string;
begin
  Params.Cancel := False;
  {$IFDEF USEJSOBJECT}
  if Assigned(FWebBrowser.FWebControl) and Assigned(FWebBrowser.FJSObject) then
  begin
    s := JStringToString(FWebBrowser.FJSObject.getPrivateImeOptions);
    if s.ToUpper.StartsWith('JSINTERFACE:') then
    begin
      FWebBrowser.FJSInterfaceContent := s.Remove(0, Length('JSINTERFACE:'));
      FWebBrowser.FJSInterfaceReady := True;
    end
    else
  {$ELSE}
  if Assigned(FWebBrowser.FWebControl) then
  begin
  {$ENDIF}
    begin
      Params.URL := s;
      FWebBrowser.FURL := Params.URL;
      TThread.Queue(nil,
      procedure
      begin
        TTMSFMXWebGMapsCustomWebBrowserProtected(FWebBrowser.FWebControl).BeforeNavigate(Params);
      end
      );
    end;
  end;
end;

{ TTMSFMXAndroidWebGMapsWebBrowserTouchListener }

constructor TTMSFMXAndroidWebGMapsWebBrowserTouchListener.Create;
begin
  inherited Create;
  FFocusTimer := TTimer.Create(nil);
  FFocusTimer.Enabled := false;
  FFocusTimer.Interval := 1;
  FFocusTimer.OnTimer := DoTimer;
end;

procedure TTMSFMXAndroidWebGMapsWebBrowserTouchListener.DoTimer(Sender: TObject);
begin
  CallInUIThread(
  procedure
  begin
    if Assigned(FWebBrowser) and Assigned(FWebBrowser.FWebControl) then
      FWebBrowser.FWebControl.SetFocus;
  end
  );

  FFocusTimer.Enabled := False;
end;

destructor TTMSFMXAndroidWebGMapsWebBrowserTouchListener.Destroy;
begin
  FFocusTimer.Free;
  inherited;
end;

function TTMSFMXAndroidWebGMapsWebBrowserTouchListener.onTouch(v: JView; event: JMotionEvent): Boolean;
var
  b: Boolean;
begin
  Result := False;
  if not Assigned(FWebBrowser) or not Assigned(FWebBrowser.FWebControl) or not Assigned(FWebBrowser.FWebBrowserWrapper) then
    Exit;

  b := FWebBrowser.FWebControl.Enabled;
  if not b then
    Result := True
  else
  begin
    FFocusTimer.Enabled := True;
  end;
end;

function TTMSFMXAndroidWebGMapsWebBrowserKeyListener.onKey(v: JView; keyCode: Integer; event: JKeyEvent): Boolean;
begin
  Result := False;
  if Assigned(FWebBrowser) and Assigned(FWebBrowser.FWebControl) and (keyCode = TJKeyEvent.JavaClass.KEYCODE_BACK) then
  begin
    Result := True;
    TTMSFMXWebGMapsCustomWebBrowserProtected(FWebBrowser.FWebControl).DoHardwareButtonClicked;
  end;
end;

{$ENDIF}

initialization
begin
  {$IFDEF ANDROID}
  TRegTypes.RegisterType('FMX.TMSWebGMapsWebBrowser.Android.JCustomTabsIntent_Builder', TypeInfo(FMX.TMSWebGMapsWebBrowser.Android.JCustomTabsIntent_Builder));
  TRegTypes.RegisterType('FMX.TMSWebGMapsWebBrowser.Android.JCustomTabsIntent', TypeInfo(FMX.TMSWebGMapsWebBrowser.Android.JCustomTabsIntent));
  {$ENDIF}
end;


end.
