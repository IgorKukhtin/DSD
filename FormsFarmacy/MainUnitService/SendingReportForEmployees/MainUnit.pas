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
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    qryDriver: TZQuery;
    dsDriver: TDataSource;
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
    btnAllDriver: TButton;
    grReport: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    isUrgently: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    Panel1: TPanel;
    cxGrid1: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    drCode: TcxGridDBColumn;
    drName: TcxGridDBColumn;
    drChatIDSendVIP: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    ChatIdDS: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnSendTelegramClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAllDriverClick(Sender: TObject);
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
    Add_Log('Водитель VIP: ' + qryDriver.FieldByName('Name').AsString);

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

    qryDriver.First;
    while not qryDriver.Eof do
    begin

      btnSendTelegramClick(Nil);

      qryDriver.Next;
      Application.ProcessMessages;
    end;

    if not FError then
    begin
      Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'SendingSendDriverVIP.ini');
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

procedure TMainForm.btnAllDriverClick(Sender: TObject);
begin
  AllDriver;
end;

procedure TMainForm.btnExecuteClick(Sender: TObject);
  var APoint : TPoint;
begin
  if not qryDriver.Active then Exit;
  if qryDriver.IsEmpty then Exit;

  try
    FileName := qryDriver.FieldByName('Name').AsString;
    qryReport_Upload.Close;
    qryReport_Upload.ParamByName('Date').AsDateTime := FDate;
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
  if not qryDriver.Active then Exit;
  if qryDriver.IsEmpty then Exit;
  Add_Log('Начало выгрузки отчета');

  FMessage.Clear;
  qryReport_Upload.First;
  if qryReport_Upload.FieldByName('isUrgently').AsBoolean then
  begin
    Urgently := True;
    FMessage.Add('Срочный заказ:');
  end else
  begin
    Urgently := False;
    FMessage.Add('Доставить товар в течении 24 часов:');
  end;

  while not qryReport_Upload.Eof do
  begin
    if qryReport_Upload.FieldByName('isUrgently').AsBoolean <> Urgently then
    begin
      Urgently := False;
      FMessage.Add('');
      FMessage.Add('Доставить товар в течении 24 часов:');
    end;
    FMessage.Add('c ' + qryReport_Upload.FieldByName('FromName').AsString + ' на ' + qryReport_Upload.FieldByName('ToName').AsString);
    qryReport_Upload.Next;
  end;


end;

procedure TMainForm.btnSendTelegramClick(Sender: TObject);
begin

  if FMessage.Count = 0 then Exit;

  Add_Log('Начало отправки сообщения: ' + qryDriver.FieldByName('Name').AsString);

  try
    if not TelegramBot.SendMessage(qryDriver.FieldByName('ChatIDSendVIP').AsInteger, FMessage.Text) then
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
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'SendingSendDriverVIP.ini');

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
  TelegramBot.FileNameChatId := ExtractFilePath(Application.ExeName) + 'SendingSendDriverVIP_ChatId.xml';
  if TelegramBot.Id <> 0 then
  begin
    TelegramBot.LoadChatId;
    ChatIdDS.DataSet := TelegramBot.ChatIdCDS;
  end else Add_Log(TelegramBot.ErrorText);

  if ZConnection1.Connected then
  begin
    qryDriver.Close;
    try
      qryDriver.Open;
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
      btnAllDriver.Enabled := false;
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
    if qryDriver.Active then btnAllClick(nil);
  finally
    Close;
  end;
end;

end.
