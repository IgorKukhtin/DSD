unit DialogMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Buttons, ExtCtrls,DB;

type
  TDialogMessageForm = class(TAncestorDialogScaleForm)
    MemoMessage: TMemo;
    Timer1: TTimer;
    PanelTime: TPanel;
    procedure Timer1Timer(Sender: TObject);
  private
    fIsOk:boolean;
    saveDateTime:TDateTime;
    diffDateTime_sec:Integer;
    function Checked: boolean; override;
  public
    function Execute: boolean; override;
  end;

var
  DialogMessageForm: TDialogMessageForm;

implementation
uses DateUtils,UtilScale;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogMessageForm.Execute: boolean;
begin
     saveDateTime:=now;
     try diffDateTime_sec:=StrToInt(GetArrayList_Value_byName(Service_Array,'SecondBeforeComplete')); except Result:=true;end;
     PanelTime.Caption:=' �������� '+IntToStr(diffDateTime_sec)+' ���.';
     fIsOk:=false;
     //
     MemoMessage.Lines.Clear;
     MemoMessage.Lines.Add('����� �� <'+DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime)+'>');
     MemoMessage.Lines.Add(ParamsMovement.ParamByName('MovementDescName_master').asString);
     MemoMessage.Lines.Add('������������� ��������� ����������� � ������������ ��������?');
     //
     ActiveControl:=bbOk;
     //ActiveControl:=bbCancel;
     Result:=inherited Execute;
end;
{------------------------------------------------------------------------------}
function TDialogMessageForm.Checked;
begin
     fIsOk:=true;
     Result:= SecondOf(now-saveDateTime)>diffDateTime_sec;
end;
{------------------------------------------------------------------------------}
procedure TDialogMessageForm.Timer1Timer(Sender: TObject);
var calcSec:Integer;
begin
     calcSec:= diffDateTime_sec-SecondOf(now-saveDateTime);
     if calcSec>0 then PanelTime.Caption:=' �������� '+IntToStr(calcSec)+' ���.'
                  else PanelTime.Caption:=' �������� 0 ���.';
     //
     if (calcSec<=0)and(fIsOk) then ModalResult:=mrOk;
end;
{------------------------------------------------------------------------------}
end.
