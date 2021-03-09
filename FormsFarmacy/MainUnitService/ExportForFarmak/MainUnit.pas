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
  Vcl.ActnList, strUtils, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils, cxButtonEdit, ZLibExGZ,
  cxNavigator, cxDataControllerConditionalFormattingRulesManagerDialog, System.Zip,
  cxExport, dxDateRanges, xmldom, XMLDoc, XMLIntf, cxDateUtils,
  IdSSLOpenSSL, IdText, IdAttachmentFile, IdGlobal;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    qryUnit: TZQuery;
    dsUnit: TDataSource;
    Panel2: TPanel;
    btnSendEmail: TButton;
    btnExecuteWhReceipt: TButton;
    btnExecuteBalance: TButton;
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
    btnExecuteDespatch: TButton;
    qryMailParam: TZQuery;
    DateStart: TcxDateEdit;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnSendEmailClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExecuteUnitClick(Sender: TObject);
    procedure btnExecuteGoodsClick(Sender: TObject);
    procedure btnExecuteBalanceClick(Sender: TObject);
    procedure btnExecuteWhReceiptClick(Sender: TObject);
    procedure btnExecuteDespatchClick(Sender: TObject);
  private
    { Private declarations }

    SavePath: String;
    UseId: Integer;
    MakerId: Integer;

    glRecipient: String;

  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
    procedure OpenFormatSQL;
    procedure LInitializeISO(var VHeaderEncoding: Char; var VCharSet: string);
    function SendMail(const Host: String; const Port: integer; const Password,
      Username: String; const Recipients: String; const FromAdres,
      Subject, MessageText: String;
      const Attachments: array of String): boolean;

    procedure AllUnit;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses Farmak_CRMPharmacyXML, Farmak_CRMWareXML, Farmak_CRMWhBalanceXML,
     Farmak_CRMDespatchXML, Farmak_CRMWhReceiptXML;

const FileName : array [0..4, 0..1] of string = (('CRMPharmacy.xml', 'CRMPharmacy.zip'),
                                                 ('CRMWare.xml', 'CRMWare.zip'),
                                                 ('CRMWhBalance.xml', 'CRMWhBalance.zip'),
                                                 ('CRMWhReceipt.xml', 'CRMWhReceipt.zip'),
                                                 ('CRMDespatch.xml', 'CRMDespatch.zip'));

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

    if grtvUnit.ColumnCount > 0 then grtvUnit.ClearItems;

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
    Application.ProcessMessages;
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

      btnExecuteGoodsClick(Nil);
      Application.ProcessMessages;

      btnExecuteBalanceClick(Nil);
      Application.ProcessMessages;

      btnExecuteWhReceiptClick(Nil);
      Application.ProcessMessages;

      btnExecuteDespatchClick(Nil);
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
  var ZipFile: TZipFile; Ini: TIniFile; I : Integer;
begin

  if not FileExists(SavePath + FileName[0, 0]) and
     not FileExists(SavePath + FileName[1, 0]) and
     not FileExists(SavePath + FileName[2, 0]) and
     not FileExists(SavePath + FileName[3, 0]) and
     not FileExists(SavePath + FileName[4, 0]) then Exit;

  Add_Log('Начало отправки данных');

  try
    ZipFile := TZipFile.Create;

    try
      for I := 0 to 4 do
      begin
        if FileExists(SavePath + FileName[I, 0]) then
        begin
          ZipFile.Open(SavePath + FileName [I, 1], zmWrite);
          ZipFile.Add(SavePath + FileName[I, 0]);
          ZipFile.Close;
        end;
      end;
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        exit;
      end;
    end;
  finally
    ZipFile.Free;
  end;

  if SendMail(qryMailParam.FieldByName('Mail_Host').AsString,
       qryMailParam.FieldByName('Mail_Port').AsInteger,
       qryMailParam.FieldByName('Mail_Password').AsString,
       qryMailParam.FieldByName('Mail_User').AsString,
       glRecipient,
       qryMailParam.FieldByName('Mail_From').AsString,
       IntToStr(UseId) + ':' + FormatDateTime('YYYY-MM-DD', Now) + ':10:Не болей',
       '',
       [SavePath + FileName[0, 1], SavePath + FileName[1, 1], SavePath + FileName[2, 1], SavePath + FileName[3, 1], SavePath + FileName[4, 1]]) then
  begin

    Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ExportForFarmak.ini');
    try
      Ini.WriteDate('Options', 'Date', Date);
      DateStart.Date := Ini.ReadDate('Options', 'Date', Date);

      Ini.WriteInteger('Options', 'UseId', UseId + 1);
      UseId := Ini.ReadInteger('Options', 'UseId', 1);

    finally
      Ini.free;
    end;

    try
      for I := 0 to 4 do
      begin
        if FileExists(SavePath + FileName[I, 0]) then DeleteFile(SavePath + FileName[I, 0]);
        if FileExists(SavePath + FileName[I, 1]) then DeleteFile(SavePath + FileName[I, 1]);
      end;
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        Exit;
      end;
    end;
  end;

