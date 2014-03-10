unit PersonalServiceEdit;

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
  dxSkinWhiteprint, dxSkinXmas2008Blue, Vcl.Menus, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxDropDownEdit, cxCalendar, dsdAddOn, cxPropertiesStore,
  dsdGuides, dsdDB, dsdAction, Vcl.ActnList, cxMaskEdit, cxButtonEdit,
  cxTextEdit, cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel;

type
  TPersonalServiceEditForm = class(TParentForm)
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Код: TcxLabel;
    ceInvNumber: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cePersonal: TcxButtonEdit;
    cePaidKind: TcxButtonEdit;
    ceUnit: TcxButtonEdit;
    ceInfoMoney: TcxButtonEdit;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose1: TdsdFormClose;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    PersonalGuides: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    UnitGuides: TdsdGuides;
    InfoMoneyGuides: TdsdGuides;
    ceOperDate: TcxDateEdit;
    ceServiceDate: TcxDateEdit;
    cxLabel6: TcxLabel;
    cxCurrencyEdit1: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    ceStatusKind: TcxButtonEdit;
    StatusKindGuides: TdsdGuides;
    PositionGuides: TdsdGuides;
    cePosition: TcxButtonEdit;
    cxLabel9: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TPersonalServiceEditForm);

end.
