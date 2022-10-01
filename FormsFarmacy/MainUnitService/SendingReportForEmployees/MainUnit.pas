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
  dxBarBuiltInMenu, cxGridChartView, cxGridDBChartView, JPEG, ZStoredProcedure;

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
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    grChart2: TcxGrid;
    cxGridDBChartView1: TcxGridDBChartView;
    cxGridDBChartDataGroup2: TcxGridDBChartDataGroup;
    cxGridDBChartSeries10: TcxGridDBChartSeries;
    cxGridDBChartSeries7: TcxGridDBChartSeries;
    cxGridDBChartSeries8: TcxGridDBChartSeries;
    cxGridDBChartSeries9: TcxGridDBChartSeries;
    cxGridLevel3: TcxGridLevel;
    dsReport: TDataSource;
    qryReport: TZQuery;
    cxTabSheet3: TcxTabSheet;
    cxGrid2: TcxGrid;
    cxGridDBChartView2: TcxGridDBChartView;
    cxGridDBChartDataGroup1: TcxGridDBChartDataGroup;
    cxGridDBChartSeries1: TcxGridDBChartSeries;
    cxGridLevel4: TcxGridLevel;
    cxTabSheet4: TcxTabSheet;
    cxGrid3: TcxGrid;
    cxGridDBChartView3: TcxGridDBChartView;
    cxGridDBChartDataGroup3: TcxGridDBChartDataGroup;
    cxGridDBChartSeries2: TcxGridDBChartSeries;
    cxGridLevel5: TcxGridLevel;
    btnTestSendTelegram: TButton;
    btnTestSendManualTelegram: TButton;
    btnUpdate: TButton;
    spLog_Send_Telegram: TZStoredProc;
    ObjectId: TcxGridDBColumn;
    TelegramId: TcxGridDBColumn;
    cxGridDBChartSeries11: TcxGridDBChartSeries;
    cxTabSheet5: TcxTabSheet;
    cxGridPopulMobileApplication: TcxGrid;
    cxGridDBTableView3: TcxGridDBTableView;
    cxGridDBColumn_UnitName: TcxGridDBColumn;
    cxGridDBColumn_Users: TcxGridDBColumn;
    cxGridDBColumn_Summa: TcxGridDBColumn;
    cxGridLevel6: TcxGridLevel;
    cxGridDBColumn_CountChech: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnSendTelegramClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAllLineClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnTestSendTelegramClick(Sender: TObject);
    procedure btnTestSendManualTelegramClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
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
  DtartDate : TDateTime;
begin
  DtartDate := Now;
  try
    FError := False;

    if not qrySendList.Active then Exit;
    if qrySendList.IsEmpty then Exit;

    qrySendList.First;
    while not qrySendList.Eof do
    begin

      if (qrySendList.FieldByName('DateSend').AsDateTime < DtartDate) and
         (qrySendList.FieldByName('DateSend').AsDateTime > FDate) then
      begin
        btnExecuteClick(Nil);
        btnExportClick(Nil);
        btnSendTelegramClick(Nil);
      end;

      qrySendList.Next;
      Application.ProcessMessages;
    end;

    if not FError then
    begin
      FDate := DtartDate;
      Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'SendingReportForEmployees.ini');
      try
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
  if qryReport_Upload.Active then qryReport_Upload.Close;


  cxGridDBChartView1.DataController.DataSource := Nil;
  cxGridDBChartView2.DataController.DataSource := Nil;
  cxGridDBChartView3.DataController.DataSource := Nil;

  if qrySendList.FieldByName('Id').AsInteger in [13] then
  begin
    cxPageControl1.Properties.ActivePage := cxTabSheet5;
    cxGridDBTableView3.DataController.DataSource := dsReport;
    try
      FileName := 'Photo.jpg';
      qryReport.Close;
      qryReport.SQL.Text := qrySendList.FieldByName('SQL').AsString;
      qryReport.Open;
      cxGridPopulMobileApplication.Height := 18 * (qryReport.RecordCount + 4);
    except
      on E: Exception do Add_Log(E.Message);
    end;
  end else
  if qrySendList.FieldByName('Id').AsInteger in [3, 4] then
  begin
    cxPageControl1.Properties.ActivePage := cxTabSheet3;
    cxGridDBChartView2.DataController.DataSource := dsReport;
    try
      FileName := 'Photo.jpg';
      qryReport.Close;
      qryReport.SQL.Text := qrySendList.FieldByName('SQL').AsString;
      qryReport.Open;
    except
      on E: Exception do Add_Log(E.Message);
    end;
  end else
  if qrySendList.FieldByName('Id').AsInteger in [2] then
  begin
    cxPageControl1.Properties.ActivePage := cxTabSheet2;
    cxGridDBChartView1.DataController.DataSource := dsReport;
    try
      FileName := 'Photo.jpg';
      qryReport.Close;
      qryReport.SQL.Text := qrySendList.FieldByName('SQL').AsString;
      qryReport.Open;
      if Assigned(qryReport.FindField('StartDate')) then
        cxGridDBChartView1.DataGroups[0].DisplayText := 'Дата. Начиная с ' + qryReport.FindField('StartDate').AsString + ' по ' + qryReport.FindField('EndDate').AsString;
    except
      on E: Exception do Add_Log(E.Message);
    end;
  end else
  if qrySendList.FieldByName('Id').AsInteger in [6] then
  begin
    cxPageControl1.Properties.ActivePage := cxTabSheet4;
    cxGridDBChartView3.DataController.DataSource := dsReport;
    try
      FileName := 'Photo.jpg';
      qryReport.Close;
      qryReport.SQL.Text := qrySendList.FieldByName('SQL').AsString;
      qryReport.Open;
    except
      on E: Exception do Add_Log(E.Message);
    end;
  end else if qrySendList.FieldByName('ChatIDList').AsString = '' then
  begin
    cxPageControl1.Properties.ActivePage := cxTabSheet1;
    try
      qryReport_Upload.Close;
      qryReport_Upload.SQL.Text := qrySendList.FieldByName('SQL').AsString;
      qryReport_Upload.ParamByName('OperDate').Value := FDate;
      qryReport_Upload.Open;
    except
      on E: Exception do Add_Log(E.Message);
    end;
  end else
  begin
    cxPageControl1.Properties.ActivePage := cxTabSheet1;
    try
      qryReport_Upload.Close;
      qryReport_Upload.SQL.Text := qrySendList.FieldByName('SQL').AsString;
      qryReport_Upload.Open;
    except
      on E: Exception do Add_Log(E.Message);
    end;
  end;
