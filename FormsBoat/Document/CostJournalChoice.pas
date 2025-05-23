unit CostJournalChoice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal_boat, cxGraphics, cxControls,
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
  dsdGuides, cxButtonEdit;

type
  TCostJournalChoiceForm = class(TAncestorJournal_boatForm)
    dsdChoiceGuides: TdsdChoiceGuides;
    bbSelect: TdxBarButton;
    cxLabel3: TcxLabel;
    edInfoMoney: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
    actOpenFormInvoice: TdsdOpenForm;
    bbOpenFormInvoice: TdxBarButton;
    bbOpenFormService: TdxBarButton;
    Amount: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    Amount_NotVAT: TcxGridDBColumn;
    Amount_VAT: TcxGridDBColumn;
    VATPercent: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    InvNumber_cost: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CostJournalChoiceForm: TCostJournalChoiceForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TCostJournalChoiceForm);
end.
