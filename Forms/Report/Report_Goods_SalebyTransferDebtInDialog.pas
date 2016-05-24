unit Report_Goods_SalebyTransferDebtInDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, cxCurrencyEdit;

type
  TReport_Goods_SalebyTransferDebtInDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deEnd: TcxDateEdit;
    deStart: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    edRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    edPartner: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel1: TcxLabel;
    GuidesPartner: TdsdGuides;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel4: TcxLabel;
    GuidesBranch: TdsdGuides;
    edBranch: TcxButtonEdit;
    edPaidKind: TcxButtonEdit;
    cxLabel2: TcxLabel;
    GuidesPaidKind: TdsdGuides;
    cxLabel5: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    edGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    cePrice: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    edContract: TcxButtonEdit;
    ContractGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    edGoodsKind: TcxButtonEdit;
    GoodsKindGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Goods_SalebyTransferDebtInDialogForm);

end.
