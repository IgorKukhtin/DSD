unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGridExportLink, cxGraphics, Math,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
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
  IdFTP, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    qryMaker: TZQuery;
    dsMaker: TDataSource;
    qryMailParam: TZQuery;
    Panel2: TPanel;
    btnSendMail: TButton;
    btnExport: TButton;
    btnExecute: TButton;
    btnAll: TButton;
    grtvMaker: TcxGridDBTableView;
    grReportMakerLevel1: TcxGridLevel;
    grReportMaker: TcxGrid;
    qryReport_Upload: TZQuery;
    dsReport_Upload: TDataSource;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    CountryName: TcxGridDBColumn;
    ContactPersonName: TcxGridDBColumn;
    Phone: TcxGridDBColumn;
    Mail: TcxGridDBColumn;
    SendPlan: TcxGridDBColumn;
    SendReal: TcxGridDBColumn;
    isReport1: TcxGridDBColumn;
    isReport2: TcxGridDBColumn;
    isReport3: TcxGridDBColumn;
    isReport4: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    pmExecute: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnSendMailClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pmClick(Sender: TObject);
  private
    { Private declarations }
    FileName: String;
    SavePath: String;

    glSubject: String;
    glSubjectTeva: String;

    function SendMail(const Host: String; const Port: integer; const Password,
      Username: String; const Recipients: array of String; const FromAdres,
      Subject, MessageText: String;
      const Attachments: array of String): boolean;
    procedure LInitializeISO(var VHeaderEncoding: Char; var VCharSet: string);
  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
    procedure OpenAndFormatSQL;
    procedure ReportIncome;
    procedure ReportCheck;
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

procedure TMainForm.btnAllClick(Sender: TObject);
begin
  try
    qryMaker.First;
    while not qryMaker.Eof do
    begin
      ReportIncome;
      ReportCheck;
      btnExportClick;
      btnSendMailClick;
      qryMaker.Next;
      Application.ProcessMessages;
    end;
  except
    on E: Exception do
      Add_Log(E.Message);
  end;
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

    for I := 0 to qryReport_Upload.FieldCount - 1 do with grtvMaker.CreateColumn do
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

      if (DataBinding.FieldName = 'Цена СИП') or (DataBinding.FieldName = 'Сумма СИП') then
      begin
        Visible := False;
        qryReport_Upload.First;
        while not qryReport_Upload.Eof do
        begin
          if not qryReport_Upload.Fields.Fields[I].IsNull then
          begin
            Visible := True;
            Break;
          end;
          qryReport_Upload.Next;
        end;
        qryReport_Upload.First;
      end;

    end;
  finally
    qryReport_Upload.EnableControls;
  end;
end;

procedure TMainForm.ReportIncome;
begin
  Add_Log('Начало Формирования отчета по приходам ' + qryMaker.FieldByName('Name').AsString);
  FileName := 'Отчет по приходам';

  qryReport_Upload.Close;
  qryReport_Upload.SQL.Text :=
    'select '#13#10 +
    '  Code AS "Код", '#13#10 +
    '  Name AS "Название", '#13#10 +
    '  NDS AS "НДС", '#13#10 +
    '  PriceWithVAT AS "Цена прихода с НДС", '#13#10 +
    '  Price AS "Цена прихода (без НДС)", '#13#10 +
    '  PriceSIP AS "Цена СИП", '#13#10 +
    '  Amount AS "Итого кол-во", '#13#10 +
    '  SummSIP AS "Сумма СИП", '#13#10 +
    '  StatusName AS "Статус", '#13#10 +
    '  ItemName AS "Тип документа", '#13#10 +
    '  UnitName AS "Подразделение", '#13#10 +
    '  OperDate AS "Дата", '#13#10 +
    '  InvNumber AS "№ документа", '#13#10 +
    '  JuridicalName AS "Поставщик", '#13#10 +
    '  RetailName AS "Торговая сеть", '#13#10 +
    '  MainJuridicalName AS "Наше юр. лицо" '#13#10 +
    'from gpReport_MovementIncome_Promo(:inMaker, :inStartDate, :inEndDate, ''3'')';

  qryReport_Upload.Params.ParamByName('inMaker').Value := qryMaker.FieldByName('Id').AsInteger;
  qryReport_Upload.Params.ParamByName('inStartDate').Value := IncMonth(Date, - 1);
  qryReport_Upload.Params.ParamByName('inEndDate').Value := Date;

  OpenAndFormatSQL;
