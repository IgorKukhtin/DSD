unit dsdOLAPSetup;

interface

uses
  DataModul, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  Data.DB, cxDBData, cxTextEdit, cxDropDownEdit,
  cxImageComboBox, cxLabel, cxCurrencyEdit, Vcl.Controls, Vcl.StdCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, cxMaskEdit, cxButtonEdit, cxDBLabel,
  Vcl.ExtCtrls, Vcl.Forms, System.Classes, Datasnap.DBClient, Vcl.Menus,
  cxButtons, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod, cxCalendar,
  dsdOLAP, cxRadioGroup, dsdDB, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPropertiesStore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdGuides,
  Vcl.ActnList, dsdAction;

type
  TOLAPSetupForm = class(TForm)
    Label2: TLabel;
    DimensionDS: TDataSource;
    DataDS: TDataSource;
    DateDS: TDataSource;
    ScrollBox1: TScrollBox;
    cxDimension: TcxGrid;
    cxDimensionDBTableView: TcxGridDBTableView;
    cxDimensionName: TcxGridDBColumn;
    cxDimensionShow: TcxGridDBColumn;
    cxDimensionLevel: TcxGridLevel;
    cxData: TcxGrid;
    cxDataTableView: TcxGridDBTableView;
    cxDataName: TcxGridDBColumn;
    cxDataisShow: TcxGridDBColumn;
    cxDataCalculateType: TcxGridDBColumn;
    cxDataLevel: TcxGridLevel;
    cxDate: TcxGrid;
    cxDateTableView: TcxGridDBTableView;
    cxDateName: TcxGridDBColumn;
    cxDateisShow: TcxGridDBColumn;
    cxDateLevel: TcxGridLevel;
    Label1: TLabel;
    cbPreparedSettings: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cxDimensionFiltered: TcxGridDBColumn;
    FilterDS: TDataSource;
    cxFilter: TcxGrid;
    tvFilterTableView: TcxGridDBTableView;
    cxFilterLevel: TcxGridLevel;
    laFilterCaption: TLabel;
    tvFilterName: TcxGridDBColumn;
    cxMaxRecordCount: TcxCurrencyEdit;
    Label6: TLabel;
    txPreparedSettings: TcxTextEdit;
    lblPeriodType: TcxLabel;
    fldPeriodType: TcxImageComboBox;
    ELLabel1: TcxLabel;
    fldReportType: TcxImageComboBox;
    DatePanel: TPanel;
    lHorizontalTotal: TcxLabel;
    cbHorizontalTotal: TcxImageComboBox;
    DimensionFields: TClientDataSet;
    DataFields: TClientDataSet;
    DateFields: TClientDataSet;
    FilterTable: TClientDataSet;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deStart: TcxDateEdit;
    cxLabel2: TcxLabel;
    deEnd: TcxDateEdit;
    cxLabel1: TcxLabel;
    PeriodChoice: TPeriodChoice;
    OlapReportOptionCDS: TClientDataSet;
    spOlapReportOption: TdsdStoredProc;
    DimensionFieldsName: TStringField;
    DimensionFieldsisShow: TBooleanField;
    DimensionFieldsField_Name: TStringField;
    DimensionFieldsisFiltered: TBooleanField;
    DimensionFieldsChoiceForm: TIntegerField;
    DimensionFieldsisOLAPFilter: TBooleanField;
    DataFieldsName: TStringField;
    DataFieldsisShow: TBooleanField;
    DataFieldsField_Name: TStringField;
    DataFieldsCalculateType: TSmallintField;
    DataFieldsisOLAPFilter: TBooleanField;
    cxButton3: TcxButton;
    cxButton4: TcxButton;
    cxPropertiesStore: TcxPropertiesStore;
    cxLabel5: TcxLabel;
    edBusiness: TcxButtonEdit;
    GuidesBusiness: TdsdGuides;
    spOlapSoldReportBusiness: TdsdStoredProc;
    procedure btnRunOlapClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DimensionFieldsAfterScroll(DataSet: TDataSet);
    procedure acAddFilterExecute(Sender: TObject);
    procedure acDelFilterExecute(Sender: TObject);
    procedure ELSavePreparedSettingsClick(Sender: TObject);
    procedure ELDeletePreparedSettingsClick(Sender: TObject);
    procedure cbPreparedSettingsCloseUp(Sender: TObject);
    procedure fldReportTypePropertiesChange(Sender: TObject);
    procedure DataFieldsAfterPost(DataSet: TDataSet);
  private
    FWindow: integer;
    // Значения фильтров
    FFilterValue: TStringList;
    // Объект хранящий настройки отчета
    FOlapReportOption: TOlapReportOption;
    // Список предварительных установок
    FPreparedSettingsList: TStringList;
    // Храним тут RadioButton
    FRadioList: TList;
    function GetRadioButton(Name: string): TcxRadioButton;
    // Заполняем структуру OlapSaleReportOption данными из гридов
    procedure FillOlapSaleReportOptionFromGrid;
    // Заполняем гриды из структуры OlapSaleReportOption
    procedure FillGridFromOlapSaleReportOption;
    // Функция возвращает список наложенных фильтров
    function GetFilterValues: TStringList;
  end;

