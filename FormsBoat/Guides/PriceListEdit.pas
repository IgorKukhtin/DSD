unit PriceListEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore, dsdDB,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, dsdAction, ParentForm, cxCurrencyEdit, dxSkinsCore, dsdAddOn, cxCheckBox,
  dxSkinsDefaultPainters, dsdGuides, cxMaskEdit, cxButtonEdit;

type
  TPriceListEditForm = class(TParentForm)
    edMeasureName: TcxTextEdit;
    cxLabel1: TcxLabel;
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
    edPriceWithVAT: TcxCheckBox;
    cxLabel2: TcxLabel;
    ceVATPercent: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPriceListEditForm);

end.
