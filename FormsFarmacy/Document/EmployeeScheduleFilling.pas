unit EmployeeScheduleFilling;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, dsdAction, Vcl.ActnList, cxStyles,
  cxSchedulerStorage, cxSchedulerCustomControls, cxSchedulerDateNavigator,
  cxDateNavigator;

type
  TEmployeeScheduleFillingForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    FormParams: TdsdFormParams;
    cxLabel3: TcxLabel;
    cePayrollType: TcxButtonEdit;
    GuidesPayrollType: TdsdGuides;
    DateNavigator: TcxDateNavigator;
    GuidesUser: TdsdGuides;
    ceUser: TcxButtonEdit;
    cxLabel1: TcxLabel;
    cbEndMin: TcxComboBox;
    cxLabel7: TcxLabel;
    cbEndHour: TcxComboBox;
    cxLabel4: TcxLabel;
    cbStartMin: TcxComboBox;
    cxLabel6: TcxLabel;
    cbStartHour: TcxComboBox;
    cxLabel2: TcxLabel;
    GuidesUnit: TdsdGuides;
    ceUnit: TcxButtonEdit;
    cxLabel5: TcxLabel;
    spUpdateEmployeeScheduleUser: TdsdStoredProc;
    ActionList: TActionList;
    actExecuteFilling: TMultiAction;
    actExecuteSPFilling: TdsdExecStoredProc;
    actFormClose: TdsdFormClose;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TEmployeeScheduleFillingForm);

end.
