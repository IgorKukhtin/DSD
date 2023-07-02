unit CheckJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdDB,
  dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, dxBarBuiltInMenu, cxNavigator, cxCurrencyEdit, dsdGuides,
  cxButtonEdit, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxCheckBox;

type
  TCheckJournalForm = class(TAncestorJournalForm)
    colUnitName: TcxGridDBColumn;
    colCashNumber: TcxGridDBColumn;
    colTotalCount: TcxGridDBColumn;
    colTotalSumm: TcxGridDBColumn;
    coPaidTypeName: TcxGridDBColumn;
    ceUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    UnitGuides: TdsdGuides;
    rdUnit: TRefreshDispatcher;
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    dsdStoredProc1: TdsdStoredProc;
    N13: TMenuItem;
    colBayer: TcxGridDBColumn;
    colCashMember: TcxGridDBColumn;
    colFiscalCheckNumber: TcxGridDBColumn;
    colNotMCS: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    clTotalSummChangePercent: TcxGridDBColumn;
    clDiscountCardName: TcxGridDBColumn;
    DiscountExternalName: TcxGridDBColumn;
    IsDeferred: TcxGridDBColumn;
    BayerPhone: TcxGridDBColumn;
    InvNumberOrder: TcxGridDBColumn;
    ConfirmedKindName: TcxGridDBColumn;
    ConfirmedKindClientName: TcxGridDBColumn;
    CommentError: TcxGridDBColumn;
    actShowMessage: TShowMessageAction;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    PrintDialog: TExecuteDialog;
    macPrint: TMultiAction;
    bbPrint: TdxBarButton;
    clPartnerMedicalName: TcxGridDBColumn;
    clOperDateSP: TcxGridDBColumn;
    clInvNumberSP: TcxGridDBColumn;
    clMedicSP: TcxGridDBColumn;
    edIsSP: TcxCheckBox;
    edIsVip: TcxCheckBox;
    InvNumber_PromoCode_Full: TcxGridDBColumn;
    GUID_PromoCode: TcxGridDBColumn;
    TotalSummPayAdd: TcxGridDBColumn;
    actCashSummaForDey: TdsdOpenForm;
    dxBarButton1: TdxBarButton;
    BanksPOSTerminalsName: TcxGridDBColumn;
    JackdawsChecksName: TcxGridDBColumn;
    Delay: TcxGridDBColumn;
    PartionDateKindName: TcxGridDBColumn;
    DateDelay: TcxGridDBColumn;
    BuyerPhone: TcxGridDBColumn;
    BuyerName: TcxGridDBColumn;
    LoyaltySMDiscount: TcxGridDBColumn;
    LoyaltySMSumma: TcxGridDBColumn;
    CheckSourceKindName: TcxGridDBColumn;
    MedicForSaleName: TcxGridDBColumn;
    BuyerForSaleName: TcxGridDBColumn;
    isCorrectMarketing: TcxGridDBColumn;
    isCorrectIlliquidMarketing: TcxGridDBColumn;
    isDeliverySite: TcxGridDBColumn;
    SummaDelivery: TcxGridDBColumn;
    isDoctors: TcxGridDBColumn;
    isDiscountCommit: TcxGridDBColumn;
    colZReport: TcxGridDBColumn;
    CommentCustomer: TcxGridDBColumn;
    MedicalProgramSPName: TcxGridDBColumn;
    isManual: TcxGridDBColumn;
    isOffsetVIP: TcxGridDBColumn;
    isErrorRRO: TcxGridDBColumn;
    isAutoVIPforSales: TcxGridDBColumn;
    isPaperRecipeSP: TcxGridDBColumn;
    ConfirmationCodeSP: TcxGridDBColumn;
    isMobileApplication: TcxGridDBColumn;
    isConfirmByPhone: TcxGridDBColumn;
    DateComing: TcxGridDBColumn;
    MobileDiscount: TcxGridDBColumn;
    isMobileFirstOrder: TcxGridDBColumn;
    UserReferalsName: TcxGridDBColumn;
    UserUnitReferalsName: TcxGridDBColumn;
    ApplicationAward: TcxGridDBColumn;
    spUpdate_InsertDate: TdsdStoredProc;
    actUpdate_InsertDate: TdsdExecStoredProc;
    macUpdate_InsertDate_list: TMultiAction;
    macUpdate_InsertDate: TMultiAction;
    bbUpdate_InsertDate: TdxBarButton;
    DateOffsetVIP: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TCheckJournalForm)

end.
