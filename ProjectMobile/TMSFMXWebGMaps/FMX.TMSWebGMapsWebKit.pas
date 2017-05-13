{***************************************************************************)
{ TMS FMX WebGMaps component                                                }
{ for Delphi                                                                }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2013 - 2016                                        }
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

unit FMX.TMSWebGMapsWebKit;

{$IFDEF IOS}
{$DEFINE GENERALOSX}
{$ENDIF}
{$IFDEF MACOS}
{$DEFINE GENERALOSX}
{$ENDIF}

{$HPPEMIT ''}
{$HPPEMIT '#pragma link "wininet.lib"'}
{$HPPEMIT ''}

interface

{$I TMSDEFS.INC}

{$IFDEF MSWINDOWS}
uses
  AnsiStrings, Classes;
{$ENDIF}

{$IFDEF ANDROID}
uses
  AndroidApi.JNI.JavaTypes, AndroidApi.JNIBridge
  {$IFDEF DELPHIXE6_LVL}
  ,AndroidApi.Helpers
  {$ENDIF}
  ;
{$ENDIF}

{$IFDEF GENERALOSX}
uses
  MacApi.ObjectiveC,
{$IFDEF IOS}
  iOSApi.CocoaTypes, iOSApi.Foundation
{$ELSE}
  MacApi.CocoaTypes, MacApi.Foundation
{$ENDIF}

{$IFDEF DELPHIXE6_LVL}
,MacApi.Helpers
{$ENDIF}
;
{$ENDIF}

{$IFDEF ANDROID}
type
  JURLConnection = interface;

  JURLConnectionClass = interface(JObjectClass)
  ['{AEDB8433-1DD1-4B20-BECC-123544789307}']
  end;

  [JavaSignature('java/net/URLConnection')]
  JURLConnection = interface(JObject)
  ['{65F78131-FB82-416E-A50A-AAEFD1B2DD77}']
    procedure addRequestProperty(field: JString; newValue: JString); cdecl;
  end;
  TJURLConnection = class(TJavaGenericImport<JURLConnectionClass, JURLConnection>) end;

  JHttpURLConnectionClass = interface(JURLConnectionClass)
  ['{17073AD7-9BB5-4049-B118-001EC934C341}']
  end;

  [JavaSignature('java/net/HttpURLConnection')]
  JHttpURLConnection = interface(JURLConnection)
  ['{72EC2B81-5962-48B0-8A78-4EF19F2256AC}']
    procedure setRequestMethod(method: JString); cdecl;
    procedure setDoInput(newValue: Boolean); cdecl;
    procedure setDoOutput(newValue: Boolean); cdecl;
    function getOutputStream: JOutputStream; cdecl;
    function getInputStream: JInputStream; cdecl;
    function getResponseCode: Integer; cdecl;
  end;
  TJHttpURLConnection = class(TJavaGenericImport<JHttpURLConnectionClass, JHttpURLConnection>) end;

  JURL = interface;

  JURLClass = interface(JObjectClass)
  ['{36566040-887E-4669-A2C2-5E398BAB11A5}']
    function init(spec: JString): JURL; cdecl;
  end;

  [JavaSignature('java/net/URL')]
  JURL = interface(JObject)
  ['{90838206-3D5E-4E46-84DA-9B5E2D913242}']
  function openConnection: JURLConnection; cdecl;
  end;
  TJURL = class(TJavaGenericImport<JURLClass, JURL>) end;

  JStringWriter = interface;

  JStringWriterClass = interface(JObjectClass)
  ['{41443AA3-D415-4869-BA63-E523EDCA533F}']
    function init: JStringWriter; cdecl;
  end;

  [JavaSignature('java/io/StringWriter')]
  JStringWriter = interface(JObject)
  ['{1D7F9DB3-1146-4AE7-8698-65B2A1E56179}']
    procedure write(chars: TJavaArray<Char>; offset: Integer; count: Integer); cdecl;
  end;
  TJStringWriter = class(TJavaGenericImport<JStringWriterClass, JStringWriter>) end;


  JInputStreamReader = interface;

  JInputStreamReaderClass = interface(JObjectClass)
  ['{41443AA3-D415-4869-BA63-E523EDCA533F}']
    function init(input: JInputStream; charSetName: JString): JInputStreamReader; cdecl; overload;
    function init(input: JInputStream): JInputStreamReader; cdecl; overload;
  end;

  [JavaSignature('java/io/InputStreamReader')]
  JInputStreamReader = interface(JObject)
  ['{1D7F9DB3-1146-4AE7-8698-65B2A1E56179}']
  end;
  TJInputStreamReader = class(TJavaGenericImport<JInputStreamReaderClass, JInputStreamReader>) end;


  JReader = interface;

  JReaderClass = interface(JObjectClass)
  ['{B600CC99-D89B-444A-8BCF-72AB33342B41}']
  end;

  [JavaSignature('java/io/Reader')]
  JReader = interface(JObject)
  ['{C449988A-B22E-4E3D-916E-BC7B65A25605}']
  end;
  TJReader = class(TJavaGenericImport<JReaderClass, JReader>) end;


  JBufferedReader = interface;

  JBufferedReaderClass = interface(JObjectClass)
  ['{6859FEC1-4D00-46D1-9252-94D4520D8374}']
    function init(input: JReader; size: Integer): JBufferedReader; cdecl; overload;
    function init(input: JReader): JBufferedReader; cdecl; overload;
  end;

  [JavaSignature('java/io/BufferedReader')]
  JBufferedReader = interface(JObject)
  ['{F2C9403F-2318-426B-A0B6-610B80D2F6D5}']
    function read(buf: TJavaArray<Char>): Integer; cdecl;
    function readLine: JString; cdecl;
  end;
  TJBufferedReader = class(TJavaGenericImport<JBufferedReaderClass, JBufferedReader>) end;


