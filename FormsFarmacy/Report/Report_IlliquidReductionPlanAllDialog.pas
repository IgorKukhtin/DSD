unit Report_IlliquidReductionPlanAllDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, dsdAction, Vcl.ActnList, cxCurrencyEdit;

type
  TReport_IlliquidReductionPlanAllDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    PeriodChoice: TPeriodChoice;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    deOperDate: TcxDateEdit;
    cxLabel1: TcxLabel;
    ceProcUnit: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ceProcGoods: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cePenalty: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    cePlanAmount: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_IlliquidReductionPlanAllDialogForm);

end.
