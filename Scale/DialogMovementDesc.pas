unit DialogMovementDesc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  AncestorDialog, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.Components, dsdAddOn, Data.FMTBcd,
  Data.SqlExpr;

type
  TDialogMovementDescForm = class(TAncestorDialogForm)
    gbPartnerAll: TGroupBox;
    PanelPartner: TPanel;
    gbPartnerCode: TGroupBox;
    EditPartnerCode: TEdit;
    gbPartnerName: TGroupBox;
    PanelPartnerName: TPanel;
    gbGrid: TGroupBox;
    CDS: TClientDataSet;
    DataSource: TDataSource;
    spSelect: TdsdStoredProc;
    DBGrid: TDBGrid;
    procedure bbOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditPartnerCodeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridCellClick(Column: TColumn);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    ChoiceNumber:Integer;
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute: boolean; override;
  end;

var
  DialogMovementDescForm: TDialogMovementDescForm;

implementation
{$R *.dfm}
uses UtilScale,Main,dmMainTest;
{------------------------------------------------------------------------}
function TDialogMovementDescForm.Execute: boolean; //Проверка корректного ввода в Edit
begin
     CDS.Locate('Number',GetArrayList_Value_byName(Default_Array,'MovementNumber'),[]);
     ActiveControl:=EditPartnerCode;
     ChoiceNumber:=0;

{  if CurSetting.PartnerCode<>0 then
  EditPartnerCode.Text := IntToStr(CurSetting.PartnerCode)
  else EditPartnerCode.Text:='';
  PanelPartnerName.Caption := CurSetting.PartnerName;

  if CurSetting.RouteSortingId<>0 then
  EditRouteUnitCode.Text := IntToStr(CurSetting.RouteSortingCode)
  else EditRouteUnitCode.Text:='';
  PanelRouteUnitName.Caption := CurSetting.RouteSortingName;

  if CurSetting.PriceListId<>0 then
  EditPriceListCode.Text := IntToStr(CurSetting.PriceListCode)
  else EditPriceListCode.Text:='';
  PanelPriceListName.Caption := CurSetting.PriceListName;
}

     result:=(ShowModal=mrOk);
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
 SettingMovement.ColorGridValue:= CDS.FieldByName('ColorGridValue').asString;

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
     then if (ActiveControl=EditPartnerCode)
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
