unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  idHTTP, IdSSLOpenSSL, Soap.EncdDecd;

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
begin
  Result := true;

  ReqBase64 := TMemoryStream.Create;
  ResBase64 := TMemoryStream.Create;

  //LHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  MyHTTP := TidHTTP.Create(nil);
  try
    //MyHTTP.IOHandler:= LHandler;
    MyHTTP.Request.CustomHeaders.AddValue('Content-Type', 'application/xml');
    //MyHTTP.Request.CustomHeaders.AddValue('Content-Encoding', 'base64');

    try
      SendData.Position := 0;
      //EncodeStream(SendData, ReqBase64);
      //ReqBase64.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Req.Base64');
      //ReqBase64.Position := 0;
      //MyHTTP.Post(cURL, ReqBase64, ResBase64);
      MyHTTP.Post(cURL, SendData, Response);

      if MyHTTP.ResponseCode = 200 then
      begin
        //ResBase64.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Res.Base64');
        //Response.SaveToFile(ExtractFilePath(ParamStr(0)) + 'response.txt');
        //ResBase64.Position := 0;
        //DecodeStream(ResBase64, Response);
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
    //FreeAndNil(LHandler);
    FreeAndNil(MyHTTP);
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

    if SendXML(sData, sResp, err) then
      sResp.SaveToFile(ExtractFilePath(Application.ExeName) + 'resp.txt');
  finally
    FreeAndNil(sData);
    FreeAndNil(sResp);
  end;
end;

end.
