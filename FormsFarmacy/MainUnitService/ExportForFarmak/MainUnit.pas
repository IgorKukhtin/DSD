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
  cxNavigator, cxDataControllerConditionalFormattingRulesManagerDialog, System.Zip,
  cxExport, dxDateRanges, ComDocXML, OrderXML, xmldom, XMLDoc, XMLIntf;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    qryUnit: TZQuery;
    dsUnit: TDataSource;
    Panel2: TPanel;
    btnSendEmail: TButton;
    btnExport: TButton;
    btnExecute: TButton;
    btnAll: TButton;
    grtvUnit: TcxGridDBTableView;
    grReportUnitLevel1: TcxGridLevel;
    grReportUnit: TcxGrid;
    qryReport_Upload: TZQuery;
    dsReport_Upload: TDataSource;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    UnitId: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    btnExecuteGoods: TButton;
    Address: TcxGridDBColumn;
    Phones: TcxGridDBColumn;
    btnExecuteUnit: TButton;
    PharmacistId: TcxGridDBColumn;
    PharmacistName: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnSendEmailClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExecuteUnitClick(Sender: TObject);
    procedure btnExecuteGoodsClick(Sender: TObject);
  private
    { Private declarations }

    SavePath: String;
    Subject: String;
    UseId: Integer;
    MakerId: Integer;

    glRecipient: String;
    FileNamePharmacy: String;

  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
    procedure OpenFormatSQL;

    procedure AllUnit;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses Farmak_CRMPharmacyXML, Farmak_CRMWareXML;

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

procedure TMainForm.OpenFormatSQL;
  var I, W : integer;
begin
  qryReport_Upload.DisableControls;
  try

    if qryReport_Upload.IsEmpty then
    begin
      qryReport_Upload.Close;
      Exit;
    end;

    for I := 0 to qryReport_Upload.FieldCount - 1 do with grtvUnit.CreateColumn do
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
    end;
  finally
    qryReport_Upload.EnableControls;
  end;
end;

procedure TMainForm.AllUnit;
begin
end;


procedure TMainForm.btnAllClick(Sender: TObject);
begin
  try
      Add_Log('');
      Add_Log('---- Отправка всех данных');

      // Экспорт аптек
      btnExecuteUnitClick(Nil);
      Application.ProcessMessages;

      btnSendEmailClick(Nil);
      Application.ProcessMessages;

  except
    on E: Exception do
      Add_Log(E.Message);
  end;

  qryUnit.Close;
  qryUnit.Open;
end;

procedure TMainForm.btnSendEmailClick(Sender: TObject);
  VAR ZipFile: TZipFile;
begin

//  if not FileExists(SavePath + FileName + '.csv') then Exit;
//
//  Add_Log('Начало отправки прайса: ' + SavePath + FileName + '.csv');
//
//  try
//    ZipFile := TZipFile.Create;
//
//    try
//      ZipFile.Open(SavePath + FileName + '.zip', zmWrite);
//      ZipFile.Add(SavePath + FileName + '.csv');
//      ZipFile.Close;
//
//      DeleteFile(SavePath + FileName + '.csv');
//    finally
//      ZipFile.Free;
//    end;
//  except
//    on E: Exception do
//    begin
//      Add_Log(E.Message);
//      exit;
//    end;
//  end;

end;

procedure TMainForm.btnExecuteGoodsClick(Sender: TObject);
var
  CRMWare: IXMLCRMWareType;
begin

  qryReport_Upload.Close;
  qryReport_Upload.SQL.Text := 'SELECT * FROM gpSelect_Farmak_CRMWare (' + IntToStr(MakerId) + ', ''3'')';
  try
    qryReport_Upload.Open;
    OpenFormatSQL;
  except
    on E: Exception do
    begin
      Add_Log('Ошибка открытия списка медикаментов: ' + E.Message);
      Close;
      Exit;
    end;
  end;

  if not qryUnit.Active then Exit;
  if qryUnit.IsEmpty then Exit;
  Add_Log('Начало выгрузки таваров');
  if not ForceDirectories(SavePath) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;

  CRMWare := NewCRMWare;
  CRMWare.User := UseId;
  CRMWare.Scheme.Request := 'SET';
  CRMWare.Scheme.Name := 'CRMWare';

  with CRMWare.Scheme.Data.S.D do
  begin
    Name := 'CRMWare';
    with f.Add do
    begin
      Name := 'WareId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'MorionCode';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'BarCode';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'WareName';
      Type_ := 'String';
    end;
  end;

  CRMWare.Scheme.Data.O.D.Name := 'CRMWare';
  qryReport_Upload.First;
  while not qryReport_Upload.Eof do
  begin
    with CRMWare.Scheme.Data.O.D.R.Add do
    begin
      Add(qryReport_Upload.FieldByName('WareId').AsString);
      Add(qryReport_Upload.FieldByName('MorionCode').AsString);
      Add(qryReport_Upload.FieldByName('BarCode').AsString);
      Add(qryReport_Upload.FieldByName('WareName').AsString);
    end;
    qryReport_Upload.Next;
  end;

  CRMWare.OwnerDocument.Encoding := 'windows-1251';
  CRMWare.OwnerDocument.SaveToFile(SavePath + 'CRMWare.xml');