end;

procedure TMainForm.btnExecuteBalanceClick(Sender: TObject);
var
  CRMWhBalance: IXMLCRMWhBalanceType; nID : Integer;
begin

  qryReport_Upload.Close;
  qryReport_Upload.SQL.Text := 'SELECT * FROM gpSelect_Farmak_CRMWhBalance (' + IntToStr(MakerId) + ', ''3'')';
  try
    qryReport_Upload.Open;
    OpenFormatSQL;
  except
    on E: Exception do
    begin
      Add_Log('Ошибка открытия списка остатков: ' + E.Message);
      Close;
      Exit;
    end;
  end;

  if not qryReport_Upload.Active then Exit;
  if qryUnit.IsEmpty then Exit;
  Add_Log('Начало выгрузки остатков');
  if not ForceDirectories(SavePath) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;

  CRMWhBalance := NewCRMWhBalance;
  CRMWhBalance.User := UseId;
  CRMWhBalance.Scheme.Request := 'SET';
  CRMWhBalance.Scheme.Name := 'CRMWhBalance';

  with CRMWhBalance.Scheme.Data.S.D do
  begin
    Name := 'CRMWhBalance';
    with f.Add do
    begin
      Name := 'PharmacyId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'WarehouseId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'BalanceDate';
      Type_ := 'Date';
    end;
  end;

  with CRMWhBalance.Scheme.Data.S.D.D do
  begin
    Name := 'CRMWhBalanceLine';
    with f.Add do
    begin
      Name := 'WareId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'Price';
      Type_ := 'Currency';
    end;
    with f.Add do
    begin
      Name := 'Quantity';
      Type_ := 'Currency';
    end;
  end;

  qryReport_Upload.First;
  while not qryReport_Upload.Eof do
  begin
    nID := qryReport_Upload.FieldByName('PharmacyId').AsInteger;
    with CRMWhBalance.Scheme.Data.O.Add do
    begin
      Name := 'CRMWhBalance';
      with R.Add do
      begin
        F.Add(qryReport_Upload.FieldByName('PharmacyId').AsString);
        F.Add(qryReport_Upload.FieldByName('WarehouseId').AsString);
        F.Add(FormatDateTime('YYYY-MM-DD''T''00:00:00', Date));
        D.Name := 'CRMWhBalanceLine';
        while not qryReport_Upload.Eof and (qryReport_Upload.FieldByName('PharmacyId').AsInteger = nID) do
        begin
          with D.R.Add do
          begin
            F.Add(qryReport_Upload.FieldByName('WareId').AsString);
            F.Add(StringReplace(qryReport_Upload.FieldByName('Price').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]));
            F.Add(StringReplace(qryReport_Upload.FieldByName('Quantity').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]));
          end;
          qryReport_Upload.Next;
        end;
      end;
    end;
  end;

  CRMWhBalance.OwnerDocument.Encoding := 'windows-1251';
  CRMWhBalance.OwnerDocument.SaveToFile(SavePath + FileName[2, 0]);

end;

procedure TMainForm.btnExecuteDespatchClick(Sender: TObject);
var
  CRMDespatch: IXMLCRMDespatchType; nID : Integer;
