unit DialogDateValue;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Mask, Buttons,
  ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxCurrencyEdit, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons, Vcl.ComCtrls, dxCore, cxDateUtils, cxMaskEdit,
  cxDropDownEdit, cxCalendar;

type
  TDialogDateValueForm = class(TAncestorDialogScaleForm)
    PanelDateValue: TPanel;
    LabelDateValue: TLabel;
    DateValueEdit: TcxDateEdit;
  private
    function Checked: boolean; override;//�������� ����������� ����� � Edit
  public
    isPartionGoodsDate:Boolean;
  end;

var
   DialogDateValueForm: TDialogDateValueForm;

implementation
uses UtilScale;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogDateValueForm.Checked: boolean; //�������� ����������� ����� � Edit
var tmpValue:TDateTime;
begin
     try
        tmpValue := StrToDate(DateValueEdit.Text)
     except
        Result:=false;
        exit;
     end;
     //
     if isPartionGoodsDate = true
     then begin
          if (tmpValue>ParamsMovement.ParamByName('OperDate').AsDateTime) then
          begin
               ShowMessage('������� ����������� ����. �� ����� ���� ����� <'+DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime)+'>.');
               Result:=false;
               exit;
          end;
          if (tmpValue<ParamsMovement.ParamByName('OperDate').AsDateTime - StrToInt(GetArrayList_Value_byName(Default_Array,'PeriodPartionGoodsDate'))) then
          begin
               ShowMessage('������� ����������� ����. �� ����� ���� ������ <'+DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime)+'>.');
               Result:=false;
               exit;
          end;
     end;
     //
     Result:=true;
end;
{------------------------------------------------------------------------------}
end.
