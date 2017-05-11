{********************************************************************}
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2013                                        }
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

{$IFDEF MACOS}
  {$DEFINE GENERALOSX}
{$ENDIF}
{$IFDEF IOS}
  {$DEFINE GENERALOSX}
{$ENDIF}

unit FMX.TMSWebGMapsWebUtil;

interface

{$I TMSDEFS.INC}

uses
  Classes, SysUtils
  {$IFNDEF IOS}
  {$IFNDEF ANDROID}
  {$IFNDEF MACOS}
  , Windows, ShellApi, ComObj, ShlObj,
    FMX.Forms, IOUtils
  {$ELSE}
  , Macapi.Foundation, Macapi.AppKit
  {$IFDEF DELPHIXE6_LVL}
  ,MacApi.Helpers
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}

  {$IFDEF DELPHI_LLVM}
  , FMX.Forms, IOUtils
  {$IFDEF ANDROID}
  , Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.App, FMX.Helpers.Android
    {$IFDEF DELPHIXE6_LVL}
    ,AndroidApi.Helpers
    {$ENDIF}
  {$ENDIF}
  {$IFDEF IOS}
  , iOSApi.Foundation, iOSapi.UIKit, iOSapi.CocoaTypes, FMX.Platform.iOS
  {$IFDEF DELPHIXE6_LVL}
  ,MacApi.Helpers
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  ;

{$IFNDEF ANDROID}
{$IFNDEF IOS}
procedure XOpenFile(AOperation, AFileName, AParameters, ADirectory: String);
{$ENDIF}
{$ENDIF}

procedure XOpenURL(AUrl: String);

{$IFDEF DELPHI_LLVM}
procedure XOpenFile(AFileName: String; AForm: TCommonCustomForm = nil);
{$ENDIF}

{$IFNDEF ANDROID}
function XGetDocumentsDirectory: String;
{$ENDIF}
function XGetRootDirectory: String;
procedure XCopyFile(ASource, ADestination: String; AOverwrite: Boolean = False);

{$IFDEF MACOS}
function NSStrEx(AString: String): NSString;
{$ENDIF}

implementation

{$IFDEF MACOS}
function NSStrEx(AString: String): NSString;
begin
  {$IFDEF DELPHIXE6_LVL}
  Result := StrToNSStr(AString);
  {$ELSE}
  Result := NSStr(AString);
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF ANDROID}
function SharedActivityEx: JActivity;
begin
  {$IFDEF DELPHIXE9_LVL}
  Result := TAndroidHelper.Activity;
  {$ELSE}
  Result := SharedActivity;
  {$ENDIF}
end;

procedure XOpenFile(AFileName: String; AForm: TCommonCustomForm = nil);
var
  i: JIntent;
begin
  i := TJIntent.Create;
  i.setAction(TJIntent.JavaClass.ACTION_VIEW);
  i.setData(StrToJURI(AFileName));
  SharedActivityEx.startActivity(i);
end;
{$ENDIF}

{$IFDEF IOS}
procedure XOpenFile(AFileName: String; AForm: TCommonCustomForm = nil);
var
  docController: UIDocumentInteractionController;
  url: NSURL;
  r: NSRect;
  vw: UIView;
  frm: TCommonCustomForm;
begin
  frm := AForm;
  if not Assigned(frm) then
  begin
    frm := Application.MainForm;
    if not Assigned(frm) then
      Exit;
  end;

  url := TNSURL.Wrap(TNSURL.OCClass.fileURLWithPath(NSStrEx(AFileName)));
  docController := TUIDocumentInteractionController.Wrap(TUIDocumentInteractionController.OCClass.interactionControllerWithURL(url));
  docController.retain;
  vw := WindowHandleToPlatform(frm.Handle).View;
  docController.presentOpenInMenuFromRect(r, vw, TRUE);
end;
{$ENDIF}


