unit RepriceUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Data.DB,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxCheckListBox, cxDBCheckListBox,
  Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, cxTextEdit, cxCurrencyEdit, cxLabel,
  Bde.DBTables, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxNavigator, cxDBData, cxMaskEdit, cxButtonEdit, dsdAddOn,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, Vcl.ActnList, dsdAction, dsdGuides,
  Datasnap.Provider, cxImageComboBox, Vcl.ExtCtrls, cxSplitter;

type
  TRepriceUnitForm = class(TForm)
    Button1: TButton;
    GetUnitsList: TdsdStoredProc;
    UnitsCDS: TClientDataSet;
    UnitsDS: TDataSource;
    CheckListBox: TCheckListBox;
    ADOQuery: TADOQuery;
    ADOConnection: TADOConnection;
    spSelectPrice: TdsdStoredProc;
    ClientDataSet: TClientDataSet;
    cePercentDifference: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    spInsertUpdate: TADOStoredProc;
    AllGoodsPriceGridTableView: TcxGridDBTableView;
    AllGoodsPriceGridLevel: TcxGridLevel;
    AllGoodsPriceGrid: TcxGrid;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    spSelect_AllGoodsPrice: TdsdStoredProc;
    AllGoodsPriceCDS: TClientDataSet;
    AllGoodPriceDS: TDataSource;
    rdUnit: TRefreshDispatcher;
    FormParams: TdsdFormParams;
    UnitGuides: TdsdGuides;
    ActionList1: TActionList;
    actRefresh: TdsdDataSetRefresh;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colOldPrice: TcxGridDBColumn;
    Button2: TButton;
    QueryDS: TDataSource;
    ADOQueryId: TIntegerField;
    ADOQueryGoodsName: TStringField;
    ADOQueryLastPrice: TFloatField;
    ADOQueryNewPrice: TFloatField;
    ADOQueryPercent: TCurrencyField;
    colNewPrice: TcxGridDBColumn;
    colPercent: TcxGridDBColumn;
    ADOQueryCode: TIntegerField;
    ResultCDS: TClientDataSet;
    DataSetProvider: TDataSetProvider;
    ADOQueryRemainsCount: TFloatField;
    colRemainsCount: TcxGridDBColumn;
    ADOQueryNDS: TFloatField;
    colNDS: TcxGridDBColumn;
    ADOQueryExpirationDate: TDateField;
    ADOQueryNotReprice: TBooleanField;
    ADOQueryNotRepriceNote: TStringField;
    colNotReprice: TcxGridDBColumn;
    colNotRepriceNote: TcxGridDBColumn;
    colExpirationDate: TcxGridDBColumn;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    cxSplitter1: TcxSplitter;
    cxSplitter2: TcxSplitter;
    Panel4: TPanel;
    Panel5: TPanel;
    ADOQueryCategoriesId: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ADOQueryCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses SimpleGauge, DataModul;

