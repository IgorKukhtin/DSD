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
  cxNavigator, cxDataControllerConditionalFormattingRulesManagerDialog,
  Datasnap.DBClient, dxDateTimeWheelPicker;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    SchedulerDS: TDataSource;
    qryMailParam: TZQuery;
    Panel2: TPanel;
    btnSendMail: TButton;
    btnExport: TButton;
    btnExecute: TButton;
    btnAll: TButton;
    grtvReport: TcxGridDBTableView;
    grReportLevel1: TcxGridLevel;
    grReport: TcxGrid;
    qryReport_Upload: TZQuery;
    dsReport_Upload: TDataSource;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Id: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    Mail: TcxGridDBColumn;
    DateRun: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    btnAllLine: TButton;
    SchedulerCDS: TClientDataSet;
    btnSaveSchedulerCDS: TButton;
    SchedulerCDSID: TAutoIncField;
    SchedulerCDSName: TStringField;
    SchedulerCDSDateRun: TDateTimeField;
    SchedulerCDSInterval: TIntegerField;
    SchedulerCDSProceure: TStringField;
    SchedulerCDSMail: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnSendMailClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAllLineClick(Sender: TObject);
    procedure btnSaveSchedulerCDSClick(Sender: TObject);
  private
    { Private declarations }
    RepType : integer;

    FileName: String;
    SavePath: String;
    Subject: String;

    FProcError : Boolean;

    function SendMail(const Host: String; const Port: integer; const Password,
      Username: String; const Recipients: String; const FromAdres,
      Subject, MessageText: String;
      const Attachments: array of String): boolean;
    procedure LInitializeISO(var VHeaderEncoding: Char; var VCharSet: string);
  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
    procedure OpenAndFormatSQL;

    procedure AllLine;
    procedure ReportFormation;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

function GetThousandSeparator : string;
begin
  if FormatSettings.ThousandSeparator = #160 then Result := ' '
  else Result := FormatSettings.ThousandSeparator;
end;


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

procedure TMainForm.AllLine;
begin
  try
    FProcError := False;

    Add_Log('');
    Add_Log('-------------------');
    Add_Log('Задание: ' + SchedulerCDS.FieldByName('Name').AsString);

    RepType := 0;
    ReportFormation;
    btnExportClick(Nil);
    btnSendMailClick(Nil);

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;


procedure TMainForm.btnAllClick(Sender: TObject);
begin
  try
    SchedulerCDS.First;
    while not SchedulerCDS.Eof do
    begin

    if SchedulerCDS.FieldByName('DateRun').AsDateTime <= Now then
    begin

      AllLine;

      SchedulerCDS.Edit;
      if SchedulerCDS.FieldByName('Interval').AsInteger < 30 then
        SchedulerCDS.FieldByName('DateRun').AsDateTime := IncDay(SchedulerCDS.FieldByName('DateRun').AsDateTime, SchedulerCDS.FieldByName('Interval').AsInteger)
      else SchedulerCDS.FieldByName('DateRun').AsDateTime := IncMonth(SchedulerCDS.FieldByName('DateRun').AsDateTime);
      SchedulerCDS.Post;
      SchedulerCDS.SaveToFile(ExtractFilePath(Application.ExeName) + 'ExportReportsToEmployees.xml', dfXML);
    end;
      SchedulerCDS.Next;
      Application.ProcessMessages;
    end;
  except
    on E: Exception do
      Add_Log(E.Message);
  end;

end;

procedure TMainForm.btnAllLineClick(Sender: TObject);
begin
  AllLine;
end;

procedure TMainForm.OpenAndFormatSQL;
  var I, W : integer;
begin
  qryReport_Upload.DisableControls;
  try
    try
      qryReport_Upload.Open;
    except
      on E:Exception do
      begin
        Add_Log(E.Message);
        Exit;
      end;
    end;

    if qryReport_Upload.IsEmpty then
    begin
      qryReport_Upload.Close;
      Exit;
    end;

    for I := 0 to qryReport_Upload.FieldCount - 1 do with grtvReport.CreateColumn do
    begin
      HeaderAlignmentHorz := TAlignment.taCenter;
      Options.Editing := False;
      DataBinding.FieldName := qryReport_Upload.Fields.Fields[I].FieldName;
      if qryReport_Upload.Fields.Fields[I].DataType in [ftString, ftWideString] then
      begin
        W := 10;
        qryReport_Upload.First;
        while not qryReport_Upload.Eof do
        begin
          W := Max(W, LengTh(qryReport_Upload.Fields.Fields[I].AsString));
          if W > 70 then Break;
          qryReport_Upload.Next;
        end;
        qryReport_Upload.First;
        Width := 6 * Min(W, 70) + 2;
      end;

      if (Pos('количество', AnsiLowerCase(qryReport_Upload.Fields.Fields[I].FieldName)) > 0) OR
         (Pos('сумма', AnsiLowerCase(qryReport_Upload.Fields.Fields[I].FieldName)) > 0) then
        with TcxGridDBTableSummaryItem(grtvReport.DataController.Summary.FooterSummaryItems.Add) do
        begin
          Column := grtvReport.Columns[I];
//          Format := '0.###';
          Kind := skSum;
        end;

    end;
  finally
    qryReport_Upload.EnableControls;
  end;
end;

procedure TMainForm.ReportFormation;
  var DateStart : TDateTime;
      DateEnd : TDateTime;
