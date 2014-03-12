unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Data.DB,
  Bde.DBTables, Vcl.Mask, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdDB, Datasnap.DBClient;

type
  TMainForm = class(TForm)
    GridPanel: TPanel;
    DBGrid: TDBGrid;
    ButtonPanel: TPanel;
    ButtonSaveAllItem: TSpeedButton;
    ButtonDeleteItem: TSpeedButton;
    ButtonExit: TSpeedButton;
    ButtonCancelItem: TSpeedButton;
    ButtonRefresh: TSpeedButton;
    ButtonRefreshZakaz: TSpeedButton;
    ButtonNewGetParams: TSpeedButton;
    ButtonPrintBill_detail_byInvNumber: TSpeedButton;
    ButtonChangePartionDate: TSpeedButton;
    ButtonChangeNumberTare: TSpeedButton;
    ButtonChangeNumberLevel: TSpeedButton;
    ButtonExportToMail: TSpeedButton;
    ButtonChangeMember: TSpeedButton;
    ButtonExportToEDI: TSpeedButton;
    ButtonChangePartionStr: TSpeedButton;
    infoPanelTotalSumm: TPanel;
    GBTotalSummGoods_Weight: TGroupBox;
    PanelTotalSummGoods_Weight: TPanel;
    TotalSummTare_Weight: TGroupBox;
    PanelTotalSummTare_Weight: TPanel;
    GBTotalSummGoods_Weight_Discount: TGroupBox;
    PanelTotalSummGoods_Weight_Discount: TPanel;
    gbTotalSumm: TGroupBox;
    PanelTotalSumm: TPanel;
    PanelZakaz: TPanel;
    GroupBox1: TGroupBox;
    DiffZakazSalePanel: TPanel;
    GroupBox2: TGroupBox;
    ZakazCountPanel: TPanel;
    GroupBox3: TGroupBox;
    ZakazChangePanel: TPanel;
    GroupBox4: TGroupBox;
    calcZakazCountPanel: TPanel;
    GroupBox5: TGroupBox;
    SaleCountPanel: TPanel;
    GroupBox6: TGroupBox;
    TotalDiffZakazSalePanel: TPanel;
    GroupBox7: TGroupBox;
    TotalZakazCountPanel: TPanel;
    PanelSaveItem: TPanel;
    ButtonSaveItem: TSpeedButton;
    CodeInfoPanel: TPanel;
    EnterGoodsCodeScanerPanel: TPanel;
    EnterGoodsCodeScanerLabel: TLabel;
    EnterGoodsCodeScanerEdit: TEdit;
    EnterWeightPanel: TPanel;
    EnterWeightLabel: TLabel;
    EnterWeightEdit: TEdit;
    gbBillDate: TGroupBox;
    EnterGoodsCode_byZakazPanel: TPanel;
    EnterGoodsCode_byZakazLabel: TLabel;
    EnterGoodsCode_byZakazEdit: TEdit;
    PanelCountTare: TPanel;
    LabelCountTare: TLabel;
    CountTareEdit: TEdit;
    infoPanel_Scale: TPanel;
    ScaleLabel: TLabel;
    Panel_Scale: TPanel;
    EnterKindPackageCode_byZakazPanel: TPanel;
    EnterKindPackageCode_byZakazLabel: TLabel;
    EnterKindPackageCode_byZakazEdit: TEdit;
    EnterKindPackageName_byZakazPanel: TPanel;
    gbPartionDate: TGroupBox;
    PanelCountPoddon: TPanel;
    LabelCountPoddon: TLabel;
    CountPoddonEdit: TEdit;
    PanelCountVanna: TPanel;
    LabelCountVanna: TLabel;
    CountVannaEdit: TEdit;
    PanelCountUpakovka: TPanel;
    LabelCountUpakovka: TLabel;
    CountUpakovkaEdit: TEdit;
    PanelPartionStr_MB: TPanel;
    PartionStr_MBLabel: TLabel;
    Panel1: TPanel;
    infoPanelPartionStr_MB: TPanel;
    PartionStr_MBEdit: TEdit;
    PanelOperCount_sh: TPanel;
    LabelOperCount_sh: TLabel;
    OperCount_shEdit: TEdit;
    PanelInfoItem: TPanel;
    PanelProduction_Goods: TPanel;
    LabelProduction_Goods: TLabel;
    GBProduction_GoodsCode: TGroupBox;
    PanelProduction_GoodsCode: TPanel;
    EditProduction_GoodsCode: TEdit;
    GBProduction_Goods_Weight: TGroupBox;
    PanelProduction_Goods_Weight: TPanel;
    GBProduction_GoodsName: TGroupBox;
    PanelProduction_GoodsName: TPanel;
    PanelTare_Goods: TPanel;
    LabelTare_Goods: TLabel;
    GBTare_GoodsCode: TGroupBox;
    PanelTare_GoodsCode: TPanel;
    GBTare_Goods_Weight: TGroupBox;
    PanelTare_Goods_Weight: TPanel;
    GBTare_GoodsName: TGroupBox;
    PanelTare_GoodsName: TPanel;
    gbTare_Goods_Count: TGroupBox;
    PanelTare_Goods_Count: TPanel;
    PanelSpace1: TPanel;
    PanelSpace2: TPanel;
    infoPanelTotalWeight: TPanel;
    GBTotalWeight: TGroupBox;
    PanelTotalWeight: TPanel;
    GBDiscountWeight: TGroupBox;
    PanelDiscountWeight: TPanel;
    PanelInfo: TPanel;
    PanelMessage: TPanel;
    GBPassword: TGroupBox;
    PanelPassword: TPanel;
    PanelBillKind: TPanel;
    infoPanel: TPanel;
    PanelPartner: TPanel;
    LabelPartner: TLabel;
    PanelPartnerCode: TPanel;
    EditPartnerCode: TEdit;
    PanelPartnerName: TPanel;
    PanelPriceList: TPanel;
    PriceListNameLabel: TLabel;
    PanelPriceListName: TPanel;
    PanelRouteUnit: TPanel;
    LabelRouteUnit: TLabel;
    PanelRouteUnitCode: TPanel;
    PanelRouteUnitName: TPanel;
    PanelIsRecalc: TPanel;
    DataSource: TDataSource;
    Query: TQuery;
    QueryProduction_Code: TIntegerField;
    QueryProduction_Name: TStringField;
    QueryKindPackageName: TStringField;
    QueryPartionStr_MB: TStringField;
    QueryPartionDate: TDateField;
    QueryPriceListName: TStringField;
    QueryDiscountWeight: TFloatField;
    QueryProduction_Weight_Discount: TFloatField;
    QueryProduction_Weight: TFloatField;
    QueryTare_Weight: TFloatField;
    QueryTare_Count: TFloatField;
    QueryTare_Code: TIntegerField;
    QueryTare_Name: TStringField;
    QueryNumberTare: TIntegerField;
    QueryNumberLevel: TIntegerField;
    QueryInsertDate: TDateTimeField;
    QueryUpdateDate: TDateTimeField;
    QueryLastPrice: TFloatField;
    QueryToatlSumm: TFloatField;
    QueryId: TIntegerField;
    QueryKindPackageId: TIntegerField;
    QueryisErased: TSmallintField;
    QueryOperCount_Upakovka: TFloatField;
    QueryBillKindName: TStringField;
    QueryOperCount_sh: TFloatField;
    QueryZakaz: TQuery;
    PopupMenu: TPopupMenu;
    miPrintZakazMinus: TMenuItem;
    miPrintZakazAll: TMenuItem;
    miLine11: TMenuItem;
    miPrintBill_byInvNumber: TMenuItem;
    miPrintBill_andNaliog_byInvNumber: TMenuItem;
    miPrintBillTotal_byClient: TMenuItem;
    miPrintBillTotal_byFozzi: TMenuItem;
    miLine12: TMenuItem;
    miPrintSchet_byInvNumber: TMenuItem;
    miPrintBillTransport_byInvNumber: TMenuItem;
    miPrintBillTransportNew_byInvNumber: TMenuItem;
    miPrintBillKachestvo_byInvNumber: TMenuItem;
    miPrintBillNumberTare_byInvNumber: TMenuItem;
    miPrintBillNotice_byInvNumber: TMenuItem;
    miLine13: TMenuItem;
    miPrintSaleAll: TMenuItem;
    miPrint_Report_byTare: TMenuItem;
    miPrint_Report_byMemberProduction: TMenuItem;
    miLine14: TMenuItem;
    miScaleIni_DB: TMenuItem;
    miScaleIni_BI: TMenuItem;
    miScaleIni_Zeus: TMenuItem;
    miScaleIni_BI_R: TMenuItem;
    miLine15: TMenuItem;
    miScaleRun_DB: TMenuItem;
    miScaleRun_BI: TMenuItem;
    miScaleRun_Zeus: TMenuItem;
    miScaleRun_BI_R: TMenuItem;
    LockTimer: TTimer;
    PartionDateEdit: TcxDateEdit;
    cxDateEdit1: TcxDateEdit;
    spTest: TdsdStoredProc;
    DataSource1: TDataSource;
    ClientDataSet: TClientDataSet;
    procedure ButtonExportToEDIClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.ButtonExportToEDIClick(Sender: TObject);
begin
 spTest.Execute;
end;

end.
