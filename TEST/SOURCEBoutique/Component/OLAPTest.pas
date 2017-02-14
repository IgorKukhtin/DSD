unit OLAPTest;

interface

uses DB, TestFramework;

type
  // Класс тестирует поведение класса TELOLAPSalers.
  TOLAPTest = class(TTestCase)
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные после тестирования}
    procedure TearDown; override;
  published
    // Проверка создания корректного SQL выражения для построения отчета
    procedure CreateSQLExpression;
    // Проверка правильного заполнения данных отчета
//    procedure CheckOlapSaleReportOption;
    // Проверка сохранения и восстановления схем по умолчанию
//    procedure CheckSaveRestoreShema;
    // Проверка сохранения и восстановления схем по умолчанию на сервере
//    procedure CheckSaveRestoreShemaOnServer;
  end;

  TField = class(DB.TField)
  private
    FFieldKind: TFieldKind;
  end;

implementation

uses dsdDB, DBClient, Classes, dsdOlap, SysUtils, Storage, UtilConst, Authentication, CommonData {, Forms, cxCustomPivotGrid,
  cxGridDBTableView, cxGridTableView, cxGridDBBandedTableView, cxGridBandedTableView,
  cxCurrencyEdit, cxGridCustomTableView, cxCustomData, Controls, cxDBPivotGrid, cxDBData, Dialogs};

{ TOLAPTest }

(*procedure TOLAPTest.CheckOlapSaleReportOption;
var
  OlapSaleReportOption: TELOlapSaleReportOption;
  LMessage: string;
begin
  OlapSaleReportOption := TELOlapSaleReportOption.Create;
  Check(not TELOlapSalers.CheckReportOption(OlapSaleReportOption, LMessage), LMessage);

  OlapSaleReportOption.Objects['SHOP_NAME'].Visible := true;
  OlapSaleReportOption.Objects['SOLD_SUMM'].Visible := true;
  Check(TELOlapSalers.CheckReportOption(OlapSaleReportOption, LMessage), LMessage);
end;

procedure TOLAPTest.CheckSaveRestoreShema;
var
  OlapSaleReportOption: TELOlapSaleReportOption;
  XML_Scheme: String;
  i: integer;
  VisibleCount: integer;
  JsonString: String;
begin
  // Создали новый объект
  OlapSaleReportOption := TELOlapSaleReportOption.Create;
  // Установили для него видимость
  OlapSaleReportOption.isOLAPonServer := true;
  OlapSaleReportOption.isCreateDate := true;
  OlapSaleReportOption.SummaryType := stUniqueCount;
  OlapSaleReportOption.Objects['SHOP_NAME'].Visible := true;
  OlapSaleReportOption.Objects['SOLD_SUMM'].Visible := true;
  // Получили схему
  XML_Scheme := OlapSaleReportOption.XMLScheme;
  // Очистили объект
  OlapSaleReportOption.Free;
  // Создали новый
  OlapSaleReportOption := TELOlapSaleReportOption.Create;
  // 2. Это SHOP_NAME и SOLD_SUMM
  Check(not OlapSaleReportOption.Objects['SHOP_NAME'].Visible);
  Check(not OlapSaleReportOption.Objects['SOLD_SUMM'].Visible);
  // Наложили на него схему
  OlapSaleReportOption.XmlScheme := XML_Scheme;
  // Проверили
  // 1. Видимых только два
  VisibleCount := 0;
  for i := 0 to OlapSaleReportOption.FieldCount - 1 do
      if OlapSaleReportOption.Objects[i].Visible then Inc(VisibleCount);
  Check(VisibleCount = 2, 'Видимых полей ' + IntToStr(VisibleCount) + ' вместо 2');
  // 2. Это SHOP_NAME и SOLD_SUMM
  Check(OlapSaleReportOption.Objects['SHOP_NAME'].Visible);
  Check(OlapSaleReportOption.Objects['SOLD_SUMM'].Visible);
  Check(OlapSaleReportOption.isOLAPonServer, 'OlapSaleReportOption.isOLAPonServer');
  Check(OlapSaleReportOption.isCreateDate, 'OlapSaleReportOption.isCreateDate');
  Check(OlapSaleReportOption.SummaryType = stUniqueCount, 'OlapSaleReportOption.SummaryType');

end;

procedure TOLAPTest.CheckSaveRestoreShemaOnServer;
var
  OlapSaleReportOption: TELOlapSaleReportOption;
  XML_Scheme: String;
  List: TStringList;
  i: integer;
  VisibleCount: integer;
begin
  List := TStringList.Create;
  // Создали новый объект
  OlapSaleReportOption := TELOlapSaleReportOption.Create;
  // Установили для него видимость
  OlapSaleReportOption.Objects['SHOP_NAME'].Visible := true;
  OlapSaleReportOption.Objects['SOLD_SUMM'].Visible := true;
  // Получили схему
  XML_Scheme := OlapSaleReportOption.XMLScheme;
  // Очистили объект
  OlapSaleReportOption.Free;

  List.Values['Первая схема'] := XML_Scheme;

    // Создали новый объект
  OlapSaleReportOption := TELOlapSaleReportOption.Create;
  // Установили для него видимость
  OlapSaleReportOption.Objects['SOLD_SUMM'].Visible := true;
  // Получили схему
  XML_Scheme := OlapSaleReportOption.XMLScheme;
  // Очистили объект
  OlapSaleReportOption.Free;

  List.Values['Вторая схема'] := XML_Scheme;

  TELListCube.SaveShema(List.Text, 'ELOLAPSalesTest');

  List.Free;
  List := TStringList.Create;
  List.Text := TELListCube.LoadShema('ELOLAPSalesTest');
   // Создали новый объект
  OlapSaleReportOption := TELOlapSaleReportOption.Create;
  // Наложили на него схему
  OlapSaleReportOption.XmlScheme := List.Values['Первая схема'];
  // Проверили
  // 1. Видимых только два
  VisibleCount := 0;
  for i := 0 to OlapSaleReportOption.FieldCount - 1 do
      if OlapSaleReportOption.Objects[i].Visible then Inc(VisibleCount);
  Check(VisibleCount = 2, 'Видимых полей ' + IntToStr(VisibleCount) + ' вместо 2');
  // 2. Это SHOP_NAME и SOLD_SUMM
  Check(OlapSaleReportOption.Objects['SHOP_NAME'].Visible);
  Check(OlapSaleReportOption.Objects['SOLD_SUMM'].Visible);


end;
  *)
