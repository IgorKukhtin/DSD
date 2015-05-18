unit DialogWeight;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialog, StdCtrls, Buttons, ExtCtrls;

type
  TDialogWeightForm = class(TAncestorDialogForm)
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
 