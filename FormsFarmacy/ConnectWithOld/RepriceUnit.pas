unit RepriceUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Data.DB,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxCheckListBox, cxDBCheckListBox,
  Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, cxTextEdit, cxCurrencyEdit, cxLabel,
  Bde.DBTables, wwstorep;

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
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses SimpleGauge;

procedure TRepriceUnitForm.Button1Click(Sender: TObject);
var i: integer;
begin
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
