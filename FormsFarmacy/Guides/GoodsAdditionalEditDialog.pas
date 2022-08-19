unit GoodsAdditionalEditDialog;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCurrencyEdit, Vcl.ActnList, dsdAction;

type
  TGoodsAdditionalEditDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    cb_MakerName: TcxCheckBox;
    cb_FormDispensing: TcxCheckBox;
    cb_NumberPlates: TcxCheckBox;
    cb_QtyPackage: TcxCheckBox;
    cxLabel2: TcxLabel;
    edMakerName: TcxButtonEdit;
    edNumberPlates: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel7: TcxLabel;
    ceQtyPackage: TcxCurrencyEdit;
    cbIsRecipe: TcxCheckBox;
    edFormDispensing: TcxButtonEdit;
    cxLabel14: TcxLabel;
    GoodsMakerNameGuides: TdsdGuides;
    FormDispensingGuides: TdsdGuides;
    cb_IsRecipe: TcxCheckBox;
    edMakerNameUkr: TcxTextEdit;
    cxLabel1: TcxLabel;
    cb_MakerNameUkr: TcxCheckBox;
    cb_Dosage: TcxCheckBox;
    edDosage: TcxTextEdit;
    cxLabel4: TcxLabel;
    cb_Volume: TcxCheckBox;
    edVolume: TcxTextEdit;
    cxLabel5: TcxLabel;
    cb_GoodsWhoCan: TcxCheckBox;
    ceGoodsWhoCan: TcxButtonEdit;
    cxLabel6: TcxLabel;
    cb_GoodsMethodAppl: TcxCheckBox;
    edGoodsMethodAppl: TcxButtonEdit;
    cxLabel8: TcxLabel;
    cb_GoodsSignOrigin: TcxCheckBox;
    edGoodsSignOrigin: TcxButtonEdit;
    cxLabel9: TcxLabel;
    GoodsWhoCanGuides: TdsdGuides;
    GoodsMethodApplGuides: TdsdGuides;
    GoodsSignOriginGuides: TdsdGuides;
    spUpdateGoodsAdditional: TdsdStoredProc;
    ActionList1: TActionList;
    actPUSHClose: TdsdShowPUSHMessage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsAdditionalEditDialogForm);

end.
