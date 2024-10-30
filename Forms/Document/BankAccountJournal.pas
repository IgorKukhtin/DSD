unit BankAccountJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, Vcl.Menus,
  dsdAddOn, ChoicePeriod, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, ClientBankLoad, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.DBActns,
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
  TBankAccountJournalForm = class(TAncestorJournalForm)
    BankName: TcxGridDBColumn;
    BankAccountName: TcxGridDBColumn;
    MoneyPlaceName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    Contract: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    AmountOut: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InvNumber_Parent: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
    OKPO_Parent: TcxGridDBColumn;
    PartnerBankName: TcxGridDBColumn;
    PartnerBankMFO: TcxGridDBColumn;
    PartnerBankAccountName: TcxGridDBColumn;
    actInsertProfitLossService: TdsdInsertUpdateAction;
    bbAddBonus: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    InfoMoneyName_all: TcxGridDBColumn;
    AmountCurrency: TcxGridDBColumn;
    CurrencyValue: TcxGridDBColumn;
    ParValue: TcxGridDBColumn;
    CurrencyPartnerValue: TcxGridDBColumn;
    ParPartnerValue: TcxGridDBColumn;
    CurrencyName: TcxGridDBColumn;
    AmountSumm: TcxGridDBColumn;
    actPrint1: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    JuridicalName: TcxGridDBColumn;
    MFO: TcxGridDBColumn;
    BankSInvNumber_Parent: TcxGridDBColumn;
    spUpdate_isCopy: TdsdStoredProc;
    actIsCopy: TdsdExecStoredProc;
    bbisCopy: TdxBarButton;
    isCopy: TcxGridDBColumn;
    mactInsertProfitLossService: TMultiAction;
    actIsCopyTrue: TdsdExecStoredProc;
    actMasterPost: TDataSetPost;
    mactIsCopy: TMultiAction;
    UnitCode: TcxGridDBColumn;
    OKPO_BankAccount: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    InvNumber_Invoice: TcxGridDBColumn;
    Comment_Invoice: TcxGridDBColumn;
    actInvoiceJournalDetailChoiceForm: TOpenChoiceForm;
    MovementId_Invoice: TcxGridDBColumn;
    spUpdate_Invoice: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    GuidesJuridicalBasis: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    spUpdateContract: TdsdStoredProc;
    macUpdateContract: TMultiAction;
    actUpdateContract: TdsdDataSetRefresh;
    bbUpdateContract: TdxBarButton;
    actChoiceContract: TOpenChoiceForm;
    spUpdateJuridical: TdsdStoredProc;
    actChoiceMoneyPlace: TOpenChoiceForm;
    actUpdateMoneyPlace: TdsdDataSetRefresh;
    macUpdateMoneyPlace: TMultiAction;
    bbUpdateMoneyPlace: TdxBarButton;
    spGet_UseJuridicalBankAccount: TdsdStoredProc;
    PartnerName: TcxGridDBColumn;
    actInsertUpdate_Split: TdsdInsertUpdateAction;
    bbInsertUpdate_Split: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    bbsUpdate: TdxBarSubItem;
    dxBarSeparator: TdxBarSeparator;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankAccountJournalForm);

end.