procedure TRepriceUnitForm.ADOQueryCalcFields(DataSet: TDataSet);
begin
  {}
  if AllGoodsPriceCDS.isEmpty then exit;

  if AllGoodsPriceCDS.Locate('GoodsCode', DataSet.FieldByName('Code').AsInteger, []) then begin
     DataSet.FieldByName('NewPrice').AsFloat := AllGoodsPriceCDS.FieldByName('NewPrice').AsFloat;
     if not AllGoodsPriceCDS.FieldByName('NDS').isnull then
       DataSet.FieldByName('NDS').AsFloat := AllGoodsPriceCDS.FieldByName('NDS').AsFloat;
     if not AllGoodsPriceCDS.FieldByName('ExpirationDate').isNull then
       DataSet.FieldByName('ExpirationDate').asDateTime := AllGoodsPriceCDS.FieldByName('ExpirationDate').asDateTime;

     if DataSet.FieldByName('LastPrice').AsFloat = 0 then
        DataSet.FieldByName('Percent').AsFloat := 0
     else
     if AllGoodsPriceCDS.FieldByName('NewPrice').AsFloat <> 0 then
        DataSet.FieldByName('Percent').AsFloat := (AllGoodsPriceCDS.FieldByName('NewPrice').AsFloat
                                                   / DataSet.FieldByName('LastPrice').AsFloat) * 100 - 100;
     DataSet.FieldByName('NotReprice').AsBoolean := (DataSet.FieldByName('NewPrice').AsFloat = 0)
                                                    or
                                                    AllGoodsPriceCDS.FieldByName('NDS').isnull
                                                    or
                                                    (AllGoodsPriceCDS.FieldByName('NDS').asFloat = 20)
                                                    or
                                                    (
                                                      not AllGoodsPriceCDS.FieldByName('ExpirationDate').isNull
                                                      AND
                                                      (AllGoodsPriceCDS.FieldByName('ExpirationDate').AsDateTime < IncMonth(Date,6))
                                                    )
                                                    or
                                                    (ABS(DataSet.FieldByName('Percent').AsFloat)<=ABS(cePercentDifference.Value));
    if DataSet.FieldByName('NotReprice').AsBoolean then
    Begin
      DataSet.FieldByName('NotRepriceNote').AsString:= '';
      if AllGoodsPriceCDS.FieldByName('NDS').isnull then
        DataSet.FieldByName('NotRepriceNote').AsString := DataSet.FieldByName('NotRepriceNote').AsString+
          'Товар без НДС; ';
      if AllGoodsPriceCDS.FieldByName('NDS').AsFloat = 20 then
        DataSet.FieldByName('NotRepriceNote').AsString := DataSet.FieldByName('NotRepriceNote').AsString+
          'НДС = 20%; ';
      if (not AllGoodsPriceCDS.FieldByName('ExpirationDate').isNull
          AND
         (AllGoodsPriceCDS.FieldByName('ExpirationDate').AsDateTime < IncMonth(Date,6))) then
        DataSet.FieldByName('NotRepriceNote').AsString := DataSet.FieldByName('NotRepriceNote').AsString+
          'Срок годности < 6 мес.; ';
      if ABS(DataSet.FieldByName('Percent').AsFloat)<=ABS(cePercentDifference.Value) then
        DataSet.FieldByName('NotRepriceNote').AsString := DataSet.FieldByName('NotRepriceNote').AsString+
          'Не превышен допустимый разбег цен; ';
    End;

  end;
end;

procedure TRepriceUnitForm.Button1Click(Sender: TObject);
var i, {J,} P: integer;
  function MyMakeDate(V:Variant):TDateTime;
  Begin
    if (V = Null) then
      Result := 0
    else
      Result := EncodeDate(StrToInt(Copy(VarToSTr(V),1,4)),
                           StrToInt(Copy(VarToSTr(V),6,2)),
                           StrToInt(Copy(VarToSTr(V),9,2)));
  end;
begin
//exit;
  memo1.Lines.Clear;
  ADOQuery.OnCalcFields := Nil;
  try
    for i := 0 to CheckListBox.Items.Count - 1 do
      if CheckListBox.Checked[i] then begin
         //J := 0;
         UnitsCDS.Locate('UnitName', CheckListBox.Items[i], []);
         ADOConnection.Close;
         //ADOConnection.ConnectionString := UnitsCDS.FieldByName('StringKey').AsString;
         ADOConnection.Open;

         ADOQuery.SQL.Text :=
