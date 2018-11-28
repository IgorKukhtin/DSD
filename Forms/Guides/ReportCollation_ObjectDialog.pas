unit ReportCollation_ObjectDialog;

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
  TReportCollation_ObjectDialogForm = class(TParentForm)
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
    cxLabel11: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    cxLabel1: TcxLabel;
    edJuridical: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edPartner: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    PartnerGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    ceContract: TcxButtonEdit;
    ContractGuides: TdsdGuides;
    cxLabel20: TcxLabel;
    edContractTag: TcxButtonEdit;
    ContractTagGuides: TdsdGuides;
    cxLabel2: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReportCollation_ObjectDialogForm);

end.
