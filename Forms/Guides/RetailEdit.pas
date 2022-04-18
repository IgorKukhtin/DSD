unit RetailEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, ParentForm, dsdDB, dsdAction, cxCurrencyEdit, dsdAddOn,
  dxSkinsCore, dxSkinsDefaultPainters, dsdGuides, cxMaskEdit, cxButtonEdit,
  cxCheckBox;

type
  TRetailEditForm = class(TParentForm)
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
    cxLabel3: TcxLabel;
    edGLNCode: TcxTextEdit;
    cxLabel4: TcxLabel;
    ceGoodsProperty: TcxButtonEdit;
    GuidesGoodsProperty: TdsdGuides;
    cxLabel5: TcxLabel;
    edGLNCodeCorporate: TcxTextEdit;
    cbOperDateOrder: TcxCheckBox;
    cxLabel6: TcxLabel;
    cePersonalMarketing: TcxButtonEdit;
    GuidesPersonalMarketing: TdsdGuides;
    cxLabel7: TcxLabel;
    cePersonalTrade: TcxButtonEdit;
    GuidesPersonalTrade: TdsdGuides;
    cxLabel8: TcxLabel;
    edOKPO: TcxTextEdit;
    cxLabel9: TcxLabel;
    edClientKind: TcxButtonEdit;
    GuidesClientKind: TdsdGuides;
    ceRoundWeight: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TRetailEditForm);

end.
