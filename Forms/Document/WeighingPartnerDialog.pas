unit WeighingPartnerDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TWeighingPartnerDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    cxLabel1: TcxLabel;
    edPersonal1: TcxButtonEdit;
    GuidesPersonal5: TdsdGuides;
    cxLabel2: TcxLabel;
    edPersonal5: TcxButtonEdit;
    GuidesPersonal1: TdsdGuides;
    cxLabel3: TcxLabel;
    edPersonal2: TcxButtonEdit;
    GuidesPersonal2: TdsdGuides;
    cxLabel4: TcxLabel;
    edPersonal3: TcxButtonEdit;
    GuidesPersonal3: TdsdGuides;
    cxLabel5: TcxLabel;
    edPersonal4: TcxButtonEdit;
    GuidesPersonal4: TdsdGuides;
    cxLabel6: TcxLabel;
    edPosition1: TcxButtonEdit;
    GuidesPosition1: TdsdGuides;
    cxLabel7: TcxLabel;
    edPosition2: TcxButtonEdit;
    GuidesPosition2: TdsdGuides;
    cxLabel8: TcxLabel;
    edPosition3: TcxButtonEdit;
    GuidesPosition3: TdsdGuides;
    cxLabel9: TcxLabel;
    edPosition4: TcxButtonEdit;
    GuidesPosition4: TdsdGuides;
    cxLabel10: TcxLabel;
    edPosition5: TcxButtonEdit;
    GuidesPosition5: TdsdGuides;
    cxLabel11: TcxLabel;
    edPersona1_Stick: TcxButtonEdit;
    GuidesPersona1_Stick: TdsdGuides;
    cxLabel12: TcxLabel;
    edPosition1_Stick: TcxButtonEdit;
    GuidesPosition1_Stick: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWeighingPartnerDialogForm);

end.
