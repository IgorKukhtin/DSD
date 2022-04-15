unit UserByGroupListEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox,
  Data.DB, Datasnap.DBClient, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, ParentForm, dsdGuides,
  dsdDB, dsdAction, cxButtonEdit, dsdAddOn, dxSkinsCore, dxSkinsDefaultPainters;

type
  TUserByGroupListEditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose: TdsdFormClose;
    cxLabel3: TcxLabel;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    edUser: TcxButtonEdit;
    edUserByGroup: TcxButtonEdit;
    cxLabel5: TcxLabel;
    GuidesUserByGroup: TdsdGuides;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    GuidesUser: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TUserByGroupListEditForm);

end.
