unit Report_CheckSendSUN_InOutDialog;

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
  TReport_CheckSendSUN_InOutDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    PeriodChoice: TPeriodChoice;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    edUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    UnitGuides: TdsdGuides;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    cxLabel6: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel1: TcxLabel;
    deStart2: TcxDateEdit;
    cxLabel2: TcxLabel;
    deEnd2: TcxDateEdit;
    PeriodChoice2: TPeriodChoice;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_CheckSendSUN_InOutDialogForm);

end.
