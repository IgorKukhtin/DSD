unit Report_SaleOLAPDialog;

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
  TReport_SaleOLAPDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deEnd: TcxDateEdit;
    deStart: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel4: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    cxLabel1: TcxLabel;
    edBrand: TcxButtonEdit;
    GuidesBrand: TdsdGuides;
    cxLabel2: TcxLabel;
    edPeriod: TcxButtonEdit;
    GuidesPeriod: TdsdGuides;
    cxLabel5: TcxLabel;
    edStartYear: TcxCurrencyEdit;
    edEndYear: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    cbSize: TcxCheckBox;
    cbGoods: TcxCheckBox;
    cbPeriodAll: TcxCheckBox;
    cbYear: TcxCheckBox;
    cxLabel3: TcxLabel;
    edUnit: TcxButtonEdit;
    cbClient_doc: TcxCheckBox;
    cbOperPrice: TcxCheckBox;
    cbOperDate_doc: TcxCheckBox;
    cbDay_doc: TcxCheckBox;
    GuidesUnit: TdsdGuides;
    cbDiscount: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_SaleOLAPDialogForm);

end.
