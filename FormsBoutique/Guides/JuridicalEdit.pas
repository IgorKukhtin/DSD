unit JuridicalEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, ParentForm, dsdDB, dsdAction, cxCurrencyEdit, dsdAddOn,
  dxSkinsCore, dxSkinsDefaultPainters, cxCheckBox, dsdGuides, cxMaskEdit,
  cxButtonEdit;

type
  TJuridicalEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    edAddress: TcxTextEdit;
    edFullName: TcxTextEdit;
    edOKPO: TcxTextEdit;
    cxLabel5: TcxLabel;
    cbisCorporate: TcxCheckBox;
    edINN: TcxTextEdit;
    cxLabel6: TcxLabel;
    ceJuridicalGroup: TcxButtonEdit;
    JuridicalGroupGuides: TdsdGuides;
    cxLabel7: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TJuridicalEditForm);

end.
