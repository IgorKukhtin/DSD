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

unit FMX.TMSWebGMapsWebBrowser.iOS;

interface

{$I TMSDEFS.INC}

//{$DEFINE USESAFARISERVICES}

procedure RegisterWebBrowserService;
procedure UnRegisterWebBrowserService;

implementation

uses
  Classes, Math, SysUtils, FMX.Types, Types, FMX.Forms, FMX.Platform, FMX.TMSWebGMapsWebBrowser
  {$IFDEF iOS}
  ,FMX.Platform.iOS, iOSApi.UIKit, iOSApi.CoreGraphics, iOSApi.Foundation, iOSApi.CocoaTypes, MacApi.ObjectiveC
  {$ENDIF}
  {$IF defined(IOS) and NOT defined(CPUARM)}
  ,Posix.Dlfcn
  {$ENDIF}
  ;

{$IF defined(IOS) and NOT defined(CPUARM)}
var
  msgSafariServices: THandle;
{$ENDIF}

{$IFDEF USESAFARISERVICES}
const
  libSafariServices = '/System/Library/Frameworks/SafariServices.framework/SafariServices';
{$ENDIF}

type
  TTMSFMXiOSWebGMapsWebBrowser = class;

  TTMSFMXiOSWebGMapsWebBrowserService = class(TTMSFMXWebGMapsWebBrowserFactoryService)
  protected
    function DoCreateWebBrowser(const AValue: TTMSFMXWebGMapsCustomWebBrowser): ITMSFMXWebGMapsCustomWebBrowser; override;
    procedure DeleteCookies; override;
  end;

  {$IFDEF IOS}
  {$IFDEF USESAFARISERVICES}
  SFSafariViewControllerClass = interface(UIViewControllerClass)
    ['{FB0D364B-0410-446D-912E-B9913CC719F9}']
  end;
  SFSafariViewController = interface(UIViewController)
    ['{1A78BFD5-AA2D-41BE-81A8-9697E0AA7CD2}']
    function initWithURL(URL: NSURL): Pointer; cdecl; overload;
    function initWithURL(URL: NSURL; entersReaderIfAvailable: Boolean): Pointer; cdecl; overload;
    procedure setDelegate(delegate: Pointer); cdecl;
  end;
  TSFSafariViewController = class(TOCGenericImport<SFSafariViewControllerClass, SFSafariViewController>)  end;

  SFSafariViewControllerDelegate = interface(IObjectiveC)
    ['{1D66D2A4-A3A0-48D6-8926-DC692A605E76}']
    procedure safariViewControllerDidFinish(controller: SFSafariViewController); cdecl;
  end;

  TTMSFMXiOSWebGMapsWebBrowserDelegateSF = class(TOCLocal, SFSafariViewControllerDelegate)
  private
    FWebBrowser: TTMSFMXiOSWebGMapsWebBrowser;
  public
    procedure safariViewControllerDidFinish(controller: SFSafariViewController); cdecl;
  end;
  {$ENDIF}

  TTMSFMXiOSWebGMapsWebBrowserDelegate = class(TOCLocal, UIWebViewDelegate)
  private
    FWebBrowser: TTMSFMXiOSWebGMapsWebBrowser;
  public
    procedure webView(webView: UIWebView; didFailLoadWithError: NSError); overload; cdecl;
    function webView(webView: UIWebView; shouldStartLoadWithRequest: NSURLRequest; navigationType: UIWebViewNavigationType): Boolean; overload; cdecl;
    procedure webViewDidFinishLoad(webView: UIWebView); cdecl;
    procedure webViewDidStartLoad(webView: UIWebView); cdecl;
  end;
  {$ENDIF}

  TTMSFMXWebGMapsCustomWebBrowserProtected = class(TTMSFMXWebGMapsCustomWebBrowser);

  TTMSFMXiOSWebGMapsWebBrowser = class(TInterfacedObject, ITMSFMXWebGMapsCustomWebBrowser)
  private
    {$IFDEF IOS}
    FWebBrowser: UIWebView;
    FWebBrowserDelegate: TTMSFMXiOSWebGMapsWebBrowserDelegate;
    {$IFDEF USESAFARISERVICES}
    FSafariVC: SFSafariViewController;
    FWebBrowserDelegateSF: TTMSFMXiOSWebGMapsWebBrowserDelegateSF;
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
    WebBrowserService := TTMSFMXiOSWebGMapsWebBrowserService.Create;
    TPlatformServices.Current.AddPlatformService(ITMSFMXWebGMapsWebBrowserService, WebBrowserService);
  end;
