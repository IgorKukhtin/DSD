unit PriceCorrectiveJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TPriceCorrectiveJournalForm = class(TAncestorJournalForm)
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    bbPrint: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    spGetReportName: TdsdStoredProc;
    spSelectPrint: TdsdStoredProc;
    actSPPrintProcName: TdsdExecStoredProc;
    actPrint: TdsdPrintAction;
    mactPrint: TMultiAction;
    cxLabel14: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    DocumentTaxKindGuides: TdsdGuides;
    spCorrective: TdsdStoredProc;
    bbCorrective: TdxBarButton;
    spSelectPrintTaxCorrective_Us: TdsdStoredProc;
    spSelectPrintTaxCorrective_Client: TdsdStoredProc;
    bbPrintTaxCorrective_Client: TdxBarButton;
    bbPrintTaxCorrective_Us: TdxBarButton;
    InvNumberPartner: TcxGridDBColumn;
    InvNumberMark: TcxGridDBColumn;
    actPrint_TaxCorrective_Us: TdsdPrintAction;
    actPrint_TaxCorrective_Client: TdsdPrintAction;
    mactPrint_TaxCorrective_Client: TMultiAction;
    mactPrint_TaxCorrective_Us: TMultiAction;
    spGetReportNameTaxCorrective: TdsdStoredProc;
    actSPPrintTaxCorrectiveProcName: TdsdExecStoredProc;
    Comment: TcxGridDBColumn;
    ContractCode: TcxGridDBColumn;
    mactPrintReturnIn: TMultiAction;
    actSPPrintProcNameReturnIn: TdsdExecStoredProc;
    spGetReportNameReturnIn: TdsdStoredProc;
    bbPrintReturnIn: TdxBarButton;
    BranchName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    actShowMessage: TShowMessageAction;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    spChecked: TdsdStoredProc;
    actChecked: TdsdExecStoredProc;
    bbChecked: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPriceCorrectiveJournalForm);
end.
