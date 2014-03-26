unit GoodsKindWeighingEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox,
  Data.DB, Datasnap.DBClient, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, ParentForm, dsdGuides,
  dsdDB, dsdAction, cxButtonEdit, dsdAddOn;

type
  TGoodsKindWeighingEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose: TdsdFormClose;
     Ó‰: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    dsdMeasureGuides: TdsdGuides;
    cxLabel2: TcxLabel;
    ceWeight: TcxCurrencyEdit;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    ceParentGroup: TcxButtonEdit;
    ceMeasure: TcxButtonEdit;
    ÒÂTradeMark: TcxButtonEdit;
    cxLabel5: TcxLabel;
    TradeMarkGuides: TdsdGuides;
    ceInfoMoney: TcxButtonEdit;
    cxLabel6: TcxLabel;
    dsdInfoMoneyGuides: TdsdGuides;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel7: TcxLabel;
    ceBusiness: TcxButtonEdit;
    BusinessGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    edFuel: TcxButtonEdit;
    FuelGuides: TdsdGuides;
    GoodsGroupGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsKindWeighingEditForm);

end.