end;

procedure UnregisterWebBrowserService;
begin
  TPlatformServices.Current.RemovePlatformService(ITMSFMXWebGMapsWebBrowserService);
end;

function TTMSFMXiOSWebGMapsWebBrowser.GetBrowserInstance: IInterface;
begin

end;

function TTMSFMXiOSWebGMapsWebBrowser.GetExternalBrowser: Boolean;
begin
  Result := FExternalBrowser;
end;

function TTMSFMXiOSWebGMapsWebBrowser.GetURL: string;
begin
  Result := FURL;
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.GoBack;
begin
  {$IFDEF IOS}
  if Assigned(FWebBrowser) then
    FWebBrowser.goBack;
  {$ENDIF}
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.GoForward;
begin
  {$IFDEF IOS}
  if Assigned(FWebBrowser) then
    FWebBrowser.goForward;
  {$ENDIF}
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.Initialize;
{$IFDEF IOS}
var
  vw: UIView;
  frm: TCommonCustomForm;
{$ENDIF}
begin
  {$IFDEF IOS}
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
end;

function TTMSFMXiOSWebGMapsWebBrowser.IsFMXBrowser: Boolean;
begin
  Result := False;
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.LoadFile(AFile: String);
{$IFDEF IOS}
var
  url: NSUrl;
  requestobj: NSURLRequest;
{$ENDIF}
begin
  {$IFDEF IOS}
  if Assigned(FWebBrowser) then
  begin
    url := TNSURL.Wrap(TNSURL.OCClass.fileURLWithPath(NSSTREx(AFile)));
    requestobj := TNSURLRequest.Wrap(TNSURLRequest.OCClass.requestWithURL(url));
    FWebBrowser.loadRequest(requestobj);
  end;
  {$ENDIF}
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.LoadHTML(AHTML: String);
begin
  {$IFDEF IOS}
  if Assigned(FWebBrowser) then
    FWebBrowser.loadHTMLString(NSSTREx(AHTML), nil);
  {$ENDIF}
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.Navigate(const AURL: string);
{$IFDEF IOS}
var
  urlobj: NSURL;
  requestobj: NSURLRequest;
  function GetSharedApplication: UIApplication;
  begin
    Result := TUIApplication.Wrap(TUIApplication.OCClass.sharedApplication);
  end;
{$ENDIF}
begin
  {$IFDEF IOS}
  if FExternalBrowser then
  begin
    {$IFDEF USESAFARISERVICES}
    FSafariVC := TSFSafariViewController.Wrap(TSFSafariViewController.Wrap(TSFSafariViewController.OCClass.alloc).initWithURL(TNSURL.Wrap(TNSURL.OCClass.URLWithString(NSStrEx(AURL)))));
    FSafariVC.setDelegate(FWebBrowserDelegateSF.GetObjectID);
    GetSharedApplication.keyWindow.rootViewController.presentViewController(FSafariVC, False, nil);
    {$ENDIF}
  end
  else
  begin
    if Assigned(FWebBrowser) then
    begin
      urlobj := TNSURL.Wrap(TNSURL.OCClass.URLWithString(NSSTREx(AURL)));
      requestobj := TNSURLRequest.Wrap(TNSURLRequest.OCClass.requestWithURL(urlobj));
      FWebBrowser.loadRequest(requestobj);
    end;
  end;
  {$ENDIF}
end;

function TTMSFMXiOSWebGMapsWebBrowser.NativeBrowser: Pointer;
begin
  Result := nil;
  {$IFDEF IOS}
  if Assigned(FWebBrowser) then
    Result := (FWebBrowser as ILocalObject).GetObjectID;
  {$ENDIF}
end;

function TTMSFMXiOSWebGMapsWebBrowser.NativeDialog: Pointer;
begin
  Result := nil;
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.Navigate;
begin
  Navigate(FURL);
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.Reload;
begin
  {$IFDEF IOS}
  if Assigned(FWebBrowser) then
    FWebBrowser.reload;
  {$ENDIF}
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.SetExternalBrowser(const AValue: Boolean);
begin
  FExternalBrowser := AValue;
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.SetURL(const AValue: string);
begin
  FURL := AValue;
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.StopLoading;
begin
  {$IFDEF IOS}
  if Assigned(FWebBrowser) then
    FWebBrowser.stopLoading;
  {$ENDIF}
end;

