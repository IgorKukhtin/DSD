unit OLAPSales;

interface

uses DataModul, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxClasses,
  cxCustomData, cxStyles, cxEdit, cxContainer, cxFilter, cxData, cxDataStorage,
  Data.DB, cxDBData, System.Classes, Vcl.ActnList, cxGridDBTableView,
  cxGridLevel, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, cxTextEdit, cxMemo,
  cxRichEdit, cxLabel, Vcl.ExtCtrls, Vcl.Controls, cxCustomPivotGrid,
  cxDBPivotGrid, Vcl.Forms, dsdOLAP, dsdAddOn, cxPropertiesStore, dxBarExtItems,
  dxBar, dsdDB, Datasnap.DBClient, dsdAction, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type

  // Перекрыли класс, что бы добраться до private метода GetViewInfoClass
  TcxGridDBBandedTableView = class (cxGridDBBandedTableView.TcxGridDBBandedTableView)
    function GetViewInfoClass: TcxCustomGridViewInfoClass; override;
  end;

  TcxDBPivotGrid = class(cxDBPivotGrid.TcxDBPivotGrid)
  protected
    function CreateController: TcxPivotGridController; override;
  end;

  TOLAPSalesForm = class(TForm)
    cxDBPivotGrid: TcxDBPivotGrid;
    gpRepHeader: TPanel;
    lblRepName: TcxLabel;
    reRepReportData: TcxRichEdit;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    tvReport: TcxGridDBBandedTableView;
    reRepFilter: TcxRichEdit;
    MasterCDS: TClientDataSet;
    MasterDS: TDataSource;
    spSelect: TdsdStoredProc;
    BarManager: TdxBarManager;
    Bar: TdxBar;
    bbRefresh: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    cxPropertiesStore: TcxPropertiesStore;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    sbDataEditor: TScrollBox;
    bbExcel: TdxBarButton;
    dsdGridToExcel: TdsdGridToExcel;

    procedure FormCreate(Sender: TObject);

    procedure tvReportDataControllerSummaryAfterSummary(
      ASender: TcxDataSummary);
    procedure odsRepDataCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    UniqueList: TStringList;
    DataFields: TStringList;
    FIsFirstShow: boolean;
    FReportTime: TDateTime;
    FMaxRecordCount: integer;
    procedure FillPivot;
    procedure FillGrid;
    procedure CalcRepData;
  public
    OlapReportOption: TOlapReportOption;
    function InitForm: Boolean;
    procedure hpReportExecute;
    procedure hpReportTerminate;
  end;

implementation

uses Dialogs, SysUtils, Variants, GridGroupCalculate, cxCurrencyEdit, StrUtils,
UtilConvert;
{ComObj, cxGridExportLink, cxExportPivotGridLink, cxFilterControlDialog;}

{$R *.dfm}
type

  // Перекрыли метод SupportsGroupSummariesAlignedWithColumns что бы в группах ячейки отражались в той же последовательности что и колонки
  TmyViewInfo = class (TcxGridBandedTableViewInfo)
    function SupportsGroupSummariesAlignedWithColumns: Boolean; override;
  end;


{ TELfrmRepControlMarkUp }

function TOLAPSalesForm.InitForm: Boolean;
begin
  lblRepName.Caption := 'Отчет по реализации ' + lblRepName.Caption;//CPT_CONTRL_MARKUP_REPORT_NAME;
end;

procedure TOLAPSalesForm.FormCreate(Sender: TObject);
begin
  inherited;
  FIsFirstShow := True;
  Application.ProcessMessages;
  UniqueList := TStringList.Create;
  DataFields := TStringList.Create;
end;

procedure TOLAPSalesForm.hpReportExecute;
begin
  inherited;
  FReportTime := Now;
  CalcRepData;
end;


