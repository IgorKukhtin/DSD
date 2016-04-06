unit Report_PriceInterventionDialog;

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
  TReport_PriceInterventionDialogForm = class(TParentForm)
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
    cePrice1: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    cePrice2: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    cePrice3: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    cePrice4: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    cePrice5: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    cePrice6: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    cxLabel3: TcxLabel;
    ceMarginReport: TcxButtonEdit;
    MarginReportGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_PriceInterventionDialogForm);

end.
