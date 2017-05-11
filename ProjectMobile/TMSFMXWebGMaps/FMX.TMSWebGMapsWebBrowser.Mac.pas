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

unit FMX.TMSWebGMapsWebBrowser.Mac;

interface

{$I TMSDEFS.INC}

{$IFDEF MACOS}
{$IFNDEF IOS}
uses
  FMX.Platform.Mac, MacApi.AppKit, TypInfo, MacApi.Foundation, MacApi.CocoaTypes, MacApi.ObjectiveC
  {$IFDEF DELPHIXE6_LVL}
  ,MacApi.Helpers
  {$ENDIF}
  ;
{$ENDIF}
{$ENDIF}

const
  WebKitFWK: string = '/System/Library/Frameworks/WebKit.framework/WebKit';

  {$IFDEF MACOS}
  {$IFNDEF IOS}
type
  WebFrame = interface;

  WebScriptObjectClass = interface(NSObjectClass)
    ['{2576DDC6-AA80-4A68-BBC9-955DDE842A9D}']
  end;
  WebScriptObject = interface(NSObject)
    ['{EFE6F7FC-AC86-45CC-A171-9065BB182143}']
  end;
  TWebscriptObject = class(TOCGenericImport<WebscriptObjectClass, WebscriptObject>);

  DOMObjectClass = interface(WebScriptObjectClass)
    ['{78F1F4DE-96A8-4926-8B9C-87C19BDC665F}']
  end;
  DOMObject = interface(WebScriptObject)
    ['{1D46DAA6-5BA4-4503-B186-F6D882C99EC5}']
  end;
  TDOMObject = class(TOCGenericImport<DOMObjectClass, DOMObject>);

  DOMNodeClass = interface(DOMObjectClass)
    ['{DE1B90C4-4569-4AC8-B785-EFF764C92EF3}']
  end;
  DOMNode = interface(DOMObject)
    ['{D02FFA86-098E-4CAF-9E5D-C22ABD88377A}']
  end;
  TDOMNode = class(TOCGenericImport<DOMNodeClass, DOMNode>);

  DOMElementClass = interface(DOMNodeClass)
    ['{D2F52A44-F1B4-46DE-B13B-B9F35E235D88}']
  end;
  DOMElement = interface(DOMNode)
    ['{FEE655DE-49F0-4289-98AE-53014D9C939E}']
  end;
  TDOMElement = class(TOCGenericImport<DOMElementClass, DOMElement>);

  DOMHTMLElementClass = interface(DOMElementClass)
    ['{133E2466-3BDF-483D-B020-C326140831F7}']
  end;
  DOMHTMLElement = interface(DOMElement)
    ['{9C5BBD54-BF96-43C6-8ACB-1BF696EE6F93}']
    procedure setInnerHTML(innerHTML: NSString); cdecl;
    function innerHTML: NSString; cdecl;
  end;
  TDOMHTMLElement = class(TOCGenericImport<DOMHTMLElementClass, DOMHTMLElement>);

  DOMDocumentClass = interface(DOMNodeClass)
    ['{1158F247-E358-4459-8C7A-2A9EDBA15B9C}']
  end;
  DOMDocument = interface(DOMNode)
    ['{19BE2958-D3FA-4A9F-915B-7B2581C8485D}']
    function WebFrame: WebFrame; cdecl;
    function documentElement: DOMElement; cdecl;
    function body: DOMHTMLElement; cdecl;
  end;
  TDOMDocument = class(TOCGenericImport<DOMDocumentClass, DOMDocument>);

  WebDataSource = interface(NSObject)
  ['{8EF3BF84-B001-442E-9314-94F0AD89F89C}']
    function request: NSMutableURLRequest; cdecl;
  end;

  WebFrameClass = interface(NSObjectClass)
  ['{32BA1A52-3E5D-452E-B1F4-B29C35F54898}']
  end;

  WebFrame = interface(NSObject)
  ['{54403F6D-3042-4714-87B7-E8CBB8EFF0E8}']
    procedure loadRequest(request: NSURLRequest); cdecl;
    procedure loadHTMLString(_string: NSString; baseURL: NSURL); cdecl;
    function provisionalDataSource: WebDataSource; cdecl;
    function DOMDocument: DOMDocument; cdecl;
  end;
  TWebFrame = class(TOCGenericImport<WebFrameClass, WebFrame>)  end;

  WebBackForwardListClass = interface(NSObjectClass)
  ['{2E6BB3DC-3650-475B-B131-0F1D1C0346BC}']
  end;

  WebBackForwardList = interface(NSObject)
  ['{35D41E96-696C-4EBC-AC8B-8F311A309C6F}']
  end;
  TWebBackForwardList = class(TOCGenericImport<WebBackForwardListClass, WebBackForwardList>) end;

  WebHistoryItemClass = interface(NSObjectClass)
  ['{F23C21C0-3BFB-4FF8-AE64-1DBE5F70D9C3}']
  end;

  WebHistoryItem = interface(NSObject)
  ['{51C038FC-B6CB-4C3E-A8E1-A0B5B5F64B03}']
  end;
  TWebHistoryItem = class(TOCGenericImport<WebHistoryItemClass, WebHistoryItem>) end;

  WebViewClass = interface(NSViewClass)
  ['{0D9F44B7-09FD-4E35-B96E-8DB71B9A2537}']
    {class} function canShowMIMEType(MIMEType: NSString): Boolean; cdecl;
  end;

  WebView = interface;

  WebPolicyDecisionListener = interface(NSObject)
  ['{1232D69C-C97E-4ED9-A6D6-B01D7269F81B}']
  procedure use; cdecl;
  procedure ignore; cdecl;
  end;

  WebPolicyDelegate = interface(IOBjectiveC)
    procedure webView(webView: WebView; decidePolicyForNavigationAction: NSDictionary; request: NSURLRequest; frame: WebFrame; decisionListener: WebPolicyDecisionListener); cdecl;
  end;

  WebFrameLoadDelegate = interface(IObjectiveC)
    procedure webView(sender: WebView; didFinishLoadForFrame: WebFrame); overload; cdecl;
  end;

  WebUIDelegate = interface(IObjectiveC)
    function webView(sender: WebView; dragDestinationActionMaskForDraggingInfo: Pointer): NSUInteger; cdecl;
  end;

  WebView = interface(NSView)
  ['{4ED62DC8-85B2-4AF8-94D6-DCBAF00A4ACB}']
    procedure close; cdecl;
    procedure setCustomUserAgent(customUserAgent: NSString); cdecl;
    function shouldCloseWithWindow: Boolean; cdecl;
    procedure setShouldCloseWithWindow(shouldCloseWithWindow: Boolean); cdecl;
    procedure stopLoading(sender: Pointer); cdecl;
    procedure takeStringURLFrom(sender: Pointer); cdecl;
    procedure reload(sender: Pointer); cdecl;
    procedure reloadFromOrigin(sender: Pointer); cdecl;
    function estimatedProgress: Double; cdecl;
    function drawsBackGround: Boolean; cdecl;
    procedure setDrawsBackGround(drawsBackGround: Boolean); cdecl;
    procedure setShouldUpdateWhileOffscreen(updateWhileOffscreen: Boolean); cdecl;
    function backForwardList: WebBackForwardList; cdecl;
    function shouldUpdateWhileOffscreen: Boolean; cdecl;
    procedure setMaintainsBackForwardList(flag: Boolean); cdecl;
    procedure setHostWindow(hostWindow: NSWindow); cdecl;
    function initWithFrame(frame: NSRect; frameName: NSString; groupName: NSString): Pointer; cdecl;
    function mainFrame: WebFrame; cdecl;
    function mainFrameURL: NSString; cdecl;
    procedure setFrameLoadDelegate(delegate: Pointer); cdecl;
    procedure setPolicyDelegate(delegate: Pointer); cdecl;
    procedure setUIDelegate(delegate: WebUIDelegate); cdecl;
    function frameLoadDelegate: WebFrameLoadDelegate; cdecl;
    function policyDelegate: WebPolicyDelegate; cdecl;
    function UIDelegate: WebUIDelegate; cdecl;
    function canGoBack: Boolean; cdecl;
    function isLoading: Boolean; cdecl;
    function selectedFrame: WebFrame; cdecl;
    function canGoForward: Boolean; cdecl;
    procedure goBack(sender: Pointer); cdecl; overload;
    function goBack: Boolean; cdecl; overload;
    procedure goForward(sender: Pointer); cdecl; overload;
    function goForward: Boolean; cdecl; overload;
    function goToBackForwardItem(item: WebHistoryItem): Boolean; cdecl;
    function stringByEvaluatingJavaScriptFromString(script: NSString): NSString; cdecl;
    function searchFor(searchStr: NSString; direction: Boolean; caseSensitive: Boolean; wrap: Boolean): Boolean; cdecl;
  end;
  TWebView = class(TOCGenericImport<WebViewClass, WebView>)  end;

  WebGMapsWebViewEx = interface(WebView)
  ['{A55D32B2-7EA4-4EAA-B7B5-408135AC4604}']
    function hitTest(aPoint: NSPoint): NSView; cdecl;
  end;
  {$ENDIF}
  {$ENDIF}

