unit ReceiptEdit;

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
  dxSkinWhiteprint, dxSkinXmas2008Blue, Vcl.Menus, dsdGuides, Data.DB,
  Datasnap.DBClient, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, dsdAddOn, cxPropertiesStore, dsdDB, dsdAction,
  Vcl.ActnList, cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit,
  cxButtonEdit, cxCheckBox, Vcl.ComCtrls, dxCore, cxDateUtils, cxCalendar,
  dsdCommon;

type
  TReceiptEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    InsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn;
    cxLabel5: TcxLabel;
    cxLabel7: TcxLabel;
    ceReceiptCost: TcxButtonEdit;
    ReceiptCostGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    ceReceiptKind: TcxButtonEdit;
    ReceiptKindGuides: TdsdGuides;
    cbIsMain: TcxCheckBox;
    edComment: TcxTextEdit;
    ceValue: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    ceValueCost: TcxCurrencyEdit;
    cePartionValue: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    cePartionCount: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    ceTaxExit: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    cxLabel15: TcxLabel;
    ceWeightPackage: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    edStartDate: TcxDateEdit;
    edEndDate: TcxDateEdit;
    ceGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    cxLabel2: TcxLabel;
    ceGoodsKind: TcxButtonEdit;
    GoodsKindGuides: TdsdGuides;
    cxLabel18: TcxLabel;
    ceGoodsKindComplete: TcxButtonEdit;
    GoodsKindCompleteGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    edReceiptCode: TcxTextEdit;
    cxLabel6: TcxLabel;
    cxLabel8: TcxLabel;
    edTaxLossCEH: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    edTaxLossVPR: TcxCurrencyEdit;
    cxLabel19: TcxLabel;
    edTaxLossTRM: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    edRealDelicShp: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    ceValuePF: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
 initialization
  RegisterClass(TReceiptEditForm);
end.
