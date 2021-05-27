unit ExportSalesForSupp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGridExportLink, cxGraphics, Math,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, XSBuiltIns,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxSpinEdit, Vcl.StdCtrls,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, cxPC, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, IniFiles,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  Vcl.ActnList, IdText, IdSSLOpenSSL, IdGlobal, strUtils, IdAttachmentFile,
  IdFTP, cxCurrencyEdit, Vcl.Menus, IdHTTP, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, Xml.XMLDoc, XMLIntf, cxButtonEdit, cxNavigator,
  dxBarBuiltInMenu, DateUtils;

type
  TExportSalesForSuppForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    qryUnit: TZQuery;
    qryReport_Upload_BaDM: TZQuery;
    dsReport_Upload_BaDM: TDataSource;
    PageControl1: TPageControl;
    tsOptima: TTabSheet;
    tsBaDM: TTabSheet;
    PageControl: TcxPageControl;
    tsMain: TcxTabSheet;
    grBaDM: TcxGrid;
    grtvBaDM: TcxGridDBTableView;
    colOperDate: TcxGridDBColumn;
    colJuridicalCode: TcxGridDBColumn;
    colUnitCode: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colOperCode: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colSegment1: TcxGridDBColumn;
    colSegment2: TcxGridDBColumn;
    colSegment3: TcxGridDBColumn;
    colSegment4: TcxGridDBColumn;
    colSegment5: TcxGridDBColumn;
    grlBaDM: TcxGridLevel;
    Panel: TPanel;
    BaDMDate: TcxDateEdit;
    cxLabel1: TcxLabel;
    btnBaDMExecute: TButton;
    BaDMID: TcxSpinEdit;
    cxLabel2: TcxLabel;
    btnBaDMExport: TButton;
    Panel1: TPanel;
    OptimaDate: TcxDateEdit;
    cxLabel3: TcxLabel;
    btnOptimaExecute: TButton;
    OptimaId: TcxSpinEdit;
    cxLabel4: TcxLabel;
    grUnit: TcxGrid;
    grtvUnit: TcxGridDBTableView;
    colUnitId: TcxGridDBColumn;
    cxGridDBColumn1: TcxGridDBColumn;
    colUnitCodePartner: TcxGridDBColumn;
    cxGridDBColumn2: TcxGridDBColumn;
    grlUnit: TcxGridLevel;
    grOptima: TcxGrid;
    grtvOptima: TcxGridDBTableView;
    colRowData: TcxGridDBColumn;
    grlOptima: TcxGridLevel;
    dsUnit: TDataSource;
    btnOptimaExport: TButton;
    qryReport_Upload_Optima: TZQuery;
    dsReport_Upload_Optima: TDataSource;
    btnOptimaAll: TButton;
    btnOptimaSendMail: TButton;
    edtOptimaEMail: TEdit;
    qryMailParam: TZQuery;
    btnBaDMSendFTP: TButton;
    IdFTP1: TIdFTP;
    grBaDM_byU: TcxGrid;
    grtvBaDM_byU: TcxGridDBTableView;
    grlBaDM_byU: TcxGridLevel;
    qryReport_Upload_BaDM_byUnit: TZQuery;
    dsReport_Upload_BaDM_byUnit: TDataSource;
    qryBadm_byUnit: TZQuery;
    tsTeva: TTabSheet;
    Panel2: TPanel;
    btnTevaSendMail: TButton;
    edtTevaEMail: TEdit;
    btnTevaExport: TButton;
    btnTevaExecute: TButton;
    btnTevaAll: TButton;
    TevaID: TcxSpinEdit;
    cxLabel5: TcxLabel;
    TevaDate: TcxDateEdit;
    cxLabel6: TcxLabel;
    grtvTeva: TcxGridDBTableView;
    grTevaLevel1: TcxGridLevel;
    grTeva: TcxGrid;
    qryReport_Upload_Teva: TZQuery;
    qryReport_Upload_Tevaoperdate: TDateTimeField;
    qryReport_Upload_Tevaokpo: TWideStringField;
    qryReport_Upload_Tevaunitname: TWideStringField;
    qryReport_Upload_Tevaunitaddress: TWideStringField;
    qryReport_Upload_Tevagoodsname: TWideStringField;
    qryReport_Upload_Tevaamount: TFloatField;
    qryReport_Upload_Tevasumm: TFloatField;
    qryReport_Upload_Tevaprice: TFloatField;
    dsReport_Upload_Teva: TDataSource;
    grtvTevaoperdate: TcxGridDBColumn;
    grtvTevaokpo: TcxGridDBColumn;
    grtvTevaunitname: TcxGridDBColumn;
    grtvTevaunitaddress: TcxGridDBColumn;
    grtvTevagoodsname: TcxGridDBColumn;
    grtvTevaamount: TcxGridDBColumn;
    grtvTevasumm: TcxGridDBColumn;
    grtvTevaprice: TcxGridDBColumn;
    tsADV: TTabSheet;
    Panel3: TPanel;
    AVDDate: TcxDateEdit;
    cxLabel7: TcxLabel;
    btnADVExecute: TButton;
    btnADVExport: TButton;
    btnADVSend: TButton;
    grAVD: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    dsReport_Upload_ADV: TDataSource;
    qryReport_Upload_ADV: TZQuery;
    cxGridDBTableView1Column1: TcxGridDBColumn;
    cxGridDBTableView1Column2: TcxGridDBColumn;
    cxGridDBTableView1Column3: TcxGridDBColumn;
    cxGridDBTableView1Column4: TcxGridDBColumn;
    cxGridDBTableView1Column5: TcxGridDBColumn;
    cxGridDBTableView1Column6: TcxGridDBColumn;
    cxGridDBTableView1Column7: TcxGridDBColumn;
    cxGridDBTableView1Column8: TcxGridDBColumn;
    cxGridDBTableView1Column9: TcxGridDBColumn;
    cxGridDBTableView1Column10: TcxGridDBColumn;
    cxGridDBTableView1Column11: TcxGridDBColumn;
    cxGridDBTableView1Column12: TcxGridDBColumn;
    cxGridDBTableView1Column13: TcxGridDBColumn;
    cxGridDBTableView1Column14: TcxGridDBColumn;
    cxGridDBTableView1Column15: TcxGridDBColumn;
    tsYuriFarm: TTabSheet;
    grYuriFarm: TcxGrid;
    grYuriFarmDBTableView: TcxGridDBTableView;
    grYuriFarmLevel: TcxGridLevel;
    Panel4: TPanel;
    YuriFarmDate: TcxDateEdit;
    cxLabel8: TcxLabel;
    btnYuriFarmExecute: TButton;
    btnYuriFarmSend: TButton;
    dsReport_Upload_YuriFarm: TDataSource;
    qryReport_Upload_YuriFarm: TZQuery;
    grYuriFarmUnit: TcxGrid;
    grYuriFarmUnitDBTableView: TcxGridDBTableView;
    grYuriFarmUnitLevel: TcxGridLevel;
    dsReport_Upload_YuriFarm_Unit: TDataSource;
    qryReport_Upload_YuriFarm_Unit: TZQuery;
    btnYuriFarmUnitExecute: TButton;
    grYuriFarmUnit_ID: TcxGridDBColumn;
    grYuriFarmUnit_UnitName: TcxGridDBColumn;
    grYuriFarmUnit_OKPO: TcxGridDBColumn;
    grYuriFarmUnit_UnitAddress: TcxGridDBColumn;
    pmExecute: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdHTTP: TIdHTTP;
    btnYuriFarmAll: TButton;
    grYuriFarmUnit_AccessKeyYF: TcxGridDBColumn;
    grYuriFarmUnit_MorionCode: TcxGridDBColumn;
    tsMDMPfizer: TTabSheet;
    Panel5: TPanel;
    btnMDMPfizerEmail: TButton;
    btnMDMPfizerExport: TButton;
    btnMDMPfizerExecute: TButton;
    btnMDMPfizerAll: TButton;
    MDMPfizerDate: TcxDateEdit;
    cxLabel10: TcxLabel;
    grMDMPfizer: TcxGrid;
    grMDMPfizerDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    NDS: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Summa: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    SummChangePercent: TcxGridDBColumn;
    DiscountExternalName: TcxGridDBColumn;
    DiscountCardName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    MainJuridicalName: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    grMDMPfizerLevel: TcxGridLevel;
    dsReport_Upload_MDMPfizer: TDataSource;
    qryReport_Upload_MDMPfizer: TZQuery;
    tsDanhsonPharma: TTabSheet;
    Panel6: TPanel;
    btnDanhsonPharmaEmail: TButton;
    btnDanhsonPharmaExport: TButton;
    btnDanhsonPharmaExecute: TButton;
    btnDanhsonPharmaAll: TButton;
    DanhsonPharmaDate: TcxDateEdit;
    cxLabel9: TcxLabel;
    dsReport_Upload_DanhsonPharma: TDataSource;
    qryReport_Upload_DanhsonPharma: TZQuery;
    grDanhsonPharma: TcxGrid;
    grDanhsonPharmaDBTableView: TcxGridDBTableView;
    DanhsonPharmaGoodscode: TcxGridDBColumn;
    DanhsonPharmaGoodsName: TcxGridDBColumn;
    DanhsonPharmaNDS: TcxGridDBColumn;
    DanhsonPharmaPrice: TcxGridDBColumn;
    DanhsonPharmaAmount: TcxGridDBColumn;
    DanhsonPharmaSumm: TcxGridDBColumn;
    DanhsonPharmaItemName: TcxGridDBColumn;
    DanhsonPharmaMainJuridicalName: TcxGridDBColumn;
    DanhsonPharmaUnitName: TcxGridDBColumn;
    DanhsonPharmaOperDate: TcxGridDBColumn;
    DanhsonPharmaInvNumber: TcxGridDBColumn;
    DanhsonPharmaStatusName: TcxGridDBColumn;
    DanhsonPharmaFromName: TcxGridDBColumn;
    grDanhsonPharmaLevel: TcxGridLevel;
    DanhsonPharmaMedicForSaleName: TcxGridDBColumn;
    DanhsonPharmaBuyerForSaleName: TcxGridDBColumn;
    DanhsonPharmaBuyerForSalePhone: TcxGridDBColumn;
    btnDanhsonPharmaWeekExecute: TButton;
    btnDanhsonPharmaMonthExecute: TButton;
    procedure btnBaDMExecuteClick(Sender: TObject);
    procedure btnBaDMExportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnOptimaExecuteClick(Sender: TObject);
    procedure btnOptimaExportClick(Sender: TObject);
    procedure btnOptimaAllClick(Sender: TObject);
    procedure btnOptimaSendMailClick(Sender: TObject);
    procedure btnBaDMSendFTPClick(Sender: TObject);
    procedure btnTevaExecuteClick(Sender: TObject);
    procedure btnTevaExportClick(Sender: TObject);
    procedure btnTevaSendMailClick(Sender: TObject);
    procedure btnTevaAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnADVExecuteClick(Sender: TObject);
    procedure btnADVExportClick(Sender: TObject);
    procedure btnADVSendClick(Sender: TObject);
    procedure btnYuriFarmSendClick(Sender: TObject);
    procedure btnYuriFarmUnitExecuteClick(Sender: TObject);
    procedure btnYuriFarmExecuteClick(Sender: TObject);
    procedure YuriFarmExecuteClick(Sender: TObject);
    procedure btnYuriFarmAllClick(Sender: TObject);
    procedure btnMDMPfizerAllClick(Sender: TObject);
    procedure btnMDMPfizerExecuteClick(Sender: TObject);
    procedure btnMDMPfizerExportClick(Sender: TObject);
    procedure btnMDMPfizerEmailClick(Sender: TObject);
    procedure btnDanhsonPharmaExecuteClick(Sender: TObject);
    procedure btnDanhsonPharmaExportClick(Sender: TObject);
    procedure btnDanhsonPharmaEmailClick(Sender: TObject);
    procedure btnDanhsonPharmaAllClick(Sender: TObject);
    procedure btnDanhsonPharmaWeekExecuteClick(Sender: TObject);
    procedure btnDanhsonPharmaMonthExecuteClick(Sender: TObject);
  private
    { Private declarations }
    FileNameBaDM_byUnit: String;
    FileNameBaDM: String;
    SavePathBaDM: String;
    FileNameOptima: String;
    SavePathOptima: String;
    FileNameTeva: String;
    SavePathTeva: String;
    SavePathYuriFarm: String;
    IntervalCount: Integer;
    IntervalMin: Integer;  // в минутах

    glSubject: String;
    glSubjectTeva: String;

    glFTPHost,
    glFTPPath,
    glFTPUser,
    glFTPPassword: String;

    FileNameADV: String;
    SavePathADV: String;

    glFTPHostADV,
    glFTPPathADV,
    glFTPUserADV,
    glFTPPasswordADV: String;

    FURLYF: String;
    FTokenYF : string;
    FIDYF : string;
    FUnitYF : Integer;

    FYuriFarmType : Integer;

    RecipientMDMPfizer: String;
    SubjectMDMPfizer: String;
    SavePathMDMPfizer: String;
    FileNameMDMPfizer: String;

    RecipientDanhsonPharma: String;
    SubjectDanhsonPharma: String;
    SavePathDanhsonPharma: String;
    FileNameDanhsonPharma: String;

    function SendMail(const Host: String; const Port: integer; const Password,
      Username: String; const Recipients: array of String; const FromAdres,
      Subject, MessageText: String;
      const Attachments: array of String): boolean;
    procedure LInitializeISO(var VHeaderEncoding: Char; var VCharSet: string);
  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
    procedure OpenAndFormatSQL(qryReport : TZQuery; grtView : TcxGridDBTableView);
    procedure YuriFarmExecute(nType : Integer);
  end;