{$IFDEF IOS}
function CGRectFromRect(const R: TRectF): CGRect;
begin
  Result.origin.x := R.Left;
  Result.origin.Y := R.Top;
  Result.size.Width := R.Right - R.Left;
  Result.size.Height := R.Bottom - R.Top;
end;
{$ENDIF}

procedure TTMSFMXiOSWebGMapsWebBrowser.UpdateBounds;
{$IFDEF IOS}
var
  Bounds: TRectF;
  Form: TCommonCustomForm;
  {$IFNDEF DELPHIXE6_LVL}
  a: UIApplication;
  h: Single;
  off: TPointF;
  {$ENDIF}
{$ENDIF}
begin
  Initialize;
  {$IFDEF IOS}
  if Assigned(FWebBrowser) then
  begin
    if (FWebControl <> nil)
      and not (csDesigning in FWebControl.ComponentState)
      and (FWebControl.Root <> nil)
      and (FWebControl.Root.GetObject is TCommonCustomForm) then
    begin
      Form := TCommonCustomForm(FWebControl.Root.GetObject);
      Bounds := TRectF.Create(0,0,FWebControl.Width,FWebControl.Height);
      Bounds.Fit(FWebControl.AbsoluteRect);
      {$IFNDEF DELPHIXE6_LVL}
      if TOSVersion.Check(7, 0) then
      begin
        a := TUIApplication.Wrap(TUIApplication.OCClass.sharedApplication);
        h := Min(a.statusBarFrame.size.width, a.statusBarFrame.size.height);
        off := PointF(0, h);
      end
      else
        off := PointF(0, 0);

      Bounds.Offset(off);
      {$ENDIF}

      FWebBrowser.setFrame(CGRectFromRect(RectF(Bounds.Left, Bounds.Top, Bounds.Right, Bounds.Bottom)));
    end;
  end;
  {$ENDIF}
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.UpdateEnabled;
begin
  {$IFDEF IOS}
  if Assigned(FWebBrowser) and Assigned(FWebControl) then
    FWebBrowser.setUserInteractionEnabled(FWebControl.Enabled);
  {$ENDIF}
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.UpdateVisible;
begin
  {$IFDEF IOS}
  if Assigned(FWebBrowser) and Assigned(FWebControl) then
    FWebBrowser.setHidden(not FWebControl.Visible);
  {$ENDIF}
end;

function TTMSFMXiOSWebGMapsWebBrowser.BodyInnerHTML: string;
begin
  Result := ExecuteJavascript('document.body.innerHTML');
end;

function TTMSFMXiOSWebGMapsWebBrowser.CanGoBack: Boolean;
begin
  Result := False;
  {$IFDEF IOS}
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.canGoBack;
  {$ENDIF}
end;

function TTMSFMXiOSWebGMapsWebBrowser.CanGoForward: Boolean;
begin
  Result := False;
  {$IFDEF IOS}
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.canGoForward;
  {$ENDIF}
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.Close;
begin
  TTMSFMXWebGMapsCustomWebBrowserProtected(FWebControl).DoCloseForm;
end;

constructor TTMSFMXiOSWebGMapsWebBrowser.Create(const AWebControl: TTMSFMXWebGMapsCustomWebBrowser);
begin
  FExternalBrowser := False;
  FWebControl := AWebControl;
  {$IFDEF IOS}
  FWebBrowserDelegate := TTMSFMXiOSWebGMapsWebBrowserDelegate.Create;
  FWebBrowserDelegate.FWebBrowser := Self;
  {$IFDEF USESAFARISERVICES}
  FWebBrowserDelegateSF := TTMSFMXiOSWebGMapsWebBrowserDelegateSF.Create;
  FWebBrowserDelegateSF.FWebBrowser := Self;
  {$ENDIF}
  FWebBrowser := TUIWebView.Wrap(TUIWebView.Wrap(TUIWebView.OCClass.alloc).init);
  FWebBrowser.setScalesPageToFit(True);
  FWebBrowser.setDelegate(ILocalObject(FWebBrowserDelegate).GetObjectID);
  {$ENDIF}
end;