procedure RegisterWebBrowserService;
procedure UnRegisterWebBrowserService;

implementation

uses
  Classes, Math, SysUtils, FMX.Types, Types, FMX.Forms, FMX.Platform, FMX.TMSWebGMapsWebBrowser;

type
  TTMSFMXMacWebGMapsWebBrowser = class;

  TTMSFMXMacWebGMapsWebBrowserService = class(TTMSFMXWebGMapsWebBrowserFactoryService)
  protected
    function DoCreateWebBrowser(const AValue: TTMSFMXWebGMapsCustomWebBrowser): ITMSFMXWebGMapsCustomWebBrowser; override;
    procedure DeleteCookies; override;
  end;

  {$IFDEF MACOS}
  {$IFNDEF IOS}
  TTMSFMXMacWebGMapsWebBrowserFrameDelegate = class(TOCLocal, WebFrameLoadDelegate)
  private
    FWebBrowser: TTMSFMXMacWebGMapsWebBrowser;
  public
    procedure webView(sender: WebView; didFinishLoadForFrame: WebFrame); overload; cdecl;
  end;

  TTMSFMXMacWebGMapsWebBrowserPolicyDelegate = class(TOCLocal, WebPolicyDelegate)
  private
    FWebBrowser: TTMSFMXMacWebGMapsWebBrowser;
  public
     procedure webView(webView: WebView; decidePolicyForNavigationAction: NSDictionary; request: NSURLRequest; frame: WebFrame; decisionListener: WebPolicyDecisionListener); cdecl;
  end;

  TTMSFMXMacWebGMapsWebBrowserEx = class(TOCLocal)
  private
    FWebBrowser: TTMSFMXMacWebGMapsWebBrowser;
  public
    constructor Create;
    function GetObjectiveCClass: PTypeInfo; override;
    function hitTest(aPoint: NSPoint): NSView; cdecl;
  end;
  {$ENDIF}
  {$ENDIF}

  TTMSFMXWebGMapsCustomWebBrowserProtected = class(TTMSFMXWebGMapsCustomWebBrowser);

  TTMSFMXMacWebGMapsWebBrowser = class(TInterfacedObject, ITMSFMXWebGMapsCustomWebBrowser)
  private
    {$IFDEF MACOS}
    {$IFNDEF IOS}
    FWebBrowser: WebView;
    FWebBrowserLocal: TTMSFMXMacWebGMapsWebBrowserEx;
    FWebBrowserFrameDelegate: TTMSFMXMacWebGMapsWebBrowserFrameDelegate;
    FWebBrowserPolicyDelegate: TTMSFMXMacWebGMapsWebBrowserPolicyDelegate;
    {$ENDIF}
    {$ENDIF}
    FURL: string;
    FExternalBrowser: Boolean;
    FWebControl: TTMSFMXWebGMapsCustomWebBrowser;
  protected
    function GetURL: string;
    procedure SetURL(const AValue: string);
    function GetExternalBrowser: Boolean;
    procedure SetExternalBrowser(const AValue: Boolean);
    procedure Navigate(const AURL: string); overload;
    procedure Navigate; overload;
    function ExecuteJavascript(AScript: String): String;
    procedure LoadHTML(AHTML: String);
    procedure LoadFile(AFile: String);
    procedure GoForward;
    procedure GoBack;
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
    WebBrowserService := TTMSFMXMacWebGMapsWebBrowserService.Create;
    TPlatformServices.Current.AddPlatformService(ITMSFMXWebGMapsWebBrowserService, WebBrowserService);
  end;