var
  ExportSalesForSuppForm: TExportSalesForSuppForm;

implementation

{$R *.dfm}

var XML: IXMLDocument;

procedure TExportSalesForSuppForm.Add_Log(AMessage: String);
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
    Writeln(F,FormatDateTime('YYYY.MM.DD hh:mm:ss',now)+' - '+AMessage);
  finally
    CloseFile(F);
  end;
  except
  end;
end;

function EncodeBase64(const Input: TBytes): string;
const
  Base64: array[0..63] of Char =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

  function Encode3Bytes(const Byte1, Byte2, Byte3: Byte): string;
  begin
    Result := Base64[Byte1 shr 2]
      + Base64[((Byte1 shl 4) or (Byte2 shr 4)) and $3F]
      + Base64[((Byte2 shl 2) or (Byte3 shr 6)) and $3F]
      + Base64[Byte3 and $3F];
  end;

  function EncodeLast2Bytes(const Byte1, Byte2: Byte): string;
  begin
    Result := Base64[Byte1 shr 2]
      + Base64[((Byte1 shl 4) or (Byte2 shr 4)) and $3F]
      + Base64[(Byte2 shl 2) and $3F] + '=';
  end;

  function EncodeLast1Byte(const Byte1: Byte): string;
  begin
    Result := Base64[Byte1 shr 2]
      + Base64[(Byte1 shl 4) and $3F] + '==';
  end;

var
  i, iLength: Integer;
begin
  Result := '';
  iLength := Length(Input);
  i := 0;
  while i < iLength do
  begin
    case iLength - i of
      3..MaxInt:
        Result := Result + Encode3Bytes(Input[i], Input[i+1], Input[i+2]);
      2:
        Result := Result + EncodeLast2Bytes(Input[i], Input[i+1]);
      1:
        Result := Result + EncodeLast1Byte(Input[i]);
    end;
    Inc(i, 3);
  end;
end;


procedure TExportSalesForSuppForm.OpenAndFormatSQL(qryReport : TZQuery; grtView : TcxGridDBTableView);
  var I, W : integer;
begin
  qryReport.Close;
  qryReport.DisableControls;
  try
    try
      qryReport.Open;
    except
      on E:Exception do
      begin
        Add_Log(E.Message);
        Exit;
      end;
    end;

    if qryReport.IsEmpty then
    begin
      qryReport.Close;
      Exit;
    end;

    grtView.ClearItems;

    for I := 0 to qryReport.FieldCount - 1 do with grtView.CreateColumn do
    begin
      HeaderAlignmentHorz := TAlignment.taCenter;
      Options.Editing := False;
      DataBinding.FieldName := qryReport.Fields.Fields[I].FieldName;
      if qryReport.Fields.Fields[I].DataType in [ftString, ftWideString] then
      begin
        W := 10;
        qryReport.First;
        while not qryReport.Eof do
        begin
          W := Max(W, LengTh(qryReport.Fields.Fields[I].AsString));
          if W > 70 then Break;
          qryReport.Next;
        end;
        qryReport.First;
        Width := 6 * Min(W, 70) + 2;
      end;
    end;
  finally
    qryReport.EnableControls;
  end;
end;


procedure TExportSalesForSuppForm.btnADVExecuteClick(Sender: TObject);
begin
  Add_Log('Начало Формирования отчета AVD');

  qryReport_Upload_ADV.Close;
  qryReport_Upload_ADV.Params.ParamByName('inDate').Value := AVDDate.Date;

  try
    qryReport_Upload_ADV.Open;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      Exit;
    end;
  end;

  FileNameADV := 'ADV_' + FormatDateTime('DD_MM_YYYY', AVDDate.Date) + '.csv';
end;

procedure TExportSalesForSuppForm.btnADVExportClick(Sender: TObject);
var
  sl: TStringList;
begin
  Add_Log('Начало выгрузки отчета ADV');
  if not ForceDirectories(SavePathADV) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;
  //
  // обычный отчет

  try
    try
      ExportGridToText(SavePathADV + FileNameADV, grAVD, True, True, ';', '', '', 'csv');
      sl := TStringList.Create;
      try
        sl.LoadFromFile(SavePathADV + FileNameADV);
        sl.SaveToFile(SavePathADV + FileNameADV, TEncoding.UTF8);
      finally
        sl.Free;
      end;
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

