unit DialogGoodsSeparate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Mask, Buttons,
  ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxCurrencyEdit, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons, Vcl.ComCtrls, dxCore, cxDateUtils, cxCheckBox,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, Data.DB;

type
  TDialogGoodsSeparateForm = class(TAncestorDialogScaleForm)
    PanelValue: TPanel;
    NullPanel: TPanel;
    infoMsgPanel: TPanel;
    PartionLabel: TcxLabel;
    GoodsLabel: TcxLabel;
    OBPanel: TPanel;
    MOPanel: TPanel;
    cbNull: TCheckBox;
    cbOB: TCheckBox;
    cbMO: TCheckBox;
    PRPanel: TPanel;
    cbPR: TCheckBox;
    NullEdit: TcxCurrencyEdit;
    MOEdit: TcxCurrencyEdit;
    OBEdit: TcxCurrencyEdit;
    PREdit: TcxCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure cbNullClick(Sender: TObject);
    procedure cbMOClick(Sender: TObject);
    procedure cbOBClick(Sender: TObject);
    procedure cbPRClick(Sender: TObject);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute (inGoodsId, inGoodsCode : Integer; inGoodsName, inPartionGoods : String; TotalCount : Double; OperDate : TDateTime): Boolean; virtual;
  end;

var
   DialogGoodsSeparateForm: TDialogGoodsSeparateForm;

implementation
{$R *.dfm}
uses MainCeh, UtilScale, dmMainScaleCeh;
{------------------------------------------------------------------------------}
function TDialogGoodsSeparateForm.Execute (inGoodsId, inGoodsCode : Integer; inGoodsName, inPartionGoods : String; TotalCount : Double; OperDate : TDateTime) : Boolean;
begin
      //
      GoodsLabel.Caption:= ' Товар : ('+IntToStr(inGoodsCode)+') ' + inGoodsName + ' / ' + DateToStr(OperDate);
      PartionLabel.Caption:= ' Партия : <'+inPartionGoods+'> / ' + FormatFloat(fmtWeight, TotalCount);
      //
      Result:= inherited Execute;
      //
end;
{------------------------------------------------------------------------------}
procedure TDialogGoodsSeparateForm.FormCreate(Sender: TObject);
begin
  inherited;
  //
end;
{------------------------------------------------------------------------------}
procedure TDialogGoodsSeparateForm.cbNullClick(Sender: TObject);
begin
  cbMO.Checked:= false;
  cbOB.Checked:= false;
  cbPR.Checked:= false;
end;
{------------------------------------------------------------------------------}
procedure TDialogGoodsSeparateForm.cbMOClick(Sender: TObject);
begin
  cbNull.Checked:= false;
  cbOB.Checked:= false;
  cbPR.Checked:= false;
end;
{------------------------------------------------------------------------------}
procedure TDialogGoodsSeparateForm.cbOBClick(Sender: TObject);
begin
  cbNull.Checked:= false;
  cbMO.Checked:= false;
  cbPR.Checked:= false;
end;
{------------------------------------------------------------------------------}
procedure TDialogGoodsSeparateForm.cbPRClick(Sender: TObject);
begin
  inherited;
  cbNull.Checked:= false;
  cbMO.Checked:= false;
  cbOB.Checked:= false;
end;
{------------------------------------------------------------------------------}
function TDialogGoodsSeparateForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:= true;
     // если все ОК - вернули новые параметры
     //if Result = TRUE then CopyValuesParamsFrom(ParamsLight_local,ParamsLight);
end;
{------------------------------------------------------------------------------}
end.