procedure TOLAPTest.CreateSQLExpression;
var
//   LClmn: TcxGridDBBandedColumn;
//   LBand: TcxGridBand;
   OlapSaleReportOption: TOlapReportOption;
   i, j: integer;
//   LBands: TStringList;
//   SummaryGroup : TcxDataSummaryGroup;
   List: TStringList;
   FIndex: integer;
   FieldDefs: TFieldDefs;
   DataFields: TStringList;
   StoredProc: TdsdStoredProc;
   DataSet: TClientDataSet;
   DataList: TStringList;
begin
  DataSet := TClientDataSet.Create(nil);
  StoredProc := TdsdStoredProc.Create(nil);
  StoredProc.OutputType := otDataSet;
  StoredProc.DataSet := DataSet;
  StoredProc.StoredProcName := 'gpGet_OlapSoldReportOption';
  StoredProc.Execute;
  //StoredProc.StoredProcName := 'gp_Select_Dynamic_cur';
  //StoredProc.
  DataList := TStringList.Create;
  FieldDefs := TFieldDefs.Create(nil);
  List:=TStringList.Create;
  OlapSaleReportOption := TOlapReportOption.Create(DataSet);
  OlapSaleReportOption.SummaryType := dsdOlap.stAverage;
  OlapSaleReportOption.Objects['sale_summ'].Visible := true;
