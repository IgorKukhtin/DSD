unit DialogNumberValue;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Mask, Buttons,
  ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxCurrencyEdit, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons;

type
  TDialogNumberValueForm = class(TAncestorDialogScaleForm)
    PanelNumberValue: TPanel;
    NumberValueEdit: TcxCurrencyEdit;
    LabelNumberValue: TLabel;
  private
    function Checked: boolean; override;//Ïğîâåğêà êîğğåêòíîãî ââîäà â Edit
  public
   NumberValue:Integer;
  end;

var
   DialogNumberValueForm: TDialogNumberValueForm;

implementation
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogNumberValueForm.Checked: boolean; //Ïğîâåğêà êîğğåêòíîãî ââîäà â Edit
begin
     try NumberValue:=StrToInt(NumberValueEdit.Text);except NumberValue:=0;end;
     Result:=NumberValue>=0;
end;
{------------------------------------------------------------------------------}
end.
