unit BankAccountMovementFarmacyForm;

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
  TBankAccountMovementForm2 = class(TBankAccountMovementForm)
    cxLabel14: TcxLabel;
    edIncome: TcxButtonEdit;
    GuidesIncome: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BankAccountMovementForm2: TBankAccountMovementForm2;

implementation

{$R *.dfm}

end.
