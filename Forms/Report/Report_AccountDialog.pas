unit Report_AccountDialog;

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
  TReport_AccountDialogForm = class(TParentForm)
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
    GuidesBranch: TdsdGuides;
    GuidesAccount: TdsdGuides;
    cxLabel5: TcxLabel;
    edInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    cxLabel4: TcxLabel;
    ceAccountGroup: TcxButtonEdit;
    cxLabel3: TcxLabel;
    ceProfitLossGroup: TcxButtonEdit;
    AccountGroupGuides: TdsdGuides;
    ProfitLossGroupGuides: TdsdGuides;
    cxLabel10: TcxLabel;
    ceAccountDirection: TcxButtonEdit;
    cxLabel12: TcxLabel;
    ceProfitLossDirection: TcxButtonEdit;
    AccountDirectionGuides: TdsdGuides;
    ProfitLossDirectionGuides: TdsdGuides;
    cxLabel13: TcxLabel;
    ceProfitLoss: TcxButtonEdit;
    ProfitLossGuides: TdsdGuides;
    cxLabel1: TcxLabel;
    ceBusiness: TcxButtonEdit;
    BusinessGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_AccountDialogForm);

end.