procedure XOpenURL(AUrl: String);
{$IFNDEF IOS}
{$IFDEF MACOS}
var
  AWorkspace: NSWorkspace;
{$ENDIF}
{$ENDIF}
begin
  {$IFNDEF ANDROID}
  {$IFNDEF IOS}
  {$IFDEF MACOS}
  //Mac
  AWorkspace := TNSWorkspace.Wrap(TNSWorkspace.OCClass.sharedWorkspace);
  AWorkSpace.openURL(TNSURL.Wrap(TNSURL.OCClass.URLWithString(NSSTREx(AUrl))));
  {$ELSE}
  //Win32 / Win64
  ShellExecute(0,PChar('open'),PChar(AUrl),PChar(''),PChar(''),SW_NORMAL);
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}

  {$IFNDEF ANDROID}
  {$IFDEF IOS}
  TUIApplication.Wrap(TUIApplication.OCClass.sharedApplication).openURL(TNSURL.Wrap(TNSURL.OCClass.URLWithString(NSStrEx(AUrl))));
  {$ENDIF}
  {$ENDIF}

  {$IFDEF ANDROID}
  XOpenFile(AURL);
  {$ENDIF}
end;

{$IFNDEF ANDROID}
{$IFNDEF IOS}
procedure XOpenFile(AOperation, AFileName, AParameters, ADirectory: String);
{$IFNDEF IOS}
{$IFDEF MACOS}
var
  AWorkspace: NSWorkspace;
{$ENDIF}
{$ENDIF}
begin
  {$IFNDEF IOS}
  {$IFDEF MACOS}
  //Mac
  AWorkspace := TNSWorkspace.Wrap(TNSWorkspace.OCClass.sharedWorkspace);
  AWorkspace.openFile(NSSTREx(AFileName));
  {$ELSE}
  //Win32 / Win64
  ShellExecute(0,PChar(AOperation),PChar(AFileName),PChar(AParameters),PChar(ADirectory),SW_NORMAL);
  {$ENDIF}
  {$ENDIF}
end;
{$ENDIF}
{$ENDIF}


procedure XCopyFile(ASource, ADestination: String; AOverwrite: Boolean = False);
{$IFDEF GENERALOSX}
var
  fileManager: NSFileManager;
  error: NSError;
{$ENDIF}
begin
  {$IFDEF GENERALOSX}
    fileManager := TNSFileManager.Wrap(TNSFileManager.OCClass.defaultManager);
    {$IFDEF IOS}
    {$IFDEF DELPHIXE5_LVL}
    fileManager.copyItemAtPath(NSStrEx(ASource), NSStrEx(ADestination), @Error);
    {$ELSE}
    fileManager.copyItemAtPath(NSStrEx(ASource), NSStrEx(ADestination), Error);
    {$ENDIF}
    {$ELSE}
      {$IFDEF DELPHIXE3_LVL}
      fileManager.copyItemAtPath(NSStrEx(ASource), NSStrEx(ADestination), @Error);
      {$ELSE}
      fileManager.copyItemAtPath(NSStrEx(ASource), NSStrEx(ADestination), Error);
      {$ENDIF}
    {$ENDIF}
  {$ELSE}
  {$IFNDEF ANDROID}
    TFile.Copy(ASource, ADestination, AOverwrite);
  {$ENDIF}
  {$ENDIF}
end;


function XGetRootDirectory: String;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

{$IFNDEF ANDROID}
function XGetDocumentsDirectory: String;
var
  {$IFDEF GENERALOSX}
    {$IFDEF MACOS}
    fileManager: NSFileManager;
    URL: NSURL;
    Error: NSError;
    {$ENDIF}
  {$ELSE}
    szBuffer: array [0..MAX_PATH] of Char;
  {$ENDIF}
begin
  {$IFDEF GENERALOSX}
    {$IFDEF MACOS}
    fileManager := TNSFileManager.Wrap(TNSFileManager.OCClass.defaultManager);
    URL := fileManager.URLForDirectory(NSDocumentDirectory,
                                   NSUserDomainMask,
                                   nil,
                                   false,
    {$IFNDEF IOS}
    {$IFDEF DELPHIXE3_LVL}
                                   @Error);
    {$ELSE}
                                   Error);
    {$ENDIF}
    {$ELSE}
    {$IFDEF DELPHIXE5_LVL}
                                   @Error);
    {$ELSE}
                                   Error);
    {$ENDIF}
    {$ENDIF}
    if Assigned(Error) then
      raise Exception.Create(UTF8ToString(Error.localizedDescription.UTF8String));

    Result := UTF8ToString(URL.path.UTF8String);
    {$ENDIF}

  {$ELSE}
  {$IFNDEF ANDROID}
    OleCheck(SHGetFolderPath(0, $0005, 0, 0, szBuffer));
    Result := szBuffer;
  {$ENDIF}
  {$ENDIF}
end;
{$ENDIF}



end.