{$ENDIF}

{$IFDEF GENERALOSX}
type
  NSURLConnectionClass = interface(NSObjectClass)
  ['{BD316992-8D3F-4205-9704-4BBBDA2B760A}']
  {class} function canHandleRequest(request: NSURLRequest): Boolean; cdecl;
  {class} function connectionWithRequest(request: NSURLRequest; delegate: Pointer): Pointer; cdecl;
  {class} function sendSynchronousRequest(request: NSURLRequest; returningResponse: PPointer; error: PPointer): NSData; cdecl;
  end;
  NSURLConnection = interface(NSObject)
    ['{545DDD3E-AC2D-4403-9115-3DFE321D78FB}']
    procedure cancel; cdecl;
    function initWithRequest(request: NSURLRequest; delegate: Pointer): Pointer; cdecl; overload;
    function initWithRequest(request: NSURLRequest; delegate: Pointer; startImmediately: Boolean): Pointer; cdecl; overload;
    procedure scheduleInRunLoop(aRunLoop: NSRunLoop; forMode: NSString); cdecl;
    procedure setDelegateQueue(queue: NSOperationQueue); cdecl;
    procedure start; cdecl;
    procedure unscheduleFromRunLoop(aRunLoop: NSRunLoop; forMode: NSString); cdecl;
  end;
  TNSURLConnection = class(TOCGenericImport<NSURLConnectionClass, NSURLConnection>)  end;
{$ENDIF}

{$IFNDEF MSWINDOWS}
type
  AChar = #0..'ÿ';
  PAChar = ^AChar;
  AnsiChar = AChar;
  AnsiString = string;
  UTF8String = string;
  rawbytestring = string;
{$ENDIF}

function HTTPSGet(AUrl: String): AnsiString;
{$IFDEF ANDROID}
function GetDataFromStream(AInputStream: JInputStream): String;
{$ENDIF}

{$IFDEF MACOS}
function NSStrEx(AString: String): NSString;
{$ENDIF}

implementation

{$IFDEF MSWINDOWS}
uses
  Windows, WinInet, SysUtils;
{$ENDIF}

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
function GetDataFromStream(AInputStream: JInputStream): String;
var
  writer: JStringWriter;
  reader: JBufferedReader;
  inputreader: JInputStreamReader;
  n: Integer;
  buf: TJavaArray<Char>;
  res: JString;
