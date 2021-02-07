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
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    fPSW :Boolean;
    fIsHide :Boolean;
    fIsPartionGoods :Boolean;
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute (isPartionGoods, isHide :Boolean): boolean;
  end;

var
   DialogStringValueForm: TDialogStringValueForm;

implementation
uses UtilScale, DMMainScale;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogStringValueForm.Execute(isPartionGoods, isHide :Boolean): boolean;
begin
     fIsPartionGoods:=isPartionGoods;
     fIsHide:=isHide;
     fPSW:=false;
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
procedure TDialogStringValueForm.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin
  inherited;
  CanClose:= (fIsHide = false) or (fPSW = true);
end;
{------------------------------------------------------------------------------}
function TDialogStringValueForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     if  fIsHide = true
     then begin
               Result:= false;
               fPSW:= false;
               if DMMainScaleForm.gpGet_Scale_PSW_delete (StringValueEdit.Text) <> ''
               then begin ShowMessage ('Пароль неверный.Повторите Ввод.');exit;end;
               Result:= true;
               fPSW:= true;
     end
     else
     if fIsPartionGoods = true
     then Result:=Recalc_PartionGoods(StringValueEdit)
     else begin
          //Result:=trim(StringValueEdit.Text)<>'';
          //if not Result
          //then begin ShowMessage ('Значение не введено.');exit;end;
            Result:=true;
     end;
end;
{------------------------------------------------------------------------------}
end.