implementation

{$R *.dfm}

uses SysUtils, Dialogs, OLAPSales;

procedure TOLAPSetupForm.btnRunOlapClick(Sender: TObject);
var
  LMessage: string;
begin
  {Заполняем параметры отчета  }
  FOlapReportOption.isOLAPonServer := fldReportType.ItemIndex = 0;
  FOlapReportOption.isCreateDate := fldPeriodType.ItemIndex = 0;
  FillOlapSaleReportOptionFromGrid;
  FOlapReportOption.FromDate := deStart.Date;;
  FOlapReportOption.ToDate := deEnd.Date;
  FOlapReportOption.BusinessId := GuidesBusiness.Params.ParamByName('Key').AsInteger;
  FOlapReportOption.SummaryType := TSummaryType(cbHorizontalTotal.ItemIndex);

  {Проверяем на заполненность  }
  if not TOlap.CheckReportOption(FOlapReportOption, LMessage) then begin
     cxDimension.SetFocus;
     raise Exception.Create(LMessage);
  end;

  with TOLAPSalesForm.Create(Application) do
  try
    OlapReportOption := Self.FOlapReportOption;
    InitForm;
    hpReportExecute;
    hpReportTerminate;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TOLAPSetupForm.FormCreate(Sender: TObject);
var i, j: integer;
    ChoiceForm: integer;
    cxRadioButton: TcxRadioButton;
    isFilter: boolean;
