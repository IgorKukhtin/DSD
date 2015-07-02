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
  Datasnap.Provider;

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

uses SimpleGauge;

procedure TRepriceUnitForm.ADOQueryCalcFields(DataSet: TDataSet);
begin
  {}
  if AllGoodsPriceCDS.Locate('GoodsCode', DataSet.FieldByName('Code').AsInteger, []) then begin
     DataSet.FieldByName('NewPrice').AsFloat := AllGoodsPriceCDS.FieldByName('NewPrice').AsFloat;
     if AllGoodsPriceCDS.FieldByName('NewPrice').AsFloat = 0 then
        DataSet.FieldByName('Percent').AsFloat := 0
     else
        DataSet.FieldByName('Percent').AsFloat := (DataSet.FieldByName('LastPrice').AsInteger / AllGoodsPriceCDS.FieldByName('NewPrice').AsFloat) * 100 - 100;
  end;
end;

procedure TRepriceUnitForm.Button1Click(Sender: TObject);
var i: integer;
begin
exit;
  for i := 0 to CheckListBox.Items.Count - 1 do
      if CheckListBox.Checked[i] then begin
         UnitsCDS.Locate('UnitName', CheckListBox.Items[i], []);
         ADOConnection.ConnectionString := UnitsCDS.FieldByName('StringKey').AsString;
         ADOConnection.Open;

         ADOQuery.SQL.Text := 'SELECT GoodsProperty.Id, LastPrice.LastPrice, GoodsProperty.Code, LastPrice.CategoriesId ' +
                   ' FROM "DBA"."LastPrice" '+
                    'join GoodsProperty on GoodsProperty.Id = LastPrice.GoodsPropertyID ' +
                  ' where CategoriesId = zf_GetCategoriesOper(zc_bkSaleToUnit(), 0, ' + UnitsCDS.FieldByName('IntegerKey').AsString + ') ';
         ADOQuery.Close;
         spSelectPrice.ParamByName('inUnitId').Value := UnitsCDS.FieldByName('Id').AsInteger;
         ADOQuery.Open;
         with TGaugeFactory.GetGauge('Загрузка данных', 1, ADOQuery.RecordCount) do begin
              Start;
              try
                 while not ADOQuery.EOF do begin
                    spSelectPrice.ParamByName('inGoodsCode').Value := ADOQuery.FieldByName('Code').AsInteger;
                    spSelectPrice.Execute;
                    if spSelectPrice.ParamByName('NewPrice').AsFloat > 0 then begin
                       if (abs(spSelectPrice.ParamByName('NewPrice').AsFloat - ADOQuery.FieldByName('LastPrice').asFloat)
                         / spSelectPrice.ParamByName('NewPrice').AsFloat) * 100 > cePercentDifference.Value  then
                         begin
                           spInsertUpdate.Parameters.ParamByName('@CategoriesId').Value := ADOQuery.FieldByName('CategoriesId').AsInteger;
                           spInsertUpdate.Parameters.ParamByName('@LastPrice').Value := spSelectPrice.ParamByName('NewPrice').AsFloat;
                           spInsertUpdate.Parameters.ParamByName('@GoodsPropertyID').Value := ADOQuery.FieldByName('Id').AsInteger;
                           spInsertUpdate.Parameters.ParamByName('@StartDate').Value := Date;
                           spInsertUpdate.ExecProc;
                         end;
                    end;
                    IncProgress;
                    ADOQuery.Next;
                 end;
              finally
                 Finish
              end;
         end;
         ADOConnection.Close;
      end;
end;

procedure TRepriceUnitForm.Button2Click(Sender: TObject);
var i: integer;
begin
  for i := 0 to CheckListBox.Items.Count - 1 do
      if CheckListBox.Checked[i] then begin
         UnitsCDS.Locate('UnitName', CheckListBox.Items[i], []);
         ADOConnection.ConnectionString := UnitsCDS.FieldByName('StringKey').AsString;
         ADOConnection.Open;

         ADOQuery.SQL.Text := 'SELECT GoodsProperty.GoodsName ' +
                   ' , GoodsProperty.Id, LastPrice.LastPrice, GoodsProperty.Code, LastPrice.CategoriesId ' +
                   ' FROM "DBA"."LastPrice" '+
                    'join GoodsProperty on GoodsProperty.Id = LastPrice.GoodsPropertyID ' +
                  ' where CategoriesId = zf_GetCategoriesOper(zc_bkSaleToUnit(), 0, ' + UnitsCDS.FieldByName('IntegerKey').AsString + ') ';
         ADOQuery.Close;
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