end;

procedure TMainForm.btnExportClick(Sender: TObject);
var
  Urgently : boolean;
  AGraphic: TGraphic;
  imJPEG : TJPEGImage;
  bmp: TBitmap;
  DC: hDC;
begin
  FMessage.Clear;
  if not qrySendList.Active then Exit;
  if qrySendList.IsEmpty then Exit;

  if qrySendList.FieldByName('Id').AsInteger in [13] then
  begin
    if not qryReport.Active then Exit;
    if qryReport.IsEmpty then Exit;
    Add_Log('Начало выгрузки <Участие сотрудников в популяризации мобильного приложения по аптекам за ' + FormatDateTime('mmmm yyyy', IncDay(Date, - 1)));
    FMessage.Text := 'Участие сотрудников в популяризации мобильного приложения по аптекам за ' + FormatDateTime('mmmm yyyy', IncDay(Date, - 1)) + 'г. ';

    bmp := TBitmap.Create;
    try
      DC := GetDC(cxGridPopulMobileApplication.Handle);
      try
        bmp.Width := cxGridPopulMobileApplication.Width;
        bmp.Height := cxGridPopulMobileApplication.Height;
        bmp.Canvas.Lock;
        cxGridPopulMobileApplication.PaintTo(bmp.Canvas.Handle, 0, 0);
        bmp.Canvas.Unlock;

        imJPEG := TJPEGImage.Create;
        try
          imJPEG.Assign(bmp);
          imJPEG.SaveToFile(SavePath + FileName);
        finally
          AGraphic.Free;
          imJPEG.Free;
        end;
      finally
      end;
    finally
      bmp.Free;
    end;
  end else
  if qrySendList.FieldByName('Id').AsInteger in [3, 4] then
  begin
    if not qryReport.Active then Exit;
    if qryReport.IsEmpty then Exit;
    if qrySendList.FieldByName('Id').AsInteger = 3 then
    begin
      Add_Log('Начало выгрузки <Динамика изменения по дням недели в %>');
      FMessage.Text := 'Динамика изменения по дням недели в %';
    end else
    begin
      Add_Log('Начало выгрузки <Динамика изменения по дням недели в % (' + FormatDateTime('dddd', IncDay(Date, - 1)) + ')');
      FMessage.Text := 'Динамика изменения по дням недели в % (' + FormatDateTime('dddd', IncDay(Date, - 1)) + ')';
    end;
    AGraphic := cxGridDBChartView2.CreateImage(TBitmap);
    imJPEG := TJPEGImage.Create;
    try
      imJPEG.Assign(AGraphic);
      imJPEG.SaveToFile(SavePath + FileName);
    finally
      AGraphic.Free;
      imJPEG.Free;
    end;
  end else
  if qrySendList.FieldByName('Id').AsInteger in [2] then
  begin
    if not qryReport.Active then Exit;
    if qryReport.IsEmpty then Exit;
    if qrySendList.FieldByName('Id').AsInteger = 2 then
    begin
      Add_Log('Начало выгрузки <Динамика заказов по ЕИЦ>');
      FMessage.Text := 'Динамика заказов по ЕИЦ';
    end;
    AGraphic := cxGridDBChartView1.CreateImage(TBitmap);
    imJPEG := TJPEGImage.Create;
    try
      imJPEG.Assign(AGraphic);
      imJPEG.SaveToFile(SavePath + FileName);
    finally
      AGraphic.Free;
      imJPEG.Free;
    end;
  end else
  if qrySendList.FieldByName('Id').AsInteger in [6] then
  begin
    if not qryReport.Active then Exit;
    if qryReport.IsEmpty then Exit;
    if qrySendList.FieldByName('Id').AsInteger = 6 then
    begin
      Add_Log('Начало выгрузки <Рост/падение заказов месяца к предыдущему месяцу в %>');
      FMessage.Text := 'Рост/падение заказов месяца к предыдущему месяцу в %';
    end;
    AGraphic := cxGridDBChartView3.CreateImage(TBitmap);
    imJPEG := TJPEGImage.Create;
    try
      imJPEG.Assign(AGraphic);
      imJPEG.SaveToFile(SavePath + FileName);
    finally
      AGraphic.Free;
      imJPEG.Free;
    end;
  end else if qrySendList.FieldByName('ChatIDList').AsString = ''  then
  begin

    if not qryReport_Upload.Active then Exit;
    if qryReport_Upload.IsEmpty then Exit;
    Add_Log('Начало выгрузки списка сообщений');

  end else
  begin

    if not qryReport_Upload.Active then Exit;
    if qryReport_Upload.IsEmpty then Exit;
    Add_Log('Начало выгрузки сообщения');

    FMessage.Text := qryReport_Upload.FieldByName('Message').AsString;
  end;

