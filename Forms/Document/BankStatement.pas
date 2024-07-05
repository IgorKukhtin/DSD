unit BankStatement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCurrencyEdit, Vcl.ExtCtrls, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxButtonEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, cxTextEdit, cxLabel,
  cxMemo, cxSplitter, Vcl.Menus, DataModul, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdGuides,
  dsdCommon;

type
  TBankStatementForm = class(TAncestorDBGridForm)
    FormParams: TdsdFormParams;
    InvNumber: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
    Debet: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    LinkJuridicalName: TcxGridDBColumn;
    Panel: TPanel;
    cxLabel1: TcxLabel;
    edInvNumber: TcxTextEdit;
    cxLabel2: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    spGet: TdsdStoredProc;
    edBankName: TcxTextEdit;
    edBankAccount: TcxTextEdit;
    InfoMoney: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    Contract: TcxGridDBColumn;
    Kredit: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    BankAccount: TcxGridDBColumn;
    BankName: TcxGridDBColumn;
    BankMFO: TcxGridDBColumn;
    actChoiceUnit: TOpenChoiceForm;
    actChoiceJuridical: TOpenChoiceForm;
    actChoiceInfoMoney: TOpenChoiceForm;
    actChoiceContract: TOpenChoiceForm;
    spUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    cxSplitter: TcxSplitter;
    BottomPanel: TPanel;
    dxBarDockControl: TdxBarDockControl;
    cxDetailGridDBTableView: TcxGridDBTableView;
    cxDetailGridLevel: TcxGridLevel;
    cxDetailGrid: TcxGrid;
    BarManagerBar1: TdxBar;
    CurrencyName: TcxGridDBColumn;
    actSendToBankAccount: TdsdExecStoredProc;
    spBankAccount_From_BankStatement: TdsdStoredProc;
    bbSendToBankAccount: TdxBarButton;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    bbInsertJuridical: TdxBarButton;
    InsertJuridical: TdsdInsertUpdateAction;
    RefreshAddOn: TRefreshAddOn;
    cxGridLevel1: TcxGridLevel;
    InvNumber_Invoice: TcxGridDBColumn;
    actInvoiceJournalDetailChoiceForm: TOpenChoiceForm;
    MovementId_Invoice: TcxGridDBColumn;
    Comment_Invoice: TcxGridDBColumn;
    ServiceDate: TcxGridDBColumn;
    cxLabel6: TcxLabel;
    edServiceDate: TcxDateEdit;
    LinkINN: TcxGridDBColumn;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbMovementProtocolOpenForm: TdxBarButton;
    actClear_Invoice: TdsdSetDefaultParams;
    cxLabel5: TcxLabel;
    edPersonalServiceList: TcxButtonEdit;
    GuidesPersonalServiceList: TdsdGuides;
    spUpdate_LinkJuridical: TdsdStoredProc;
    actUpdate_LinkJuridical: TdsdExecStoredProc;
    bbUpdate_LinkJuridical: TdxBarButton;
    macUpdate_LinkJuridical: TMultiAction;
    macUpdate_LinkJuridical_list: TMultiAction;
    spUpdateParams: TdsdStoredProc;
    actUpdateParams: TdsdExecStoredProc;
    mactUpdateParams_list: TMultiAction;
    mactUpdateParams: TMultiAction;
    bbUpdateParams: TdxBarButton;
    PartnerName: TcxGridDBColumn;
    actChoicePartner: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankStatementForm);


end.