begin

  qryReport_Upload.Close;
  qryReport_Upload.SQL.Text := 'SELECT * FROM gpSelect_Farmak_CRMDespatch (' + IntToStr(MakerId) + ', :Date' + ', ''3'')';
  qryReport_Upload.Params.ParamByName('Date').Value := DateStart.Date;
  try
    qryReport_Upload.Open;
    OpenFormatSQL;
  except
    on E: Exception do
    begin
      Add_Log('Ошибка открытия списка расходов: ' + E.Message);
      Close;
      Exit;
    end;
  end;

  if not qryReport_Upload.Active then Exit;
  if qryUnit.IsEmpty then Exit;
  Add_Log('Начало выгрузки расходов');
  if not ForceDirectories(SavePath) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;

  CRMDespatch := NewCRMDespatch;
  CRMDespatch.User := UseId;
  CRMDespatch.Scheme.Request := 'SET';
  CRMDespatch.Scheme.Name := 'CRMDespatch';

  with CRMDespatch.Scheme.Data.S.D do
  begin
    Name := 'CRMDespatch';
    with f.Add do
    begin
      Name := 'DocumentDate';
      Type_ := 'Date';
    end;
    with f.Add do
    begin
      Name := 'DocumentNumber';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'WarehouseId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'PharmacyId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'PharmacistId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'CompanyId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'AddressId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'DstCodeId';
      Type_ := 'String';
    end;
  end;

  with CRMDespatch.Scheme.Data.S.D.D do
  begin
    Name := 'CRMDespatchLine';
    with f.Add do
    begin
      Name := 'WareId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'Price';
      Type_ := 'Currency';
    end;
    with f.Add do
    begin
      Name := 'Quantity';
      Type_ := 'Currency';
    end;
  end;

  qryReport_Upload.First;
  while not qryReport_Upload.Eof do
  begin
    nID := qryReport_Upload.FieldByName('MovementId').AsInteger;
    with CRMDespatch.Scheme.Data.O.Add do
    begin
      Name := 'CRMDespatch';
      with R.Add do
      begin
        F.Add(FormatDateTime('YYYY-MM-DD''T''00:00:00', qryReport_Upload.FieldByName('DocumentDate').AsDateTime));
        F.Add(qryReport_Upload.FieldByName('DocumentNumber').AsString);
        F.Add(qryReport_Upload.FieldByName('WarehouseId').AsString);
        F.Add(qryReport_Upload.FieldByName('PharmacyId').AsString);
        F.Add(qryReport_Upload.FieldByName('PharmacistId').AsString);
        F.Add(qryReport_Upload.FieldByName('CompanyId').AsString);
        F.Add(qryReport_Upload.FieldByName('AddressId').AsString);
        F.Add(qryReport_Upload.FieldByName('DstCodeId').AsString);
        D.Name := 'CRMDespatchLine';
        while not qryReport_Upload.Eof and (qryReport_Upload.FieldByName('MovementId').AsInteger = nID) do
        begin
          with D.R.Add do
          begin
            F.Add(qryReport_Upload.FieldByName('WareId').AsString);
            F.Add(StringReplace(qryReport_Upload.FieldByName('Price').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]));
            F.Add(StringReplace(qryReport_Upload.FieldByName('Quantity').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]));
          end;
          qryReport_Upload.Next;
        end;
      end;
    end;
  end;

  CRMDespatch.OwnerDocument.Encoding := 'windows-1251';
  CRMDespatch.OwnerDocument.SaveToFile(SavePath + FileName[4, 0]);end;

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

  if not qryReport_Upload.Active then Exit;
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
  CRMWare.OwnerDocument.SaveToFile(SavePath + FileName[1, 0]);
end;

procedure TMainForm.btnExecuteUnitClick(Sender: TObject);
var
  CRMPharmacy: IXMLCRMPharmacyType; nID : Integer;
begin
  if qryUnit.IsEmpty then Exit;
  Add_Log('Начало выгрузки аптек');
  if not ForceDirectories(SavePath) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;

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
  CRMPharmacy.OwnerDocument.SaveToFile(SavePath + FileName[0, 0]);
end;

procedure TMainForm.btnExecuteWhReceiptClick(Sender: TObject);
var
  CRMWhReceipt: IXMLCRMWhReceiptType; nID : Integer;
