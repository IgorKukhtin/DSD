unit BankAccountJournalByInvoice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal_boat, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, Vcl.Menus,
  dsdAddOn, ChoicePeriod, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCurrencyEdit, dxSkinsCore,
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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  Vcl.StdCtrls, cxButtons;

type
  TBankAccountJournalByInvoiceForm = class(TAncestorJournal_boatForm)
    BankName: TcxGridDBColumn;
    BankAccountName: TcxGridDBColumn;
    MoneyPlaceName: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    AmountOut: TcxGridDBColumn;
    InvNumberParent: TcxGridDBColumn;
    bbAddBonus: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actPrint1: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    spUpdate_isCopy: TdsdStoredProc;
    bbisCopy: TdxBarButton;
    actMasterPost: TDataSetPost;
    ExecuteDialog: TExecuteDialog;
    InvNumber_Invoice_Full: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    actInvoiceJournalDetailChoiceForm: TOpenChoiceForm;
    spUpdate_Invoice: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    actRefreshStart: TdsdDataSetRefresh;
    spUpdateContract: TdsdStoredProc;
    macUpdateContract: TMultiAction;
    actUpdateContract: TdsdDataSetRefresh;
    bb: TdxBarButton;
    actChoiceContract: TOpenChoiceForm;
    spUpdateJuridical: TdsdStoredProc;
    actChoiceMoneyPlace: TOpenChoiceForm;
    actUpdateMoneyPlace: TdsdDataSetRefresh;
    macUpdateMoneyPlace: TMultiAction;
    bbUpdateMoneyPlace: TdxBarButton;
    cxLabel6: TcxLabel;
    edInvoice: TcxButtonEdit;
    GuidesInvoice: TdsdGuides;
    Panel_btn: TPanel;
    btnFormClose: TcxButton;
    btnSetNull_GuidesClient: TcxButton;
    actGuidesInvoiceChoiceForm: TOpenChoiceForm;
    cxLabel3: TcxLabel;
    ceObject: TcxButtonEdit;
    cxLabel5: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesObject: TdsdGuides;
    GuidesInfoMoney: TdsdGuides;
    InvoiceKindName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankAccountJournalByInvoiceForm);

end.