end;

procedure UnregisterWebBrowserService;
begin
  TPlatformServices.Current.RemovePlatformService(ITMSFMXWebGMapsWebBrowserService);
end;

function TTMSFMXMacWebGMapsWebBrowser.GetBrowserInstance: IInterface;
begin

end;

function TTMSFMXMacWebGMapsWebBrowser.GetExternalBrowser: Boolean;
begin
  Result := FExternalBrowser;
end;

function TTMSFMXMacWebGMapsWebBrowser.GetURL: string;
begin
  Result := FURL;
end;

procedure TTMSFMXMacWebGMapsWebBrowser.GoBack;
begin
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) then
    FWebBrowser.goBack;
  {$ENDIF}
  {$ENDIF}
end;

procedure TTMSFMXMacWebGMapsWebBrowser.GoForward;
begin
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) then
    FWebBrowser.goForward;
  {$ENDIF}
  {$ENDIF}
end;

procedure TTMSFMXMacWebGMapsWebBrowser.Initialize;
{$IFDEF MACOS}
{$IFNDEF IOS}
var
  vw: NSView;
  frm: TCommonCustomForm;
{$ENDIF}
{$ENDIF}
begin
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) then
  begin
    if (FWebControl <> nil) and (FWebControl.Root <> nil) and (FWebControl.Root.GetObject is TCommonCustomForm) then
    begin
      frm := TCommonCustomForm(FWebControl.Root.GetObject);
      vw := WindowHandleToPlatform(frm.Handle).View;
      vw.addSubview(FWebBrowser);
    end;
  end;
  {$ENDIF}
  {$ENDIF}
