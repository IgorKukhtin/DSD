unit PriceListTaxDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, Vcl.Menus, dsdGuides, Data.DB,
  Datasnap.DBClient, dsdAddOn, cxPropertiesStore, dsdDB, dsdAction,
  Vcl.ActnList, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel,
  cxTextEdit, cxButtonEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxCalendar,
  cxCheckBox;

type
  TPriceListTaxDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxLabel3: TcxLabel;
    ActionList: TActionList;
    actDataSetRefresh: TdsdDataSetRefresh;
    actFormClose: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    edOperDate: TcxDateEdit;
    actUpdate: TdsdInsertUpdateGuides;
    Код: TcxLabel;
    edPriceListFrom: TcxButtonEdit;
    cePriceTax: TcxCurrencyEdit;
    PriceListGuidesFrom: TdsdGuides;
    cxLabel4: TcxLabel;
    edPriceListTo: TcxButtonEdit;
    PriceListGuidesTo: TdsdGuides;
    cxLabel8: TcxLabel;
    cxLabel1: TcxLabel;
    edOperDateFrom: TcxDateEdit;
    mactUpdate: TMultiAction;
    cxLabel2: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GuidesGoodsGroup: TdsdGuides;
    cxLabel7: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPriceListTaxDialogForm);
end.