//                  'SELECT GoodsProperty.Id, LastPrice.LastPrice, GoodsProperty.Code, LastPrice.CategoriesId ' +
//                   ' FROM "DBA"."LastPrice" '+
//                    'join GoodsProperty on GoodsProperty.Id = LastPrice.GoodsPropertyID ' +
//                  ' where CategoriesId = zf_GetCategoriesOper(zc_bkSaleToUnit(), 0, ' + UnitsCDS.FieldByName('IntegerKey').AsString + ') ';
           'Select DISTINCT' + #13#10 +
           '  GoodsProperty.GoodsName,' + #13#10 +
           '  GoodsProperty.Id,' + #13#10 +
           '  LastPrice.LastPrice,' + #13#10 +
           '  GoodsProperty.Code,' + #13#10 +
           '  LastPrice.CategoriesId,' + #13#10 +
           '  GoodsCardItemsCount.RemainsCount' + #13#10 +
           'from' + #13#10 +
           '  dba.GoodsCardItems,' + #13#10 +
           '  dba.GoodsProperty,' + #13#10 +
           '  dba.LastPrice,' + #13#10 +
           '  dba.GoodsCardItemsCount' + #13#10 +
           'where' + #13#10 +
           '  GoodsCardItems.GoodsPropertyID=GoodsProperty.ID' + #13#10 +
           '  and' + #13#10 +
           '  GoodsCardItemsCount.GoodsCardItemsId=GoodsCardItems.ID' + #13#10 +
           '  and' + #13#10 +
           '  GoodsCardItemsCount.UnitID=' + UnitsCDS.FieldByName('IntegerKey').AsString + #13#10 +
           '  and' + #13#10 +
           '  LastPrice.GoodsPropertyID=GoodsProperty.Id' + #13#10 +
           '  and' + #13#10 +
           '  LastPrice.CategoriesId=zf_GetCategoriesOper(zc_bkSaleToUnit(), 0, ' + UnitsCDS.FieldByName('IntegerKey').AsString + ')' + #13#10 +
           '  and' + #13#10 +
           '  RemainsCount <> 0';
         ADOQuery.Close;
         spSelectPrice.ParamByName('inUnitId').Value := UnitsCDS.FieldByName('Id').AsInteger;
         ADOQuery.Open;
         with TGaugeFactory.GetGauge('Загрузка данных', 1, ADOQuery.RecordCount) do begin
              Start;
              try
                 while not ADOQuery.EOF do begin
                    //если пустой набор - то параметры не перезаписываются с прошлой выборки
                    for P := 0 to spSelectPrice.Params.Count - 1 do
                      if spSelectPrice.Params.Items[P].Name <> 'inUnitId' then
                        spSelectPrice.Params.Items[P].Value := Null;
                    spSelectPrice.ParamByName('inGoodsCode').Value := ADOQuery.FieldByName('Code').AsInteger;
                    spSelectPrice.Execute;
                    if (spSelectPrice.ParamByName('NewPrice').AsFloat > 0)
                       AND
                       ((abs(spSelectPrice.ParamByName('NewPrice').AsFloat - ADOQuery.FieldByName('LastPrice').asFloat)
                         / ADOQuery.FieldByName('LastPrice').asFloat) * 100 > ABS(cePercentDifference.Value))
                       AND
                       (spSelectPrice.ParamByName('NDS').Value <> Null)
                       AND
                       (spSelectPrice.ParamByName('NDS').AsFloat <> 20)
                       AND
                       (
                          (MyMakeDate(spSelectPrice.ParamByName('ExpirationDate').Value) = 0)
                          or
                          (MyMakeDate(spSelectPrice.ParamByName('ExpirationDate').Value) > IncMonth(Date,6))
                       )
                     then
                     begin
                       spInsertUpdate.Parameters.ParamByName('@CategoriesId').Value := ADOQuery.FieldByName('CategoriesId').AsInteger;
                       spInsertUpdate.Parameters.ParamByName('@LastPrice').Value := spSelectPrice.ParamByName('NewPrice').AsFloat;
                       spInsertUpdate.Parameters.ParamByName('@GoodsPropertyID').Value := ADOQuery.FieldByName('Id').AsInteger;
                       spInsertUpdate.Parameters.ParamByName('@StartDate').Value := Date;
                       spInsertUpdate.ExecProc;
                       Memo1.Lines.Add(CheckListBox.Items[i]+'. '+
                                       ADOQuery.FieldByName('Code').AsString+'. '+
                                       ADOQuery.FieldByName('GoodsName').AsString+' ('+spSelectPrice.ParamByName('GoodsName').AsString+'): '+
                                       FormatFloat(',0.00',ADOQuery.FieldByName('LastPrice').asFloat)+' -> '+
                                       FormatFloat(',0.00',spSelectPrice.ParamByName('NewPrice').AsFloat))
                    end
                    (*else
                       Memo1.Lines.Add(CheckListBox.Items[i]+'. '+
                                       ADOQuery.FieldByName('Code').AsString+'. '+
                                       ADOQuery.FieldByName('GoodsName').AsString+' ('+spSelectPrice.ParamByName('GoodsName').AsString+'): '+
                                       FormatFloat(',0.00',(abs(spSelectPrice.ParamByName('NewPrice').AsFloat - ADOQuery.FieldByName('LastPrice').asFloat)
                                                            / ADOQuery.FieldByName('LastPrice').asFloat) * 100)+'; '+
                                       FormatFloat(',0.00',spSelectPrice.ParamByName('NewPrice').AsFloat)+'; '+
                                       spSelectPrice.ParamByName('NDS').AsString+'; '+
                                       spSelectPrice.ParamByName('ExpirationDate').AsString+'; '+
                                       DateToStr(MyMakeDate(spSelectPrice.ParamByName('ExpirationDate').Value)))*);

                    IncProgress;
                    ADOQuery.Next;
