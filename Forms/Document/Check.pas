unit Check;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, dsdGuides,
  dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCurrencyEdit, dxBarBuiltInMenu, cxNavigator, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox,
  cxSplitter, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
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
  TCheckForm = class(TAncestorDocumentForm)
    edCashRegisterName: TcxTextEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    edPaidTypeName: TcxTextEdit;
    ChoiceCashRegister: TOpenChoiceForm;
    ChoicePaidType: TOpenChoiceForm;
    actEditDocument: TMultiAction;
    dxBarButton1: TdxBarButton;
    actUpdate_Movement_Check: TdsdExecStoredProc;
    lblCashMember: TcxLabel;
    edCashMember: TcxTextEdit;
    lblBayer: TcxLabel;
    edBayer: TcxTextEdit;
    cxLabel6: TcxLabel;
    edFiscalCheckNumber: TcxTextEdit;
    chbNotMCS: TcxCheckBox;
    cxLabel7: TcxLabel;
    edDiscountCard: TcxTextEdit;
    edInvNumberOrder: TcxTextEdit;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    edBayerPhone: TcxTextEdit;
    cxLabel8: TcxLabel;
    edConfirmedKind: TcxTextEdit;
    List_UID: TcxGridDBColumn;
    edConfirmedKindClient: TcxTextEdit;
    cxLabel11: TcxLabel;
    actShowMessage: TShowMessageAction;
    spSelectPrint: TdsdStoredProc;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintDialog: TExecuteDialog;
    macPrint: TMultiAction;
    cxLabel12: TcxLabel;
    edPartnerMedical: TcxTextEdit;
    cxLabel13: TcxLabel;
    edOperDateSP: TcxDateEdit;
    cxLabel14: TcxLabel;
    edInvNumberSP: TcxTextEdit;
    cxLabel16: TcxLabel;
    edMedicSP: TcxTextEdit;
    ExecuteDialogUpdateOperDate: TExecuteDialog;
    actUpdateOperDate: TdsdDataSetRefresh;
    spUpdateMovement_OperDate: TdsdStoredProc;
    macUpdateOperDate: TMultiAction;
    bbUpdateOperDate: TdxBarButton;
    cxLabel17: TcxLabel;
    edAmbulance: TcxTextEdit;
    colisSp: TcxGridDBColumn;
    spUpdate_SpParam: TdsdStoredProc;
    actUpdateSpParam: TdsdDataSetRefresh;
    ExecuteDialogSP: TExecuteDialog;
    macUpdateSpParam: TMultiAction;
    bbUpdateSpParam: TdxBarButton;
    cxLabel18: TcxLabel;
    edSPKind: TcxTextEdit;
    cxLabel19: TcxLabel;
    edInvNumber_PromoCode_Full: TcxTextEdit;
    edUnitName: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    edManualDiscount: TcxTextEdit;
    cxLabel20: TcxLabel;
    cxLabel21: TcxLabel;
    edTotalSummPayAdd: TcxTextEdit;
    actUpdateUnit: TMultiAction;
    actExecStoredUpdateUnit: TdsdExecStoredProc;
    spUpdateUnit: TdsdStoredProc;
    bbUpdateUnit: TdxBarButton;
    actChoiceUnitTreeForm: TOpenChoiceForm;
    cxLabel22: TcxLabel;
    edMemberSP: TcxButtonEdit;
    cxLabel23: TcxLabel;
    edGroupMemberSP: TcxButtonEdit;
    cxLabel24: TcxLabel;
    cxLabel25: TcxLabel;
    edPassport: TcxTextEdit;
    edInn: TcxTextEdit;
    cxLabel26: TcxLabel;
    edAddress: TcxTextEdit;
    GuidesMemberSP: TdsdGuides;
    GuidesGroupMemberSP: TdsdGuides;
    actChoiceMemberSpForm: TOpenChoiceForm;
    spUpdateMemberSP: TdsdStoredProc;
    actExecStoredUpdateMemberSp: TdsdExecStoredProc;
    macUpdateMemberSp: TMultiAction;
    bbUpdateMemberSp: TdxBarButton;
    ExecuteDialogUpdateMemberSp: TExecuteDialog;
    cbSite: TcxCheckBox;
    edBankPOSTerminal: TcxButtonEdit;
    cxLabel27: TcxLabel;
    GuidesBankPOSTerminal: TdsdGuides;
    actBankPOSTerminal: TMultiAction;
    actChoiceBankPOSTerminal: TOpenChoiceForm;
    actExecBankPOSTerminal: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    spUpdateBankPOSTerminal: TdsdStoredProc;
    edJackdawsChecks: TcxButtonEdit;
    cxLabel28: TcxLabel;
    GuidesJackdawsChecks: TdsdGuides;
    actJackdawsChecks: TMultiAction;
    actChoiceJackdawsChecks: TOpenChoiceForm;
    actExecJackdawsChecks: TdsdExecStoredProc;
    dxBarButton3: TdxBarButton;
    spUpdateJackdawsChecks: TdsdStoredProc;
    cbDelay: TcxCheckBox;
    cxLabel29: TcxLabel;
    edPartionDateKind: TcxButtonEdit;
    GuidesPartionDateKind: TdsdGuides;
    DetailDCS: TClientDataSet;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    DetailDS: TDataSource;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chAmount: TcxGridDBColumn;
    chisErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    spSelect_MI_Child: TdsdStoredProc;
    spReLinkContainer: TdsdStoredProc;
    actReLinkContainer: TMultiAction;
    actExecReLinkContainer: TdsdExecStoredProc;
    dxBarButton4: TdxBarButton;
    actExec_MovementIten_PartionDateKind: TdsdExecStoredProc;
    spUpdate_PartionDateKind: TdsdStoredProc;
    actUpdate_MovementIten_PartionDateKind: TMultiAction;
    dxBarButton5: TdxBarButton;
    astChoicePartionDateKind: TOpenChoiceForm;
    actPartionGoods: TdsdOpenForm;
    dxBarButton6: TdxBarButton;
    actAddGoods: TMultiAction;
    actEditAmount: TMultiAction;
    actAmountDialog: TExecuteDialog;
    actExecAddGoods: TdsdExecStoredProc;
    actExecEditAmount: TdsdExecStoredProc;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    spAddGoods: TdsdStoredProc;
    spEditAmount: TdsdStoredProc;
    actGoodsChoice: TOpenChoiceForm;
    actUpdateNotMCS: TdsdExecStoredProc;
    SPUpdate_NotMCS: TdsdStoredProc;
    dxBarButton10: TdxBarButton;
    edLoyaltySMDiscount: TcxTextEdit;
    cxLabel30: TcxLabel;
    edLoyaltySMSumma: TcxTextEdit;
    cxLabel31: TcxLabel;
    spSetPromoCode: TdsdStoredProc;
    actSetPromoCodeDoctor: TdsdExecStoredProc;
    actChoicePromoCodeDoctor: TOpenChoiceForm;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    colNDS: TcxGridDBColumn;
    actChoiceNDSKind: TOpenChoiceForm;
    spUpdate_MovementIten_PartionDateKind: TdsdStoredProc;
    spUpdateNDSKindId: TdsdStoredProc;
    actExecspUpdateNDSKindId: TdsdExecStoredProc;
    dxBarButton13: TdxBarButton;
    colDiscountExternalName: TcxGridDBColumn;
    colDivisionPartiesName: TcxGridDBColumn;
    colisPresent: TcxGridDBColumn;
    colColor_calc: TcxGridDBColumn;
    actChoiceDivisionPartiesKind: TOpenChoiceForm;
    actExecDivisionParties: TdsdExecStoredProc;
    dxBarButton14: TdxBarButton;
    spUpdateDivisionPartiesId: TdsdStoredProc;
    actPriceDialog: TExecuteDialog;
    actSetPrice: TdsdExecStoredProc;
    spUpdatePrice: TdsdStoredProc;
    dxBarButton15: TdxBarButton;
    cbCorrectMarketing: TcxCheckBox;
    cbCorrectIlliquidMarketing: TcxCheckBox;
    cbDoctors: TcxCheckBox;
    actUpdate_Doctors: TdsdExecStoredProc;
    spUpdate_Doctors: TdsdStoredProc;
    dxBarButton16: TdxBarButton;
    cbDiscountCommit: TcxCheckBox;
    edZReport: TcxTextEdit;
    cxLabel32: TcxLabel;
    spUpdate_ClearFiscal: TdsdStoredProc;
    actUpdate_ClearFiscal: TdsdExecStoredProc;
    dxBarButton17: TdxBarButton;
    colJuridicalName: TcxGridDBColumn;
    actUpdatePriceSale: TdsdExecStoredProc;
    spUpdatePriceSale: TdsdStoredProc;
    actPriceSaleDialog: TExecuteDialog;
    dxBarButton18: TdxBarButton;
    cbOffsetVIP: TcxCheckBox;
    actUpdate_OffsetVIP: TdsdExecStoredProc;
    spUpdate_OffsetVIP: TdsdStoredProc;
    dxBarButton19: TdxBarButton;
    cbErrorRRO: TcxCheckBox;
    dxBarSubItem1: TdxBarSubItem;
    dxBarSeparator1: TdxBarSeparator;
    spUpdate_MedicForSale: TdsdStoredProc;
    spUpdate_BuyerForSale: TdsdStoredProc;
    actUpdate_MedicForSale: TdsdExecStoredProc;
    actChoicespMedicForSale: TOpenChoiceForm;
    actUpdate_BuyerForSale: TdsdExecStoredProc;
    actChoiceBuyerForSale: TOpenChoiceForm;
    dxBarButton20: TdxBarButton;
    dxBarButton21: TdxBarButton;
    cbConfirmByPhone: TcxCheckBox;
    CommentCheckName: TcxGridDBColumn;
    actDateOffsetVIPDialog: TExecuteDialog;
    actUpdate_SetOffsetVIP: TdsdExecStoredProc;
    spUpdate_SetOffsetVIP: TdsdStoredProc;
    dxBarButton22: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TCheckForm)

end.
