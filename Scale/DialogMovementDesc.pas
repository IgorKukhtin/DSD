unit DialogMovementDesc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  AncestorDialog, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.Components, dsdAddOn, Data.FMTBcd,
  Data.SqlExpr, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, dxSkinsCore, dxSkinsDefaultPainters, cxTextEdit,
  cxMaskEdit, cxButtonEdit
, UtilScale;

type
  TDialogMovementDescForm = class(TAncestorDialogForm)
    CDS: TClientDataSet;
    DataSource: TDataSource;
    spSelect: TdsdStoredProc;
    InfoPanel: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label2: TLabel;
    Panel4: TPanel;
    Label3: TLabel;
    PanelPartnerName: TPanel;
    Panel5: TPanel;
    ScaleLabel: TLabel;
    EdiBarCode: TEdit;
    Panel6: TPanel;
    DBGrid: TDBGrid;
    EditPartnerCode: TcxButtonEdit;
    Label4: TLabel;
    procedure bbOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditPartnerCodeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridCellClick(Column: TColumn);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdiBarCodeExit(Sender: TObject);
    procedure EdiBarCodeChange(Sender: TObject);

  private
    ChoiceNumber:Integer;

    IsOrderExternal: Boolean;
    SettingMovement_local: TSettingMovement;

    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute: boolean; override;
  end;

var
  DialogMovementDescForm: TDialogMovementDescForm;

implementation
{$R *.dfm}
uses Main,DMMainScale;
{------------------------------------------------------------------------}
function TDialogMovementDescForm.Execute: Boolean; //Проверка корректного ввода в Edit
begin
     ChoiceNumber:=0;
     CDS.Locate('Number',GetArrayList_Value_byName(Default_Array,'MovementNumber'),[]);
     CDS.Filtered:=false;

     if SettingMovement.OrderExternal_BarCode<>''
     then EdiBarCode.Text:=SettingMovement.OrderExternal_BarCode
     else EdiBarCode.Text:=SettingMovement.OrderExternal_InvNumber;

     EditPartnerCode.Text:= IntToStr(SettingMovement.calcPartnerCode);

     ActiveControl:=EdiBarCode;
     Result:=(ShowModal=mrOk);
end;
{------------------------------------------------------------------------}
function TDialogMovementDescForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=True;
//     spData.fi
//     SQLQuery1.FieldByName()
end;
{------------------------------------------------------------------------}
procedure TDialogMovementDescForm.bbOkClick(Sender: TObject);
begin
 inherited;

 if CDS.FieldByName('MovementDescId').AsInteger=0 then exit;
// EditPartnerCodeExit(Sender);
// EditRouteUnitCodeExit(Sender);
// EditPartnerCodeExit(Sender);
      if ActiveControl=EditPartnerCode then EditPartnerCodeExit(Sender);

   MyDelay(700);

// ShowMessage(CDS.FieldByName('DisplayName').asString);
 // SettingMain.ToolsCode:= CDS.FieldByName('Code').asInteger;
 SettingMovement.MovementDescId:= CDS.FieldByName('MovementDescId').asInteger;
 SettingMovement.FromId:= CDS.FieldByName('FromId').asInteger;
 SettingMovement.FromName:= CDS.FieldByName('FromName').asString;
 SettingMovement.ToId:= CDS.FieldByName('ToId').asInteger;
 SettingMovement.ToName:= CDS.FieldByName('ToName').asString;
 SettingMovement.PaidKindId:= CDS.FieldByName('PaidKindId').asInteger;
 SettingMovement.PaidKindName:= CDS.FieldByName('PaidKindName').asString;
 SettingMovement.ColorGridValue:= CDS.FieldByName('ColorGridValue').asInteger;

 SettingMovement.OrderExternalId         := SettingMovement_local.OrderExternalId;
 SettingMovement.OrderExternal_BarCode   := SettingMovement_local.OrderExternal_BarCode;
 SettingMovement.OrderExternal_InvNumber := SettingMovement_local.OrderExternal_InvNumber;


end;
{------------------------------------------------------------------------}
procedure TDialogMovementDescForm.DBGridCellClick(Column: TColumn);
begin
     if (CDS.FieldByName('MovementDescId').AsInteger=0)
     then CDS.Next
     else begin
               ChoiceNumber:=CDS.FieldByName('Number').AsInteger;
               //DBGrid.Refresh;
               DBGrid.Repaint;
               bbOkClick(Self);
     end;
