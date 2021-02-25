unit Income;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxCurrencyEdit, dsdAddOn,
  dsdAction, cxCheckBox, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxBarBuiltInMenu, cxNavigator, cxImageComboBox,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCalc, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  TIncomeForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    bbPrintTax: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTax: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    Summ: TcxGridDBColumn;
    edPriceWithVAT: TcxCheckBox;
    cxLabel10: TcxLabel;
    edNDSKind: TcxButtonEdit;
    NDSKindGuides: TdsdGuides;
    Price: TcxGridDBColumn;
    PartnerGoodsCode: TcxGridDBColumn;
    PartnerGoodsName: TcxGridDBColumn;
    GuidesContract: TdsdGuides;
    cxLabel5: TcxLabel;
    edContract: TcxButtonEdit;
    edPaymentDate: TcxDateEdit;
    cxLabel6: TcxLabel;
    ExpirationDate: TcxGridDBColumn;
    ceTotalSummMVAT: TcxCurrencyEdit;
    ceTotalSummPVAT: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    PartitionGoods: TcxGridDBColumn;
    MakerName: TcxGridDBColumn;
    actRefreshGoodsCode: TdsdExecStoredProc;
    bbRefreshGoodsCode: TdxBarButton;
    spIncome_GoodsId: TdsdStoredProc;
    FEA: TcxGridDBColumn;
    Measure: TcxGridDBColumn;
    spCalculateSalePrice: TdsdStoredProc;
    actCalculateSalePrice: TdsdExecStoredProc;
    bbCalculateSalePrice: TdxBarButton;
    SalePrice: TcxGridDBColumn;
    SaleSumm: TcxGridDBColumn;
    Percent: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
    cxLabel9: TcxLabel;
    edPointNumber: TcxTextEdit;
    cxLabel11: TcxLabel;
    edPointDate: TcxDateEdit;
    cbFarmacyShow: TcxCheckBox;
    cxLabel12: TcxLabel;
    DublePriceColour: TcxGridDBColumn;
    SertificatNumber: TcxGridDBColumn;
    SertificatStart: TcxGridDBColumn;
    SertificatEnd: TcxGridDBColumn;
    WarningColor: TcxGridDBColumn;
    AVGIncomePrice: TcxGridDBColumn;
    AVGIncomePriceWarning: TcxGridDBColumn;
    cxLabel13: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    AmountManual: TcxGridDBColumn;
    ReasonDifferencesName: TcxGridDBColumn;
    AmountDiff: TcxGridDBColumn;
    spUpdate_MovementItem_Income_AmountManual: TdsdStoredProc;
    chbIsPay: TcxCheckBox;
    ‚ÛDateLastPay: TcxDateEdit;
    cxLabel17: TcxLabel;
    spUpdateIncome_PartnerData: TdsdStoredProc;
    mactEditPartnerData: TMultiAction;
    actPartnerDataDialod: TExecuteDialog;
    actUpdateIncome_PartnerData: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    cbisDocument: TcxCheckBox;
    spisDocument: TdsdStoredProc;
    actisDocument: TdsdExecStoredProc;
    bbisDocument: TdxBarButton;
    JuridicalPrice: TcxGridDBColumn;
    JuridicalPriceWithVAT: TcxGridDBColumn;
    edInvNumberOrder: TcxButtonEdit;
    cxLabel25: TcxLabel;
    OrderExternalChoiceGuides: TdsdGuides;
    PersentDiff: TcxGridDBColumn;
    spUpdateMovementIncome_OrderExt: TdsdStoredProc;
    HeaderSaver1: THeaderSaver;
    Color_ExpirationDate: TcxGridDBColumn;
    cbisRegistered: TcxCheckBox;
    actPrintStickerOld: TdsdPrintAction;
    spSelectPrintSticker: TdsdStoredProc;
    actPrintSticker: TdsdPrintAction;
    PrintCount: TcxGridDBColumn;
    isPrint: TcxGridDBColumn;
    actPrintSticker_notPrice: TdsdPrintAction;
    bbPrintSticker_notPrice: TdxBarButton;
    cbisDeferred: TcxCheckBox;
    spUpdate_isDeferred_Yes: TdsdStoredProc;
    spUpdate_isDeferred_No: TdsdStoredProc;
    spUpdateisDeferredNo: TdsdExecStoredProc;
    spUpdateisDeferredYes: TdsdExecStoredProc;
    bbUpdateisDeferredYes: TdxBarButton;
    bbUpdateisDeferredNo: TdxBarButton;
    InsertName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    cxLabel14: TcxLabel;
    edMemberIncomeCheck: TcxTextEdit;
    edCheckDate: TcxDateEdit;
    cxLabel16: TcxLabel;
    spUpdate_Check: TdsdStoredProc;
    actUpdateCheck: TdsdDataSetRefresh;
    ExecuteDialogCheck: TExecuteDialog;
    macUpdateCheck: TMultiAction;
    bbUpdateCheck: TdxBarButton;
    actPrintReestr: TdsdPrintAction;
    bbPrintReestr: TdxBarButton;
    bbComplete: TdxBarButton;
    spMovementComplete: TdsdStoredProc;
    actComplete: TdsdExecStoredProc;
    macCalculateSalePrice: TMultiAction;
    actUpdate_OrderExternal_Deferred: TdsdExecStoredProc;
    spUpdate_OrderExternal_Deferred: TdsdStoredProc;
    RetailName: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    actShowMessage: TShowMessageAction;
    spLinkCheck: TdsdStoredProc;
    actLinkCheck: TdsdExecStoredProc;
    spCheckObject: TdsdStoredProc;
    actCheckObject: TdsdExecStoredProc;
    cbDifferent: TcxCheckBox;
    cxLabel18: TcxLabel;
    edComment: TcxTextEdit;
    spUpdate_BranchDate: TdsdStoredProc;
    actUpdate_BranchDate: TdsdExecStoredProc;
    actUpdateOperDate: TdsdExecStoredProc;
    actExecuteDataDialog: TExecuteDialog;
    spUpdateIncome_OperData: TdsdStoredProc;
    dxBarButton2: TdxBarButton;
    cbUseNDSKind: TcxCheckBox;
    PromoBonus: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DataModul;

initialization
  RegisterClass(TIncomeForm);

end.
