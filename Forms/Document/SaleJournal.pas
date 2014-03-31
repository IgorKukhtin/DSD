unit SaleJournal;

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
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides;

type
  TSaleJournalForm = class(TAncestorJournalForm)
    colOperDatePartner: TcxGridDBColumn;
    colFromName: TcxGridDBColumn;
    colToName: TcxGridDBColumn;
    colTotalCount: TcxGridDBColumn;
    colTotalCountPartner: TcxGridDBColumn;
    colTotalSumm: TcxGridDBColumn;
    colChangePercent: TcxGridDBColumn;
    colPriceWithVAT: TcxGridDBColumn;
    colVATPercent: TcxGridDBColumn;
    colTotalSummVAT: TcxGridDBColumn;
    colTotalSummMVAT: TcxGridDBColumn;
    colTotalSummPVAT: TcxGridDBColumn;
    colPaidKindName: TcxGridDBColumn;
    colContractName: TcxGridDBColumn;
    colInvNumberOrder: TcxGridDBColumn;
    colChecked: TcxGridDBColumn;
    colRouteSortingName: TcxGridDBColumn;
    edIsPartnerDate: TcxCheckBox;
    colInfoMoneyGroupName: TcxGridDBColumn;
    colInfoMoneyDestinationName: TcxGridDBColumn;
    colInfoMoneyCode: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    spTax: TdsdStoredProc;
    actTax: TdsdExecStoredProc;
    bbTax: TdxBarButton;
    cxLabel14: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    DocumentTaxKindGuides: TdsdGuides;
    colInvNumberPartner_Master: TcxGridDBColumn;
    colDocumentTaxKindName: TcxGridDBColumn;
    colOKPO_To: TcxGridDBColumn;
    colJuridicalName_To: TcxGridDBColumn;
    colInvNumberPartner: TcxGridDBColumn;
    colTotalCountTare: TcxGridDBColumn;
    colTotalCountSh: TcxGridDBColumn;
    colTotalCountKg: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SaleJournalForm: TSaleJournalForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TSaleJournalForm);
end.
