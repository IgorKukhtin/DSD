unit BankAccountMovementFarmacy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BankAccountMovement, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, dsdGuides, dsdDB, dsdAction,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, cxTextEdit, cxCurrencyEdit,
  cxButtonEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, Vcl.StdCtrls,
  cxButtons;

type
  TBankAccountMovementFarmacyForm = class(TBankAccountMovementForm)
    cxLabel14: TcxLabel;
    edIncome: TcxButtonEdit;
    GuidesIncome: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass (TBankAccountMovementFarmacyForm)


end.
