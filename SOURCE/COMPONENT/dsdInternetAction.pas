unit dsdInternetAction;

{$I ..\dsdVer.inc}

interface

uses
  dsdAction, dsdDB, Classes, cxGrid, DB {$IFDEF DELPHI103RIO}, Actions {$ENDIF}
//, Vcl.Dialogs, Messages
  ;

type

  TArrayOfS = array of string;

  TdsdSMTPAction = class(TdsdCustomAction)
  private
    FBody: TdsdParam;
    FToAddress: TdsdParam;
    FPort: TdsdParam;
    FPassword: TdsdParam;
    FFromAddress: TdsdParam;
    FUserName: TdsdParam;
    FHost: TdsdParam;
    FSubject: TdsdParam;
  protected
    FAttachments: TArrayOfS;
    procedure FillAttachments; virtual;
    procedure DeleteAttachments; virtual;
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Host: TdsdParam read FHost write FHost;
    property Port: TdsdParam read FPort write FPort;
    property UserName: TdsdParam read FUserName write FUserName;
    property Password: TdsdParam read FPassword write FPassword;
    property Body: TdsdParam read FBody write FBody;
    property Subject: TdsdParam read FSubject write FSubject;
    property FromAddress: TdsdParam read FFromAddress write FFromAddress;
    property ToAddress: TdsdParam read FToAddress write FToAddress;
  end;

  TdsdSMTPGridAction = class(TdsdSMTPAction)
  private
    FFileName: string;
    FcxGrid: TcxGrid;
  protected
    procedure FillAttachments; override;
    function LocalExecute: boolean; override;
  published
    property cxGrid: TcxGrid read FcxGrid write FcxGrid;
  end;

  TdsdSMTPFileAction = class(TdsdSMTPAction)
  private
    FFileName: string;
  protected
    procedure FillAttachments; override;
    procedure DeleteAttachments; override;
  published
    property FileName: String read FFileName write FFileName;
  end;

  TdsdSMTPMultipleFileAction = class(TdsdSMTPAction)
  private
    FFieldFileNameParam: TdsdParam;
    FDataSet: TDataSet;
  protected
    procedure FillAttachments; override;
    procedure DeleteAttachments; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FieldFileName: TdsdParam read FFieldFileNameParam write FFieldFileNameParam;
    property DataSet: TDataSet read FDataSet write FDataSet;
  end;

  procedure Register;

implementation

uses SysUtils, IdMessage, IdText, IdAttachmentFile, IdSMTP, cxGridExportLink,
     VCL.ActnList, cxControls, IdExplicitTLSClientServerBase, IdSSLOpenSSL,
     IdGlobal, StrUtils, IOUtils, Types;

{ TdsdSMTPAction }

procedure Register;
begin
  RegisterActions('DSDLib', [TdsdSMTPAction], TdsdSMTPAction);
  RegisterActions('DSDLib', [TdsdSMTPGridAction], TdsdSMTPGridAction);
  RegisterActions('DSDLib', [TdsdSMTPFileAction], TdsdSMTPFileAction);
  RegisterActions('DSDLib', [TdsdSMTPMultipleFileAction], TdsdSMTPMultipleFileAction);
end;

type

  TMailer = class
    class procedure LInitializeISO(var VHeaderEncoding: Char; var VCharSet: string);
    class function SendMail(const Host: String; const Port: integer;
                            const Password, Username: String;
                            const Recipients:  array of String;
                            const FromAdres, Subject: String;
                            const MessageText:  String;
                            const Attachments: array of String): boolean;
  end;

class procedure TMailer.LInitializeISO(var VHeaderEncoding: Char; var VCharSet: string);
begin
  VHeaderEncoding:='B';
  VCharSet:='Windows-1251';
end;

class function TMailer.SendMail(const Host: String; const Port: integer;
                          const Password, Username: String;
                          const Recipients:  array of String;
                          const FromAdres, Subject: String;
                          const MessageText:  String;
                          const Attachments: array of String): boolean;

