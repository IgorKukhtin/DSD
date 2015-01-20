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
    procedure FormCreate(Sender: TObject);
    procedure EditPartnerCodeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridCellClick(Column: TColumn);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdiBarCodeExit(Sender: TObject);
    procedure EdiBarCodeChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    ChoiceNumber:Integer;

    IsOrderExternal,IsPartnerCode: Boolean;
    ParamsMovement_local: TParams;

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
     CopyValuesParamsFrom(ParamsMovement,ParamsMovement_local);

     IsOrderExternal:=false;
     IsPartnerCode:=false;
     CDS.Filtered:=false;

     ChoiceNumber:=0;
     with ParamsMovement_local do
     begin
          CDS.Locate('Number',ParamByName('MovementNumber').AsString,[]);
          if ParamByName('OrderExternal_BarCode').AsString<>''
          then EdiBarCode.Text:=ParamByName('OrderExternal_BarCode').AsString
          else EdiBarCode.Text:=ParamByName('OrderExternal_InvNumber').AsString;

          EditPartnerCode.Text:= IntToStr(ParamByName('calcPartnerCode').AsInteger);
          PanelPartnerName.Caption:= ParamByName('calcPartnerName').AsString;
     end;

     ActiveControl:=EdiBarCode;
     Result:=(ShowModal=mrOk);
end;
{------------------------------------------------------------------------}
function TDialogMovementDescForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     if ActiveControl=EditPartnerCode then EditPartnerCodeExit(Self);
     if ActiveControl=EditPartnerCode then EditPartnerCodeExit(Self);

     Result:=(IsOrderExternal=true);//and(IsPartnerCode=true);
     if not Result then exit;


     if CDS.FieldByName('MovementDescId').AsInteger=0 then exit;

     with ParamsMovement_local do
     begin
          ParamByName('ColorGridValue').AsInteger:=CDS.FieldByName('ColorGridValue').asInteger;
          ParamByName('MovementNumber').AsInteger:= CDS.FieldByName('Number').asInteger;
          ParamByName('MovementDescId').AsInteger:= CDS.FieldByName('MovementDescId').asInteger;

          if  (CDS.FieldByName('MovementDescId').asInteger <> zc_Movement_ReturnIn)
           and(CDS.FieldByName('MovementDescId').asInteger <> zc_Movement_Income)
          then begin
          ParamByName('FromId').AsInteger:= CDS.FieldByName('FromId').asInteger;
          ParamByName('FromName').asString:= CDS.FieldByName('FromName').asString;
          end;

          if  (CDS.FieldByName('MovementDescId').asInteger <> zc_Movement_Sale)
           and(CDS.FieldByName('MovementDescId').asInteger <> zc_Movement_ReturnOut)
          then begin
          ParamByName('ToId').AsInteger:= CDS.FieldByName('ToId').asInteger;
          ParamByName('ToName').asString:= CDS.FieldByName('ToName').asString;
          end;

          ParamByName('PaidKindId').AsInteger:= CDS.FieldByName('PaidKindId').asInteger;
          ParamByName('PaidKindName').asString:= CDS.FieldByName('PaidKindName').asString;
    end;

    CopyValuesParamsFrom(ParamsMovement_local,ParamsMovement);

    MyDelay(700);
end;
{------------------------------------------------------------------------}
procedure TDialogMovementDescForm.EdiBarCodeExit(Sender: TObject);
begin
    if Length(trim(EdiBarCode.Text))>0
    then begin
              //поиск по номеру или ш-к
              isOrderExternal:=DMMainScaleForm.gpSelect_Scale_OrderExternal(ParamsMovement_local,EdiBarCode.Text);
              if isOrderExternal=false then
              begin
                   ShowMessage('Ошибка.Значение <Штрих код/Номер заявки> не найдено.');
                   ActiveControl:=EdiBarCode;
                   exit;
              end
              else begin
                        EditPartnerCode.Text:= IntToStr(ParamsMovement_local.ParamByName('calcPartnerCode').AsInteger);
                        PanelPartnerName.Caption:= ParamsMovement_local.ParamByName('calcPartnerName').asString;
                   end;
    end
    else begin //обнуление
               isOrderExternal:=true;
               ParamsMovement_local.ParamByName('OrderExternalId').AsInteger:=0;
               ParamsMovement_local.ParamByName('OrderExternal_BarCode').asString :='';
               ParamsMovement_local.ParamByName('OrderExternal_InvNumber').asString :='';
          end;
    //
    if ParamsMovement_local.ParamByName('OrderExternal_BarCode').asString<>''
    then begin
              CDS.Filter:='MovementDescId='+IntToStr(ParamsMovement_local.ParamByName('MovementDescId').asInteger)
                    +' and PaidKindId='+IntToStr(ParamsMovement_local.ParamByName('PaidKindId').asInteger)
                    //+' and FromId='+IntToStr(ParamsMovement_local.ParamByName('FromId').asInteger)
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
              ActiveControl:=DBGrid;
              DBGridCellClick(DBGrid.Columns[0]);
         end;
end;
{------------------------------------------------------------------------}
procedure TDialogMovementDescForm.EdiBarCodeChange(Sender: TObject);
begin
    if Length(trim(EdiBarCode.Text))>=13 then EdiBarCodeExit(Self);
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
procedure TDialogMovementDescForm.DBGridCellClick(Column: TColumn);
begin
     if (CDS.FieldByName('MovementDescId').AsInteger=0)
     then CDS.Next
     else begin
               ChoiceNumber:=CDS.FieldByName('Number').AsInteger;
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
procedure TDialogMovementDescForm.FormCreate(Sender: TObject);
begin
  inherited;
  spSelect.Params.AddParam('inScaleNum', ftInteger, ptInput, SettingMain.ScaleNum);
  spSelect.Execute;
  //
  Create_ParamsMovement(ParamsMovement_local);
  //
  bbOk.Visible := false;
end;
{------------------------------------------------------------------------}
procedure TDialogMovementDescForm.FormDestroy(Sender: TObject);
begin
  ParamsMovement_local.Free;
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
