unit DialogWeight;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Buttons, ExtCtrls, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinsDefaultPainters, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons;

type
  TDialogWeightForm = class(TAncestorDialogScaleForm)
    rgWeight: TRadioGroup;
    procedure FormShow(Sender: TObject);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  end;

var
  DialogWeightForm: TDialogWeightForm;

implementation
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogWeightForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(rgWeight.ItemIndex=0)or(rgWeight.ItemIndex=1);
end;
{------------------------------------------------------------------------------}
procedure TDialogWeightForm.FormShow(Sender: TObject);
begin
  inherited;
  ActiveControl:=rgWeight;
end;
{------------------------------------------------------------------------------}
end.
 