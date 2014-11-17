unit dsdInternetAction;

interface

uses
  dsdAction, dsdDB, Classes;

type

  TdsdSMTPAction = class(TdsdCustomAction)
  private
    FBody: String;
    FToAddress: TdsdParam;
    FPort: TdsdParam;
    FPassword: TdsdParam;
    FFromAddress: TdsdParam;
    FUserName: TdsdParam;
    FHost: TdsdParam;
    FSubject: TdsdParam;
  protected
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

  procedure Register;

implementation

uses SysUtils, IdMessage, IdText, IdAttachmentFile, IdSMTP, VCL.ActnList;

{ TdsdSMTPAction }

procedure Register;
begin
  RegisterActions('DSDLib', [TdsdSMTPAction], TdsdSMTPAction);
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
begin
  result := false;
  FIdSMTP := TIdSMTP.Create(nil);
  FIdSMTP.Host:= Host;
  FIdSMTP.Password:= Password;
  FIdSMTP.Username:= Username;

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
              MessageText + '</body></html>';

    EText.ContentType := 'text/html';
    EText.CharSet := 'Windows-1251';
    EText.ContentTransfer := '8bit';
    for i := 0 to high(Recipients) do
        EMsg.Recipients.Add.Address :=Recipients[i];
    EMsg.From.Address := FromAdres;
    EMsg.Body.Clear;
    EMsg.Date := now;
    for i := 0 to high(Attachments) do
      if FileExists(Trim(Attachments[i])) then
         TIdAttachmentFile.Create(EMsg.MessageParts, Attachments[i]);
    EMsg.AfterConstruction;

    FIdSMTP.Connect;
    if FIdSMTP.Connected then
          FIdSMTP.Send(EMsg);
          result := true;
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
  inherited;
end;

function TdsdSMTPAction.LocalExecute: boolean;
var Recipients: array of String;
    Attachments: array of String;
begin
  SetLength(Recipients, 1);
  Recipients[0] := ToAddress.Value;
  result := TMailer.SendMail(Host.Value, Port.Value,
                             Password.Value, Username.Value,
                             Recipients, FromAddress.Value,
                             Subject.Value, Body,
                             Attachments);
end;

end.
