unit TaxJournal;

interface

uses
  DataModul, Winapi.Windows, AncestorJournal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxImageComboBox,
  cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdGuides,
  dsdAction, cxButtonEdit, cxCheckBox, dsdDB, dsdAddOn, ChoicePeriod, Vcl.Menus,
  dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, System.Classes,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxPC,
  Vcl.Controls, MeDOC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, EDI, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TTaxJournalForm = class(TAncestorJournalForm)
    DateRegistered: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
    VATPercent: TcxGridDBColumn;
    TotalSummVAT: TcxGridDBColumn;
    TotalSummMVAT: TcxGridDBColumn;
    TotalSummPVAT: TcxGridDBColumn;
    TaxKindName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    Checked: TcxGridDBColumn;
    edIsRegisterDate: TcxCheckBox;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    Document: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectTax_Client: TdsdStoredProc;
    spSelectTax_Us: TdsdStoredProc;
    actPrintTax_Us: TdsdPrintAction;
    actPrintTax_Client: TdsdPrintAction;
    spGetReporNameTax: TdsdStoredProc;
    actGetReporNameTax: TdsdExecStoredProc;
    mactPrint_Tax_Us: TMultiAction;
    mactPrint_Tax_Client: TMultiAction;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    InvNumber_Master: TcxGridDBColumn;
    IsError: TcxGridDBColumn;
    InvNumberBranch: TcxGridDBColumn;
    cxLabel14: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    DocumentTaxKindGuides: TdsdGuides;
    spTax: TdsdStoredProc;
    MedocAction: TMedocAction;
    bbMeDoc: TdxBarButton;
    mactMeDoc: TMultiAction;
    actSelect_Medoc: TdsdExecStoredProc;
    actMovementCheck: TdsdOpenForm;
    bbMovementCheck: TdxBarButton;
    spChecked: TdsdStoredProc;
    actChecked: TdsdExecStoredProc;
    bbChecked: TdxBarButton;
    IsEDI: TcxGridDBColumn;
    IsElectron: TcxGridDBColumn;
    actElectron: TdsdExecStoredProc;
    spElectron: TdsdStoredProc;
    bbElectron: TdxBarButton;
    spDocument: TdsdStoredProc;
    actDocument: TdsdExecStoredProc;
    bbDocument: TdxBarButton;
    ContractCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    EDI: TEDI;
    spGetDirectoryName: TdsdStoredProc;
    mactMedocALL: TMultiAction;
    bbSaveDeclarForMedoc: TdxBarButton;
    actGetDirectory: TdsdExecStoredProc;
    mactMEDOCGrid: TMultiAction;
    EDIAction: TEDIAction;
    actSelect_Medoc_list: TdsdExecStoredProc;
    IsMedoc: TcxGridDBColumn;
    spUpdateIsMedoc: TdsdStoredProc;
    MedocListAction: TMedocAction;
    actUpdateIsMedoc: TdsdExecStoredProc;
    actInsertMaskMulti: TMultiAction;
    actMedocFalse: TdsdExecStoredProc;
    spMedoc_False: TdsdStoredProc;
    bbMedocFalse: TdxBarButton;
    RegisteredNumber: TcxGridDBColumn;
    cxTextEdit1: TcxTextEdit;
    edLoadData: TcxDateEdit;
    spGetInfo: TdsdStoredProc;
    spSelectTax_Medoc: TdsdStoredProc;
    edPeriod: TcxDateEdit;
    cxTextEdit2: TcxTextEdit;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    Comment: TcxGridDBColumn;
    DateRegistered_notNull: TcxGridDBColumn;
    spCopyTaxCorrective: TdsdStoredProc;
    actCopyTaxCorrective: TdsdExecStoredProc;
    mactCopyTaxCorrective: TMultiAction;
    bbCopyTaxCorrective: TdxBarButton;
    isCopy: TcxGridDBColumn;
    PersonalSigningName: TcxGridDBColumn;
    ExecuteDialog1: TExecuteDialog;
    actShowMessage: TShowMessageAction;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    ExecuteDialog2: TExecuteDialog;
    mactCopyTaxCorrectiveList: TMultiAction;
    mactIFin: TMultiAction;
    mactIFinALL: TMultiAction;
    IFinAction: TMedocAction;
    IFinListAction: TMedocAction;
    mactIFinGrid: TMultiAction;
    bbIFin: TdxBarButton;
    bbIFinALL: TdxBarButton;
    spGetDirectoryNameIFIN: TdsdStoredProc;
    actGetDirectoryIFIN: TdsdExecStoredProc;
    isINN: TcxGridDBColumn;
    spUpdate_INN: TdsdStoredProc;
    actUpdateINN: TdsdDataSetRefresh;
    ExecuteDialogINN: TExecuteDialog;
    macUpdateINN: TMultiAction;
    bbUpdateINN: TdxBarButton;
    actOpenFormTaxCorrective: TdsdOpenForm;
    bbOpenFormTaxCorrective: TdxBarButton;
    isDisableNPP: TcxGridDBColumn;
    spInsert_isAutoPrepay: TdsdStoredProc;
    actInsert_isAutoPrepay: TdsdExecStoredProc;
    macInsert_isAutoPrepay: TMultiAction;
    bbInsert_isAutoPrepay: TdxBarButton;
    spUpdate_Branch: TdsdStoredProc;
    actBranchChoiceForm: TOpenChoiceForm;
    actUpdate_Branch: TdsdExecStoredProc;
    macUpdateBranch: TMultiAction;
    bbUpdateBranch: TdxBarButton;
    OperDatePartner_Master: TcxGridDBColumn;
    isUKTZ_new: TcxGridDBColumn;
    spUpdate_IsUKTZ_new: TdsdStoredProc;
    actUpdate_IsUKTZ_new: TdsdExecStoredProc;
    bbUpdate_IsUKTZ_new: TdxBarButton;
    bbChange: TdxBarSubItem;
    dxBarSeparator1: TdxBarSeparator;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
initialization
  RegisterClass(TTaxJournalForm);
end.
