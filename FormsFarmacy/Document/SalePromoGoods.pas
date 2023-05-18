unit SalePromoGoods;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, ExternalLoad, cxCheckBox,
  dsdExportToXLSAction, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TSalePromoGoodsForm = class(TAncestorDocumentForm)
    MasterGoodsCode: TcxGridDBColumn;
    MasterGoodsName: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chJuridicalName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    ChildDCS: TClientDataSet;
    ChildDS: TDataSource;
    spSelect_MovementItem_SalePromoGoodsChild: TdsdStoredProc;
    cxSplitter1: TcxSplitter;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    IsErased: TcxGridDBColumn;
    spInsertUpdateMIChild: TdsdStoredProc;
    cxLabel3: TcxLabel;
    cxLabel6: TcxLabel;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMIChild: TdsdStoredProc;
    actMISetErasedChild: TdsdUpdateErased;
    actMISetUnErasedChild: TdsdUpdateErased;
    bbMISetErasedChild: TdxBarButton;
    bbMISetUnErasedChild: TdxBarButton;
    actUpdateChildDS: TdsdUpdateDataSet;
    JuridicalChoiceForm: TOpenChoiceForm;
    actDoLoad: TExecuteImportSettingsAction;
    spGetImportSettingId: TdsdStoredProc;
    bbactStartLoad: TdxBarButton;
    bbInsertRecordChild: TdxBarButton;
    bbOpenReportForm: TdxBarButton;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    SignDCS: TClientDataSet;
    SignDS: TDataSource;
    dsdDBViewAddOn2: TdsdDBViewAddOn;
    spSelect_MovementItem_SalePromoGoodsSign: TdsdStoredProc;
    sgGoodsName: TcxGridDBColumn;
    bbInsertRecordPartner: TdxBarButton;
    spInsertUpdateSalePromoGoodsSign: TdsdStoredProc;
    dsdUpdateSignDS: TdsdUpdateDataSet;
    spUpErasedMISign: TdsdStoredProc;
    actSetErasedSalePromoGoodsSign: TdsdUpdateErased;
    actSetUnErasedSalePromoGoodsSign: TdsdUpdateErased;
    bbSetErasedPromoPartner: TdxBarButton;
    bbSetUnErasedPromoPartner: TdxBarButton;
    actRefreshSalePromoGoodsSign: TdsdDataSetRefresh;
    bbInsertSalePromoGoodsSign: TdxBarButton;
    bbReportMinPriceForm: TdxBarButton;
    bbOpenReportMinPrice_All: TdxBarButton;
    cxLabel10: TcxLabel;
    edInsertName: TcxButtonEdit;
    GuidesInsert: TdsdGuides;
    cxLabel11: TcxLabel;
    edUpdateName: TcxButtonEdit;
    GuidesUpdate: TdsdGuides;
    cxLabel12: TcxLabel;
    edInsertdate: TcxDateEdit;
    cxLabel13: TcxLabel;
    edUpdateDate: TcxDateEdit;
    spErasedMISign: TdsdStoredProc;
    sgGoodsCode: TcxGridDBColumn;
    cxSplitter2: TcxSplitter;
    bbGoodsIsCheckedYes: TdxBarButton;
    bbGoodsIsCheckedNo: TdxBarButton;
    actRefreshSalePromoGoodsGoods: TdsdDataSetRefresh;
    spUpdateSignIsCheckedNo: TdsdExecStoredProc;
    spUpdateSignIsCheckedYes: TdsdExecStoredProc;
    actRefreshSalePromoGoodsChild: TdsdDataSetRefresh;
    bbChildIsCheckedNo: TdxBarButton;
    bbChildIsCheckedYes: TdxBarButton;
    bbSignIsCheckedNo: TdxBarButton;
    bbSignIsCheckedYes: TdxBarButton;
    Panel1: TPanel;
    Panel2: TPanel;
    spSelectSalePromoGoodsInfo: TdsdStoredProc;
    MasterErased: TcxGridDBColumn;
    edEndPromo: TcxDateEdit;
    edStartPromo: TcxDateEdit;
    chIsChecked: TcxGridDBColumn;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    PrintTitleCDS: TClientDataSet;
    dxBarButton3: TdxBarButton;
    dsdDBViewAddOn3: TdsdDBViewAddOn;
    cxLabel19: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    bbInsertPromoCode: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    bbOpenCheckCreate: TdxBarButton;
    bbOpenCheckSale: TdxBarButton;
    MasterAmount: TcxGridDBColumn;
    sqAmount: TcxGridDBColumn;
    MasterPrice: TcxGridDBColumn;
    cbAmountCheck: TcxCheckBox;
    ceAmountCheck: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    cbDiscountInformation: TcxCheckBox;
    MasterDiscount: TcxGridDBColumn;
    mactUnitChecked: TMultiAction;
    actUnitChecked: TdsdExecStoredProc;
    dxBarButton8: TdxBarButton;
    spUnitChecked: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSalePromoGoodsForm);

end.
