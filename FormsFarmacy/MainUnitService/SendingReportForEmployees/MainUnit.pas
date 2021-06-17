unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Win.ComObj, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGridExportLink, cxGraphics, Math,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, System.RegularExpressions,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxSpinEdit, Vcl.StdCtrls,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, cxPC, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, IniFiles,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  Vcl.ActnList, IdText, IdSSLOpenSSL, IdGlobal, strUtils, IdAttachmentFile,
  IdFTP, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils, cxButtonEdit, ZLibExGZ,
  cxImageComboBox, cxNavigator, UtilTelegram,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxDateRanges;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    qrySendList: TZQuery;
    dsSendList: TDataSource;
    Panel2: TPanel;
    btnSendTelegram: TButton;
    btnExport: TButton;
    btnExecute: TButton;
    btnAll: TButton;
    qryReport_Upload: TZQuery;
    dsReport_Upload: TDataSource;
    grChatId: TcxGrid;
    grChatIdDBTableView: TcxGridDBTableView;
    ciFirstName: TcxGridDBColumn;
    ciLastName: TcxGridDBColumn;
    ciUserName: TcxGridDBColumn;
    cidID: TcxGridDBColumn;
    grChatIdLevel: TcxGridLevel;
    btnAllLine: TButton;
    grReport: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    Panel1: TPanel;
    cxGrid1: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    ChatIdDS: TDataSource;
    Message: TcxGridDBColumn;
    slId: TcxGridDBColumn;
    slDateSend: TcxGridDBColumn;
    slChatIDList: TcxGridDBColumn;
    slSQL: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnSendTelegramClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAllLineClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }

    FileName: String;
    SavePath: String;
    Token : String;
    TelegramBot : TTelegramBot;
    FDate: TDateTime;

    FMessage : TStringList;

    FError : boolean;


  public
    { Public declarations }
    procedure Add_Log(AMessage:String);

    procedure AllDriver;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.Add_Log(AMessage: String);
var
  F: TextFile;

begin
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'.log'));
    if not fileExists(ChangeFileExt(Application.ExeName,'.log')) then
      Rewrite(F)
    else
      Append(F);
  try
    Writeln(F,FormatDateTime('YYYY.MM.DD hh:mm:ss',now) + ' - ' + AMessage);
  finally
    CloseFile(F);
  end;
  except
  end;
end;

procedure TMainForm.AllDriver;
begin
  try

    Add_Log('');
    Add_Log('-------------------');
    Add_Log('Сообщение: ' + qrySendList.FieldByName('Id').AsString);

    btnExecuteClick(Nil);
    btnExportClick(Nil);
    btnSendTelegramClick(Nil);

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;


procedure TMainForm.btnAllClick(Sender: TObject);
var
  Ini: TIniFile;
begin
  try
    FError := False;
    btnExecuteClick(Nil);
    btnExportClick(Nil);

    if not qryReport_Upload.Active then Exit;
    if qryReport_Upload.IsEmpty then Exit;

    qrySendList.First;
    while not qrySendList.Eof do
    begin

      btnSendTelegramClick(Nil);

      qrySendList.Next;
      Application.ProcessMessages;
    end;

    if not FError then
    begin
      Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'SendingReportForEmployees.ini');
      try
        FDate := Now;
        Ini.WriteDateTime('Options', 'Date', FDate);
      finally
        Ini.Free;
      end;
    end;

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;

procedure TMainForm.btnAllLineClick(Sender: TObject);
begin
  AllDriver;
end;

procedure TMainForm.btnExecuteClick(Sender: TObject);
  var APoint : TPoint;
begin
  if not qrySendList.Active then Exit;
  if qrySendList.IsEmpty then Exit;

  try
//    FileName := qrySendList.FieldByName('Name').AsString;
    qryReport_Upload.Close;
    qryReport_Upload.SQL.Text := qrySendList.FieldByName('SQL').AsString;
    qryReport_Upload.Open;
  except
    on E: Exception do Add_Log(E.Message);
  end;
