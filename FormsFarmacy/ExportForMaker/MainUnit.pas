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
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxDateUtils, cxNavigator, dxDateRanges, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxScrollbarAnnotations;

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
    qrySetDateSend: TZQuery;
    N3: TMenuItem;
    N4: TMenuItem;
    btnAllMaker: TButton;
    isQuarter: TcxGridDBColumn;
    is4Month: TcxGridDBColumn;
    N5: TMenuItem;
    isReport6: TcxGridDBColumn;
    N6: TMenuItem;
    isReport7: TcxGridDBColumn;
    N7: TMenuItem;
    isCurrMonth: TcxGridDBColumn;
    isUnPlanned: TcxGridDBColumn;
    StartDateUnPlanned: TcxGridDBColumn;
    EndDateUnPlanned: TcxGridDBColumn;
    qryClearUnPlanned: TZQuery;
    isQuarterAdd: TcxGridDBColumn;
    is4MonthAdd: TcxGridDBColumn;
    EditId: TEdit;
    StartDateEdit: TcxDateEdit;
    EndDateEdit: TcxDateEdit;
    isReport8: TcxGridDBColumn;
    N8: TMenuItem;
    isReportLoss: TcxGridDBColumn;
    N9: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnSendMailClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pmClick(Sender: TObject);
    procedure btnAllMakerClick(Sender: TObject);
  private
    { Private declarations }
    RepType : integer;
    DateStart : TDateTime;
    DateEnd : TDateTime;

    FormAddFile : boolean;
    DateStartAdd : TDateTime;
    DateEndAdd : TDateTime;

    FormQuarterFile : boolean;
    DateStartQuarter : TDateTime;
    DateEndQuarter : TDateTime;

    Form4MonthFile : boolean;
    DateStart4Month : TDateTime;
    DateEnd4Month : TDateTime;

    DateStartQuarterAdd : TDateTime;
    DateEndQuarterAdd : TDateTime;

    DateStart4MonthAdd : TDateTime;
    DateEnd4MonthAdd : TDateTime;

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
    procedure SetDateParams;

    procedure AllMaker;
    procedure ReportIncome(ADateStart, ADateEnd : TDateTime);
    procedure ReportCheck(ADateStart, ADateEnd : TDateTime);
    procedure ReportIncomeConsumptionBalance(ADateStart, ADateEnd : TDateTime);
    procedure ReportAnalysisRemainsSelling(ADateStart, ADateEnd : TDateTime);
    procedure ReportGoodsPartionDate;
    procedure ReportStockTimingRemainder;
    procedure ReportPayIncome(ADateStart, ADateEnd : TDateTime);
    procedure ReportRemainsDate(ADateEnd : TDateTime);
    procedure ReportLoss(ADateStart : TDateTime);

    procedure ExportAnalysisRemainsSelling;
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

