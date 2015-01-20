unit AncestorDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,Db;

type
  TAncestorDialogForm = class(TForm)
    BottomPanel: TPanel;
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
function TAncestorDialogForm.Execute: boolean;
begin
     result:=(ShowModal=mrOk);
end;
{------------------------------------------------------------------------------}
function TAncestorDialogForm.Checked;
begin result:=false;end;
{------------------------------------------------------------------------------}
procedure TAncestorDialogForm.bbOkClick(Sender: TObject);
begin if Checked then ModalResult:=mrOk;end;
{------------------------------------------------------------------------------}
procedure TAncestorDialogForm.FormResize(Sender: TObject);
begin
 bbOk.Top:=(BottomPanel.Height-bbOk.Height) div 2;
 bbCancel.Top:=bbOk.Top;
 bbOK.Left:=((BottomPanel.Width div 2)*9) div 10 -bbOK.width;
 if bbOK.Visible
 then bbCancel.Left:=((BottomPanel.Width div 2)*11)div 10
 else bbCancel.Left:=(BottomPanel.Width div 2)-(bbCancel.Width div 2);
end;
{------------------------------------------------------------------------------}

end.
