unit UserHelsiEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  cxPropertiesStore, dsdAddOn, dsdGuides, dsdDB, dsdAction, Vcl.ActnList,
  cxMaskEdit, cxButtonEdit, cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel,
  cxTextEdit, dxSkinsCore, dxSkinsDefaultPainters, cxCheckBox;

type
  TUserHelsiEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    edUnit: TcxButtonEdit;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    UnitGuides: TdsdGuides;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    cxLabel4: TcxLabel;
    edUserName: TcxTextEdit;
    edUserPassword: TcxTextEdit;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    edKeyPassword: TcxTextEdit;
    edKey: TcxButtonEdit;
    dsdFileToBase641: TdsdFileToBase64;
    edLikiDnepr_Unit: TcxButtonEdit;
    cxLabel2: TcxLabel;
    edLikiDnepr_PasswordEHels: TcxTextEdit;
    cxLabel8: TcxLabel;
    edLikiDnepr_UserEmail: TcxTextEdit;
    cxLabel9: TcxLabel;
    LikiDnepr_UnitGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TUserHelsiEditForm);


end.