//                    inc(J);
//                    if J >= 100 then exit;
                 end;
              finally
                 Finish
              end;
         end;
         ADOConnection.Close;
      end;
  finally
    ADOQuery.OnCalcFields := ADOQueryCalcFields;
  end;
end;

procedure TRepriceUnitForm.Button2Click(Sender: TObject);
var i: integer;
begin
  for i := 0 to CheckListBox.Items.Count - 1 do
      if CheckListBox.Checked[i] then begin
         UnitsCDS.Locate('UnitName', CheckListBox.Items[i], []);
//         ADOConnection.ConnectionString := UnitsCDS.FieldByName('StringKey').AsString;
         ADOConnection.Open;

         ADOQuery.SQL.Text :=
//           'SELECT'+ #13#10 +
//           '  GoodsProperty.GoodsName,'+ #13#10 +
//           '  GoodsProperty.Id,'+ #13#10 +
//           '  LastPrice.LastPrice,'+ #13#10 +
//           '  GoodsProperty.Code,'+ #13#10 +
//           '  LastPrice.CategoriesId'+ #13#10 +
//           'FROM "DBA"."LastPrice"'+ #13#10 +
//           '  join GoodsProperty on GoodsProperty.Id = LastPrice.GoodsPropertyID'+ #13#10 +
//           'where'+ #13#10 +
//           '  CategoriesId = zf_GetCategoriesOper(zc_bkSaleToUnit(), 0, ' + UnitsCDS.FieldByName('IntegerKey').AsString + ')';

           'Select DISTINCT' + #13#10 +
           '  GoodsProperty.GoodsName,' + #13#10 +
           '  GoodsProperty.Id,' + #13#10 +
           '  LastPrice.LastPrice,' + #13#10 +
           '  GoodsProperty.Code,' + #13#10 +
           '  LastPrice.CategoriesId,' + #13#10 +
           '  GoodsCardItemsCount.RemainsCount' + #13#10 +
           'from' + #13#10 +
           '  dba.GoodsCardItems,' + #13#10 +
           '  dba.GoodsProperty,' + #13#10 +
           '  dba.LastPrice,' + #13#10 +
           '  dba.GoodsCardItemsCount' + #13#10 +
           'where' + #13#10 +
           '  GoodsCardItems.GoodsPropertyID=GoodsProperty.ID' + #13#10 +
           '  and' + #13#10 +
           '  GoodsCardItemsCount.GoodsCardItemsId=GoodsCardItems.ID' + #13#10 +
           '  and' + #13#10 +
           '  GoodsCardItemsCount.UnitID=' + UnitsCDS.FieldByName('IntegerKey').AsString + #13#10 +
           '  and' + #13#10 +
           '  LastPrice.GoodsPropertyID=GoodsProperty.Id' + #13#10 +
           '  and' + #13#10 +
           '  LastPrice.CategoriesId=zf_GetCategoriesOper(zc_bkSaleToUnit(), 0, ' + UnitsCDS.FieldByName('IntegerKey').AsString + ')' + #13#10 +
           '  and' + #13#10 +
           '  RemainsCount <> 0';
         ADOQuery.Close;
         spSelect_AllGoodsPrice.ParamByName('inUnitId').Value := UnitsCDS.FieldByName('Id').AsInteger;
         spSelectPrice.ParamByName('inUnitId').Value := UnitsCDS.FieldByName('Id').AsInteger;
         spSelect_AllGoodsPrice.Execute;
         AllGoodsPriceCDS.IndexFieldNames := 'GoodsCode';
         ADOQuery.Open;
         ResultCDS.Data := DataSetProvider.Data;
         break;
      end;
end;

procedure TRepriceUnitForm.FormCreate(Sender: TObject);
begin
  GetUnitsList.Execute;

  UnitsCDS.First;
  while not UnitsCDS.Eof do begin
    CheckListBox.Items.Add(UnitsCDS.FieldByName('UnitName').asString);
    UnitsCDS.Next;
  end;
end;

end.
