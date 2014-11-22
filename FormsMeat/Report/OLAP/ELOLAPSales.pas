unit ELOLAPSales;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ELCustomDataEditor, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, cxLabel, Oracle,
  ELOracleSession, ActnList, ELActionList, cxGridLevel,                                                                   
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxControls, cxGridCustomView, cxGrid, ELGrid, NxCollection, ELFlipPanel,
  cxTextEdit, cxMemo, cxRichEdit, cxContainer, ELLabel, ExtCtrls,
  ELGroupPanel, HProcess, xlcClasses, xlEngine, xlReport, ProgressImage,
  OracleData, ELOracleDataSet, cxGridDBBandedTableView, cxGridBandedTableView,
  StdCtrls, ELMemo, cxCurrencyEdit, cxCheckBox, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle,
  dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary,
  dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin,
  dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp,
  dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, upsmilestile,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomPivotGrid, cxPivotGrid,
  cxDBPivotGrid, ELOlapSalesUnit, ThreadProgress, cxLocalization;

type

  // Перекрыли класс, что бы добраться до private метода GetViewInfoClass
  TcxGridDBBandedTableView = class (cxGridDBBandedTableView.TcxGridDBBandedTableView)
    function GetViewInfoClass: TcxCustomGridViewInfoClass; override;
  end;

  TcxDBPivotGrid = class(cxDBPivotGrid.TcxDBPivotGrid)
  protected
    function CreateController: TcxPivotGridController; override;
  end;

  TELfrmOLAPSales = class(TELfrmCustomDataEditor)
    odsRepData: TOracleDataSet;
    dsrRepData: TDataSource;
    hpReport: THProcess;
    acExcel: TELAction;
    acShowDetail: TELAction;
    cxDBPivotGrid: TcxDBPivotGrid;
    gpRepHeader: TELGroupPanel;
    lblRepName: TELLabel;
    reRepReportData: TcxRichEdit;
    ProgessImg: TProgessImg;
    cxLocalizer: TcxLocalizer;
    cxGridLevel: TcxGridLevel;
    cxGrid: TELGrid;
    tvReport: TcxGridDBBandedTableView;
    reRepFilter: TcxRichEdit;

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure hpReportExecute(HP: THProcess);
    procedure hpReportStart(HP: THProcess);
    procedure hpReportTerminate(HP: THProcess);
    procedure tvReportDataControllerSummaryAfterSummary(
      ASender: TcxDataSummary);
    procedure acExcelExecute(Sender: TObject);
    procedure odsRepDataCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    UniqueList: TStringList;
    DataFields: TStringList;
    FELOlapSaleReportOption: TELOlapSaleReportOption;
    FIsFirstShow: boolean;
    FReportTime: TDateTime;
    FMaxRecordCount: integer;
    procedure CalcRepData;
    procedure FillPivot;
    procedure FillGrid;
  protected
    procedure LoadData; override;
    function IsDataChanged: Boolean; override;
  public
    function InitForm: Boolean; override;
  end;

var
  ELfrmOLAPSales: TELfrmOLAPSales;

implementation

uses ELClasses, RESELSales, ELEnv, ELIntrf, ComObj, ELDialogs, ELdmExportToXl, ELGridGroupCalculate,
     cxGridExportLink, cxExportPivotGridLink, StrUtils, cxFilterControlDialog;

{$R *.dfm}
{$R upsmileRus.res}
type

  // Перекрыли метод SupportsGroupSummariesAlignedWithColumns что бы в группах ячейки отражались в той же последовательности что и колонки
  TmyViewInfo = class (TcxGridBandedTableViewInfo)
    function SupportsGroupSummariesAlignedWithColumns: Boolean; override;
  end;


{ TELfrmRepControlMarkUp }

function TELfrmOLAPSales.InitForm: Boolean;
begin
  Result := inherited InitForm;
  lblRepName.Caption := 'Отчет по реализации ' + lblRepName.Caption;//CPT_CONTRL_MARKUP_REPORT_NAME;
end;

procedure TELfrmOLAPSales.LoadData;
var
  S: string;
  LPFGetParam: IELPFGetParams;
begin
  inherited;
  GetSession.DataDateTime := Trunc(ELEnvironment.SysDate);
