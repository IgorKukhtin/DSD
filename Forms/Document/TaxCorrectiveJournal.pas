unit TaxCorrectiveJournal;

interface

uses
  DataModul, Winapi.Windows, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, MeDOC, dsdAction, cxCheckBox, dsdDB, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, System.Classes,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxPC,
  Vcl.Controls, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, EDI, dsdGuides, cxButtonEdit, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  TTaxCorrectiveJournalForm = class(TAncestorJournalForm)
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
    PartnerCode: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    OKPO_From: TcxGridDBColumn;
    InvNumber_Master: TcxGridDBColumn;
    InvNumberPartner_Child: TcxGridDBColumn;
    Document: TcxGridDBColumn;
    spSelectPrintTaxCorrective_Us: TdsdStoredProc;
    spSelectPrintTaxCorrective_Client: TdsdStoredProc;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    bbPrintTaxCorrective_Us: TdxBarButton;
    bbPrintTaxCorrective_Client: TdxBarButton;
    IsError: TcxGridDBColumn;
    OperDate_Child: TcxGridDBColumn;
    InvNumberPartner_Master: TcxGridDBColumn;
    actPrint_TaxCorrective_Reestr: TdsdPrintAction;
    bbPrintTaxCorrective_Reestr: TdxBarButton;
    InvNumberBranch: TcxGridDBColumn;
    actMovementCheck: TdsdOpenForm;
    bbMovementCheck: TdxBarButton;
    bbMeDoc: TdxBarButton;
    spChecked: TdsdStoredProc;
    actChecked: TdsdExecStoredProc;
    bbactChecked: TdxBarButton;
    IsEDI: TcxGridDBColumn;
    IsElectron: TcxGridDBColumn;
    spElectron: TdsdStoredProc;
    actElectron: TdsdExecStoredProc;
    bbElectron: TdxBarButton;
    actDocument: TdsdExecStoredProc;
    spDocument: TdsdStoredProc;
    bbDocument: TdxBarButton;
    ContractCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    spGetReportNameTaxCorrective: TdsdStoredProc;
    actSPPrintTaxCorrectiveProcName: TdsdExecStoredProc;
    actPrint_TaxCorrective_Us: TdsdPrintAction;
    actPrint_TaxCorrective_Client: TdsdPrintAction;
    mactPrint_TaxCorrective_Client: TMultiAction;
    mactPrint_TaxCorrective_Us: TMultiAction;
    spUpdateIsMedoc: TdsdStoredProc;
    MedocListAction: TMedocCorrectiveAction;
    IsMedoc: TcxGridDBColumn;
    actUpdateIsMedoc: TdsdExecStoredProc;
    DocumentValue: TcxGridDBColumn;
    spMedoc_False: TdsdStoredProc;
    actMedocFalse: TdsdExecStoredProc;
    bbMedocFalse: TdxBarButton;
    actInsertMaskMulti: TMultiAction;
    InvNumberRegistered: TcxGridDBColumn;
    spGetInfo: TdsdStoredProc;
    cxTextEdit1: TcxTextEdit;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    Comment: TcxGridDBColumn;
    DateRegistered_notNull: TcxGridDBColumn;
    isCopy: TcxGridDBColumn;
    isPartner: TcxGridDBColumn;
    ExecuteDialog1: TExecuteDialog;
    actShowMessage: TShowMessageAction;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    mactIFin: TMultiAction;
    mactIFinALL: TMultiAction;
    bbIFin: TdxBarButton;
    bbIFinALL: TdxBarButton;
    IFinListAction: TMedocCorrectiveAction;
    IFinAction: TMedocCorrectiveAction;
    mactIFinGrid: TMultiAction;
    spGetDirectoryNameIFIN: TdsdStoredProc;
    actGetDirectoryIFIN: TdsdExecStoredProc;
    isINN: TcxGridDBColumn;
    spUpdate_INN: TdsdStoredProc;
    actUpdateINN: TdsdDataSetRefresh;
    ExecuteDialogINN: TExecuteDialog;
    macUpdateINN: TMultiAction;
    bbUpdateINN: TdxBarButton;
    spUpdateMI_NPP_calc: TdsdStoredProc;
    actChangeNPP_calc: TdsdExecStoredProc;
    macChangeNPP: TMultiAction;
    macChangeNPP_Calc: TMultiAction;
    bbChangeNPP_Calc: TdxBarButton;
    actReport_Check_NPP: TdsdOpenForm;
    bbReport_Check_NPP: TdxBarButton;
    spUpdateMI_NPP_Null: TdsdStoredProc;
    actUpdateMI_NPP_Null: TdsdExecStoredProc;
    macUpdate_NPP_Null: TMultiAction;
    macUpdate_NPP_Null_All: TMultiAction;
    bbUpdate_NPP_Null: TdxBarButton;
    spInsert_isAutoPrepay: TdsdStoredProc;
    actInsert_isAutoPrepay: TdsdExecStoredProc;
    macInsert_isAutoPrepay: TMultiAction;
    bbInsert_isAutoPrepay: TdxBarButton;
    spUpdate_Branch: TdsdStoredProc;
    actBranchChoiceForm: TOpenChoiceForm;
    actUpdate_Branch: TdsdExecStoredProc;
    macUpdateBranch: TMultiAction;
    bbUpdateBranch: TdxBarButton;
    isUKTZ_new: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TaxCorrectiveJournalForm: TTaxCorrectiveJournalForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TTaxCorrectiveJournalForm);
end.
