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
    PPanel: TPanel;
    cbP: TCheckBox;
    MOEdit: TcxTextEdit;
    NullEdit: TcxTextEdit;
    OBEdit: TcxTextEdit;
    PREdit: TcxTextEdit;
    PEdit: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure cbNullClick(Sender: TObject);
    procedure cbMOClick(Sender: TObject);
    procedure cbOBClick(Sender: TObject);
    procedure cbPRClick(Sender: TObject);
    procedure cbPClick(Sender: TObject);
  private
    lTotalCount_in, lTotalCount_null, lTotalCount_MO, lTotalCount_OB, lTotalCount_PR, lTotalCount_P : Double;
    lHeadCount_in, lHeadCount_null, lHeadCount_MO, lHeadCount_OB, lHeadCount_PR, lHeadCount_P : Double;
    lPartionGoods, lPartionGoods_null, lPartionGoods_MO, lPartionGoods_OB, lPartionGoods_PR, lPartionGoods_P : String;
    lOperDate : TDateTime;
    lGoodsId : Integer;
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute (inOperDate : TDateTime; inMovementId, inGoodsId, inGoodsCode : Integer; inGoodsName, inPartionGoods : String): Boolean; virtual;
  end;

var
   DialogGoodsSeparateForm: TDialogGoodsSeparateForm;

implementation
{$R *.dfm}
uses MainCeh, UtilScale, dmMainScaleCeh, UtilPrint;
{------------------------------------------------------------------------------}
function TDialogGoodsSeparateForm.Execute (inOperDate : TDateTime; inMovementId, inGoodsId, inGoodsCode : Integer; inGoodsName, inPartionGoods : String) : Boolean;
var tmpTotalCount_in, tmpHeadCount_in : Double;
begin
      Result:= false;
      //
      lOperDate    :=inOperDate;
      lPartionGoods:= inPartionGoods;
      lGoodsId     :=inGoodsId;
      //
      if not DMMainScaleCehForm.gpGet_ScaleCeh_GoodsSeparate(inOperDate, inMovementId, inGoodsId, inPartionGoods
                                                           , tmpTotalCount_in, lTotalCount_null, lTotalCount_MO, lTotalCount_OB, lTotalCount_PR, lTotalCount_P
                                                           , tmpHeadCount_in, lHeadCount_null, lHeadCount_MO, lHeadCount_OB, lHeadCount_PR, lHeadCount_P
                                                           , lPartionGoods_null, lPartionGoods_MO, lPartionGoods_OB, lPartionGoods_PR, lPartionGoods_P
                                                            )
      then exit;
      //
      if tmpTotalCount_in = 0 then
      begin
           ShowMessage('Ошибка. Для партии = <'+lPartionGoods+'> не найден приход за <'+DateToStr(lOperDate)+'>.');
           // exit;
      end;
      //
      lTotalCount_in:= tmpTotalCount_in - lTotalCount_null - lTotalCount_MO - lTotalCount_OB - lTotalCount_PR - lTotalCount_P;
      lHeadCount_in := tmpHeadCount_in - lHeadCount_null - lHeadCount_MO - lHeadCount_OB - lHeadCount_PR - lHeadCount_P;
      //
      NullEdit.Text:= '(' + FormatFloat(fmtHead, lHeadCount_null) + ') ' + FormatFloat(fmtWeight, lTotalCount_null);
      MOEdit.Text  := '(' + FormatFloat(fmtHead, lHeadCount_MO)   + ') ' + FormatFloat(fmtWeight, lTotalCount_MO);
      OBEdit.Text  := '(' + FormatFloat(fmtHead, lHeadCount_OB)   + ') ' + FormatFloat(fmtWeight, lTotalCount_OB);
      PREdit.Text  := '(' + FormatFloat(fmtHead, lHeadCount_PR)   + ') ' + FormatFloat(fmtWeight, lTotalCount_PR);
      PEdit.Text   := '(' + FormatFloat(fmtHead, lHeadCount_P)    + ') ' + FormatFloat(fmtWeight, lTotalCount_P);
      //
      cbNull.Checked:= false;
      cbMO.Checked:= false;
      cbOB.Checked:= false;
      cbPR.Checked:= false;
      cbP.Checked:= false;
      //
      GoodsLabel.Caption:= ' ('+IntToStr(inGoodsCode)+') ' + inGoodsName + ' за ' + DateToStr(inOperDate);
      PartionLabel.Caption:= ' Итого приход : ' + '(' + FormatFloat(fmtHead, tmpHeadCount_in) + ') ' + FormatFloat(fmtWeight, tmpTotalCount_in)
                  +'  /  формируется Расход : ' + '(' + FormatFloat(fmtHead, lHeadCount_in)   + ') ' + FormatFloat(fmtWeight, lTotalCount_in);
      //
      cbNull.Caption:= AnsiUpperCase(lPartionGoods_null);
      cbMO.Caption  := AnsiUpperCase(lPartionGoods_MO);
      cbOB.Caption  := AnsiUpperCase(lPartionGoods_OB);
      cbPR.Caption  := AnsiUpperCase(lPartionGoods_PR);
      cbP.Caption   := AnsiUpperCase(lPartionGoods_P);
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
  if cbNull.Checked = TRUE then
  begin
      cbMO.Checked:= false;
      cbOB.Checked:= false;
      cbPR.Checked:= false;
      cbP.Checked := false;
      //
      NullEdit.Text:= '(' + FormatFloat(fmtHead, lHeadCount_null) + ') ' + FormatFloat(fmtWeight, lTotalCount_null)
            + ' + ' + '(' + FormatFloat(fmtHead, lHeadCount_in)   + ') ' + FormatFloat(fmtWeight, lTotalCount_in);
  end
  else
      NullEdit.Text:= '(' + FormatFloat(fmtHead, lHeadCount_null) + ') ' + FormatFloat(fmtWeight, lTotalCount_null);
