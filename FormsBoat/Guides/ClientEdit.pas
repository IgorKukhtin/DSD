unit ClientEdit;

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
  dsdGuides, cxMaskEdit, cxButtonEdit, dxSkinscxPCPainter, cxPCdxBarPopupMenu,
  cxPC;

type
  TClientEditForm = class(TParentForm)
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
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel3: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel6: TcxLabel;
    edDiscountTax: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    ceDayCalendar: TcxCurrencyEdit;
    ceDayBank: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    edFax: TcxTextEdit;
    cxLabel5: TcxLabel;
    edPhone: TcxTextEdit;
    cxLabel7: TcxLabel;
    edMobile: TcxTextEdit;
    edIBAN: TcxTextEdit;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    edStreet: TcxTextEdit;
    edMember: TcxTextEdit;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    edWWW: TcxTextEdit;
    edEmail: TcxTextEdit;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    edCodeDB: TcxTextEdit;
    cxLabel15: TcxLabel;
    edBank: TcxButtonEdit;
    cxLabel16: TcxLabel;
    edInfoMoney: TcxButtonEdit;
    cxLabel19: TcxLabel;
    edTaxKind: TcxButtonEdit;
    GuidesBank: TdsdGuides;
    GuidesInfoMoney: TdsdGuides;
    GuidesTaxKind: TdsdGuides;
    cxLabel20: TcxLabel;
    edTaxNumber: TcxTextEdit;
    cxLabel21: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    actVATNumberValidation: TdsdVATNumberValidation;
    cxButton3: TcxButton;
    edName1: TcxTextEdit;
    edName2: TcxTextEdit;
    edName3: TcxTextEdit;
    cxLabel22: TcxLabel;
    edCity: TcxButtonEdit;
    GuidesCity: TdsdGuides;
    cxLabel23: TcxLabel;
    edCountry: TcxButtonEdit;
    GuidesCountry: TdsdGuides;
    edPLZ: TcxButtonEdit;
    cxLabel14: TcxLabel;
    GuidesPLZ: TdsdGuides;
    cxLabel24: TcxLabel;
    cxPageControl1: TcxPageControl;
    Main: TcxTabSheet;
    Detail: TcxTabSheet;
    cxLabel4: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TClientEditForm);

end.