procedure TExportSalesForSuppForm.btnADVSendClick(Sender: TObject);
begin
  try
    IdFTP1.Disconnect;
    IdFTP1.Host := glFTPHostADV;
    idFTP1.Username := glFTPUserADV;
    idFTP1.Password := glFTPPasswordADV;
    try
      idFTP1.Connect;
    Except ON E: Exception DO
      Begin
        Add_Log(E.Message);
        exit;
      End;
    end;
    if glFTPPathADV <> '' then
    try
      idFTP1.ChangeDir(glFTPPathADV);
    except ON E: Exception DO
      begin
        Add_Log(E.Message);
        exit;
      end;
    end;
    try
      idFTP1.Put(SavePathADV+FileNameADV,
                 FileNameADV);
      DeleteFile(SavePathADV+FileNameADV);
    except ON E: Exception DO
      Begin
        Add_Log(E.Message);
        exit;
      End;
    end;
  finally
    idFTP1.Disconnect;
  end;
end;

procedure TExportSalesForSuppForm.btnBaDMExecuteClick(Sender: TObject);
begin
  Add_Log('Начало Формирования 2-х отчетов БаДМ');
  qryReport_Upload_BaDM.Close;
  qryReport_Upload_BaDM.Params.ParamByName('inDate').Value := BaDMDate.Date;
  qryReport_Upload_BaDM.Params.ParamByName('inObjectId').Value := BaDMID.Value;
  //
  qryBadm_byUnit.Close;
  //
  qryReport_Upload_BaDM_byUnit.Close;;
  qryReport_Upload_BaDM_byUnit.Params.ParamByName('inDate').Value := BaDMDate.Date;
  try
    qryReport_Upload_BaDM.Open;
    //
    qryBadm_byUnit.Open;
    qryReport_Upload_BaDM_byUnit.Open;
  except ON E:Exception DO
    Begin
      Add_Log(E.Message);
      Exit;
    end;
  end;
  FileNameBaDM := 'BaDM_'+FormatDateTime('DD_MM_YYYY',BaDMDate.Date)+'.csv';
  FileNameBaDM_byUnit := 'BaDMRep_'+FormatDateTime('DD_MM_YYYY',BaDMDate.Date)+'.csv';
end;

procedure TExportSalesForSuppForm.btnBaDMExportClick(Sender: TObject);
var
  sl,sll : TStringList;
  i : Integer;
begin
  Add_Log('Начало выгрузки отчета БаДМ');
  if not ForceDirectories(SavePathBaDM) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;
  //
  // обычный отчет
  grtvBaDM.OptionsView.Header := False;
  try
    try
      ExportGridToText(SavePathBaDM+FileNameBaDM,grBaDM,true,true,';','','','csv');
      sl := TStringList.Create;
      try
        sl.LoadFromFile(SavePathBaDM+FileNameBaDM);
        sl.SaveToFile(SavePathBaDM+FileNameBaDM,TEncoding.ANSI);
      finally
        sl.Free;
      end;
    except ON E: Exception DO
      Begin
        Add_Log(E.Message);
        exit;
      End;
    end;
  finally
    grtvBaDM.OptionsView.Header := True;
  end;
  //
  // отчет по "всем" аптекам
  grtvBaDM_byU.OptionsView.Header := True;
  //
  //но снача построим колонки
  qryBadm_byUnit.First;
  for i := 1 to 30 do
  begin
       if qryBadm_byUnit.FieldByName('Num_byReportBadm').AsInteger = i
       then begin
           grtvBaDM_byU.Columns[grtvBaDM_byU.GetColumnByFieldName('Amount_Sale'+IntToStr(i)).Index].Visible       :=TRUE;
           grtvBaDM_byU.Columns[grtvBaDM_byU.GetColumnByFieldName('RemainsEnd' +IntToStr(i)).Index].Visible       :=TRUE;
           //
           grtvBaDM_byU.Columns[grtvBaDM_byU.GetColumnByFieldName('Amount_Sale'+IntToStr(i)).Index].Caption       := qryBadm_byUnit.FieldByName('Name').AsString + ' Реализация (тип 4), шт';
           grtvBaDM_byU.Columns[grtvBaDM_byU.GetColumnByFieldName('RemainsEnd' +IntToStr(i)).Index].Caption       := qryBadm_byUnit.FieldByName('Name').AsString + ' Конечный остаток, шт';
       end
       else begin
           grtvBaDM_byU.Columns[grtvBaDM_byU.GetColumnByFieldName('Amount_Sale'+IntToStr(i)).Index].Visible       :=FALSE;
           grtvBaDM_byU.Columns[grtvBaDM_byU.GetColumnByFieldName('RemainsEnd' +IntToStr(i)).Index].Visible       :=FALSE;
       end;
       if not qryBadm_byUnit.EOF then qryBadm_byUnit.Next;
  end;
  //
  try
    try
      ExportGridToText(SavePathBaDM+FileNameBaDM_byUnit,grBaDM_byU,true,true,';','','','csv');
      sll := TStringList.Create;
      try
        sll.LoadFromFile(SavePathBaDM+FileNameBaDM_byUnit);
        sll.SaveToFile(SavePathBaDM+FileNameBaDM_byUnit,TEncoding.ANSI);
      finally
        sll.Free;
      end;
    except ON E: Exception DO
      Begin
        Add_Log(E.Message);
        exit;
      End;
    end;
  finally
    grtvBaDM_byU.OptionsView.Header := True;
  end;
end;

procedure TExportSalesForSuppForm.btnBaDMSendFTPClick(Sender: TObject);
begin
  try
    IdFTP1.Disconnect;
    IdFTP1.Host := glFTPHost;
    idFTP1.Username := glFTPUser;
    idFTP1.Password := glFTPPassword;
    try
      idFTP1.Connect;
    Except ON E: Exception DO
      Begin
        Add_Log(E.Message);
        exit;
      End;
    end;
    try
      idFTP1.ChangeDir(glFTPPath);
    except ON E: Exception DO
      begin
        Add_Log(E.Message);
        exit;
      end;
    end;
    try
      idFTP1.Put(SavePathBaDM+FileNameBaDM_byUnit,
                 FileNameBaDM_byUnit);
      DeleteFile(SavePathBaDM+FileNameBaDM_byUnit);

      idFTP1.Put(SavePathBaDM+FileNameBaDM,
                 FileNameBaDM);
      DeleteFile(SavePathBaDM+FileNameBaDM);

    except ON E: Exception DO
      Begin
        Add_Log(E.Message);
        exit;
      End;
    end;
  finally
    idFTP1.Disconnect;
  end;
end;

procedure TExportSalesForSuppForm.btnDanhsonPharmaAllClick(Sender: TObject);
begin
  try
    btnDanhsonPharmaExecuteClick(nil);
    Application.ProcessMessages;
    btnDanhsonPharmaExportClick(nil);
    Application.ProcessMessages;
    btnDanhsonPharmaEmailClick(nil);
    Application.ProcessMessages;
    if DayOfTheWeek(IncDay(DanhsonPharmaDate.Date)) = 1 then
    begin
      btnDanhsonPharmaWeekExecuteClick(nil);
      Application.ProcessMessages;
      btnDanhsonPharmaExportClick(nil);
      Application.ProcessMessages;
      btnDanhsonPharmaEmailClick(nil);
      Application.ProcessMessages;
    end;
    if DayOf(IncDay(DanhsonPharmaDate.Date)) = 1 then
    begin
      btnDanhsonPharmaMonthExecuteClick(nil);
      Application.ProcessMessages;
      btnDanhsonPharmaExportClick(nil);
      Application.ProcessMessages;
      btnDanhsonPharmaEmailClick(nil);
      Application.ProcessMessages;
    end;
  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;

procedure TExportSalesForSuppForm.btnDanhsonPharmaEmailClick(Sender: TObject);
var
  addr: array of string;
  S, S1: string;
begin
//  if qryReport_Upload_DanhsonPharma.IsEmpty then Exit;

  S := Trim(RecipientDanhsonPharma);

  if S[Length(S)] <> ',' then
    S := S + ',';

  while S <> '' do
  begin
    S1 := Copy(S, 1, Pos(',', S) - 1);
    Delete(S, 1, Pos(',', S));
    SetLength(addr, Length(addr) + 1);
    addr[Length(addr) - 1] := S1;
  end;

  if SendMail(qryMailParam.FieldByName('Mail_Host').AsString,
       qryMailParam.FieldByName('Mail_Port').AsInteger,
       qryMailParam.FieldByName('Mail_Password').AsString,
       qryMailParam.FieldByName('Mail_User').AsString,
       addr,
       qryMailParam.FieldByName('Mail_From').AsString,
       SubjectDanhsonPharma,
       '',
       [SavePathDanhsonPharma + FileNameDanhsonPharma]) then
  begin
    try
      DeleteFile(SavePathDanhsonPharma + FileNameDanhsonPharma);
    except
      on E: Exception do
        Add_Log(E.Message);
    end;
  end;
