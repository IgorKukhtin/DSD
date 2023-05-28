unit Report_MotionGoodsAssetDialog;

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
  TReport_MotionGoodsAssetDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deEnd: TcxDateEdit;
    deStart: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    edGoods: TcxButtonEdit;
    edGoodsGroup: TcxButtonEdit;
    edLocation: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    GuidesGoodsGroup: TdsdGuides;
    GuidesLocation: TdsdGuides;
    edUnitGroup: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    GuidesUnitGroup: TdsdGuides;
    ceAccountGroup: TcxButtonEdit;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cbInfoMoney: TcxCheckBox;
    GuidesAccountGroup: TdsdGuides;
    cxLabel8: TcxLabel;
    edUnitGroup_by: TcxButtonEdit;
    GuidesUnitGroup_by: TdsdGuides;
    cxLabel9: TcxLabel;
    edLocation_by: TcxButtonEdit;
    GuidesLocation_by: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_MotionGoodsAssetDialogForm);

end.
