unit Check_SPEdit;

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
  TCheck_SPEditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deOperDateSP: TcxDateEdit;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    cxLabel6: TcxLabel;
    PeriodChoice: TPeriodChoice;
    cxLabel14: TcxLabel;
    edInvNumberSP: TcxTextEdit;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    edAmbulance: TcxTextEdit;
    edMedicSP: TcxTextEdit;
    cxLabel12: TcxLabel;
    edPartnerMedical: TcxButtonEdit;
    PartnerMedicalGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCheck_SPEditForm);

end.
