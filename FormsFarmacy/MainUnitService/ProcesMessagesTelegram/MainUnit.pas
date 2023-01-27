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
  cxDataControllerConditionalFormattingRulesManagerDialog, dxDateRanges,
  dxBarBuiltInMenu, cxGridChartView, cxGridDBChartView, JPEG, ZStoredProcedure,
  Datasnap.DBClient;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    MessagesTelegramDS: TDataSource;
    Panel2: TPanel;
    btnSendTelegram: TButton;
    btnProcesMessages: TButton;
    qryReport_Upload: TZQuery;
    dsReport_Upload: TDataSource;
    grChatId: TcxGrid;
    grChatIdDBTableView: TcxGridDBTableView;
    ciFirstName: TcxGridDBColumn;
    ciLastName: TcxGridDBColumn;
    ciUserName: TcxGridDBColumn;
    cidID: TcxGridDBColumn;
    grChatIdLevel: TcxGridLevel;
    grReport: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    Panel1: TPanel;
    cxGrid1: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    ChatIdDS: TDataSource;
    Message: TcxGridDBColumn;
    slChatId: TcxGridDBColumn;
    slText: TcxGridDBColumn;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    dsReport: TDataSource;
    qryReport: TZQuery;
    btnTestSendTelegram: TButton;
    btnTestSendManualTelegram: TButton;
    btnUpdate: TButton;
    spProcesMessagesTelegram: TZStoredProc;
    ObjectId: TcxGridDBColumn;
    TelegramId: TcxGridDBColumn;
    MessagesTelegramCDS: TClientDataSet;
    btnGetMessagesTelegram: TButton;
    tiServise: TTrayIcon;
    pmServise: TPopupMenu;
    pmClose: TMenuItem;
    Timer2: TTimer;
    btnProcesTimer2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnProcesMessagesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnTestSendTelegramClick(Sender: TObject);
    procedure btnTestSendManualTelegramClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnGetMessagesTelegramClick(Sender: TObject);
    procedure pmCloseClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure btnProcesTimer2Click(Sender: TObject);
  private
    { Private declarations }

    FileName: String;
    SavePath: String;
    Token : String;
    TelegramBot : TTelegramBot;

    FBookingsTabletkiLog : string;
    FBookingsTabletkiTelegramId : string;

    FMessage : TStringList;

    FError : boolean;


  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
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

procedure TMainForm.btnGetMessagesTelegramClick(Sender: TObject);
begin
  TelegramBot.LoadChatId;
end;

procedure TMainForm.btnProcesMessagesClick(Sender: TObject);
var
  Urgently : boolean; AGraphic: TGraphic; imJPEG : TJPEGImage;