//  odsRepData.Session.DataDateTime := Trunc(ELEnvironment.SysDate);
  odsRepData.Session := GetSession;
  odsRepData.DeleteVariables;

  if Assigned(GetLaunchInfo.ParentObject) and
    GetLaunchInfo.ParentObject.GetInterface(IELPFGetParams, LPFGetParam) then

  begin

    FMaxRecordCount := LPFGetParam.GetParamData(2).Items[0].GetFieldValue('MaxRecordCount');
    FELOlapSaleReportOption := TELOlapSaleReportOption(Integer(LPFGetParam.GetParamData(2).Items[0].GetFieldValue('OlapSaleReportOption')));

    S := ' за период с ' + DateToStr(FELOlapSaleReportOption.FromDate) + ' по ' + DateToStr(FELOlapSaleReportOption.ToDate);

    lblRepName.Caption := S;

    reRepReportData.Lines.Add('Тип периода: ' + LPFGetParam.GetParamData(2).Items[0].GetFieldValue('PeriodType'));

    reRepFilter.Text := StringReplace(TStringList(Integer(LPFGetParam.GetParamData(2).Items[0].GetFieldValue('FilterList'))).Text, '=', ': ', [rfReplaceAll]);

  end;
  Application.ProcessMessages;
end;

procedure TELfrmOLAPSales.FormShow(Sender: TObject);
begin
  inherited;
  if FIsFirstShow then
  begin
    cxLocalizer.Active := true;
    cxLocalizer.Locale:= 1049;
    FIsFirstShow := False;
    hpReport.Execute;
  end;
end;

procedure TELfrmOLAPSales.FormCreate(Sender: TObject);
begin
  inherited;
  FIsFirstShow := True;
  Application.ProcessMessages;
  UniqueList := TStringList.Create;
  DataFields := TStringList.Create;
end;

procedure TELfrmOLAPSales.hpReportExecute(HP: THProcess);
begin
  inherited;
  CalcRepData;
end;

procedure TELfrmOLAPSales.hpReportStart(HP: THProcess);
begin
  inherited;
  Application.ProcessMessages;
  Screen.Cursor := crHourGlass;
  FReportTime := Now;
  ProgessImg.BeginUpdateProgress;
  Application.ProcessMessages;
end;