procedure TOLAPSalesForm.hpReportTerminate;
begin
  FMaxRecordCount := 100000000;
  if MasterCDS.RecordCount * MasterCDS.FieldCount > FMaxRecordCount then begin
     ShowMessage('Количество записей выбранных Вами: ' + IntToStr(MasterCDS.RecordCount * MasterCDS.FieldCount) +
                    #13' Измените условия');
     Screen.Cursor := crDefault;
     Close;
  end
  else begin
    // В зависимости от выбранного пользователем типа отображения строим или Pivot или обычный grid
    if OlapReportOption.isOLAPonServer then
       FillGrid
    else
       FillPivot;
    reRepReportData.Text := reRepReportData.Text + 'Время построения отчета ' +  TimeToStr(Now - FReportTime);
    Screen.Cursor := crDefault;
  end;
end;

procedure TOLAPSalesForm.CalcRepData;
var
  i: integer;
  FieldDefs: TFieldDefs;
begin
(*  FieldDefs := TFieldDefs.Create(MasterCDS);

  if OlapReportOption.isOLAPonServer then begin
     spSelect.ParamByName('SQL').Value := gfStrToXmlStr(TOlap.CreateSQLExpression(OlapReportOption, MasterCDS.FieldDefs, DataFields));
     spSelect.Execute;
     MasterCDS.FieldDefs.Clear;
     MasterCDS.FieldDefs.Assign(FieldDefs);
     for i := 0 to MasterCDS.FieldDefs.Count - 1 do
         MasterCDS.FieldDefs[i].CreateField(MasterCDS);

    if OlapReportOption.isOLAPonServer and (OlapReportOption.SummaryType <> stNone) then
      for i := 0 to OlapReportOption.FieldCount - 1 do
          if OlapReportOption.Objects[i] is TDataOLAPField then
             with OlapReportOption.Objects[i] do
               if Visible then
                  with FieldDefs.AddFieldDef do begin
                    Name := 'ITOG_' + FieldName;
                    DataType := ftFloat;
                    CreateField(MasterCDS).FieldKind := fkCalculated;
                  end;
  end;
  *)
  FReportTime := Now;

  spSelect.ParamByName('SQL').Value := gfStrToXmlStr(TOlap.CreateSQLExpression(OlapReportOption, MasterCDS.FieldDefs, DataFields));
  spSelect.ParamByName('inStartDate').Value := OlapReportOption.FromDate;
  spSelect.ParamByName('inEndDate').Value := OlapReportOption.ToDate;
  spSelect.Execute;

  reRepReportData.Lines.Add('Дата построения отчета ' +  DateTimeToStr(Now));
  reRepReportData.Lines.Add('Запрос отработал за ' +  TimeToStr(Now - FReportTime));
end;

procedure TOLAPSalesForm.FillGrid;
var
   LBand: TcxGridBand;
   LClmn: TcxGridDBBandedColumn;
   List, LBands: TStringList;
   i, j, ItogBandIndex: integer;
begin
  List := TStringList.Create;
  // Начинаем подготовку данных
  cxGrid.BeginUpdate;
  tvReport.DataController.DataSource := MasterDS;
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

    with OlapReportOption.GetIterator do
      while HasNextItem do
        if List.IndexOf(Item) = -1 then begin
           List.Add(Item);
           with tvReport.Bands.Add do begin
             Caption := Item;
             Options.Moving := false;
             LBands.Values[Caption] := IntToStr(Index);
           end;
        end;

    for i := 0 to OlapReportOption.FieldCount - 1 do
      if OlapReportOption.Objects[i].Visible then begin
         LClmn := tvReport.GetColumnByFieldName(OlapReportOption.Objects[i].FieldName);
         if Assigned(LClmn) then begin
            LClmn.Caption := OlapReportOption.Objects[i].Caption;
            LClmn.Position.BandIndex := LBand.Index;
            LClmn.Visible := true;
            LClmn.Width := 200;
            with OlapReportOption.Objects[i] as TDimensionOLAPField do
              if Alignment <> null then begin
                 LClmn.PropertiesClass := TcxTextEditProperties;
                 TcxTextEditProperties(LClmn.Properties).Alignment.Horz := Alignment;
              end;
         end;
         if OlapReportOption.Objects[i] is TDataOLAPField then begin
            for j := 0 to LBands.Count - 1 do begin
              LClmn := tvReport.GetColumnByFieldName(LBands.Names[j] + '_' + OlapReportOption.Objects[i].FieldName);
              if Assigned(LClmn) then begin
                 LClmn.Caption := OlapReportOption.Objects[i].Caption;
                 LClmn.Position.BandIndex := StrToInt(LBands.Values[LBands.Names[j]]);
                 LClmn.Width := 80;
                 LClmn.PropertiesClass := TcxCurrencyEditProperties;
                 TcxCurrencyEditProperties(LClmn.Properties).DisplayFormat := TDataOLAPField(OlapReportOption.Objects[i]).DisplayFormat;
                 LClmn.Visible := true;
                 LClmn.Options.Moving := false;
                 case TDataOLAPField(OlapReportOption.Objects[i]).SummaryType of
                    stSum: LClmn.Summary.FooterKind := skSum;
                    stPercent: LClmn.Summary.FooterKind := skSum;
                 end;
                 LClmn.Summary.FooterFormat := TDataOLAPField(OlapReportOption.Objects[i]).DisplayFormat;
                 LClmn.Summary.GroupFooterKind := LClmn.Summary.FooterKind;
                 LClmn.Summary.GroupFooterFormat := LClmn.Summary.FooterFormat;
              end;
            end;
         end;
      end;

    if OlapReportOption.isOLAPonServer and (OlapReportOption.SummaryType <> stNone) then begin
       with tvReport.Bands.Add do begin
         Caption := 'Итого';
         ItogBandIndex := Index;
       end;

       for i := 0 to OlapReportOption.FieldCount - 1 do
         if OlapReportOption.Objects[i] is TDataOLAPField then
            with TDataOLAPField(OlapReportOption.Objects[i]) do
              if Visible then begin
                LClmn := tvReport.GetColumnByFieldName('ITOG_' + FieldName);
                if Assigned(LClmn) then begin
                   LClmn.PropertiesClass := TcxCurrencyEditProperties;
                   if OlapReportOption.SummaryType in [stCount, stUniqueCount] then
                      TcxCurrencyEditProperties(LClmn.Properties).DisplayFormat := '0'
                   else
                      TcxCurrencyEditProperties(LClmn.Properties).DisplayFormat := DisplayFormat;
                   LClmn.Visible := true;
                   LClmn.Position.BandIndex := ItogBandIndex;
                   LClmn.Caption := Caption;
                   case OlapReportOption.SummaryType of
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

procedure TOLAPSalesForm.FillPivot;
var i: integer;
    DataIndex, DimensionIndex, DateIndex: integer;
begin
  inherited;
  DataIndex := 0;
  DimensionIndex := 0;
  DateIndex := 0;

  cxDBPivotGrid.BeginUpdate;
  try
    cxDBPivotGrid.DataSource := MasterDS;
    cxDBPivotGrid.CreateAllFields;
    for i := 0 to OlapReportOption.FieldCount - 1 do begin
      if OlapReportOption.Objects[i].Visible then begin
         with cxDBPivotGrid.GetFieldByName(OlapReportOption.Objects[i].FieldName) do begin
           if OlapReportOption.Objects[i] is TDataOLAPField then begin
              DisplayFormat := (OlapReportOption.Objects[i] as TDataOLAPField).DisplayFormat;
              Area := faData;
              AreaIndex := DataIndex;
              inc(DataIndex);
            end;
           if OlapReportOption.Objects[i] is TDateOLAPField then begin
              Area := faColumn;
              AreaIndex := DateIndex;
              inc(DateIndex);
            end;
           if OlapReportOption.Objects[i] is TDimensionOLAPField then begin
              Area := faRow;
              AreaIndex := DimensionIndex;
              inc(DimensionIndex);
            end;
            Caption := OlapReportOption.Objects[i].Caption;
         end;
      end;
    end;
  finally
    cxDBPivotGrid.Align := alClient;
    cxDBPivotGrid.EndUpdate;
    cxDBPivotGrid.Visible := true;
  end;
end;

procedure TOLAPSalesForm.tvReportDataControllerSummaryAfterSummary(
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
      TCalculateGroupValues.CalculateValues(OlapReportOption, ASender.GroupSummaryItems[Groups.Level[Groups.ChildDataGroupIndex[ADataGroupIndex, I]]],
           TSetGroupValues.Create(Groups.ChildDataGroupIndex[ADataGroupIndex, I], ASender), tvReport, false);
      CalcGroupSummariesByDataGroupIndex(Groups.ChildDataGroupIndex[ADataGroupIndex, I]);
    end;
  end;
begin
  // Расчет вычисляемых значений для групп
  CalcGroupSummariesByDataGroupIndex(-1);
  // Расчет вычисляемых значений для футеров
  TCalculateGroupValues.CalculateValues(OlapReportOption, ASender.FooterSummaryItems,
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

procedure TOLAPSalesForm.odsRepDataCalcFields(DataSet: TDataSet);
   function ItogCalculate(ItogName: string): double;
   var j: integer;
       RecordCount: integer;
   begin
     result := 0;
     RecordCount := 0;
     if OlapReportOption.SummaryType = stUniqueCount then
        UniqueList.Clear;
     for j := 0 to DataFields.Count - 1 do
       if Pos(ItogName, DataFields[j]) > 0 then
          case OlapReportOption.SummaryType of
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
          case OlapReportOption.SummaryType of
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
  for i := 0 to OlapReportOption.FieldCount - 1 do
    if OlapReportOption.Objects[i] is TDataOLAPField then
       with OlapReportOption.Objects[i] do
         if Visible then
            DataSet.FieldByName('ITOG_' + FieldName).asFloat := ItogCalculate(FieldName);
end;

initialization
  RegisterClass(TOLAPSalesForm);

finalization
  UnRegisterClass(TOLAPSalesForm);

end.