begin
  FMessage.Clear;
  if not MessagesTelegramCDS.Active then Exit;
  if MessagesTelegramCDS.IsEmpty then Exit;

  try
    ZConnection1.Connect;

    MessagesTelegramCDS.First;
    while not MessagesTelegramCDS.EOF do
    begin
      Add_Log('Начало выгрузки списка сообщений');
      try
        FMessage.Text := '';

        spProcesMessagesTelegram.ParamByName('inChatId').AsInteger :=  MessagesTelegramCDS.FieldByName('ChatId').AsInteger;
        spProcesMessagesTelegram.ParamByName('inText').AsString := MessagesTelegramCDS.FieldByName('Text').AsString;
        spProcesMessagesTelegram.ParamByName('outResult').AsString := '';

        spProcesMessagesTelegram.ExecProc;

        FMessage.Text := StringReplace(spProcesMessagesTelegram.ParamByName('outResult').AsString, '\n', #13, [rfReplaceAll]);

      except
        on E:Exception do
        begin
          Add_Log(E.Message);
          FMessage.Text := E.Message;
        end;
      end;

      if FMessage.Text <> '' then TelegramBot.SendMessage(MessagesTelegramCDS.FieldByName('ChatId').AsString, FMessage.Text);

      MessagesTelegramCDS.Delete;
      MessagesTelegramCDS.First;
    end;

    ZConnection1.Disconnect;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      Timer1.Enabled := true;
      Exit;
    end;
  end;

end;

procedure TMainForm.btnProcesTimer2Click(Sender: TObject);
begin
  Timer2Timer(Sender);
end;

procedure TMainForm.btnTestSendManualTelegramClick(Sender: TObject);
  var AValues: array[0..1] of string;
begin
  AValues[1] := 'Тестовое сообщение...';
  if not InputQuery('Отправка сообщения', ['ID или имя','Текст сообщения'], AValues) then Exit;

  if (AValues[0] <> '') and (AValues[1] <> '') then TelegramBot.SendMessage(AValues[0], AValues[1]);
end;

procedure TMainForm.btnTestSendTelegramClick(Sender: TObject);
begin
  if not TelegramBot.ChatIdCDS.IsEmpty and (TelegramBot.ChatIdCDS.FieldByName('Id').AsLargeInt <> 0) then
    TelegramBot.SendMessage(TelegramBot.ChatIdCDS.FieldByName('Id').AsString, 'Тестовое сообщение...');
end;

procedure TMainForm.btnUpdateClick(Sender: TObject);
begin
  TelegramBot.LoadChatId;
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
  cxPageControl1.Properties.ActivePage := cxTabSheet1;

  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ProcesMessagesTelegram.ini');

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

    FBookingsTabletkiLog := Ini.ReadString('BookingsForTabletki', 'BookingsTabletkiLog', '');
    Ini.WriteString('BookingsForTabletki', 'BookingsTabletkiLog', FBookingsTabletkiLog);

    FBookingsTabletkiTelegramId := Ini.ReadString('BookingsForTabletki', 'BookingsTabletkiTelegramId', '');
    Ini.WriteString('BookingsForTabletki', 'BookingsTabletkiTelegramId', FBookingsTabletkiTelegramId);

  finally
    Ini.free;
  end;

  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection1.Connect;
    ZConnection1.Disconnect;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
    end;
  end;

  TelegramBot := TTelegramBot.Create(Token);
  TelegramBot.FileNameChatId := ExtractFilePath(Application.ExeName) + 'ProcesMessagesTelegram_ChatId.xml';
  TelegramBot.MessagesTelegramCDS := MessagesTelegramCDS;
  if TelegramBot.Id <> 0 then
  begin
    ChatIdDS.DataSet := TelegramBot.ChatIdCDS;
  end else Add_Log(TelegramBot.ErrorText);

  if not (((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0))) then
  begin
    Application.ShowMainForm:=False;
    Application.MainFormOnTaskBar:=False;
    btnGetMessagesTelegram.Enabled := false;
    btnProcesMessages.Enabled := false;
    btnSendTelegram.Enabled := false;
    btnTestSendTelegram.Enabled := false;
    btnTestSendManualTelegram.Enabled := false;
    btnUpdate.Enabled := false;
    btnProcesTimer2.Enabled := false;
    Timer1.Enabled := true;
    Timer2.Enabled := true;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FMessage.Free;
  TelegramBot.Free;
end;

procedure TMainForm.pmCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;

    btnGetMessagesTelegramClick(Sender);
    btnProcesMessagesClick(Sender);

  finally
    timer1.Enabled := True;
  end;
end;

procedure TMainForm.Timer2Timer(Sender: TObject);
  var DateTime: TDateTimeInfoRec; Res : TArray<string>; i : Integer;
begin
  Timer2.Enabled := False;

  try
    // Проверяем дату обработки заказов с таблеток
    if (FBookingsTabletkiLog <> '') and FileExists(FBookingsTabletkiLog) and
       (HourOf(Now) >= 8) and (HourOf(Now) < 21) then
    begin
      try
        if FileGetDateTimeInfo(FBookingsTabletkiLog, DateTime) and
          (MinutesBetween(DateTime.TimeStamp, Now) > 15) then
        begin
          Res := TRegEx.Split(FBookingsTabletkiTelegramId, ',');
          for I := 0 to High(Res) do
            TelegramBot.SendMessage(Res[I], 'Не работает обработка заказов с таблеток - ' + FormatCurr(',0', MinutesBetween(DateTime.TimeStamp, Now)) + ' мин.')
        end;
      except
        on E:Exception do Add_Log(E.Message);
      end;
    end;
  finally
    Timer2.Enabled := true;
  end;

end;

end.
