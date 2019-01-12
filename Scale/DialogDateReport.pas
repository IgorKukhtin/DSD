unit DialogDateReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Mask, Buttons,
  ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxCurrencyEdit, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons, Vcl.ComCtrls, dxCore, cxDateUtils, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxLabel, cxCheckBox;

type
  TDialogDateReportForm = class(TAncestorDialogScaleForm)
    PanelDateValue: TPanel;
    deStart: TcxDateEdit;
    cbGoodsKind: TcxCheckBox;
    cbPartionGoods: TcxCheckBox;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    deEnd: TcxDateEdit;
    LabelValue: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    isPartionGoodsDate:Boolean;
  end;

var
   DialogDateReportForm: TDialogDateReportForm;

implementation
uses UtilScale;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogDateReportForm.Checked: boolean; //Проверка корректного ввода в Edit
var tmpValue1, tmpValue2 :TDateTime;
begin
     try
        tmpValue1 := StrToDate(deStart.Text)
     except
        Result:=false;
        exit;
     end;
     try
        tmpValue2 := StrToDate(deEnd.Text)
     except
        Result:=false;
        exit;
     end;
     //
     if (tmpValue1>tmpValue2) then
     begin
          ShowMessage('Неверно установлена начальная дата. Не может быть позже <'+DateToStr(tmpValue1)+'>.');
          Result:=false;
          exit;
     end;
     //
     Result:=true;
end;
{------------------------------------------------------------------------------}
procedure TDialogDateReportForm.FormCreate(Sender: TObject);
begin
  inherited;
  deStart.Text:= DateToStr(now);
  deEnd.Text:= DateToStr(now);
end;

end.
