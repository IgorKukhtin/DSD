unit Report_JuridicalCollation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCurrencyEdit, DataModul, frxClass, frxDBSet, dsdGuides, cxButtonEdit,
  dxSkinsCore, cxImageComboBox, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  TReport_JuridicalCollationForm = class(TAncestorReportForm)
    ItemName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    Debet: TcxGridDBColumn;
    Kredit: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    actPrintOfficial: TdsdPrintAction;
    bbPrintOfficial: TdxBarButton;
    cxLabel6: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    getMovementForm: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actOpenForm: TdsdOpenForm;
    actGetForm: TdsdExecStoredProc;
    actOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    AccountName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    InfoMoneyGroupCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationCode: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    spJuridicalBalance: TdsdStoredProc;
    cxLabel3: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cxLabel4: TcxLabel;
    edAccount: TcxButtonEdit;
    GuidesAccount: TdsdGuides;
    cxLabel8: TcxLabel;
    ceContract: TcxButtonEdit;
    GuidesContract: TdsdGuides;
    StartRemains: TcxGridDBColumn;
    EndRemains: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    cxLabel7: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    actPrintTurnover: TdsdPrintAction;
    bbPrintTurnover: TdxBarButton;
    MovementSumm: TcxGridDBColumn;
    OperationSort: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    ContractComment: TcxGridDBColumn;
    cxLabel10: TcxLabel;
    edCurrency: TcxButtonEdit;
    GuidesCurrency: TdsdGuides;
    Debet_Currency: TcxGridDBColumn;
    Kredit_Currency: TcxGridDBColumn;
    StartRemains_Currency: TcxGridDBColumn;
    EndRemains_Currency: TcxGridDBColumn;
    MovementSumm_Currency: TcxGridDBColumn;
    CurrencyName: TcxGridDBColumn;
    actPrintCurrency: TdsdPrintAction;
    bbPrintCurrency: TdxBarButton;
    cxLabel9: TcxLabel;
    GuidesSaleChoice: TdsdGuides;
    edInvNumberSale: TcxButtonEdit;
    PartionMovementName: TcxGridDBColumn;
    PaymentDate: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    MovementComment: TcxGridDBColumn;
    macPrint: TMultiAction;
    actSPSaveObject: TdsdExecStoredProc;
    spSavePrintObject: TdsdStoredProc;
    cbIsInsert: TcxCheckBox;
    bbIsInsert: TdxBarControlContainerItem;
    macPrintOfficial: TMultiAction;
    macPrintCurrency: TMultiAction;
    InvNumber_Transport: TcxGridDBColumn;
    bbIsUpdate: TdxBarControlContainerItem;
    cbIsUpdate: TcxCheckBox;
    actOpenProtocol: TdsdOpenForm;
    bbOpenProtocol: TdxBarButton;
    BranchName: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_JuridicalCollationForm)

end.
