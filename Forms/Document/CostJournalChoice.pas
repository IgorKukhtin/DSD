unit CostJournalChoice;

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
  dsdGuides, cxButtonEdit;

type
  TCostJournalChoiceForm = class(TAncestorJournalForm)
    dsdChoiceGuides: TdsdChoiceGuides;
    bbSelect: TdxBarButton;
    cxLabel6: TcxLabel;
    edPartner: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    edInfoMoney: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
    spCheckDescTransport: TdsdStoredProc;
    spCheckDescService: TdsdStoredProc;
    actCheckDescService: TdsdExecStoredProc;
    actCheckDescTransport: TdsdExecStoredProc;
    actOpenFormService: TdsdOpenForm;
    actOpenFormTransport: TdsdOpenForm;
    macOpenFormService: TMultiAction;
    macOpenFormTransport: TMultiAction;
    bbOpenFormTransport: TdxBarButton;
    bbOpenFormService: TdxBarButton;
    cbOnlyService: TcxCheckBox;
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
