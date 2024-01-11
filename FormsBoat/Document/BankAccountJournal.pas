unit BankAccountJournal;

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
  Vcl.StdCtrls, cxButtons, ExternalLoad;

type
  TBankAccountJournalForm = class(TAncestorJournal_boatForm)
    BankName: TcxGridDBColumn;
    BankAccountName: TcxGridDBColumn;
    MoneyPlaceName: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    AmountOut: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    bbAddBonus: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actPrint1: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    bbisCopy: TdxBarButton;
    actMasterPost: TDataSetPost;
    ExecuteDialog: TExecuteDialog;
    InvNumber_Invoice_Full: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    actInvoiceJournalDetailChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    actRefreshStart: TdsdDataSetRefresh;
    bbOpenInvoiceForm: TdxBarButton;
    bbUpdateMoneyPlace: TdxBarButton;
    actOpenInvoiceForm: TdsdOpenForm;
    InfoMoneyGroupName_Invoice: TcxGridDBColumn;
    InfoMoneyDestinationName_Invoice: TcxGridDBColumn;
    InfoMoneyName_all_Invoice: TcxGridDBColumn;
    Panel_btn: TPanel;
    btnInsert: TcxButton;
    btnUpdate: TcxButton;
    btnComplete: TcxButton;
    btnUnComplete: TcxButton;
    btnSetErased: TcxButton;
    btnFormClose: TcxButton;
    lbSearchArticle: TcxLabel;
    edSearch_ReceiptNumber_Invoice: TcxTextEdit;
    cxLabel3: TcxLabel;
    edSearchMoneyPlaceName: TcxTextEdit;
    cxLabel4: TcxLabel;
    edSearchInvNumber_OrderClient: TcxTextEdit;
    FieldFilter_Article: TdsdFieldFilter;
    actChoiceGuides: TdsdChoiceGuides;
    InvoiceKindName: TcxGridDBColumn;
    spGetImportSettingId: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting_csv: TdsdExecStoredProc;
    mactStartLoad_csv: TMultiAction;
    bbStartLoad: TdxBarButton;
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