begin
  fldReportType.ItemIndex := 1;
  FFilterValue := TStringList.Create;
  // Сюда запишем фильтруемые поля
  DimensionFields.CreateDataSet;
  DataFields.CreateDataSet;
  DateFields.CreateDataSet;
  FilterTable.CreateDataSet;
  j := 0;
  FRadioList := TList.Create;
  spOlapReportOption.Execute;
  // Устанавливаем поля для выбора
  FOlapReportOption := TOlapReportOption.Create(OlapReportOptionCDS);
  for i := 0 to FOlapReportOption.FieldCount - 1 do begin
    ChoiceForm := 0;
    if FOlapReportOption.Objects[i] is TDimensionOLAPField then begin
       isFilter := false;
       with FOlapReportOption.Objects[i] as TOLAPField do
          DimensionFields.AppendRecord([Caption, Visible, FieldName, False, ChoiceForm, isFilter]);
    end;
    if FOlapReportOption.Objects[i] is TDataOLAPField then
       with FOlapReportOption.Objects[i] as TDataOLAPField do
          // Указываем данное поле как фильтр для ОЛАП отчетов. Эти поля не могут в них пока выводиться
          DataFields.AppendRecord([Caption, Visible, FieldName, 0, SummaryType = stPercent]);
    if FOlapReportOption.Objects[i] is TDateOLAPField then
       with FOlapReportOption.Objects[i] as TOLAPField do begin
          DateFields.AppendRecord([Caption, Visible, FieldName]);
          cxRadioButton := TcxRadioButton.Create(DatePanel);
          cxRadioButton.LookAndFeel.NativeStyle := false;
          cxRadioButton.Left := 6;
          cxRadioButton.Width := 16;
          cxRadioButton.Height := 16;
          cxRadioButton.Top := j * 17;
          cxRadioButton.HelpKeyword := FieldName;
          DatePanel.InsertControl(cxRadioButton);
          FRadioList.Add(cxRadioButton);
          inc(j);
          cxRadioButton.Checked := true;
       end;   
  end;
  DimensionFields.First;
  FPreparedSettingsList := TStringList.Create;
  // FPreparedSettingsList.Text := TELListCube.LoadShema(SchemeName);
  for i := 0 to FPreparedSettingsList.Count - 1 do
    cbPreparedSettings.Items.Add(FPreparedSettingsList.Names[i]);
  //
  spOlapSoldReportBusiness.Execute;
end;

procedure TOLAPSetupForm.DimensionFieldsAfterScroll(
  DataSet: TDataSet);
