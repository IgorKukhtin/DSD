unit DialogMsg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Mask, Buttons,
  ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxCurrencyEdit, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons;

type
  TDialogMsgForm = class(TAncestorDialogScaleForm)
    PanelMsg: TPanel;
    MemoMsg: TMemo;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute (inMsg1, inMsg2, inMsg3 :String): boolean;
  end;

var
   DialogMsgForm: TDialogMsgForm;

implementation
uses UtilScale, DMMainScale;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogMsgForm.Execute(inMsg1, inMsg2, inMsg3 :String): boolean;
begin
     MemoMsg.Lines.Clear;
     if inMsg1 <> '' then MemoMsg.Lines.Add(inMsg1);
     if inMsg2 <> '' then MemoMsg.Lines.Add(inMsg2);
     if inMsg3 <> '' then MemoMsg.Lines.Add(inMsg3);
     //
     ActiveControl:= bbCancel;
     result:=(ShowModal=mrOk);
end;
{------------------------------------------------------------------------------}
procedure TDialogMsgForm.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin
  inherited;
  CanClose:= true;
end;
{------------------------------------------------------------------------------}
function TDialogMsgForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:= true;
end;
{------------------------------------------------------------------------------}
end.