procedure TTMSFMXiOSWebGMapsWebBrowser.DeInitialize;
begin
  {$IFDEF IOS}
  if Assigned(FWebBrowser) then
    FWebBrowser.setDelegate(nil);

  if Assigned(FWebBrowserDelegate) then
  begin
    FWebBrowserDelegate.Free;
    FWebBrowserDelegate := nil;
  end;

  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.removeFromSuperview;
    FWebBrowser.release;
    FWebBrowser := nil;
  end;

  {$IFDEF USESAFARISERVICES}
  if Assigned(FWebBrowserDelegateSF) then
  begin
    FWebBrowserDelegateSF.Free;
    FWebBrowserDelegateSF := nil;
  end;
  {$ENDIF}
  {$ENDIF}
end;

function TTMSFMXiOSWebGMapsWebBrowser.ExecuteJavascript(AScript: String): String;
begin
  Result := '';
  {$IFDEF IOS}
  if Assigned(FWebBrowser) then
    Result := UTF8ToString(FWebBrowser.stringByEvaluatingJavaScriptFromString(NSSTREx(AScript)).UTF8String);
  {$ENDIF}
end;

{ TTMSFMXiOSWebGMapsWebBrowserService }

procedure TTMSFMXiOSWebGMapsWebBrowserService.DeleteCookies;
{$IFDEF IOS}
var
  storage: NSHTTPCookieStorage;
  I: Integer;
  cnt: Integer;
{$ENDIF}
begin
  {$IFDEF IOS}
  storage := TNSHTTPCookieStorage.Wrap(TNSHTTPCookieStorage.OCClass.sharedHTTPCookieStorage);
  cnt := storage.cookies.count;
  for I := cnt - 1 downto 0 do
    storage.deleteCookie(TNSHTTPCookie.Wrap(storage.cookies.objectAtIndex(I)));

  TNSUserDefaults.Wrap(TNSUserDefaults.OCClass.standardUserDefaults).synchronize;
  {$ENDIF}
end;

function TTMSFMXiOSWebGMapsWebBrowserService.DoCreateWebBrowser(const AValue: TTMSFMXWebGMapsCustomWebBrowser): ITMSFMXWebGMapsCustomWebBrowser;
begin
  Result := TTMSFMXiOSWebGMapsWebBrowser.Create(AValue);
end;

{$IFDEF IOS}
{$IFDEF USESAFARISERVICES}

{ TTMSFMXiOSWebGMapsWebBrowserDelegateSF }

procedure TTMSFMXiOSWebGMapsWebBrowserDelegateSF.safariViewControllerDidFinish(controller: SFSafariViewController);
begin
  controller.dismissViewControllerAnimated(False, nil);
end;
{$ENDIF}

{ TTMSFMXiOSWebGMapsWebBrowserDelegate }

function TTMSFMXiOSWebGMapsWebBrowserDelegate.webView(webView: UIWebView;
  shouldStartLoadWithRequest: NSURLRequest;
  navigationType: UIWebViewNavigationType): Boolean;
var
  Params: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams;
begin
  Params.URL := UTF8ToString(shouldStartLoadWithRequest.URL.absoluteString.UTF8String);
  Params.Cancel := False;
  if Assigned(FWebBrowser.FWebControl) then
  begin
    FWebBrowser.FURL := Params.URL;
    TTMSFMXWebGMapsCustomWebBrowserProtected(FWebBrowser.FWebControl).BeforeNavigate(Params);
  end;

  Result := not Params.Cancel;
end;

procedure TTMSFMXiOSWebGMapsWebBrowserDelegate.webView(webView: UIWebView;
  didFailLoadWithError: NSError);
begin

end;

procedure TTMSFMXiOSWebGMapsWebBrowserDelegate.webViewDidFinishLoad(webView: UIWebView);
var
  Params: TTMSFMXWebGMapsCustomWebBrowserNavigateCompleteParams;
begin
  Params.URL := UTF8ToString(webView.request.URL.absoluteString.UTF8String);
  if Assigned(FWebBrowser.FWebControl) then
  begin
    FWebBrowser.FURL := Params.URL;
    TTMSFMXWebGMapsCustomWebBrowserProtected(FWebBrowser.FWebControl).NavigateComplete(Params);
  end;
end;

procedure TTMSFMXiOSWebGMapsWebBrowserDelegate.webViewDidStartLoad(webView: UIWebView);
begin

end;

{$ENDIF}

{$IFDEF USESAFARISERVICES}
{$IFDEF IOS}
{$IFDEF CPUARM}
procedure ldr_1; cdecl; external libSafariServices;
{$ELSE}
initialization
begin
  msgSafariServices := dlopen(MarshaledAString(libSafariServices), RTLD_LAZY);
end;

finalization
begin
  dlclose(msgSafariServices);
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}


end.
