unit CallbackHandler;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.StdCtrls, cxButtons, cxGroupBox, cxRadioGroup, cxLabel,
  cxTextEdit, cxCurrencyEdit, Vcl.ActnList, cxClasses, cxPropertiesStore,  dxSkinsCore,
  dxSkinsDefaultPainters, Vcl.ComCtrls, cxProgressBar, IdContext,
  IdCustomHTTPServer, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdHTTPServer, Winapi.ShellAPI, System.RegularExpressions;

type

  TCallbackHandlerForm = class(TForm)
    edMsgDescription: TEdit;
    cxProgressBar1: TcxProgressBar;
    Timer: TTimer;
    cxButton1: TcxButton;
    IdHTTPServer: TIdHTTPServer;
    labInterval: TcxLabel;
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IdHTTPServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  private
    { Private declarations }
    FURL : String;
    FCallback : String;
    FInterval : Integer;
    FHandle : THandle;
    FExecInfo: TShellExecuteInfo;
    FExitCode: DWORD;
  public
    { Public declarations }
  end;

var CallbackHandlerForm : TCallbackHandlerForm;

function ShowCallbackHandler(AURL, ACaption, AText: String; APort, AInterval: Integer; var ACallback : String) : Boolean;

implementation

{$R *.dfm}

  {TCallbackHandlerForm}

procedure TCallbackHandlerForm.cxButton1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCallbackHandlerForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if IdHTTPServer.Active and (ModalResult <> mrOk) then
  begin
    Action := caNone;
    ModalResult := 0;
    if MessageDlg('ѕрервать выполнение операции?',mtConfirmation,mbYesNo,0) = mrYes then IdHTTPServer.Active := False;
  end;
end;

procedure TCallbackHandlerForm.FormCreate(Sender: TObject);
begin
  FCallback := '';
  FInterval := 60000;
end;

procedure TCallbackHandlerForm.FormDestroy(Sender: TObject);
begin
  IdHTTPServer.Active := False;
  SendMessage(Application.MainForm.Handle, WM_SYSCOMMAND, SC_HOTKEY, Application.MainForm.Handle); // возвращаем фокус
end;

procedure TCallbackHandlerForm.FormShow(Sender: TObject);
begin
  if FURL <> '' then
  begin
    IdHTTPServer.Active := True;
    Timer.Enabled := True;
    FillChar(FExecInfo, SizeOf(TShellExecuteInfo), 0);
    with FExecInfo do
    begin
      cbSize := SizeOf(TShellExecuteInfo);
      fMask := SEE_MASK_NOCLOSEPROCESS;
      Wnd := Handle;
      lpFile := PChar(FURL);
      nShow := SW_SHOWNORMAL;
    end;
    ShellExecuteEx(@FExecInfo);
//    FHandle := ShellExecute(Screen.ActiveForm.Handle, 'open', PChar(FURL), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TCallbackHandlerForm.IdHTTPServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  var I : integer; Res: TArray<string>;
begin
  for I := 0 to ARequestInfo.Params.Count - 1 do
  begin
    Res := TRegEx.Split(ARequestInfo.Params.Strings[I], '=');
    if Res[0] = 'callback_result' then
    begin
      FCallback := COPY(Res[1], 2, Length(Res[1]) - 4);
      Timer.Enabled := False;
      ModalResult := mrOk;
      Break;
    end;
  end;
end;

procedure TCallbackHandlerForm.TimerTimer(Sender: TObject);
begin
  FInterval := FInterval - Timer.Interval;
  if IdHTTPServer.Active = False then
  begin
    Timer.Enabled := False;
    ModalResult := mrCancel;
  end else if FCallback <> '' then
  begin
    Timer.Enabled := False;
    IdHTTPServer.Active := False;
    ModalResult := mrOk;
  end else if FInterval <= 0 then
  begin
    Timer.Enabled := False;
    IdHTTPServer.Active := False;
    ModalResult := mrCancel;
  end else labInterval.Caption := IntToStr(FInterval div 60000) + ':' + IntToStr(FInterval mod 60000 div 1000);
end;

function ShowCallbackHandler(AURL, ACaption, AText: String; APort, AInterval: Integer; var ACallback : String) : Boolean;
Begin
  ACallback := '';
  CallbackHandlerForm := TCallbackHandlerForm.Create(Application);
  With CallbackHandlerForm do
  try
    try
      FURL := AURL;
      if AInterval <> 0 then FInterval := AInterval;
      if APort <> 0 then IdHTTPServer.DefaultPort := APort;
      if ACaption <> '' then Caption := ACaption;
      if AText <> '' then edMsgDescription.Text := AText;

      Result := ShowModal = mrOK;
      if Result then ACallback := FCallback;
    Except ON E: Exception DO
      MessageDlg(E.Message,mtError,[mbOk],0);
    end;
  finally
    FreeAndNil(CallbackHandlerForm);
  end;
End;

end.
