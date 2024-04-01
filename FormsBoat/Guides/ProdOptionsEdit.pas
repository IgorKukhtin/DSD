unit ProdOptionsEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, ParentForm, dsdDB, dsdAction, cxCurrencyEdit, dsdAddOn,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  dsdGuides, cxMaskEdit, cxButtonEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxCheckBox, cxDropDownEdit, cxCalendar;

type
  TProdOptionsEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    actDataSetRefresh: TdsdDataSetRefresh;
    actInsertUpdateGuides: TdsdInsertUpdateGuides;
    actFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel3: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel6: TcxLabel;
    edSalePrice: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    edModel: TcxButtonEdit;
    cxLabel11: TcxLabel;
    edBrand: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edProdEngine: TcxButtonEdit;
    GuidesModel: TdsdGuides;
    GuidesBrand: TdsdGuides;
    GuidesProdEngine: TdsdGuides;
    cxLabel5: TcxLabel;
    edTaxKind: TcxButtonEdit;
    GuidesTaxKind: TdsdGuides;
    cxLabel7: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    cxLabel8: TcxLabel;
    edMaterialOptions: TcxButtonEdit;
    GuidesMaterialOptions: TdsdGuides;
    edCodeVergl: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    edId_Site: TcxTextEdit;
    GuidesProdColorPattern: TdsdGuides;
    edProdColorPattern: TcxButtonEdit;
    cxLabel13: TcxLabel;
    cxLabel14: TcxLabel;
    edAmount: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    edPriceList: TcxButtonEdit;
    cxLabel16: TcxLabel;
    edOperDate: TcxDateEdit;
    GuidesPriceList: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProdOptionsEditForm);

end.
