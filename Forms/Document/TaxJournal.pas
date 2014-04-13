unit TaxJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit;

type
  TTaxJournalForm = class(TAncestorJournalForm)
    colDateRegistered: TcxGridDBColumn;
    colFromName: TcxGridDBColumn;
    colToName: TcxGridDBColumn;
    colTotalCount: TcxGridDBColumn;
    colTotalSumm: TcxGridDBColumn;
    colPriceWithVAT: TcxGridDBColumn;
    colVATPercent: TcxGridDBColumn;
    colTotalSummVAT: TcxGridDBColumn;
    colTotalSummMVAT: TcxGridDBColumn;
    colTotalSummPVAT: TcxGridDBColumn;
    colTaxKindName: TcxGridDBColumn;
    colContractName: TcxGridDBColumn;
    colChecked: TcxGridDBColumn;
    edIsRegisterDate: TcxCheckBox;
    colInfoMoneyGroupName: TcxGridDBColumn;
    colInfoMoneyDestinationName: TcxGridDBColumn;
    colInfoMoneyCode: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    colInvNumberPartner: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colPartnerCode: TcxGridDBColumn;
    colPartnerName: TcxGridDBColumn;
    colDocument: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectTax_Client: TdsdStoredProc;
    spSelectTax_Us: TdsdStoredProc;
    actPrintTax_Us: TdsdPrintAction;
    actPrintTax_Client: TdsdPrintAction;
    spGetReporNameTax: TdsdStoredProc;
    actSPPrintTaxProcName: TdsdExecStoredProc;
    mactPrint_Tax_Us: TMultiAction;
    mactPrint_Tax_Client: TMultiAction;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    colInvNumberPartner_Master: TcxGridDBColumn;
    colIsError: TcxGridDBColumn;
    colRegistered: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TaxJournalForm: TTaxJournalForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TTaxJournalForm);
end.
