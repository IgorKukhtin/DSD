unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  IPPeerClient, Vcl.StdCtrls, idHTTP, IdSSLOpenSSL;

const
  cURL = 'http://www.medicard.com.ua/api/api.php';

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

function SendXML(SendData : TStream; var Response : TStream; ErrMsg : string) : boolean;
var
  i, j : integer;
  Res : string;

  LHandler : TIdSSLIOHandlerSocketOpenSSL;
  MyHTTP: TidHTTP;
begin
  Result := true;

  LHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  MyHTTP := TidHTTP.Create(nil);
  try
    SendData.Position := 0;

    MyHTTP.IOHandler:= LHandler;
    MyHTTP.Request.CustomHeaders.AddValue('Content-Type', 'application/xml');

    try
      MyHTTP.Post(cURL, SendData, Response);

      if MyHTTP.ResponseCode = 200 then
      begin
        Response.CopyFrom(MyHTTP.Response.ContentStream, MyHTTP.Response.ContentStream.Size);
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
    FreeAndNil(LHandler);
    FreeAndNil(MyHTTP);
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

    if SendXML(sData, TStream(sResp), err) then
      sResp.SaveToFile(ExtractFilePath(Application.ExeName) + 'resp.txt');
  finally
    FreeAndNil(sData);
    FreeAndNil(sResp);
  end;
end;

end.
