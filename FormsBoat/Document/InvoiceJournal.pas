unit InvoiceJournal;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TInvoiceJournalForm = class(TAncestorJournalForm)
    ObjectName: TcxGridDBColumn;
    ProductName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    DescName: TcxGridDBColumn;
    actInsertProfitLossService: TdsdInsertUpdateAction;
    bbAddBonus: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    InfoMoneyName_all: TcxGridDBColumn;
    actPrint1: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    actIsCopy: TdsdExecStoredProc;
    bbisCopy: TdxBarButton;
    mactInsertProfitLossService: TMultiAction;
    actIsCopyTrue: TdsdExecStoredProc;
    actMasterPost: TDataSetPost;
    mactIsCopy: TMultiAction;
    UnitCode: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    actInvoiceJournalDetailChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    actRefreshStart: TdsdDataSetRefresh;
    macUpdateContract: TMultiAction;
    actUpdateContract: TdsdDataSetRefresh;
    bb: TdxBarButton;
    actChoiceContract: TOpenChoiceForm;
    actChoiceMoneyPlace: TOpenChoiceForm;
    actUpdateMoneyPlace: TdsdDataSetRefresh;
    macUpdateMoneyPlace: TMultiAction;
    bbUpdateMoneyPlace: TdxBarButton;
    TaxKindValue: TcxGridDBColumn;
    AmountIn_NotVAT: TcxGridDBColumn;
    AmountOut_NotVAT: TcxGridDBColumn;
    AmountIn_VAT: TcxGridDBColumn;
    AmountOut_VAT: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TInvoiceJournalForm);

end.
