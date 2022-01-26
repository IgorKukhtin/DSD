unit Report_GoodsMI_IncomeDialog;

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
  TReport_GoodsMI_IncomeDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deEnd: TcxDateEdit;
    deStart: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    edGoodsGroup: TcxButtonEdit;
    GuidesGoodsGroup: TdsdGuides;
    edUnitGroup: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel1: TcxLabel;
    GuidesUnitGroup: TdsdGuides;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel4: TcxLabel;
    GuidesUnit: TdsdGuides;
    edUnit: TcxButtonEdit;
    edPaidKind: TcxButtonEdit;
    cxLabel2: TcxLabel;
    GuidesPaidKind: TdsdGuides;
    cxLabel5: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    edInfoMoney: TcxButtonEdit;
    InfoMoneyGuide: TdsdGuides;
    cbDate: TcxCheckBox;
    cbMovement: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_GoodsMI_IncomeDialogForm);

end.
