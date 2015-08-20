unit Report_ReceiptProductionOutAnalyzeDialog;

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
  TReport_ReceiptProductionOutAnalyzeDialogForm = class(TParentForm)
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
    cxLabel3: TcxLabel;
    edFromUnit: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edToUnit: TcxButtonEdit;
    FromUnitGuides: TdsdGuides;
    ToUnitGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    edPriceList_1: TcxButtonEdit;
    cxLabel1: TcxLabel;
    edPriceList_2: TcxButtonEdit;
    PriceList_1_Guides: TdsdGuides;
    PriceList_2_Guides: TdsdGuides;
    cxLabel2: TcxLabel;
    cxLabel8: TcxLabel;
    edPriceList_3: TcxButtonEdit;
    edPriceList_sale: TcxButtonEdit;
    PriceList_3_Guides: TdsdGuides;
    PriceList_sale_Guides: TdsdGuides;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_ReceiptProductionOutAnalyzeDialogForm);

end.