procedure TMainForm.AllMaker;
begin
  try

    SetDateParams;
    FProcError := False;

    //!!!������ ��� ������� ������!!!
    if trim (EditId.Text) <> '' then
    begin
         DateStart:=StrToDate(StartDateEdit.Text);
         DateEnd:=StrToDate(EndDateEdit.Text);
    end;

    if qryMaker.FieldByName('isUnPlanned').AsBoolean then
    begin

      Add_Log('');
      Add_Log('-------------------');
      Add_Log('����������� ����� �� ����������: ' + qryMaker.FieldByName('Name').AsString);

      if qryMaker.FieldByName('isReport1').AsBoolean then
      begin
        RepType := 0;
        ReportIncome(DateStart, DateEnd);
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReport2').AsBoolean then
      begin
        RepType := 1;
        ReportCheck(DateStart, DateEnd);
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReport3').AsBoolean then
      begin
        RepType := 2;
        ReportAnalysisRemainsSelling(DateStart, DateEnd);
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReport4').AsBoolean then
      begin
        RepType := 3;
        ReportIncomeConsumptionBalance(DateStart, DateEnd);
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReport7').AsBoolean then
      begin
        RepType := 6;
        ReportPayIncome(DateStart, DateEnd);
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReport8').AsBoolean then
      begin
        RepType := 7;
        ReportRemainsDate(IncDay(Date, -1));
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReportLoss').AsBoolean then
      begin
        RepType := 8;
        ReportLoss(DateStart);
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if not FProcError then
      begin
        try
          qryClearUnPlanned.Params.ParamByName('inMaker').Value := qryMaker.FieldByName('Id').AsInteger;
          qryClearUnPlanned.ExecSQL;
        except
          on E: Exception do
          begin
            Add_Log(E.Message);
          end;
        end;
      end;
    end else

    if qryMaker.FieldByName('isQuarterAdd').AsBoolean then
    begin
      Add_Log('');
      Add_Log('-------------------');
      Add_Log('�������������� ����� �� ���������� �� �������: ' + qryMaker.FieldByName('Name').AsString);

        if qryMaker.FieldByName('isReport1').AsBoolean then
        begin
          RepType := 0;
          ReportIncome(DateStartQuarterAdd, DateEndQuarterAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport2').AsBoolean then
        begin
          RepType := 1;
          ReportCheck(DateStartQuarterAdd, DateEndQuarterAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport3').AsBoolean then
        begin
          RepType := 2;
          ReportAnalysisRemainsSelling(DateStartQuarterAdd, DateEndQuarterAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport4').AsBoolean then
        begin
          RepType := 3;
          ReportIncomeConsumptionBalance(DateStartQuarterAdd, DateEndQuarterAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport7').AsBoolean then
        begin
          RepType := 6;
          ReportPayIncome(DateStartQuarterAdd, DateEndQuarterAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;
    end else if qryMaker.FieldByName('is4MonthAdd').AsBoolean then
    begin
      Add_Log('');
      Add_Log('-------------------');
      Add_Log('�������������� ����� �� ���������� �� 4 ������: ' + qryMaker.FieldByName('Name').AsString);

        if qryMaker.FieldByName('isReport1').AsBoolean then
        begin
          RepType := 0;
          ReportIncome(DateStart4MonthAdd, DateEnd4MonthAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport2').AsBoolean then
        begin
          RepType := 1;
          ReportCheck(DateStart4MonthAdd, DateEnd4MonthAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport3').AsBoolean then
        begin
          RepType := 2;
          ReportAnalysisRemainsSelling(DateStart4MonthAdd, DateEnd4MonthAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport4').AsBoolean then
        begin
          RepType := 3;
          ReportIncomeConsumptionBalance(DateStart4MonthAdd, DateEnd4MonthAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport7').AsBoolean then
        begin
          RepType := 6;
          ReportPayIncome(DateStart4MonthAdd, DateEnd4MonthAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;
    end else
    begin

      Add_Log('');
      Add_Log('-------------------');
      Add_Log('���������: ' + qryMaker.FieldByName('Name').AsString);

      if qryMaker.FieldByName('isReport1').AsBoolean then
      begin
        RepType := 0;
        ReportIncome(DateStart, DateEnd);
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReport2').AsBoolean then
      begin
        RepType := 1;
        ReportCheck(DateStart, DateEnd);
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReport3').AsBoolean then
      begin
        RepType := 2;
        ReportAnalysisRemainsSelling(DateStart, DateEnd);
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReport4').AsBoolean then
      begin
        RepType := 3;
        ReportIncomeConsumptionBalance(DateStart, DateEnd);
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReport5').AsBoolean then
      begin
        RepType := 4;
        ReportGoodsPartionDate;
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReport6').AsBoolean then
      begin
        RepType := 5;
        ReportStockTimingRemainder;
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReport7').AsBoolean then
      begin
        RepType := 6;
        ReportPayIncome(DateStart, DateEnd);
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReport8').AsBoolean then
      begin
        RepType := 7;
        ReportPayIncome(DateStart, DateEnd);
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if qryMaker.FieldByName('isReportLoss').AsBoolean then
      begin
        RepType := 8;
        ReportLoss(DateStart);
        btnExportClick(Nil);
        btnSendMailClick(Nil);
      end;

      if FormAddFile then
      begin
        if qryMaker.FieldByName('isReport1').AsBoolean then
        begin
          RepType := 0;
          ReportIncome(DateStartAdd, DateEndAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport2').AsBoolean then
        begin
          RepType := 1;
          ReportCheck(DateStartAdd, DateEndAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport3').AsBoolean then
        begin
          RepType := 2;
          ReportAnalysisRemainsSelling(DateStartAdd, DateEndAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport4').AsBoolean then
        begin
          RepType := 3;
          ReportIncomeConsumptionBalance(DateStartAdd, DateEndAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport7').AsBoolean then
        begin
          RepType := 6;
          ReportPayIncome(DateStartAdd, DateEndAdd);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;
      end;

        // ����������� ������
      if FormQuarterFile then
      begin
        if qryMaker.FieldByName('isReport1').AsBoolean then
        begin
          RepType := 0;
          ReportIncome(DateStartQuarter, DateEndQuarter);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport2').AsBoolean then
        begin
          RepType := 1;
          ReportCheck(DateStartQuarter, DateEndQuarter);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport3').AsBoolean then
        begin
          RepType := 2;
          ReportAnalysisRemainsSelling(DateStartQuarter, DateEndQuarter);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport4').AsBoolean then
        begin
          RepType := 3;
          ReportIncomeConsumptionBalance(DateStartQuarter, DateEndQuarter);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport7').AsBoolean then
        begin
          RepType := 6;
          ReportPayIncome(DateStartQuarter, DateEndQuarter);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;
      end;

        // ������������� ������ �� 4 ������
      if Form4MonthFile then
      begin
        if qryMaker.FieldByName('isReport1').AsBoolean then
        begin
          RepType := 0;
          ReportIncome(DateStart4Month, DateEnd4Month);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport2').AsBoolean then
        begin
          RepType := 1;
          ReportCheck(DateStart4Month, DateEnd4Month);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport3').AsBoolean then
        begin
          RepType := 2;
          ReportAnalysisRemainsSelling(DateStart4Month, DateEnd4Month);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport4').AsBoolean then
        begin
          RepType := 3;
          ReportIncomeConsumptionBalance(DateStart4Month, DateEnd4Month);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;

        if qryMaker.FieldByName('isReport7').AsBoolean then
        begin
          RepType := 6;
          ReportPayIncome(DateStart4Month, DateEnd4Month);
          btnExportClick(Nil);
          btnSendMailClick(Nil);
        end;
      end;

      if not FProcError then
      begin
        try
          qrySetDateSend.Params.ParamByName('inMaker').Value := qryMaker.FieldByName('Id').AsInteger;
          qrySetDateSend.Params.ParamByName('inAddMonth').Value :=  qryMaker.FieldByName('AmountMonthSend').AsInteger;
          qrySetDateSend.Params.ParamByName('inAddDay').Value :=  qryMaker.FieldByName('AmountDaySend').AsInteger;
          qrySetDateSend.Params.ParamByName('inisCurrMonth').Value :=  qryMaker.FieldByName('isCurrMonth').AsBoolean;
          qrySetDateSend.ExecSQL;
        except
          on E: Exception do
          begin
            Add_Log(E.Message);
          end;
        end;
      end;
    end;

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;


procedure TMainForm.btnAllClick(Sender: TObject);
begin
  try
    qryMaker.First;
    while not qryMaker.Eof do
    begin

      AllMaker;

      qryMaker.Next;
      Application.ProcessMessages;
    end;
  except
    on E: Exception do
      Add_Log(E.Message);
  end;

  qryMaker.Close;
  qryMaker.Open;
end;

procedure TMainForm.btnAllMakerClick(Sender: TObject);
begin
  AllMaker;
  qryMaker.Close;
  qryMaker.Open;
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

      if (DataBinding.FieldName = '���� ���') or (DataBinding.FieldName = '����� ���') then
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

procedure TMainForm.ReportIncome(ADateStart, ADateEnd : TDateTime);
begin
  Add_Log('������ ������������ ������ �� �������� �� ������ � ' +
                                          FormatDateTime('dd.mm.yyyy', ADateStart) + ' �� ' +
                                          FormatDateTime('dd.mm.yyyy', ADateEnd));
  FileName := '����� �� ��������';
  Subject := FileName + ' �� ������ � ' + FormatDateTime('dd.mm.yyyy', ADateStart) + ' �� ' +
                                          FormatDateTime('dd.mm.yyyy', ADateEnd);

  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvMaker.ColumnCount > 0 then grtvMaker.ClearItems;
  if grtvMaker.DataController.Summary.FooterSummaryItems.Count > 0 then
    grtvMaker.DataController.Summary.FooterSummaryItems.Clear;
  qryReport_Upload.SQL.Text :=
    'select '#13#10 +
    '  Code AS "���", '#13#10 +
    '  Name AS "��������", '#13#10 +
    '  MorionCode AS "��� �������", '#13#10 +
    '  NDS AS "���", '#13#10 +
    '  PriceWithVAT AS "���� ������� � ���", '#13#10 +
    '  Price AS "���� ������� (��� ���)", '#13#10 +
    '  PriceSIP AS "���� ���", '#13#10 +
    '  Amount AS "����� ���-��", '#13#10 +
    '  SummSIP AS "����� ���", '#13#10 +
    '  StatusName AS "������", '#13#10 +
    '  ItemName AS "��� ���������", '#13#10 +
    '  UnitName AS "�������������", '#13#10 +
    '  OperDate AS "����", '#13#10 +
    '  InvNumber AS "� ���������", '#13#10 +
    '  JuridicalName AS "���������", '#13#10 +
    '  RetailName AS "�������� ����", '#13#10 +
    '  MainJuridicalName AS "���� ��. ����" '#13#10 +
    'from gpReport_MovementIncome_Promo(:inMaker, :inStartDate, :inEndDate, ''3'') '#13#10 +
    'where isSendMaker = True and MainJuridicalId not in (2141104, 3031071, 5603546, 377601, 5778621, 5062813)' +
    '  AND UnitID not in (SELECT Object_Unit_View.Id FROM Object_Unit_View WHERE COALESCE (Object_Unit_View.ParentId, 0) = 0)';

  qryReport_Upload.Params.ParamByName('inMaker').Value := qryMaker.FieldByName('Id').AsInteger;
  qryReport_Upload.Params.ParamByName('inStartDate').Value := ADateStart;
  qryReport_Upload.Params.ParamByName('inEndDate').Value := ADateEnd;

  OpenAndFormatSQL;

  if grtvMaker.ColumnCount = 0 then Exit;

  with TcxGridDBTableSummaryItem(grtvMaker.DataController.Summary.FooterSummaryItems.Add) do
  begin
    Column := grtvMaker.Columns[7];
    Format := '0.###';
    Kind := skSum;
  end;
  with TcxGridDBTableSummaryItem(grtvMaker.DataController.Summary.FooterSummaryItems.Add) do
  begin
    Column := grtvMaker.Columns[8];
    Format := '0.###';
    Kind := skSum;
  end;
end;

procedure TMainForm.ReportCheck(ADateStart, ADateEnd : TDateTime);
begin
  Add_Log('������ ������������ ������ �� �������� � ' +
                                          FormatDateTime('dd.mm.yyyy', ADateStart) + ' �� ' +
                                          FormatDateTime('dd.mm.yyyy', ADateEnd));
  FileName := '����� �� ��������';
  Subject := FileName + ' �� ������ � ' + FormatDateTime('dd.mm.yyyy', ADateStart) + ' �� ' +
                                          FormatDateTime('dd.mm.yyyy', ADateEnd);

  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvMaker.ColumnCount > 0 then grtvMaker.ClearItems;
  if grtvMaker.DataController.Summary.FooterSummaryItems.Count > 0 then
    grtvMaker.DataController.Summary.FooterSummaryItems.Clear;
  qryReport_Upload.SQL.Text :=
    'select '#13#10 +
    '  Code AS "���", '#13#10 +
    '  Name AS "��������", '#13#10 +
    '  NDS  AS "���", '#13#10 +
    '  PriceWithVAT AS "���� ������� � ���", '#13#10 +
    '  TotalAmount AS "����� ���-��", '#13#10 +
    '  SummaWithVAT AS "�����, � ����� ������� � ���", '#13#10 +
    '  PriceSale AS "���� ���������� � ���", '#13#10 +
    '  PriceSIP AS "���� ���", '#13#10 +
    '  SummSIP AS "����� ���", '#13#10 +
    '  StatusName AS "������", '#13#10 +
    '  ItemName AS "��� ���������", '#13#10 +
    '  MainJuridicalName AS "���� ��. ����", '#13#10 +
    '  UnitName AS "�������������", '#13#10 +
    '  OperDate AS "����", '#13#10 +
    '  InvNumber AS "� ���������", '#13#10 +
    '  JuridicalName AS "���������" '#13#10 +
    'from gpReport_MovementCheck_Promo(:inMaker, :inStartDate, :inEndDate, ''3'')'#13#10 +
    'where isSendMaker = True and MainJuridicalId not in (2141104, 3031071, 5603546, 377601, 5778621, 5062813)' +
    '  AND UnitID not in (SELECT Object_Unit_View.Id FROM Object_Unit_View WHERE COALESCE (Object_Unit_View.ParentId, 0) = 0)';

  qryReport_Upload.Params.ParamByName('inMaker').Value := qryMaker.FieldByName('Id').AsInteger;
  qryReport_Upload.Params.ParamByName('inStartDate').Value := ADateStart;
  qryReport_Upload.Params.ParamByName('inEndDate').Value := ADateEnd;

  OpenAndFormatSQL;

  if grtvMaker.ColumnCount = 0 then Exit;

  with TcxGridDBTableSummaryItem(grtvMaker.DataController.Summary.FooterSummaryItems.Add) do
  begin
    Column := grtvMaker.Columns[4];
    Format := '0.###';
    Kind := skSum;
  end;
  with TcxGridDBTableSummaryItem(grtvMaker.DataController.Summary.FooterSummaryItems.Add) do
  begin
    Column := grtvMaker.Columns[5];
    Format := '0.###';
    Kind := skSum;
  end;
  with TcxGridDBTableSummaryItem(grtvMaker.DataController.Summary.FooterSummaryItems.Add) do
  begin
    Column := grtvMaker.Columns[7];
    Format := '0.###';
    Kind := skSum;
  end;

end;

procedure TMainForm.ReportAnalysisRemainsSelling(ADateStart, ADateEnd : TDateTime);
  var I : integer;
begin
  Add_Log('������ ������������ ������ ���������� �� ������ � �������� �� ����� ������� � ' +
                                          FormatDateTime('dd.mm.yyyy', ADateStart) + ' �� ' +
                                          FormatDateTime('dd.mm.yyyy', ADateEnd));
  FileName := '����� ���������� �� ������ � �������� �� ����� �������';
  Subject := FileName + ' �� ������ � ' + FormatDateTime('dd.mm.yyyy', ADateStart) + ' �� ' +
                                          FormatDateTime('dd.mm.yyyy', ADateEnd);

  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvMaker.ColumnCount > 0 then grtvMaker.ClearItems;
  if grtvMaker.DataController.Summary.FooterSummaryItems.Count > 0 then
    grtvMaker.DataController.Summary.FooterSummaryItems.Clear;
  qryReport_Upload.SQL.Text :=
    'select * '#13#10 +
    'from gpSelect_Export_AnalysisRemainsSelling (:inStartDate, :inEndDate, :inMaker, ''3'')';

  qryReport_Upload.Params.ParamByName('inMaker').Value := qryMaker.FieldByName('Id').AsInteger;
  qryReport_Upload.Params.ParamByName('inStartDate').Value := ADateStart;
  qryReport_Upload.Params.ParamByName('inEndDate').Value := ADateEnd;

  OpenAndFormatSQL;
end;

procedure TMainForm.ReportGoodsPartionDate;
begin
  Add_Log('������ ������������ ����� �� ������');
  FileName := '����� �� ������';
  Subject := FileName;

  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvMaker.ColumnCount > 0 then grtvMaker.ClearItems;
  if grtvMaker.DataController.Summary.FooterSummaryItems.Count > 0 then
    grtvMaker.DataController.Summary.FooterSummaryItems.Clear;
  qryReport_Upload.SQL.Text :=
    'select '#13#10 +
    '  GoodsCode AS "���", '#13#10 +
    '  GoodsName AS "��������", '#13#10 +
    '  UnitName AS "�������������", '#13#10 +
    '  PartionDateKindName AS "��� �����", '#13#10 +
    '  Remains AS "�������", '#13#10 +
    '  ExpirationDate AS "���� ��������", '#13#10 +
    '  DayOverdue AS "���� �� ���������"  '#13#10 +
    'from gpSelect_GoodsPartionDatePromo(0, :inMaker, ''3'') '#13#10 +
    'where MainJuridicalId not in (2141104, 3031071, 5603546, 377601, 5778621, 5062813)' +
    '  AND UnitID not in (SELECT Object_Unit_View.Id FROM Object_Unit_View WHERE COALESCE (Object_Unit_View.ParentId, 0) = 0)';

  qryReport_Upload.Params.ParamByName('inMaker').Value := qryMaker.FieldByName('Id').AsInteger;

  OpenAndFormatSQL;

  if grtvMaker.ColumnCount = 0 then Exit;

  with TcxGridDBTableSummaryItem(grtvMaker.DataController.Summary.FooterSummaryItems.Add) do
  begin
    Column := grtvMaker.Columns[4];
    Format := '0.###';
    Kind := skSum;
  end;
end;

procedure TMainForm.ReportStockTimingRemainder;
  var I : integer;
begin
  Add_Log('������ ������������ ������ �������� ���� ��������');
  FileName := '�������� ���� ��������';
  Subject := FileName;

  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvMaker.ColumnCount > 0 then grtvMaker.ClearItems;
  if grtvMaker.DataController.Summary.FooterSummaryItems.Count > 0 then
    grtvMaker.DataController.Summary.FooterSummaryItems.Clear;
  qryReport_Upload.SQL.Text :=
    'select '#13#10 +
    '  UnitName AS "�������������", '#13#10 +
    '  GoodsCode AS "���", '#13#10 +
    '  GoodsName AS "��������", '#13#10 +
    '  Price AS "���� � ���", '#13#10 +
    '  Sum(Amount) AS "������� ����������", '#13#10 +
    '  Sum(Summa) AS "������� �����", '#13#10 +
//    '  AmountComplete AS "���������� ����������", '#13#10 +
//    '  SummaComplete AS "���������� �����", '#13#10 +
//    '  Amount AS "������� ����������", '#13#10 +
//    '  Summa AS "������� �����", '#13#10 +
    '  ExpirationDate AS "���� �������� �������" '#13#10 +
    'from gpReport_StockTiming_Remainder(CURRENT_DATE, 0, :inMaker, ''3'') '#13#10 +
    'GROUP BY UnitName, GoodsCode, GoodsName, Price, ExpirationDate '#13#10 +
    'HAVING Sum(Amount) > 0';

  qryReport_Upload.Params.ParamByName('inMaker').Value := qryMaker.FieldByName('Id').AsInteger;

  OpenAndFormatSQL;

  if grtvMaker.ColumnCount = 0 then Exit;

  for I := 4 to 5 do
  with TcxGridDBTableSummaryItem(grtvMaker.DataController.Summary.FooterSummaryItems.Add) do
  begin
    Column := grtvMaker.Columns[I];
    Format := '0.###';
    Kind := skSum;
  end;
end;

procedure TMainForm.ReportPayIncome(ADateStart, ADateEnd : TDateTime);
  var I : integer;
begin
  Add_Log('������ ������������ ������ ������ �������� � ' +
                                          FormatDateTime('dd.mm.yyyy', ADateStart) + ' �� ' +
                                          FormatDateTime('dd.mm.yyyy', ADateEnd));
  FileName := '����� ������ ��������';
  Subject := FileName + ' �� ������ � ' + FormatDateTime('dd.mm.yyyy', ADateStart) + ' �� ' +
                                          FormatDateTime('dd.mm.yyyy', ADateEnd);

  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvMaker.ColumnCount > 0 then grtvMaker.ClearItems;
  if grtvMaker.DataController.Summary.FooterSummaryItems.Count > 0 then
    grtvMaker.DataController.Summary.FooterSummaryItems.Clear;
  qryReport_Upload.SQL.Text :=
    'select '#13#10 +
    '  MainJuridicalName AS "���� ��. ����", '#13#10 +
    '  UnitName AS "�������������", '#13#10 +
    '  OperDate AS "����", '#13#10 +
    '  InvNumber AS "� ���������", '#13#10 +
    '  JuridicalName AS "���������", '#13#10 +
    '  TotalSumm AS "����� ������� � ���", '#13#10 +
    '  OperDatePay AS "���� ������", '#13#10 +
    '  SummaNoPay AS "�������� �� ���� ������", '#13#10 +
    '  SummaPay AS "����� ������", '#13#10 +
    '  SummaRemainder AS "����� �������" '#13#10 +
    'from gpReport_Movement_PayIncome(:inStartDate, :inEndDate, :inMaker, ''3'')'#13#10 +
    'where UnitID not in (SELECT Object_Unit_View.Id FROM Object_Unit_View WHERE COALESCE (Object_Unit_View.ParentId, 0) = 0)';

  qryReport_Upload.Params.ParamByName('inStartDate').Value := ADateStart;
  qryReport_Upload.Params.ParamByName('inEndDate').Value := ADateEnd;
  qryReport_Upload.Params.ParamByName('inMaker').Value := qryMaker.FieldByName('Id').AsInteger;

  OpenAndFormatSQL;

  if grtvMaker.ColumnCount = 0 then Exit;

  with TcxGridDBTableSummaryItem(grtvMaker.DataController.Summary.FooterSummaryItems.Add) do
  begin
    Column := grtvMaker.Columns[8];
    Format := '0.##';
    Kind := skSum;
  end;
end;

procedure TMainForm.ReportRemainsDate(ADateEnd : TDateTime);
  var I : integer;
begin
  Add_Log('������ ������������ ������ ������� �� ����������� �� ' +
                                          FormatDateTime('dd.mm.yyyy', IncDay(ADateEnd)));
  FileName := '����� ������� �� �����������';
  Subject := FileName + ' �� ' + FormatDateTime('dd.mm.yyyy', IncDay(ADateEnd));

  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvMaker.ColumnCount > 0 then grtvMaker.ClearItems;
  if grtvMaker.DataController.Summary.FooterSummaryItems.Count > 0 then
    grtvMaker.DataController.Summary.FooterSummaryItems.Clear;
  qryReport_Upload.SQL.Text :=
    'select '#13#10 +
    '  GoodsName AS "�������� ������", '#13#10 +
    '  OKPO AS "���� ������", '#13#10 +
    '  UnitName AS "������", '#13#10 +
    '  FromName AS "���������", '#13#10 +
    '  OperDate AS "���� �������", '#13#10 +
    '  Remains AS "������� ����������" '#13#10 +
    'from gpReport_RemainsDateMaker(:inOperDate, :inMaker, ''3'')';

  qryReport_Upload.Params.ParamByName('inOperDate').Value := IncDay(ADateEnd);
  qryReport_Upload.Params.ParamByName('inMaker').Value := qryMaker.FieldByName('Id').AsInteger;

  OpenAndFormatSQL;

  if grtvMaker.ColumnCount = 0 then Exit;

  with TcxGridDBTableSummaryItem(grtvMaker.DataController.Summary.FooterSummaryItems.Add) do
  begin
    Column := grtvMaker.Columns[5];
    Format := '0.####';
    Kind := skSum;
  end;
end;

procedure TMainForm.ReportLoss(ADateStart : TDateTime);
begin
  Add_Log('������ ������������ ����� �� ��������� �������');
  FileName := '����� ��������� ������';
  Subject := FileName;

  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvMaker.ColumnCount > 0 then grtvMaker.ClearItems;
  if grtvMaker.DataController.Summary.FooterSummaryItems.Count > 0 then
    grtvMaker.DataController.Summary.FooterSummaryItems.Clear;
  qryReport_Upload.SQL.Text :=
    'select '#13#10 +
    '  GoodsCode AS "���", '#13#10 +
    '  GoodsName AS "��������", '#13#10 +
    '  UnitName AS "�������������", '#13#10 +
    '  Amount AS "�������", '#13#10 +
    '  ExpirationDate AS "���� ��������" '#13#10 +
    'from gpReport_Loss_DateMarketing(:inOperDate, :inMaker, ''3'')';

  qryReport_Upload.Params.ParamByName('inOperDate').Value := IncDay(ADateStart);
  qryReport_Upload.Params.ParamByName('inMaker').Value := qryMaker.FieldByName('Id').AsInteger;

  OpenAndFormatSQL;

  if grtvMaker.ColumnCount = 0 then Exit;

  with TcxGridDBTableSummaryItem(grtvMaker.DataController.Summary.FooterSummaryItems.Add) do
  begin
    Column := grtvMaker.Columns[3];
    Format := '0.###';
    Kind := skSum;
  end;
end;

procedure TMainForm.ReportIncomeConsumptionBalance(ADateStart, ADateEnd : TDateTime);
  var I : integer;
begin
  Add_Log('������ ������������ ������ ������ ������ ������� � ' +
                                          FormatDateTime('dd.mm.yyyy', ADateStart) + ' �� ' +
                                          FormatDateTime('dd.mm.yyyy', ADateEnd));
  FileName := '����� ������ ������ �������';
  Subject := FileName + ' �� ������ � ' + FormatDateTime('dd.mm.yyyy', ADateStart) + ' �� ' +
                                          FormatDateTime('dd.mm.yyyy', ADateEnd);

  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvMaker.ColumnCount > 0 then grtvMaker.ClearItems;
  if grtvMaker.DataController.Summary.FooterSummaryItems.Count > 0 then
    grtvMaker.DataController.Summary.FooterSummaryItems.Clear;
  qryReport_Upload.SQL.Text :=
    'select '#13#10 +
    '  ParentName AS "�����������", '#13#10 +
    '  UnitName AS "������", '#13#10 +
    '  GoodsId AS "���", '#13#10 +
    '  GoodsName AS "������������ �����������", '#13#10 +
    '  AmountIncome AS "������ ����������, ��", '#13#10 +
    '  AmountIncomeSumWith AS "������ ����� ��� ���, ���", '#13#10 +
    '  AmountCheck AS "���������� ����������, ��", '#13#10 +
    '  AmountCheckSumJuridical AS "���������� ����� ������� � ���, ���", '#13#10 +
    '  SaldoOut AS "������� ����������, ��", '#13#10 +
    '  SummaOut AS "������� ����� � ���, ���" '#13#10 +
    'from gpSelect_Export_IncomeConsumptionBalance (:inStartDate, :inEndDate, :inMaker, ''3'')';

  qryReport_Upload.Params.ParamByName('inMaker').Value := qryMaker.FieldByName('Id').AsInteger;
  qryReport_Upload.Params.ParamByName('inStartDate').Value := ADateStart;
  qryReport_Upload.Params.ParamByName('inEndDate').Value := ADateEnd;

  OpenAndFormatSQL;

  if grtvMaker.ColumnCount = 0 then Exit;

  for I := 4 to 9 do
    with TcxGridDBTableSummaryItem(grtvMaker.DataController.Summary.FooterSummaryItems.Add) do
    begin
      Column := grtvMaker.Columns[I];
      Format := '0.###';
      Kind := skSum;
    end;
end;

procedure TMainForm.SetDateParams;
begin
  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvMaker.ColumnCount > 0 then grtvMaker.ClearItems;
  if grtvMaker.DataController.Summary.FooterSummaryItems.Count > 0 then
    grtvMaker.DataController.Summary.FooterSummaryItems.Clear;

  FormAddFile := False; FormQuarterFile := False; Form4MonthFile := False;

  if qryMaker.FieldByName('isUnPlanned').AsBoolean then
  begin
    DateStart := qryMaker.FieldByName('StartDateUnPlanned').AsDateTime;
    DateEnd := qryMaker.FieldByName('EndDateUnPlanned').AsDateTime;
  end else
  begin
    if qryMaker.FieldByName('AmountDaySend').AsInteger <> 0 then
    begin
       if qryMaker.FieldByName('AmountDaySend').AsInteger = 14 then
       begin
         if DayOf(qryMaker.FieldByName('SendPlan').AsDateTime) < 15 then
         begin
           DateEnd := IncDay(StartOfTheMonth(qryMaker.FieldByName('SendPlan').AsDateTime), -1);
           DateStart := IncDay(StartOfTheMonth(DateEnd), 14);

           FormAddFile := True;
           DateEndAdd := DateEnd;
           DateStartAdd := StartOfTheMonth(DateEndAdd);
         end else
         begin
           DateStart := StartOfTheMonth(qryMaker.FieldByName('SendPlan').AsDateTime);
           DateEnd := IncDay(DateStart, 13);
         end;
       end else if qryMaker.FieldByName('AmountDaySend').AsInteger = 15 then
       begin
         if DayOf(qryMaker.FieldByName('SendPlan').AsDateTime) < 16 then
         begin
           DateEnd := IncDay(StartOfTheMonth(qryMaker.FieldByName('SendPlan').AsDateTime), -1);
           DateStart := IncDay(StartOfTheMonth(DateEnd), 15);

           FormAddFile := True;
           DateEndAdd := DateEnd;
           DateStartAdd := StartOfTheMonth(DateEndAdd);
         end else
         begin
           DateStart := StartOfTheMonth(qryMaker.FieldByName('SendPlan').AsDateTime);
           DateEnd := IncDay(DateStart, 14);
         end;
       end else
       begin
         DateEnd := IncDay(StartOfTheDay(qryMaker.FieldByName('SendPlan').AsDateTime), -1);
         DateStart := IncDay(DateEnd, 1 - qryMaker.FieldByName('AmountDaySend').AsInteger);
       end;
    end else
    begin
      if qryMaker.FieldByName('isCurrMonth').AsBoolean then
      begin
        DateEnd := IncDay(Date, -1);
        DateStart := StartOfTheMonth(DateEnd);
      end else
      begin
        DateEnd := IncDay(StartOfTheMonth(qryMaker.FieldByName('SendPlan').AsDateTime), -1);
        DateStart := StartOfTheMonth(DateEnd);
        if qryMaker.FieldByName('AmountMonthSend').AsInteger > 1 then
          DateStart := System.SysUtils.IncMonth(DateStart, 1 - qryMaker.FieldByName('AmountMonthSend').AsInteger);
      end;
    end;

    if qryMaker.FieldByName('isQuarter').AsBoolean and ((MonthOf(qryMaker.FieldByName('SendPlan').AsDateTime) in [1, 4, 7, 10]) or
       (qryMaker.FieldByName('SendPlan').AsDateTime = EncodeDate(2024, 3, 1))) and
      (DateEnd = IncDay(StartOfTheMonth(qryMaker.FieldByName('SendPlan').AsDateTime), -1))  then
    begin
      FormQuarterFile := True;
      DateEndQuarter := DateEnd;
      if qryMaker.FieldByName('SendPlan').AsDateTime = EncodeDate(2024, 3, 1) then
        DateStartQuarter := System.SysUtils.IncMonth(StartOfTheMonth(DateEndQuarter), - 1)
      else DateStartQuarter := System.SysUtils.IncMonth(StartOfTheMonth(DateEndQuarter), - 2);
    end;

    if qryMaker.FieldByName('is4Month').AsBoolean and (MonthOf(qryMaker.FieldByName('SendPlan').AsDateTime) in [1, 5, 9]) and
      (DateEnd = IncDay(StartOfTheMonth(qryMaker.FieldByName('SendPlan').AsDateTime), -1))  then
    begin
      Form4MonthFile := True;
      DateEnd4Month := DateEnd;
      DateStart4Month := System.SysUtils.IncMonth(StartOfTheMonth(DateEnd4Month), - 3);
    end;


    if qryMaker.FieldByName('isQuarterAdd').AsBoolean then
    begin
      DateEndQuarterAdd := StartOfTheDay(EndOfTheMonth(System.SysUtils.IncMonth(DateEnd, 1)));
      DateStartQuarterAdd := System.SysUtils.IncMonth(StartOfTheMonth(DateEndQuarterAdd), - 2);
    end;

    if qryMaker.FieldByName('is4MonthAdd').AsBoolean then
    begin
      DateEnd4MonthAdd := StartOfTheDay(EndOfTheMonth(System.SysUtils.IncMonth(DateEnd, 1)));
      DateStart4MonthAdd := System.SysUtils.IncMonth(StartOfTheMonth(DateEnd4MonthAdd), - 3);
    end;

  end;
end;

procedure TMainForm.pmClick(Sender: TObject);
begin

  RepType := TMenuItem(Sender).Tag;
  SetDateParams;

  //!!!������ ��� ������� ������!!!
  if trim (EditId.Text) <> '' then
  begin
       DateStart:=StrToDate(StartDateEdit.Text);
       DateEnd:=StrToDate(EndDateEdit.Text);
       //
       //ShowMessage(qryMaker.SQL[23-1]);
       qryMaker.Close;
       qryMaker.SQL.Add('');
       qryMaker.SQL[23]:= ' or Id = ' + EditId.Text;
       qryMaker.Open;
       //
       //DateStart:=StrToDate('16.11.2022');
       //DateEnd:=StrToDate('16.11.2022');
       //or Id = 15451717 // ������ ����� (�������)
       //or Id = 13648288 // ������ + 3605620, 3623593
  end;


  Add_Log('');
  Add_Log('');
  //Add_Log('������ ������������ � ' + DateToStr(DateStart) +' �� ' + DateToStr(DateEnd));

  case RepType of
    0 : ReportIncome(DateStart, DateEnd);
    1 : ReportCheck(DateStart, DateEnd);
    2 : ReportAnalysisRemainsSelling(DateStart, DateEnd);
    3 : ReportIncomeConsumptionBalance(DateStart, DateEnd);
    4 : ReportGoodsPartionDate;
    5 : ReportStockTimingRemainder;
    6 : ReportPayIncome(DateStart, DateEnd);
    7 : ReportRemainsDate(DateEnd);
    8 : ReportLoss(DateStart);
  end;
end;

procedure TMainForm.btnExecuteClick(Sender: TObject);
  var APoint : TPoint;
begin
  inherited;

  if qryReport_Upload.Active then qryReport_Upload.Close;
  if grtvMaker.ColumnCount > 0 then grtvMaker.ClearItems;
  if grtvMaker.DataController.Summary.FooterSummaryItems.Count > 0 then
    grtvMaker.DataController.Summary.FooterSummaryItems.Clear;

  APoint := btnExecute.ClientToScreen(Point(0, btnExecute.ClientHeight));
  pmExecute.Popup(APoint.X, APoint.Y);
end;

procedure TMainForm.ExportAnalysisRemainsSelling;
  var lGoods, lUnit : TStringList; I, J : Integer;
      xlApp, xlBook, xlSheet, xlRange: OLEVariant;
      arrSum : array of array of Extended; bSIP : boolean;

  const xlLeft = - 4131;
        xlRight = -4152;
        xlCenter = -4108;
        xlTop = -4160;
        xlBottom = -4107;
        xlEdgeLeft = 7;
        xlEdgeTop = 8;
        xlEdgeBottom = 9;
        xlEdgeRight = 10;
        xlInsideVertical = 11;
        xlInsideHorizontal = 12;
        xlThin = 2;
        xlMedium = -4138;
        xlLandscape = 2;
        xlPortrait = 1;
        xlMaximized = -4137;
        xlMinimized = -4140;
        xlNormal = -4143;
        xlExcel9795 = 43;
        xlExcel8 = 56;
begin
  qryReport_Upload.DisableControls;
  lGoods := TStringList.Create;
  lGoods.Sorted := True;
  lUnit := TStringList.Create;
  lUnit.Sorted := True;
  try

    qryReport_Upload.First;
    while not qryReport_Upload.Eof do
    begin
      if not lGoods.Find(qryReport_Upload.FieldByName('GoodsName').AsString, I) then lGoods.Add(qryReport_Upload.FieldByName('GoodsName').AsString);
      if not lUnit.Find(qryReport_Upload.FieldByName('UnitName').AsString, I) then lUnit.Add(qryReport_Upload.FieldByName('UnitName').AsString);
      qryReport_Upload.Next;
    end;

    try
      xlApp := GetActiveOleObject('Excel.Application');
    except
      try
        xlApp:=CreateOleObject('Excel.Application');
      except
        Exit;
      end;
    end;

    SetLength(arrSum, lGoods.Count, 6);

    try
      xlApp.Application.ScreenUpdating := false;
      xlApp.DisplayAlerts := false;
      xlBook := xlApp.WorkBooks.Add;
      xlSheet := xlBook.ActiveSheet;
      xlSheet.PageSetup.Orientation := xlLandscape;
      xlSheet.Rows[1].RowHeight := xlSheet.Rows[1].RowHeight * 3;
      xlSheet.Rows[2].RowHeight := xlSheet.Rows[2].RowHeight * 4;
      xlSheet.Columns[1].ColumnWidth := 40;
      xlSheet.Columns[2].ColumnWidth := 10;

      xlRange := xlSheet.Range[xlSheet.Cells[1, 1], xlSheet.Cells[1, 2]];
      xlRange.Merge;
      xlRange := xlSheet.Cells[1, 1];
      xlRange.Value := '����������';
      xlRange.HorizontalAlignment := xlCenter;
      xlRange.VerticalAlignment := xlCenter;
      xlRange.WrapText:=true;
      xlRange.Font.Bold := True;

      xlRange := xlSheet.Cells[2, 1];
      xlRange.Value := '��������';
      xlRange.HorizontalAlignment := xlCenter;
      xlRange.VerticalAlignment := xlCenter;
      xlRange.WrapText:=true;
      xlRange.Font.Bold := True;

      xlRange := xlSheet.Cells[2, 2];
      xlRange.Value := '���';
      xlRange.HorizontalAlignment := xlCenter;
      xlRange.VerticalAlignment := xlCenter;
      xlRange.WrapText:=true;
      xlRange.Font.Bold := True;

      for I := 0 to lUnit.Count - 1 do
      begin
        xlRange := xlSheet.Range[xlSheet.Cells[1, 2 * I + 3], xlSheet.Cells[1, 2 * I + 4]];
        xlRange.Merge;
        xlRange := xlSheet.Cells[1, 2 * I + 3];
        xlRange.Value := lUnit.Strings[I];
        xlRange.HorizontalAlignment := xlCenter;
        xlRange.VerticalAlignment := xlCenter;
        xlRange.WrapText:=true;
        xlRange.Font.Bold := True;
        xlSheet.Columns[2 * I + 3].ColumnWidth := 12;
        xlSheet.Columns[2 * I + 4].ColumnWidth := 12;

        xlRange := xlSheet.Cells[2, 2 * I + 3];
        xlRange.Value := '����������';
        xlRange.HorizontalAlignment := xlCenter;
        xlRange.VerticalAlignment := xlCenter;
        xlRange.WrapText:=true;
        xlRange.Font.Bold := True;

        xlRange := xlSheet.Cells[2, 2 * I + 4];
        xlRange.Value := '�������';
        xlRange.HorizontalAlignment := xlCenter;
        xlRange.VerticalAlignment := xlCenter;
        xlRange.WrapText:=true;
        xlRange.Font.Bold := True;
      end;

      for I := 0 to lGoods.Count - 1 do
      begin
        xlRange := xlSheet.Cells[I + 3, 1];
        xlRange.Value := lGoods.Strings[I];
        xlRange.VerticalAlignment := xlCenter;
        xlRange.HorizontalAlignment := xlLeft;
        xlRange.Font.Bold := True;
        xlRange := xlSheet.Cells[I + 3, 2];
        if qryReport_Upload.Locate('GoodsName', lGoods.Strings[I], [loCaseInsensitive]) then
          xlRange.Value := qryReport_Upload.FieldByName('GoodsId').AsInteger;
        xlRange.VerticalAlignment := xlCenter;
        xlRange.HorizontalAlignment := xlRight;
        xlRange.Font.Bold := True;
      end;

      qryReport_Upload.First;
      while not qryReport_Upload.Eof do
      begin
        if lGoods.Find(qryReport_Upload.FieldByName('GoodsName').AsString, I) and
          lUnit.Find(qryReport_Upload.FieldByName('UnitName').AsString, J) then
        begin
          if not qryReport_Upload.FieldByName('Amount').IsNull then
          begin
            xlRange := xlSheet.Cells[I + 3, 2 * J + 3];
            xlRange.Value := qryReport_Upload.FieldByName('Amount').AsExtended;
          end;
          if not qryReport_Upload.FieldByName('OutSaldo').IsNull then
          begin
            xlRange := xlSheet.Cells[I + 3, 2 * J + 4];
            xlRange.Value := qryReport_Upload.FieldByName('OutSaldo').AsExtended;
          end;
          arrSum[I][0] := arrSum[I][0] + qryReport_Upload.FieldByName('Amount').AsCurrency;
          arrSum[I][1] := arrSum[I][1] + qryReport_Upload.FieldByName('OutSaldo').AsCurrency;
          arrSum[I][2] := arrSum[I][2] + qryReport_Upload.FieldByName('Summ').AsCurrency;
          arrSum[I][3] := arrSum[I][3] + qryReport_Upload.FieldByName('SummSaldo').AsCurrency;
          arrSum[I][4] := arrSum[I][4] + qryReport_Upload.FieldByName('SummSIP').AsCurrency;
          arrSum[I][5] := arrSum[I][5] + qryReport_Upload.FieldByName('SummSaldoSIP').AsCurrency;
        end;
        qryReport_Upload.Next;
      end;

      bSIP := False;
      for I := 0 to lGoods.Count - 1 do
      begin
        for j := 0 to 5 do
        if arrSum[I][J] <> 0 then
        begin
          if j > 3 then bSIP := True;
          xlRange := xlSheet.Cells[I + 3, lUnit.Count * 2 + 3 + j];
          xlRange.Value := arrSum[I][J];
        end;
      end;

      if bSIP then
        xlRange := xlSheet.Range[xlSheet.Cells[1, lUnit.Count * 2 + 3], xlSheet.Cells[1, lUnit.Count * 2 + 8]]
      else xlRange := xlSheet.Range[xlSheet.Cells[1, lUnit.Count * 2 + 3], xlSheet.Cells[1, lUnit.Count * 2 + 6]];
      xlRange.Merge;
      xlRange := xlSheet.Cells[1, lUnit.Count * 2 + 3];
      xlRange.Value := '����� ����';
      xlRange.HorizontalAlignment := xlCenter;
      xlRange.VerticalAlignment := xlCenter;
      xlRange.WrapText:=true;
      xlRange.Font.Bold := True;

      xlRange := xlSheet.Cells[2, lUnit.Count * 2 + 3];
      xlRange.Value := '����������';
      xlRange.HorizontalAlignment := xlCenter;
      xlRange.VerticalAlignment := xlCenter;
      xlRange.WrapText:=true;
      xlRange.Font.Bold := True;
      xlSheet.Columns[lUnit.Count * 2 + 3].ColumnWidth := 12;

      xlRange := xlSheet.Cells[2, lUnit.Count * 2 + 4];
      xlRange.Value := '�������';
      xlRange.HorizontalAlignment := xlCenter;
      xlRange.VerticalAlignment := xlCenter;
      xlRange.WrapText:=true;
      xlRange.Font.Bold := True;
      xlSheet.Columns[lUnit.Count * 2 + 4].ColumnWidth := 12;

      xlRange := xlSheet.Cells[2, lUnit.Count * 2 + 5];
      xlRange.Value := '����� ������ � ����� � ���';
      xlRange.HorizontalAlignment := xlCenter;
      xlRange.VerticalAlignment := xlCenter;
      xlRange.WrapText:=true;
      xlRange.Font.Bold := True;
      xlSheet.Columns[lUnit.Count * 2 + 5].ColumnWidth := 12;

      xlRange := xlSheet.Cells[2, lUnit.Count * 2 + 6];
      xlRange.Value := '����� ������� � ����� � ���';
      xlRange.HorizontalAlignment := xlCenter;
      xlRange.VerticalAlignment := xlCenter;
      xlRange.WrapText:=true;
      xlRange.Font.Bold := True;
      xlSheet.Columns[lUnit.Count * 2 + 6].ColumnWidth := 12;

      if bSIP then
      begin
        xlRange := xlSheet.Cells[2, lUnit.Count * 2 + 7];
        xlRange.Value := '����� ������ � ��� �����';
        xlRange.HorizontalAlignment := xlCenter;
        xlRange.VerticalAlignment := xlCenter;
        xlRange.WrapText:=true;
        xlRange.Font.Bold := True;
        xlSheet.Columns[lUnit.Count * 2 + 7].ColumnWidth := 12;

        xlRange := xlSheet.Cells[2, lUnit.Count * 2 + 8];
        xlRange.Value := '����� ������� � ��� �����';
        xlRange.HorizontalAlignment := xlCenter;
        xlRange.VerticalAlignment := xlCenter;
        xlRange.WrapText:=true;
        xlRange.Font.Bold := True;
        xlSheet.Columns[lUnit.Count * 2 + 8].ColumnWidth := 12;
      end;

        // ������ ����� ������ �����
      if bSIP then
        xlRange := xlSheet.Range[xlSheet.Cells[1, 1], xlSheet.Cells[2, lUnit.Count * 2 + 8]]
      else xlRange := xlSheet.Range[xlSheet.Cells[1, 1], xlSheet.Cells[2, lUnit.Count * 2 + 6]];
      xlRange.Borders[xlEdgeLeft].Weight := xlMedium;
      xlRange.Borders[xlEdgeTop].Weight := xlMedium;
      xlRange.Borders[xlEdgeRight].Weight := xlMedium;
      xlRange.Borders[xlEdgeBottom].Weight := xlMedium;
      xlRange.Borders[xlInsideVertical].Weight := xlThin;
      xlRange.Borders[xlInsideHorizontal].Weight := xlThin;

        // ������ ����� ������ ������
      if bSIP then
        xlRange := xlSheet.Range[xlSheet.Cells[3, 1], xlSheet.Cells[lGoods.Count + 2, lUnit.Count * 2 + 8]]
      else xlRange := xlSheet.Range[xlSheet.Cells[3, 1], xlSheet.Cells[lGoods.Count + 2, lUnit.Count * 2 + 6]];
      xlRange.Borders[xlEdgeLeft].Weight := xlMedium;
      xlRange.Borders[xlEdgeTop].Weight := xlMedium;
      xlRange.Borders[xlEdgeRight].Weight := xlMedium;
      xlRange.Borders[xlEdgeBottom].Weight := xlMedium;
      xlRange.Borders[xlInsideVertical].Weight := xlThin;
      xlRange.Borders[xlInsideHorizontal].Weight := xlThin;

      xlRange := xlSheet.Range[xlSheet.Cells[lGoods.Count + 3, 1], xlSheet.Cells[lGoods.Count + 3, 2]];
      xlRange.Merge;
      xlRange := xlSheet.Cells[lGoods.Count + 3, 1];
      xlRange.Value := '����� ����';
      xlRange.HorizontalAlignment := xlLeft;
      xlRange.VerticalAlignment := xlCenter;
      xlRange.WrapText:=true;
      xlRange.Font.Bold := True;

      if bSIP then
        xlRange := xlSheet.Range[xlSheet.Cells[lGoods.Count + 3, 3], xlSheet.Cells[lGoods.Count + 3, lUnit.Count * 2 + 8]]
      else xlRange := xlSheet.Range[xlSheet.Cells[lGoods.Count + 3, 3], xlSheet.Cells[lGoods.Count + 3, lUnit.Count * 2 + 6]];
      xlRange.FormulaR1C1 := '=SUM(R[-' + IntToStr(lGoods.Count) + ']C:R[-1]C)';

        // ������ ����� ������ ������
      if bSIP then
        xlRange := xlSheet.Range[xlSheet.Cells[lGoods.Count + 3, 1], xlSheet.Cells[lGoods.Count + 3, lUnit.Count * 2 + 8]]
      else xlRange := xlSheet.Range[xlSheet.Cells[lGoods.Count + 3, 1], xlSheet.Cells[lGoods.Count + 3, lUnit.Count * 2 + 6]];
      xlRange.Borders[xlEdgeLeft].Weight := xlMedium;
      xlRange.Borders[xlEdgeTop].Weight := xlMedium;
      xlRange.Borders[xlEdgeRight].Weight := xlMedium;
      xlRange.Borders[xlEdgeBottom].Weight := xlMedium;
      xlRange.Borders[xlInsideVertical].Weight := xlThin;
      xlRange.Borders[xlInsideHorizontal].Weight := xlThin;

      xlBook.SaveAs(SavePath + FileName, xlExcel8);
      xlApp.Application.ScreenUpdating := true;
      xlBook.Close;
      xlApp.Quit;
      xlApp := Unassigned;
    finally
      SetLength(arrSum, 0, 0);
    end;
  finally
    lGoods.Free;
    lUnit.Free;
    qryReport_Upload.First;
    qryReport_Upload.EnableControls;
  end;
end;

procedure TMainForm.btnExportClick(Sender: TObject);
var
  sl: TStringList;
begin
  if not qryReport_Upload.Active then Exit;
  if qryReport_Upload.IsEmpty then Exit;
  Add_Log('������ �������� ������');
  if not ForceDirectories(SavePath) then
  Begin
    Add_Log('�� ���� ������� ���������� ��������');
    FProcError := True;
    exit;
  end;

  // ������� �����
  if RepType = 2 then ExportAnalysisRemainsSelling
  else
  try
    try
      ExportGridToExcel(SavePath + FileName, grReportMaker);
      Add_Log(qryMaker.FieldByName('Name').AsString);
      Add_Log('����� ��������� :'+ SavePath + FileName);
      Add_Log('');
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

procedure TMainForm.btnSendMailClick(Sender: TObject);
  var vExt : string;

  function GetFileSizeByName(AFileName: string): DWord;
  var
    Handle: THandle;
  begin
    if not FileExists(AFilename) then exit;
    Handle := FileOpen(AFilename, fmOpenRead or fmShareDenyNone);
    Result := GetFileSize(Handle, nil);
    CloseHandle(Handle);
  end;

begin

  if not FileExists(SavePath + FileName + '.xls') then Exit;

  Add_Log('������ �������� ������: ' + SavePath + FileName + '.xls');
  vExt := '.xls';

  if GetFileSizeByName(SavePath + FileName + '.xls') > 10000000 then
  begin
    vExt := '.zip';
    Add_Log('������������� ������: ' + SavePath + FileName + vExt);
    GZCompressFile(SavePath + FileName + '.xls', SavePath + FileName + vExt);
  end;

  if SendMail(qryMailParam.FieldByName('Mail_Host').AsString,
       qryMailParam.FieldByName('Mail_Port').AsInteger,
       qryMailParam.FieldByName('Mail_Password').AsString,
       qryMailParam.FieldByName('Mail_User').AsString,
       StringsReplace(qryMaker.FieldByName('Mail').AsString, [',', ', '], [';',';']),
       qryMailParam.FieldByName('Mail_From').AsString,
       Subject,
       '',
       [SavePath + FileName + vExt]) then
  begin
    Add_Log('����� ��������� :'+ qryMaker.FieldByName('Mail').AsString + '  ����:' + SavePath + FileName + vExt);
    try
      DeleteFile(SavePath + FileName + '.xls');
      if FileExists(SavePath + FileName + vExt) then DeleteFile(SavePath + FileName + vExt);
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
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ExportForMaker.ini');

  //!!!������ ��� ������� ������!!!
  StartDateEdit.Date:= Date;
  EndDateEdit.Date:= Date;
  EditId.Text:= '';


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
      ZConnection1.Disconnect;
      Timer1.Enabled := true;
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
        ZConnection1.Disconnect;
        Timer1.Enabled := true;
        Exit;
      end;
    end;

    if not (((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) or
      (Pos('Farmacy.exe', Application.ExeName) <> 0)) then
    begin
      btnAll.Enabled := false;
      btnAllMaker.Enabled := false;
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