begin
  if Assigned(AInputStream) then
  begin

    writer := TJStringWriter.JavaClass.init;
    try
      inputreader := TJInputStreamReader.JavaClass.init(AInputStream, StringToJString('UTF-8'));
      reader := TJBufferedReader.JavaClass.init(JReader(inputreader), 1024);

      buf := TJavaArray<Char>.Create(1024);

      n := reader.read(buf);
      while (n <> -1) do
      begin
        writer.write(buf, 0, n);
        n := reader.read(buf);
      end;

    finally
      AInputStream.close;
      inputreader := nil;
      reader := nil;
    end;

    res := writer.toString;
    if Assigned(res) then
      Result := JStringToString(res)
    else
      Result := '';

    writer := nil;
  end;
end;
{$ENDIF}

function HTTPSGet(AUrl: String): AnsiString;
{$IFDEF MACOS}
var
  req: NSMutableURLRequest;
  nurl: NSURL;
  res: Pointer;
  resdata: NSData;
  datastr: NSString;
begin
  Result := '';
  try
    nurl := TNSURL.Wrap(TNSURL.OCClass.URLWithString(NSStrEx(AUrl)));
    req := TNSMutableURLRequest.Wrap(TNSMutableURLRequest.OCClass.requestWithURL(nurl, NSURLRequestUseProtocolCachePolicy, 60.0));
    req.setHTTPMethod(NSStrEx('GET'));

    res := nil;
    resdata := TNSURLConnection.OCClass.sendSynchronousRequest(req, @res, nil);
    if Assigned(resdata) then
    begin
      dataStr := TNSString.Wrap((TNSString.Wrap(TNSString.OCClass.alloc)).initWithData(resdata, NSUTF8StringEncoding));
      Result := AnsiString(System.UTF8ToString(dataStr.UTF8String));
      dataStr.release;
    end;
  finally
  end;
{$ELSE}
  {$IFDEF ANDROID}
  var
    urlCon: JHttpURLConnection;
    u: JURL;
  begin
    u := TJURL.JavaClass.init(StringToJString(AUrl));
    urlCon := TJHttpURLConnection.Wrap((u.openConnection as ILocalObject).GetObjectID);
    urlCon.setDoInput(True);
    urlCon.setDoOutput(False);
    urlCon.setRequestMethod(StringToJString('GET'));

    if (urlCon.getResponseCode in [200, 201]) then
      Result := GetDataFromStream(urlCon.getInputStream);
  {$ELSE}
var
  NetHandle: HINTERNET;
  UrlHandle: HINTERNET;
  Buffer: array[0..1023] of byte;
  BytesRead: dWord;
  position: int64;
  lpdwlen,lpdwidx,lpdword: DWord;
  ss: TStringStream;
  FAgent: string;
begin
  FAgent := 'Mozilla/5.001 (windows; U; NT4.0; en-US; rv:1.0) Gecko/25250101';
  Result := '';
  NetHandle := InternetOpen(PChar(FAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if Assigned(NetHandle) then
  begin
    UrlHandle := InternetOpenUrl(NetHandle, PChar(AUrl), nil, 0, INTERNET_FLAG_RELOAD, 0);

    if Assigned(UrlHandle) then
    begin
      lpdword := 0;
      lpdwlen := 4;
      lpdwidx := 0;
      HttpQueryInfo(URLHandle,HTTP_QUERY_CONTENT_LENGTH or HTTP_QUERY_FLAG_NUMBER,@lpdword,lpdwlen,lpdwidx);

      ss := TStringStream.Create('',tencoding.UTF8);
      try
        position := 0;
        repeat
          BytesRead := 0;
          InternetReadFile(UrlHandle, @Buffer, Sizeof(Buffer) -1, BytesRead);
          ss.WriteBuffer(buffer,BytesRead);
          position := position + bytesread;
        until (BytesRead = 0);

        Result := ansistring(ss.DataString);
      finally
        ss.Free;
      end;

      InternetCloseHandle(UrlHandle);
    end
    else
      raise Exception.CreateFmt('Cannot open URL %s', [AUrl]);

    InternetCloseHandle(NetHandle);
  end
  else
    raise Exception.Create('Unable to initialize Wininet');
  {$ENDIF}
{$ENDIF}
end;

end.