end;

procedure TExportSalesForSuppForm.btnDanhsonPharmaExecuteClick(Sender: TObject);
begin
  Add_Log('Начало Формирования отчета Дансон фарма');

  qryReport_Upload_DanhsonPharma.Close;
  qryReport_Upload_DanhsonPharma.Params.ParamByName('StartDate').Value := DanhsonPharmaDate.Date;
  qryReport_Upload_DanhsonPharma.Params.ParamByName('EndDate').Value := DanhsonPharmaDate.Date;

  try
    qryReport_Upload_DanhsonPharma.Open;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      Exit;
    end;
  end;

  FileNameDanhsonPharma := 'DanhsonPharma_' + FormatDateTime('DD_MM_YYYY', DanhsonPharmaDate.Date) + '.xls';
end;

procedure TExportSalesForSuppForm.btnDanhsonPharmaExportClick(Sender: TObject);
begin
//  if qryReport_Upload_DanhsonPharma.IsEmpty then Exit;

  Add_Log('Начало выгрузки отчета Дансон фарма');
  if not ForceDirectories(SavePathDanhsonPharma) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;
  try
    ExportGridToExcel(SavePathDanhsonPharma+FileNameDanhsonPharma,grDanhsonPharma);
  except ON E: Exception DO
    Begin
      Add_Log(E.Message);
      exit;
    End;
  end;
end;

procedure TExportSalesForSuppForm.btnDanhsonPharmaMonthExecuteClick(
  Sender: TObject);
begin
  Add_Log('Начало Формирования отчета Дансон фарма за месяц');

  qryReport_Upload_DanhsonPharma.Close;
  qryReport_Upload_DanhsonPharma.Params.ParamByName('StartDate').Value := StartOfTheMonth(DanhsonPharmaDate.Date);
  qryReport_Upload_DanhsonPharma.Params.ParamByName('EndDate').Value := DanhsonPharmaDate.Date;

  try
    qryReport_Upload_DanhsonPharma.Open;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      Exit;
    end;
  end;

  FileNameDanhsonPharma := 'DanhsonPharmaPeriod_' +
     FormatDateTime('DD_MM_YYYY', StartOfTheMonth(DanhsonPharmaDate.Date)) + '_' +
     FormatDateTime('DD_MM_YYYY', DanhsonPharmaDate.Date) + '.xls';

end;

procedure TExportSalesForSuppForm.btnMDMPfizerAllClick(Sender: TObject);
begin
  try
    btnMDMPfizerExecuteClick(nil);
    Application.ProcessMessages;
    btnMDMPfizerExportClick(nil);
    Application.ProcessMessages;
    btnMDMPfizerEmailClick(nil);
    Application.ProcessMessages;
  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;

procedure TExportSalesForSuppForm.btnMDMPfizerEmailClick(Sender: TObject);
var
  addr: array of string;
  S, S1: string;
begin
  if qryReport_Upload_MDMPfizer.IsEmpty then Exit;

  S := Trim(RecipientMDMPfizer);

  if S[Length(S)] <> ',' then
    S := S + ',';

  while S <> '' do
  begin
    S1 := Copy(S, 1, Pos(',', S) - 1);
    Delete(S, 1, Pos(',', S));
    SetLength(addr, Length(addr) + 1);
    addr[Length(addr) - 1] := S1;
  end;

  if SendMail(qryMailParam.FieldByName('Mail_Host').AsString,
       qryMailParam.FieldByName('Mail_Port').AsInteger,
       qryMailParam.FieldByName('Mail_Password').AsString,
       qryMailParam.FieldByName('Mail_User').AsString,
       addr,
       qryMailParam.FieldByName('Mail_From').AsString,
       SubjectMDMPfizer,
       '',
       [SavePathMDMPfizer + FileNameMDMPfizer]) then
  begin
    try
      DeleteFile(SavePathMDMPfizer + FileNameMDMPfizer);
    except
      on E: Exception do
        Add_Log(E.Message);
    end;
  end;
end;

procedure TExportSalesForSuppForm.btnMDMPfizerExecuteClick(Sender: TObject);
begin
  Add_Log('Начало Формирования отчета МДМ Пфайзер');

  qryReport_Upload_MDMPfizer.Close;
  qryReport_Upload_MDMPfizer.Params.ParamByName('StartDate').Value := MDMPfizerDate.Date;
  qryReport_Upload_MDMPfizer.Params.ParamByName('EndDate').Value := MDMPfizerDate.Date;

  try
    qryReport_Upload_MDMPfizer.Open;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      Exit;
    end;
  end;

  FileNameMDMPfizer := 'MDMPfizer_' + FormatDateTime('DD_MM_YYYY', MDMPfizerDate.Date) + '.xls';
end;

procedure TExportSalesForSuppForm.btnMDMPfizerExportClick(Sender: TObject);
begin
  if qryReport_Upload_MDMPfizer.IsEmpty then Exit;

  Add_Log('Начало выгрузки отчета МДМ Пфайзер');
  if not ForceDirectories(SavePathMDMPfizer) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;
  try
    ExportGridToExcel(SavePathMDMPfizer+FileNameMDMPfizer,grMDMPfizer);
  except ON E: Exception DO
    Begin
      Add_Log(E.Message);
      exit;
    End;
  end;
end;

procedure TExportSalesForSuppForm.btnOptimaExecuteClick(Sender: TObject);
begin
  Add_Log('Начало Формирования отчета Оптима - '+qryUnit.FieldByName('UnitName').AsString);
  qryReport_Upload_Optima.Close;
  qryReport_Upload_Optima.Params.ParamByName('inDate').Value := OptimaDate.Date;
  qryReport_Upload_Optima.Params.ParamByName('inObjectId').Value := OptimaId.Value;
  qryReport_Upload_Optima.Params.ParamByName('inUnitId').Value := qryUnit.FieldByName('UnitId').AsInteger;
  try
    qryReport_Upload_Optima.Open;
  except on E: Exception do
    Begin
      Add_Log(E.Message);
      exit;
    End;
  end;
  FileNameOptima := 'Report_'+qryUnit.FieldByName('UnitCodePartner').AsString+'_'+FormatDateTime('YYYYMMDD',OptimaDate.Date)+'.XML';
end;

procedure TExportSalesForSuppForm.btnOptimaExportClick(Sender: TObject);
var
  sl : TStringList;
begin
  Add_Log('Начало выгрузки отчета Оптима - '+qryUnit.FieldByName('UnitName').AsString);
  if not ForceDirectories(SavePathOptima) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;
  try
    ExportGridToText(SavePathOptima+FileNameOptima,grOptima,true,true,'','','','XML');
    sl := TStringList.Create;
    try
      sl.LoadFromFile(SavePathOptima+FileNameOptima);
      sl.SaveToFile(SavePathOptima+FileNameOptima,TEncoding.ANSI);
    finally
      sl.Free;
    end;
  except ON E: Exception DO
    Begin
      Add_Log(E.Message);
      exit;
    End;
  end;
end;

procedure TExportSalesForSuppForm.btnOptimaSendMailClick(Sender: TObject);
var
  addr: Array of String;
  S, S1: String;
begin
  S := edtOptimaEMail.Text;
  if S[Length(S)]<> ',' then
    S:=S+',';
  while S<>'' do
  begin
    S1:=copy(S,1,pos(',',S)-1);
    Delete(S,1, pos(',',S));
    SetLength(addr,length(Addr)+1);
    Addr[length(addr)-1] := S1;
  end;

  if SendMail(qryMailParam.FieldByName('Mail_Host').AsString,
               qryMailParam.FieldByName('Mail_Port').AsInteger,
               qryMailParam.FieldByName('Mail_Password').AsString,
               qryMailParam.FieldByName('Mail_User').AsString,
               Addr,
               qryMailParam.FieldByName('Mail_From').AsString,
               glSubject,
               '',
              [SavePathOptima+FileNameOptima]) then
  Begin
    try
      DeleteFile(SavePathOptima+FileNameOptima);
    except on E: Exception do
      Add_Log(E.Message);
    end;
  End;
end;

procedure TExportSalesForSuppForm.btnTevaAllClick(Sender: TObject);
begin
  try
    btnTevaExecuteClick(nil);
    Application.ProcessMessages;
    btnTevaExportClick(nil);
    Application.ProcessMessages;
    btnTevaSendMailClick(nil);
    Application.ProcessMessages;
  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;

procedure TExportSalesForSuppForm.btnTevaExecuteClick(Sender: TObject);
begin
  Add_Log('Начало Формирования отчета Тева');

  qryReport_Upload_Teva.Close;
  qryReport_Upload_Teva.Params.ParamByName('inDate').Value := TevaDate.Date;
  qryReport_Upload_Teva.Params.ParamByName('inObjectId').Value := TevaID.Value;

  try
    qryReport_Upload_Teva.Open;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      Exit;
    end;
  end;

  FileNameTeva := 'Teva_' + FormatDateTime('DD_MM_YYYY', TevaDate.Date) + '.csv';
end;

