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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  protected
    FormParams: TParams;
    function Checked: boolean; virtual;//Проверка корректного ввода в Edit
    procedure CreateFormParams;virtual;//
    procedure WriteFormParams(execFormParams: TParams); virtual;//
    procedure SetFormParams(execFormParams: TParams); virtual;//
  public
    function Execute(execFormParams: TParams): boolean; virtual;
  end;

implementation
{$R *.dfm}
{------------------------------------------------------------------------------}
function TAncestorDialogForm.Execute(execFormParams: TParams): boolean;
begin WriteFormParams(execFormParams);
      result:=(ShowModal=mrOk);
      if result then SetFormParams(execFormParams)
end;
{------------------------------------------------------------------------------}
procedure TAncestorDialogForm.CreateFormParams;
begin FormParams:=nil;end;
{------------------------------------------------------------------------------}
procedure TAncestorDialogForm.WriteFormParams(execFormParams: TParams);
begin end;
{------------------------------------------------------------------------------}
procedure TAncestorDialogForm.SetFormParams(execFormParams: TParams);
begin end;
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
procedure TAncestorDialogForm.FormCreate(Sender: TObject);
begin CreateFormParams;end;
{------------------------------------------------------------------------------}
procedure TAncestorDialogForm.FormDestroy(Sender: TObject);
begin if Assigned(FormParams)then FormParams.Free;end;
{------------------------------------------------------------------------------}
end.
