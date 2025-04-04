unit Report_PersonalDialog;

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
  TReport_PersonalDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deEnd: TcxDateEdit;
    deStart: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    edBranch: TcxButtonEdit;
    cxLabel20: TcxLabel;
    edAccount: TcxButtonEdit;
    cxLabel9: TcxLabel;
    edInfoMoneyDestination: TcxButtonEdit;
    cxLabel13: TcxLabel;
    edInfoMoneyGroup: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    GuidesAccount: TdsdGuides;
    GuidesInfoMoneyDestination: TdsdGuides;
    cxLabel5: TcxLabel;
    edInfoMoney: TcxButtonEdit;
    GuidesInfoMoneyGroup: TdsdGuides;
    GuidesInfoMoney: TdsdGuides;
    cbServiceDate: TcxCheckBox;
    deServiceDate: TcxDateEdit;
    cxLabel1: TcxLabel;
    cePersonalServiceList: TcxButtonEdit;
    PersonalServiceListGuides: TdsdGuides;
    cxLabel2: TcxLabel;
    cePersonal: TcxButtonEdit;
    PersonalGuides: TdsdGuides;
    cbMember: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_PersonalDialogForm);

end.
