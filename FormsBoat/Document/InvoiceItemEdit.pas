unit InvoiceItemEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, ParentForm, dsdDB, dsdAction, cxCurrencyEdit, dsdAddOn,
  dxSkinsCore, dxSkinsDefaultPainters, dsdGuides, cxMaskEdit, cxButtonEdit,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxCheckBox;

type
  TInvoiceItemEditForm = class(TParentForm)
    cxLabel1: TcxLabel;
    cxButtonOK: TcxButton;
    cxButtonCancel: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    actRefresh: TdsdDataSetRefresh;
    actInsertUpdate: TdsdInsertUpdateGuides;
    actFormClose: TdsdFormClose;
    cxPropertiesStore: TcxPropertiesStore;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    edGoodsName: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    cxLabel18: TcxLabel;
    ceAmount: TcxCurrencyEdit;
    actRefresh_Price: TdsdDataSetRefresh;
    cxLabel14: TcxLabel;
    edGoodsCode: TcxTextEdit;
    cxLabel3: TcxLabel;
    edArticle: TcxTextEdit;
    cxLabel5: TcxLabel;
    ceOperPrice: TcxCurrencyEdit;
    HeaderExit: THeaderExit;
    GuidesFiller: TGuidesFiller;
    ceComment: TcxTextEdit;
    cxLabel16: TcxLabel;
    EnterMoveNext: TEnterMoveNext;
    btnGoodsChoiceForm: TcxButton;
    actGoodsChoiceForm: TOpenChoiceForm;
    cxLabel2: TcxLabel;
    cxLabel4: TcxLabel;
    ceSummPVAT: TcxCurrencyEdit;
    ceSummMVAT: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    ceSummà_VAT: TcxCurrencyEdit;
    spUpdate_before: TdsdStoredProc;
    actUpdate_summ_before: TdsdDataSetRefresh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TInvoiceItemEditForm);

end.
