unit SendOnPrice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TSendOnPriceForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    edOperDatePartner: TcxDateEdit;
    cxLabel10: TcxLabel;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountChangePercent: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    ChangePercentAmount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    CountForPrice: TcxGridDBColumn;
    AmountSumm: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    cxLabel11: TcxLabel;
    edPriceList: TcxButtonEdit;
    PriceListGuides: TdsdGuides;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    MeasureName: TcxGridDBColumn;
    PrintItemsSverkaCDS: TClientDataSet;
    actPrintOut: TdsdPrintAction;
    bbPrintOut: TdxBarButton;
    spSelectPrintOut: TdsdStoredProc;
    GoodsGroupNameFull: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    UnitChoiceForm: TOpenChoiceForm;
    actPrintUnit: TdsdPrintAction;
    bbPrintUnit: TdxBarButton;
    actGoodsChoiceForm: TOpenChoiceForm;
    cxLabel5: TcxLabel;
    edInvNumberOrder: TcxButtonEdit;
    GuidesInvNumberOrder: TdsdGuides;
    cbCalcAmountPartner: TcxCheckBox;
    edChangePercentAmount: TcxCurrencyEdit;
    cxLabel25: TcxLabel;
    edInvNumberTransport: TcxButtonEdit;
    ceComment: TcxTextEdit;
    cxLabel22: TcxLabel;
    TransportChoiceGuides: TdsdGuides;
    spInsertUpdateMovement_Params: TdsdStoredProc;
    HeaderSaver2: THeaderSaver;
    actIncomeJournalChoice: TOpenChoiceForm;
    mactUpdateMask: TMultiAction;
    spUpdateMask: TdsdStoredProc;
    actUpdateMask: TdsdExecStoredProc;
    bbUpdateMask: TdxBarButton;
    actPrinDiff: TdsdPrintAction;
    bbPrinDiff: TdxBarButton;
    spSelectPrint_SaleOrder: TdsdStoredProc;
    actPrintSaleOrder: TdsdPrintAction;
    bbPrintSaleOrder: TdxBarButton;
    cxLabel6: TcxLabel;
    edInvNumberProduction: TcxButtonEdit;
    GuidesProductionDoc: TdsdGuides;
    spSelectPrint_TTN: TdsdStoredProc;
    actDialog_TTN: TdsdOpenForm;
    actPrint_TTN: TdsdPrintAction;
    mactPrint_TTN: TMultiAction;
    bbPrint_TTN: TdxBarButton;
    spSelectPrint_Pack: TdsdStoredProc;
    actPrintPackGross1: TdsdPrintAction;
    bbPrintPackGross: TdxBarButton;
    actPrintPackGross: TdsdPrintAction;
    spSelectPrint_SaleOrderTax: TdsdStoredProc;
    actPrintSaleOrderTax: TdsdPrintAction;
    bbPrintSaleOrderTax: TdxBarButton;
    edIsChecked: TcxCheckBox;
    spChecked: TdsdStoredProc;
    actChecked: TdsdExecStoredProc;
    bbChecked: TdxBarButton;
    cxLabel26: TcxLabel;
    edReestrKind: TcxButtonEdit;
    cxLabel9: TcxLabel;
    edSubjectDoc: TcxButtonEdit;
    GuidesSubjectDoc: TdsdGuides;
    cxTabSheet1: TcxTabSheet;
    DetailDS_Reason: TDataSource;
    DetailCDS_Reason: TClientDataSet;
    spSelect_Detail: TdsdStoredProc;
    DBViewAddOn_Detail: TdsdDBViewAddOn;
    cxGridDetail: TcxGrid;
    cxGridDBTableViewDetail: TcxGridDBTableView;
    ord: TcxGridDBColumn;
    GoodsGroupNameFull_ch2: TcxGridDBColumn;
    GoodsCode_ch2: TcxGridDBColumn;
    GoodsName_ch2: TcxGridDBColumn;
    GoodsKindName_ch2: TcxGridDBColumn;
    MeasureName_ch2: TcxGridDBColumn;
    Amount_ch2: TcxGridDBColumn;
    ReasonCode_ch2: TcxGridDBColumn;
    ReasonName_ch2: TcxGridDBColumn;
    ReturnKindName_ch2: TcxGridDBColumn;
    isErased_ch2: TcxGridDBColumn;
    Value5_ch2: TcxGridDBColumn;
    Value10_ch2: TcxGridDBColumn;
    cxGridLevelDetail: TcxGridLevel;
    cxLabel27: TcxLabel;
    edReason: TcxButtonEdit;
    GuidesReason: TdsdGuides;
    spInsertUpdateMI_Detail: TdsdStoredProc;
    actUpdateDetailDS_Reason: TdsdUpdateDataSet;
    actReasonOpenForm: TOpenChoiceForm;
    spGetReporNameTTN: TdsdStoredProc;
    actSPPrintTTNProcName: TdsdExecStoredProc;
    mactUpdateMaskSale: TMultiAction;
    actSaleJournalChoice: TOpenChoiceForm;
    bbUpdateMaskSale: TdxBarButton;
    actOpenProductionUnitForm: TdsdOpenForm;
    bbOpenProductionUnitForm: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSendOnPriceForm);

end.