end;
{------------------------------------------------------------------------}
procedure TDialogMovementDescForm.DBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
     if (gdSelected in State)and(ChoiceNumber=0) then exit;

     //if ChoiceNumber <> 0 then ShowMessage (CDS.FieldByName('Number').AsString);

     with (Sender as TDBGrid).Canvas do
     if CDS.FieldByName('MovementDescId').AsInteger=0 then
     begin
          Font.Color:=clNavy;
          Font.Size:=11;
          Font.Style:=[fsBold];
          FillRect(Rect);
          TextOut(Rect.Left + 30, Rect.Top + 0, Column.Field.Text);
     end
     else
     if CDS.FieldByName('Number').AsInteger=ChoiceNumber then
     begin
          Font.Color:=clBlue;
          Font.Size:=10;
          Font.Style:=[];
          FillRect(Rect);
          TextOut(Rect.Left + 2, Rect.Top + 2, Column.Field.Text);
     end
     else
     begin
          Font.Color:=clBlack;
          Font.Size:=10;
          Font.Style:=[];
          FillRect(Rect);
          TextOut(Rect.Left + 5, Rect.Top + 0, Column.Field.Text);
     end;
end;
{------------------------------------------------------------------------}
procedure TDialogMovementDescForm.EdiBarCodeChange(Sender: TObject);
begin
    if Length(trim(EdiBarCode.Text))>=13 then EdiBarCodeExit(Self);
end;
{------------------------------------------------------------------------}
procedure TDialogMovementDescForm.EdiBarCodeExit(Sender: TObject);
begin
    if Length(trim(EdiBarCode.Text))>0
    then begin
              //поиск по номеру или ш-к
              isOrderExternal:=DMMainScaleForm.gpSelect_Scale_OrderExternal(SettingMovement_local,SettingMovement.OperDate,EdiBarCode.Text);
              if isOrderExternal=false then
              begin
                   ShowMessage('Ошибка.Значение <Штрих код/Номер заявки> не найдено.');
                   ActiveControl:=EdiBarCode;
                   exit;
              end;
    end
    else begin //обнуление
               isOrderExternal:=true;
               SettingMovement_local.OrderExternalId:=0;
               SettingMovement_local.OrderExternal_BarCode:='';
               SettingMovement_local.OrderExternal_InvNumber:='';
          end;
    //
    if SettingMovement_local.OrderExternal_BarCode<>''
    then begin
              CDS.Filter:='MovementDescId='+IntToStr(SettingMovement_local.MovementDescId)
                    +' and PaidKindId='+IntToStr(SettingMovement_local.PaidKindId)
                    //+' and FromId='+IntToStr(SettingMovement_local.FromId)
                    ;
              CDS.Filtered:=true;
              if CDS.RecordCount<>1 then
              begin
                   ShowMessage('Ошибка.Значение <Вид документа> не определено.');
                   ActiveControl:=EdiBarCode;
                   isOrderExternal:=false;
                   exit;
              end;
              // завершение
              DBGridCellClick(DBGrid.Columns[0]);
         end;
end;
{------------------------------------------------------------------------}
procedure TDialogMovementDescForm.EditPartnerCodeExit(Sender: TObject);
var
 PartnerObject: TDBObject;
begin
  inherited;
{     try NewSetting.PartnerCode:=StrToInt(trim(EditPartnerCode.Text));except NewSetting.PartnerCode:=0;end;
     PartnerObject := GetObject_byCode(NewSetting.PartnerCode, 30);
     PanelPartnerName.Caption := PartnerObject.Name;
     NewSetting.PartnerId := PartnerObject.Id;
     NewSetting.PartnerName := PartnerObject.Name;
     NewSetting.PartnerCode := PartnerObject.Code;
//     try RouteUnitCode:=StrToInt(trim(EditRouteUnitCode.Text));except RouteUnitCode:=0;end;
}
end;
{------------------------------------------------------------------------}
procedure TDialogMovementDescForm.FormCreate(Sender: TObject);
begin
  inherited;
  spSelect.Params.AddParam('inScaleNum', ftInteger, ptInput, SettingMain.ScaleNum);
  spSelect.Execute;
  bbOk.Visible := false;
end;
{------------------------------------------------------------------------}
procedure TDialogMovementDescForm.FormKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
     if Key = VK_RETURN
     then if (ActiveControl=EdiBarCode)
          then ActiveControl:=EditPartnerCode
          else if (ActiveControl=EditPartnerCode)
               then ActiveControl:=DBGrid
               else if (ActiveControl=DBGrid)
                    then DBGridCellClick(DBGrid.Columns[0]);
end;
{------------------------------------------------------------------------}
procedure TDialogMovementDescForm.FormKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if (Key = VK_UP)or(Key = VK_DOWN)or(Key = VK_HOME)or(Key = VK_END)or(Key = VK_PRIOR)or(Key = VK_NEXT)
     then if (CDS.FieldByName('MovementDescId').AsInteger=0)
          then CDS.Next;
end;
{------------------------------------------------------------------------}
end.
