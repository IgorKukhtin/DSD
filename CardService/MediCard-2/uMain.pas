unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  idHTTP, IdSSLOpenSSL, Soap.EncdDecd, HTTPApp, IdURI, httpsend,
  MediCard.Intf;

const
  cURL = 'http://medicard.in.ua/api/api.php';
  CardCount = 10;
  CardList: array[1..CardCount] of String[16] = ('MD00030026441', 'MD00030026593', 'MD00071023724',
    'MD00071053713', 'MD00072032404', 'MD00072032847', 'MD00072059497', 'MD00072059505',
    'MD00072059744', 'MD00072060385');

type
  TfrmMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
      //S := UTF8ToAnsi(HTTPEncode(ReqURLData.DataString));
      S := HTTPEncode(ReqURLData.DataString);
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

procedure TfrmMain.Button2Click(Sender: TObject);
var
  sData, sResp: TStringStream;
  Response: string;
  MCData: IMCData;
  GUID: TGUID;
  CasualId, XML: string;
begin
  sData := TStringStream.Create;
  sResp := TStringStream.Create;
  try
    //sData.LoadFromFile(ExtractFilePath(Application.ExeName) + '1.txt');

    MCDesigner.URL := cURL;
    MCDesigner.CreateObject(IMCRequestDiscount).GetInterface(IMCData, MCData);

    CreateGUID(GUID);
    CasualId := StringReplace(LowerCase(GUIDToString(GUID)), '-', '', [rfReplaceAll, rfIgnoreCase]);
    CasualId := StringReplace(CasualId, '{', '', [rfReplaceAll, rfIgnoreCase]);
    CasualId := StringReplace(CasualId, '}', '', [rfReplaceAll, rfIgnoreCase]);

  	MCData.Params.ParamByName('id_casual').AsString := CasualId;
    MCData.Params.ParamByName('inside_code').AsInteger := 679;
    MCData.Params.ParamByName('card_code').AsString := 'MD00030026441';
  	MCData.Params.ParamByName('product_code').AsString := '134965';
	  MCData.Params.ParamByName('qty').AsFloat := 3;

    MCData.SaveToXML(XML);

    MCData := nil;

    sData.WriteString(XML);

    if MCDesigner.HTTPPost(sData.DataString, Response) = 200 then
    begin
      MCDesigner.CreateObject(IMCResponseDiscount).GetInterface(IMCData, MCData);
      MCData.LoadFromXML(Response);

      if MCData.Params.ParamByName('id_casual').AsString <> CasualId then
        raise EMCException.Create('Ответ не соответствует запросу');

      sResp.WriteString(Response);
      sResp.SaveToFile(ExtractFilePath(Application.ExeName) + 'resp.txt');
    end;
  finally
    FreeAndNil(sData);
    FreeAndNil(sResp);
  end;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
  sData, sResp: TStringStream;
  I: Integer;
  Session: IMCSession;
  CasualId, XML: string;
begin
  sData := TStringStream.Create;
  sResp := TStringStream.Create;
  try
    MCDesigner.URL := cURL;

    for I := 1 to CardCount do
    begin
      MCDesigner.CreateObject(IMCSessionDiscount).GetInterface(IMCSession, Session);

      CasualId := MCDesigner.CasualCache.GenerateCasual;

      with Session.Request.Params do
      begin
        ParamByName('id_casual').AsString := CasualId;
        ParamByName('inside_code').AsInteger := 679;
        ParamByName('card_code').AsString := CardList[I];
        ParamByName('product_code').AsString := '134965';
        ParamByName('qty').AsFloat := 2;
      end;

      Session.Request.SaveToXML(XML);
      sData.Clear;
      sData.WriteString(XML);
      sData.SaveToFile(ExtractFilePath(Application.ExeName) + 'request_' + CardList[I] + '.xml');

      if Session.Post = 200 then
      begin
        Session.Response.SaveToXML(XML);
        sResp.Clear;
        sResp.WriteString(XML);
        sResp.SaveToFile(ExtractFilePath(Application.ExeName) + 'response_' + CardList[I] + '.xml');

        if Pos('202', Session.Response.Params.ParamByName('error').AsString) = 1 then
        begin
          MCDesigner.CreateObject(IMCSessionSale).GetInterface(IMCSession, Session);

          with Session.Request.Params do
          begin
            ParamByName('id_casual').AsString := CasualId;
            ParamByName('inside_code').AsInteger := 679;;
            ParamByName('supplier').AsInteger := 45643;
            ParamByName('id_alter').AsString := '5678';
            ParamByName('sale_status').AsInteger := MC_SALE_COMPLETE;
            ParamByName('card_code').AsString := CardList[I];
            ParamByName('product_code').AsString := '134965';
            ParamByName('price').AsFloat := 34.67;
            ParamByName('qty').AsFloat := 3;
            ParamByName('rezerv').AsFloat := 51;
            ParamByName('discont_percent').AsFloat := 15;
            ParamByName('discont_value').AsFloat := 0;
            ParamByName('sale_date').AsString := '2017-05-11 17:26:45';
          end;

          Session.Request.SaveToXML(XML);
          sData.Clear;
          sData.WriteString(XML);
          sData.SaveToFile(ExtractFilePath(Application.ExeName) + 'request_sale_' + CardList[I] + '.xml');

          if Session.Post = 200 then
          begin
            Session.Response.SaveToXML(XML);
            sResp.Clear;
            sResp.WriteString(XML);
            sResp.SaveToFile(ExtractFilePath(Application.ExeName) + 'response_sale_' + CardList[I] + '.xml');
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(sData);
    FreeAndNil(sResp);
  end;
end;

end.
