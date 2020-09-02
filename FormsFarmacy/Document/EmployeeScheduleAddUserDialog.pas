unit EmployeeScheduleAddUserDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox;

type
  TEmployeeScheduleAddUserDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deDateStart: TcxDateEdit;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    cxLabel6: TcxLabel;
    PeriodChoice: TPeriodChoice;
    deDateEnd: TcxDateEdit;
    cxLabel1: TcxLabel;
    edUser: TcxTextEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cePayrollType: TcxButtonEdit;
    GuidesPayrollType: TdsdGuides;
    edUnit: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesUnit: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TEmployeeScheduleAddUserDialogForm);

end.