end;

function TTMSFMXMacWebGMapsWebBrowser.BodyInnerHTML: string;
begin
  Result := '';
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) and Assigned(FWebBrowser.mainFrame) and Assigned(FWebBrowser.mainFrame.DOMDocument)
    and Assigned(FWebBrowser.mainFrame.DOMDocument.body) then
  begin
    Result := UTF8ToString(FWebBrowser.mainFrame.DOMDocument.body.innerHTML.UTF8String);
  end;
  {$ENDIF}
  {$ENDIF}
end;

function TTMSFMXMacWebGMapsWebBrowser.IsFMXBrowser: Boolean;
begin
  Result := False;
end;

procedure TTMSFMXMacWebGMapsWebBrowser.LoadFile(AFile: String);
{$IFDEF MACOS}
{$IFNDEF IOS}
var
  url: NSUrl;
  requestobj: NSURLRequest;
{$ENDIF}
{$ENDIF}
begin
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) then
  begin
    url := TNSURL.Wrap(TNSURL.OCClass.fileURLWithPath(NSStrEx(AFile)));
    requestobj := TNSURLRequest.Wrap(TNSURLRequest.OCClass.requestWithURL(url));
    FWebBrowser.mainFrame.loadRequest(requestobj);
  end;
  {$ENDIF}
  {$ENDIF}
end;

procedure TTMSFMXMacWebGMapsWebBrowser.LoadHTML(AHTML: String);
begin
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) then
    FWebBrowser.mainFrame.loadHTMLString(NSStrEx(AHTML), nil);
  {$ENDIF}
  {$ENDIF}
end;

procedure TTMSFMXMacWebGMapsWebBrowser.Navigate(const AURL: string);
{$IFDEF MACOS}
{$IFNDEF IOS}
var
  urlobj: NSURL;
  requestobj: NSURLRequest;
{$ENDIF}
{$ENDIF}
begin
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if FExternalBrowser then
  begin
    TNSWorkspace.Wrap(TNSWorkspace.OCClass.sharedWorkspace).openURL(TNSURL.Wrap(TNSURL.OCClass.URLWithString(NSStrEx(AUrl))));
  end
  else
  begin
    if Assigned(FWebBrowser) then
    begin
      urlobj := TNSURL.Wrap(TNSURL.OCClass.URLWithString(NSStrEx(AURL)));
      requestobj := TNSURLRequest.Wrap(TNSURLRequest.OCClass.requestWithURL(urlobj));
      FWebBrowser.mainFrame.loadRequest(requestobj);
    end;
  end;
  {$ENDIF}
  {$ENDIF}
end;

function TTMSFMXMacWebGMapsWebBrowser.NativeBrowser: Pointer;
begin
  Result := nil;
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) then
    Result := (FWebBrowser as ILocalObject).GetObjectID;
  {$ENDIF}
  {$ENDIF}
end;

function TTMSFMXMacWebGMapsWebBrowser.NativeDialog: Pointer;
begin
  Result := nil;
end;

procedure TTMSFMXMacWebGMapsWebBrowser.Navigate;
begin
  Navigate(FURL);
end;

procedure TTMSFMXMacWebGMapsWebBrowser.Reload;
begin
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) then
    FWebBrowser.reload(nil);
  {$ENDIF}
  {$ENDIF}
end;

procedure TTMSFMXMacWebGMapsWebBrowser.SetExternalBrowser(const AValue: Boolean);
begin
  FExternalBrowser := AValue;
