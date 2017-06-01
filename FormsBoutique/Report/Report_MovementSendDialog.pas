unit Report_MovementSendDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, dsdAction, Vcl.ActnList;

type
  TReport_MovementSendDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deEnd: TcxDateEdit;
    deStart: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    edUnitFrom: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    GuidesUnitFrom: TdsdGuides;
    cbPartion: TcxCheckBox;
    cbSize: TcxCheckBox;
    cxLabel1: TcxLabel;
    edBrand: TcxButtonEdit;
    cxLabel2: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesBrand: TdsdGuides;
    GuidesPartner: TdsdGuides;
    cbPartner: TcxCheckBox;
    cbMovement: TcxCheckBox;
    cxLabel4: TcxLabel;
    edUnitTo: TcxButtonEdit;
    GuidesUnitTo: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_MovementSendDialogForm);

end.
