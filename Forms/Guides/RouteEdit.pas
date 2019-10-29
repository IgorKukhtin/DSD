unit RouteEdit;

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
  dxSkinWhiteprint, dxSkinXmas2008Blue, Vcl.Menus, dsdAddOn, cxPropertiesStore,
  dsdDB, dsdAction, Vcl.ActnList, cxCurrencyEdit, Vcl.StdCtrls, cxButtons,
  cxLabel, cxTextEdit, dsdGuides, cxMaskEdit, cxButtonEdit, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxDropDownEdit, cxCalendar, cxCheckBox;

type
  TRouteEditForm = class(TParentForm)
    edRouteName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ���: TcxLabel;
    ceCode: TcxCurrencyEdit;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose1: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    ceUnit: TcxButtonEdit;
    cxLabel7: TcxLabel;
    UnitGuides: TdsdGuides;
    cxLabel2: TcxLabel;
    ceRouteKind: TcxButtonEdit;
    RouteKindGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    ceFreight: TcxButtonEdit;
    FreightGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    ceBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    ceRouteGroup: TcxButtonEdit;
    RouteGroupGuides: TdsdGuides;
    cxLabel29: TcxLabel;
    edRateSumma: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edRatePrice: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    edTimePrice: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    edRateSummaAdd: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    edRateSummaExp: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    edStartRunPlan: TcxDateEdit;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    edHoursPlan: TcxCurrencyEdit;
    edMinutePlan: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edEndRunPlan: TcxTextEdit;
    cbNotPayForWeight: TcxCheckBox;

  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TRouteEditForm);

end.