end;
{------------------------------------------------------------------------------}
procedure TDialogGoodsSeparateForm.cbMOClick(Sender: TObject);
begin
  if cbMO.Checked = TRUE then
  begin
      cbNull.Checked:= false;
      cbOB.Checked:= false;
      cbPR.Checked:= false;
      cbP.Checked := false;
      //
      MOEdit.Text:= '(' + FormatFloat(fmtHead, lHeadCount_MO) + ') ' + FormatFloat(fmtWeight, lTotalCount_MO)
          + ' + ' + '(' + FormatFloat(fmtHead, lHeadCount_in) + ') ' + FormatFloat(fmtWeight, lTotalCount_in);
  end
  else
      MOEdit.Text:= '(' + FormatFloat(fmtHead, lHeadCount_MO) + ') ' + FormatFloat(fmtWeight, lTotalCount_MO);
end;
{------------------------------------------------------------------------------}
procedure TDialogGoodsSeparateForm.cbOBClick(Sender: TObject);
begin
  if cbOB.Checked = TRUE then
  begin
      cbNull.Checked:= false;
      cbMO.Checked:= false;
      cbPR.Checked:= false;
      cbP.Checked := false;
      //
      OBEdit.Text:= '(' + FormatFloat(fmtHead, lHeadCount_OB) + ') ' + FormatFloat(fmtWeight, lTotalCount_OB)
          + ' + ' + '(' + FormatFloat(fmtHead, lHeadCount_in) + ') ' + FormatFloat(fmtWeight, lTotalCount_in);
  end
  else
      OBEdit.Text:= '(' + FormatFloat(fmtHead, lHeadCount_OB) + ') ' + FormatFloat(fmtWeight, lTotalCount_OB);
end;
{------------------------------------------------------------------------------}
procedure TDialogGoodsSeparateForm.cbPRClick(Sender: TObject);
begin
  if cbPR.Checked = TRUE then
  begin
      cbNull.Checked:= false;
      cbMO.Checked:= false;
      cbOB.Checked:= false;
      cbP.Checked := false;
      //
      PREdit.Text:= '(' + FormatFloat(fmtHead, lHeadCount_PR) + ') ' + FormatFloat(fmtWeight, lTotalCount_PR)
          + ' + ' + '(' + FormatFloat(fmtHead, lHeadCount_in) + ') ' + FormatFloat(fmtWeight, lTotalCount_in);
  end
  else
      PREdit.Text:= '(' + FormatFloat(fmtHead, lHeadCount_PR) + ') ' + FormatFloat(fmtWeight, lTotalCount_PR);
end;
{------------------------------------------------------------------------------}
procedure TDialogGoodsSeparateForm.cbPClick(Sender: TObject);
begin
  if cbP.Checked = TRUE then
  begin
      cbNull.Checked:= false;
      cbMO.Checked:= false;
      cbOB.Checked:= false;
      cbPR.Checked:= false;
      //
      PEdit.Text:= '(' + FormatFloat(fmtHead, lHeadCount_P)  + ') ' + FormatFloat(fmtWeight, lTotalCount_P)
         + ' + ' + '(' + FormatFloat(fmtHead, lHeadCount_in) + ') ' + FormatFloat(fmtWeight, lTotalCount_in);
  end
  else
      PEdit.Text:= '(' + FormatFloat(fmtHead, lHeadCount_P)  + ') ' + FormatFloat(fmtWeight, lTotalCount_P);
end;
{------------------------------------------------------------------------------}
function TDialogGoodsSeparateForm.Checked: boolean; //Проверка корректного ввода в Edit
var PartionGoods_calc : String;
    retMovementId_begin, retMovementId : Integer;
begin
     //
     Result:= lTotalCount_in > 0;
     if not Result then
     begin
          ShowMessage('Ошибка. Кол-во для формирования расхода = <'+FormatFloat(fmtWeight, lTotalCount_in)+'> не может быть <= 0.');
          exit;
     end;
     //
     //
     if cbNull.Checked = TRUE
     then PartionGoods_calc:= lPartionGoods_null
     else
     if cbMO.Checked = TRUE
     then PartionGoods_calc:= lPartionGoods_MO
     else
     if cbOB.Checked = TRUE
     then PartionGoods_calc:= lPartionGoods_OB
     else
     if cbPR.Checked = TRUE
     then PartionGoods_calc:= lPartionGoods_PR
     else
     if cbP.Checked = TRUE
     then PartionGoods_calc:= lPartionGoods_P
     else
     begin
          Result:=false;
          ShowMessage('Ошибка.Не выбрана категория для партии.');
          exit;
     end;
     //
     Result:= DMMainScaleCehForm.gpInsert_ScaleCeh_GoodsSeparate(retMovementId_begin, retMovementId, ParamsMovement, lOperDate, lGoodsId, PartionGoods_calc, lTotalCount_in, lHeadCount_in);
     if Result then
     begin
       Print_Movement (ParamsMovement.ParamByName('MovementDescId').AsInteger
                     , retMovementId_begin
                     , retMovementId
                     , 1    // myPrintCount
                     , TRUE // isPreview
                     , FALSE
                      );
     end;

end;
{------------------------------------------------------------------------------}
end.
