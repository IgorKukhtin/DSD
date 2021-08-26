unit Report_GoodsMI_SaleReturnIn_PaidKindDialog;

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
  TReport_GoodsMI_SaleReturnIn_PaidKindDialogForm = class(TParentForm)
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
    cxLabel1: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    edBranch: TcxButtonEdit;
    cxLabel20: TcxLabel;
    edArea: TcxButtonEdit;
    cxLabel9: TcxLabel;
    edRetail: TcxButtonEdit;
    cxLabel10: TcxLabel;
    edJuridical: TcxButtonEdit;
    cxLabel11: TcxLabel;
    edPaidKind: TcxButtonEdit;
    cxLabel12: TcxLabel;
    ådTradeMark: TcxButtonEdit;
    cxLabel13: TcxLabel;
    edInfoMoney: TcxButtonEdit;
    cbPartner: TcxCheckBox;
    cbTradeMark: TcxCheckBox;
    cbGoods: TcxCheckBox;
    cbGoodsKind: TcxCheckBox;
    GuidesBranch: TdsdGuides;
    GuidesArea: TdsdGuides;
    GuidesRetail: TdsdGuides;
    GuidesJuridical: TdsdGuides;
    GuidesPaidKind: TdsdGuides;
    GuidesTradeMark: TdsdGuides;
    GuidesInfoMoney: TdsdGuides;
    cbPaidKind: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_GoodsMI_SaleReturnIn_PaidKindDialogForm);

end.
