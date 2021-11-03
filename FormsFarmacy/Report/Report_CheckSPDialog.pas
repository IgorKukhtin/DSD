unit Report_CheckSPDialog;

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
  TReport_CheckSPDialogForm = class(TParentForm)
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
    cxLabel4: TcxLabel;
    cxLabel1: TcxLabel;
    edJuridical: TcxButtonEdit;
    ceUnit: TcxButtonEdit;
    cxLabel5: TcxLabel;
    ceHospital: TcxButtonEdit;
    JuridicalGuide: TdsdGuides;
    UnitGuides: TdsdGuides;
    HospitalGuides: TdsdGuides;
    cxLabel2: TcxLabel;
    edJuridicalMedic: TcxButtonEdit;
    GuidesJuridicalMedic: TdsdGuides;
    ceMedicalProgramSP: TcxButtonEdit;
    cxLabel3: TcxLabel;
    MedicalProgramSPGuides: TdsdGuides;
    edGroupMedicalProgramSP: TcxButtonEdit;
    cxLabel8: TcxLabel;
    GroupMedicalProgramSPGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_CheckSPDialogForm);

end.
