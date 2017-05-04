unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  idHTTP, IdSSLOpenSSL, Soap.EncdDecd, HTTPApp, IdURI, httpsend;

const
  cURL = 'http://medicard.in.ua/api/api.php';

type
  TfrmMain = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

function SendXML(SendData: TStream; Response: TStream; ErrMsg: string): Boolean;
var
  //LHandler : TIdSSLIOHandlerSocketOpenSSL;
  MyHTTP: TidHTTP;
  ReqBase64, ResBase64: TMemoryStream;
  ReqURLData, ResURLData: TStringStream;
  S: AnsiString;
begin
  Result := true;

  ReqBase64 := TMemoryStream.Create;
  ResBase64 := TMemoryStream.Create;
  ReqURLData := TStringStream.Create;
  ResURLData := TStringStream.Create;

  //LHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  MyHTTP := TidHTTP.Create(nil);
  try
    //MyHTTP.IOHandler:= LHandler;
    MyHTTP.Request.CustomHeaders.AddValue('Content-Type', 'application/x-www-form-urlencoded');
    //MyHTTP.Request.CustomHeaders.AddValue('Content-Encoding', 'base64');

    try
      SendData.Position := 0;
      EncodeStream(SendData, ReqBase64);
      ReqBase64.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Req.Base64');
      ReqBase64.Position := 0;
      ReqURLData.LoadFromStream(ReqBase64);
      S := UTF8ToAnsi(HTTPEncode(ReqURLData.DataString));
      ReqURLData.Clear;
      ReqURLData.WriteString('medicard=' + S);
      ReqURLData.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Req.URL');
      ReqURLData.Position := 0;
      MyHTTP.Post(cURL, ReqURLData, ResURLData);
      //MyHTTP.Post(cURL, ReqBase64, ResBase64);
      //MyHTTP.Post(cURL, SendData, Response);

      {if MyHTTP.ResponseCode = 200 then
      begin}
        //ResURLData.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Res.URL');
        //ResBase64.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Res.Base64');
        //Response.SaveToFile(ExtractFilePath(ParamStr(0)) + 'response.txt');
        //ResBase64.Position := 0;
        ResBase64.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Res.URL');
        DecodeStream(ResBase64, Response);
      //end;
    except
      on E: Exception do
      begin
        ErrMsg := E.Message;
        Result := false;
        exit;
      end;
    end;
  finally
    //FreeAndNil(LHandler);
    FreeAndNil(MyHTTP);
    ResURLData.Free;
    ReqURLData.Free;
    ReqBase64.Free;
    ResBase64.Free;
  end;
end;

function SendXML2(SendData: TStream; Response: TStream; ErrMsg: string): Boolean;
var
  MyHTTP: THTTPSend;
  ReqBase64, ResBase64: TMemoryStream;
  ReqURLData, ResURLData: TStringStream;
  S: AnsiString;
begin
  Result := true;

  ReqBase64 := TMemoryStream.Create;
  ResBase64 := TMemoryStream.Create;
  ReqURLData := TStringStream.Create;
  ResURLData := TStringStream.Create;

  MyHTTP := THTTPSend.Create;
  try
    MyHTTP.MimeType := 'application/x-www-form-urlencoded';

    try
      SendData.Position := 0;
      EncodeStream(SendData, ReqBase64);
      ReqBase64.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Req.Base64');
      ReqBase64.Position := 0;
      ReqURLData.LoadFromStream(ReqBase64);
      S := UTF8ToAnsi(HTTPEncode(ReqURLData.DataString));
      ReqURLData.Clear;
      ReqURLData.WriteString('medicard=' + S);
      ReqURLData.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Req.URL');
      MyHTTP.Document.Write(ReqURLData.Memory^, ReqURLData.Size);
      MyHTTP.HTTPMethod('POST', cURL);

      if MyHTTP.ResultCode = 200 then
      begin
        MyHTTP.Document.Position := 0;
        SetLength(S, MyHTTP.Document.Size);
        MyHTTP.Document.Read(Pointer(S)^, MyHTTP.Document.Size);
        ResURLData.WriteString(S);
        ResURLData.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Res.URL');
        ResURLData.Position := 0;
        DecodeStream(ResURLData, Response);
      end;
    except
      on E: Exception do
      begin
        ErrMsg := E.Message;
        Result := false;
        exit;
      end;
    end;
  finally
    FreeAndNil(MyHTTP);
    ResURLData.Free;
    ReqURLData.Free;
    ReqBase64.Free;
    ResBase64.Free;
  end;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
  sData, sResp : TMemoryStream;
  err : string;
begin
  sData := TMemoryStream.Create;
  sResp := TMemoryStream.Create;
  try
    sData.LoadFromFile(ExtractFilePath(Application.ExeName) + '1.txt');

    if SendXML2(sData, sResp, err) then
      sResp.SaveToFile(ExtractFilePath(Application.ExeName) + 'resp.txt');
  finally
    FreeAndNil(sData);
    FreeAndNil(sResp);
  end;
end;

end.
