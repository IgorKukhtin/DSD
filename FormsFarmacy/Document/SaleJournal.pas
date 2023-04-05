unit SaleJournal;

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
  cxGrid, cxPC, cxCalc, cxCurrencyEdit, dxSkinsCore, dxSkinsDefaultPainters,
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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TSaleJournalForm = class(TAncestorJournalForm)
    spGet_Movement_Sale: TdsdStoredProc;
    UnitName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    TotalSummPrimeCost: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    isSP: TcxGridDBColumn;
    GroupMemberSPName: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    PrintDialog: TExecuteDialog;
    actPrint: TdsdPrintAction;
    macPrint: TMultiAction;
    bbmacPrint: TdxBarButton;
    InvNumber_Invoice_Full: TcxGridDBColumn;
    SPKindName: TcxGridDBColumn;
    isDeferred: TcxGridDBColumn;
    isNP: TcxGridDBColumn;
    InsuranceCompaniesName: TcxGridDBColumn;
    MemberICName: TcxGridDBColumn;
    InsuranceCardNumber: TcxGridDBColumn;
    actInsertInsuranceCompanies: TdsdInsertUpdateAction;
    bbInsertInsuranceCompanies: TdxBarButton;
    actChoiceInsuranceCompanies: TOpenChoiceForm;
    actChoiceMemberIC: TOpenChoiceForm;
    actExecInsert_InsuranceCompanies: TdsdExecStoredProc;
    spInsert_InsuranceCompanies: TdsdStoredProc;
    GoodsCode: TcxGridDBColumn;
    JuridicalMainName: TcxGridDBColumn;
    actChangePercentDialog: TExecuteDialog;
    CashRegisterName: TcxGridDBColumn;
    ZReport: TcxGridDBColumn;
    FiscalCheckNumber: TcxGridDBColumn;
    TotalSummPayAdd: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSaleJournalForm);

end.
