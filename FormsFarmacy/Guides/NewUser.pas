unit NewUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, dsdAction, Vcl.ActnList;

type
  TNewUserForm = class(TParentForm)
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    cxLabel2: TcxLabel;
    edPhone: TcxTextEdit;
    cxLabel1: TcxLabel;
    edName: TcxTextEdit;
    ceUnit: TcxButtonEdit;
    cxLabel12: TcxLabel;
    cePosition: TcxButtonEdit;
    cxLabel11: TcxLabel;
    edLogin: TcxTextEdit;
    cxLabel3: TcxLabel;
    edPassword: TcxTextEdit;
    cxLabel4: TcxLabel;
    UnitGuides: TdsdGuides;
    PositionGuides: TdsdGuides;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose: TdsdFormClose;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    cxButton2: TcxButton;
    cxButton1: TcxButton;
    spGet: TdsdStoredProc;
    HeaderExitName: THeaderExit;
    actExitName: TdsdExecStoredProc;
    spGet_ExitName: TdsdStoredProc;
    spInsertUpdate: TdsdStoredProc;
    actShowPUSHMessageInfo: TdsdShowPUSHMessage;
    spPUSHInfo: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TNewUserForm);

end.