begin

  DateEnd := IncDay(StartOfTheDay(SchedulerCDS.FieldByName('DateRun').AsDateTime), -1);
  if SchedulerCDS.FieldByName('Interval').AsInteger < 30 then
    DateStart := IncDay(DateEnd, 1 - SchedulerCDS.FieldByName('Interval').AsInteger)
  else DateStart := IncMonth(DateEnd, -1);

  Add_Log('Начало Формирования' +
                                          FormatDateTime('dd.mm.yyyy', DateStart) + ' по ' +
                                          FormatDateTime('dd.mm.yyyy', DateEnd));
  FileName := SchedulerCDS.FieldByName('Name').AsString;
  Subject := FileName + ' за период с ' + FormatDateTime('dd.mm.yyyy', DateStart) + ' по ' +
                                          FormatDateTime('dd.mm.yyyy', DateEnd);

  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvReport.ColumnCount > 0 then grtvReport.ClearItems;
  if grtvReport.DataController.Summary.FooterSummaryItems.Count > 0 then
    grtvReport.DataController.Summary.FooterSummaryItems.Clear;

  qryReport_Upload.SQL.Text := SchedulerCDS.FieldByName('Proceure').AsString;

  qryReport_Upload.Params.ParamByName('inStartDate').Value := DateStart;
  qryReport_Upload.Params.ParamByName('inEndDate').Value := DateEnd;

  OpenAndFormatSQL;

  if grtvReport.ColumnCount = 0 then Exit;

  RepType := SchedulerCDS.FieldByName('ID').AsInteger;
end;

procedure TMainForm.btnExecuteClick(Sender: TObject);
begin
  inherited;
  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvReport.ColumnCount > 0 then grtvReport.ClearItems;
  if grtvReport.DataController.Summary.FooterSummaryItems.Count > 0 then
    grtvReport.DataController.Summary.FooterSummaryItems.Clear;

  RepType := 0;
  ReportFormation;
end;

procedure TMainForm.btnExportClick(Sender: TObject);
var
  sl: TStringList;
begin
  if not qryReport_Upload.Active then Exit;
  if qryReport_Upload.IsEmpty then Exit;
  Add_Log('Начало выгрузки отчета');
  if not ForceDirectories(SavePath) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    FProcError := True;
    exit;
  end;

  // обычный отчет
  try
    try
      ExportGridToExcel(SavePath + FileName, grReport);
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        FProcError := True;
        exit;
      end;
    end;
  finally
  end;
end;

procedure TMainForm.btnSaveSchedulerCDSClick(Sender: TObject);
begin
   SchedulerCDS.SaveToFile(ExtractFilePath(Application.ExeName) + 'ExportReportsToEmployees.xml', dfXML);
end;

procedure TMainForm.btnSendMailClick(Sender: TObject);
begin

  if not FileExists(SavePath + FileName + '.xls') then Exit;

  Add_Log('Начало отправки отчета: ' + SavePath + FileName + '.xls');

  if SendMail(qryMailParam.FieldByName('Mail_Host').AsString,
       qryMailParam.FieldByName('Mail_Port').AsInteger,
       qryMailParam.FieldByName('Mail_Password').AsString,
       qryMailParam.FieldByName('Mail_User').AsString,
       SchedulerCDS.FieldByName('Mail').AsString,
       qryMailParam.FieldByName('Mail_From').AsString,
       Subject,
       '',
       [SavePath + FileName + '.xls']) then
  begin
    try
      DeleteFile(SavePath + FileName + '.xls');
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        FProcError := True;
      end;
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
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ExportReportsToEmployees.ini');

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
      Close;
      Exit;
    end;
  end;

  if ZConnection1.Connected then
  begin

    try
      if FileExists(ExtractFilePath(Application.ExeName) + 'ExportReportsToEmployees.xml') then
        SchedulerCDS.LoadFromFile(ExtractFilePath(Application.ExeName) + 'ExportReportsToEmployees.xml');
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        Close;
        Exit;
      end;
    end;

    qryMailParam.Close;
    try
      qryMailParam.Open;
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        Close;
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
      btnSendMail.Enabled := false;
      Timer1.Enabled := true;
    end;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;
    if ZConnection1.Connected then btnAllClick(nil);
  finally
    Close;
  end;
end;

procedure TMainForm.LInitializeISO(var VHeaderEncoding: Char; var VCharSet: string);
begin
  VHeaderEncoding:='B';
  VCharSet:='Windows-1251';
end;

function TMainForm.SendMail(const Host: String; const Port: integer;
                          const Password, Username: String;
                          const Recipients: String;
                          const FromAdres, Subject: String;
                          const MessageText:  String;
                          const Attachments: array of String): boolean;

var EMsg: TIdMessage;
    FIdSMTP: TIdSMTP;
    EText: TIdText;
    i: integer;
    Stream: TFileStream;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    Res: TArray<string>;
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
  FIdSMTP.UseTLS := utUseImplicitTLS;

  EMsg := TIdMessage.Create(FIdSMTP);
  EMsg.OnInitializeISO := Self.LInitializeISO;

  try
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

      Res := TRegEx.Split(Recipients, '[;]');
      for i := 0 to high(Res) do
          EMsg.Recipients.Add.Address :=Res[i];
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

      FIdSMTP.Connect;
      if FIdSMTP.Connected then begin
         FIdSMTP.Send(EMsg);
         result := true;
      end;
    Except ON E:Exception DO
      Begin
        Add_Log(E.Message);
        FProcError := True;
      end;
    end;
  finally
    FIdSMTP.Disconnect;
    FreeAndNil(FIdSMTP);
  end;
end;

end.