procedure TELfrmOLAPSales.hpReportTerminate(HP: THProcess);
begin
  if odsRepData.RecordCount * odsRepData.FieldCount > FMaxRecordCount then begin
     ELShowMessage('Количество записей выбранных Вами: ' + IntToStr(odsRepData.RecordCount * odsRepData.FieldCount) +
                    #13' Измените условия');
     Screen.Cursor := crDefault;
     ProgessImg.EndUpdateProgress;
     ELenvironment.FormList.CloseForm(Self);
  end
  else begin
    // В зависимости от выбранного пользователем типа отображения строим или Pivot или обычный grid
    if FELOlapSaleReportOption.isOLAPonServer then
       FillGrid
    else
       FillPivot;
    reRepReportData.Text := reRepReportData.Text + 'Время построения отчета ' +  TimeToStr(Now - FReportTime);
    Screen.Cursor := crDefault;
    ProgessImg.EndUpdateProgress;
  end;
end;

procedure TELfrmOLAPSales.CalcRepData;
var
  FieldDefs: TFieldDefs;
  i: integer;
  //OracleSession: TELOracleSession;
begin
  //OracleSession := GetSession;
  //try
  //  OracleSession.DataDateTime := Trunc(ELEnvironment.SysDate);
  //except end;
  //odsRepData.Session := OracleSession;
  FieldDefs := TFieldDefs.Create(odsRepData);
  odsRepData.DeleteVariables;
  odsRepData.DeclareAndSet('LSQL', otSubst, TELOlapSalers.CreateSQLExpression(FELOlapSaleReportOption, FieldDefs, DataFields));

  if odsRepData.Active then
     odsRepData.Close;

  if FELOlapSaleReportOption.isOLAPonServer then begin
    odsRepData.FieldDefs.Clear;
    odsRepData.FieldDefs.Assign(FieldDefs);
    for i := 0 to odsRepData.FieldDefs.Count - 1 do
        odsRepData.FieldDefs[i].CreateField(odsRepData);

    if FELOlapSaleReportOption.isOLAPonServer and (FELOlapSaleReportOption.SummaryType <> stNone) then
      for i := 0 to FELOlapSaleReportOption.FieldCount - 1 do
          if FELOlapSaleReportOption.Objects[i] is TDataOLAPField then
             with FELOlapSaleReportOption.Objects[i] do
               if Visible then
                  with FieldDefs.AddFieldDef do begin
                    Name := 'ITOG_' + FieldName;
                    DataType := ftFloat;
                    CreateField(odsRepData).FieldKind := fkCalculated;
                  end;
  end;

  odsRepData.Open;
  reRepReportData.Lines.Add('Дата построения отчета ' +  DateTimeToStr(Now));
  reRepReportData.Lines.Add('Запрос отработал за ' +  TimeToStr(Now - FReportTime));
end;

function TELfrmOLAPSales.IsDataChanged: Boolean;
begin
  Result := False;
end;

procedure TELfrmOLAPSales.FillGrid;
var
   LBand: TcxGridBand;
   LClmn: TcxGridDBBandedColumn;
   List, LBands: TStringList;
   i, j, ItogBandIndex: integer;
begin
  List := TStringList.Create;
  // Начинаем подготовку данных
  cxGrid.BeginUpdate;
  tvReport.DataController.DataSource := dsrRepData;
  tvReport.DataController.CreateAllItems;
  tvReport.DataController.Filter.AutoDataSetFilter := false;
  tvReport.OptionsCustomize.ColumnGrouping := True;
  tvReport.OptionsView.GridLines := glBoth;
  tvReport.OptionsView.GridLineColor := $00C8D0D4;

  for i := 0 to tvReport.ColumnCount - 1 do
    tvReport.Columns[i].Visible := false;

  LBand := tvReport.Bands.Add;
  if Assigned(LBand) then
  begin
    LBand.Caption := '';
    LBand.FixedKind := fkLeft;
    LBand.Options.HoldOwnColumnsOnly := true;
    LBand.Options.Moving := false;
  end;

  // Создаем список для хранения данных о созданных Band
  LBands := TStringList.Create;
  try
    // В итераторе заполняем бенды и устанавливаем им заголовки

    with FELOlapSaleReportOption.GetIterator do
      while HasNextItem do
        if List.IndexOf(Item) = -1 then begin
           List.Add(Item);
           with tvReport.Bands.Add do begin
             Caption := Item;
             Options.Moving := false;
             LBands.Values[Caption] := IntToStr(Index);
           end;
        end;

    for i := 0 to FELOlapSaleReportOption.FieldCount - 1 do
      if FELOlapSaleReportOption.Objects[i].Visible then begin
         LClmn := tvReport.GetColumnByFieldName(FELOlapSaleReportOption.Objects[i].FieldName);
         if Assigned(LClmn) then begin
            LClmn.Caption := FELOlapSaleReportOption.Objects[i].Caption;
            LClmn.Position.BandIndex := LBand.Index;
            LClmn.Visible := true;
            LClmn.Width := 200;
            with FELOlapSaleReportOption.Objects[i] as TDimensionOLAPField do
              if Alignment <> null then begin
                 LClmn.PropertiesClass := TcxTextEditProperties;
                 TcxTextEditProperties(LClmn.Properties).Alignment.Horz := Alignment;
              end;
         end;
         if FELOlapSaleReportOption.Objects[i] is TDataOLAPField then begin
            for j := 0 to LBands.Count - 1 do begin
              LClmn := tvReport.GetColumnByFieldName(LBands.Names[j] + '_' + FELOlapSaleReportOption.Objects[i].FieldName);
              if Assigned(LClmn) then begin
                 LClmn.Caption := FELOlapSaleReportOption.Objects[i].Caption;
                 LClmn.Position.BandIndex := StrToInt(LBands.Values[LBands.Names[j]]);
                 LClmn.Width := 80;
                 LClmn.PropertiesClass := TcxCurrencyEditProperties;
                 TcxCurrencyEditProperties(LClmn.Properties).DisplayFormat := TDataOLAPField(FELOlapSaleReportOption.Objects[i]).DisplayFormat;
                 LClmn.Visible := true;
                 LClmn.Options.Moving := false;
                 case TDataOLAPField(FELOlapSaleReportOption.Objects[i]).SummaryType of
                    stSum: LClmn.Summary.FooterKind := skSum;
                    stPercent: LClmn.Summary.FooterKind := skSum;
                 end;
                 LClmn.Summary.FooterFormat := TDataOLAPField(FELOlapSaleReportOption.Objects[i]).DisplayFormat;
                 LClmn.Summary.GroupFooterKind := LClmn.Summary.FooterKind;
                 LClmn.Summary.GroupFooterFormat := LClmn.Summary.FooterFormat;
              end;
            end;
         end;
      end;

    if FELOlapSaleReportOption.isOLAPonServer and (FELOlapSaleReportOption.SummaryType <> stNone) then begin
       with tvReport.Bands.Add do begin
         Caption := 'Итого';
         ItogBandIndex := Index;
       end;

       for i := 0 to FELOlapSaleReportOption.FieldCount - 1 do
         if FELOlapSaleReportOption.Objects[i] is TDataOLAPField then
            with TDataOLAPField(FELOlapSaleReportOption.Objects[i]) do
              if Visible then begin
                LClmn := tvReport.GetColumnByFieldName('ITOG_' + FieldName);
                if Assigned(LClmn) then begin
                   LClmn.PropertiesClass := TcxCurrencyEditProperties;
                   if FELOlapSaleReportOption.SummaryType in [stCount, stUniqueCount] then
                      TcxCurrencyEditProperties(LClmn.Properties).DisplayFormat := '0'
                   else
                      TcxCurrencyEditProperties(LClmn.Properties).DisplayFormat := DisplayFormat;
                   LClmn.Visible := true;
                   LClmn.Position.BandIndex := ItogBandIndex;
                   LClmn.Caption := Caption;
                   case FELOlapSaleReportOption.SummaryType of
                      stSum:     LClmn.Summary.FooterKind := skSum;
                      stMin:     LClmn.Summary.FooterKind := skMin;
                      stMax:     LClmn.Summary.FooterKind := skMax;
                      stAverage: LClmn.Summary.FooterKind := skAverage;
                      stCount, stUniqueCount:   LClmn.Summary.FooterKind := skCount;
                   end;
                   LClmn.Summary.FooterFormat := TcxCurrencyEditProperties(LClmn.Properties).DisplayFormat;
                   LClmn.Summary.GroupFooterKind := LClmn.Summary.FooterKind;
                   LClmn.Summary.GroupFooterFormat := LClmn.Summary.FooterFormat;
                end;
              end;
    end;

    for i := 0 to tvReport.Bands.Count - 1 do
        tvReport.Bands[i].Caption := AnsiReplaceStr(tvReport.Bands[i].Caption, '''', '');

    cxGrid.Align := alClient;
    cxGrid.Visible := true;
    cxGrid.EndUpdate;
  finally
    LBands.Free;
    List.Free;
    cxGrid.Align := alClient;
    cxGrid.EndUpdate;
    cxGrid.Visible := true;
  end;     
end;

procedure TELfrmOLAPSales.FillPivot;
var i: integer;
    DataIndex, DimensionIndex, DateIndex: integer;
begin
  inherited;
  DataIndex := 0;
  DimensionIndex := 0;
  DateIndex := 0;

  cxDBPivotGrid.BeginUpdate;
  try
    cxDBPivotGrid.DataSource := dsrRepData;
    cxDBPivotGrid.CreateAllFields;
    for i := 0 to FELOlapSaleReportOption.FieldCount - 1 do begin
      if FELOlapSaleReportOption.Objects[i].Visible then begin
         with cxDBPivotGrid.GetFieldByName(FELOlapSaleReportOption.Objects[i].FieldName) do begin
           if FELOlapSaleReportOption.Objects[i] is TDataOLAPField then begin
              DisplayFormat := (FELOlapSaleReportOption.Objects[i] as TDataOLAPField).DisplayFormat;
              Area := faData;
              AreaIndex := DataIndex;
              inc(DataIndex);
            end;
           if FELOlapSaleReportOption.Objects[i] is TDateOLAPField then begin
              Area := faColumn;
              AreaIndex := DateIndex;
              inc(DateIndex);
            end;
           if FELOlapSaleReportOption.Objects[i] is TDimensionOLAPField then begin
              Area := faRow;
              AreaIndex := DimensionIndex;
              inc(DimensionIndex);
            end;
            Caption := FELOlapSaleReportOption.Objects[i].Caption;
         end;
      end;
    end;
  finally
    cxDBPivotGrid.Align := alClient;
    cxDBPivotGrid.EndUpdate;
    cxDBPivotGrid.Visible := true;
  end;
end;

procedure TELfrmOLAPSales.tvReportDataControllerSummaryAfterSummary(
  ASender: TcxDataSummary);

  function Groups: TcxDataControllerGroups;
  begin
    Result := ASender.DataController.Groups;
  end;

  procedure CalcGroupSummariesByDataGroupIndex(ADataGroupIndex: Integer);
  var
    I: Integer;
  begin
    if Groups.Level[ADataGroupIndex] >= Groups.GroupingItemCount - 1 then
      Exit;
    for I := 0 to Groups.ChildCount[ADataGroupIndex] - 1 do
    begin
      TCalculateGroupValues.CalculateValues(FELOlapSaleReportOption, ASender.GroupSummaryItems[Groups.Level[Groups.ChildDataGroupIndex[ADataGroupIndex, I]]],
           TSetGroupValues.Create(Groups.ChildDataGroupIndex[ADataGroupIndex, I], ASender), tvReport, false);
      CalcGroupSummariesByDataGroupIndex(Groups.ChildDataGroupIndex[ADataGroupIndex, I]);
    end;
  end;
begin
  // Расчет вычисляемых значений для групп
  CalcGroupSummariesByDataGroupIndex(-1);
  // Расчет вычисляемых значений для футеров
  TCalculateGroupValues.CalculateValues(FELOlapSaleReportOption, ASender.FooterSummaryItems,
             TSetFooterValues.Create(ASender), tvReport);
end;

{ TcxGridDBBandedTableView }

function TcxGridDBBandedTableView.GetViewInfoClass: TcxCustomGridViewInfoClass;
begin
  result := TmyViewInfo;
end;

{ TmyViewInfo }

function TmyViewInfo.SupportsGroupSummariesAlignedWithColumns: Boolean;
begin
  result := true;
end;

{ TcxDBPivotGrid }

function TcxDBPivotGrid.CreateController: TcxPivotGridController;
begin
  Result := TmycxPivotGridController.Create(Self);
end;


procedure TELfrmOLAPSales.acExcelExecute(Sender: TObject);
var Excel: OleVariant;
begin
  inherited;
  if cxGrid.Visible then
     TdmExportToXl.RunReport(cxGrid)
  else begin
     cxExportPivotGridToExcel('temp', cxDBPivotGrid);
     Excel := CreateOleObject('Excel.Application');
     Excel.Workbooks.Open(GetCurrentDir + '\temp.xls');
     Excel.Visible := True;
  end;   
end;

procedure TELfrmOLAPSales.odsRepDataCalcFields(DataSet: TDataSet);
   function ItogCalculate(ItogName: string): double;
   var j: integer;
       RecordCount: integer;
   begin
     result := 0;
     RecordCount := 0;
     if FELOlapSaleReportOption.SummaryType = stUniqueCount then
        UniqueList.Clear;
     for j := 0 to DataFields.Count - 1 do
       if Pos(ItogName, DataFields[j]) > 0 then
          case FELOlapSaleReportOption.SummaryType of
            stSum:
               result := result + DataSet.FieldByName(DataFields[j]).asFloat;
            stMin:
              begin
                if result = 0 then
                   result := DataSet.FieldByName(DataFields[j]).asFloat;
                if DataSet.FieldByName(DataFields[j]).asFloat < result then
                   result := DataSet.FieldByName(DataFields[j]).asFloat;
              end;
            stMax:
              begin
                if result = 0 then
                   result := DataSet.FieldByName(DataFields[j]).asFloat;
                if DataSet.FieldByName(DataFields[j]).asFloat > result then
                   result := DataSet.FieldByName(DataFields[j]).asFloat;
              end;
            stCount:
               if abs(DataSet.FieldByName(DataFields[j]).asFloat) >= 0.01 then
                  result := result + 1;
            stAverage:
              begin
                result := result + DataSet.FieldByName(DataFields[j]).asFloat;
                inc(RecordCount);
              end;
            stUniqueCount:
               if (DataSet.FieldByName(DataFields[j]).AsString <> '') and
                  (DataSet.FieldByName(DataFields[j]).AsString <> '0') then
                  if UniqueList.IndexOf(DataSet.FieldByName(DataFields[j]).AsString) > -1 then
                     UniqueList.Add(DataSet.FieldByName(DataFields[j]).AsString);
          end;
          case FELOlapSaleReportOption.SummaryType of
            stAverage:
              if RecordCount <> 0 then
                 result := result / RecordCount;
            stUniqueCount:
              result := UniqueList.Count;
          end;
   end;
var
   i: integer;
begin
  for i := 0 to FELOlapSaleReportOption.FieldCount - 1 do
    if FELOlapSaleReportOption.Objects[i] is TDataOLAPField then
       with FELOlapSaleReportOption.Objects[i] do
         if Visible then
            DataSet.FieldByName('ITOG_' + FieldName).asFloat := ItogCalculate(FieldName);
end;

initialization
  RegisterClass(TELfrmOLAPSales);

finalization
  UnRegisterClass(TELfrmOLAPSales);

end.