end;

procedure TMainForm.btnExecuteUnitClick(Sender: TObject);
var
  CRMPharmacy: IXMLCRMPharmacyType; nID : Integer;
begin
  if not qryUnit.Active then Exit;
  if qryUnit.IsEmpty then Exit;
  Add_Log('Начало выгрузки аптек');
  if not ForceDirectories(SavePath) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;

  Subject := IntToStr(UseId) + ':' + FormatDateTime('YYYY-MM-DD', Now) + ':10:Не болей';
  FileNamePharmacy := 'CRMPharmacy.xml';

  // обычный отчет

  CRMPharmacy := NewCRMPharmacy;
  CRMPharmacy.User := UseId;
  CRMPharmacy.Scheme.Request := 'SET';
  CRMPharmacy.Scheme.Name := 'CRMPharmacy';

  with CRMPharmacy.Scheme.Data.S.D do
  begin
    Name := 'CRMPharmacy';
    with f.Add do
    begin
      Name := 'PharmacyId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'CompanyId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'PharmacyName';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'PharmacyAddress';
      Type_ := 'String';
    end;
  end;

  with CRMPharmacy.Scheme.Data.S.D.D do
  begin
    Name := 'CRMPharmacist';
    with f.Add do
    begin
      Name := 'PharmacistId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'PharmacistName';
      Type_ := 'String';
    end;
  end;

  qryUnit.First;
  while not qryUnit.Eof do
  begin
    nID := qryUnit.FieldByName('PharmacyId').AsInteger;
    with CRMPharmacy.Scheme.Data.O.Add do
    begin
      Name := 'CRMPharmacy';
      with R.Add do
      begin
        F.Add(qryUnit.FieldByName('PharmacyId').AsString);
        F.Add(qryUnit.FieldByName('CompanyId').AsString);
        F.Add(qryUnit.FieldByName('PharmacyName').AsString);
        F.Add(qryUnit.FieldByName('PharmacyAddress').AsString);
        D.Name := 'CRMPharmacist';
        while not qryUnit.Eof and (qryUnit.FieldByName('PharmacyId').AsInteger = nID) do
        begin
          with D.R.Add do
          begin
            F.Add(qryUnit.FieldByName('PharmacistId').AsString);
            F.Add(qryUnit.FieldByName('PharmacistName').AsString);
          end;
          qryUnit.Next;
        end;
      end;
    end;
  end;

  CRMPharmacy.OwnerDocument.Encoding := 'windows-1251';
  CRMPharmacy.OwnerDocument.SaveToFile(SavePath + 'CRMPharmacy.xml');
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ExportForFarmak.ini');

  try
    SavePath := Trim(Ini.ReadString('Options', 'Path', ExtractFilePath(Application.ExeName)));
    if SavePath[Length(SavePath)] <> '\' then SavePath := SavePath + '\';
    Ini.WriteString('Options', 'Path', SavePath);

    UseId := Ini.ReadInteger('Options', 'UseId', 1);
    Ini.WriteInteger('Options', 'UseId', UseId + 1);

    MakerId := Ini.ReadInteger('Options', 'MakerId', 13648288);
    Ini.WriteInteger('Options', 'MakerId', MakerId);

    ZConnection1.Database := Ini.ReadString('Connect', 'DataBase', 'farmacy');
    Ini.WriteString('Connect', 'DataBase', ZConnection1.Database);

    ZConnection1.HostName := Ini.ReadString('Connect', 'HostName', '172.17.2.12');
    Ini.WriteString('Connect', 'HostName', ZConnection1.HostName);

    ZConnection1.User := Ini.ReadString('Connect', 'User', 'postgres');
    Ini.WriteString('Connect', 'User', ZConnection1.User);

    ZConnection1.Password := Ini.ReadString('Connect', 'Password', 'eej9oponahT4gah3');
    Ini.WriteString('Connect', 'Password', ZConnection1.Password);

    glRecipient := Ini.ReadString('Mail','Recipient','DataSupport@farmak.ua');
    Ini.WriteString('Mail','Recipient',glRecipient);

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
    qryUnit.Close;
    try
      qryUnit.Open;
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
      btnExecuteGoods.Enabled := false;
      btnExecute.Enabled := false;
      btnExport.Enabled := false;
      btnSendEmail.Enabled := false;
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


end.
