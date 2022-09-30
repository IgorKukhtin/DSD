unit UserEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  cxPropertiesStore, dsdAddOn, dsdGuides, dsdDB, dsdAction, Vcl.ActnList,
  cxMaskEdit, cxButtonEdit, cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel,
  cxTextEdit, dxSkinsCore, dxSkinsDefaultPainters, cxCheckBox, cxDropDownEdit;

type
  TUserEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    edMember: TcxButtonEdit;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    MemberGuides: TdsdGuides;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    edPassword: TcxTextEdit;
    cxLabel2: TcxLabel;
    cxLabel4: TcxLabel;
    edSign: TcxTextEdit;
    edSeal: TcxTextEdit;
    cxLabel5: TcxLabel;
    edKey: TcxTextEdit;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    edProjectMobile: TcxTextEdit;
    ceisProjectMobile: TcxCheckBox;
    ceisSite: TcxCheckBox;
    ceManagerPharmacy: TcxCheckBox;
    edPasswordWages: TcxTextEdit;
    cxLabel8: TcxLabel;
    cbWorkingMultiple: TcxCheckBox;
    ceNewUser: TcxCheckBox;
    ceDismissedUser: TcxCheckBox;
    ceInternshipCompleted: TcxCheckBox;
    edInternshipConfirmation: TcxTextEdit;
    cbLanguage: TcxComboBox;
    cxLabel9: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TUserEditForm);


end.
