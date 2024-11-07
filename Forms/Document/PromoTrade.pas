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
    DBViewAddOnMov1: TdsdDBViewAddOn;
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
    spUnErasedAdvertising: TdsdStoredProc;
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
    actInsertUpdateMISignNo: TdsdExecStoredProc;
    actInsertUpdateMISignYes: TdsdExecStoredProc;
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
    actUpdate_Movement_isTaxPromo: TdsdExecStoredProc;
    actOpenReport_SaleReturn_byPromo: TdsdOpenForm;
    bsGoods: TdxBarSubItem;
    bsSign: TdxBarSubItem;
    spUpdate_SignInternal_Two: TdsdStoredProc;
    actPrint_CalcAll: TdsdPrintAction;
    cxEditRepository1: TcxEditRepository;
    cxEditRepository1CurrencyItem1: TcxEditRepositoryCurrencyItem;
    cxEditRepository1CurrencyItem2: TcxEditRepositoryCurrencyItem;
    DBViewAddOnMov2: TdsdDBViewAddOn;
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
    DBViewAddOnMov3: TdsdDBViewAddOn;
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
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    Amount_weight: TcxGridDBColumn;
    AmountPlan_weight: TcxGridDBColumn;
    HeaderExit: THeaderExit;
    spGet_OperDate: TdsdStoredProc;
    actGet_OperDate: TdsdDataSetRefresh;
    cxGridPromoStateKind: TcxGrid;
    cxGridDBTableViewPromoStateKind: TcxGridDBTableView;
    psOrd: TcxGridDBColumn;
    psPromoStateKindName: TcxGridDBColumn;
    psComment: TcxGridDBColumn;
    psInsertName: TcxGridDBColumn;
    psInsertDate: TcxGridDBColumn;
    psIsErased: TcxGridDBColumn;
    cxGridLevel4: TcxGridLevel;
    PromoStateKindDCS: TClientDataSet;
    PromoStateKindDS: TDataSource;
    spSelectMIPromoStateKind: TdsdStoredProc;
    DBViewAddOnPromoStateKind: TdsdDBViewAddOn;
    spUpdate_PromoStateKind: TdsdStoredProc;
    spGetPromoTradeStateKind: TdsdStoredProc;
    actUpdateMovement_PromoTradeStateKind: TdsdExecStoredProc;
    actPromoTradeDialog: TExecuteDialog;
    actGetPromoStateKind_Return: TdsdDataSetRefresh;
    actGetPromoStateKind_Complete: TdsdDataSetRefresh;
    macUpdatePromoTradeStateKind_Return: TMultiAction;
    macUpdatePromoTradeStateKind_Complete: TMultiAction;
    cxSplitter2: TcxSplitter;
    dxBarButton1: TdxBarButton;
    spUpdate_PromoStateKind_del: TdsdStoredProc;
    actUpdateMovement_PromoTradeStateKind_del: TdsdExecStoredProc;
    actGet_SignPrint: TdsdExecStoredProc;
    macPrint: TMultiAction;
    spGet_SignPrint: TdsdStoredProc;
    PrintSignCDS: TClientDataSet;
    Value_2_ch2: TcxGridDBColumn;
    cxLabel8: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    InsertRecordTM: TInsertRecord;
    InsertRecordGGPP: TInsertRecord;
    InsertRecordGGP: TInsertRecord;
    InsertRecordGD: TInsertRecord;
    bbInsertRecordTM: TdxBarButton;
    bbInsertRecordGGP: TdxBarButton;
    bbInsertRecordGGPP: TdxBarButton;
    bbInsertRecordGD: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    spErasedMIMaster_all: TdsdStoredProc;
    actSetErasedMIMaster_all: TdsdExecStoredProc;
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