//  OlapSaleReportOption.Objects['EXCHANGE_SUMM'].Visible := true;
  //OlapSaleReportOption.Objects['WEIGHT'].Visible := true;
  //OlapSaleReportOption.Objects['EXCHANGE_PERCENT'].Visible := true;

 OlapSaleReportOption.Objects['JuridicalName'].Visible := true;
 OlapSaleReportOption.Objects['GoodsName'].Visible := true;

  with OlapSaleReportOption.Objects['YEAR_DATE_DOC'] do begin
      Visible := true;
  end;
{  with OlapSaleReportOption.Objects['MONTH_YEAR_DATE_DOC'] do begin
      Visible := true;
  end;

  with OlapSaleReportOption.Objects['DAYOFWEEK_DATE_DOC'] do begin
       Visible := true;
  end;

  with OlapSaleReportOption.Objects['MONTH_DATE_DOC'] do begin
      Visible := true;
  end;

 }
 { with OlapSaleReportOption.Objects['DATE_DOC'] do begin
      Visible := true;
  end;}

  (*  with OlapSaleReportOption.Objects['POSITION_NAME'] do begin
  //     Visible := true;
  end;

  with OlapSaleReportOption.Objects['DEPARTMENT_NAME'] do begin
       Visible := true;
  end;

  with OlapSaleReportOption.Objects['PRODUCER_NAME'] do begin
       Visible := true;
  end;

  with OlapSaleReportOption.Objects['BRANCH_NAME'] do begin
     //  Visible := true;
  end;


  with OlapSaleReportOption.Objects['GOOD_NAME'] as TDimensionOLAPField do begin
   // FilterList.Add('126789012');
     Visible := true;
  end;

  with OlapSaleReportOption.Objects['GOOD_CAT_NAME'] do begin
    //   Visible := true;
  end;

  with OlapSaleReportOption.Objects['GOOD_TYPE_DISTRIBUTOR_NAME'] do begin
     //  Visible := true;
  end;

  with OlapSaleReportOption.Objects['GOOD_PRODUCER_TYPE_NAME'] do begin
     //  Visible := true;
  end;

  with OlapSaleReportOption.Objects['SHOP_NAME'] do begin
   //   Visible := true;
  end;

  with OlapSaleReportOption.Objects['TRANSACTOR_NAME'] do begin
    //  Visible := true;
  end;


  with OlapSaleReportOption.Objects['DOCUMENT_NUMBER'] do begin
     //  Visible := true;
  end;

  with OlapSaleReportOption.Objects['DOC_DATE_DIM'] do begin
  //  Visible := true;
  end;

  with OlapSaleReportOption.Objects['RTT'] do begin
 //   Visible := true;
  end;


  with OlapSaleReportOption.Objects['CONTRACT_NAME'] do begin
    Visible := true;
  end;


  with OlapSaleReportOption.Objects['DELIV_TIME'] do begin
    Visible := true;
  end;

  with OlapSaleReportOption.Objects['DELIV_TIME_FACT'] do begin
    Visible := true;
  end;
  *)

  OlapSaleReportOption.FromDate := StrToDate('01.01.2014');
  OlapSaleReportOption.ToDate := StrToDate('01.01.2015');

 // OlapSaleReportOption.isOLAPonServer := true;
 OlapSaleReportOption.isOLAPonServer := false;

 Check (false, TOlap.CreateSQLExpression(OlapSaleReportOption, DataSet.FieldDefs, DataList));
 exit;

 (* DataFields := TStringList.Create;

  with TForm1.Create(nil) do begin

    FELOlapSaleReportOption := OlapSaleReportOption;

    FieldDefs := TFieldDefs.Create(SQLQuery);

    SQLQuery.SQL.Text := TELOlapSalers.CreateSQLExpression(OlapSaleReportOption, FieldDefs, DataFields);
    OracleSession.Connected := true;
    SQLQuery.FieldDefs.Clear;
    SQLQuery.FieldDefs.Assign(FieldDefs);
    for i := 0 to SQLQuery.FieldDefs.Count - 1 do
        SQLQuery.FieldDefs[i].CreateField(SQLQuery);

    for i := 0 to OlapSaleReportOption.FieldCount - 1 do
        if OlapSaleReportOption.Objects[i] is TDataOLAPField then
           with OlapSaleReportOption.Objects[i] do
             if Visible then
                with FieldDefs.AddFieldDef do begin
                  Name := 'ITOG_' + FieldName;
                  DataType := ftFloat;
                  CreateField(SQLQuery).FieldKind := fkCalculated;
                end;
   LDataFields := DataFields;
   SQLQuery.Open;

  cxGrid.BeginUpdate;
  tvReport.DataController.CreateAllItems;
  for i := 0 to tvReport.ColumnCount - 1 do
    tvReport.Columns[i].Visible := false;

  LBand := tvReport.Bands.Add;
  if Assigned(LBand) then
  begin
    LBand.Caption := 'Заголовок';
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

    with tvReport.DataController.Summary do begin
      SummaryGroups.Clear;
      SummaryGroup := SummaryGroups.Add;
    end;

    for i := 0 to FELOlapSaleReportOption.FieldCount - 1 do
      if FELOlapSaleReportOption.Objects[i].Visible then begin
         if not (FELOlapSaleReportOption.Objects[i] is TDataOLAPField) then begin
             LClmn := tvReport.GetColumnByFieldName(FELOlapSaleReportOption.Objects[i].FieldName);
             if Assigned(LClmn) then begin
                LClmn.Caption := FELOlapSaleReportOption.Objects[i].Caption;
                LClmn.Position.BandIndex := LBand.Index;
                LClmn.Visible := true;
                LClmn.Width := 200;
                 with TcxGridTableSummaryGroupItemLink(SummaryGroup.Links.Add) do begin
                  Column := LClmn;
                 end;
             end;
         end
         else
         begin
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
                 LClmn.Summary.FooterKind := skSum;
                 //case TDataOLAPField(FELOlapSaleReportOption.Objects[i]).SummaryType of
                  // TSummaryType(stSum), TSummaryType(stCustom): LClmn.Summary.FooterKind := skSum;
                 //end;
                 LClmn.Summary.FooterFormat := TcxCurrencyEditProperties(LClmn.Properties).DisplayFormat;
              //   LClmn.Summary.GroupKind := LClmn.Summary.FooterKind;
               //  LClmn.Summary.GroupFormat := LClmn.Summary.FooterFormat;
             //    LClmn.Summary.GroupFooterKind := LClmn.Summary.FooterKind;
                // LClmn.Summary.GroupFooterFormat := LClmn.Summary.FooterFormat;
                        //Add summary items
               with SummaryGroup.SummaryItems.Add as TcxGridDBTableSummaryItem do
                 begin
                    DisplayText := '33';
                    VisibleForCustomization := true;
                    Tag := 1;
                    DisplayName := 'dsfs';
                    Column := LClmn;
                    Position := spGroup;
                    Kind := LClmn.Summary.FooterKind;
                    Format := LClmn.Summary.FooterFormat;
                 end;
              end;
            end;
         end;
      end;

     with tvReport.Bands.Add do begin
       Caption := 'Итого';
       FIndex := Index;
     end;

     for i := 0 to OlapSaleReportOption.FieldCount - 1 do
        if OlapSaleReportOption.Objects[i] is TDataOLAPField then
           with OlapSaleReportOption.Objects[i] do
             if Visible then begin
               LClmn := tvReport.GetColumnByFieldName('ITOG_'+FieldName);
               if Assigned(LClmn) then begin
                  LClmn.PropertiesClass := TcxCurrencyEditProperties;
                  TcxCurrencyEditProperties(LClmn.Properties).DisplayFormat := ',0.00';
                  LClmn.Visible := true;
                  LClmn.Position.BandIndex := FIndex;
                  LClmn.Caption := Caption;
                  LClmn.Summary.FooterKind := skSum;
                  LClmn.Summary.FooterFormat := TcxCurrencyEditProperties(LClmn.Properties).DisplayFormat;
               end;
             end;

    cxGrid.Align := alClient;
    cxGrid.Visible := true;
    cxGrid.EndUpdate;
  finally
    LBands.Free;
    cxGrid.Align := alClient;
    cxGrid.EndUpdate;
    cxGrid.Visible := true;
  end;
    cxDBPivotGrid.CreateAllFields;
    cxDBPivotGrid.DataController.Filter.AutoDataSetFilter := true;
   *)   (*    cxDBPivotGrid.CreateAllFields;
      for i := 0 to OlapSaleReportOption.Fields.Count - 1 do begin
        if TOLAPField(OlapSaleReportOption.Fields.Objects[i]).Visible then begin
//           if OlapSaleReportOption.Fields.Objects[i] is TDataOLAPField then begin
  //            if TDataOLAPField(OlapSaleReportOption.Fields.Objects[i]).SummaryType = stUniqueCount then
    //             cxDBPivotGrid.GetFieldByName(TOLAPField(OlapSaleReportOption.Fields.Objects[i]).FieldName).SummaryType := stCount;
      //     end;

           cxDBPivotGrid.GetFieldByName(TOLAPField(OlapSaleReportOption.Fields.Objects[i]).FieldName).Caption := TOLAPField(OlapSaleReportOption.Fields.Objects[i]).Caption;
        end;
    end;
    *)
    (*ShowModal;

    Application.ProcessMessages;
  //  sleep(3000);
    Free;
  end;*)
end;

procedure TOLAPTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', gc_AdminPassword, gc_User);
end;

procedure TOLAPTest.TearDown;
begin
  inherited;
end;

initialization

  TestFramework.RegisterTest('Reports', TOLAPTest.Suite);

end.
