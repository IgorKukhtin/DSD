unit Report_ImplementationPlanEmployeeCash;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, DateUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, ParentForm, DataModul, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, dsdAddOn,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxCurrencyEdit, cxCustomPivotGrid,
  cxDBPivotGrid, cxLabel, ChoicePeriod, dxBarExtItems, cxCheckBox, cxSplitter,
  Vcl.StdCtrls, Vcl.Menus, cxButtons, cxExportPivotGridLink, dsdGuides,
  cxButtonEdit, cxGridBandedTableView, cxGridDBBandedTableView, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, System.Actions,
  dxDateRanges;

type
  TReport_ImplementationPlanEmployeeCashForm = class(TForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    dsdStoredProc: TdsdStoredProc;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel1: TcxLabel;
    FormParams: TdsdFormParams;
    dsdOpenForm1: TdsdOpenForm;
    dsdExecStoredProc1: TdsdExecStoredProc;
    bbStaticText: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bb: TdxBarControlContainerItem;
    cxSplitter1: TcxSplitter;
    dsUnitCategory: TDataSource;
    cdsUnitCategory: TClientDataSet;
    dsUnit: TDataSource;
    cdsUnit: TClientDataSet;
    dsResult: TDataSource;
    cdsResult: TClientDataSet;
    dxBarButton3: TdxBarButton;
    actExportExel: TdsdGridToExcel;
    dxBarButton4: TdxBarButton;
    cxImplementationPlanEmployee: TcxGrid;
    Panel2: TPanel;
    Panel3: TPanel;
    cxImplementationPlanEmployeeLevel1: TcxGridLevel;
    cxImplementationPlanEmployeeDBBandedTableView1: TcxGridDBBandedTableView;
    colGroupName: TcxGridDBBandedColumn;
    colGoodsCode: TcxGridDBBandedColumn;
    colGoodsName: TcxGridDBBandedColumn;
    colAmount: TcxGridDBBandedColumn;
    colAmountPlanTab: TcxGridDBBandedColumn;
    colAmountPlanAwardTab: TcxGridDBBandedColumn;
    colAmountTheFineTab: TcxGridDBBandedColumn;
    colBonusAmountTab: TcxGridDBBandedColumn;
    colConsider: TcxGridDBBandedColumn;
    cdsListBands: TClientDataSet;
    cdsListFields: TClientDataSet;
    cxUnitDBTableView1: TcxGridDBTableView;
    cxUnitLevel1: TcxGridLevel;
    cxUnit: TcxGrid;
    colUnitName: TcxGridDBColumn;
    colNormOfManDays: TcxGridDBColumn;
    colFactOfManDays: TcxGridDBColumn;
    colPercentAttendance: TcxGridDBColumn;
    cxUnitCategory: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    colUnitCategoryName: TcxGridDBColumn;
    colPenaltyNonMinPlan: TcxGridDBColumn;
    colPremiumImplPlan: TcxGridDBColumn;
    colMinLineByLineImplPlan: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxResult: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridDBColumn5: TcxGridDBColumn;
    cxGridDBColumn6: TcxGridDBColumn;
    cxGridDBColumn7: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    dxBarButton1: TdxBarButton;
    actConsider: TAction;
    edFilter: TcxTextEdit;
    cxLabel2: TcxLabel;
    dsdFieldFilter1: TdsdFieldFilter;
    cbHighlightStrings: TcxCheckBox;
    cbFilter1: TcxCheckBox;
    cbFilter2: TcxCheckBox;
    cbFilter3: TcxCheckBox;
    AmountPlan: TcxGridDBBandedColumn;
    AmountPlanAward: TcxGridDBBandedColumn;
    cxGridDBColumn8: TcxGridDBColumn;
    cdsResultTotalExecutionLine: TCurrencyField;
    cdsResultTotalExecutionAllLine: TCurrencyField;
    cdsResultAwarding: TStringField;
    cdsResultTotal: TCurrencyField;
    spGetTotal: TdsdStoredProc;
    colisFixedPercent: TcxGridDBBandedColumn;
    colAddBonusPercent: TcxGridDBBandedColumn;
    cdsResultTotalExecutionFixed: TCurrencyField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cdsListBandsAfterOpen(DataSet: TDataSet);
    procedure ClientDataSetCalcFields(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cdsListFieldsAfterOpen(DataSet: TDataSet);
    procedure ClientDataSetAfterOpen(DataSet: TDataSet);
    procedure cdsUnitAfterPost(DataSet: TDataSet);
    procedure cxImplementationPlanEmployeeDBBandedTableView1TcxGridDBDataControllerTcxDataSummaryFooterSummaryItems3GetText(
      Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
      var AText: string);
    procedure cxImplementationPlanEmployeeDBBandedTableView1TcxGridDBDataControllerTcxDataSummaryFooterSummaryItems4GetText(
      Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
      var AText: string);
    procedure cdsListBandsAfterClose(DataSet: TDataSet);
    procedure cdsResultCalcFields(DataSet: TDataSet);
    procedure ClientDataSetAfterPost(DataSet: TDataSet);
    procedure cxImplementationPlanEmployeeDBBandedTableView1TcxGridDBDataControllerTcxDataSummaryFooterSummaryItems2GetText(
      Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
      var AText: string);
    procedure actConsiderExecute(Sender: TObject);
    procedure cdsUnitAfterOpen(DataSet: TDataSet);
    procedure colGroupNameStylesGetContentStyle(Sender: TcxCustomGridTableView;
      ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem;
      var AStyle: TcxStyle);
    procedure cbHighlightStringsClick(Sender: TObject);
    procedure cbFilter1Click(Sender: TObject);
    procedure ClientDataSetFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    FUnit : TStrings;
    FUnitCategory : TStrings;
    FCountO : Integer;
    FCountAllO : Integer;
    FCountYes : Integer;
    FCountFixed : Integer;
    FCountFixedPercent : Integer;
    FFixedPercent : Currency;
    FStyle : TcxStyle;

    FUnitCalck : Integer;
    FUnitId : Integer;
    FUnitCategoryID : Integer;

    FAmountPlan :  TcxGridDBBandedColumn;
    FAmountPlanAward :  TcxGridDBBandedColumn;

  public
  end;

implementation

{$R *.dfm}

const aCaption : array[1..14] of String = (
  '����',  '����', '���. ����', '% ���. ���. �����', '���� ��� ������',
  '% ���. ����� ��� ������', '����� ������ ', '����� ������', '��� ���� � ��. ������', '% ���. ���. ����� � ��. ������ ',
  '���� ��� ������ � ��. ������', '% ���. ����� ��� ������ c ��. ������', '����� ������ � ��. ������', '����� ������ � ��. ������');

procedure TReport_ImplementationPlanEmployeeCashForm.actConsiderExecute(
  Sender: TObject);
  var S : string; nPos : Integer;
begin

  if not ClientDataSet.Active then Exit;

  S := '';
  with TTaskDialog.Create(self) do
  try
    Caption := Self.Caption;
    Title := '��������� ��������';
    Text := '��������� ��� ������������ % ����������� ����������';
    CommonButtons := [];
    with TTaskDialogButtonItem(Buttons.Add) do
    begin
      Caption := '���������� "Yes" �� ��� �������';
      ModalResult := mrYes;
    end;
    with TTaskDialogButtonItem(Buttons.Add) do
    begin
      Caption := '���������� "No" �� ��� �������';
      ModalResult := mrNo;
    end;
    with TTaskDialogButtonItem(Buttons.Add) do
    begin
      Caption := '������';
      ModalResult := mrCancel;
    end;
    Flags := [tfUseCommandLinks];
    MainIcon := tdiNone;
    if Execute then
      case ModalResult of
        mrYes : S := 'Yes';
        mrNo : S := 'No';
      end;
  finally
    Free;
  end;

  if S = '' then Exit;

  nPos :=  ClientDataSet.RecNo;
  FCountYes := 0;
  try
    ClientDataSet.AfterPost :=  Nil;
    ClientDataSet.DisableControls;
    ClientDataSet.First;
    while not ClientDataSet.Eof do
    begin
      if ClientDataSet.FieldByName('Consider').AsString <> S then
      begin
        ClientDataSet.Edit;
        ClientDataSet.FieldByName('Consider').AsString := S;
        ClientDataSet.Post;
      end;
      if ClientDataSet.FieldByName('Consider').AsString = 'Yes' then Inc(FCountYes);
      ClientDataSet.Next;
    end;
  finally
    ClientDataSet.RecNo := nPos;
    ClientDataSet.EnableControls;
    ClientDataSet.AfterPost :=  ClientDataSetAfterPost;
    ClientDataSet.Resync([]);
//    cdsResult.Resync([]);
  end;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.cbHighlightStringsClick(
  Sender: TObject);
begin

  cbFilter1.Visible := cbHighlightStrings.Checked;
  cbFilter2.Visible := cbHighlightStrings.Checked;
  cbFilter3.Visible := cbHighlightStrings.Checked;

  if not ClientDataSet.Active  then Exit;

  ClientDataSet.DisableControls;
  if ClientDataSet.Filtered then
  begin
    ClientDataSet.Filtered := False;
    ClientDataSet.Filtered := True;
  end;
  ClientDataSet.EnableControls;
  cxImplementationPlanEmployee.SetFocus;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.cdsListBandsAfterClose(
  DataSet: TDataSet);
begin
  ClientDataSet.Close;
  cdsUnitCategory.Close;
  cdsUnit.Close;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.cdsListBandsAfterOpen(
  DataSet: TDataSet);
  var nIndexUnitCategory, nIndexUnit, I : Integer;
begin
  nIndexUnitCategory := -1; nIndexUnit := -1;
  FAmountPlan := Nil; FAmountPlanAward := Nil;
  FUnit.Clear;
  FUnitCategory.Clear;

  I := 0;
  while I < cxImplementationPlanEmployeeDBBandedTableView1.ColumnCount do
  begin
    if cxImplementationPlanEmployeeDBBandedTableView1.Columns[I].Position.BandIndex <>
      cxImplementationPlanEmployeeDBBandedTableView1.Columns[I].Tag then
      cxImplementationPlanEmployeeDBBandedTableView1.Columns[I].Position.BandIndex :=
      cxImplementationPlanEmployeeDBBandedTableView1.Columns[I].Tag;
    Inc(I);
  end;

  I := 0;
  while I < cxImplementationPlanEmployeeDBBandedTableView1.ColumnCount do
  begin
    if cxImplementationPlanEmployeeDBBandedTableView1.Columns[I].Position.BandIndex > 1 then
      cxImplementationPlanEmployeeDBBandedTableView1.Columns[I].Free
    else Inc(I);
  end;


  while cxImplementationPlanEmployeeDBBandedTableView1.Bands.Count > 2 do
    cxImplementationPlanEmployeeDBBandedTableView1.Bands.Delete(2);

  cdsListBands.First;
  while not cdsListBands.Eof do
  begin
    if (nIndexUnitCategory < 0) or
      (cxImplementationPlanEmployeeDBBandedTableView1.Bands[nIndexUnitCategory].Tag <>
      cdsListBands.FieldByName('UnitCategoryID').AsInteger) then
    with cxImplementationPlanEmployeeDBBandedTableView1.Bands.Add do
    begin
      if cdsListBands.FieldByName('UnitCategoryName').AsString <> '' then
        Caption := '���������: ' + cdsListBands.FieldByName('UnitCategoryName').AsString
      else Caption := '��� ���������';
      Tag := cdsListBands.FieldByName('UnitCategoryID').AsInteger;
      nIndexUnitCategory := Index;
    end;
    with cxImplementationPlanEmployeeDBBandedTableView1.Bands.Add do
    begin
      Caption := '������: ' + cdsListBands.FieldByName('UnitName').AsString;
      Tag := cdsListBands.FieldByName('UnitID').AsInteger;
      nIndexUnit := Index;
      Position.BandIndex := nIndexUnitCategory;
      FUnit.Add(IntToStr(cdsListBands.FieldByName('UnitID').AsInteger));
      FUnitCategory.Add(IntToStr(cdsListBands.FieldByName('UnitCategoryID').AsInteger));
    end;

    for I := Low(aCaption) to High(aCaption) do
    with cxImplementationPlanEmployeeDBBandedTableView1.CreateColumn do
    begin
      Caption := aCaption[I];
      Position.BandIndex := nIndexUnit;
      HeaderAlignmentHorz := TAlignment.taCenter;
      Options.Editing := False;
      case I of
        1 : DataBinding.FieldName := 'Price' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
        2 : DataBinding.FieldName := 'Amount' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
        3 : DataBinding.FieldName := 'AmountPlan' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
        4 : DataBinding.FieldName := 'PercentAmountPlan' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
        5 : DataBinding.FieldName := 'AmountPlanAward' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
        6 : DataBinding.FieldName := 'PercentAmountPlanAward' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
        7 : DataBinding.FieldName := 'AmountTheFine' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
        8 : DataBinding.FieldName := 'BonusAmount' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
        9 : DataBinding.FieldName := 'AmountPlanTab' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
        10 : DataBinding.FieldName := 'PercentAmountPlanTab' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
        11 : DataBinding.FieldName := 'AmountPlanAwardTab' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
        12 : DataBinding.FieldName := 'PercentAmountPlanAwardTab' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
        13 : DataBinding.FieldName := 'AmountTheFineTab' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
        14 : DataBinding.FieldName := 'BonusAmountTab' + IntToStr(cdsListBands.FieldByName('UnitID').AsInteger);
      end;
      Name := 'col' + DataBinding.FieldName;
      Tag := nIndexUnit;

      if I in [2, 3, 5] then
      begin
        Summary.FooterFormat := ',0.####';
        Summary.FooterKind := skSum;
      end;

      if I in [7, 8, 13, 14] then
      begin
        Summary.FooterFormat := ',0.00';
        Summary.FooterKind := skSum;
      end;

      case I of
         2, 3, 5 : begin
               PropertiesClass := TcxCurrencyEditProperties;
               TcxCurrencyEditProperties(Properties).DecimalPlaces := 4;
               TcxCurrencyEditProperties(Properties).DisplayFormat := ',0.####';
             end;
        else
        begin
          PropertiesClass := TcxCurrencyEditProperties;
          TcxCurrencyEditProperties(Properties).DisplayFormat := ',0.00';
        end;
      end;
      Styles.OnGetContentStyle := colGroupNameStylesGetContentStyle;
    end;

    cdsListBands.Next;
  end;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.cdsListFieldsAfterOpen(
  DataSet: TDataSet);
  var Field: TField; FieldClassType: TFieldClass; I, J : integer;
begin

  if ClientDataSet.Active then ClientDataSet.Close;
  ClientDataSet.Fields.Clear;

  for I := 0 to cdsListFields.FieldDefs.Count - 1 do
  begin
    FieldClassType := cdsListFields.FieldDefs.Items[I].FieldClass;
    Field := FieldClassType.Create(Owner);
    Field.FieldName := cdsListFields.FieldDefs.Items[I].Name;
    Field.SetFieldType(cdsListFields.FieldDefs.Items[I].DataType);
    Field.Name := 'cds' + Field.FieldName;
    Field.DataSet := ClientDataSet;
  end;

  for I := 1 to 10 do
  begin
    Field := TCurrencyField.Create(Self);
    Field.FieldKind := fkCalculated;
    case I of
      1 : Field.FieldName := 'Amount';
      2 : Field.FieldName := 'AmountPlanTab';
      3 : Field.FieldName := 'AmountPlan';
      4 : Field.FieldName := 'AmountPlanAwardTab';
      5 : Field.FieldName := 'AmountPlanAward';
      6 : Field.FieldName := 'AmountTheFineTab';
      7 : Field.FieldName := 'BonusAmountTab';
      8 : Field.FieldName := 'AddBonusPercent';
      9 : Field.FieldName := 'BonusPercentSum';
      10 : Field.FieldName := 'BonusPercentAddSum';
    end;
    Field.Name := 'cds' + Field.FieldName;
    Field.DataSet := ClientDataSet;
  end;

//  Field := TBooleanField.Create(Self);
//  Field.FieldKind := fkCalculated;
//  Field.FieldName := 'isFixedPercent';
//  Field.Name := 'cds' + Field.FieldName;
//  Field.DataSet := ClientDataSet;

  for I := 0 to FUnit.Count - 1 do
  begin
    for J := 1 to 10 do
    begin
      Field := TCurrencyField.Create(Self);
      Field.FieldKind := fkCalculated;
      case J of
        1 : Field.FieldName := 'PercentAmountPlan' + FUnit.Strings[I];
        2 : Field.FieldName := 'PercentAmountPlanAward' + FUnit.Strings[I];
        3 : Field.FieldName := 'AmountTheFine' + FUnit.Strings[I];
        4 : Field.FieldName := 'BonusAmount' + FUnit.Strings[I];
        5 : Field.FieldName := 'AmountPlanTab' + FUnit.Strings[I];
        6 : Field.FieldName := 'PercentAmountPlanTab' + FUnit.Strings[I];
        7 : Field.FieldName := 'AmountPlanAwardTab' + FUnit.Strings[I];
        8 : Field.FieldName := 'PercentAmountPlanAwardTab' + FUnit.Strings[I];
        9 : Field.FieldName := 'AmountTheFineTab' + FUnit.Strings[I];
        10 : Field.FieldName := 'BonusAmountTab' + FUnit.Strings[I];
      end;
      Field.Name := 'cds' + Field.FieldName;
      Field.DataSet := ClientDataSet;
    end;
  end;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.cdsResultCalcFields(
  DataSet: TDataSet);
begin
  if not ClientDataSet.Active then Exit;

  if FCountYes <> 0 then
    Dataset['TotalExecutionLine'] := (ClientDataSet.RecordCount - FCountO) / FCountYes * 100 + FCountFixedPercent * FFixedPercent
  else Dataset['TotalExecutionLine'] := 0;

  if FCountFixed <> 0 then
    Dataset['TotalExecutionFixed'] := FCountFixedPercent / FCountFixed * 100
  else Dataset['TotalExecutionFixed'] := 0;

  if FCountYes <> 0 then
    Dataset['TotalExecutionAllLine'] := (ClientDataSet.RecordCount - FCountAllO) / FCountYes * 100
  else Dataset['TotalExecutionAllLine'] := 0;

  if Dataset['Awarding'] = 'Yes' then
    Dataset['Total'] := cxImplementationPlanEmployeeDBBandedTableView1.DataController.Summary.FooterSummaryValues[1] -
      cxImplementationPlanEmployeeDBBandedTableView1.DataController.Summary.FooterSummaryValues[0]
  else Dataset['Total'] := 0;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.cdsUnitAfterOpen(
  DataSet: TDataSet);
  var nCount : integer; I : Integer;
begin
  FUnitCalck := 0;
  nCount := 0;
  try
    cdsUnit.DisableControls;
    cdsUnit.First;
    while not cdsUnit.Eof do
    begin
      if nCount < cdsUnit.FieldByName('FactOfManDays').AsInteger then
      begin
        nCount := cdsUnit.FieldByName('FactOfManDays').AsInteger;
        FUnitId := cdsUnit.FieldByName('UnitId').AsInteger;
        FUnitCategoryID := cdsUnit.FieldByName('UnitCategoryId').AsInteger;
        FFixedPercent := cdsUnit.FieldByName('FixedPercent').AsCurrency;
        FUnitCalck := cdsUnit.RecNo - 1;
      end;
      cdsUnit.Next;
    end;
    for I := 0 to ComponentCount - 1 do if Components[I] is TcxGridDBBandedColumn then
    begin
      if TcxGridDBBandedColumn(Components[I]).Name = 'col' + 'AmountPlan' + FUnit.Strings[FUnitCalck] then
         FAmountPlan := TcxGridDBBandedColumn(Components[I]);
      if TcxGridDBBandedColumn(Components[I]).Name = 'col' + 'AmountPlanAward' + FUnit.Strings[FUnitCalck] then
         FAmountPlanAward := TcxGridDBBandedColumn(Components[I]);
    end;
  finally
    cdsUnit.First;
    cdsUnit.EnableControls;
  end;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.cdsUnitAfterPost(
  DataSet: TDataSet);
begin
  ClientDataSet.Resync([]);
//  cdsResult.Resync([]);
end;

procedure TReport_ImplementationPlanEmployeeCashForm.ClientDataSetAfterOpen(
  DataSet: TDataSet);
begin
  FCountO := 0;
  FCountAllO := 0;
  FCountYes := 0;
  FCountFixedPercent := 0;
  FCountFixed := 0;
  try
    ClientDataSet.AfterPost :=  Nil;
    ClientDataSet.DisableControls;
    while not ClientDataSet.Eof do
    begin
      if (ClientDataSet.FieldByName('Amount').AsCurrency = 0) or
        (ClientDataSet.FieldByName('AmountPlanTab').AsCurrency = 0) or
        (ClientDataSet.FieldByName('Amount').AsCurrency < ClientDataSet.FieldByName('AmountPlanTab').AsCurrency) then Inc(FCountO);
      if (ClientDataSet.FieldByName('Amount').AsCurrency = 0) or
        (ClientDataSet.FieldByName('AmountPlan').AsCurrency = 0) or
        (ClientDataSet.FieldByName('Amount').AsCurrency < ClientDataSet.FieldByName('AmountPlan').AsCurrency) then Inc(FCountAllO);
      if ClientDataSet.FieldByName('isFixedPercent').AsBoolean AND
        (ClientDataSet.FieldByName('Amount').AsCurrency > 0) AND
        (ClientDataSet.FieldByName('AmountPlanTab').AsCurrency > 0) AND
        (ClientDataSet.FieldByName('Amount').AsCurrency >= ClientDataSet.FieldByName('AmountPlanTab').AsCurrency) then Inc(FCountFixedPercent);
      ClientDataSet.Edit;
      if ClientDataSet.FieldByName('AmountPlanTab').AsCurrency >= 0.1 then
      begin
        ClientDataSet.FieldByName('Consider').AsString := 'Yes';
        if ClientDataSet.FieldByName('isFixedPercent').AsBoolean then Inc(FCountFixed);
        Inc(FCountYes);
      end else ClientDataSet.FieldByName('Consider').AsString := 'No';
      ClientDataSet.Post;
      ClientDataSet.Next;
    end;
  finally
    ClientDataSet.First;
    ClientDataSet.EnableControls;
    ClientDataSet.AfterPost :=  ClientDataSetAfterPost;
  end;

  try
//    cur := 0;
//    cdsUnitCategory.DisableControls;
//    cdsUnitCategory.First;
//    while not cdsUnitCategory.Eof do
//    begin
//      cur := cur + cdsUnitCategory.FieldByName('MinLineByLineImplPlan').AsCurrency;
//      cdsUnitCategory.Next;
//    end;


    if cdsResult.RecordCount = 0 then cdsResult.Append
    else cdsResult.Edit;
////    if (cdsUnitCategory.RecordCount > 0) and (cdsResult.FieldByName('TotalExecutionLine').AsCurrency >=
////      (cur / cdsUnitCategory.RecordCount)) then
////      cdsResult.FieldByName('Awarding').AsString := 'Yes'
//    if (FCountYes <> 0) and cdsUnitCategory.Locate('UnitCategoryCode', FUnitCategoryID, []) and
//      (((ClientDataSet.RecordCount - FCountO) / FCountYes * 100) >=
//      cdsUnitCategory.FieldByName('MinLineByLineImplPlan').AsCurrency) then
//      cdsResult.FieldByName('Awarding').AsString := 'Yes'
//    else cdsResult.FieldByName('Awarding').AsString := 'No';

    if not ClientDataSet.Active then Exit;

    if FCountYes <> 0 then
      cdsResult.FieldByName('TotalExecutionLine').AsCurrency := (ClientDataSet.RecordCount - FCountO) / FCountYes * 100 + FCountFixedPercent * FFixedPercent
    else cdsResult.FieldByName('TotalExecutionLine').AsCurrency := 0;

    if FCountFixed <> 0 then
      cdsResult.FieldByName('TotalExecutionFixed').AsCurrency := FCountFixedPercent / FCountFixed * 100
    else cdsResult.FieldByName('TotalExecutionFixed').AsCurrency := 0;

    if FCountYes <> 0 then
      cdsResult.FieldByName('TotalExecutionAllLine').AsCurrency := (ClientDataSet.RecordCount - FCountAllO) / FCountYes * 100
    else cdsResult.FieldByName('TotalExecutionAllLine').AsCurrency := 0;

    spGetTotal.ParamByName('inUnitId').Value := FUnitId;
    spGetTotal.ParamByName('inOperDate').Value := deStart.Date;
    spGetTotal.ParamByName('inTotalExecutionLine').Value := cdsResult.FieldByName('TotalExecutionLine').AsCurrency;
    spGetTotal.ParamByName('inTotalExecutionFixed').Value := cdsResult.FieldByName('TotalExecutionFixed').AsCurrency;
    spGetTotal.ParamByName('inAmountTheFineTab').Value := cxImplementationPlanEmployeeDBBandedTableView1.DataController.Summary.FooterSummaryValues[0];
    spGetTotal.ParamByName('inBonusAmountTab').Value := cxImplementationPlanEmployeeDBBandedTableView1.DataController.Summary.FooterSummaryValues[1];
    if (FCountFixedPercent * FFixedPercent < 45) and (StartOfTheMonth(deStart.Date) >= EncodeDate(202, 09, 01)) then
    begin
      spGetTotal.ParamByName('inBonusPercentSum').Value := cxImplementationPlanEmployeeDBBandedTableView1.DataController.Summary.FooterSummaryValues[5] * 0.7;
      spGetTotal.ParamByName('inBonusPercentAddSum').Value := cxImplementationPlanEmployeeDBBandedTableView1.DataController.Summary.FooterSummaryValues[6] * 0.7;
    end else
    begin
      spGetTotal.ParamByName('inBonusPercentSum').Value := cxImplementationPlanEmployeeDBBandedTableView1.DataController.Summary.FooterSummaryValues[5];
      spGetTotal.ParamByName('inBonusPercentAddSum').Value := cxImplementationPlanEmployeeDBBandedTableView1.DataController.Summary.FooterSummaryValues[6];
    end;
    spGetTotal.ParamByName('inisNewUser').Value := cdsUnit.FieldByName('isNewUser').AsBoolean;
    spGetTotal.ParamByName('inisCashier').Value := cdsUnit.FieldByName('isCashier').AsBoolean;
    spGetTotal.ParamByName('outTotal').Value := 0;

    try
      spGetTotal.Execute;
    except
    end;

    if spGetTotal.ParamByName('outTotal').AsFloat <> 0 then cdsResult.FieldByName('Awarding').AsString := 'Yes'
    else cdsResult.FieldByName('Awarding').AsString := 'No';
    cdsResult.FieldByName('Total').AsCurrency := spGetTotal.ParamByName('outTotal').AsFloat;

    cdsResult.Post;
  finally
//    cdsUnitCategory.First;
//    cdsUnitCategory.EnableControls;
  end;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.ClientDataSetAfterPost(
  DataSet: TDataSet);
  var Pos : Integer;
begin
  if not ClientDataSet.Active then Exit;
  Pos := ClientDataSet.RecNo;
  FCountYes := 0;
  try
    ClientDataSet.DisableControls;
    ClientDataSet.First;
    while not ClientDataSet.Eof do
    begin
      if DataSet['Consider'] = 'Yes' then Inc(FCountYes);
      ClientDataSet.Next;
    end;
  finally
    ClientDataSet.RecNo := Pos;
    ClientDataSet.EnableControls;
  end;

//  cdsResult.Resync([]);
end;

procedure TReport_ImplementationPlanEmployeeCashForm.ClientDataSetCalcFields(
  DataSet: TDataSet);
  var I, rnUnitCategory, rnUnit : Integer; nSum, nSumMax : Currency;

  function Max(A, B : Currency) : Currency;
  begin
    if A > B then Result := A else Result := B;
  end;

  function Min(A, B : Currency) : Currency;
  begin
    if A > B then Result := B else Result := A;
  end;

begin
  rnUnitCategory := cdsUnitCategory.RecNo;
  rnUnit := cdsUnit.RecNo;
  try
    cdsUnitCategory.DisableControls;
    cdsUnit.DisableControls;
    for I := 0 to FUnit.Count - 1 do
    begin
      if Dataset['AmountPlan' + FUnit.Strings[I]] > 0 then
        nSum := Dataset['Amount' + FUnit.Strings[I]] / Dataset['AmountPlan' + FUnit.Strings[I]] * 100
      else nSum := 0;
      Dataset['PercentAmountPlan' + FUnit.Strings[I]] := nSum;

      if Dataset['AmountPlanAward' + FUnit.Strings[I]] > 0 then
        nSum := Dataset['Amount' + FUnit.Strings[I]] / Dataset['AmountPlanAward' + FUnit.Strings[I]] * 100
      else nSum := 0;
      Dataset['PercentAmountPlanAward' + FUnit.Strings[I]] := nSum;

      nSum := 0;
      if Dataset['Amount' + FUnit.Strings[I]] < Dataset['AmountPlan' + FUnit.Strings[I]] then
      begin
        if cdsUnitCategory.Locate('UnitCategoryCode', FUnitCategory.Strings[I], []) then
          nSum := Max(Dataset['AmountPlan' + FUnit.Strings[I]] - Dataset['Amount' + FUnit.Strings[I]], 0) *
                  Dataset['Price' + FUnit.Strings[I]] * cdsUnitCategory.FieldByName('PenaltyNonMinPlan').AsCurrency / 100;
      end;
      Dataset['AmountTheFine' + FUnit.Strings[I]] := nSum;

      nSum := 0;
      if (Dataset['Amount' + FUnit.Strings[I]] >= Dataset['AmountPlanAward' + FUnit.Strings[I]]) and (Dataset['AmountPlanAward' + FUnit.Strings[I]] > 0) then
      begin
        if cdsUnitCategory.Locate('UnitCategoryCode', FUnitCategory.Strings[I], []) then
          nSum := Dataset['AmountPlanAward' + FUnit.Strings[I]] * Dataset['Price' + FUnit.Strings[I]] *
          (cdsUnitCategory.FieldByName('PremiumImplPlan').AsCurrency + Dataset['AddBonusPercent' + FUnit.Strings[I]]) / 100;
      end;
      Dataset['BonusAmount' + FUnit.Strings[I]] := nSum;

      nSum := 0;
      if cdsUnit.Locate('UnitCode', FUnit.Strings[I], []) then
        nSum := Dataset['AmountPlan' + FUnit.Strings[I]] * Min(cdsUnit.FieldByName('PercentAttendance').AsCurrency, 100) / 100;
      Dataset['AmountPlanTab' + FUnit.Strings[I]] := nSum;

      if Dataset['AmountPlanTab' + FUnit.Strings[I]] > 0 then
        nSum := Dataset['Amount' + FUnit.Strings[I]] / Dataset['AmountPlanTab' + FUnit.Strings[I]] * 100
      else nSum := 0;
      Dataset['PercentAmountPlanTab' + FUnit.Strings[I]] := nSum;

      nSum := 0;
      if cdsUnit.Locate('UnitCode', FUnit.Strings[I], []) then
        nSum := Dataset['AmountPlanAward' + FUnit.Strings[I]] * Min(cdsUnit.FieldByName('PercentAttendance').AsCurrency, 100) / 100;
      Dataset['AmountPlanAwardTab' + FUnit.Strings[I]] := nSum;

      if Dataset['AmountPlanAwardTab' + FUnit.Strings[I]] > 0 then
        nSum := Dataset['Amount' + FUnit.Strings[I]] / Dataset['AmountPlanAwardTab' + FUnit.Strings[I]] * 100
      else nSum := 0;
      Dataset['PercentAmountPlanAwardTab' + FUnit.Strings[I]] := nSum;

      nSum := 0;
      if Dataset['Amount' + FUnit.Strings[I]] < Dataset['AmountPlanTab' + FUnit.Strings[I]] then
      begin
        if cdsUnitCategory.Locate('UnitCategoryCode', FUnitCategory.Strings[I], []) then
          nSum := Max(Dataset['AmountPlanTab' + FUnit.Strings[I]] - Dataset['Amount' + FUnit.Strings[I]], 0) *
                  Dataset['Price' + FUnit.Strings[I]] * cdsUnitCategory.FieldByName('PenaltyNonMinPlan').AsCurrency / 100;
      end;
      Dataset['AmountTheFineTab' + FUnit.Strings[I]] := nSum;

      nSum := 0;
      if (Dataset['Amount' + FUnit.Strings[I]] >= Dataset['AmountPlanAwardTab' + FUnit.Strings[I]]) and (Dataset['AmountPlanAwardTab' + FUnit.Strings[I]] > 0) then
      begin
        if cdsUnitCategory.Locate('UnitCategoryCode', FUnitCategory.Strings[I], []) then
          nSum := Dataset['Amount' + FUnit.Strings[I]] * Dataset['Price' + FUnit.Strings[I]] *
          (cdsUnitCategory.FieldByName('PremiumImplPlan').AsCurrency + Dataset['AddBonusPercent' + FUnit.Strings[I]]) / 100;
      end;
      Dataset['BonusAmountTab' + FUnit.Strings[I]] := nSum;
    end;

    nSum := 0;
    for I := 0 to FUnit.Count - 1 do nSum := nSum + Dataset['Amount' + FUnit.Strings[I]];
    Dataset['Amount'] := nSum;

//    nSum := 0; nSumMax := 0;
//    for I := 0 to FUnit.Count - 1 do
//    begin
//      nSum := nSum + Dataset['AmountPlanTab' + FUnit.Strings[I]];
//      nSumMax := Max(nSumMax, Dataset['AmountPlanTab' + FUnit.Strings[I]]);
//    end;
//    Dataset['AmountPlanTab'] := Min(nSum, nSumMax);
    Dataset['AmountPlanTab'] := Dataset['AmountPlanTab' + FUnit.Strings[FUnitCalck]];
    Dataset['AmountPlan'] := Dataset['AmountPlan' + FUnit.Strings[FUnitCalck]];

//    nSum := 0; nSumMax := 0;
//    for I := 0 to FUnit.Count - 1 do
//    begin
//      nSum := nSum + Dataset['AmountPlanAwardTab' + FUnit.Strings[I]];
//      nSumMax := Max(nSumMax, Dataset['AmountPlanAwardTab' + FUnit.Strings[I]]);
//    end;
//    Dataset['AmountPlanAwardTab'] := Min(nSum, nSumMax);
    Dataset['AmountPlanAwardTab'] := Dataset['AmountPlanAwardTab' + FUnit.Strings[FUnitCalck]];
    Dataset['AmountPlanAward'] := Dataset['AmountPlanAward' + FUnit.Strings[FUnitCalck]];

//    nSum := 0;
//    for I := 0 to FUnit.Count - 1 do nSum := nSum + Dataset['AmountTheFineTab' + FUnit.Strings[I]];
//    Dataset['AmountTheFineTab'] := nSum;

    nSum := 0;
    if Dataset['Amount'] < Dataset['AmountPlanTab'] then
    begin
      if cdsUnitCategory.Locate('UnitCategoryCode', FUnitCategoryID, []) then
        nSum := Max(Dataset['AmountPlanTab'] - Dataset['Amount'], 0) *
                Dataset['Price' + FUnit.Strings[FUnitCalck]] * cdsUnitCategory.FieldByName('PenaltyNonMinPlan').AsCurrency / 100;
    end;
    Dataset['AmountTheFineTab'] := nSum;

//    nSum := 0;
//    for I := 0 to FUnit.Count - 1 do nSum := nSum + Dataset['BonusAmountTab' + FUnit.Strings[I]];
//    Dataset['BonusAmountTab'] := nSum;

    nSum := 0;
    if (Dataset['Amount'] >= Dataset['AmountPlanAwardTab']) and (Dataset['AmountPlanAwardTab'] > 0) then
    begin
      if cdsUnitCategory.Locate('UnitCategoryCode', FUnitCategoryID, []) then
        nSum := Dataset['Amount'] * Dataset['Price' + FUnit.Strings[FUnitCalck]] *
        (cdsUnitCategory.FieldByName('PremiumImplPlan').AsCurrency + Dataset['AddBonusPercent' + FUnit.Strings[FUnitCalck]]) / 100;
    end;
    Dataset['BonusAmountTab'] := nSum;

    nSum := 0;
    if (Dataset['Amount'] >= Dataset['AmountPlanAwardTab']) and (Dataset['AmountPlanAwardTab'] > 0) and
       (Dataset['AddBonusPercent' + FUnit.Strings[FUnitCalck]] > 0) then
    begin
      if cdsUnitCategory.Locate('UnitCategoryCode', FUnitCategoryID, []) then
        nSum := Dataset['Amount'] * Dataset['Price' + FUnit.Strings[FUnitCalck]] *
        (Dataset['AddBonusPercent' + FUnit.Strings[FUnitCalck]]) / 100;
    end;

    Dataset['BonusPercentSum'] := nSum;

    nSum := 0;
    if (Dataset['Amount'] >= Dataset['AmountPlanAwardTab']) and (Dataset['AmountPlanAwardTab'] > 0) and
       (Dataset['AddBonusPercent' + FUnit.Strings[FUnitCalck]] > 0) then
    begin
      if cdsUnitCategory.Locate('UnitCategoryCode', FUnitCategoryID, []) then
        nSum := Dataset['Amount'] * Dataset['Price' + FUnit.Strings[FUnitCalck]] *
        (Dataset['AddBonusPercent' + FUnit.Strings[FUnitCalck]] + Dataset['AddBonusPercentAdd']) / 100;
    end;

    Dataset['BonusPercentAddSum'] := nSum;

    if (FCountFixedPercent * FFixedPercent < 45) and (StartOfTheMonth(deStart.Date) >= EncodeDate(202, 09, 01)) and
      (Dataset['BonusPercentSum'] > 0) then
    begin
      if (Dataset['BonusAmountTab'] - Dataset['BonusPercentSum'] * 0.3) > 0 then
        Dataset['BonusAmountTab'] := Dataset['BonusAmountTab'] - Dataset['BonusPercentSum'] * 0.3
      else Dataset['BonusAmountTab'] := 0;
    end;

    // Dataset['isFixedPercent'] := Dataset['isFixedPercent' + FUnit.Strings[FUnitCalck]];

    Dataset['AddBonusPercent'] := Dataset['AddBonusPercent' + FUnit.Strings[FUnitCalck]];

  finally
    cdsUnitCategory.RecNo := rnUnitCategory;
    cdsUnit.RecNo := rnUnit;
    cdsUnitCategory.EnableControls;
    cdsUnit.EnableControls;
  end;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.ClientDataSetFilterRecord(
  DataSet: TDataSet; var Accept: Boolean);
  var I, rnUnit : Integer; nAmount, nAmountPlan, nAmountPlanAward : Currency;

  function Min(A, B : Currency) : Currency;
  begin
    if A > B then Result := B else Result := A;
  end;

begin
  if not cbHighlightStrings.Checked then Exit;
  if cbFilter1.Checked and cbFilter2.Checked and cbFilter3.Checked then Exit;
  nAmount := 0; nAmountPlan := 0; nAmountPlanAward := 0;

  for I := 0 to FUnit.Count - 1 do
    nAmount := nAmount + Dataset['Amount' + FUnit.Strings[I]];

  if StartOfTheMonth(deStart.Date) < StartOfTheMonth(Date)  then
  begin
    rnUnit := cdsUnit.RecNo;
    try
      cdsUnit.DisableControls;
      if cdsUnit.Locate('UnitCode', FUnit.Strings[FUnitCalck], []) then
      begin
        nAmountPlan := nAmountPlan + Dataset['AmountPlan' + FUnit.Strings[FUnitCalck]] * Min(cdsUnit.FieldByName('PercentAttendance').AsCurrency, 100) / 100;;
        nAmountPlanAward := nAmountPlanAward + Dataset['AmountPlanAward' + FUnit.Strings[FUnitCalck]] * Min(cdsUnit.FieldByName('PercentAttendance').AsCurrency, 100) / 100;
      end;
    finally
      cdsUnit.RecNo := rnUnit;
      cdsUnit.EnableControls;
    end;
  end else
  begin
    nAmountPlan := nAmountPlan + Dataset['AmountPlan' + FUnit.Strings[FUnitCalck]];
    nAmountPlanAward := nAmountPlanAward + Dataset['AmountPlanAward' + FUnit.Strings[FUnitCalck]];
  end;

  if not cbFilter1.Checked and (nAmount < nAmountPlan) then Accept := False
  else if not cbFilter2.Checked and (nAmount >= nAmountPlan) and (nAmount < nAmountPlanAward) then Accept := False
  else if not cbFilter3.Checked and (nAmount >= nAmountPlanAward) then Accept := False;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.colGroupNameStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  if ARecord.Values[colisFixedPercent.Index] or (ARecord.Values[colAddBonusPercent.Index] <> 0) then
  begin
    FStyle.TextColor := clWindowText;
    FStyle.Color := $00BAE1FE;
    AStyle := FStyle
  end else
  begin
    FStyle.TextColor := clWindowText;
    FStyle.Color := clWindow;
    AStyle := FStyle
  end;

  if cbHighlightStrings.Checked and (AItem.Index <> colisFixedPercent.Index) and (AItem.Index <> colAddBonusPercent.Index) then
  begin
    if StartOfTheMonth(deStart.Date) < StartOfTheMonth(Date)  then
    begin
      if ARecord.Values[colAmount.Index] < ARecord.Values[colAmountPlanTab.Index] then FStyle.TextColor := clRed
      else if ARecord.Values[colAmount.Index] < ARecord.Values[colAmountPlanAwardTab.Index] then FStyle.TextColor := clGreen
      else FStyle.TextColor := clBlue;
      AStyle := FStyle
    end else if Assigned(FAmountPlan) and Assigned(FAmountPlanAward) then
    begin
      if ARecord.Values[colAmount.Index] < ARecord.Values[FAmountPlan.Index] then FStyle.TextColor := clRed
      else if ARecord.Values[colAmount.Index] < ARecord.Values[FAmountPlanAward.Index] then FStyle.TextColor := clGreen
      else FStyle.TextColor := clBlue;
      AStyle := FStyle
    end;
  end;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.cbFilter1Click(
  Sender: TObject);
begin
  if cbHighlightStrings.Checked then
  try
    ClientDataSet.DisableControls;
    ClientDataSet.Filtered := False;
    ClientDataSet.Filtered := not cbFilter1.Checked or not cbFilter2.Checked or not cbFilter3.Checked or
      (Trim(edFilter.Text) <> '');
  finally
    ClientDataSet.EnableControls;
  end;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.cxImplementationPlanEmployeeDBBandedTableView1TcxGridDBDataControllerTcxDataSummaryFooterSummaryItems2GetText(
  Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
  var AText: string);
begin
  AText := IntToStr(FCountYes);
end;

procedure TReport_ImplementationPlanEmployeeCashForm.cxImplementationPlanEmployeeDBBandedTableView1TcxGridDBDataControllerTcxDataSummaryFooterSummaryItems3GetText(
  Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
  var AText: string);
  var Count, Pos : Integer;
begin
  if not ClientDataSet.Active then Exit;
  AText := IntToStr(FCountO);
end;

procedure TReport_ImplementationPlanEmployeeCashForm.cxImplementationPlanEmployeeDBBandedTableView1TcxGridDBDataControllerTcxDataSummaryFooterSummaryItems4GetText(
  Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
  var AText: string);
begin
  if not ClientDataSet.Active then Exit;
  AText := IntToStr(ClientDataSet.RecordCount - FCountO);
end;

procedure TReport_ImplementationPlanEmployeeCashForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  UserSettingsStorageAddOn.SaveUserSettings;
  Action:=caFree;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.FormCreate(Sender: TObject);
begin
  FUnit := TStringList.Create;
  FUnitCategory := TStringList.Create;
  FCountO := 0;
  FCountAllO := 0;
  FUnitCalck := 0;
  FCountFixedPercent := 0;
  FCountFixed := 0;
  FFixedPercent := 1;
  FAmountPlan := Nil;
  FAmountPlanAward := Nil;
  UserSettingsStorageAddOn.LoadUserSettings;
  FStyle := TcxStyle.Create(nil);
  ExecuteDialog.Execute;
end;

procedure TReport_ImplementationPlanEmployeeCashForm.FormDestroy(Sender: TObject);
begin
  FStyle.Free;
  FUnit.Free;
  FUnitCategory.Free;
end;

end.
