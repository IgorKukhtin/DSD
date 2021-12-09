unit Report_Analysis_Remains_Selling;

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
  Vcl.StdCtrls, Vcl.Menus, cxButtons, cxExportPivotGridLink;

type
  TReport_Analysis_Remains_SellingForm = class(TForm)
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
    cxDBPivotGrid: TcxDBPivotGrid;
    pvUnitID: TcxDBPivotGridField;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    PivotAddOn: TPivotAddOn;
    FormParams: TdsdFormParams;
    dsdOpenForm1: TdsdOpenForm;
    dsdExecStoredProc1: TdsdExecStoredProc;
    bbStaticText: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    bbPrint2: TdxBarButton;
    bb: TdxBarControlContainerItem;
    pvUnitName: TcxDBPivotGridField;
    pvGoodsId: TcxDBPivotGridField;
    pvGoodsName: TcxDBPivotGridField;
    pvAmount: TcxDBPivotGridField;
    pvOutSaldo: TcxDBPivotGridField;
    pvGoodsGroupId: TcxDBPivotGridField;
    pvGoodsGroupName: TcxDBPivotGridField;
    pvNDSKindId: TcxDBPivotGridField;
    pvNDSKindName: TcxDBPivotGridField;
    pvPromoID: TcxDBPivotGridField;
    pvJuridicalID: TcxDBPivotGridField;
    pvJuridicalName: TcxDBPivotGridField;
    Panel2: TPanel;
    cxSplitter1: TcxSplitter;
    dsGoods: TDataSource;
    cdsGoods: TClientDataSet;
    cxDBPivotGrid1: TcxDBPivotGrid;
    cxDBPivotGridField1: TcxDBPivotGridField;
    cxDBPivotGridField2: TcxDBPivotGridField;
    cxDBPivotGridField3: TcxDBPivotGridField;
    cxDBPivotGridField4: TcxDBPivotGridField;
    cxDBPivotGridField5: TcxDBPivotGridField;
    cxDBPivotGridField6: TcxDBPivotGridField;
    cxDBPivotGridField7: TcxDBPivotGridField;
    cxDBPivotGridField8: TcxDBPivotGridField;
    cxDBPivotGridField9: TcxDBPivotGridField;
    cxDBPivotGridField10: TcxDBPivotGridField;
    dsdStoredProcGoods: TdsdStoredProc;
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
    dsdStoredProcPromo: TdsdStoredProc;
    dsPromo: TDataSource;
    cdsPromo: TClientDataSet;
    dsdStoredProcPromoGoods: TdsdStoredProc;
    dsPromoGoods: TDataSource;
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
    actExportExel: TAction;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    Panel7: TPanel;
    cxButton3: TcxButton;
    actAddGoods: TAction;
    cxDBPivotGridField11: TcxDBPivotGridField;
    cxDBPivotGridField12: TcxDBPivotGridField;
    cxDBPivotGridField13: TcxDBPivotGridField;
    cxDBPivotGridField14: TcxDBPivotGridField;
    cxDBPivotGridField15: TcxDBPivotGridField;
    cxDBPivotGridField16: TcxDBPivotGridField;
    Ord: TcxDBPivotGridField;
    cxDBPivotGrid1Field1: TcxDBPivotGridField;
    cxDBPivotGrid1Field2: TcxDBPivotGridField;
    cxDBPivotGrid1Field3: TcxDBPivotGridField;
    cxDBPivotGrid1Field4: TcxDBPivotGridField;
    cxDBPivotGrid1Field5: TcxDBPivotGridField;
    procedure actSetGoodsExecute(Sender: TObject);
    procedure actSetPromoExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actExportExelExecute(Sender: TObject);
    procedure actAddGoodsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cxDBPivotGrid1Field5GetDisplayText(Sender: TcxPivotGridField;
      ACell: TcxPivotGridDataCellViewInfo; var AText: string);
  private
  public
  end;

implementation

{$R *.dfm}

procedure TReport_Analysis_Remains_SellingForm.actAddGoodsExecute(
  Sender: TObject);
var
  I, TovarID: Integer;
begin
  inherited;
  with cxDBPivotGrid1.DataController.Filter do
  begin
    BeginUpdate;
    try
      root.BoolOperatorKind := TcxFilterBoolOperatorKind.fboOr;
      for I := 0 to cxgChoiceGoodsDBTableView.Controller.SelectedRecordCount - 1 do
      begin
        TovarID := cxgChoiceGoodsDBTableView.Controller.SelectedRecords[I].Values[cxgChoiceGoodsDBTableViewColumn1.Index];
        root.AddItem(cxDBPivotGridField3, TcxFilterOperatorKind.foEqual, TovarID, IntToStr(TovarID));
      end;
      Active := true;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TReport_Analysis_Remains_SellingForm.actExportExelExecute(Sender: TObject);
  var FileName : string;
begin
  FileName := 'ExportAnalysis.xls';
  try
    cxDBPivotGrid1.OptionsView.FilterFields := False;
    cxDBPivotGrid1.OptionsView.ColumnFields := False;
    cxDBPivotGrid1.OptionsView.DataFields := False;
    cxExportPivotGridToExcel(FileName, cxDBPivotGrid1, False);
    ShellExecute(Application.Handle, 'open', PWideChar(FileName), nil, nil, SW_SHOWNORMAL);
  finally
    cxDBPivotGrid1.OptionsView.FilterFields := True;
    cxDBPivotGrid1.OptionsView.ColumnFields := True;
    cxDBPivotGrid1.OptionsView.DataFields := True;
  end;
end;

procedure TReport_Analysis_Remains_SellingForm.actSetGoodsExecute(
  Sender: TObject);
var
  I, TovarID: Integer;
begin
  inherited;
  with cxDBPivotGrid1.DataController.Filter do
  begin
    BeginUpdate;
    try
      Clear;
      root.BoolOperatorKind := TcxFilterBoolOperatorKind.fboOr;
      for I := 0 to cxgChoiceGoodsDBTableView.Controller.SelectedRecordCount - 1 do
      begin
        TovarID := cxgChoiceGoodsDBTableView.Controller.SelectedRecords[I].Values[cxgChoiceGoodsDBTableViewColumn1.Index];
        root.AddItem(cxDBPivotGridField3, TcxFilterOperatorKind.foEqual, TovarID, IntToStr(TovarID));
      end;
      Active := true;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TReport_Analysis_Remains_SellingForm.actSetPromoExecute(
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

procedure TReport_Analysis_Remains_SellingForm.cxDBPivotGrid1Field5GetDisplayText(
  Sender: TcxPivotGridField; ACell: TcxPivotGridDataCellViewInfo;
  var AText: string);
begin
  if AText = 'True' then AText := 'Да' else AText := 'Нет';
end;

procedure TReport_Analysis_Remains_SellingForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  UserSettingsStorageAddOn.SaveUserSettings;
  Action:=caFree;
end;

procedure TReport_Analysis_Remains_SellingForm.FormCreate(Sender: TObject);
begin
  UserSettingsStorageAddOn.LoadUserSettings;
end;

initialization
  RegisterClass(TReport_Analysis_Remains_SellingForm);

end.