begin
  inherited;
  if not DimensionFields.IsEmpty then begin
     laFilterCaption.Caption := 'Фильтр для: ' + DimensionFields.FieldValues['Name'];
     FilterTable.Filter := 'KeyName = ''' + DimensionFields.FieldValues['Field_Name'] + '''';
  end
end;

procedure TOLAPSetupForm.acAddFilterExecute(Sender: TObject);
var
  i: integer;
begin
  if DimensionFields.FieldByName('ChoiceForm').asInteger = 0 then begin
     ShowMessage('Для измерения ' + DimensionFields.FieldValues['Name'] + ' не определена форма подбора');
     exit;
  end;
  inherited;
{  if DimensionFields.FieldValues['Field_Name'] = 'MARKET_TYPE_NAME' then
    LDataItems :=
      ELEnvironment.DataListManager.GetDataListSelectedItems(DimensionFields.FieldValues['ChoiceForm'],
      '', null, True)
  else
    LDataItems :=
      ELEnvironment.DataListManager.GetDataListSelectedItems(DimensionFields.FieldValues['ChoiceForm'],
      '', null, True, VarArrayOf(['ActualDate']), VarArrayOf([Date]));
  tvFilterTableView.BeginUpdate;
  try
    if Assigned(LDataItems) then
    begin
      for i := 0 to LDataItems.ItemCount - 1 do
        if not FilterTable.Locate('ID', LDataItems.DataItems[i].GetFieldValue('ID'), []) then
          begin
            FilterTable.Append;
            FilterTable.FieldByName('ID').AsString     :=  LDataItems.DataItems[i].GetFieldValue('ID');
            FilterTable.FieldByName('NAME').AsString    :=  LDataItems.DataItems[i].GetFieldValue('NAME');
            FilterTable.FieldByName('KeyNAME').AsString :=  DimensionFields.FieldValues['Field_Name'];
            FilterTable.Post;
          end;
        DimensionFields.Edit;
        DimensionFields.FieldValues['isFiltered'] := FilterTable.RecordCount;
        DimensionFields.Post;
    end;
  finally
    tvFilterTableView.EndUpdate;
    LDataItems.Free;
  end;}
end;

procedure TOLAPSetupForm.acDelFilterExecute(Sender: TObject);
begin
  inherited;
  if not FilterTable.IsEmpty then
     FilterTable.Delete;
  DimensionFields.Edit;
  DimensionFields.FieldValues['isFiltered'] := FilterTable.RecordCount;
  DimensionFields.Post;
end;

procedure TOLAPSetupForm.ELSavePreparedSettingsClick(
  Sender: TObject);
begin
  inherited;
  FillOlapSaleReportOptionFromGrid;
  FPreparedSettingsList.Values[txPreparedSettings.Text] := FOlapReportOption.XMLScheme;
//  TELListCube.SaveShema(FPreparedSettingsList.Text, SchemeName);
  cbPreparedSettings.Items.Add(txPreparedSettings.Text)
end;

procedure TOLAPSetupForm.ELDeletePreparedSettingsClick(
  Sender: TObject);
begin
  inherited;
  if MessageDlg('Вы хотите удалить предварительную настройку?', mtConfirmation, mbYesNo, 0) = mrYes then begin
    FPreparedSettingsList.Delete(FPreparedSettingsList.IndexOfName(cbPreparedSettings.Text));
    cbPreparedSettings.Items.Delete(cbPreparedSettings.Items.IndexOfName(cbPreparedSettings.Text));
    cbPreparedSettings.Text := '';
//    TELListCube.SaveShema(FPreparedSettingsList.Text, SchemeName);
  end;
end;

procedure TOLAPSetupForm.cbPreparedSettingsCloseUp(Sender: TObject);
begin
  inherited;
  if cbPreparedSettings.Text <> '' then begin
    FOlapReportOption.XMLScheme := FPreparedSettingsList.Values[cbPreparedSettings.Text];
    FillGridFromOlapSaleReportOption
  end;
end;

procedure TOLAPSetupForm.FillGridFromOlapSaleReportOption;
var
  i: integer;
begin
  fldPeriodType.ItemIndex := byte(not FOlapReportOption.isCreateDate);
  fldReportType.ItemIndex := byte(not FOlapReportOption.isOLAPonServer);
  cbHorizontalTotal.ItemIndex := Integer(FOlapReportOption.SummaryType);

  for i := 0 to FOlapReportOption.FieldCount - 1 do begin
    if FOlapReportOption.Objects[i] is TDimensionOLAPField then begin
       with FOlapReportOption.Objects[i] as TOLAPField do begin
          DimensionFields.Locate('Field_Name', FieldName, []);
          DimensionFields.Edit;
          DimensionFields.FieldByName('isShow').asBoolean := Visible;
          DimensionFields.Post;
       end;
    end;
    if FOlapReportOption.Objects[i] is TDataOLAPField then
       with FOlapReportOption.Objects[i] as TOLAPField do begin
          DataFields.Locate('Field_Name', FieldName, []);
          DataFields.Edit;
          DataFields.FieldByName('isShow').asBoolean := Visible;
          DataFields.Post;
       end;
    if FOlapReportOption.Objects[i] is TDateOLAPField then
       with FOlapReportOption.Objects[i] as TOLAPField do
         if FOlapReportOption.isOLAPonServer then
            GetRadioButton(FieldName).Checked := Visible
         else begin
            DateFields.Locate('Field_Name', FieldName, []);
            DateFields.Edit;
            DateFields.FieldByName('isShow').asBoolean := Visible;
            DateFields.Post;
         end;
  end;
end;

procedure TOLAPSetupForm.FillOlapSaleReportOptionFromGrid;
var
  DimensionField: TDimensionOLAPField;
  i: integer;
  FilterStr: string;
begin
  FOlapReportOption.isCreateDate := fldPeriodType.ItemIndex = 0;
  FOlapReportOption.isOLAPonServer := fldReportType.ItemIndex = 0;
  FOlapReportOption.SummaryType := TSummaryType(cbHorizontalTotal.ItemIndex);

  FFilterValue.Clear;
  // Установим видимость полей
  DimensionFields.First;
  while not DimensionFields.EOF do begin
    DimensionField := FOlapReportOption.Objects[DimensionFields.FieldByName('Field_Name').asString] as TDimensionOLAPField;
    DimensionField.FilterList.Clear;
    FilterTable.First;
    FilterStr := '';
    while not FilterTable.Eof do begin
      DimensionField.FilterList.Add(FilterTable.FieldByName('ID').AsString);
      if FilterStr = '' then
        FilterStr := FilterTable.FieldByName('Name').AsString
      else
        FilterStr := FilterStr + ', ' + FilterTable.FieldByName('Name').AsString;
      FilterTable.Next;
    end;
    if FilterStr <> '' then
       FFilterValue.Values[DimensionFields.FieldByName('Name').asString] := FilterStr;
    DimensionField.Visible := DimensionFields.FieldByName('isShow').asBoolean;
    DimensionFields.Next;
  end;

  DataFields.First;
  while not DataFields.EOF do begin
    FOlapReportOption.Objects[DataFields.FieldByName('Field_Name').asString].Visible := DataFields.FieldByName('isShow').asBoolean;
    DataFields.Next;
  end;

  {Устанавливаем данные по датам}
  if FOlapReportOption.isOLAPonServer then
  begin
     for i := 0 to FRadioList.Count - 1 do
       FOlapReportOption.Objects[ TcxRadioButton(FRadioList[i]).HelpKeyword].Visible := TcxRadioButton(FRadioList[i]).Checked
  end
  else
  begin
    DateFields.First;
    while not DateFields.EOF do begin
      FOlapReportOption.Objects[DateFields.FieldByName('Field_Name').asString].Visible := DateFields.FieldByName('isShow').asBoolean;
      DateFields.Next;
    end;
  end;
end;

procedure TOLAPSetupForm.fldReportTypePropertiesChange(
  Sender: TObject);
begin
  inherited;
  if not Assigned(FOlapReportOption) then exit;
  DataFields.First;
  while not DataFields.EOF do begin
     if DataFields.FieldByName('isOlapFilter').AsBoolean and
        DataFields.FieldByName('isShow').AsBoolean then begin
        DataFields.Edit;
        DataFields.FieldByName('isShow').AsBoolean := false;
        DataFields.Post;
     end;

     DataFields.Next;
  end;
  FOlapReportOption.isOLAPonServer := fldReportType.ItemIndex = 0;
  DatePanel.Visible := FOlapReportOption.isOLAPonServer;
  DataFields.Filtered := not FOlapReportOption.isOLAPonServer;
  DimensionFields.Filtered := not FOlapReportOption.isOLAPonServer;
  cbHorizontalTotal.Visible := FOlapReportOption.isOLAPonServer;
  lHorizontalTotal.Visible := FOlapReportOption.isOLAPonServer;

end;

function TOLAPSetupForm.GetRadioButton(Name: string): TcxRadioButton;
var i: integer;
begin
  result := nil;
  for i := 0 to FRadioList.Count - 1 do
      if TcxRadioButton(FRadioList[i]).HelpKeyword = Name then
         result := TcxRadioButton(FRadioList[i])
end;

procedure TOLAPSetupForm.DataFieldsAfterPost(DataSet: TDataSet);
var
  i: integer;
begin
  inherited;
  // Если указано, что это расчет процентов, отметить те данные, по которым это просчет будет проводиться.
  if DataSet.FieldByName('isShow').asBoolean then
     with TDataOLAPField(FOlapReportOption.Objects[DataSet.FieldByName('Field_Name').AsString]) do
       if SummaryType = stPercent then
          for i := 0 to ObligatoryFieldCount - 1 do
            if DataSet.Locate('Field_Name', ObligatoryObjects[i].FieldName, []) then begin
               DataSet.Edit;
               DataSet.FieldByName('isShow').asBoolean := true;
               DataSet.Post;
            end;
end;

function TOLAPSetupForm.GetFilterValues: TStringList;
begin
  result := FFilterValue
end;

initialization
  RegisterClass(TOLAPSetupForm);

finalization
  UnRegisterClass(TOLAPSetupForm);

end.



