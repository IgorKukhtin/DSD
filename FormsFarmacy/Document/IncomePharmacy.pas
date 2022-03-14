unit IncomePharmacy;

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
  cxGridCustomView, cxGrid, cxPC, dxBarBuiltInMenu, cxNavigator, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCalc,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
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
  TIncomePharmacyForm = class(TAncestorDocumentForm)
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
    cxLabel10: TcxLabel;
    edNDSKind: TcxButtonEdit;
    NDSKindGuides: TdsdGuides;
    ContractGuides: TdsdGuides;
    ExpirationDate: TcxGridDBColumn;
    PartitionGoods: TcxGridDBColumn;
    MakerName: TcxGridDBColumn;
    spIncome_GoodsId: TdsdStoredProc;
    Measure: TcxGridDBColumn;
    spCalculateSalePrice: TdsdStoredProc;
    SalePrice: TcxGridDBColumn;
    SaleSumm: TcxGridDBColumn;
    cxLabel12: TcxLabel;
    cxLabel11: TcxLabel;
    edPointDate: TcxDateEdit;
    cxLabel9: TcxLabel;
    edPointNumber: TcxTextEdit;
    cbFarmacyShow: TcxCheckBox;
    actPrintForManager: TdsdPrintAction;
    dxBarButton1: TdxBarButton;
    SertificatNumber: TcxGridDBColumn;
    SertificatStart: TcxGridDBColumn;
    SertificatEnd: TcxGridDBColumn;
    DublePriceColour: TcxGridDBColumn;
    WarningColor: TcxGridDBColumn;
    AmountManual: TcxGridDBColumn;
    ReasonDifferencesName: TcxGridDBColumn;
    spUpdate_MovementItem_Income_AmountManual: TdsdStoredProc;
    ChoiceReasonDifferences: TOpenChoiceForm;
    actSetAmountEqual: TdsdExecStoredProc;
    AmountDiff: TcxGridDBColumn;
    mactFarmacyShow: TMultiAction;
    spGet_Movement_ManualAmountTrouble: TdsdStoredProc;
    actGet_Movement_ManualAmountTrouble: TdsdExecStoredProc;
    actaOpen_Income_AmountTroubleForm: TdsdOpenForm;
    actUpdate_MovementItem_Income_SetEqualAmount: TdsdExecStoredProc;
    spUpdate_MovementItem_Income_SetEqualAmount: TdsdStoredProc;
    dxBarButton2: TdxBarButton;
    cbisDocument: TcxCheckBox;
    spisDocument: TdsdStoredProc;
    actisDocument: TdsdExecStoredProc;
    bbisDocument: TdxBarButton;
    cbisRegistered: TcxCheckBox;
    actPrintStickerOld: TdsdPrintAction;
    cxLabel13: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    spSelectPrintSticker: TdsdStoredProc;
    actPrintSticker: TdsdPrintAction;
    actPrintSticker_notPrice: TdsdPrintAction;
    bbPrintSticker_notPrice: TdxBarButton;
    isDeferred: TcxGridDBColumn;
    spConduct_Movement_Income: TdsdStoredProc;
    spUnConduct_Movement_Income: TdsdStoredProc;
    actConductMovement: TMultiAction;
    actUnConductMovement: TMultiAction;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    actspConduct_Movement: TdsdExecStoredProc;
    actspUnConduct_Movement: TdsdExecStoredProc;
    Color_AmountManual: TcxGridDBColumn;
    AccommodationName: TcxGridDBColumn;
    spUpdate_ExpirationDate: TdsdStoredProc;
    actExecuteDialogExpirationDate: TExecuteDialog;
    actUpdate_ExpirationDate: TdsdExecStoredProc;
    dxBarButton5: TdxBarButton;
    actAccommodationUnit: TOpenChoiceForm;
    cbisConduct: TcxCheckBox;
    actPUSH_CloseIncome: TdsdShowPUSHMessage;
    spPUSH_CloseIncome: TdsdStoredProc;
    spGetTelegram: TdsdStoredProc;
    spInsert_TelegramBot_Protocol: TdsdStoredProc;
    actGetTelegram: TdsdExecStoredProc;
    actInsert_TelegramBot_Protocol: TdsdExecStoredProc;
    actSendTelegramBot: TdsdSendTelegramBotAction;
    Color_ExpirationDatePh: TcxGridDBColumn;
    actCreatePretension: TdsdOpenForm;
    bbCreatePretension: TdxBarButton;
    edComment: TcxTextEdit;
    cxLabel18: TcxLabel;
    PretensionAmount: TcxGridDBColumn;
    spPUSHComplete: TdsdStoredProc;
    actPUSHComplete: TdsdShowPUSHMessage;
    spPUSHNewPretension: TdsdStoredProc;
    actPUSHNewPretension: TdsdShowPUSHMessage;
    actPretensionJournalIncome: TdsdOpenForm;
    dxBarButton6: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIncomePharmacyForm);

end.