end;

procedure TTMSFMXMacWebGMapsWebBrowser.SetURL(const AValue: string);
begin
  FURL := AValue;
end;

procedure TTMSFMXMacWebGMapsWebBrowser.StopLoading;
begin
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) then
    FWebBrowser.stopLoading(nil);
  {$ENDIF}
  {$ENDIF}
end;

procedure TTMSFMXMacWebGMapsWebBrowser.UpdateBounds;
{$IFDEF MACOS}
{$IFNDEF IOS}
var
  vw: NSView;
  bd: TRectF;
  frm: TCommonCustomForm;
  frmr: NSRect;
{$ENDIF}
{$ENDIF}
begin
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) then
  begin
    if (FWebControl <> nil) and (FWebControl.Root <> nil) and (FWebControl.Root.GetObject is TCommonCustomForm) then
    begin
      frm := TCommonCustomForm(FWebControl.Root.GetObject);
      bd := TRectF.Create(0,0,FWebControl.Width,FWebControl.Height);
      bd.Fit(FWebControl.AbsoluteRect);
      vw := WindowHandleToPlatform(frm.Handle).View;
      frmr.origin.x := bd.Left;
      frmr.origin.y := bd.Top;
      frmr.size.width := bd.Width;
      frmr.size.height := bd.Height;
      frmr.origin.y := - frmr.origin.y + vw.frame.size.height - frmr.size.height;
      FWebBrowser.setFrame(frmr);
    end;
  end;
  {$ENDIF}
  {$ENDIF}
end;

procedure TTMSFMXMacWebGMapsWebBrowser.UpdateEnabled;
begin
end;

procedure TTMSFMXMacWebGMapsWebBrowser.UpdateVisible;
begin
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) and Assigned(FWebControl) then
    FWebBrowser.setHidden(not FWebControl.Visible);
  {$ENDIF}
  {$ENDIF}
end;

function TTMSFMXMacWebGMapsWebBrowser.CanGoBack: Boolean;
begin
  Result := False;
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.canGoBack;
  {$ENDIF}
  {$ENDIF}
end;

function TTMSFMXMacWebGMapsWebBrowser.CanGoForward: Boolean;
begin
  Result := False;
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.canGoForward;
  {$ENDIF}
  {$ENDIF}
end;

procedure TTMSFMXMacWebGMapsWebBrowser.Close;
begin
  TTMSFMXWebGMapsCustomWebBrowserProtected(FWebControl).DoCloseForm;
end;

constructor TTMSFMXMacWebGMapsWebBrowser.Create(const AWebControl: TTMSFMXWebGMapsCustomWebBrowser);
begin
  FWebControl := AWebControl;
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  LoadLibrary(PWideChar(WebKitFWK));
  FWebBrowserFrameDelegate := TTMSFMXMacWebGMapsWebBrowserFrameDelegate.Create;
  FWebBrowserFrameDelegate.FWebBrowser := Self;
  FWebBrowserPolicyDelegate := TTMSFMXMacWebGMapsWebBrowserPolicyDelegate.Create;
  FWebBrowserPolicyDelegate.FWebBrowser := Self;
  FWebBrowserLocal := TTMSFMXMacWebGMapsWebBrowserEx.Create;
  FWebBrowserLocal.FWebBrowser := Self;
  FWebBrowser := WebView(FWebBrowserLocal.Super);
  {$IFNDEF DELPHIXE9_LVL}
  FWebBrowser.setWantsLayer(True);
  {$ENDIF}
  FWebBrowser.setFrameLoadDelegate(ILocalObject(FWebBrowserFrameDelegate).GetObjectID);
  FWebBrowser.setPolicyDelegate(ILocalObject(FWebBrowserPolicyDelegate).GetObjectID);
  {$ENDIF}
  {$ENDIF}
end;

procedure TTMSFMXMacWebGMapsWebBrowser.DeInitialize;
begin
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.setFrameLoadDelegate(nil);
    FWebBrowser.setPolicyDelegate(nil);
  end;

  if Assigned(FWebBrowserPolicyDelegate) then
  begin
    FWebBrowserPolicyDelegate.Free;
    FWebBrowserPolicyDelegate := nil;
  end;

  if Assigned(FWebBrowserFrameDelegate) then
  begin
    FWebBrowserFrameDelegate.Free;
    FWebBrowserFrameDelegate := nil;
  end;

  if Assigned(FWebBrowserLocal) then
  begin
    FWebBrowserLocal.Free;
    FWebBrowserLocal := nil;
  end;

  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.removeFromSuperview;
    FWebBrowser.release;
    FWebBrowser := nil;
  end;
  {$ENDIF}
  {$ENDIF}
