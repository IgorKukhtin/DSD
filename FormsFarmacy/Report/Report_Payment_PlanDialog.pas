unit Report_Payment_PlanDialog;

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
  TReport_Payment_PlanDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deEnd: TcxDateEdit;
    deStart: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    edJuridical: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    JuridicalGuides: TdsdGuides;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Payment_PlanDialogForm);

end.
