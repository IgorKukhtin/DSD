unit PromoTrade;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxSplitter, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCheckBox, cxEditRepositoryItems, cxImageComboBox, dsdCommon, ExternalLoad;

type
  TPromoTradeForm = class(TAncestorDocumentForm)
    GuidesPromoKind: TdsdGuides;
    cxLabel4: TcxLabel;
    edPromoKind: TcxButtonEdit;
    cxLabel5: TcxLabel;
    deStartPromo: TcxDateEdit;
    cxLabel6: TcxLabel;
    deEndPromo: TcxDateEdit;
    cxLabel9: TcxLabel;
    deOperDateStart: TcxDateEdit;
    cxLabel10: TcxLabel;
    deOperDateEnd: TcxDateEdit;
    edCostPromo: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    edComment: TcxTextEdit;
    GuidesPersonalTrade: TdsdGuides;
    cxLabel14: TcxLabel;
    edPersonalTrade: TcxButtonEdit;
    cxLabel16: TcxLabel;
    edPromoItem: TcxButtonEdit;
    GuidesPromoItem: TdsdGuides;
    GuidesContract: TdsdGuides;
    edContract: TcxButtonEdit;
    cxLabel17: TcxLabel;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    actGoodsChoiceForm: TOpenChoiceForm;
    InsertRecord: TInsertRecord;
    actGoodsKindChoiceForm: TOpenChoiceForm;
    bbInsertRecord: TdxBarButton;
    cxGridMov3: TcxGrid;
    cxGridDBTableViewMov3: TcxGridDBTableView;
    Name_ch3: TcxGridDBColumn;
    cxGridLevelMov3: TcxGridLevel;
    spSelect_PromoTradeCondition: TdsdStoredProc;
    Mov1CDS: TClientDataSet;
    Mov1DS: TDataSource;
    dsdDBViewAddOnMov1: TdsdDBViewAddOn;
    Panel1: TPanel;
    cxPageControl1: TcxPageControl;
    tsPartner: TcxTabSheet;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    PrintHead: TClientDataSet;
    spSelect_Movement_Promo_Print: TdsdStoredProc;
    Mov2CDS: TClientDataSet;
    Mov2DS: TDataSource;
    spErasedAdvertising: TdsdStoredProc;
    spUnErasedAdvertising: TdsdStoredProc;
    spInsertUpdateMIAdvertising: TdsdStoredProc;
    spSelect_PromoTradeHistory: TdsdStoredProc;
    cxPageControl3: TcxPageControl;
    tsAdvertising: TcxTabSheet;
    cxGridMov2: TcxGrid;
    cxGridDBTableViewMov2: TcxGridDBTableView;
    Name_ch2: TcxGridDBColumn;
    cxGridLevelMov2: TcxGridLevel;
    cxSplitter3: TcxSplitter;
    Comment: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    TradeMarkName: TcxGridDBColumn;
    Value_ch3: TcxGridDBColumn;
    actPartnerProtocolOpenForm: TdsdOpenForm;
    actConditionPromoProtocolOpenForm: TdsdOpenForm;
    actAdvertisingProtocolOpenForm: TdsdOpenForm;
    spInsertUpdateMISign_No: TdsdStoredProc;
    spInsertUpdateMISign_Yes: TdsdStoredProc;
    actInsertUpdateMISignNo: TdsdExecStoredProc;
    actInsertUpdateMISignYes: TdsdExecStoredProc;
    bbInsertUpdateMISignYes: TdxBarButton;
    bbInsertUpdateMISignNo: TdxBarButton;
    cxLabel21: TcxLabel;
    edStrSign: TcxTextEdit;
    edStrSignNo: TcxTextEdit;
    cxLabel22: TcxLabel;
    mactInsertUpdateMISignYes: TMultiAction;
    mactInsertUpdateMISignNo: TMultiAction;
    actRefresh_Get: TdsdDataSetRefresh;
    SignCDS: TClientDataSet;
    SignDS: TDataSource;
    dsdDBViewAddOnSign: TdsdDBViewAddOn;
    spSelectMISign: TdsdStoredProc;
    actUpdateCalcDS: TdsdUpdateDataSet;
    actPrint_Calc: TdsdPrintAction;
    actOpenReportForm: TdsdOpenForm;
    actGoodsKindCompleteChoiceForm: TOpenChoiceForm;
    cxSplitter4: TcxSplitter;
    spInsertUpdateMIMessage: TdsdStoredProc;
    actUserChoice: TOpenChoiceForm;
    actUpdateDataSetMessage: TdsdUpdateDataSet;
    actUpdateMov1DS: TdsdUpdateDataSet;
    cxLabel25: TcxLabel;
    edSignInternal: TcxButtonEdit;
    GuidesSignInternal: TdsdGuides;
    actPrint_Calc2: TdsdPrintAction;
    actUpdate_Movement_isTaxPromo: TdsdExecStoredProc;
    actOpenReport_SaleReturn_byPromo: TdsdOpenForm;
    bsGoods: TdxBarSubItem;
    bsSign: TdxBarSubItem;
    dxBarSeparator1: TdxBarSeparator;
    actUpdate_SignInternal_One: TdsdExecStoredProc;
    actUpdate_SignInternal_Two: TdsdExecStoredProc;
    bbUpdate_SignInternal_One: TdxBarButton;
    bbUpdate_SignInternal_Two: TdxBarButton;
    spUpdate_SignInternal_One: TdsdStoredProc;
    spUpdate_SignInternal_Two: TdsdStoredProc;
    actPrint_CalcAll: TdsdPrintAction;
    cxEditRepository1: TcxEditRepository;
    cxEditRepository1CurrencyItem1: TcxEditRepositoryCurrencyItem;
    cxEditRepository1CurrencyItem2: TcxEditRepositoryCurrencyItem;
    dsdDBViewAddOnMov2: TdsdDBViewAddOn;
    actRefreshCalc: TdsdDataSetRefresh;
    actOpenFormPromoContractBonus_Detail: TdsdOpenForm;
    actUpdate_SignInternal_Three: TdsdExecStoredProc;
    spUpdate_SignInternal_Three: TdsdStoredProc;
    bbUpdate_SignInternal_Three: TdxBarButton;
    dxBarSeparator2: TdxBarSeparator;
    bbUpdatePromoStateKind_Complete: TdxBarButton;
    bbUpdatePromoStateKind_Return: TdxBarButton;
    dxBarSeparator3: TdxBarSeparator;
    actChoiceTradeMark: TOpenChoiceForm;
    actChoiceGoodsGroupPropertyParent: TOpenChoiceForm;
    actChoiceGoodsGroupDirection: TOpenChoiceForm;
    Value_ch2: TcxGridDBColumn;
    cxLabel20: TcxLabel;
    edContractTag: TcxButtonEdit;
    GuidesContractTag: TdsdGuides;
    cxLabel3: TcxLabel;
    ceJuridical: TcxButtonEdit;
    GuidesContractJuridical: TdsdGuides;
    GuidesJuridical: TdsdGuides;
    cxLabel7: TcxLabel;
    ceRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    Ord: TcxGridDBColumn;
    actChoiceGoodsGroupProperty: TOpenChoiceForm;
    spInsertUpdate_PromoTradeCondition: TdsdStoredProc;
    spUpdate_PromoTradeHistory: TdsdStoredProc;
    actUpdate_PromoTradeHistory: TdsdExecStoredProc;
    bbUpdate_PromoTradeHistory: TdxBarButton;
    AmountSale: TcxGridDBColumn;
    SummSale: TcxGridDBColumn;
    AmountReturnIn: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    cxPageControl2: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxGridMov1: TcxGrid;
    cxGridDBTableViewMov1: TcxGridDBTableView;
    Name_ch1: TcxGridDBColumn;
    Value_ch1: TcxGridDBColumn;
    cxGridLeveMov1: TcxGridLevel;
    Mov3DS: TDataSource;
    Mov3CDS: TClientDataSet;
    dsdDBViewAddOnMov3: TdsdDBViewAddOn;
    spSelect_PromoTradeSign: TdsdStoredProc;
    actChoiceMember: TOpenChoiceForm;
    actUpdateMov3DS: TdsdUpdateDataSet;
    spInsertUpdate_PromoTradeSign: TdsdStoredProc;
    PartnerName: TcxGridDBColumn;
    actChoicePartner: TOpenChoiceForm;
    spGetImportSetting: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting: TdsdExecStoredProc;
    macStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    AmountPlan: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
    PriceWithOutVAT: TcxGridDBColumn;
    SummWithOutVATPlan: TcxGridDBColumn;
    SummWithVATPlan: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromoTradeForm);

end.
