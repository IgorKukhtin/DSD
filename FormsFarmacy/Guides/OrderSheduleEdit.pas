unit OrderSheduleEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore, dsdDB,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, dsdAction, ParentForm, cxCurrencyEdit, dxSkinsCore, dsdAddOn, cxCheckBox,
  dxSkinsDefaultPainters, dsdGuides, cxMaskEdit, cxButtonEdit;

type
  TOrderSheduleEditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose1: TdsdFormClose;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    cxLabel2: TcxLabel;
    ceValue1: TcxCurrencyEdit;
    cxLabel19: TcxLabel;
    edContract: TcxButtonEdit;
    ContractGuides: TdsdGuides;
    cxLabel1: TcxLabel;
    edUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    ceValue2: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ceValue3: TcxCurrencyEdit;
    ceValue4: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    ceValue5: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    ceValue6: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceValue7: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderSheduleEditForm);

end.
