unit ReasonEdit;

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
  dsdGuides, cxMaskEdit, cxButtonEdit, cxCheckBox;

type
  TReasonEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel11: TcxLabel;
    ceReturnKind: TcxButtonEdit;
    GuidesReturnKind: TdsdGuides;
    cbisReturnIn: TcxCheckBox;
    cbisSendOnPrice: TcxCheckBox;
    edComment: TcxTextEdit;
    cxLabel3: TcxLabel;
    edPeriodTax: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    edPeriodDays: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edReturnDescKind: TcxButtonEdit;
    GuidesReturnDescKind: TdsdGuides;
    cxLabel7: TcxLabel;
    edShort: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReasonEditForm);

end.
