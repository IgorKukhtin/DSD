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
    fIsPartionGoods :Boolean;
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute (isPartionGoods, isHide :Boolean): boolean;
  end;

var
   DialogStringValueForm: TDialogStringValueForm;

implementation
uses UtilScale;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogStringValueForm.Execute(isPartionGoods, isHide :Boolean): boolean;
begin
     fIsPartionGoods:=isPartionGoods;
     //
     if isHide = true
     then begin StringValueEdit.Text:='';StringValueEdit.PasswordChar:='*';LabelStringValue.Caption:='Пароль для подтверждения'; end
     else StringValueEdit.PasswordChar:=#0;
     //
     ActiveControl:=StringValueEdit;
     //
     result:=(ShowModal=mrOk);
end;
{------------------------------------------------------------------------------}
function TDialogStringValueForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     if fIsPartionGoods = true
     then Result:=Recalc_PartionGoods(StringValueEdit)
     else Result:=true;
end;
{------------------------------------------------------------------------------}
end.
