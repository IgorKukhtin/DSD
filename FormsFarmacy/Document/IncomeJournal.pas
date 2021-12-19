unit IncomeJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxCurrencyEdit, dsdAction, dsdDB, dsdAddOn, ChoicePeriod, Vcl.Menus,
  dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, ExternalSave,
  dxBarBuiltInMenu, cxNavigator, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.DBActns, cxButtonEdit, dsdGuides,
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
  TIncomeJournalForm = class(TAncestorJournalForm)
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    bbTax: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintTax_Us: TdxBarButton;
    bbPrintSticker: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    TotalSumm: TcxGridDBColumn;
    ADOQueryAction1: TADOQueryAction;
    actGetDataForSend: TdsdExecStoredProc;
    mactSendOneDoc: TMultiAction;
    MultiAction2: TMultiAction;
    bbSendData: TdxBarButton;
    spGetDataForSend: TdsdStoredProc;
    TotalSummMVAT: TcxGridDBColumn;
    NDS: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    PaymentDate: TcxGridDBColumn;
    PaySumm: TcxGridDBColumn;
    mactSendOneDocNEW: TMultiAction;
    actGetDataForSendNew: TdsdExecStoredProc;
    spGetDataForSendNew: TdsdStoredProc;
    bbNewSend: TdxBarButton;
    SaleSumm: TcxGridDBColumn;
    InvNumberBranch: TcxGridDBColumn;
    BranchDate: TcxGridDBColumn;
    Checked: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    PayColor: TcxGridDBColumn;
    DateLastPay: TcxGridDBColumn;
    spUpdateIncome_PartnerData: TdsdStoredProc;
    mactEditPartnerData: TMultiAction;
    actPartnerDataDialod: TExecuteDialog;
    actUpdateIncome_PartnerData: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    DataSetPost1: TDataSetPost;
    spisDocument: TdsdStoredProc;
    actisDocument: TdsdExecStoredProc;
    bbisDocument: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    FromOKPO: TcxGridDBColumn;
    PaymentDays: TcxGridDBColumn;
    spSelectPrintSticker: TdsdStoredProc;
    actPrintSticker: TdsdPrintAction;
    actPrintSticker_notPrice: TdsdPrintAction;
    bbPrintSticker_notPrice: TdxBarButton;
    MemberIncomeCheckName: TcxGridDBColumn;
    CheckDate: TcxGridDBColumn;
    cxLabel6: TcxLabel;
    deCheckDate: TcxDateEdit;
    cxLabel16: TcxLabel;
    edMemberIncomeCheck: TcxButtonEdit;
    MemberIncomeCheckGuides: TdsdGuides;
    spUpdateMovementCheck: TdsdStoredProc;
    actUpdateMovementCheck: TdsdExecStoredProc;
    mactUpdateMovementCheck: TMultiAction;
    bbUpdateMovementCheck: TdxBarButton;
    actPrintReestr: TdsdPrintAction;
    bbPrintReestr: TdxBarButton;
    spUpdateMovementCheck_Print: TdsdStoredProc;
    macPrintReestr: TMultiAction;
    actUpdateMovementCheckPrint: TdsdExecStoredProc;
    spUpdate_Movement_BranchDate: TdsdStoredProc;
    actUpdate_BranchDate: TdsdExecStoredProc;
    macUpdate_BranchDate: TMultiAction;
    cxLabel3: TcxLabel;
    deBranchDate: TcxDateEdit;
    bbUpdate_BranchDate: TdxBarButton;
    macUpdate_BranchDateList: TMultiAction;
    isUseNDSKind: TcxGridDBColumn;
    isConduct: TcxGridDBColumn;
    DateConduct: TcxGridDBColumn;
    spPUSHComplete: TdsdStoredProc;
    actPUSHInfo: TdsdShowPUSHMessage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TIncomeJournalForm);
end.
