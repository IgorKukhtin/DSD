unit UnitEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox, ParentForm, dsdGuides, dsdDB,
  dsdAction, cxMaskEdit, cxButtonEdit, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxDropDownEdit, cxCalendar, cxSpinEdit,
  cxTimeEdit, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TUnitEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    DataSetRefresh: TdsdDataSetRefresh;
    InsertUpdateGuides: TdsdInsertUpdateGuides;
    FormClose: TdsdFormClose;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    ParentGuides: TdsdGuides;
    ceParent: TcxButtonEdit;
    cxLabel5: TcxLabel;
    ceJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    cxLabel2: TcxLabel;
    edMarginCategory: TcxButtonEdit;
    MarginCategoryGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    ceTaxService: TcxCurrencyEdit;
    cbRepriceAuto: TcxCheckBox;
    cxLabel6: TcxLabel;
    ceTaxServiceNigth: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    edEndServiceNigth: TcxDateEdit;
    edStartServiceNigth: TcxDateEdit;
    cxLabel9: TcxLabel;
    edAddress: TcxTextEdit;
    cxLabel10: TcxLabel;
    ceProvinceCity: TcxButtonEdit;
    GuidesProvinceCity: TdsdGuides;
    cxLabel11: TcxLabel;
    edCreateDate: TcxDateEdit;
    edCloseDate: TcxDateEdit;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    edUserManager: TcxButtonEdit;
    GuidesUserManager: TdsdGuides;
    cxLabel14: TcxLabel;
    edArea: TcxButtonEdit;
    GuidesArea: TdsdGuides;
    ceUnitCategory: TcxButtonEdit;
    cxLabel15: TcxLabel;
    GuidesUnitCategory: TdsdGuides;
    ceNormOfManDays: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    edPhone: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TUnitEditForm);

end.