var EMsg: TIdMessage;
    FIdSMTP: TIdSMTP;
    EText: TIdText;
    i: integer;
    Stream: TFileStream;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
 begin
  FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FIdSSLIOHandlerSocketOpenSSL.MaxLineAction := maException;
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvTLSv1;
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Mode := sslmUnassigned;
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.VerifyDepth := 0;

  result := false;
  FIdSMTP := TIdSMTP.Create(nil);
  FIdSMTP.Host:= Host;
  FIdSMTP.Port := Port;
  FIdSMTP.Password:= Password;
  FIdSMTP.Username:= Username;
  FIdSMTP.IOHandler := FIdSSLIOHandlerSocketOpenSSL;
  if AnsiLowerCase(FIdSMTP.Host) = 'smtp.gmail.com' then
    FIdSMTP.UseTLS := utUseExplicitTLS
  else FIdSMTP.UseTLS := utUseImplicitTLS;

  EMsg := TIdMessage.Create(FIdSMTP);
  EMsg.OnInitializeISO := Self.LInitializeISO;

  try
    EMsg.CharSet := 'Windows-1251';
    EMsg.Subject := Subject;
    EMsg.ContentTransferEncoding  := '8bit';

    EText := TIdText.Create(EMsg.MessageParts);

    EText.Body.Text :=
              '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+
              '<html><head>'+
                              '<meta http-equiv="content-type" content="text/html; charset=Windows-1251">'+
                              '<title>' + Subject + '</title></head>'+
              '<body bgcolor="#ffffff">'+
              ReplaceStr(MessageText, #10, '<br>') + '</body></html>';

    EText.ContentType := 'text/html';
    EText.CharSet := 'Windows-1251';
    EText.ContentTransfer := '8bit';
    for i := 0 to high(Recipients) do
        EMsg.Recipients.Add.Address :=Recipients[i];
    EMsg.From.Address := FromAdres;
    EMsg.Body.Clear;
    EMsg.Date := now;
    for i := 0 to high(Attachments) do
      if FileExists(Trim(Attachments[i])) then begin
         Stream := TFileStream.Create(Attachments[i], fmOpenReadWrite);
         try
            with TIdAttachmentFile.Create(EMsg.MessageParts) do begin
                 FileName := ExtractFileName(Attachments[i]);
                 LoadFromStream(Stream);
            end;
         finally
            FreeAndNil(Stream);
         end;
      end;
    EMsg.AfterConstruction;

    try
      FIdSMTP.Connect;
      if FIdSMTP.Connected then begin
         FIdSMTP.Send(EMsg);
         result := true;
      end;
    except on E:Exception do raise Exception.Create('Ошибка отправки письма: ' + E.Message);
    end;
  finally
    FIdSMTP.Disconnect;
    FreeAndNil(FIdSMTP);
  end;
end;

constructor TdsdSMTPAction.Create(AOwner: TComponent);
begin
  inherited;
  FToAddress := TdsdParam.Create;
  FPort := TdsdParam.Create;
  FPort.Value := 25;
  FPassword := TdsdParam.Create;
  FFromAddress := TdsdParam.Create;
  FUserName := TdsdParam.Create;
  FHost := TdsdParam.Create;
  FSubject := TdsdParam.Create;
  FBody := TdsdParam.Create;
end;

procedure TdsdSMTPAction.DeleteAttachments;
begin

end;

destructor TdsdSMTPAction.Destroy;
begin
  FreeAndNil(FToAddress);
  FreeAndNil(FPort);
  FreeAndNil(FPassword);
  FreeAndNil(FFromAddress);
  FreeAndNil(FUserName);
  FreeAndNil(FHost);
  FreeAndNil(FSubject);
  FreeAndNil(FBody);
  inherited;
end;

procedure TdsdSMTPAction.FillAttachments;
begin

end;

function TdsdSMTPAction.LocalExecute: boolean;
var Recipients: TArrayOfS;
    RicipientsList: TStringList;
    i: integer;
begin
  RicipientsList := TStringList.Create;
  try
    if POS(';',ToAddress.Value) > 0
    then RicipientsList.Delimiter:=';'
    //else RicipientsList.Delimiter:=',' !!!это DEFAULT!!!
    ;
    RicipientsList.DelimitedText := ToAddress.Value;
    SetLength(Recipients, RicipientsList.Count);
    for I := 0 to RicipientsList.Count - 1 do
        Recipients[i] := RicipientsList[i];
  finally
    RicipientsList.Free;
  end;
  FillAttachments;
  try
    if Assigned (Body.Component)
    then
      result := TMailer.SendMail(Host.Value, Port.Value,
                                 Password.Value, Username.Value,
                                 Recipients, FromAddress.Value,
                                 Subject.Value, Body.Value,
                                 FAttachments)
    else
      result := TMailer.SendMail(Host.Value, Port.Value,
                                 Password.Value, Username.Value,
                                 Recipients, FromAddress.Value,
                                 Subject.Value, '',
                                 FAttachments);
  finally
    DeleteAttachments;
  end;
end;

{ TdsdSMTPDBViewAction }

procedure TdsdSMTPGridAction.FillAttachments;
begin
  inherited;
  SetLength(FAttachments, 1);
  FAttachments[0] := FFileName;
end;

function TdsdSMTPGridAction.LocalExecute: boolean;
var GUID: TGuid;
begin
  CreateGUID(GUID);
  FFileName := ExtractFilePath(ParamStr(0)) + GUIDToString(GUID) + '.xls';
  ExportGridToExcel(FFileName, FcxGrid, IsCtrlPressed, true, false);
  try
    result := inherited LocalExecute;
  finally
    // Обязательно тут грохнуть файл!!!
    if FileExists(FFileName) then
       DeleteFile(FFileName);
  end;
end;

{ TdsdSMTPFileAction }

procedure TdsdSMTPFileAction.DeleteAttachments;
begin
  inherited;
  // Обязательно тут грохнуть файл!!!
  if FileExists(FileName) then
     DeleteFile(FileName);
end;

procedure TdsdSMTPFileAction.FillAttachments;
var Files: TStringDynArray;
begin
  inherited;
  if not FileExists(FFileName) then begin
     Files := TDirectory.GetFiles(GetCurrentDir, FFileName + '.*');
     if High(Files) >= 0 then
        FileName := Files[0];
  end;

//ShowMessage(FFileName);
//if not FileExists(FFileName) then ShowMessage('not find ' + FFileName);

  SetLength(FAttachments, 1);
  FAttachments[0] := FFileName;

end;

{ TdsdSMTPMultipleFileAction }

constructor TdsdSMTPMultipleFileAction.Create(AOwner: TComponent);
begin
  inherited;
  FFieldFileNameParam := TdsdParam.Create;
  FFieldFileNameParam.DataType := ftString;
  FFieldFileNameParam.Value := '';
end;

destructor TdsdSMTPMultipleFileAction.Destroy;
begin
  FreeAndNil(FFieldFileNameParam);
  inherited;
end;

procedure TdsdSMTPMultipleFileAction.DeleteAttachments;
  var I : Integer;
begin
  inherited;
  // Обязательно тут грохнуть файл!!!
  for I := 0 to High(FAttachments) do
    if FileExists(FAttachments[I]) then
       DeleteFile(FAttachments[I]);

  SetLength(FAttachments, 0);
end;

procedure TdsdSMTPMultipleFileAction.FillAttachments;
begin
  inherited;

  if not Assigned(FDataSet) then 
    raise Exception.Create('Не определен DataSet со списком отправляемых файлов.');
  
  if not FDataSet.Active or FDataSet.IsEmpty then 
    raise Exception.Create('Нет файлов для отправки.');

  if FFieldFileNameParam.Value = '' then 
    raise Exception.Create('Не определено имя поля с названием файла.');

  if not Assigned(FDataSet.Fields.FindField(FFieldFileNameParam.Value)) then 
    raise Exception.Create('Нет поля с именем ' + FFieldFileNameParam.Value + ' в DataSet.');

  FDataSet.First;
  while not FDataSet.Eof do
  begin
    if FileExists(FDataSet.FieldByName(FFieldFileNameParam.Value).AsString) then
    begin
      SetLength(FAttachments, High(FAttachments) + 2);
      FAttachments[High(FAttachments)] := FDataSet.FieldByName(FFieldFileNameParam.Value).AsString;
    end else raise Exception.Create('Файл ' + FDataSet.FieldByName(FFieldFileNameParam.Value).AsString + ' не найден.');

    FDataSet.Next;
  end;

end;

initialization
  RegisterClass(TdsdSMTPAction);
  RegisterClass(TdsdSMTPGridAction);
  RegisterClass(TdsdSMTPFileAction);
  RegisterClass(TdsdSMTPMultipleFileAction);


end.