end;

procedure TMainForm.btnSendTelegramClick(Sender: TObject);
  var Res : TArray<string>; I : Integer; nError : boolean;
begin

  if qrySendList.FieldByName('ChatIDList').AsString = '' then
  begin

    if qryReport_Upload.IsEmpty then Exit;

    Add_Log('Начало отправки сообщения: ' + qrySendList.FieldByName('Id').AsString);

    try
      while not qryReport_Upload.Eof do
      begin

        nError := False;
        if not TelegramBot.SendMessage(qryReport_Upload.FieldByName('TelegramId').AsString, qryReport_Upload.FieldByName('Message').AsString) then
        begin
          nError := True;
          Add_Log(TelegramBot.ErrorText);
        end;

        spLog_Send_Telegram.ParamByName('inObjectId').Value := qryReport_Upload.FieldByName('ObjectId').AsVariant;
        spLog_Send_Telegram.ParamByName('inTelegramId').Value := qryReport_Upload.FieldByName('TelegramId').AsString;
        spLog_Send_Telegram.ParamByName('inisError').Value := nError;
        spLog_Send_Telegram.ParamByName('inMessage').Value := qryReport_Upload.FieldByName('Message').AsString;
        spLog_Send_Telegram.ParamByName('inError').Value := TelegramBot.ErrorText;
        spLog_Send_Telegram.ExecProc;

        qryReport_Upload.Next;
      end;
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
      end;
    end;

  end else
  begin

    if FMessage.Count = 0 then Exit;

    Add_Log('Начало отправки сообщения: ' + qrySendList.FieldByName('Id').AsString);

    Res := TRegEx.Split(qrySendList.FieldByName('ChatIDList').AsString, ',');

    for I := 0 to High(Res) do if (Res[I] <> '') then
    try

      if qrySendList.FieldByName('Id').AsInteger in [2, 3, 4, 6, 13] then
      begin

        if not FileExists(SavePath + FileName) then Break;

        if not TelegramBot.SendPhoto(Res[I], SavePath + FileName, FMessage.Text) then
        begin
          FError := True;
          Add_Log(TelegramBot.ErrorText);
        end;
      end else
      begin
        if not TelegramBot.SendMessage(Res[I], FMessage.Text) then
        begin
          FError := True;
          Add_Log(TelegramBot.ErrorText);
        end;
      end;

    except
      on E: Exception do
      begin
        Add_Log(E.Message);
      end;
    end;

    if FileExists(SavePath + FileName) then DeleteFile(SavePath + FileName);
  end;
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
    // TelegramBot.LoadChatId;
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
      btnTestSendTelegram.Enabled := false;
      btnTestSendManualTelegram.Enabled := false;
      btnUpdate.Enabled := false;
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
