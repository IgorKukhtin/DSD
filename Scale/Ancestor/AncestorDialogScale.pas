unit AncestorDialogScale;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,Db;

type
  TAncestorDialogScaleForm = class(TForm)
    bbPanel: TPanel;
    bbOk: TBitBtn;
    bbCancel: TBitBtn;
    procedure bbOkClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  protected
    function Checked: boolean; virtual;//Проверка корректного ввода в Edit
  public
    function Execute: boolean; virtual;
  end;

implementation
{$R *.dfm}
{------------------------------------------------------------------------------}
function TAncestorDialogScaleForm.Execute: boolean;
begin
     result:=(ShowModal=mrOk);
end;
{------------------------------------------------------------------------------}
function TAncestorDialogScaleForm.Checked;
begin result:=false;end;
{------------------------------------------------------------------------------}
procedure TAncestorDialogScaleForm.bbOkClick(Sender: TObject);
begin if Checked
then ModalResult:=mrOk;
end;
{------------------------------------------------------------------------------}
procedure TAncestorDialogScaleForm.FormResize(Sender: TObject);
begin
 bbOk.Top:=(bbPanel.Height-bbOk.Height) div 2;
 bbCancel.Top:=bbOk.Top;
 bbOK.Left:=((bbPanel.Width div 2)*9) div 10 -bbOK.width;
 if bbOK.Visible
 then bbCancel.Left:=((bbPanel.Width div 2)*11)div 10
 else bbCancel.Left:=(bbPanel.Width div 2)-(bbCancel.Width div 2);
end;
{------------------------------------------------------------------------------}

end.
