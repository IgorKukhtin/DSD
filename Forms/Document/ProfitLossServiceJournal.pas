unit ProfitLossServiceJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCheckBox, cxImageComboBox, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.Menus, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  TProfitLossServiceJournalForm = class(TAncestorJournalForm)
    AmountOut: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    ContractInvNumber: TcxGridDBColumn;
    JuridicalCode: TcxGridDBColumn;
    ContractConditionKindName: TcxGridDBColumn;
    N13: TMenuItem;
    actReCompleteAll: TdsdExecStoredProc;
    spMovementReCompleteAll: TdsdStoredProc;
    bbReCompleteAll: TdxBarButton;
    BonusKindName: TcxGridDBColumn;
    isLoad: TcxGridDBColumn;
    ContractMasterInvNumber: TcxGridDBColumn;
    ContractChildInvNumber: TcxGridDBColumn;
    BonusValue: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    JuridicalCode_Child: TcxGridDBColumn;
    JuridicalName_Child: TcxGridDBColumn;
    OKPO_Child: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    cxLabel3: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    cxLabel4: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    BranchName: TcxGridDBColumn;
    actOpenForm_51201: TdsdOpenForm;
    bbOpenForm_51201: TdxBarButton;
    ContractTagName_master: TcxGridDBColumn;
    ContractTagName_child: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbactPrint: TdxBarButton;
    PersonalName: TcxGridDBColumn;
    PersonalName_main: TcxGridDBColumn;
    TradeMarkName: TcxGridDBColumn;
    InvNumber_doc: TcxGridDBColumn;
    InvNumberInvoice: TcxGridDBColumn;
    getMovementFormPromo: TdsdStoredProc;
    actGetFormPromo: TdsdExecStoredProc;
    actOpenFormPromo: TdsdOpenForm;
    mactOpenDocumentPromo: TMultiAction;
    bbOpenDocumentPromo: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProfitLossServiceJournalForm);

end.