procedure TExportSalesForSuppForm.btnTevaExportClick(Sender: TObject);
var
  sl: TStringList;
begin
  Add_Log('Начало выгрузки отчета Тева');
  if not ForceDirectories(SavePathTeva) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;
  //
  // обычный отчет
  grtvTeva.OptionsView.Header := False;

  try
    try
      ExportGridToText(SavePathTeva + FileNameTeva, grTeva, True, True, ';', '', '', 'csv');
      sl := TStringList.Create;
      try
        sl.LoadFromFile(SavePathTeva + FileNameTeva);
        sl.SaveToFile(SavePathTeva + FileNameTeva, TEncoding.ANSI);
      finally
        sl.Free;
      end;
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        exit;
      end;
    end;
  finally
    grtvTeva.OptionsView.Header := True;
  end;
end;

procedure TExportSalesForSuppForm.btnTevaSendMailClick(Sender: TObject);
var
  addr: array of string;
  S, S1: string;
begin
  S := Trim(edtTevaEMail.Text);

  if S[Length(S)] <> ',' then
    S := S + ',';

  while S <> '' do
  begin
    S1 := Copy(S, 1, Pos(',', S) - 1);
    Delete(S, 1, Pos(',', S));
    SetLength(addr, Length(addr) + 1);
    addr[Length(addr) - 1] := S1;
  end;

  if SendMail(qryMailParam.FieldByName('Mail_Host').AsString,
       qryMailParam.FieldByName('Mail_Port').AsInteger,
       qryMailParam.FieldByName('Mail_Password').AsString,
       qryMailParam.FieldByName('Mail_User').AsString,
       addr,
       qryMailParam.FieldByName('Mail_From').AsString,
       glSubjectTeva,
       '',
       [SavePathTeva + FileNameTeva]) then
  begin
    try
      DeleteFile(SavePathTeva + FileNameTeva);
    except
      on E: Exception do
        Add_Log(E.Message);
    end;
  end;
end;

procedure TExportSalesForSuppForm.YuriFarmExecute(nType : Integer);
begin
  if not qryReport_Upload_YuriFarm_Unit.Active then Exit;
  Add_Log('Начало Формирования отчета Юрия-Фарм ' + IntToStr(nType));

  FYuriFarmType := nType;
  qryReport_Upload_YuriFarm.Close;
  case nType of
    1  : qryReport_Upload_YuriFarm.SQL.Text := 'SELECT * FROM gpReport_Upload_YuriFarm_Income (:inDate, :inUnitID, zfCalc_UserAdmin())';
    3  : qryReport_Upload_YuriFarm.SQL.Text := 'SELECT * FROM gpReport_Upload_YuriFarm_Check (:inDate, :inUnitID, zfCalc_UserAdmin())';
    51 : qryReport_Upload_YuriFarm.SQL.Text := 'SELECT * FROM gpReport_Upload_YuriFarm_Remains (:inDate, :inUnitID, zfCalc_UserAdmin())';
  end;
  qryReport_Upload_YuriFarm.Params.ParamByName('inDate').Value := YuriFarmDate.Date;
  qryReport_Upload_YuriFarm.Params.ParamByName('inUnitID').Value := qryReport_Upload_YuriFarm_Unit.FieldByName('id').AsInteger;

  OpenAndFormatSQL(qryReport_Upload_YuriFarm, grYuriFarmDBTableView);
end;

procedure TExportSalesForSuppForm.YuriFarmExecuteClick(Sender: TObject);
begin
  YuriFarmExecute(TMenuItem(Sender).Tag);
end;


