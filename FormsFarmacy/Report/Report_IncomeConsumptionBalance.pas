unit Report_IncomeConsumptionBalance;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
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
  Vcl.StdCtrls, Vcl.Menus, cxButtons, cxExportPivotGridLink,
  cxGridBandedTableView, cxGridDBBandedTableView;

type
  TReport_IncomeConsumptionBalanceForm = class(TForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    dsdStoredProc: TdsdStoredProc;
    bbToExcel: TdxBarButton;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    FormParams: TdsdFormParams;
    dsdOpenForm1: TdsdOpenForm;
    dsdExecStoredProc1: TdsdExecStoredProc;
    bbStaticText: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    bbPrint2: TdxBarButton;
    bb: TdxBarControlContainerItem;
    Panel2: TPanel;
    cxSplitter1: TcxSplitter;
    dsGoods: TDataSource;
    cdsGoods: TClientDataSet;
    cxgChoicePrpmo: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridDBColumn1: TcxGridDBColumn;
    cxGridDBColumn2: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxgChoiceGoods: TcxGrid;
    cxgChoiceGoodsDBTableView: TcxGridDBTableView;
    cxgChoiceGoodsDBTableViewColumn1: TcxGridDBColumn;
    cxgChoiceGoodsDBTableViewColumn2: TcxGridDBColumn;
    cxgChoiceGoodsLevel: TcxGridLevel;
    dsPromo: TDataSource;
    cdsPromo: TClientDataSet;
    cdsPromoGoods: TClientDataSet;
    dxBarButton1: TdxBarButton;
    actSetGoods: TAction;
    dxBarButton2: TdxBarButton;
    actSetPromo: TAction;
    Panel3: TPanel;
    Panel4: TPanel;
    cxSplitter2: TcxSplitter;
    Panel5: TPanel;
    Panel6: TPanel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    dxBarButton3: TdxBarButton;
    actExportExel: TdsdGridToExcel;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    Panel7: TPanel;
    cxButton3: TcxButton;
    actAddGoods: TAction;
    cxIncomeConsumptionBalance: TcxGrid;
    cxIncomeConsumptionBalanceDBBandedTableView1: TcxGridDBBandedTableView;
    colParentName: TcxGridDBBandedColumn;
    colUnitName: TcxGridDBBandedColumn;
    colGoodsId: TcxGridDBBandedColumn;
    colGoodsName: TcxGridDBBandedColumn;
    colSaldoIn: TcxGridDBBandedColumn;
    colSummaIn: TcxGridDBBandedColumn;
    colAmountIncome: TcxGridDBBandedColumn;
    colAmountIncomeSumWith: TcxGridDBBandedColumn;
    cxIncomeConsumptionBalanceLevel1: TcxGridLevel;
    colAmountIncomeSum: TcxGridDBBandedColumn;
    colAmountReturnOut: TcxGridDBBandedColumn;
    colAmountReturnOutSum: TcxGridDBBandedColumn;
    AmountCheck: TcxGridDBBandedColumn;
    AmountCheckSumJuridical: TcxGridDBBandedColumn;
    AmountCheckSum: TcxGridDBBandedColumn;
    AmountSale: TcxGridDBBandedColumn;
    AmountSaleSumJuridical: TcxGridDBBandedColumn;
    AmountSaleSum: TcxGridDBBandedColumn;
    AmountInventory: TcxGridDBBandedColumn;
    AmountInventorySum: TcxGridDBBandedColumn;
    AmountLoss: TcxGridDBBandedColumn;
    AmountLossSum: TcxGridDBBandedColumn;
    AmountSend: TcxGridDBBandedColumn;
    AmountSendSum: TcxGridDBBandedColumn;
    SaldoOut: TcxGridDBBandedColumn;
    SummaOut: TcxGridDBBandedColumn;
    AmountReturnIn: TcxGridDBBandedColumn;
    AmountReturnInSum: TcxGridDBBandedColumn;
    dsdStoredProcGoods: TdsdStoredProc;
    dsdStoredProcUnit: TdsdStoredProc;
    ClientDataSetTemp: TClientDataSet;
    cdsPromoUnit: TClientDataSet;
    ProgressBar1: TProgressBar;
    lblProggres1: TLabel;
    cxLabel3: TcxLabel;
    procedure actSetGoodsExecute(Sender: TObject);
    procedure actSetPromoExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actAddGoodsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dsdStoredProcUnitAfterExecute(Sender: TObject);
  private
  public
  end;

implementation

{$R *.dfm}

procedure TReport_IncomeConsumptionBalanceForm.actAddGoodsExecute(
  Sender: TObject);
var
  I, TovarID: Integer;
begin
  inherited;
  with cxIncomeConsumptionBalanceDBBandedTableView1.DataController.Filter do
  begin
    BeginUpdate;
    try
      root.BoolOperatorKind := TcxFilterBoolOperatorKind.fboOr;
      for I := 0 to cxgChoiceGoodsDBTableView.Controller.SelectedRecordCount - 1 do
      begin
        TovarID := cxgChoiceGoodsDBTableView.Controller.SelectedRecords[I].Values[cxgChoiceGoodsDBTableViewColumn1.Index];
//        root.AddItem(cxDBPivotGridField3, TcxFilterOperatorKind.foEqual, TovarID, IntToStr(TovarID));
      end;
      Active := true;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TReport_IncomeConsumptionBalanceForm.actSetGoodsExecute(
  Sender: TObject);
var
  I, TovarID: Integer;
begin
  inherited;
  with cxIncomeConsumptionBalanceDBBandedTableView1.DataController.Filter do
  begin
    BeginUpdate;
    try
      Clear;
      root.BoolOperatorKind := TcxFilterBoolOperatorKind.fboOr;
      for I := 0 to cxgChoiceGoodsDBTableView.Controller.SelectedRecordCount - 1 do
      begin
        TovarID := cxgChoiceGoodsDBTableView.Controller.SelectedRecords[I].Values[cxgChoiceGoodsDBTableViewColumn1.Index];
        root.AddItem(colGoodsId, TcxFilterOperatorKind.foEqual, TovarID, IntToStr(TovarID));
      end;
      Active := true;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TReport_IncomeConsumptionBalanceForm.actSetPromoExecute(
  Sender: TObject);
var
  I, TovarID: Integer;
begin
  inherited;

  cdsPromoGoods.Filter := 'PromoID = ' + QuotedStr(cdsPromo.FieldByName('PromoID').AsString);
  cdsPromoGoods.Filtered := True;
  try
    cdsPromoGoods.First;
    if cdsPromoGoods.Eof then Exit;

    with cxgChoiceGoodsDBTableView.DataController.Filter do
    begin
      BeginUpdate;
      try
        Clear;
        root.BoolOperatorKind := TcxFilterBoolOperatorKind.fboOr;
        while not cdsPromoGoods.Eof do
        begin
          TovarID := cdsPromoGoods.FieldByName('GoodsID').AsInteger;
          root.AddItem(cxgChoiceGoodsDBTableViewColumn1, TcxFilterOperatorKind.foEqual, TovarID, IntToStr(TovarID));
          cdsPromoGoods.Next;
        end;
        Active := true;
      finally
        EndUpdate;
      end;
    end;
  finally
    cdsPromoGoods.Filtered := False;
    cdsPromoGoods.Filter := '';
  end;
end;

procedure TReport_IncomeConsumptionBalanceForm.dsdStoredProcUnitAfterExecute(
  Sender: TObject);
begin
  try
    cxIncomeConsumptionBalanceDBBandedTableView1.DataController.DataSource := Nil;
    cdsPromoUnit.First;

    lblProggres1.Caption := IntToStr(cdsPromoUnit.RecNo)+' / '+IntToStr(cdsPromoUnit.RecordCount);
    lblProggres1.Repaint;
    ProgressBar1.Position := cdsPromoUnit.RecNo;
    ProgressBar1.Max := cdsPromoUnit.RecordCount;
    ProgressBar1.Repaint;
    Application.ProcessMessages;

    cxLabel3.Visible := True;
    lblProggres1.Visible := True;
    ProgressBar1.Visible := True;
    dsdStoredProc.ParamByName('inUnitId').Value := cdsPromoUnit.FieldByName('UnitId').AsInteger;
    dsdStoredProc.Execute;
    dsdStoredProc.DataSet := ClientDataSetTemp;
    cdsPromoUnit.Next;
    while not cdsPromoUnit.Eof do
    begin

      lblProggres1.Caption := IntToStr(cdsPromoUnit.RecNo)+' / '+IntToStr(cdsPromoUnit.RecordCount);
      lblProggres1.Repaint;
      ProgressBar1.Position := cdsPromoUnit.RecNo;
      ProgressBar1.Repaint;
      Application.ProcessMessages;

      ClientDataSetTemp.Close;
      dsdStoredProc.ParamByName('inUnitId').Value := cdsPromoUnit.FieldByName('UnitId').AsInteger;
      dsdStoredProc.Execute;
      if not ClientDataSetTemp.IsEmpty then ClientDataSet.AppendData(ClientDataSetTemp.Data, False);
      cdsPromoUnit.Next;
    end;
  finally
    dsdStoredProc.DataSet := ClientDataSet;
    cxIncomeConsumptionBalanceDBBandedTableView1.DataController.DataSource := DataSource;
    cxLabel3.Visible := False;
    lblProggres1.Visible := False;
    ProgressBar1.Visible := False;
    Application.ProcessMessages;
  end;
end;

procedure TReport_IncomeConsumptionBalanceForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  UserSettingsStorageAddOn.SaveUserSettings;
  Action:=caFree;
end;

procedure TReport_IncomeConsumptionBalanceForm.FormCreate(Sender: TObject);
begin
  UserSettingsStorageAddOn.LoadUserSettings;
end;

initialization
  RegisterClass(TReport_IncomeConsumptionBalanceForm);

end.