end;

procedure TMainForm.ReportCheck;
begin
  Add_Log('Начало Формирования отчета по приходам ' + qryMaker.FieldByName('Name').AsString);
  FileName := 'Отчет по приходам';

  qryReport_Upload.Close;
  qryReport_Upload.SQL.Text :=
    'select '#13#10 +
    '  Code AS "Код", '#13#10 +
    '  Name AS "Название", '#13#10 +
    '  NDS AS "НДС", '#13#10 +
    '  PriceWithVAT AS "Цена прихода с НДС", '#13#10 +
    '  Price AS "Цена прихода (без НДС)", '#13#10 +
    '  PriceSIP AS "Цена СИП", '#13#10 +
    '  Amount AS "Итого кол-во", '#13#10 +
    '  SummSIP AS "Сумма СИП", '#13#10 +
    '  StatusName AS "Статус", '#13#10 +
    '  ItemName AS "Тип документа", '#13#10 +
    '  UnitName AS "Подразделение", '#13#10 +
    '  OperDate AS "Дата", '#13#10 +
    '  InvNumber AS "№ документа", '#13#10 +
    '  JuridicalName AS "Поставщик", '#13#10 +
    '  RetailName AS "Торговая сеть", '#13#10 +
    '  MainJuridicalName AS "Наше юр. лицо" '#13#10 +
    'from gpReport_MovementIncome_Promo(:inMaker, :inStartDate, :inEndDate, ''3'')';

  qryReport_Upload.Params.ParamByName('inMaker').Value := qryMaker.FieldByName('Id').AsInteger;
  qryReport_Upload.Params.ParamByName('inStartDate').Value := IncMonth(Date, - 1);
  qryReport_Upload.Params.ParamByName('inEndDate').Value := Date;

  OpenAndFormatSQL;
end;


procedure TMainForm.pmClick(Sender: TObject);
begin
  case TMenuItem(Sender).Tag of
    0 : ReportIncome;
    1 : ;
  end;
end;

procedure TMainForm.btnExecuteClick(Sender: TObject);
  var APoint : TPoint;
begin
  inherited;

  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvMaker.ColumnCount > 0 then grtvMaker.ClearItems;


  APoint := btnExecute.ClientToScreen(Point(0, btnExecute.ClientHeight));
  pmExecute.Popup(APoint.X, APoint.Y);
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
    exit;
  end;

  // обычный отчет

  try
    try
      ExportGridToExcel(SavePath + FileName, grReportMaker);
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        exit;
      end;
    end;
  finally
  end;
end;

procedure TMainForm.btnSendMailClick(Sender: TObject);
begin

  if not FileExists(SavePath + FileName + '.xls') then Exit;

  if SendMail(qryMailParam.FieldByName('Mail_Host').AsString,
       qryMailParam.FieldByName('Mail_Port').AsInteger,
       qryMailParam.FieldByName('Mail_Password').AsString,
       qryMailParam.FieldByName('Mail_User').AsString,
       [qryMaker.FieldByName('Mail').AsString],
       qryMailParam.FieldByName('Mail_From').AsString,
       FileName,
       FileName,
       [SavePath + FileName + '.xls']) then
  begin
    try
      DeleteFile(SavePath + FileName + '.xls');
    except
      on E: Exception do
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
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ExportForMaker.ini');

  try
    SavePath := Trim(Ini.ReadString('Options', 'Path', ExtractFilePath(Application.ExeName)));
    if SavePath[Length(SavePath)] <> '\' then SavePath := SavePath + '\';
    Ini.WriteString('Options', 'Path', SavePath);

    ZConnection1.Database := Ini.ReadString('Connect', 'DataBase', 'farmacy');
    Ini.WriteString('Connect', 'DataBase', ZConnection1.Database);

    ZConnection1.HostName := Ini.ReadString('Connect', 'HostName', '9172.17.2.2');
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
    qryMaker.Close;
    try
      qryMaker.Open;
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
    btnAllClick(nil);
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

      FIdSMTP.Connect;
      if FIdSMTP.Connected then begin
         FIdSMTP.Send(EMsg);
         result := true;
      end;
    Except ON E:Exception DO
      Begin
        Add_Log(E.Message);
      end;
    end;
  finally
    FIdSMTP.Disconnect;
    FreeAndNil(FIdSMTP);
  end;
end;

end.