end;

procedure TMainForm.btnExportClick(Sender: TObject);
var
  Urgently : boolean;
begin
  if not qryReport_Upload.Active then Exit;
  if qryReport_Upload.IsEmpty then Exit;
  if not qrySendList.Active then Exit;
  if qrySendList.IsEmpty then Exit;
  Add_Log('Начало выгрузки отчета');

  FMessage.Clear;
  FMessage.Text := qryReport_Upload.FieldByName('Message').AsString;

end;

procedure TMainForm.btnSendTelegramClick(Sender: TObject);
  var Res : TArray<string>; I, ChatId : Integer;
begin

  if FMessage.Count = 0 then Exit;

  Add_Log('Начало отправки сообщения: ' + qrySendList.FieldByName('Id').AsString);

  Res := TRegEx.Split(qrySendList.FieldByName('ChatIDList').AsString, FormatSettings.ListSeparator);

  for I := 0 to High(Res) do if TryStrToInt(Res[I], ChatId) then
  try
    if not TelegramBot.SendMessage(ChatId, FMessage.Text) then
    begin
      FError := True;
      Add_Log(TelegramBot.ErrorText);
    end;
  except
    on E: Exception do
    begin
      Add_Log(E.Message);
    end;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  FMessage := TStringList.Create;
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'SendingReportForEmployees.ini');

  try
    SavePath := Trim(Ini.ReadString('Options', 'Path', ExtractFilePath(Application.ExeName)));
    if SavePath[Length(SavePath)] <> '\' then SavePath := SavePath + '\';
    Ini.WriteString('Options', 'Path', SavePath);

    ZConnection1.Database := Ini.ReadString('Connect', 'DataBase', 'farmacy');
    Ini.WriteString('Connect', 'DataBase', ZConnection1.Database);

    ZConnection1.HostName := Ini.ReadString('Connect', 'HostName', '172.17.2.5');
    Ini.WriteString('Connect', 'HostName', ZConnection1.HostName);

    ZConnection1.User := Ini.ReadString('Connect', 'User', 'postgres');
    Ini.WriteString('Connect', 'User', ZConnection1.User);

    ZConnection1.Password := Ini.ReadString('Connect', 'Password', 'eej9oponahT4gah3');
    Ini.WriteString('Connect', 'Password', ZConnection1.Password);

    ZConnection1.Password := Ini.ReadString('Connect', 'Password', 'eej9oponahT4gah3');
    Ini.WriteString('Connect', 'Password', ZConnection1.Password);

    Token := Ini.ReadString('Telegram', 'Token', '');
    Ini.WriteString('Telegram', 'Token', Token);

    FDate := Ini.ReadDateTime('Options', 'Date', Now);

  finally
    Ini.free;
  end;

  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection1.Connect;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      Timer1.Enabled := true;
      Exit;
    end;
  end;

  TelegramBot := TTelegramBot.Create(Token);
  TelegramBot.FileNameChatId := ExtractFilePath(Application.ExeName) + 'SendingReportForEmployees_ChatId.xml';
  if TelegramBot.Id <> 0 then
  begin
    TelegramBot.LoadChatId;
    ChatIdDS.DataSet := TelegramBot.ChatIdCDS;
  end else Add_Log(TelegramBot.ErrorText);

  if ZConnection1.Connected then
  begin
    qrySendList.Close;
    try
      qrySendList.Open;
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        Timer1.Enabled := true;
        Exit;
      end;
    end;

    if not (((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) or
      (Pos('Farmacy.exe', Application.ExeName) <> 0)) then
    begin
      btnAll.Enabled := false;
      btnAllLine.Enabled := false;
      btnExecute.Enabled := false;
      btnExport.Enabled := false;
      btnSendTelegram.Enabled := false;
      Timer1.Enabled := true;
    end;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FMessage.Free;
  TelegramBot.Free;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;
    if qrySendList.Active then btnAllClick(nil);
  finally
    Close;
  end;
end;

end.