end;

function TTMSFMXMacWebGMapsWebBrowser.ExecuteJavascript(AScript: String): String;
begin
  Result := '';
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  if Assigned(FWebBrowser) then
    Result := UTF8ToString(FWebBrowser.stringByEvaluatingJavaScriptFromString(NSStrEx(AScript)).UTF8String);
  {$ENDIF}
  {$ENDIF}
end;

{ TTMSFMXMacWebGMapsWebBrowserService }

procedure TTMSFMXMacWebGMapsWebBrowserService.DeleteCookies;
{$IFDEF MACOS}
{$IFNDEF IOS}
var
  storage: NSHTTPCookieStorage;
  I: Integer;
  cnt: Integer;
{$ENDIF}
{$ENDIF}
begin
{$IFDEF MACOS}
{$IFNDEF IOS}
  storage := TNSHTTPCookieStorage.Wrap(TNSHTTPCookieStorage.OCClass.sharedHTTPCookieStorage);
  cnt := storage.cookies.count;
  for I := cnt - 1 downto 0 do
    storage.deleteCookie(TNSHTTPCookie.Wrap(storage.cookies.objectAtIndex(I)));

  TNSUserDefaults.Wrap(TNSUserDefaults.OCClass.standardUserDefaults).synchronize;
{$ENDIF}
{$ENDIF}
end;

function TTMSFMXMacWebGMapsWebBrowserService.DoCreateWebBrowser(const AValue: TTMSFMXWebGMapsCustomWebBrowser): ITMSFMXWebGMapsCustomWebBrowser;
begin
  Result := TTMSFMXMacWebGMapsWebBrowser.Create(AValue);
end;

{$IFDEF MACOS}
{$IFNDEF IOS}

{ TTMSFMXMacWebGMapsWebBrowserFrameDelegate }

procedure TTMSFMXMacWebGMapsWebBrowserFrameDelegate.webView(sender: WebView;
  didFinishLoadForFrame: WebFrame);
var
  Params: TTMSFMXWebGMapsCustomWebBrowserNavigateCompleteParams;
begin
  Params.URL := UTF8ToString(sender.mainFrameURL.UTF8String);
  if Assigned(FWebBrowser.FWebControl) then
  begin
    FWebBrowser.FURL := Params.URL;
    TTMSFMXWebGMapsCustomWebBrowserProtected(FWebBrowser.FWebControl).NavigateComplete(Params);
  end;
end;

{ TTMSFMXMacWebGMapsWebBrowserPolicyDelegate }

procedure TTMSFMXMacWebGMapsWebBrowserPolicyDelegate.webView(webView: WebView;
  decidePolicyForNavigationAction: NSDictionary; request: NSURLRequest;
  frame: WebFrame; decisionListener: WebPolicyDecisionListener);
var
  Params: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams;
begin
  Params.URL := UTF8ToString(request.URL.absoluteString.UTF8String);
  Params.Cancel := False;
  if Assigned(FWebBrowser.FWebControl) then
  begin
    FWebBrowser.FURL := Params.URL;
    TTMSFMXWebGMapsCustomWebBrowserProtected(FWebBrowser.FWebControl).BeforeNavigate(Params);
  end;
  if not Params.Cancel then
    decisionListener.use
  else
    decisionListener.ignore;
end;

{ TTMSFMXMacWebGMapsWebBrowserEx }

constructor TTMSFMXMacWebGMapsWebBrowserEx.Create;
var
  V: Pointer;
begin
  inherited Create;
  V := WebView(Super).init;
  if V <> GetObjectID then
    UpdateObjectID(V);
end;

function TTMSFMXMacWebGMapsWebBrowserEx.GetObjectiveCClass: PTypeInfo;
begin
  Result := TypeInfo(WebGMapsWebViewEx);
end;

function TTMSFMXMacWebGMapsWebBrowserEx.hitTest(aPoint: NSPoint): NSView;
begin
  Result := WebView(Super).hitTest(aPoint);
  if Assigned(FWebBrowser) and Assigned(FWebBrowser.FWebControl) then
  begin
    if not FWebBrowser.FWebControl.Enabled then
      Result := nil;
  end;
end;

{$ENDIF}
{$ENDIF}

end.