function StrToXML(Q : TZQuery; F : String) : string;
begin
  Result := Q.FieldByName(F).AsString;
  Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '''', '&apos;', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll, rfIgnoreCase]);
end;

function CurrToXML(Q : TZQuery; F : String) : String;
begin
  Result := Q.FieldByName(F).AsString;
  if Result = '' then Result := '0';
  Result := StringReplace(Result, FormatSettings.DecimalSeparator, '.', [rfReplaceAll, rfIgnoreCase]);
end;

function IntToXML(Q : TZQuery; F : String) : String;
begin
  Result := Q.FieldByName(F).AsString;
  if Result = '' then Result := '0';
end;

function DateTimeToXML(D : TDateTime) : String; overload;
var
  MyTimeZoneInformation: TTimeZoneInformation;
begin
  GetTimeZoneInformation (MyTimeZoneInformation);
  Result := IntToStr(Round(D - EncodeDate(1970, 1, 1) + ((MyTimeZoneInformation.Bias) / (24 * 60))) * (24 * 3600));
end;

function DateTimeToXML(Q : TZQuery; F : String) : String; overload;
begin
  Result := DateTimeToXML(Q.FieldByName(F).AsDateTime);
end;

function DateToXML(Q : TZQuery; F : String) : String;
begin
  if Q.FieldByName(F).IsNull then Result := ''
  else Result := FormatDateTime('YYYY-MM-DD', Q.FieldByName(F).AsDateTime);
end;

procedure TExportSalesForSuppForm.btnYuriFarmAllClick(Sender: TObject);
begin
  btnYuriFarmUnitExecuteClick(Sender);
  qryReport_Upload_YuriFarm_Unit.First;
  while not qryReport_Upload_YuriFarm_Unit.Eof do
  begin
    Add_Log('Цикл отправки Юрия-Фарм по подразделению ' + qryReport_Upload_YuriFarm_Unit.FieldByName('UnitName').AsString);
    Application.ProcessMessages;
    YuriFarmExecute(1);
    Application.ProcessMessages;
    btnYuriFarmSendClick(Sender);
    Application.ProcessMessages;
    YuriFarmExecute(3);
    Application.ProcessMessages;
    btnYuriFarmSendClick(Sender);
    Application.ProcessMessages;
    YuriFarmExecute(51);
    Application.ProcessMessages;
    btnYuriFarmSendClick(Sender);
    Application.ProcessMessages;
    qryReport_Upload_YuriFarm_Unit.Next;
    Application.ProcessMessages;
  end;
end;

procedure TExportSalesForSuppForm.btnYuriFarmExecuteClick(Sender: TObject);
  var APoint : TPoint;
begin
  inherited;

  FYuriFarmType := 0;
  if qryReport_Upload_YuriFarm.Active then qryReport_Upload_YuriFarm.Close;
  if grYuriFarmDBTableView.ColumnCount > 0 then grYuriFarmDBTableView.ClearItems;

  APoint := btnYuriFarmExecute.ClientToScreen(Point(0, btnYuriFarmExecute.ClientHeight));
  pmExecute.Popup(APoint.X, APoint.Y);
end;

procedure TExportSalesForSuppForm.btnYuriFarmSendClick(Sender: TObject);
  var cFileNameYuriFarm : string; nID : Integer;
      sl : TStringList;

  procedure StartXML;
  begin
    sl.Add('<?xml version="1.0" encoding="UTF-8"?>');
    sl.Add('<pack>');
    sl.Add('    <meta type_id="' + IntToStr(FYuriFarmType) + '"' +
                    ' data_start="' + DateTimeToXML(YuriFarmDate.Date) + '"' +
                    ' data_end="' + DateTimeToXML(YuriFarmDate.Date) + '" />');
    sl.Add('    <body>');
  end;

  function GetDocName : string;
  begin
    case FYuriFarmType of
      1  : Result := 'doc'; //'d_buy';
      3  : Result := 'doc'; //'d_receipt';
      51 : Result := '';
    end;
  end;

  function GetItemName : string;
  begin
    case FYuriFarmType of
      1  : Result := 'item'; //'d_buy_item';
      3  : Result := 'item'; //'d_receipt_item';
      51 : Result := 'doc'; //'d_stock';
    end;
  end;

  procedure DocCheck;
  begin
    sl.Add('        <' +  GetDocName +
           ' id="' + qryReport_Upload_YuriFarm.FieldByName('id').AsString + '"' +
           ' id_storage="' +  qryReport_Upload_YuriFarm_Unit.FieldByName('UnitCode').AsString + '"' +
           ' name="' + StrToXML(qryReport_Upload_YuriFarm, 'InvNumber') + '"' +
           ' date="' + DateTimeToXML(qryReport_Upload_YuriFarm, 'OperDate') + '"' +
           ' owner="' + StrToXML(qryReport_Upload_YuriFarm, 'InsertName') + '"' +
           ' case_type="' + StrToXML(qryReport_Upload_YuriFarm, 'case_type') + '"' +
           ' case_name="' + StrToXML(qryReport_Upload_YuriFarm, 'InvNumberSP') + '"' +
           ' discount_card="' + StrToXML(qryReport_Upload_YuriFarm, 'DiscountCardName') + '"' +
           ' payment_type="' + StrToXML(qryReport_Upload_YuriFarm, 'PaidTypeName') + '"' +
           ' deleted="0"' +
           ' >');
  end;

  procedure DocCheckList;
  begin
    sl.Add('            <' + GetItemName +
           ' id_item="' + StrToXML(qryReport_Upload_YuriFarm, 'MovementItemId') + '"' +
           ' id_parsel="' + StrToXML(qryReport_Upload_YuriFarm, 'id_parsel') + '"' +
           ' id_drug="' + StrToXML(qryReport_Upload_YuriFarm, 'GoodsId') + '"' +
           ' id_morion="' + IntToXML(qryReport_Upload_YuriFarm, 'MorionCode') + '"' +
           ' drug_name="' + StrToXML(qryReport_Upload_YuriFarm, 'GoodsName') + '"' +
           ' drug_form=""' +
           ' drug_number="' + StrToXML(qryReport_Upload_YuriFarm, 'GoodsCode') + '"' +
           ' drug_maker="' + StrToXML(qryReport_Upload_YuriFarm, 'MakerName') + '"' +
           ' date_expire="' + DateTimeToXML(qryReport_Upload_YuriFarm, 'ExpirationDate') + '"' +
           ' series="' + StrToXML(qryReport_Upload_YuriFarm, 'PartionGoods') + '"' +
           ' vat="' + StrToXML(qryReport_Upload_YuriFarm, 'NDS') + '"' +
           ' supplier="' + StrToXML(qryReport_Upload_YuriFarm, 'Supplier') + '"' +
           ' okpo="' + StrToXML(qryReport_Upload_YuriFarm, 'OKPO') + '"' +

           ' quant_num="' + IntToStr(Trunc(qryReport_Upload_YuriFarm.FieldByName('Amount').AsCurrency * 1000)) + '"' +
           ' quant_div="' + '1000' + '"' +
           ' amount_buy="' + CurrToXML(qryReport_Upload_YuriFarm, 'SummaWithVAT') + '"' +
           ' amount_sell="' + CurrToXML(qryReport_Upload_YuriFarm, 'Summ') + '"' +
           ' amount_reparation="' + CurrToXML(qryReport_Upload_YuriFarm, 'Reparation') + '"' +
           ' amount_discount="' + CurrToXML(qryReport_Upload_YuriFarm, 'Discount') + '"' +
           ' amount_divergence="' + CurrToXML(qryReport_Upload_YuriFarm, 'Divergence') + '"' +

           ' />');
  end;

  procedure DocIncome;
  begin
    sl.Add('        <' +  GetDocName +
           ' id="' + qryReport_Upload_YuriFarm.FieldByName('id').AsString + '"' +
           ' id_storage="' +  qryReport_Upload_YuriFarm_Unit.FieldByName('UnitCode').AsString + '"' +
           ' name="' + StrToXML(qryReport_Upload_YuriFarm, 'InvNumber') + '"' +
           ' date="' + DateTimeToXML(qryReport_Upload_YuriFarm, 'OperDate') + '"' +
           ' supplier="' + StrToXML(qryReport_Upload_YuriFarm, 'Supplier') + '"' +
           ' okpo="' + StrToXML(qryReport_Upload_YuriFarm, 'OKPO') + '"' +
           ' deleted="0"' +
           ' >');
  end;

  procedure DocIncomeList;
  begin
    sl.Add('            <' + GetItemName +
           ' id_item="' + StrToXML(qryReport_Upload_YuriFarm, 'MovementItemId') + '"' +
           ' id_drug="' + StrToXML(qryReport_Upload_YuriFarm, 'GoodsId') + '"' +
           ' id_parsel="' + StrToXML(qryReport_Upload_YuriFarm, 'id_parsel') + '"' +
           ' id_morion="' + IntToXML(qryReport_Upload_YuriFarm, 'MorionCode') + '"' +
           ' drug_name="' + StrToXML(qryReport_Upload_YuriFarm, 'GoodsName') + '"' +
           ' drug_form=""' +
           ' drug_number="' + StrToXML(qryReport_Upload_YuriFarm, 'GoodsCode') + '"' +
           ' drug_maker="' + StrToXML(qryReport_Upload_YuriFarm, 'MakerName') + '"' +
           ' date_expire="' + DateTimeToXML(qryReport_Upload_YuriFarm, 'ExpirationDate') + '"' +
           ' series="' + StrToXML(qryReport_Upload_YuriFarm, 'PartionGoods') + '"' +
           ' vat="' + StrToXML(qryReport_Upload_YuriFarm, 'NDS') + '"' +
           ' quant_div="' + '1000' + '"' +
           ' quant_num="' + IntToStr(Trunc(qryReport_Upload_YuriFarm.FieldByName('Amount').AsCurrency * 1000)) + '"' +
           ' amount_buy="' + CurrToXML(qryReport_Upload_YuriFarm, 'SummaWithVAT') + '"' +

           ' />');
  end;

  procedure DocRemainsList;
  begin
    sl.Add('            <' + GetItemName +
           ' id="' + StrToXML(qryReport_Upload_YuriFarm, 'Id') + '"' +
           ' id_parsel="' + StrToXML(qryReport_Upload_YuriFarm, 'id_parsel') + '"' +
           ' id_drug="' + StrToXML(qryReport_Upload_YuriFarm, 'GoodsId') + '"' +
           ' id_morion="' + IntToXML(qryReport_Upload_YuriFarm, 'MorionCode') + '"' +
           ' drug_name="' + StrToXML(qryReport_Upload_YuriFarm, 'GoodsName') + '"' +
           ' drug_form=""' +
           ' drug_number="' + StrToXML(qryReport_Upload_YuriFarm, 'GoodsCode') + '"' +
           ' drug_maker="' + StrToXML(qryReport_Upload_YuriFarm, 'MakerName') + '"' +
           ' date_expire="' + DateTimeToXML(qryReport_Upload_YuriFarm, 'ExpirationDate') + '"' +
           ' series="' + StrToXML(qryReport_Upload_YuriFarm, 'PartionGoods') + '"' +
           ' vat="' + StrToXML(qryReport_Upload_YuriFarm, 'NDS') + '"' +
           ' supplier="' + StrToXML(qryReport_Upload_YuriFarm, 'Supplier') + '"' +
           ' okpo="' + StrToXML(qryReport_Upload_YuriFarm, 'OKPO') + '"' +

           ' quant_num="' + IntToStr(Trunc(qryReport_Upload_YuriFarm.FieldByName('Remains').AsCurrency * 1000)) + '"' +
           ' quant_div="' + '1000' + '"' +

           ' stock_start="' + DateTimeToXML(YuriFarmDate.Date) + '"' +
           ' stock_close="' + DateTimeToXML(YuriFarmDate.Date) + '"' +
           ' amount_buy="' + CurrToXML(qryReport_Upload_YuriFarm, 'SummaWithVAT') + '"' +
           ' deleted="0"' +

           ' />');
  end;

  procedure EndXML;
  begin
    if GetDocName <> '' then sl.Add('        </' + GetDocName + '>');
    sl.Add('    </body>');
    sl.Add('</pack>');
  end;

  procedure SendXML;
    var S : UnicodeString; mStream: TMemoryStream; XMLToSend: TStringList; sResponse : string;
  begin
    EndXML;

    XML.Active := False;
    XML.XML.Text := sl.Text;
    XML.Active := True;
    XML.SaveToFile(SavePathYuriFarm + cFileNameYuriFarm);
    XML.Active := False;
//    sl.SaveToFile(SavePathYuriFarm + cFileNameYuriFarm, TEncoding.UTF8);
    sl.Clear;

      // Получение токена
    if (FTokenYF = '') or (FUnitYF <> qryReport_Upload_YuriFarm_Unit.FieldByName('id').AsInteger) then
    begin
      FIDYF := '';
      FTokenYF := '';
      mStream := TMemoryStream.Create;
      try
        IdHTTP.Request.ContentType := 'application/xml';
        IdHTTP.Request.CustomHeaders.Clear;
        IdHTTP.Request.CustomHeaders.FoldLines := False;
        IdHTTP.Request.CustomHeaders.Values['AccessKey'] := qryReport_Upload_YuriFarm_Unit.FieldByName('AccessKeyYF').AsString;

        try
          IdHTTP.Get(FURLYF + '/spauth/verify', mStream);
        except   ON E: Exception DO
          Begin
            Add_Log(E.Message);
            exit;
          End;
        end;

        if IdHTTP.ResponseCode = 200 then
        begin
          XML.Active := False;
          XML.LoadFromStream(mStream);
          XML.Active := True;
          FTokenYF := XML.DocumentElement.Attributes['token'];
        end;
      finally
        mStream.Free;
      end;
    end;

      // Получение ID аптеки
    if FIDYF = '' then
    begin
      FIDYF := '';

        // Заполнение структуры для получение ID аптеки
      XMLToSend := TStringList.Create;
      try
        XMLToSend.Add('<?xml version="1.0" encoding="UTF-8"?> ');
        XMLToSend.Add('<body ' +
                      '  head="' + StrToXML(qryReport_Upload_YuriFarm_Unit, 'JuridicalName') + '" ' +
                      '  name="' + StrToXML(qryReport_Upload_YuriFarm_Unit, 'UnitName') + '" ' +
                      '  code="' + qryReport_Upload_YuriFarm_Unit.FieldByName('OKPO').AsString + '" ' +
                      '  addr="' + StrToXML(qryReport_Upload_YuriFarm_Unit, 'UnitAddress') + '" ' +
                      '  id_local="' + qryReport_Upload_YuriFarm_Unit.FieldByName('UnitCode').AsString + '" ' +
                      '  local_name="' + StrToXML(qryReport_Upload_YuriFarm_Unit, 'UnitName') + '" ' +
                      '  br_nick="' + qryReport_Upload_YuriFarm_Unit.FieldByName('MorionCode').AsString + '" ' +
                      '  access_key="' + qryReport_Upload_YuriFarm_Unit.FieldByName('AccessKeyYF').AsString + '" ' +
                      '/>');
        XMLToSend.SaveToFile(SavePathYuriFarm + 'TempXML.xml', TEncoding.UTF8);
      finally
        XMLToSend.Clear;
        XMLToSend.Free;
      end;

        // Получение ID аптеки
      try
        IdHTTP.Request.ContentType := 'application/xml';
        IdHTTP.Request.CustomHeaders.Clear;
        IdHTTP.Request.CustomHeaders.FoldLines := False;
        IdHTTP.Request.CustomHeaders.Values['Token'] := Trim(FTokenYF);

        try
           sResponse := IdHTTP.Post(FURLYF + '/admin/reg-customer', SavePathYuriFarm + 'TempXML.xml');
        except ON E: Exception DO
          Begin
            Add_Log(E.Message);
            exit;
          End;
        end;

        if IdHTTP.ResponseCode = 200 then
        begin
          XML.Active := False;
          XML.XML.Text := sResponse;
          XML.Active := True;
          FIDYF := XML.DocumentElement.Attributes['id'];
          FUnitYF := qryReport_Upload_YuriFarm_Unit.FieldByName('id').AsInteger;
        end;
      finally
        DeleteFile(SavePathYuriFarm + 'TempXML.xml');
      end;
    end;

      // Отправка данных

    try
      S := '<?xml version="1.0" encoding="UTF-8"?> <body id_entity="' + IntToStr(FYuriFarmType) + '" id_customer="' + FIDYF + '" />';

      IdHTTP.Request.ContentType := 'application/xml';
      IdHTTP.Request.CustomHeaders.Clear;
      IdHTTP.Request.CustomHeaders.FoldLines := False;
      IdHTTP.Request.CustomHeaders.Values['Token'] := Trim(FTokenYF);
      IdHTTP.Request.CustomHeaders.Values['Charset'] := 'utf-8';
      IdHTTP.Request.CustomHeaders.Values['Content-Encoding'] := '';
      IdHTTP.Request.CustomHeaders.Values['Content-Meta'] :=  EncodeBase64(BytesOf(S));

      try
         sResponse := IdHTTP.Post(FURLYF + '/api/post-docs', SavePathYuriFarm + cFileNameYuriFarm);
      except ON E: Exception DO
          Begin
            Add_Log(E.Message);
            exit;
          End;
      end;

      if IdHTTP.ResponseCode = 200 then
      begin
        DeleteFile(SavePathYuriFarm + cFileNameYuriFarm);
        Add_Log('Отчет Юрия-Фарм ' + IntToStr(FYuriFarmType) + ' отправлен');
      end;
    finally
    end;
  end;

begin

  if FYuriFarmType = 0 then Exit;

  if not qryReport_Upload_YuriFarm.Active then Exit;
  Add_Log('Начало выгрузки отчетов Юрия-Фарм ' + IntToStr(FYuriFarmType));
  if not ForceDirectories(SavePathYuriFarm) then
  Begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;

  sl := TStringList.Create;
  try
    qryReport_Upload_YuriFarm.First;
    nID := 0;
    if FYuriFarmType = 51 then
    begin
      cFileNameYuriFarm := 'YuriFarm_Stock' + '.xml';
      StartXML;
    end;
    while not qryReport_Upload_YuriFarm.Eof do
    begin

      if (FYuriFarmType <> 51) and (nID <> qryReport_Upload_YuriFarm.FieldByName('id').AsInteger) then
      begin
        if nID <> 0 then SendXML;
        nID := qryReport_Upload_YuriFarm.FieldByName('id').AsInteger;
        cFileNameYuriFarm := 'YuriFarm_' + qryReport_Upload_YuriFarm.FieldByName('id').AsString + '.xml';
        StartXML;
        case FYuriFarmType of
          1 : DocIncome;
          3 : DocCheck;
        end;
      end;

      case FYuriFarmType of
        1  : DocIncomeList;
        3  : DocCheckList;
        51 : DocRemainsList;
      end;

      qryReport_Upload_YuriFarm.Next;
    end;
    if (nID <> 0) or (FYuriFarmType = 51) then SendXML;
  finally
    sl.Free;
  end;

  FYuriFarmType := 0;
end;

procedure TExportSalesForSuppForm.btnYuriFarmUnitExecuteClick(Sender: TObject);
begin
  Add_Log('Начало Формирования отчета Юрия-Фарм аптеки');

  qryReport_Upload_YuriFarm_Unit.Close;
  qryReport_Upload_YuriFarm_Unit.Params.ParamByName('inDate').Value := YuriFarmDate.Date;

  try
    qryReport_Upload_YuriFarm_Unit.Open;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      Exit;
    end;
  end;

  if qryReport_Upload_YuriFarm_Unit.IsEmpty then qryReport_Upload_YuriFarm_Unit.Close;

end;

procedure TExportSalesForSuppForm.btnDanhsonPharmaWeekExecuteClick(Sender: TObject);
begin
  Add_Log('Начало Формирования отчета Дансон фарма зв неделю');

  qryReport_Upload_DanhsonPharma.Close;
  qryReport_Upload_DanhsonPharma.Params.ParamByName('StartDate').Value := IncDay(DanhsonPharmaDate.Date, - 6);
  qryReport_Upload_DanhsonPharma.Params.ParamByName('EndDate').Value := DanhsonPharmaDate.Date;

  try
    qryReport_Upload_DanhsonPharma.Open;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      Exit;
    end;
  end;

  FileNameDanhsonPharma := 'DanhsonPharmaPeriod_' +
     FormatDateTime('DD_MM_YYYY', IncDay(DanhsonPharmaDate.Date, - 6)) + '_' +
     FormatDateTime('DD_MM_YYYY', DanhsonPharmaDate.Date) + '.xls';
end;

procedure TExportSalesForSuppForm.btnOptimaAllClick(Sender: TObject);
var lCount: Integer;
begin
  try
    qryUnit.First;
    lCount:=0;
    while not qryUnit.Eof do
    Begin
      // если уже IntervalCount аптек отправлено
      if (lCount > 0) and ((lCount mod IntervalCount) = 0) then
      begin
        // будем ждать
        Application.ProcessMessages;
        Sleep(IntervalMin * 60000);
        Application.ProcessMessages;
      end;

      btnOptimaExecuteClick(nil);
      Application.ProcessMessages;
      btnOptimaExportClick(nil);
      Application.ProcessMessages;
      btnOptimaSendMailClick(nil);
      Application.ProcessMessages;
      // будет следующий
      qryUnit.Next;
      lCount:= lCount + 1;

    End;
  except ON E: Exception DO
    Add_Log(E.Message);
  end;



end;

procedure TExportSalesForSuppForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TExportSalesForSuppForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
  function GetCorrectNameFile(AName: String): String;
  var
    j: Integer;
  begin
    for j := 1 to length(AName) do
      if CharInSet(AName[j],[' ','\','/',':','*','?','''','"','<','>','|']) then
        AName[j] := '_';
    Result := AName;
  end;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ExportSalesForSuppliers.ini');

  try
    SavePathBaDM := Ini.readString('Options','PathBaDM',ExtractFilePath(Application.ExeName));
    if SavePathBaDM[length(SavePathBaDM)]<> '\' then
      SavePathBaDM := SavePathBaDM+'\';
    Ini.WriteString('Options','PathBaDM',SavePathBaDM);

    SavePathOptima := Ini.readString('Options','PathOptima',ExtractFilePath(Application.ExeName));
    if SavePathOptima[length(SavePathOptima)]<> '\' then
      SavePathOptima := SavePathOptima+'\';
    Ini.WriteString('Options','PathOptima',SavePathOptima);

    SavePathTeva := Trim(Ini.ReadString('Options', 'PathTeva', ExtractFilePath(Application.ExeName)));
    if SavePathTeva[Length(SavePathTeva)] <> '\' then
      SavePathTeva := SavePathTeva + '\';
    Ini.WriteString('Options', 'PathTeva', SavePathTeva);

    SavePathADV := Trim(Ini.ReadString('Options', 'PathADV', ExtractFilePath(Application.ExeName)));
    if SavePathADV[Length(SavePathADV)] <> '\' then
      SavePathADV := SavePathADV + '\';
    Ini.WriteString('Options', 'PathADV', SavePathADV);

    SavePathYuriFarm := Trim(Ini.ReadString('Options', 'PathYuriFarm', ExtractFilePath(Application.ExeName)));
    if SavePathADV[Length(SavePathYuriFarm)] <> '\' then
      SavePathYuriFarm := SavePathYuriFarm + '\';
    Ini.WriteString('Options', 'PathYuriFarm', SavePathYuriFarm);

    SavePathMDMPfizer := Trim(Ini.ReadString('Options', 'PathMDMPfizer', ExtractFilePath(Application.ExeName)));
    if SavePathMDMPfizer[Length(SavePathMDMPfizer)] <> '\' then
      SavePathMDMPfizer := SavePathMDMPfizer + '\';
    Ini.WriteString('Options', 'PathMDMPfizer', SavePathMDMPfizer);

    SavePathDanhsonPharma := Trim(Ini.ReadString('Options', 'PathDanhsonPharma', ExtractFilePath(Application.ExeName)));
    if SavePathDanhsonPharma[Length(SavePathDanhsonPharma)] <> '\' then
      SavePathDanhsonPharma := SavePathDanhsonPharma + '\';
    Ini.WriteString('Options', 'PathDanhsonPharma', SavePathDanhsonPharma);

    BaDMID.Value := Ini.ReadInteger('Options','BaDM_ID',59610);
    Ini.WriteInteger('Options','BaDM_ID',BaDMID.Value);

    OptimaID.Value := Ini.ReadInteger('Options','Optima_ID',59611);
    Ini.WriteInteger('Options','Optima_ID',OptimaID.Value);

    TevaID.Value := Ini.ReadInteger('Options', 'Teva_ID', 59610);
    Ini.WriteInteger('Options', 'Teva_ID', TevaID.Value);

    IntervalCount := Ini.ReadInteger('Options','IntervalCount',15);
    Ini.WriteInteger('Options','IntervalCount',IntervalCount);

    IntervalMin := Ini.ReadInteger('Options','IntervalMin',60);
    Ini.WriteInteger('Options','IntervalMin',IntervalMin);

    ZConnection1.Database := Ini.ReadString('Connect', 'DataBase', 'farmacy');
    Ini.WriteString('Connect', 'DataBase', ZConnection1.Database);

    ZConnection1.HostName := Ini.ReadString('Connect', 'HostName', '91.210.37.210');
    Ini.WriteString('Connect', 'HostName', ZConnection1.HostName);

    ZConnection1.User := Ini.ReadString('Connect', 'User', 'postgres');
    Ini.WriteString('Connect', 'User', ZConnection1.User);

    ZConnection1.Password := Ini.ReadString('Connect', 'Password', 'postgres');
    Ini.WriteString('Connect', 'Password', ZConnection1.Password);

    edtOptimaEMail.Text := Ini.ReadString('Mail','Recipient','sqlmail2@optimapharm.ua');
    Ini.WriteString('Mail','Recipient',edtOptimaEMail.Text);

    edtTevaEMail.Text := Ini.ReadString('Mail', 'RecipientTeva', 'teva.reports@proximaresearch.com');
    Ini.WriteString('Mail', 'RecipientTeva', edtTevaEMail.Text);

    glSubject := Ini.ReadString('Mail','Subject','Report for Optima');
    Ini.WriteString('Mail','Subject',glSubject);

    glSubjectTeva := Ini.ReadString('Mail', 'SubjectTeva', 'Report for Teva');
    Ini.WriteString('Mail', 'SubjectTeva', glSubjectTeva);

    glFTPHost := Ini.ReadString('FTP','Host','ooobadm.dp.ua');
    Ini.WriteString('FTP','Host',glFTPHost);

    glFTPPath := Ini.ReadString('FTP','Path','OD_UTZ\K_shapiro');
    Ini.WriteString('FTP','Path',glFTPPath);

    glFTPUser := Ini.ReadString('FTP','User','K_shapiro');
    Ini.WriteString('FTP','User',glFTPUser);

    glFTPPassword := Ini.ReadString('FTP','Password','FsT3469Dv');
    Ini.WriteString('FTP','Password',glFTPPassword);

    glFTPHostADV := Ini.ReadString('FTP','HostADV','zvh53.mirohost.net');
    Ini.WriteString('FTP','Host',glFTPHost);

    glFTPPathADV := Ini.ReadString('FTP','PathADV','');
    Ini.WriteString('FTP','Path',glFTPPath);

    glFTPUserADV := Ini.ReadString('FTP','UserADV','neboley');
    Ini.WriteString('FTP','User',glFTPUser);

    glFTPPasswordADV := Ini.ReadString('FTP','PasswordADV','MXps3yZWudD0');
    Ini.WriteString('FTP','Password',glFTPPassword);

    FURLYF := Ini.ReadString('HTTP','URLYF','http://test-spho.pharmbase.com.ua');
    Ini.WriteString('HTTP','URLYF',FURLYF);

    RecipientMDMPfizer := Ini.ReadString('Mail', 'RecipientMDMPfizer', '');
    Ini.WriteString('Mail', 'RecipientMDMPfizer', RecipientMDMPfizer);

    SubjectMDMPfizer := Ini.ReadString('Mail', 'SubjectMDMPfizer', '');
    Ini.WriteString('Mail', 'SubjectMDMPfizer', SubjectMDMPfizer);

    RecipientDanhsonPharma := Ini.ReadString('Mail', 'RecipientDanhsonPharma', '');
    Ini.WriteString('Mail', 'RecipientDanhsonPharma', RecipientDanhsonPharma);

    SubjectDanhsonPharma := Ini.ReadString('Mail', 'SubjectDanhsonPharma', '');
    Ini.WriteString('Mail', 'SubjectDanhsonPharma', SubjectDanhsonPharma);

  finally
    Ini.free;
  end;

  BaDMDate.Date := Date - 1;
  OptimaDate.Date := Date - 1;
  TevaDate.Date := Date - 1;
  AVDDate.Date := Date - 1;
  YuriFarmDate.Date := Date - 1;
  MDMPfizerDate.Date := Date - 1;
  DanhsonPharmaDate.Date := Date - 1;
  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection1.Connect;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      ZConnection1.Disconnect;
      Timer1.Enabled := true;
      Exit;
    end;
  end;

  if ZConnection1.Connected then
  begin
    qryUnit.Close;
    qryUnit.Params.ParamByName('inObjectId').Value := OptimaId.Value;
    qryUnit.Params.ParamByName('inSelectAll').Value := True;
    try
      qryUnit.Open;
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        ZConnection1.Disconnect;
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
        Close;
        Exit;
      end;
    end;

    if not (((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) or
      (Pos('Farmacy.exe', Application.ExeName) <> 0)) then
    begin
      btnOptimaAll.Enabled := false;
      btnOptimaExecute.Enabled := false;
      btnOptimaExport.Enabled := false;
      btnOptimaSendMail.Enabled := false;
      btnBaDMExecute.Enabled := false;
      btnBaDMExport.Enabled := false;
      btnBaDMSendFTP.Enabled := false;
      btnTevaAll.Enabled := false;
      btnTevaExecute.Enabled := false;
      btnTevaExport.Enabled := false;
      btnTevaSendMail.Enabled := false;
      OptimaDate.Enabled := False;
      OptimaId.Enabled := False;
      BaDMDate.Enabled := False;
      BaDMID.Enabled := False;
      TevaDate.Enabled := False;
      TevaID.Enabled := False;
      edtOptimaEMail.Enabled := False;
      edtTevaEMail.Enabled := False;
      grUnit.Enabled := false;
      AVDDate.Enabled := false;
      btnADVExecute.Enabled := false;
      btnADVExport.Enabled := false;
      btnADVSend.Enabled := false;
      btnYuriFarmUnitExecute.Enabled := false;
      btnYuriFarmExecute.Enabled := false;
      btnYuriFarmSend.Enabled := false;
      btnYuriFarmAll.Enabled := false;

      Timer1.Enabled := true;
    end;
  end;

  FTokenYF := '';
  FIDYF := '';
  FUnitYF := 0;
  FYuriFarmType := 0;

  FormatSettings.DecimalSeparator:=',';
  FormatSettings.DateSeparator := '.';
end;

procedure TExportSalesForSuppForm.Timer1Timer(Sender: TObject);
begin
  if not ZConnection1.Connected then
  begin
    Close;
    Exit;
  end;

  try
    timer1.Enabled := False;

//    btnOptimaAllClick(nil);

    btnBaDMExecuteClick(nil);
    btnBaDMExportClick(nil);
    btnBaDMSendFTPClick(nil);

    btnTevaAllClick(nil);

    btnYuriFarmAllClick(Nil);

//    btnMDMPfizerAllClick(Nil);

    btnDanhsonPharmaAllClick(Nil);
  finally
    Close;
  end;
end;

procedure TExportSalesForSuppForm.LInitializeISO(var VHeaderEncoding: Char; var VCharSet: string);
begin
  VHeaderEncoding:='B';
  VCharSet:='Windows-1251';
end;


function TExportSalesForSuppForm.SendMail(const Host: String; const Port: integer;
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

initialization

  XML := TXMLDocument.Create(nil);
  RegisterClass(TExportSalesForSuppForm);

end.