begin

  qryReport_Upload.Close;
  qryReport_Upload.SQL.Text := 'SELECT * FROM gpSelect_Farmak_CRMWhReceipt (' + IntToStr(MakerId) + ', :Date' + ', ''3'')';
  qryReport_Upload.Params.ParamByName('Date').Value := DateStart.Date;
  try
    qryReport_Upload.Open;
    OpenFormatSQL;
  except
    on E: Exception do
    begin
      Add_Log('Ошибка открытия списка приходов: ' + E.Message);
      Close;
      Exit;
    end;
  end;

  if not qryReport_Upload.Active then Exit;
  if qryUnit.IsEmpty then Exit;
  Add_Log('Начало выгрузки приходов');
  if not ForceDirectories(SavePath) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;

  CRMWhReceipt := NewCRMWhReceipt;
  CRMWhReceipt.User := UseId;
  CRMWhReceipt.Scheme.Request := 'SET';
  CRMWhReceipt.Scheme.Name := 'CRMWhReceipt';

  with CRMWhReceipt.Scheme.Data.S.D do
  begin
    Name := 'CRMWhReceipt';
    with f.Add do
    begin
      Name := 'DocumentDate';
      Type_ := 'Date';
    end;
    with f.Add do
    begin
      Name := 'DocumentNumber';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'WarehouseId';
      Type_ := 'String';
    end;
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
      Name := 'SrcCodeId';
      Type_ := 'String';
    end;
  end;

  with CRMWhReceipt.Scheme.Data.S.D.D do
  begin
    Name := 'CRMWhReceiptLine';
    with f.Add do
    begin
      Name := 'WareId';
      Type_ := 'String';
    end;
    with f.Add do
    begin
      Name := 'Price';
      Type_ := 'Currency';
    end;
    with f.Add do
    begin
      Name := 'Quantity';
      Type_ := 'Currency';
    end;
  end;

  qryReport_Upload.First;
  while not qryReport_Upload.Eof do
  begin
    nID := qryReport_Upload.FieldByName('MovementId').AsInteger;
    with CRMWhReceipt.Scheme.Data.O.Add do
    begin
      Name := 'CRMWhReceipt';
      with R.Add do
      begin
        F.Add(FormatDateTime('YYYY-MM-DD''T''00:00:00', qryReport_Upload.FieldByName('DocumentDate').AsDateTime));
        F.Add(qryReport_Upload.FieldByName('DocumentNumber').AsString);
        F.Add(qryReport_Upload.FieldByName('WarehouseId').AsString);
        F.Add(qryReport_Upload.FieldByName('PharmacyId').AsString);
        F.Add(qryReport_Upload.FieldByName('CompanyId').AsString);
        F.Add(qryReport_Upload.FieldByName('SrcCodeId').AsString);
        D.Name := 'CRMWhReceiptLine';
        while not qryReport_Upload.Eof and (qryReport_Upload.FieldByName('MovementId').AsInteger = nID) do
        begin
          with D.R.Add do
          begin
            F.Add(qryReport_Upload.FieldByName('WareId').AsString);
            F.Add(StringReplace(qryReport_Upload.FieldByName('Price').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]));
            F.Add(StringReplace(qryReport_Upload.FieldByName('Quantity').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]));
          end;
          qryReport_Upload.Next;
        end;
      end;
    end;
  end;

  CRMWhReceipt.OwnerDocument.Encoding := 'windows-1251';
  CRMWhReceipt.OwnerDocument.SaveToFile(SavePath + FileName[3, 0]);

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
    Ini.WriteInteger('Options', 'UseId', UseId);

    MakerId := Ini.ReadInteger('Options', 'MakerId', 13648288);
    Ini.WriteInteger('Options', 'MakerId', MakerId);

    DateStart.Date := Ini.ReadDate('Options', 'Date', Date);
    Ini.WriteDate('Options', 'Date', DateStart.Date);

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
      Timer1.Enabled := true;
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
        Timer1.Enabled := true;
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
        ZConnection1.Disconnect;
        Timer1.Enabled := true;
        Exit;
      end;
    end;

    if not ((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) then
    begin
      btnAll.Enabled := false;
      btnExecuteGoods.Enabled := false;
      btnExecuteBalance.Enabled := false;
      btnExecuteWhReceipt.Enabled := false;
      btnExecuteDespatch.Enabled := false;
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
      end;
    end;
  finally
    FIdSMTP.Disconnect;
    FreeAndNil(FIdSMTP);
  end;
end;

end.
