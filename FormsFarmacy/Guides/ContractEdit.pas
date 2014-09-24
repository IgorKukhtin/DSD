unit ContractEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEditDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit, cxCheckBox,
  dsdGuides, cxMaskEdit, cxButtonEdit, cxTextEdit, cxCurrencyEdit, cxLabel,
  dsdDB, dsdAction, Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls,
  cxButtons;

type
  TContractEditForm = class(TAncestorEditDialogForm)
    cxLabel2: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    edName: TcxTextEdit;
    cxLabel4: TcxLabel;
    ceJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel5: TcxLabel;
    ceJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    ceDeferment: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TContractEditForm);

end.

