unit ExportSalesForSupp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGridExportLink, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
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
  IdFTP, cxCurrencyEdit;

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
    TabSheet1: TTabSheet;
    cxGrid1: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridDBColumn3: TcxGridDBColumn;
    cxGridDBColumn4: TcxGridDBColumn;
    cxGridDBColumn5: TcxGridDBColumn;
    cxGridDBColumn6: TcxGridDBColumn;
    cxGridDBColumn7: TcxGridDBColumn;
    cxGridDBColumn8: TcxGridDBColumn;
    cxGridDBColumn9: TcxGridDBColumn;
    cxGridDBColumn10: TcxGridDBColumn;
    cxGridDBColumn11: TcxGridDBColumn;
    cxGridDBColumn12: TcxGridDBColumn;
    cxGridDBColumn13: TcxGridDBColumn;
    cxGridDBColumn14: TcxGridDBColumn;
    cxGridDBColumn15: TcxGridDBColumn;
    cxGridDBColumn16: TcxGridDBColumn;
    cxGridDBColumn17: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    Panel4: TPanel;
    YuriFarmDate: TcxDateEdit;
    cxLabel8: TcxLabel;
    btnYuriFarmExecute: TButton;
    btnYuriFarmExport: TButton;
    btnYuriFarmSend: TButton;
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
  private
    { Private declarations }
    FileNameBaDM_byUnit: String;
    FileNameBaDM: String;
    SavePathBaDM: String;
    FileNameOptima: String;
    SavePathOptima: String;
    FileNameTeva: String;
    SavePathTeva: String;
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

    function SendMail(const Host: String; const Port: integer; const Password,
      Username: String; const Recipients: array of String; const FromAdres,
      Subject, MessageText: String;
      const Attachments: array of String): boolean;
    procedure LInitializeISO(var VHeaderEncoding: Char; var VCharSet: string);
  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
  end;

var
  ExportSalesForSuppForm: TExportSalesForSuppForm;

implementation

{$R *.dfm}

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

  finally
    Ini.free;
  end;

  BaDMDate.Date := Date - 1;
  OptimaDate.Date := Date - 1;
  TevaDate.Date := Date - 1;
  AVDDate.Date := Date - 1;
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
    qryUnit.Params.ParamByName('inObjectId').Value := OptimaId.Value;
    qryUnit.Params.ParamByName('inSelectAll').Value := True;
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

      Timer1.Enabled := true;
    end;
  end;

  FormatSettings.DecimalSeparator:=',';
  FormatSettings.DateSeparator := '.';
end;

procedure TExportSalesForSuppForm.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;

//    btnOptimaAllClick(nil);

    btnBaDMExecuteClick(nil);
    btnBaDMExportClick(nil);
    btnBaDMSendFTPClick(nil);

    btnTevaAllClick(nil);
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

end.
