unit DialogStringValue;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Mask, Buttons,
  ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxCurrencyEdit, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons;

type
  TDialogStringValueForm = class(TAncestorDialogScaleForm)
    PanelStringValue: TPanel;
    LabelStringValue: TLabel;
    StringValueEdit: TEdit;
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    isPartionGoods:Boolean;
  end;

var
   DialogStringValueForm: TDialogStringValueForm;

implementation
uses UtilScale;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogStringValueForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     if isPartionGoods = true
     then Result:=Recalc_PartionGoods(StringValueEdit)
     else Result:=true;
end;
{------------------------------------------------------------------------------}
end.
